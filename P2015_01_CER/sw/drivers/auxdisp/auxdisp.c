#include <asm/io.h>
#include <asm/uaccess.h>
#include <linux/cdev.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/dma-mapping.h>
#include <linux/fs.h>
#include <linux/interrupt.h>
#include <linux/ioctl.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/of_platform.h>
#include <linux/semaphore.h>
#include <linux/slab.h>
#include <linux/string.h>
#include <linux/types.h>
#include <linux/wait.h>
#include <linux/dmaengine.h>
#include <linux/dma-mapping.h>
#include <linux/dmapool.h>
#include <linux/dma/xilinx_dma.h>
#include <linux/of_gpio.h>

#include "auxdisp.h"
#include "auxdisp_ioctl.h"

#define DRIVER_NAME "iit-auxdisp"
#define DTS_COMPATIBLE "iit,auxdisp-1.0"
#define RET_CLASS_NAME "Auxiliary Display"
#define RET_CTL_DEVNAME "auxdisp"
#define MAX_CHANNELS   1

#define MSG_PREFIX "IIT-auxdisp: "

#define set_register_bits(reg, v, mask) {								\
	int __ms = 0;														\
	typeof(mask) __mask = (mask);										\
	while(__mask > 0 && ! (__mask & 0x1)) {								\
		__mask = __mask >> 1;											\
		__ms++;															\
	}																	\
	iowrite32((ioread32(reg) & ~(mask)) | (((v) << __ms) & (mask)), (reg)); 	\
}

#define get_register_bits(reg, res, mask) {					\
	unsigned int __rmask = (mask);							\
	typeof(*(reg)) __reg = ioread32(reg);					\
															\
	while(__rmask > 0 && ! (__rmask & 0x1)) {				\
		__rmask = __rmask >> 1;								\
		__reg = __reg >> 1;									\
	}														\
															\
	res = __reg & __rmask;									\
}

static long auxdisp_ioctl(struct file *filp, unsigned int cmd, unsigned long param);
static long get_version(struct file *filp, unsigned int * version);
static long get_ctrl(struct file *filp, unsigned int * value);
static long set_fc(struct file *filp, uint48_t **FC);
static long set_reset(unsigned int val);
static irqreturn_t irq_handler(int irq, void *arg);
static ssize_t chardev_write(struct file *f, const char __user *buf, size_t len, loff_t *off);
void set_bpp(unsigned int val);
void get_bpp(unsigned int *val);
static int init_dma (void);

unsigned int input_picsize;

struct dev_support {
	int major, minor;
	struct cdev chdev;
	dev_t devt;
	void *base_addr;
	size_t mem_size;
	resource_size_t pm_start; //phisical memory start

	unsigned int irq;

	wait_queue_head_t wait;

    struct dma_chan                         *tx_dma_chan;
    dma_addr_t                              tx_dma_buf_phys;
    unsigned char                           *tx_dma_buf_virt;
    struct dma_async_tx_descriptor          *tx_dma_desc;
    unsigned long                           tx_tmo;
    struct completion                       tx_cmp;
    dma_cookie_t                            tx_cookie;
    unsigned int                            impl_numlines;
    unsigned int                            impl_numofchips;
    unsigned int                            impl_numofrows;
    unsigned int                            bpp_format;
    int done;
    int ready;
    unsigned char                           *writing_done;
    int                                     reset_auxdisp;
};

static struct class *ret_class;
static struct dev_support d_support;

static struct of_device_id auxdisp_of_match[] = {
        {
                .compatible     = DTS_COMPATIBLE,
        }, {
        },
};
MODULE_DEVICE_TABLE(of, auxdisp_of_match);

static void dmatest_slave_tx_callback(void *completion)
{
	complete(completion);
}

static int remove_dma (void) {
    
    dma_release_channel(d_support.tx_dma_chan);

    return 0;
}


static bool xdma_filter(struct dma_chan *chan, void *param)
{
	if (*((int *)chan->private) == *(int *)param)
		return true;

	return false;
}

static ssize_t chardev_read (struct file *fp, char *buf, size_t length, loff_t *offset) {
	printk(KERN_DEBUG MSG_PREFIX "Read\n");
	return 0;
}


// I know... this function could be written much better and most shared with chardev_write funcion...
static ssize_t black_screen (void) {
    int status;
    unsigned long time_left;
	enum dma_ctrl_flags flags;
    uint32_t *intmsk_reg  = d_support.base_addr + AUXDISP_INTMSK;
	uint32_t *ctrl_reg = d_support.base_addr + AUXDISP_CTRL;
    unsigned int length = NUM_CHIPS_PER_ROW*16*d_support.bpp_format*NUM_ROWS*LINES_PER_ROW;
    unsigned char *buffer = kzalloc(length, GFP_KERNEL);
    
    if (length==0)
        return 0;

    init_dma();

    memcpy(d_support.tx_dma_buf_virt, buffer, length);

    flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT ;
    d_support.tx_dma_desc=dmaengine_prep_slave_single(d_support.tx_dma_chan, d_support.tx_dma_buf_phys, length, DMA_MEM_TO_DEV, flags);
    
    // Enable VSYNC interrupt
	set_register_bits(intmsk_reg, DISABLE, AUXDISP_INT_FC);
	set_register_bits(intmsk_reg, ENABLE, AUXDISP_INT_ENDVSYNC);
    // Enable the IP
    set_register_bits(ctrl_reg,   AUXDISP_CTRL_IE | (AUXDISP_CTRL_CMD_MSK & AUXDISP_CTRL_CMD_WRTGS), 0xFF);
    
    init_completion(&d_support.tx_cmp);
    d_support.tx_dma_desc->callback = dmatest_slave_tx_callback;
    d_support.tx_dma_desc->callback_param = &d_support.tx_cmp;
        

    d_support.tx_cookie = d_support.tx_dma_desc->tx_submit(d_support.tx_dma_desc);

    if (dma_submit_error(d_support.tx_cookie)) {
        printk(KERN_INFO MSG_PREFIX "Error in cookies\n");
    	msleep(100);
    	goto err_config;
    }

    dmaengine_submit(d_support.tx_dma_desc);
    // Start transactions
    dma_async_issue_pending(d_support.tx_dma_chan);
    
    // Wait that tx has finished
    time_left = wait_for_completion_timeout(&d_support.tx_cmp, d_support.tx_tmo);
    status = dma_async_is_tx_complete(d_support.tx_dma_chan, d_support.tx_cookie, NULL, NULL);
    if (time_left == 0) {
    	printk(KERN_ALERT MSG_PREFIX "DMA timed out\n");
    } else if (status != DMA_COMPLETE) {
    	printk(KERN_ALERT MSG_PREFIX "Tx got completion callback, but status is \'%s\'\n", 
                        status == DMA_ERROR ? "error" :
    					                      "in progress");
    }
    else {
        // printk(KERN_INFO MSG_PREFIX "writing done\n"); 
        }

	return length;

    err_config:
        remove_dma();
    return -1;
}

static ssize_t chardev_write(struct file *fp, const char __user *buf, size_t length, loff_t *off) {
    int status;
    unsigned long time_left;
	enum dma_ctrl_flags flags;
    uint32_t *intmsk_reg  = d_support.base_addr + AUXDISP_INTMSK;
	uint32_t *ctrl_reg = d_support.base_addr + AUXDISP_CTRL;
    int i, offset;
    

    //
    for (i=0; i<32; i++) {
        // I copy 0, 16, 1, 17, 2, 18 ... and so on lines.
        offset = (i%2) ? ((i>>1)+16)*NUM_CHIPS_PER_ROW*16*d_support.bpp_format : (i>>1)*NUM_CHIPS_PER_ROW*16*d_support.bpp_format ;
        //printk("bpp:%d %d %d %d\n", d_support.bpp_format, offset, i, (i%2) ? ((i>>1)+16) : (i>>1));
        if (copy_from_user (d_support.tx_dma_buf_virt+i*NUM_CHIPS_PER_ROW*16*d_support.bpp_format, buf+offset, NUM_CHIPS_PER_ROW*16*d_support.bpp_format)) {
         printk(KERN_ALERT MSG_PREFIX "Error in copy_from_user of the image data\n");
	     return -1;
        }
    }

    flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT ;
    d_support.tx_dma_desc=dmaengine_prep_slave_single(d_support.tx_dma_chan, d_support.tx_dma_buf_phys, length, DMA_MEM_TO_DEV, flags);
         

    // Enable VSYNC interrupt
	set_register_bits(intmsk_reg, DISABLE, AUXDISP_INT_FC);
	set_register_bits(intmsk_reg, ENABLE, AUXDISP_INT_ENDVSYNC);
    // Enable the IP
    set_register_bits(ctrl_reg,   AUXDISP_CTRL_IE | (AUXDISP_CTRL_CMD_MSK & AUXDISP_CTRL_CMD_WRTGS), 0xFF);
    
    init_completion(&d_support.tx_cmp);
    d_support.tx_dma_desc->callback = dmatest_slave_tx_callback;
    d_support.tx_dma_desc->callback_param = &d_support.tx_cmp;
        

    d_support.tx_cookie = d_support.tx_dma_desc->tx_submit(d_support.tx_dma_desc);

    if (dma_submit_error(d_support.tx_cookie)) {
        printk(KERN_INFO MSG_PREFIX "Error in cookies\n");
    	msleep(100);
    	goto err_config;
    }

    dmaengine_submit(d_support.tx_dma_desc);
    // Start transactions
    dma_async_issue_pending(d_support.tx_dma_chan);
    
    // Wait that tx has finished
    time_left = wait_for_completion_timeout(&d_support.tx_cmp, d_support.tx_tmo);
    status = dma_async_is_tx_complete(d_support.tx_dma_chan, d_support.tx_cookie, NULL, NULL);
    if (time_left == 0) {
    	printk(KERN_ALERT MSG_PREFIX "DMA timed out\n");
    } else if (status != DMA_COMPLETE) {
    	printk(KERN_ALERT MSG_PREFIX "Tx got completion callback, but status is \'%s\'\n", 
                        status == DMA_ERROR ? "error" :
    					                      "in progress");
    }
    else {
        // printk(KERN_INFO MSG_PREFIX "writing done\n"); 
        }

	return length;

    err_config:
        remove_dma();
    return -1;
}

static int init_dma (void) {
    dma_cap_mask_t mask;
	enum dma_data_direction direction;
    u32 match, device_id = 0;
    struct dma_device *tx_dev;

    // /////////////////////////////////////////////////////////////////////////////
    // Configure the DMA
    // /////////////////////////////////////////////////////////////////////////////
	dma_cap_zero(mask);
	dma_cap_set(DMA_SLAVE | DMA_PRIVATE, mask);

    d_support.tx_tmo = msecs_to_jiffies(3000);

    // Channels request Set tx channel
    direction = DMA_MEM_TO_DEV;
    match = (direction & 0xFF) | XILINX_DMA_IP_DMA | (device_id << XILINX_DMA_DEVICE_ID_SHIFT);

    d_support.tx_dma_chan=dma_request_channel(mask, xdma_filter, (void *)&match);
	if (!d_support.tx_dma_chan) {
		printk(KERN_INFO MSG_PREFIX "No more tx channels available\n");
        goto exit_now;
    }

    // Channels settings
    tx_dev=d_support.tx_dma_chan->device;


    exit_now:
        return 0;
}


static int chardev_open(struct inode *i, struct file *f) {
	// printk(KERN_DEBUG MSG_PREFIX "Open\n");

    init_dma();

	return 0;
} 

static int chardev_close(struct inode *i, struct file *fp) { 
	// printk(KERN_DEBUG MSG_PREFIX "Close\n");

    remove_dma();

	return 0; 
}


static struct file_operations ret_fops = {
	.open = chardev_open,
	.owner = THIS_MODULE,
	.read = chardev_read,
	.release = chardev_close,
	.unlocked_ioctl = auxdisp_ioctl,
	.write = chardev_write,
};

int register_chardev(struct platform_device *devp) {
	int res;

	if ((res = alloc_chrdev_region(&d_support.devt, 0, 1, RET_CLASS_NAME)) < 0) {
		printk(KERN_ALERT MSG_PREFIX "Error allocating space for device: %d\n", res);
		return -1;
	}

	d_support.major = MAJOR(d_support.devt);
	
	if ((ret_class = class_create(THIS_MODULE, RET_CLASS_NAME)) == NULL) {
		printk(KERN_ALERT MSG_PREFIX "Error creating device class\n");

		unregister_chrdev_region(d_support.devt, MAX_CHANNELS);
		return -1;
	}

	if ((device_create(ret_class, NULL, d_support.devt, NULL, RET_CTL_DEVNAME)) == NULL) {
		printk(KERN_ALERT MSG_PREFIX "Error creating " RET_CTL_DEVNAME "\n");

		class_destroy(ret_class);
		unregister_chrdev_region(d_support.devt, MAX_CHANNELS);
		return -1;
	}

	cdev_init(&d_support.chdev, &ret_fops);
	
	if ((res = cdev_add(&d_support.chdev, d_support.devt, 1)) < 0) {
		printk(KERN_ALERT MSG_PREFIX "Error adding device " RET_CTL_DEVNAME "\n");

		cdev_del(&d_support.chdev);
		device_destroy(ret_class, d_support.devt);
		class_destroy(ret_class);
		unregister_chrdev_region(d_support.devt, MAX_CHANNELS);
		return -1;
	}

	printk(KERN_DEBUG MSG_PREFIX "Registered chardev /dev/" RET_CTL_DEVNAME "\n");

    return 0;
}


static irqreturn_t irq_handler(int irq, void *arg) {
	irqreturn_t retval = 0;
	uint32_t *ctrl_reg = d_support.base_addr + AUXDISP_CTRL;
	uint32_t *int_reg  = d_support.base_addr + AUXDISP_INT;
	uint32_t interrupt;
    
    // Disable interrupt and IP
	set_register_bits(ctrl_reg, 0, AUXDISP_CTRL_IE | AUXDISP_CTRL_EN);
    // Get interrupt value
    get_register_bits(int_reg,interrupt,0xFFFFFFFF);

	if (interrupt & AUXDISP_INT_FC) {
        // Disable IP
	    set_register_bits(ctrl_reg, DISABLE, AUXDISP_CTRL_EN);
        //printk(KERN_INFO MSG_PREFIX "Interrupt FC done\n");
		set_register_bits(int_reg, CLEAR, AUXDISP_INT_FC);

		retval = IRQ_HANDLED;
	} 

	if (interrupt & AUXDISP_INT_PIXEL) {
		set_register_bits(int_reg, CLEAR, AUXDISP_INT_PIXEL);
		retval = IRQ_HANDLED;
	} 

	if (interrupt & AUXDISP_INT_LINE) {
		set_register_bits(int_reg, CLEAR, AUXDISP_INT_LINE);
		retval = IRQ_HANDLED;
	} 

	if (interrupt & AUXDISP_INT_ENDBANK) {
		set_register_bits(int_reg, CLEAR, AUXDISP_INT_ENDBANK);
		retval = IRQ_HANDLED;
	} 

	if (interrupt & AUXDISP_INT_ENDVSYNC) {
        // printk(KERN_INFO MSG_PREFIX "ENDVSYNC done\n");
		set_register_bits(int_reg, CLEAR, AUXDISP_INT_ENDVSYNC);
		retval = IRQ_HANDLED;
	} 

    // Enable interrupt
	set_register_bits(ctrl_reg, ENABLE, AUXDISP_CTRL_IE);

	return retval;
}

static int init_FC_registers (uint48_t **FC) {
	enum dma_ctrl_flags flags;
    uint32_t *intmsk_reg  = d_support.base_addr + AUXDISP_INTMSK;
	uint32_t *ctrl_reg = d_support.base_addr + AUXDISP_CTRL;
    int status;
    unsigned long time_left;
    unsigned char dummy[2]= {0xAD, 0xDE}; // Dummy 16bit data to pad the FC data structure
    unsigned char *tmp_ptr;
    unsigned int r;    
    
    // Initialize the data to transfer
    tmp_ptr = (unsigned char *)d_support.tx_dma_buf_virt;
    for (r=0; r<d_support.impl_numofrows; r++) {
        memcpy (tmp_ptr, (unsigned char *)(&FC[r][0]), sizeof(uint48_t)*d_support.impl_numofchips);
        tmp_ptr =  tmp_ptr + sizeof(uint48_t)*d_support.impl_numofchips;
        if (d_support.impl_numofchips&0x1) {
            // i.e. we have an ODD number of chip then we need to PAD the data!!!
            memcpy (tmp_ptr, (unsigned char *)dummy, sizeof(dummy)); 
            tmp_ptr =  tmp_ptr + sizeof(dummy);
        }
    }

    // Enable FC interrupt
	set_register_bits(intmsk_reg, ENABLE, AUXDISP_INT_FC);
       
    // Descriptors preparing
    flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT ;

    d_support.tx_dma_desc=dmaengine_prep_slave_single(d_support.tx_dma_chan, d_support.tx_dma_buf_phys, 
        d_support.impl_numofrows*(d_support.impl_numofchips*sizeof(uint48_t)+((d_support.impl_numofchips&0x1) ? sizeof(dummy) : 0) ),
         DMA_MEM_TO_DEV, flags);

    init_completion(&d_support.tx_cmp);
    d_support.tx_dma_desc->callback = dmatest_slave_tx_callback;
    d_support.tx_dma_desc->callback_param = &d_support.tx_cmp;

    // Descriptors submit in DMA queus
    d_support.tx_cookie = dmaengine_submit(d_support.tx_dma_desc);
    if (dma_submit_error(d_support.tx_cookie)) {
        printk(KERN_INFO MSG_PREFIX "Error in cookies\n");
     msleep(100);
     goto err_config;
    }
    
    // Start transactions
    dma_async_issue_pending(d_support.tx_dma_chan);

    // Enable the IP
    set_register_bits(ctrl_reg,   AUXDISP_CTRL_EN | AUXDISP_CTRL_IE | (AUXDISP_CTRL_CMD_MSK & AUXDISP_CTRL_CMD_WRTFC), 0xFF);

    // Wait that tx has finished
    time_left = wait_for_completion_timeout(&d_support.tx_cmp, d_support.tx_tmo);
    status = dma_async_is_tx_complete(d_support.tx_dma_chan, d_support.tx_cookie, NULL, NULL);
    if (time_left == 0) {
        printk(KERN_INFO MSG_PREFIX "Tx test timed out b0\n");
    } else if (status != DMA_COMPLETE) {
        printk(KERN_INFO MSG_PREFIX "Tx got completion callback, but status is \'%s\'\n", 
                    status == DMA_ERROR ? "error" :
                                       "in progress");
    }
    return 0;
    
    // Set to NULL command the IP
    set_register_bits(ctrl_reg,   AUXDISP_CTRL_IE | (AUXDISP_CTRL_CMD_MSK & AUXDISP_CTRL_CMD_NULL), 0xFF);
    
    return 0;

    err_config:
        remove_dma();
    return -1;
    
}

static int init_fc (void) {
    uint48_t **FC;
    int r;

    // Allocate space for FC registers
    FC= (uint48_t **)kmalloc(d_support.impl_numofrows*sizeof(uint48_t *),GFP_KERNEL);
    for (r=0; r<d_support.impl_numofrows; r++)
        FC[r]=(uint48_t *)kmalloc(d_support.impl_numofchips*sizeof(uint48_t),GFP_KERNEL);


    // Initialize the FC1 registers
    FC[0][0].v = 0x910080401B75;
    FC[0][1].v = 0x910080401B75;
    FC[0][2].v = 0x910080401B75;
    FC[0][3].v = 0x910080401B75;
    FC[0][4].v = 0x910080401B75;
    
    FC[1][0].v = 0x910080401B75;
    FC[1][1].v = 0x910080401B75;
    FC[1][2].v = 0x910080401B75;
    FC[1][3].v = 0x910080401B75;
    FC[1][4].v = 0x910080401B75;

    // Make the FC1 effective
    if (init_FC_registers(FC))
        return 1;

    
    // Initialize the FC2 registers
    FC[0][0].v = 0x60000001008F;
    FC[0][1].v = 0x60000001008F;
    FC[0][2].v = 0x60000001008F;
    FC[0][3].v = 0x60000001008F;
    FC[0][4].v = 0x60000001008F;
    
    FC[1][0].v = 0x60000001008F;
    FC[1][1].v = 0x60000001008F;
    FC[1][2].v = 0x60000001008F;
    FC[1][3].v = 0x60000001008F;
    FC[1][4].v = 0x60000001008F;

    // Make the FC2 effective
    if (init_FC_registers(FC))
        return 1;
    
    // Free the FC allocated memory    
    for (r=0; r<d_support.impl_numofrows; r++) {
        kfree(FC[r]);
        }
    kfree(FC);
    
    return 0;

}
static int auxdisp_probe(struct platform_device *devp) {
	uint32_t *ver_reg;
	uint32_t *impl_reg;
	struct resource *res; 
	unsigned long remap_size;
	int result;
    uint32_t tmp;
    struct device_node *np = devp->dev.of_node;
    
 	printk(KERN_DEBUG MSG_PREFIX "Probing auxdisp\n");

    d_support.writing_done = NULL;
	   
    if ((result = register_chardev(devp)) < 0) {
		printk(KERN_INFO MSG_PREFIX "Error registering character device!\n");
		return result;
	}
	res = platform_get_resource(devp, IORESOURCE_MEM, 0);
	if (!res) {
		printk(KERN_INFO MSG_PREFIX "Error getting platform device memory\n");
		return -1;
	}

	remap_size = res->end - res->start + 1;
	if (!request_mem_region(res->start, remap_size, devp->name)) {
		printk(KERN_INFO MSG_PREFIX "Error allocating device memory\n");
		return -1;
	}
    
	devp->dev.devt = d_support.devt;
	d_support.base_addr = ioremap(res->start, remap_size);
	d_support.mem_size = remap_size;
	d_support.pm_start = res->start;
	init_waitqueue_head(&(d_support.wait));

    ver_reg =  d_support.base_addr + AUXDISP_VER;
    get_register_bits(ver_reg, tmp, AUXDISP_VER_MSK);
    printk(KERN_INFO MSG_PREFIX "Version: 0x%08X\n", tmp);

    impl_reg =  d_support.base_addr + AUXDISP_IMPL;
    get_register_bits(impl_reg, tmp, AUXDISP_IMPL_MSK);
    d_support.impl_numlines   =(tmp&0x1F  )+1;   
    d_support.impl_numofchips =(tmp&0x3E0 )>>5;
    d_support.impl_numofrows  =(tmp&0x3C00)>>10;
    printk(KERN_INFO MSG_PREFIX "cfg (%d.%d.%d)\n",d_support.impl_numofrows,d_support.impl_numofchips,d_support.impl_numlines);
    if ( (d_support.impl_numlines!=LINES_PER_ROW) || (d_support.impl_numofchips!=NUM_CHIPS_PER_ROW) || (d_support.impl_numofrows!=NUM_ROWS) ) {
		printk(KERN_ALERT MSG_PREFIX "Error in kernel module configuration and auxdisp implementation\n");
        return -1;
    }
    // This is the size of a FC
    input_picsize=NUM_ROWS*LINES_PER_ROW*NUM_CHIPS_PER_ROW*16*sizeof(uint48_t);
    // Allocate DMA coherent memory
	d_support.tx_dma_buf_virt = (unsigned char *)dma_alloc_coherent(&(devp->dev), PAGE_ALIGN(input_picsize), &(d_support.tx_dma_buf_phys), GFP_KERNEL);
	if (!d_support.tx_dma_buf_virt) {
		printk(KERN_INFO MSG_PREFIX "Error allocating tx dma coherent device memory\n");
		return -1;
	}
    // printk(KERN_DEBUG MSG_PREFIX "DMA coherent memory allocated\n");
    
    d_support.irq = platform_get_irq(devp, 0);
    if (d_support.irq<0) {
        printk(KERN_INFO MSG_PREFIX "Error getting irq\n");
        return -1;
    }
    
    result = request_irq(d_support.irq, irq_handler, IRQF_SHARED, "int_auxdisp", &d_support);
    if (result) {
        printk(KERN_INFO MSG_PREFIX "Error requesting irq: %d\n", result);
        return -1;
    }
    
    d_support.reset_auxdisp = of_get_named_gpio(np, "auxdisp-reset", 0);
    if (!gpio_is_valid(d_support.reset_auxdisp)) {
        dev_err(&devp->dev, "Invalid gpio: %d\n", d_support.reset_auxdisp);
        remove_dma();
        return (d_support.reset_auxdisp);
    } else {
        if (gpio_direction_output(d_support.reset_auxdisp, 0)<0) {
            dev_err(&devp->dev, "Cannot turn to output gpio: %d\n", d_support.reset_auxdisp);;
        }
    }
    
    
    // Reset all FSMs inside the auxdisp module
    set_reset(1);
    
    

    // Initialize the DMA
    init_dma();
    
    if (init_fc())
        goto remove;

    remove:
        remove_dma();
    
    return 0;
};

static int auxdisp_remove(struct platform_device *devp) {
	dev_t dev = devp->dev.devt;
    
    // Write a black screen
    black_screen();
    msleep(100);

    
    // Free allocated coherent memory
	dma_free_coherent(&(devp->dev), PAGE_ALIGN(input_picsize), d_support.tx_dma_buf_virt, d_support.tx_dma_buf_phys);
    
    // free interrupt
    free_irq(d_support.irq, &d_support);

    remove_dma();

	// printk(KERN_DEBUG MSG_PREFIX "Unregister device\n");
	cdev_del(&d_support.chdev);
	device_destroy(ret_class, dev);

	// printk(KERN_DEBUG MSG_PREFIX "Destroy class\n");
	class_destroy(ret_class);

	//printk(KERN_DEBUG MSG_PREFIX "Unregister chardev region\n");
	unregister_chrdev_region(d_support.devt, 1);

	iounmap(d_support.base_addr);
	release_mem_region(d_support.pm_start, d_support.mem_size);
        
    // Turn the input of TLC to be not driven by FPGA
    gpio_direction_input(d_support.reset_auxdisp);
    
	printk(KERN_DEBUG MSG_PREFIX "Removed\n");
    return 0;
};

static struct platform_driver auxdisp_platform_driver = {
        .probe          = auxdisp_probe,
        .remove         = auxdisp_remove,
        .driver         = {
        .name   = DRIVER_NAME,
        .owner  = THIS_MODULE,
        .of_match_table = auxdisp_of_match,
        },
};

module_platform_driver(auxdisp_platform_driver);

MODULE_ALIAS("platform:iit-auxdisp");
MODULE_DESCRIPTION("CER display driver");
MODULE_AUTHOR("Francesco Diotalevi <francesco.diotalevi@iit.it>");
MODULE_LICENSE("GPL v2");

static void read_generic_reg(u32 *par, void __iomem *reg_addr)
{
    *par=ioread32(reg_addr);
}

static void write_generic_reg(u32 par, void __iomem *reg_addr)
{
	iowrite32(par,reg_addr);
}

static long auxdisp_ioctl(struct file *filp, unsigned int cmd, unsigned long param) {
    int res =0;
    unsigned int tmp;
    uint48_t **FC;
    int r;
    auxdisp_regs_t temp_reg;
//    unsigned int bpp;
    
    switch (cmd) {
        case IOC_GET_VER:
            res=get_version(filp, &tmp);
            if (copy_to_user((unsigned int *)param, &tmp, sizeof(unsigned int)))
                goto ctuser_err;
            
            break;
      
         case IOC_SET_FC:
            // Allocate space for FC registers
            FC= (uint48_t **)kmalloc(d_support.impl_numofrows*sizeof(uint48_t *),GFP_KERNEL);
            for (r=0; r<d_support.impl_numofrows; r++)
                FC[r]=(uint48_t *)kmalloc( d_support.impl_numofchips*sizeof(uint48_t), GFP_KERNEL );

            for (r=0; r<d_support.impl_numofrows; r++)
                if (copy_from_user(&(FC[r][0]), (&((uint48_t **)param)[r][0]), d_support.impl_numofchips*sizeof(uint48_t)))
                    goto cfuser_err;
            
            res=set_fc(filp, FC);

            // Free the FC allocated memory    
            for (r=0; r<d_support.impl_numofrows; r++)
                kfree(FC[r]);
            kfree(FC);
            
            break;
      
        case IOC_GET_CTRL:
            res=get_ctrl(filp, &tmp);
            if (copy_to_user((unsigned int *)param, &tmp, sizeof(unsigned int)))
                goto ctuser_err;
            
            break;
      
         case IOC_RESET_IP:
            printk(KERN_INFO MSG_PREFIX "RESET done!\n");
            res=set_reset(1);
            
            break;
            
         case IOC_GEN_REG:
            if (copy_from_user(&temp_reg, (struct gla_regs *)param, sizeof(temp_reg)))
                goto cfuser_err;

            if (temp_reg.rw==0) {
		        read_generic_reg(&temp_reg.data,d_support.base_addr + temp_reg.reg_offset);
                
                if (copy_to_user((struct gla_regs *)param, &temp_reg, sizeof(temp_reg)))
                    goto cfuser_err;
            }
            else {
		        write_generic_reg(temp_reg.data,d_support.base_addr + temp_reg.reg_offset);
            }
    	    break;
            
        case IOC_SET_BPP:

//             if (copy_from_user(&bpp, (unsigned int *)&param, sizeof(bpp))) {
//                 printk(KERN_ALERT MSG_PREFIX "ERROR %d\n",(unsigned int)param);
//                 goto cfuser_err;
//                 }

            if (param==AUXDISP_CTRL_BPP_48)
                set_bpp(AUXDISP_CTRL_BPP_48);
            else if (param==AUXDISP_CTRL_BPP_24)
                set_bpp(AUXDISP_CTRL_BPP_24);
            else if (param==AUXDISP_CTRL_BPP_16)
                set_bpp(AUXDISP_CTRL_BPP_16);

	        //get_bpp(&bpp);
            //printk(KERN_INFO MSG_PREFIX "bpp set to %d\n",bpp);
            
            break;
     
        default:
            printk(KERN_INFO MSG_PREFIX "IOCTL request not handled: %d\n", cmd);
            return -EFAULT;
    }

    return res;
    
    cfuser_err:
        printk(KERN_INFO MSG_PREFIX "Copy from user space failed\n");
        return -EFAULT;
    ctuser_err:
        printk(KERN_INFO MSG_PREFIX "Copy to user space failed\n");
        return -EFAULT;
}



static long get_version(struct file *filp, unsigned int *version) {
    uint32_t *ver_reg  = d_support.base_addr + AUXDISP_VER;
    uint32_t tmp;

	get_register_bits(ver_reg, tmp, 0xFFFFFFFF);
    *version=tmp;
    
    return(0);
}

static long get_ctrl(struct file *filp, unsigned int *value) {
    uint32_t *ctrl_reg  = d_support.base_addr + AUXDISP_CTRL;
    uint32_t tmp;

	get_register_bits(ctrl_reg, tmp, 0xFFFFFFFF);
    *value=tmp;
    
    return(0);
}

static long set_fc(struct file *filp, uint48_t **FC) {

//    set_reset(1);
    init_FC_registers(FC);
        
    return(0);
}

static long set_reset(unsigned int val) {
    uint32_t *ctrl_reg  = d_support.base_addr + AUXDISP_CTRL;
        
    set_register_bits(ctrl_reg, ENABLE, AUXDISP_CTRL_RESETIP);
    
    return(0);
}

void set_bpp(unsigned int val) {
    uint32_t *ctrl_reg  = d_support.base_addr + AUXDISP_CTRL;
        
    set_register_bits(ctrl_reg, val&0x7, AUXDISP_CTRL_BPP_MSK);
    d_support.bpp_format = (val==AUXDISP_CTRL_BPP_48) ?  6*sizeof(char) : // 48bit means 6 bytes
                           (val==AUXDISP_CTRL_BPP_24) ?  3*sizeof(char) : // 24bit means 3 bytes
                           (val==AUXDISP_CTRL_BPP_16) ?  2*sizeof(char) : // 16bit means 2 bytes
                                                         6*sizeof(char) ; // Default is 6 bytes i.e.: 48bit

}

void get_bpp(unsigned int *val) {
    uint32_t *ctrl_reg  = d_support.base_addr + AUXDISP_CTRL;
        
    get_register_bits(ctrl_reg, *val, AUXDISP_CTRL_BPP_MSK);

}


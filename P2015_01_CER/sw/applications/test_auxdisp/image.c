#include <stdlib.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include<opencv/highgui.h>
#include<opencv/cxcore.h>
#include<opencv/cv.h>


#define IOC_MAGIC_NUMBER 0x98
#define IOC_GET_VER      _IOR(IOC_MAGIC_NUMBER, 0, unsigned int)
#define IOC_SET_FC       _IOW(IOC_MAGIC_NUMBER, 1, unsigned int)
#define IOC_GET_CTRL     _IOR(IOC_MAGIC_NUMBER, 2, unsigned int)
#define IOC_RESET_IP     _IOW(IOC_MAGIC_NUMBER, 3, unsigned int)
#define IOC_GEN_REG      _IOWR(IOC_MAGIC_NUMBER, 4, struct auxdisp_regs *)
#define IOC_SET_BPP      _IOW(IOC_MAGIC_NUMBER, 5, unsigned int)

// Reggisters
#define CER_VERSION 0x00
#define CER_CTRL    0x04
#define CER_INTMSK  0x08
#define CER_INT     0x0C
#define CER_RAWSTAT 0x10
#define CER_TIME    0x14
#define CER_IMPL    0x18

#define READ_REGISTER  0
#define WRITE_REGISTER 1

#define BPP48  (0)
#define BPP24  (1)
#define BPP16  (2)

typedef struct auxdisp_regs {
    uint32_t offset;
    char rw;
    uint32_t data;
} auxdisp_regs_t;

int main(int argc, char* argv[])
{
  int fd = -1;
  IplImage* img = cvLoadImage(argv[1],1);
  auxdisp_regs_t gen_reg;

  if (!img)
  {
    printf("Image can NOT Load!!!\n");
    return 1;
  }
  
  // Show image
//  cvNamedWindow("CERImage",CV_WINDOW_AUTOSIZE);
//  cvShowImage("CERImage", img);

  // Conver into BGR
  cvCvtColor(img,img,CV_BGR2RGB);

  // Open auxdisplay
  if ((fd=open("/dev/auxdisp", O_RDWR)) < 0) {
		perror("open");
		return -1;
  }

  // THIS SET THE DEAD TIME
  gen_reg.offset=CER_TIME;
  gen_reg.rw=WRITE_REGISTER;
  gen_reg.data=0x110063;
  ioctl (fd, IOC_GEN_REG, &gen_reg);

  // Set 24bpp otherwise exit
  if (img->depth==IPL_DEPTH_8U)
	ioctl(fd,IOC_SET_BPP,BPP24);
  else 
	exit(1);

  // Show image on Auxdisp
  write(fd, img->imageData, img->imageSize);
  close(fd);

  // Wait any key to release the opencv image 
//  cvWaitKey(0);
//  cvReleaseImage(&img);

return 0;
}

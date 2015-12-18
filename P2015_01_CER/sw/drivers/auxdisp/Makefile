obj-m := auxdisp.o 
ccflags-m := -DDEBUG

all:
	make -C ../linux_kernel/ M=$(PWD) modules
clean:
	make -C ../linux_kernel/ M=$(PWD) clean

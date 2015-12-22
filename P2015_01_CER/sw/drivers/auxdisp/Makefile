obj-m := auxdisp.o
ccflags-m := -DDEBUG

all:
	make -C /home/andrea/zed_kernel/linux-stable M=$(PWD) modules
clean:
	make -C /home/andrea/zed_kernel/linux-stable M=$(PWD) clean

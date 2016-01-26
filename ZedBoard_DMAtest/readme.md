# Zedboard dma test
This project is aimed to test the xilinx dma IP instanced in the PL. It has been instanced with scatter-gather interface and with the IP streaming interfaces connected back-to-back. For better understanding the dma behaviour, ILA have been added for any interface.

### U-boot.elf
The *u-boot.elf* here used has been cloned from the [u-boot repository], master branch.
Just types 
```sh
$ make zynq_zed_defconfig
$ make
```
The u-boot file *u-boot* in the main directory of the cloned [u-boot repository] must be used as *u-boot.elf*.

### Linux Kernel
The linux kernel used has been cloned from [xilinx linux kernel] with tag  *xilinx-v2015.1*.
Just types 
```sh
$ make ARCH=arm xilinx_zynq_defconfig
$ make ARCH=arm menuconfig 
```
Include the xilinx dma driver and also the xilinx dma test. Then, compile the kernel with:
```sh
$ make ARCH=arm UIMAGE_LOADADDR=0x8000 uImage
```
> __A maintained EDL version of working linux kernel is also here: [EDL linux branch]__

### Devicetree
The devicetree here used has been cloned from [xilinx devicetree] with tag *xilinx-v2015.1*.
Use the cloned directory as reference for the Xilinx tools reference in Xilinx SDK tool.

### Vivado
These instructions needs to be followed to build the fpga bitstream.
* Open a new project for the Zedboard in vivado and call it *fpga*
* Create a Block Design and call it *system*
* from the tcl command bar types: *source ../\_\_reference_stuff\_\_/whole_design.tcl* (for 2015.2 vivado version) or *source ../\_\_reference_stuff\_\_/whole_design_2015.4.tcl* (for 2015.4 vivado version)
* use the *../\_\_reference_stuff\_\_/sytem_wrapper.v* as top design.
* Generate the bitstream
* export the hardware (with the bitstream flagged).
* launch SDK
* From SDK, set the repository as in Devicetree Section here above.
* Create a New Application and call it *FSBL*. Use the Zynq FSBL as template.
* Create a New Board Support Package in such a way to create the devicetree.
* From the *boot_image* directory types:
```sh
> ./launch_bootgen
> ./start_script_device_tree
```
* Now in the boot_image you should have *BOOT.bin*, *devicetree.dtb*. Put them with the uImage as in *Linux Kernel Section* into the FAT partition of the SD card.

### Development
Want to contribute? Great!

### Todos
TBD

### License
TBD

[u-boot repository]: <https://github.com/francescodiotalevi/u-boot-xlnx>
[xilinx linux kernel]: <https://github.com/Xilinx/linux-xlnx.git>
[EDL linux branch]: <https://github.com/andreamerello/linux-zynq-stable/tree/P2016_I01_xilinx_dma_test>
[xilinx devicetree]: <https://github.com/Xilinx/device-tree-xlnx>

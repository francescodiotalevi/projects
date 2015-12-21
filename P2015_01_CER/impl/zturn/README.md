# Myir Zturn design

The BOOT.BIN has been created by using the Xilinx Vivado 2015.2 version.

## Auxdisp:
The Ip-core for driving the TLC5958 is the auxdisp ip
- **Address**:43c00000
- It has **interrupt** @ line 31
- **Parameters**: 
* hor-module = <0x5>;
* log2numlines = <0x4>;
* numlines = <0x10>;
* numrows = <0x2>;
* The signal to reset the IP is connected to gpio line 119. Keep high by default /* 109 = 54(offset default for gpio) + 55 */


## Axi Dma
It is connected as stream interface to the Auxdisp
- **Address**: 40400000
- It has **interrupt** @ line 29
- **Parameters**: 
* include-sg ;
* dma-channel@40400000 {
* compatible = "xlnx,axi-dma-mm2s-channel";
* interrupts = <0 29 4>;
* xlnx,datawidth = <0x20>;
* xlnx,device-id = <0x0>;
*			};

# How to create the u-boot.elf
To create the u-boot for zturn, follow these instructions:
1. checkout the *EDL_2015.2 branch* of *u-boot-xlnx* from [here]
2. type: **make zynq_zturn_config**
3. type: **make** 
4. the *.u-boot* file is built

[here]:https://github.com/francescodiotalevi/u-boot-xlnx/tree/EDL_2015.2
 

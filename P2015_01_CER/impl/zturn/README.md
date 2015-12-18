# Myir Zturn design

The BOOT.BIN has been created by using the Xilinx Vivado 2015.2 version.

Auxdisp:
The Ip-core for driving the TLC5958 is the auxdisp ip
Address:43c00000 {
It has intterrupt @ line 31
Parameters: hor-module = <0x5>;
			log2numlines = <0x4>;
			numlines = <0x10>;
			numrows = <0x2>;
			/* 109 = 54(offset default for gpio) + 55 */
The signal to reset the IP is connected to gpio line 119. Keep high by default


Axi Dma
It is connected as stream interface to the Auxdisp
Address: 40400000
It has intterrupt @ line 29
Parameters: include-sg ;
			dma-channel@40400000 {
				compatible = "xlnx,axi-dma-mm2s-channel";
				interrupts = <0 29 4>;
				xlnx,datawidth = <0x20>;
				xlnx,device-id = <0x0>;
			};

# Zedboard design

The BOOT.BIN has been created by using the Xilinx Vivado 2015.2 version.
Please see [pl.dtsi] to view which custom IPs are used in programmable logic of FPGA.

# How to create the u-boot.elf
To create the u-boot for zedboard, follow these instructions:

1. checkout the *EDL_2015.2 branch* of *u-boot-xlnx* from [here]
2. from the checkouted directory type:
   1. **make zynq_zed_config**
   2. **make**
3. the *.u-boot* file is then built in the directory where you typed the commands above


[pl.dtsi]:https://github.com/francescodiotalevi/projects/blob/master/P2015_01_CER/impl/zturn/pl.dtsi
[here]:https://github.com/francescodiotalevi/u-boot-xlnx/tree/EDL_2015.2
 

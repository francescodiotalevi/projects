# Zturn design

The BOOT.BIN has been created by using the Xilinx Vivado 2015.4 version.
No custom IPs are here used.

# How to create the u-boot.elf
To create the u-boot for zturn, follow these instructions:

1. checkout the *EDL_2015.2 branch* of *u-boot-xlnx* from [here]
2. from the checkouted directory type:
   1. **make zynq_zturn_config**
   2. **make**
3. the *.u-boot* file is then built in the directory where you typed the commands above

**Please note** that the u-boot **automatically at the early steps initializes** the USB and ETH reset and also I2Cs.

[pl.dtsi]:https://github.com/francescodiotalevi/projects/blob/master/P2015_01_CER/impl/zturn/pl.dtsi
[here]:https://github.com/francescodiotalevi/u-boot-xlnx/tree/EDL_2015.2
 

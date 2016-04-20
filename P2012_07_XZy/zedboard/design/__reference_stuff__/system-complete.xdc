#############################################################
# GPIO                                                      #
#############################################################
set_property  -dict {PACKAGE_PIN  P16   IOSTANDARD LVCMOS25} [get_ports gpio_bd[0]]       ; ## BTNC ## RESTART Button
set_property  -dict {PACKAGE_PIN  R16   IOSTANDARD LVCMOS25} [get_ports gpio_bd[1]]       ; ## BTND
set_property  -dict {PACKAGE_PIN  N15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[2]]       ; ## BTNL
set_property  -dict {PACKAGE_PIN  R18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[3]]       ; ## BTNR
set_property  -dict {PACKAGE_PIN  T18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[4]]       ; ## BTNU
set_property  -dict {PACKAGE_PIN  U10   IOSTANDARD LVCMOS33} [get_ports gpio_bd[5]]       ; ## OLED-DC
set_property  -dict {PACKAGE_PIN  U9    IOSTANDARD LVCMOS33} [get_ports gpio_bd[6]]       ; ## OLED-RES
set_property  -dict {PACKAGE_PIN  AB12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[7]]       ; ## OLED-SCLK
set_property  -dict {PACKAGE_PIN  AA12  IOSTANDARD LVCMOS33} [get_ports gpio_bd[8]]       ; ## OLED-SDIN
set_property  -dict {PACKAGE_PIN  U11   IOSTANDARD LVCMOS33} [get_ports gpio_bd[9]]       ; ## OLED-VBAT
set_property  -dict {PACKAGE_PIN  U12   IOSTANDARD LVCMOS33} [get_ports gpio_bd[10]]      ; ## OLED-VDD

set_property  -dict {PACKAGE_PIN  F22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[11]]      ; ## SW0
set_property  -dict {PACKAGE_PIN  G22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[12]]      ; ## SW1
set_property  -dict {PACKAGE_PIN  H22   IOSTANDARD LVCMOS25} [get_ports gpio_bd[13]]      ; ## SW2
set_property  -dict {PACKAGE_PIN  F21   IOSTANDARD LVCMOS25} [get_ports gpio_bd[14]]      ; ## SW3
set_property  -dict {PACKAGE_PIN  H19   IOSTANDARD LVCMOS25} [get_ports gpio_bd[15]]      ; ## SW4
set_property  -dict {PACKAGE_PIN  H18   IOSTANDARD LVCMOS25} [get_ports gpio_bd[16]]      ; ## SW5
set_property  -dict {PACKAGE_PIN  H17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[17]]      ; ## SW6
set_property  -dict {PACKAGE_PIN  M15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[18]]      ; ## SW7

set_property  -dict {PACKAGE_PIN  T22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[19]]      ; ## LD0
set_property  -dict {PACKAGE_PIN  T21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[20]]      ; ## LD1
set_property  -dict {PACKAGE_PIN  U22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[21]]      ; ## LD2
set_property  -dict {PACKAGE_PIN  U21   IOSTANDARD LVCMOS33} [get_ports gpio_bd[22]]      ; ## LD3
set_property  -dict {PACKAGE_PIN  V22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[23]]      ; ## LD4
set_property  -dict {PACKAGE_PIN  W22   IOSTANDARD LVCMOS33} [get_ports gpio_bd[24]]      ; ## LD5
set_property  -dict {PACKAGE_PIN  U19   IOSTANDARD LVCMOS33} [get_ports gpio_bd[25]]      ; ## LD6
set_property  -dict {PACKAGE_PIN  U14   IOSTANDARD LVCMOS33} [get_ports gpio_bd[26]]      ; ## LD7

set_property  -dict {PACKAGE_PIN  H15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[27]]      ; ## XADC-GIO0
set_property  -dict {PACKAGE_PIN  R15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[28]]      ; ## XADC-GIO1
set_property  -dict {PACKAGE_PIN  K15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[29]]      ; ## XADC-GIO2
set_property  -dict {PACKAGE_PIN  J15   IOSTANDARD LVCMOS25} [get_ports gpio_bd[30]]      ; ## XADC-GIO3

#############################################################
# USB OTG                                                   #
#############################################################
# USB-Overcurrent
set_property IOSTANDARD LVCMOS25 [get_ports otg_oc]
set_property PACKAGE_PIN L16     [get_ports otg_oc]
# OTG-RESETN
set_property  -dict {PACKAGE_PIN  G17   IOSTANDARD LVCMOS25} [get_ports gpio_bd[31]]
#############################################################

#############################################################
## 
## #     # ######  #     #   ###
## #     # #     # ##   ##    #
## #     # #     # # # # #    #
## ####### #     # #  #  #    #
## #     # #     # #     #    #
## #     # #     # #     #    #
## #     # ######  #     #   ###
## 
#############################################################
set_property  -dict {PACKAGE_PIN  W18   IOSTANDARD LVCMOS33}           [get_ports hdmi_out_clk]
set_property  -dict {PACKAGE_PIN  W17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_vsync]
set_property  -dict {PACKAGE_PIN  V17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_hsync]
set_property  -dict {PACKAGE_PIN  U16   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data_e]
set_property  -dict {PACKAGE_PIN  Y13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[0]]
set_property  -dict {PACKAGE_PIN  AA13  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[1]]
set_property  -dict {PACKAGE_PIN  AA14  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[2]]
set_property  -dict {PACKAGE_PIN  Y14   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[3]]
set_property  -dict {PACKAGE_PIN  AB15  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[4]]
set_property  -dict {PACKAGE_PIN  AB16  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[5]]
set_property  -dict {PACKAGE_PIN  AA16  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[6]]
set_property  -dict {PACKAGE_PIN  AB17  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[7]]
set_property  -dict {PACKAGE_PIN  AA17  IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[8]]
set_property  -dict {PACKAGE_PIN  Y15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[9]]
set_property  -dict {PACKAGE_PIN  W13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[10]]
set_property  -dict {PACKAGE_PIN  W15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[11]]
set_property  -dict {PACKAGE_PIN  V15   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[12]]
set_property  -dict {PACKAGE_PIN  U17   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[13]]
set_property  -dict {PACKAGE_PIN  V14   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[14]]
set_property  -dict {PACKAGE_PIN  V13   IOSTANDARD LVCMOS33  IOB TRUE} [get_ports hdmi_data[15]]
# spdif
set_property  -dict {PACKAGE_PIN  U15   IOSTANDARD LVCMOS33} [get_ports spdif]
# iic
set_property  -dict {PACKAGE_PIN  AA18    IOSTANDARD LVCMOS33} [get_ports iic_fmc_scl_io]
set_property  PULLUP true                                      [get_ports iic_fmc_scl_io]
set_property  -dict {PACKAGE_PIN  Y16     IOSTANDARD LVCMOS33} [get_ports iic_fmc_sda_io]
set_property  PULLUP true                                      [get_ports iic_fmc_sda_io]

#############################################################
##    #    #     # ######    ###   #######
##   # #   #     # #     #    #    #     #
##  #   #  #     # #     #    #    #     #
## #     # #     # #     #    #    #     #
## ####### #     # #     #    #    #     #
## #     # #     # #     #    #    #     #
## #     #  #####  ######    ###   #######
#############################################################
set_property  -dict {PACKAGE_PIN  AA6   IOSTANDARD LVCMOS33} [get_ports BCLK_O] 
set_property  -dict {PACKAGE_PIN  Y6    IOSTANDARD LVCMOS33} [get_ports LRCLK_O]
set_property  -dict {PACKAGE_PIN  AA7   IOSTANDARD LVCMOS33} [get_ports SDATA_I]
set_property  -dict {PACKAGE_PIN  Y8    IOSTANDARD LVCMOS33} [get_ports SDATA_O]
set_property  -dict {PACKAGE_PIN  AB2   IOSTANDARD LVCMOS33} [get_ports i2s_mclk]
set_property  -dict {PACKAGE_PIN  AB4   IOSTANDARD LVCMOS33} [get_ports iic_adau_scl_io]
set_property  PULLUP true                                    [get_ports iic_adau_scl_io]
set_property  -dict {PACKAGE_PIN  AB5   IOSTANDARD LVCMOS33} [get_ports iic_adau_sda_io]
set_property  PULLUP true                                    [get_ports iic_adau_sda_io]
set_property  -dict {PACKAGE_PIN  AB1   IOSTANDARD LVCMOS33} [get_ports i2s_addr[0]]
set_property  -dict {PACKAGE_PIN  Y5    IOSTANDARD LVCMOS33} [get_ports i2s_addr[1]]

#Time ignore between system clock and audio clock
#create_clock -period 81.380 -name clock_12M288hz -waveform {0.000 40.690} [get_pins system_i/axi_i2s_adi_0/DATA_CLK_I]
#set_false_path -from [get_clocks clock_12M288hz] -to [get_clocks clk_fpga_0]
#set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clock_12M288hz]
#set_false_path -reset_path -from [get_clocks clock_12M288hz] -to [get_clocks clk_fpga_0]


#############################################################
##  #    #   ####     ##
##  #    #  #    #   #  #
##  #    #  #       #    #
##  #    #  #  ###  ######
##   #  #   #    #  #    #
##    ##     ####   #    #
#############################################################
set_property  -dict {PACKAGE_PIN  V20   IOSTANDARD LVCMOS33} [get_ports Red_o[0]] 
set_property  -dict {PACKAGE_PIN  U20   IOSTANDARD LVCMOS33} [get_ports Red_o[1]] 
set_property  -dict {PACKAGE_PIN  V19   IOSTANDARD LVCMOS33} [get_ports Red_o[2]] 
set_property  -dict {PACKAGE_PIN  V18   IOSTANDARD LVCMOS33} [get_ports Red_o[3]] 

set_property  -dict {PACKAGE_PIN  AB22  IOSTANDARD LVCMOS33} [get_ports Green_o[0]] 
set_property  -dict {PACKAGE_PIN  AA22  IOSTANDARD LVCMOS33} [get_ports Green_o[1]] 
set_property  -dict {PACKAGE_PIN  AB21  IOSTANDARD LVCMOS33} [get_ports Green_o[2]] 
set_property  -dict {PACKAGE_PIN  AA21  IOSTANDARD LVCMOS33} [get_ports Green_o[3]]

set_property  -dict {PACKAGE_PIN  Y21   IOSTANDARD LVCMOS33} [get_ports Blue_o[0]] 
set_property  -dict {PACKAGE_PIN  Y20   IOSTANDARD LVCMOS33} [get_ports Blue_o[1]] 
set_property  -dict {PACKAGE_PIN  AB20  IOSTANDARD LVCMOS33} [get_ports Blue_o[2]] 
set_property  -dict {PACKAGE_PIN  Ab19  IOSTANDARD LVCMOS33} [get_ports Blue_o[3]]

set_property  -dict {PACKAGE_PIN  AA19  IOSTANDARD LVCMOS33} [get_ports hsync]
set_property  -dict {PACKAGE_PIN  Y19   IOSTANDARD LVCMOS33} [get_ports vsync]

#Time ignore between system clock and pixel clocks
create_clock -period 25.000 -name clock_40Mhz -waveform {0.000 12.500} [get_pins system_i/clk_wiz_1/clk_out4]
create_clock -period 15.384 -name clock_65Mhz -waveform {0.000 7.692} [get_pins system_i/clk_wiz_1/clk_out3]
create_clock -period 13.468 -name clock_74_25Mhz -waveform {0.000 6.734} [get_pins system_i/clk_wiz_1/clk_out2]
create_clock -period 9.259 -name clock_108Mhz -waveform {0.000 4.629} [get_pins system_i/clk_wiz_1/clk_out1]

# 40MHz clock
set_false_path -from [get_clocks clock_40Mhz] -to [get_clocks clk_fpga_2]
set_false_path -from [get_clocks clk_fpga_2] -to [get_clocks clock_40Mhz]
set_false_path -from [get_clocks clock_40Mhz] -to [get_clocks clock_65Mhz]
set_false_path -from [get_clocks clock_40Mhz] -to [get_clocks clock_74_25Mhz]
set_false_path -from [get_clocks clock_40Mhz] -to [get_clocks clock_108Mhz]
# 65MHz clock
set_false_path -from [get_clocks clock_65Mhz] -to [get_clocks clk_fpga_2]
set_false_path -from [get_clocks clk_fpga_2] -to [get_clocks clock_65Mhz]
set_false_path -from [get_clocks clock_65Mhz] -to [get_clocks clock_40Mhz]
set_false_path -from [get_clocks clock_65Mhz] -to [get_clocks clock_74_25Mhz]
set_false_path -from [get_clocks clock_65Mhz] -to [get_clocks clock_108Mhz]
# 74.25 MHz clock
set_false_path -from [get_clocks clock_74_25Mhz] -to [get_clocks clk_fpga_2]
set_false_path -from [get_clocks clk_fpga_2] -to [get_clocks clock_74_25Mhz]
set_false_path -from [get_clocks clock_74_25Mhz] -to [get_clocks clock_40Mhz]
set_false_path -from [get_clocks clock_74_25Mhz] -to [get_clocks clock_65Mhz]
set_false_path -from [get_clocks clock_74_25Mhz] -to [get_clocks clock_108Mhz]
# 108 MHz clock
set_false_path -from [get_clocks clock_108Mhz] -to [get_clocks clk_fpga_2]
set_false_path -from [get_clocks clk_fpga_2] -to [get_clocks clock_108Mhz]
set_false_path -from [get_clocks clock_108Mhz] -to [get_clocks clock_40Mhz]
set_false_path -from [get_clocks clock_108Mhz] -to [get_clocks clock_65Mhz]
set_false_path -from [get_clocks clock_108Mhz] -to [get_clocks clock_74_25Mhz]

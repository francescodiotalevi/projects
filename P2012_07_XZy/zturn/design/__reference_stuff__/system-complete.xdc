######################################################################
# LEDs
######################################################################
# set_property  -dict {PACKAGE_PIN  D18   IOSTANDARD LVCMOS33   PULLUP TRUE} [get_ports ampli_iic_scl]    ; ## CN2 29

# Triple Led Color
set_property -dict {PACKAGE_PIN R14     IOSTANDARD  LVCMOS33} [get_ports LEDR]
set_property -dict {PACKAGE_PIN Y16     IOSTANDARD  LVCMOS33} [get_ports LEDG]
set_property -dict {PACKAGE_PIN Y17     IOSTANDARD  LVCMOS33} [get_ports LEDB]

# User led 1 ==> MIO0

# User led 2 ==> MIO9

######################################################################
# Buzzer
######################################################################
set_property -dict {PACKAGE_PIN P18     IOSTANDARD  LVCMOS33} [get_ports BP]

######################################################################
# I2C0
######################################################################
set_property -dict {PACKAGE_PIN P15     IOSTANDARD  LVCMOS33   PULLUP TRUE} [get_ports iic_zturn_sda_io]
set_property -dict {PACKAGE_PIN P16     IOSTANDARD  LVCMOS33   PULLUP TRUE} [get_ports iic_zturn_scl_io]

## 3 Axis GSensor ADXL345
set_property -dict {PACKAGE_PIN N17     IOSTANDARD  LVCMOS33} [get_ports MEMS_INTn]

# Temperature Sensor STLM75
# Interrupt shared with 3 Axis GSensor ADXL345

######################################################################
# SWITCH
######################################################################
set_property -dict {PACKAGE_PIN R19      IOSTANDARD  LVCMOS33} [get_ports {SW[0]}]
set_property -dict {PACKAGE_PIN T19      IOSTANDARD  LVCMOS33} [get_ports {SW[1]}]
set_property -dict {PACKAGE_PIN G14      IOSTANDARD  LVCMOS33} [get_ports {SW[2]}]
set_property -dict {PACKAGE_PIN J15      IOSTANDARD  LVCMOS33} [get_ports {SW[3]}]

######################################################################
# GPIO Key
######################################################################

# MIO50 User Switch 1 used as wakeup?

######################################################################
# CAN
######################################################################

# TX MIO15
# RX MIO14


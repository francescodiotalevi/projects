
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:0.9 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set gpio_bd [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_bd ]
  set iic_adau [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_adau ]
  set iic_fmc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_fmc ]

  # Create ports
  set BCLK_O [ create_bd_port -dir O -from 0 -to 0 BCLK_O ]
  set Blue [ create_bd_port -dir O -from 7 -to 0 Blue ]
  set Green [ create_bd_port -dir O -from 7 -to 0 Green ]
  set LRCLK_O [ create_bd_port -dir O -from 0 -to 0 LRCLK_O ]
  set Red [ create_bd_port -dir O -from 7 -to 0 Red ]
  set SDATA_I [ create_bd_port -dir I -from 0 -to 0 SDATA_I ]
  set SDATA_O [ create_bd_port -dir O -from 0 -to 0 SDATA_O ]
  set hdmi_data [ create_bd_port -dir O -from 15 -to 0 hdmi_data ]
  set hdmi_data_e [ create_bd_port -dir O hdmi_data_e ]
  set hdmi_hsync [ create_bd_port -dir O hdmi_hsync ]
  set hdmi_out_clk [ create_bd_port -dir O -type clk hdmi_out_clk ]
  set hdmi_vsync [ create_bd_port -dir O hdmi_vsync ]
  set hsync [ create_bd_port -dir O hsync ]
  set i2s_addr [ create_bd_port -dir O -from 1 -to 0 i2s_addr ]
  set i2s_mclk [ create_bd_port -dir O i2s_mclk ]
  set otg_oc [ create_bd_port -dir I otg_oc ]
  set spdif [ create_bd_port -dir O spdif ]
  set vsync [ create_bd_port -dir O vsync ]

  # Create instance: axi_clkgen_0, and set properties
  set axi_clkgen_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_clkgen_0 ]

  # Create instance: axi_hdmi_dma, and set properties
  set axi_hdmi_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_hdmi_dma ]
  set_property -dict [ list CONFIG.c_include_s2mm {0} CONFIG.c_m_axis_mm2s_tdata_width {64} CONFIG.c_s2mm_genlock_mode {0} CONFIG.c_use_mm2s_fsync {1}  ] $axi_hdmi_dma

  # Create instance: axi_hdmi_tx_0, and set properties
  set axi_hdmi_tx_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 axi_hdmi_tx_0 ]

  # Create instance: axi_i2s_adi_0, and set properties
  set axi_i2s_adi_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_i2s_adi:1.0 axi_i2s_adi_0 ]
  set_property -dict [ list CONFIG.C_DMA_TYPE {1}  ] $axi_i2s_adi_0

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_iic_fmc, and set properties
  set axi_iic_fmc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_fmc ]

  # Create instance: axi_mem_intercon_1, and set properties
  set axi_mem_intercon_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon_1 ]
  set_property -dict [ list CONFIG.NUM_MI {1}  ] $axi_mem_intercon_1

  # Create instance: axi_spdif_tx_0, and set properties
  set axi_spdif_tx_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_spdif_tx:1.0 axi_spdif_tx_0 ]
  set_property -dict [ list CONFIG.C_DMA_TYPE {1}  ] $axi_spdif_tx_0

  # Create instance: axi_vga_interconnect_0, and set properties
  set axi_vga_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_vga_interconnect_0 ]
  set_property -dict [ list CONFIG.NUM_MI {1}  ] $axi_vga_interconnect_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0 ]
  set_property -dict [ list CONFIG.CLKOUT1_JITTER {327.996} CONFIG.CLKOUT1_PHASE_ERROR {264.435} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288} CONFIG.MMCM_CLKFBOUT_MULT_F {44.375} CONFIG.MMCM_CLKOUT0_DIVIDE_F {80.250} CONFIG.MMCM_DIVCLK_DIVIDE {9} CONFIG.RESET_PORT {resetn} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.USE_LOCKED {false}  ] $clk_wiz_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_1 ]
  set_property -dict [ list CONFIG.CLKOUT1_JITTER {254.987} \
CONFIG.CLKOUT1_PHASE_ERROR {408.085} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {108.000} \
CONFIG.CLKOUT2_JITTER {268.433} CONFIG.CLKOUT2_PHASE_ERROR {408.085} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {74.25} CONFIG.CLKOUT2_USED {true} \
CONFIG.CLKOUT3_JITTER {273.401} CONFIG.CLKOUT3_PHASE_ERROR {408.085} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {65} CONFIG.CLKOUT3_USED {true} \
CONFIG.CLKOUT4_JITTER {292.283} CONFIG.CLKOUT4_PHASE_ERROR {408.085} \
CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {40} CONFIG.CLKOUT4_USED {true} \
CONFIG.MMCM_CLKFBOUT_MULT_F {62.375} CONFIG.MMCM_CLKOUT0_DIVIDE_F {9.625} \
CONFIG.MMCM_CLKOUT1_DIVIDE {14} CONFIG.MMCM_CLKOUT2_DIVIDE {16} \
CONFIG.MMCM_CLKOUT3_DIVIDE {26} CONFIG.MMCM_DIVCLK_DIVIDE {10} \
CONFIG.NUM_OUT_CLKS {4}  ] $clk_wiz_1

  # Create instance: gnd_net, and set properties
  set gnd_net [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd_net ]
  set_property -dict [ list CONFIG.CONST_VAL {0}  ] $gnd_net

  # Create instance: i2s_addr_const, and set properties
  set i2s_addr_const [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 i2s_addr_const ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_EN_CLK2_PORT {1} CONFIG.PCW_EN_RST2_PORT {1} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200.000000} CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {166.666666} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_IO {32} CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} CONFIG.PCW_USE_DMA0 {1} CONFIG.PCW_USE_DMA1 {1} CONFIG.PCW_USE_DMA2 {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_USE_S_AXI_HP0 {0} CONFIG.PCW_USE_S_AXI_HP1 {1} CONFIG.PCW_USE_S_AXI_HP2 {1} CONFIG.preset {ZedBoard}  ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {9}  ] $processing_system7_0_axi_periph

  # Create instance: rst_proc_sys_reset_0_166M, and set properties
  set rst_proc_sys_reset_0_166M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_proc_sys_reset_0_166M ]

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: usb_oc_not, and set properties
  set usb_oc_not [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 usb_oc_not ]
  set_property -dict [ list CONFIG.C_OPERATION {not} CONFIG.C_SIZE {1}  ] $usb_oc_not

  # Create instance: vga_enh_top_0, and set properties
  set vga_enh_top_0 [ create_bd_cell -type ip -vlnv iit.it:user:vga_enh_top:1.1 vga_enh_top_0 ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list CONFIG.NUM_PORTS {5}  ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_hdmi_dma_M_AXIS_MM2S [get_bd_intf_pins axi_hdmi_dma/M_AXIS_MM2S] [get_bd_intf_pins axi_hdmi_tx_0/m_axis_mm2s]
  connect_bd_intf_net -intf_net axi_hdmi_dma_M_AXI_MM2S [get_bd_intf_pins axi_hdmi_dma/M_AXI_MM2S] [get_bd_intf_pins axi_mem_intercon_1/S00_AXI]
  connect_bd_intf_net -intf_net axi_i2s_adi_0_DMA_REQ_RX [get_bd_intf_pins axi_i2s_adi_0/DMA_REQ_RX] [get_bd_intf_pins processing_system7_0/DMA1_REQ]
  connect_bd_intf_net -intf_net axi_i2s_adi_0_DMA_REQ_TX [get_bd_intf_pins axi_i2s_adi_0/DMA_REQ_TX] [get_bd_intf_pins processing_system7_0/DMA0_REQ]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports iic_adau] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_iic_fmc_IIC [get_bd_intf_ports iic_fmc] [get_bd_intf_pins axi_iic_fmc/IIC]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_vga_interconnect_0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP2]
  connect_bd_intf_net -intf_net axi_mem_intercon_1_M00_AXI [get_bd_intf_pins axi_mem_intercon_1/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP1]
  connect_bd_intf_net -intf_net axi_spdif_tx_0_DMA_REQ [get_bd_intf_pins axi_spdif_tx_0/DMA_REQ] [get_bd_intf_pins processing_system7_0/DMA2_REQ]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_DMA0_ACK [get_bd_intf_pins axi_i2s_adi_0/DMA_ACK_TX] [get_bd_intf_pins processing_system7_0/DMA0_ACK]
  connect_bd_intf_net -intf_net processing_system7_0_DMA1_ACK [get_bd_intf_pins axi_i2s_adi_0/DMA_ACK_RX] [get_bd_intf_pins processing_system7_0/DMA1_ACK]
  connect_bd_intf_net -intf_net processing_system7_0_DMA2_ACK [get_bd_intf_pins axi_spdif_tx_0/DMA_ACK] [get_bd_intf_pins processing_system7_0/DMA2_ACK]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_GPIO_0 [get_bd_intf_ports gpio_bd] [get_bd_intf_pins processing_system7_0/GPIO_0]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI] [get_bd_intf_pins vga_enh_top_0/S_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_i2s_adi_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins axi_spdif_tx_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins axi_hdmi_tx_0/s_axi] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins axi_clkgen_0/s_axi] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins axi_hdmi_dma/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M07_AXI [get_bd_intf_pins axi_iic_fmc/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M08_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net vga_enh_top_0_M_AXI [get_bd_intf_pins axi_vga_interconnect_0/S00_AXI] [get_bd_intf_pins vga_enh_top_0/M_AXI]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_vga_interconnect_0/ARESETN] [get_bd_pins rst_proc_sys_reset_0_166M/interconnect_aresetn]
  connect_bd_net -net SDATA_I_1 [get_bd_ports SDATA_I] [get_bd_pins axi_i2s_adi_0/SDATA_I]
  connect_bd_net -net axi_clkgen_0_clk_0 [get_bd_pins axi_clkgen_0/clk_0] [get_bd_pins axi_hdmi_tx_0/hdmi_clk]
  connect_bd_net -net axi_hdmi_dma_mm2s_introut [get_bd_pins axi_hdmi_dma/mm2s_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_hdmi_tx_0_hdmi_16_data [get_bd_ports hdmi_data] [get_bd_pins axi_hdmi_tx_0/hdmi_16_data]
  connect_bd_net -net axi_hdmi_tx_0_hdmi_16_data_e [get_bd_ports hdmi_data_e] [get_bd_pins axi_hdmi_tx_0/hdmi_16_data_e]
  connect_bd_net -net axi_hdmi_tx_0_hdmi_16_hsync [get_bd_ports hdmi_hsync] [get_bd_pins axi_hdmi_tx_0/hdmi_16_hsync]
  connect_bd_net -net axi_hdmi_tx_0_hdmi_16_vsync [get_bd_ports hdmi_vsync] [get_bd_pins axi_hdmi_tx_0/hdmi_16_vsync]
  connect_bd_net -net axi_hdmi_tx_0_hdmi_out_clk [get_bd_ports hdmi_out_clk] [get_bd_pins axi_hdmi_tx_0/hdmi_out_clk]
  connect_bd_net -net axi_hdmi_tx_0_m_axis_mm2s_fsync [get_bd_pins axi_hdmi_dma/mm2s_fsync] [get_bd_pins axi_hdmi_tx_0/m_axis_mm2s_fsync] [get_bd_pins axi_hdmi_tx_0/m_axis_mm2s_fsync_ret]
  connect_bd_net -net axi_i2s_adi_0_BCLK_O [get_bd_ports BCLK_O] [get_bd_pins axi_i2s_adi_0/BCLK_O]
  connect_bd_net -net axi_i2s_adi_0_LRCLK_O [get_bd_ports LRCLK_O] [get_bd_pins axi_i2s_adi_0/LRCLK_O]
  connect_bd_net -net axi_i2s_adi_0_SDATA_O [get_bd_ports SDATA_O] [get_bd_pins axi_i2s_adi_0/SDATA_O]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_iic_fmc_iic2intc_irpt [get_bd_pins axi_iic_fmc/iic2intc_irpt] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_spdif_tx_0_spdif_tx_o [get_bd_ports spdif] [get_bd_pins axi_spdif_tx_0/spdif_tx_o]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports i2s_mclk] [get_bd_pins axi_i2s_adi_0/DATA_CLK_I] [get_bd_pins axi_spdif_tx_0/spdif_data_clk] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins vga_enh_top_0/clk_p_i_c]
  connect_bd_net -net clk_wiz_1_clk_out2 [get_bd_pins clk_wiz_1/clk_out2] [get_bd_pins vga_enh_top_0/clk_p_i_b]
  connect_bd_net -net clk_wiz_1_clk_out3 [get_bd_pins clk_wiz_1/clk_out3] [get_bd_pins vga_enh_top_0/clk_p_i_a]
  connect_bd_net -net clk_wiz_1_clk_out4 [get_bd_pins clk_wiz_1/clk_out4] [get_bd_pins vga_enh_top_0/clk_p_i]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_proc_sys_reset_0_166M/dcm_locked] [get_bd_pins rst_processing_system7_0_100M/dcm_locked]
  connect_bd_net -net gnd_net_dout [get_bd_pins clk_wiz_1/reset] [get_bd_pins gnd_net/dout] [get_bd_pins i2s_addr_const/In0] [get_bd_pins i2s_addr_const/In1] [get_bd_pins vga_enh_top_0/rst_i] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net i2s_addr_const_dout [get_bd_ports i2s_addr] [get_bd_pins i2s_addr_const/dout]
  connect_bd_net -net otg_oc_1 [get_bd_ports otg_oc] [get_bd_pins usb_oc_not/Op1]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_clkgen_0/s_axi_aclk] [get_bd_pins axi_hdmi_dma/m_axi_mm2s_aclk] [get_bd_pins axi_hdmi_dma/m_axis_mm2s_aclk] [get_bd_pins axi_hdmi_dma/s_axi_lite_aclk] [get_bd_pins axi_hdmi_tx_0/m_axis_mm2s_clk] [get_bd_pins axi_hdmi_tx_0/s_axi_aclk] [get_bd_pins axi_i2s_adi_0/DMA_REQ_RX_ACLK] [get_bd_pins axi_i2s_adi_0/DMA_REQ_TX_ACLK] [get_bd_pins axi_i2s_adi_0/S_AXI_ACLK] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_iic_fmc/s_axi_aclk] [get_bd_pins axi_mem_intercon_1/ACLK] [get_bd_pins axi_mem_intercon_1/M00_ACLK] [get_bd_pins axi_mem_intercon_1/S00_ACLK] [get_bd_pins axi_spdif_tx_0/DMA_REQ_ACLK] [get_bd_pins axi_spdif_tx_0/S_AXI_ACLK] [get_bd_pins processing_system7_0/DMA0_ACLK] [get_bd_pins processing_system7_0/DMA1_ACLK] [get_bd_pins processing_system7_0/DMA2_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/M07_ACLK] [get_bd_pins processing_system7_0_axi_periph/M08_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins axi_clkgen_0/clk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_pins axi_vga_interconnect_0/ACLK] [get_bd_pins axi_vga_interconnect_0/M00_ACLK] [get_bd_pins axi_vga_interconnect_0/S00_ACLK] [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK2] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins rst_proc_sys_reset_0_166M/slowest_sync_clk] [get_bd_pins vga_enh_top_0/M_AXI_ACLK] [get_bd_pins vga_enh_top_0/S_AXI_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net processing_system7_0_FCLK_RESET2_N [get_bd_pins processing_system7_0/FCLK_RESET2_N] [get_bd_pins rst_proc_sys_reset_0_166M/ext_reset_in]
  connect_bd_net -net rst_proc_sys_reset_0_166M_peripheral_aresetn [get_bd_pins axi_vga_interconnect_0/M00_ARESETN] [get_bd_pins axi_vga_interconnect_0/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins rst_proc_sys_reset_0_166M/peripheral_aresetn] [get_bd_pins vga_enh_top_0/M_AXI_ARESETN] [get_bd_pins vga_enh_top_0/S_AXI_ARESETN]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins axi_mem_intercon_1/ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_clkgen_0/s_axi_aresetn] [get_bd_pins axi_hdmi_dma/axi_resetn] [get_bd_pins axi_hdmi_tx_0/s_axi_aresetn] [get_bd_pins axi_i2s_adi_0/DMA_REQ_RX_RSTN] [get_bd_pins axi_i2s_adi_0/DMA_REQ_TX_RSTN] [get_bd_pins axi_i2s_adi_0/S_AXI_ARESETN] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_iic_fmc/s_axi_aresetn] [get_bd_pins axi_mem_intercon_1/M00_ARESETN] [get_bd_pins axi_mem_intercon_1/S00_ARESETN] [get_bd_pins axi_spdif_tx_0/DMA_REQ_RSTN] [get_bd_pins axi_spdif_tx_0/S_AXI_ARESETN] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M07_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M08_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins processing_system7_0/USB0_VBUS_PWRFAULT] [get_bd_pins usb_oc_not/Res]
  connect_bd_net -net vga_enh_top_0_b_pad_o [get_bd_ports Blue] [get_bd_pins vga_enh_top_0/b_pad_o]
  connect_bd_net -net vga_enh_top_0_g_pad_o [get_bd_ports Green] [get_bd_pins vga_enh_top_0/g_pad_o]
  connect_bd_net -net vga_enh_top_0_hsync_pad_o [get_bd_ports hsync] [get_bd_pins vga_enh_top_0/hsync_pad_o]
  connect_bd_net -net vga_enh_top_0_inta_o [get_bd_pins vga_enh_top_0/inta_o] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net vga_enh_top_0_r_pad_o [get_bd_ports Red] [get_bd_pins vga_enh_top_0/r_pad_o]
  connect_bd_net -net vga_enh_top_0_vsync_pad_o [get_bd_ports vsync] [get_bd_pins vga_enh_top_0/vsync_pad_o]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_hdmi_dma/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_clkgen_0/s_axi/axi_lite] SEG_axi_clkgen_0_axi_lite
  create_bd_addr_seg -range 0x10000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_hdmi_dma/S_AXI_LITE/Reg] SEG_axi_hdmi_dma_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_hdmi_tx_0/s_axi/axi_lite] SEG_axi_hdmi_tx_0_axi_lite
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_i2s_adi_0/S_AXI/reg0] SEG_axi_i2s_adi_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x41610000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_fmc/S_AXI/Reg] SEG_axi_iic_fmc_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x60000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_spdif_tx_0/S_AXI/reg0] SEG_axi_spdif_tx_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs vga_enh_top_0/S_AXI/reg0] SEG_vga_enh_top_0_reg0
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces vga_enh_top_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Thu Dec 24 12:33:00 2015
//Host        : fravbox running 64-bit Ubuntu 14.04.3 LTS
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
	// VGA
    hsync,
    vsync,
    Red_o,
    Green_o,
    Blue_o,
    // Audio
    BCLK_O,
    LRCLK_O,
    SDATA_I,
    SDATA_O,
    i2s_mclk,
    iic_adau_scl_io,
    iic_adau_sda_io,
    i2s_addr,
    // GPIO
    gpio_bd,
    // HDMI
    hdmi_data,
    hdmi_data_e,
    hdmi_hsync,
    hdmi_out_clk,
    hdmi_vsync,
    spdif,
    iic_fmc_scl_io,
    iic_fmc_sda_io,
    // USB Overcurrent
    otg_oc
	);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  // VGA
  output hsync;
  output vsync;
  output [3:0]Red_o;
  output [3:0]Green_o;
  output [3:0]Blue_o;
  // Audio
  output [0:0]BCLK_O;
  output [0:0]LRCLK_O;
  input [0:0]SDATA_I;
  output [0:0]SDATA_O;
  output i2s_mclk;
  inout iic_adau_scl_io;
  inout iic_adau_sda_io;
  output [1:0]i2s_addr;
  // GPIO
  inout [31:0]gpio_bd;
  // HDMI
  output [15:0]hdmi_data;
  output hdmi_data_e;
  output hdmi_hsync;
  output hdmi_out_clk;
  output hdmi_vsync;
  output spdif;
  inout iic_fmc_scl_io;
  inout iic_fmc_sda_io;
    // USB Overcurrent
  input otg_oc;

  wire [0:0]BCLK_O;
  wire [7:0]Blue;
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [7:0]Green;
  wire [0:0]LRCLK_O;
  wire [7:0]Red;
  wire [0:0]SDATA_I;
  wire [0:0]SDATA_O;
  wire [31:0] gpio_bd_tri_i;
  wire [31:0] gpio_bd_tri_o;
  wire [31:0] gpio_bd_tri_t;
  wire [15:0]hdmi_data;
  wire hdmi_data_e;
  wire hdmi_hsync;
  wire hdmi_out_clk;
  wire hdmi_vsync;
  wire hsync;
  wire [1:0]i2s_addr;
  wire iic_adau_scl_i;
  wire iic_adau_scl_io;
  wire iic_adau_scl_o;
  wire iic_adau_scl_t;
  wire iic_adau_sda_i;
  wire iic_adau_sda_io;
  wire iic_adau_sda_o;
  wire iic_adau_sda_t;
  wire iic_fmc_scl_i;
  wire iic_fmc_scl_io;
  wire iic_fmc_scl_o;
  wire iic_fmc_scl_t;
  wire iic_fmc_sda_i;
  wire iic_fmc_sda_io;
  wire iic_fmc_sda_o;
  wire iic_fmc_sda_t;
  wire otg_oc;
  wire spdif;
  wire vsync;

  ad_iobuf #(
    .DATA_WIDTH(32)
  ) i_iobuf_gen_gpio (
    .dio_t(gpio_bd_tri_t[31:0]),
    .dio_i(gpio_bd_tri_o[31:0]),
    .dio_o(gpio_bd_tri_i[31:0]),
    .dio_p(gpio_bd));
    
  IOBUF iic_adau_scl_iobuf
       (.I(iic_adau_scl_o),
        .IO(iic_adau_scl_io),
        .O(iic_adau_scl_i),
        .T(iic_adau_scl_t));
  IOBUF iic_adau_sda_iobuf
       (.I(iic_adau_sda_o),
        .IO(iic_adau_sda_io),
        .O(iic_adau_sda_i),
        .T(iic_adau_sda_t));
  
  IOBUF iic_fmc_scl_iobuf
       (.I(iic_fmc_scl_o),
        .IO(iic_fmc_scl_io),
        .O(iic_fmc_scl_i),
        .T(iic_fmc_scl_t));
  IOBUF iic_fmc_sda_iobuf
       (.I(iic_fmc_sda_o),
        .IO(iic_fmc_sda_io),
        .O(iic_fmc_sda_i),
        .T(iic_fmc_sda_t));
        
  system system_i
       (.BCLK_O(BCLK_O),
        .Blue(Blue),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .Green(Green),
        .LRCLK_O(LRCLK_O),
        .Red(Red),
        .SDATA_I(SDATA_I),
        .SDATA_O(SDATA_O),
        .i2s_mclk(i2s_mclk),
        .gpio_bd_tri_i(gpio_bd_tri_i),
        .gpio_bd_tri_o(gpio_bd_tri_o),
        .gpio_bd_tri_t(gpio_bd_tri_t),
        .hdmi_data(hdmi_data),
        .hdmi_data_e(hdmi_data_e),
        .hdmi_hsync(hdmi_hsync),
        .hdmi_out_clk(hdmi_out_clk),
        .hdmi_vsync(hdmi_vsync),
        .hsync(hsync),
        .i2s_addr(i2s_addr),
        .iic_adau_scl_i(iic_adau_scl_i),
        .iic_adau_scl_o(iic_adau_scl_o),
        .iic_adau_scl_t(iic_adau_scl_t),
        .iic_adau_sda_i(iic_adau_sda_i),
        .iic_adau_sda_o(iic_adau_sda_o),
        .iic_adau_sda_t(iic_adau_sda_t),
        .iic_fmc_scl_i(iic_fmc_scl_i),
        .iic_fmc_scl_o(iic_fmc_scl_o),
        .iic_fmc_scl_t(iic_fmc_scl_t),
        .iic_fmc_sda_i(iic_fmc_sda_i),
        .iic_fmc_sda_o(iic_fmc_sda_o),
        .iic_fmc_sda_t(iic_fmc_sda_t),
        .otg_oc(otg_oc),
        .spdif(spdif),
        .vsync(vsync));

assign Red_o = Red [7:4];
assign Green_o = Green [7:4];
assign Blue_o = Blue [7:4];
       
endmodule

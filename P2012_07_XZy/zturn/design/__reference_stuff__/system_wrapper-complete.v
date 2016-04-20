//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
//Date        : Wed Apr 20 08:57:32 2016
//Host        : fravbox running 64-bit Ubuntu 14.04.4 LTS
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
  // ZTURN on board circuitry
    iic_zturn_scl_io,
    iic_zturn_sda_io,
    MEMS_INTn,
    SW,
    BP,
    LEDR,
    LEDG,
    LEDB
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
  // ZTURN on board circuitry
  inout iic_zturn_scl_io;
  inout iic_zturn_sda_io;
  input MEMS_INTn;
  inout [3:0] SW;
  output BP;
  inout LEDR;
  inout LEDG;
  inout LEDB;

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
  wire MEMS_INTn;
  wire TEMP_INTn;
  wire iic_zturn_scl_i;
  wire iic_zturn_scl_io;
  wire iic_zturn_scl_o;
  wire iic_zturn_scl_t;
  wire iic_zturn_sda_i;
  wire iic_zturn_sda_io;
  wire iic_zturn_sda_o;
  wire iic_zturn_sda_t;
  wire [63:0] gpio_0_tri_i;
  wire [63:0] gpio_0_tri_o;
  wire [63:0] gpio_0_tri_t;
  wire [7:0] gpio_p;

  // ZTURN on board swithes
  assign gpio_p[3:0] = SW[3:0];

  // ZTURN on board RGB LED
  assign LEDR = gpio_p[4];
  assign LEDG = gpio_p[5];
  assign LEDB = gpio_p[6];

  // ZTURN on board BUZZER
  assign BP   = gpio_p[7];

  ad_iobuf #(
    .DATA_WIDTH(8) 
  ) gpio_buf (
      .dio_t(gpio_0_tri_t[63:56]),
      .dio_i(gpio_0_tri_o[63:56]),
      .dio_o(gpio_0_tri_i[63:56]),
      .dio_p(gpio_p));


  IOBUF iic_zturn_scl_iobuf
       (.I(iic_zturn_scl_o),
        .IO(iic_zturn_scl_io),
        .O(iic_zturn_scl_i),
        .T(iic_zturn_scl_t));
  IOBUF iic_zturn_sda_iobuf
       (.I(iic_zturn_sda_o),
        .IO(iic_zturn_sda_io),
        .O(iic_zturn_sda_i),
        .T(iic_zturn_sda_t));
        
  system system_i
       (.DDR_addr(DDR_addr),
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
        .GPIO_0_tri_i(gpio_0_tri_i),
        .GPIO_0_tri_o(gpio_0_tri_o),
        .GPIO_0_tri_t(gpio_0_tri_t),
        .IIC_ZTURN_scl_i(iic_zturn_scl_i),
        .IIC_ZTURN_scl_o(iic_zturn_scl_o),
        .IIC_ZTURN_scl_t(iic_zturn_scl_t),
        .IIC_ZTURN_sda_i(iic_zturn_sda_i),
        .IIC_ZTURN_sda_o(iic_zturn_sda_o),
        .IIC_ZTURN_sda_t(iic_zturn_sda_t),
        .MEMS_INTn(MEMS_INTn),
        .TEMP_INTn(MEMS_INTn));
endmodule

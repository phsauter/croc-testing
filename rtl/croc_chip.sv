// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Authors:
// - Philippe Sauter <phsauter@iis.ee.ethz.ch>

module croc_chip import croc_pkg::*; #() (
  input  wire clk_i,
  input  wire rst_ni,
  input  wire ref_clk_i,

  input  wire jtag_tck_i,
  input  wire jtag_trst_ni,
  input  wire jtag_tms_i,
  input  wire jtag_tdi_i,
  output wire jtag_tdo_o,

  input  wire uart_rx_i,
  output wire uart_tx_o,

  input  wire fetch_en_i,
  output wire status_o,

  inout  wire gpio0_io,
  inout  wire gpio1_io,
  inout  wire gpio2_io,
  inout  wire gpio3_io,
  inout  wire gpio4_io,
  inout  wire gpio5_io,
  inout  wire gpio6_io,
  inout  wire gpio7_io,
  inout  wire gpio8_io,
  inout  wire gpio9_io,
  inout  wire gpio10_io,
  inout  wire gpio11_io,
  inout  wire gpio12_io,
  inout  wire gpio13_io,
  inout  wire gpio14_io,
  inout  wire gpio15_io,
  inout  wire gpio16_io,
  inout  wire gpio17_io,
  inout  wire gpio18_io,
  inout  wire gpio19_io,
  inout  wire gpio20_io,
  inout  wire gpio21_io,
  inout  wire gpio22_io,
  inout  wire gpio23_io,
  inout  wire gpio24_io,
  inout  wire gpio25_io,
  inout  wire gpio26_io,
  inout  wire gpio27_io,
  inout  wire gpio28_io,
  inout  wire gpio29_io,
  inout  wire gpio30_io,
  inout  wire gpio31_io,
  output wire unused0_o,
  output wire unused1_o,
  output wire unused2_o,
  output wire unused3_o
); 
    logic soc_clk_i;
    logic soc_rst_ni;
    logic soc_ref_clk_i;
    logic soc_testmode;

    logic soc_jtag_tck_i;
    logic soc_jtag_trst_ni;
    logic soc_jtag_tms_i;
    logic soc_jtag_tdi_i;
    logic soc_jtag_tdo_o;

    logic soc_fetch_en_i;
    logic soc_status_o;

    localparam int unsigned GpioCount = 32;

    logic [GpioCount-1:0] soc_gpio_i;             
    logic [GpioCount-1:0] soc_gpio_o;            
    logic [GpioCount-1:0] soc_gpio_out_en_o; // Output enable signal; 0 -> input, 1 -> output

    // PBMUX Pad configurations
    // Signal pins
    // I:   Signal from core to pad output
    // C:   Signal from pad input to core
    // A:   Analog signal?
    // Config pins (inputs)
    // IE:  Input Enable
    // CS:  Input CMOS Schmitt-Triggered?
    // OE:  Output Enable
    // OD:  Open Drain
    // PU:  Pull-Up
    // PD:  Pull-Down
    // DS0: Drive Strength 0
    // DS1: Drive Strength 1

    P65_1233_PBMUX pad_clk_i        (.PAD(clk_i),        .C(soc_clk_i),        .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b0), .PD(1'b1), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_rst_ni       (.PAD(rst_ni),       .C(soc_rst_ni),       .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b0), .PD(1'b1), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_ref_clk_i    (.PAD(ref_clk_i),    .C(soc_ref_clk_i),    .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b0), .PD(1'b1), .DS0(1'b1), .DS1(1'b0), .A());
    assign soc_testmode_i = '0;

    P65_1233_PBMUX pad_jtag_tck_i   (.PAD(jtag_tck_i),   .C(soc_jtag_tck_i),   .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b0), .PD(1'b1), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_jtag_trst_ni (.PAD(jtag_trst_ni), .C(soc_jtag_trst_ni), .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b1), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_jtag_tms_i   (.PAD(jtag_tms_i),   .C(soc_jtag_tms_i),   .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b0), .PD(1'b1), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_jtag_tdi_i   (.PAD(jtag_tdi_i),   .C(soc_jtag_tdi_i),   .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b0), .PD(1'b1), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_jtag_tdo_o   (.PAD(jtag_tdo_o),   .I(soc_jtag_tdo_o),   .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .C(), .IE(1'b0), .CS(1'b1), .A());

    P65_1233_PBMUX pad_uart_rx_i    (.PAD(uart_rx_i),    .C(soc_uart_rx_i),    .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b1), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_uart_tx_o    (.PAD(uart_tx_o),    .I(soc_uart_tx_o),    .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .C(), .IE(1'b0), .CS(1'b1), .A());

    P65_1233_PBMUX pad_fetch_en_i   (.PAD(fetch_en_i),   .C(soc_fetch_en_i),   .IE(1'b1), .CS(1'b1), .I(1'b0), .OE(1'b0), .OD(1'b0), .PU(1'b0), .PD(1'b1), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_status_o     (.PAD(status_o),     .I(soc_status_o),     .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .C(), .IE(1'b0), .CS(1'b1), .A());

    P65_1233_PBMUX pad_gpio0_io     (.PAD(gpio0_io),     .C(soc_gpio_i[0]),  .IE(~soc_gpio_out_en_o[0]),  .CS(1'b1), .I(soc_gpio_o[0]),  .OE(soc_gpio_out_en_o[0]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio1_io     (.PAD(gpio1_io),     .C(soc_gpio_i[1]),  .IE(~soc_gpio_out_en_o[1]),  .CS(1'b1), .I(soc_gpio_o[1]),  .OE(soc_gpio_out_en_o[1]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio2_io     (.PAD(gpio2_io),     .C(soc_gpio_i[2]),  .IE(~soc_gpio_out_en_o[2]),  .CS(1'b1), .I(soc_gpio_o[2]),  .OE(soc_gpio_out_en_o[2]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio3_io     (.PAD(gpio3_io),     .C(soc_gpio_i[3]),  .IE(~soc_gpio_out_en_o[3]),  .CS(1'b1), .I(soc_gpio_o[3]),  .OE(soc_gpio_out_en_o[3]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio4_io     (.PAD(gpio4_io),     .C(soc_gpio_i[4]),  .IE(~soc_gpio_out_en_o[4]),  .CS(1'b1), .I(soc_gpio_o[4]),  .OE(soc_gpio_out_en_o[4]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio5_io     (.PAD(gpio5_io),     .C(soc_gpio_i[5]),  .IE(~soc_gpio_out_en_o[5]),  .CS(1'b1), .I(soc_gpio_o[5]),  .OE(soc_gpio_out_en_o[5]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio6_io     (.PAD(gpio6_io),     .C(soc_gpio_i[6]),  .IE(~soc_gpio_out_en_o[6]),  .CS(1'b1), .I(soc_gpio_o[6]),  .OE(soc_gpio_out_en_o[6]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio7_io     (.PAD(gpio7_io),     .C(soc_gpio_i[7]),  .IE(~soc_gpio_out_en_o[7]),  .CS(1'b1), .I(soc_gpio_o[7]),  .OE(soc_gpio_out_en_o[7]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio8_io     (.PAD(gpio8_io),     .C(soc_gpio_i[8]),  .IE(~soc_gpio_out_en_o[8]),  .CS(1'b1), .I(soc_gpio_o[8]),  .OE(soc_gpio_out_en_o[8]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio9_io     (.PAD(gpio9_io),     .C(soc_gpio_i[9]),  .IE(~soc_gpio_out_en_o[9]),  .CS(1'b1), .I(soc_gpio_o[9]),  .OE(soc_gpio_out_en_o[9]),  .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio10_io    (.PAD(gpio10_io),    .C(soc_gpio_i[10]), .IE(~soc_gpio_out_en_o[10]), .CS(1'b1), .I(soc_gpio_o[10]), .OE(soc_gpio_out_en_o[10]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio11_io    (.PAD(gpio11_io),    .C(soc_gpio_i[11]), .IE(~soc_gpio_out_en_o[11]), .CS(1'b1), .I(soc_gpio_o[11]), .OE(soc_gpio_out_en_o[11]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio12_io    (.PAD(gpio12_io),    .C(soc_gpio_i[12]), .IE(~soc_gpio_out_en_o[12]), .CS(1'b1), .I(soc_gpio_o[12]), .OE(soc_gpio_out_en_o[12]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio13_io    (.PAD(gpio13_io),    .C(soc_gpio_i[13]), .IE(~soc_gpio_out_en_o[13]), .CS(1'b1), .I(soc_gpio_o[13]), .OE(soc_gpio_out_en_o[13]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio14_io    (.PAD(gpio14_io),    .C(soc_gpio_i[14]), .IE(~soc_gpio_out_en_o[14]), .CS(1'b1), .I(soc_gpio_o[14]), .OE(soc_gpio_out_en_o[14]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio15_io    (.PAD(gpio15_io),    .C(soc_gpio_i[15]), .IE(~soc_gpio_out_en_o[15]), .CS(1'b1), .I(soc_gpio_o[15]), .OE(soc_gpio_out_en_o[15]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio16_io    (.PAD(gpio16_io),    .C(soc_gpio_i[16]), .IE(~soc_gpio_out_en_o[16]), .CS(1'b1), .I(soc_gpio_o[16]), .OE(soc_gpio_out_en_o[16]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio17_io    (.PAD(gpio17_io),    .C(soc_gpio_i[17]), .IE(~soc_gpio_out_en_o[17]), .CS(1'b1), .I(soc_gpio_o[17]), .OE(soc_gpio_out_en_o[17]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio18_io    (.PAD(gpio18_io),    .C(soc_gpio_i[18]), .IE(~soc_gpio_out_en_o[18]), .CS(1'b1), .I(soc_gpio_o[18]), .OE(soc_gpio_out_en_o[18]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio19_io    (.PAD(gpio19_io),    .C(soc_gpio_i[19]), .IE(~soc_gpio_out_en_o[19]), .CS(1'b1), .I(soc_gpio_o[19]), .OE(soc_gpio_out_en_o[19]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio20_io    (.PAD(gpio20_io),    .C(soc_gpio_i[20]), .IE(~soc_gpio_out_en_o[20]), .CS(1'b1), .I(soc_gpio_o[20]), .OE(soc_gpio_out_en_o[20]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio21_io    (.PAD(gpio21_io),    .C(soc_gpio_i[21]), .IE(~soc_gpio_out_en_o[21]), .CS(1'b1), .I(soc_gpio_o[21]), .OE(soc_gpio_out_en_o[21]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio22_io    (.PAD(gpio22_io),    .C(soc_gpio_i[22]), .IE(~soc_gpio_out_en_o[22]), .CS(1'b1), .I(soc_gpio_o[22]), .OE(soc_gpio_out_en_o[22]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio23_io    (.PAD(gpio23_io),    .C(soc_gpio_i[23]), .IE(~soc_gpio_out_en_o[23]), .CS(1'b1), .I(soc_gpio_o[23]), .OE(soc_gpio_out_en_o[23]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio24_io    (.PAD(gpio24_io),    .C(soc_gpio_i[24]), .IE(~soc_gpio_out_en_o[24]), .CS(1'b1), .I(soc_gpio_o[24]), .OE(soc_gpio_out_en_o[24]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio25_io    (.PAD(gpio25_io),    .C(soc_gpio_i[25]), .IE(~soc_gpio_out_en_o[25]), .CS(1'b1), .I(soc_gpio_o[25]), .OE(soc_gpio_out_en_o[25]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio26_io    (.PAD(gpio26_io),    .C(soc_gpio_i[26]), .IE(~soc_gpio_out_en_o[26]), .CS(1'b1), .I(soc_gpio_o[26]), .OE(soc_gpio_out_en_o[26]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio27_io    (.PAD(gpio27_io),    .C(soc_gpio_i[27]), .IE(~soc_gpio_out_en_o[27]), .CS(1'b1), .I(soc_gpio_o[27]), .OE(soc_gpio_out_en_o[27]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio28_io    (.PAD(gpio28_io),    .C(soc_gpio_i[28]), .IE(~soc_gpio_out_en_o[28]), .CS(1'b1), .I(soc_gpio_o[28]), .OE(soc_gpio_out_en_o[28]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio29_io    (.PAD(gpio29_io),    .C(soc_gpio_i[29]), .IE(~soc_gpio_out_en_o[29]), .CS(1'b1), .I(soc_gpio_o[29]), .OE(soc_gpio_out_en_o[29]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio30_io    (.PAD(gpio30_io),    .C(soc_gpio_i[30]), .IE(~soc_gpio_out_en_o[30]), .CS(1'b1), .I(soc_gpio_o[30]), .OE(soc_gpio_out_en_o[30]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_gpio31_io    (.PAD(gpio31_io),    .C(soc_gpio_i[31]), .IE(~soc_gpio_out_en_o[31]), .CS(1'b1), .I(soc_gpio_o[31]), .OE(soc_gpio_out_en_o[31]), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .A());
    P65_1233_PBMUX pad_unused0_o    (.PAD(unused0_o),    .I(soc_status_o), .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .C(), .IE(1'b0), .CS(1'b1), .A());
    P65_1233_PBMUX pad_unused1_o    (.PAD(unused1_o),    .I(soc_status_o), .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .C(), .IE(1'b0), .CS(1'b1), .A());
    P65_1233_PBMUX pad_unused2_o    (.PAD(unused2_o),    .I(soc_status_o), .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .C(), .IE(1'b0), .CS(1'b1), .A());
    P65_1233_PBMUX pad_unused3_o    (.PAD(unused3_o),    .I(soc_status_o), .OE(1'b1), .OD(1'b0), .PU(1'b0), .PD(1'b0), .DS0(1'b1), .DS1(1'b0), .C(), .IE(1'b0), .CS(1'b1), .A());

    (* dont_touch = "true" *)P65_1233_VDD3 pad_vdd0();
    (* dont_touch = "true" *)P65_1233_VDD3 pad_vdd1();
    (* dont_touch = "true" *)P65_1233_VDD3 pad_vdd2();
    (* dont_touch = "true" *)P65_1233_VDD3 pad_vdd3();

    (* dont_touch = "true" *)P65_1233_VSS3 pad_vss0();
    (* dont_touch = "true" *)P65_1233_VSS3 pad_vss1();
    (* dont_touch = "true" *)P65_1233_VSS3 pad_vss2();
    (* dont_touch = "true" *)P65_1233_VSS3 pad_vss3();

    (* dont_touch = "true" *)P65_1233_VDDIO3 pad_vddio0();
    (* dont_touch = "true" *)P65_1233_VDDIO3 pad_vddio1();
    (* dont_touch = "true" *)P65_1233_VDDIO3 pad_vddio2();
    (* dont_touch = "true" *)P65_1233_VDDIO3 pad_vddio3();

    (* dont_touch = "true" *)P65_1233_VSSIO3 pad_vssio0();
    (* dont_touch = "true" *)P65_1233_VSSIO3 pad_vssio1();
    (* dont_touch = "true" *)P65_1233_VSSIO3 pad_vssio2();
    (* dont_touch = "true" *)P65_1233_VSSIO3 pad_vssio3();

  croc_soc #(
    .GpioCount( GpioCount )
  )
  i_croc_soc (
    .clk_i          ( soc_clk_i      ),
    .rst_ni         ( soc_rst_ni     ),
    .ref_clk_i      ( soc_ref_clk_i  ),
    .testmode_i     ( soc_testmode_i ),
    .fetch_en_i     ( soc_fetch_en_i ),
    .status_o       ( soc_status_o   ),

    .jtag_tck_i     ( soc_jtag_tck_i   ),
    .jtag_tdi_i     ( soc_jtag_tdi_i   ),
    .jtag_tdo_o     ( soc_jtag_tdo_o   ),
    .jtag_tms_i     ( soc_jtag_tms_i   ),
    .jtag_trst_ni   ( soc_jtag_trst_ni ),

    .uart_rx_i      ( soc_uart_rx_i ),
    .uart_tx_o      ( soc_uart_tx_o ),

    .gpio_i         ( soc_gpio_i        ),             
    .gpio_o         ( soc_gpio_o        ),            
    .gpio_out_en_o  ( soc_gpio_out_en_o )
  );

endmodule

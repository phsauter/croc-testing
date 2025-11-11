// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Authors:
// - Thomas Benz <tbenz@iis.ee.ethz.ch>
// - Tobias Senti <tsenti@student.ethz.ch>
// - Paul Scheffler <paulsc@iis.ee.ethz.ch>

module tc_sram_blackbox #(
  parameter int unsigned NumWords     = 32'd0,
  parameter int unsigned DataWidth    = 32'd0,
  parameter int unsigned ByteWidth    = 32'd0,
  parameter int unsigned NumPorts     = 32'd0,
  parameter int unsigned Latency      = 32'd0,
  parameter              SimInit      = "none",
  parameter bit          PrintSimCfg  = 1'b0,
  parameter              ImplKey      = "none"
) ();
endmodule

// one tie-off per macro to avoid port size mismatch warnings
`define IHP13_TC_SRAM_64x64_TIEOFF \
  .A_BIST_CLK   (  1'b0 ), \
  .A_BIST_ADDR  (  6'd0 ), \
  .A_BIST_DIN   ( 64'd0 ), \
  .A_BIST_BM    ( 64'd0 ), \
  .A_BIST_MEN   (  1'b0 ), \
  .A_BIST_WEN   (  1'b0 ), \
  .A_BIST_REN   (  1'b0 ), \
  .A_BIST_EN    (  1'b0 )

`define IHP13_TC_SRAM_256x64_TIEOFF \
  .A_BIST_CLK   (  1'b0 ), \
  .A_BIST_ADDR  (  8'd0 ), \
  .A_BIST_DIN   ( 64'd0 ), \
  .A_BIST_BM    ( 64'd0 ), \
  .A_BIST_MEN   (  1'b0 ), \
  .A_BIST_WEN   (  1'b0 ), \
  .A_BIST_REN   (  1'b0 ), \
  .A_BIST_EN    (  1'b0 )

`define IHP13_TC_SRAM_512x64_TIEOFF \
  .A_BIST_CLK   (  1'b0 ), \
  .A_BIST_ADDR  (  9'd0 ), \
  .A_BIST_DIN   ( 64'd0 ), \
  .A_BIST_BM    ( 64'd0 ), \
  .A_BIST_MEN   (  1'b0 ), \
  .A_BIST_WEN   (  1'b0 ), \
  .A_BIST_REN   (  1'b0 ), \
  .A_BIST_EN    (  1'b0 )

`define IHP13_TC_SRAM_1024x64_TIEOFF \
  .A_BIST_CLK   (  1'b0 ), \
  .A_BIST_ADDR  ( 10'd0 ), \
  .A_BIST_DIN   ( 64'd0 ), \
  .A_BIST_BM    ( 64'd0 ), \
  .A_BIST_MEN   (  1'b0 ), \
  .A_BIST_WEN   (  1'b0 ), \
  .A_BIST_REN   (  1'b0 ), \
  .A_BIST_EN    (  1'b0 )

`define IHP13_TC_SRAM_2048x64_TIEOFF \
  .A_BIST_CLK   (  1'b0 ), \
  .A_BIST_ADDR  ( 11'd0 ), \
  .A_BIST_DIN   ( 64'd0 ), \
  .A_BIST_BM    ( 64'd0 ), \
  .A_BIST_MEN   (  1'b0 ), \
  .A_BIST_WEN   (  1'b0 ), \
  .A_BIST_REN   (  1'b0 ), \
  .A_BIST_EN    (  1'b0 )

module tc_sram_impl #(
  parameter int unsigned NumWords     = 32'd1024,
  parameter int unsigned DataWidth    = 32'd128,
  parameter int unsigned ByteWidth    = 32'd8,
  parameter int unsigned NumPorts     = 32'd2,
  parameter int unsigned Latency      = 32'd1,
  parameter              SimInit      = "none",
  parameter bit          PrintSimCfg  = 1'b0,
  parameter              ImplKey      = "none",
  parameter type         impl_in_t    = logic,
  parameter type         impl_out_t   = logic,
  parameter impl_out_t   ImplOutSim   = 'X,
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth,
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,

  input  impl_in_t             impl_i,
  output impl_out_t            impl_o,

  input  logic  [NumPorts-1:0] req_i,
  input  logic  [NumPorts-1:0] we_i,
  input  addr_t [NumPorts-1:0] addr_i,
  input  data_t [NumPorts-1:0] wdata_i,
  input  be_t   [NumPorts-1:0] be_i,

  output data_t [NumPorts-1:0] rdata_o
);
  // We drive a static value for `impl_o` in behavioral simulation.
  assign impl_o = ImplOutSim;

  // Generate desired cuts

  `ifndef SYNTHESIS
    initial $fatal("No tc_sram for %m: NumWords %0d, DataWidth %0d NumPorts %0d, Latency %0d",
        NumWords, DataWidth, NumPorts);
  `endif

  // Instantiate a non-linkable blackbox with parameters for debugging
  `ifdef SYNTHESIS
    (* dont_touch = "true" *)
    tc_sram_blackbox #(
      .NumWords     ( NumWords    ),
      .DataWidth    ( DataWidth   ),
      .ByteWidth    ( ByteWidth   ),
      .NumPorts     ( NumPorts    ),
      .Latency      ( Latency     ),
      .SimInit      ( SimInit     ),
      .PrintSimCfg  ( PrintSimCfg ),
      .ImplKey      ( ImplKey     )
    ) i_sram_blackbox ();
  `endif

endmodule

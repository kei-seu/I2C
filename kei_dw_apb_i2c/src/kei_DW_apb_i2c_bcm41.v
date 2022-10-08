
//  ------------------------------------------------------------------------
//
//                    (C) COPYRIGHT 2003 - 2018 SYNOPSYS, INC.
//                            ALL RIGHTS RESERVED
//
//  This software and the associated documentation are confidential and
//  proprietary to Synopsys, Inc.  Your use or disclosure of this
//  software is subject to the terms and conditions of a written
//  license agreement between you, or your company, and Synopsys, Inc.
//
// The entire notice above must be reproduced on all authorized copies.
//
// Component Name   : DW_apb_i2c
// Component Version: 2.02a
// Release Type     : GA
//  ------------------------------------------------------------------------

//
// Filename    : DW_apb_i2c_bcm41.v
// Revision    : $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_bcm41.v#5 $
// Author      : Rick Kelly         8/28/12
// Description : DW_apb_i2c_bcm41.v Verilog module for DW_apb_i2c
//
// DesignWare IP ID: ea00bd45
//
////////////////////////////////////////////////////////////////////////////////


module kei_DW_apb_i2c_bcm41 (
    clk_d,
    rst_d_n,
    data_s,
    data_d
    );

parameter WIDTH        = 1;  // RANGE 1 to 1024
parameter RST_VAL      = -1; // RANGE -1 to 2147483647
parameter F_SYNC_TYPE  = 2;  // RANGE 0 to 4
parameter VERIF_EN     = 1;  // RANGE 0 to 5
parameter SVA_TYPE     = 1;  // RANGE 0 to 2

// spyglass disable_block ParamWidthMismatch-ML
// SMD: Parameter width does not match with the value assigned
// SJ: The legal value of RHS parameter cannot exceed the range that the LHS parameter can represent.  Even though there is a width mismatch, no information is lost in the assignment.
// spyglass disable_block W163
// SMD: Truncation of bits in constant integer conversion
// SJ: In some case, sized local parameters are used to convert to the needed vector widths internally.  This may truncate bits of integers on the RHS which is intentional.
localparam [WIDTH-1 : 0] RST_POLARITY = RST_VAL;
// spyglass enable_block ParamWidthMismatch-ML
// spyglass enable_block W163

input                   clk_d;      // clock input from destination domain
input                   rst_d_n;    // active low asynchronous reset from destination domain
input  [WIDTH-1:0]      data_s;     // data to be synchronized from source domain
output [WIDTH-1:0]      data_d;     // data synchronized to destination domain

wire   [WIDTH-1:0]      data_s_int;
wire   [WIDTH-1:0]      data_d_int;

  assign data_s_int = data_s ^ RST_POLARITY;

// spyglass disable_block SelfDeterminedExpr-ML
// SMD: Self determined expression found
// SJ: The integer value of a parameter, that starts in the range of 0-4, is incremented by 8 through design hierarchy.  The depth of the hierarchy never reaches levels that cause the parameter value to exceed the bounds of a 32-bit integer.
  kei_DW_apb_i2c_bcm21
   #(WIDTH, F_SYNC_TYPE+8, VERIF_EN, SVA_TYPE) U_SYNC (
// spyglass enable_block SelfDeterminedExpr-ML
      .clk_d(clk_d),
      .rst_d_n(rst_d_n),
      .data_s(data_s_int),
      .data_d(data_d_int)
      );

  assign data_d = data_d_int ^ RST_POLARITY;

endmodule

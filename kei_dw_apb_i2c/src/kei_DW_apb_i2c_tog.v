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
// Release version :  2.02a
// File Version     :        $Revision: #1 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_tog.v#1 $ 
//
//
// File    : DW_apb_i2c_tog.v
//
//
// Author  : Madhusudhan Prabhu
// Created : Thu Nov 05 00:54:48 IST 2015
// Abstract: The toggle module is used for generating toggle signal of its input. This is used for
//           avoiding the scenario in which the same file has the logic corresponding 
//           to two clocks i.e. pclk and ic_clk.
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------


module kei_DW_apb_i2c_tog (
    clk,
    resetn,
    tog_data_in,
    tog_data_out
);

input  clk;
input  resetn;
input  tog_data_in;
output tog_data_out;

  reg  tog_data_out;

  always @(posedge clk or negedge resetn)
  begin : i2c_tog_PROC
    if (resetn == 1'b0) begin
      tog_data_out <= 1'b0;
    end else begin
      if (tog_data_in == 1'b1) 
      tog_data_out <= ~tog_data_out;
    end
  end

endmodule



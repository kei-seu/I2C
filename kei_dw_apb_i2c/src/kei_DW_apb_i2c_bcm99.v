
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
// Filename    : DW_apb_i2c_bcm99.v
// Revision    : $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_bcm99.v#3 $
// Author      : Liming SU    06/19/15
// Description : DW_apb_i2c_bcm99.v Verilog module for DW_apb_i2c
//
// DesignWare IP ID: ace7615a
//
////////////////////////////////////////////////////////////////////////////////

module kei_DW_apb_i2c_bcm99 (
  clk_d,
  rst_d_n,
  data_s,
  data_d
);

parameter ACCURATE_MISSAMPLING = 0; // RANGE 0 to 1

input  clk_d;      // clock input from destination domain
input  rst_d_n;    // active low asynchronous reset from destination domain
input  data_s;     // data to be synchronized from source domain
output data_d;     // data synchronized to destination domain

`ifdef SYNTHESIS
//######################### NOTE ABOUT TECHNOLOGY CELL MAPPING ############################
// Replace code between "DOUBLE FF SYNCHRONIZER BEGIN" and "DOUBLE FF SYNCHRONIZER END"
// with one of the following two options of customized register cell(s):
//   Option 1: One instance of a 2-FF cell
//     Macro cell must have an instance name of "sample_meta".
//
//     Example: (TECH_SYNC_2FF is example name of a synchronizer macro cell found in a technology library)
//         TECH_SYNC_2FF sample_meta ( .D(data_s), .CP(clk_d), .RSTN(rst_d_n), .Q(data_d) );
//     
//   Option 2: Two instances of single-FF cells connected serially 
//     The first stage synchronizer cell must have an instance name of "sample_meta".
//     The second stage synchronizer cell must have an instance name of "sample_syncl".
//
//     Example: (in GTECH)
//         wire n9;
//         GTECH_FD2 sample_meta ( .D(data_s), .CP(clk_d), .CD(rst_d_n), .Q(n9) );
//         GTECH_FD2 sample_syncl ( .D(n9), .CP(clk_d), .CD(rst_d_n), .Q(data_d) );
//
//####################### END NOTE ABOUT TECHNOLOGY CELL MAPPING ##########################
// DOUBLE FF SYNCHRONIZER BEGIN
  reg sample_meta;
  reg sample_syncl;
  always @(posedge clk_d or negedge rst_d_n) begin : a1000_PROC
    if (!rst_d_n) begin
      sample_meta <= 1'b0;
      sample_syncl <= 1'b0;
    end else begin
      sample_meta <= data_s;
      sample_syncl <= sample_meta;
    end
  end
  assign data_d = sample_syncl;
// DOUBLE FF SYNCHRONIZER END
`else
  `ifndef DW_MODEL_MISSAMPLES
//#####################################################################################
// NOTE: This section is for zero-time delay functional simulation
//#####################################################################################
  reg sample_meta;
  reg sample_syncl;
  always @(posedge clk_d or negedge rst_d_n) begin : a1001_PROC
    if (!rst_d_n) begin
      sample_meta <= 1'b0;
      sample_syncl <= 1'b0;
    end else begin
      sample_meta <= data_s;
      sample_syncl <= sample_meta;
    end
  end
  assign data_d = sample_syncl;
  `else
  localparam WIDTH = 1;


  `ifdef DW_MODEL_MISSAMPLES


// { START Latency Accurate modeling
  initial begin : set_setup_hold_delay_PROC
    `ifndef DW_HOLD_MUX_DELAY
      `define DW_HOLD_MUX_DELAY  1
      if (ACCURATE_MISSAMPLING == 1)
        $display("Information: %m: *** Warning: `DW_HOLD_MUX_DELAY is not defined so it is being set to: %0d ***", `DW_HOLD_MUX_DELAY);
    `endif

    `ifndef DW_SETUP_MUX_DELAY
      `define DW_SETUP_MUX_DELAY  1
      if (ACCURATE_MISSAMPLING == 1)
        $display("Information: %m: *** Warning: `DW_SETUP_MUX_DELAY is not defined so it is being set to: %0d ***", `DW_SETUP_MUX_DELAY);
    `endif
  end // set_setup_hold_delay_PROC


  reg [WIDTH-1:0] setup_mux_ctrl, hold_mux_ctrl;
  initial setup_mux_ctrl = {WIDTH{1'b0}};
  initial hold_mux_ctrl  = {WIDTH{1'b0}};
  
  wire [WIDTH-1:0] data_s_q;
  reg clk_d_q;
  initial clk_d_q = 1'b0;
  reg [WIDTH-1:0] setup_mux_out, d_muxout;
  reg [WIDTH-1:0] d_ff1, d_ff2;
  integer i,j,k;
  
  
  //Delay the destination clock
  always @ (posedge clk_d)
  #`DW_HOLD_MUX_DELAY clk_d_q = 1'b1;

  always @ (negedge clk_d)
  #`DW_HOLD_MUX_DELAY clk_d_q = 1'b0;
  
  //Delay the source data
  assign #`DW_SETUP_MUX_DELAY data_s_q = (!rst_d_n) ? {WIDTH{1'b0}}:data_s;

  //setup_mux_ctrl controls the data entering the flip flop 
  always @ (data_s or data_s_q or setup_mux_ctrl) begin
    for (i=0;i<=WIDTH-1;i=i+1) begin
      if (setup_mux_ctrl[i])
        setup_mux_out[i] = data_s_q[i];
      else
        setup_mux_out[i] = data_s;
    end
  end

  always @ (posedge clk_d_q or negedge rst_d_n) begin
    if (rst_d_n == 1'b0)
      d_ff2 <= {WIDTH{1'b0}};
    else
      d_ff2 <= setup_mux_out;
  end

  always @ (posedge clk_d or negedge rst_d_n) begin
    if (rst_d_n == 1'b0) begin
      d_ff1          <= {WIDTH{1'b0}};
      setup_mux_ctrl <= {WIDTH{1'b0}};
      hold_mux_ctrl  <= {WIDTH{1'b0}};
    end
    else begin
      d_ff1          <= setup_mux_out;
    `ifdef DWC_BCM_SV
      setup_mux_ctrl <= $urandom;  //randomize mux_ctrl
      hold_mux_ctrl  <= $urandom;  //randomize mux_ctrl
    `else
      setup_mux_ctrl <= $random;  //randomize mux_ctrl
      hold_mux_ctrl  <= $random;  //randomize mux_ctrl
    `endif
    end
  end


//hold_mux_ctrl decides the clock triggering the flip-flop
always @(hold_mux_ctrl or d_ff2 or d_ff1) begin
      for (k=0;k<=WIDTH-1;k=k+1) begin
        if (hold_mux_ctrl[k])
          d_muxout[k] = d_ff2[k];
        else
          d_muxout[k] = d_ff1[k];
      end
end
// END Latency Accurate modeling }


 //Assertions
`ifdef DWC_BCM_SNPS_ASSERT_ON
`ifndef SYNTHESIS
generate if (ACCURATE_MISSAMPLING==1) begin : GEN_ASSERT_FST2_VE5
  sequence p_num_d_chng;
  @ (posedge clk_d) 1'b1 ##0 (data_s != d_ff1); //Number of times input data changed
  endsequence
  
  sequence p_num_d_chng_hmux1;
  @ (posedge clk_d) 1'b1 ##0 ((data_s != d_ff1) && (|(hold_mux_ctrl & (data_s ^ d_ff1)))); //Number of times hold_mux_ctrl was asserted when the input data changed
  endsequence
  
  sequence p_num_d_chng_smux1;
  @ (posedge clk_d) 1'b1 ##0 ((data_s != d_ff1) && (|(setup_mux_ctrl & (data_s ^ d_ff1)))); //Number of times setup_mux_ctrl was asserted when the input data changed
  endsequence
  
  sequence p_hold_vio;
  reg [WIDTH-1:0]temp_var, temp_var1;
  @ (posedge clk_d) (((data_s != d_ff1) && (|(hold_mux_ctrl & (data_s ^ d_ff1)))), temp_var = data_s, temp_var1 =(hold_mux_ctrl & (data_s ^ d_ff1))) ##1 ((data_d & temp_var1) == (temp_var & temp_var1));
          //Number of times output data was advanced due to hold violation
  endsequence
  
  sequence p_setup_vio;
  reg [WIDTH-1:0]temp_var, temp_var1;
  @ (posedge clk_d) (((data_s != d_ff1) && (|(setup_mux_ctrl & (data_s ^ d_ff1)))), temp_var = data_s, temp_var1 =(setup_mux_ctrl & (data_s ^ d_ff1))) ##2 ((data_d & temp_var1) != (temp_var & temp_var1));
          //Number of times output data was delayed due to setup violation
  endsequence

  cp_num_d_chng           : cover property  (p_num_d_chng);    
  cp_num_d_chng_hld_mux1  : cover property  (p_num_d_chng_hmux1);
  cp_num_d_chng_set_mux1  : cover property  (p_num_d_chng_smux1);
  cp_hold_vio             : cover property  (p_hold_vio);
  cp_setup_vio            : cover property  (p_setup_vio);        
 end
endgenerate
`endif // SYNTHESIS
`endif // DWC_BCM_SNPS_ASSERT_ON

  `endif

  generate if (ACCURATE_MISSAMPLING == 1) begin : GEN_DATA_PRE_AM_EQ_1
    reg sample_syncl;
    always @(posedge clk_d or negedge rst_d_n) begin : a1002_PROC
      if (!rst_d_n)
        sample_syncl <= 1'b0;
      else
        sample_syncl <= d_muxout;
    end
    assign data_d = sample_syncl;
  end else begin : GEN_DATA_PRE_AM_EQ_0
    reg sample_meta;
    reg sample_syncl;
    always @(posedge clk_d or negedge rst_d_n) begin : a1003_PROC
      if (!rst_d_n) begin
        sample_meta  <= 1'b0;
        sample_syncl <= 1'b0;
      end else begin
        sample_meta  <= data_s;
        sample_syncl <= sample_meta;
      end
    end
    assign data_d = sample_syncl;
  end endgenerate
  `endif
`endif

endmodule


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
// Filename    : DW_apb_i2c_bcm47.v
// Revision    : $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_bcm47.v#5 $
// Author      : Bruce Dean      May 01, 2004
// Description : DW_apb_i2c_bcm47.v Verilog module for DW_apb_i2c
//
// DesignWare IP ID: ddf794e1
//
////////////////////////////////////////////////////////////////////////////////
module kei_DW_apb_i2c_bcm47 (
     clk,         
     rst_n,       
     init_n,      
     enable,      
     drain,       
     ld_crc_n,    
     data_in,     
     crc_in,      
     draining,    
     drain_done,  
     crc_ok,      
     data_out,    
     crc_out     
    );
    
parameter DATA_WIDTH = 16;
parameter POLY_SIZE  = 16;
parameter CRC_CFG    = 7;
parameter BIT_ORDER  = 3;
parameter POLY_COEF0 = 4129;
parameter POLY_COEF1 = 0;
parameter POLY_COEF2 = 0;
parameter POLY_COEF3 = 0;

localparam              ODD_WIDTH_OFFSET = ((DATA_WIDTH & 1) == 1)? DATA_WIDTH : 0;
localparam              POLY_2_DATA_RATIO = POLY_SIZE/DATA_WIDTH;
localparam [ 4 : 0]     INITIAL_POINTER   = POLY_SIZE/DATA_WIDTH;

localparam [63 : 0] tp =                ((POLY_COEF3 & 65535) << 48) +
                                        ((POLY_COEF2 & 65535) << 32) +
                                        ((POLY_COEF1 & 65535) << 16) +
                                         (POLY_COEF0 & 65535);

   
input                  clk;       
input                  rst_n;     
input                  init_n;    
input                  enable;    
input                  drain;     
input                  ld_crc_n; 
input [DATA_WIDTH-1:0] data_in;  
input [POLY_SIZE-1:0]  crc_in;   
   
output                  draining;     
output                  drain_done;   
output                  crc_ok;
output [DATA_WIDTH-1:0] data_out;
output [POLY_SIZE-1:0]  crc_out;

reg [4:0]   data_pointer;

reg                   drain_done_next;
reg                   crc_ok_int;
reg                   drain_done_int;
reg                   draining_status;
reg                   draining_status_next;

reg  [DATA_WIDTH-1:0] data_out_next;
reg  [DATA_WIDTH-1:0] data_out_int;

wire [POLY_SIZE-1:0]  crc_out_int;
reg  [POLY_SIZE-1:0]  crc_out_rg;
reg  [POLY_SIZE-1:0]  crc_out_next;
reg  [POLY_SIZE-1:0]  crc_out_temp;

wire                  crc_ok_result;

wire [4:0]   data_pointer_next;
wire [3:0]   data_pointer_minus_1;

wire [DATA_WIDTH-1:0] crc_drn_dat;
wire [DATA_WIDTH-1:0] data_in_ro;
wire [DATA_WIDTH-1:0] crc_xor_res;
wire [DATA_WIDTH-1:0] crc_ins_mask;
wire [DATA_WIDTH-1:0] crc_xord_swaped; 

wire [POLY_SIZE-1:0]  crc_result;
wire [POLY_SIZE-1:0]  crc_out_next_shifted;
wire [POLY_SIZE-1:0]  crc_ok_remn;
wire [POLY_SIZE-1:0]  crc_xor_constant;
wire [POLY_SIZE-1:0]  reset_crc_reg;

  // This function generates the remainder
  // to be used in the crc ok generation
  function [POLY_SIZE-1:0] gen_crc_rem;
   input [POLY_SIZE-1:0]  crc_xor_constant;
   begin : FUNC_CRC_OK_NFO 
    reg [POLY_SIZE-1:0]  int_ok_calc;
    reg                  xor_or_not;
    integer              i;
    int_ok_calc = crc_xor_constant;
    for(i = 0; i < POLY_SIZE; i = i + 1) begin 
      xor_or_not  = int_ok_calc[(POLY_SIZE-1)];
      int_ok_calc = { int_ok_calc[((POLY_SIZE-1)- 1):0], 1'b0};
      if(xor_or_not == 1'b1)
       int_ok_calc = (int_ok_calc ^ tp[POLY_SIZE-1:0]);
     end
     
     gen_crc_rem = int_ok_calc;
    end
   endfunction


   // This function caculates the crc on a data word sized chunk
   // by checking if the msb is a one, and iff then xor the data
   // with the crc polynomial from the parameters
   function [POLY_SIZE-1:0] fcalc_crc;
    input [DATA_WIDTH-1:0] data_ro_in;
    input [POLY_SIZE-1:0]  crc_fb_data;
    input                  draining_status;
    begin : FUNC_CALC_CRC
     reg [DATA_WIDTH-1:0] fdata_in;
     reg [POLY_SIZE-1:0]  crc_data;
     reg                  xor_or_not;
     integer              i;
     crc_data  = crc_fb_data ;
     fdata_in  = data_ro_in;
     for (i = 0;i < DATA_WIDTH; i = i + 1 ) begin 
// spyglass disable_block SelfDeterminedExpr-ML
// SMD: Self determined expression found
// SJ: The expression indexing the vector/array will never exceed the bound of the vector/array.
       xor_or_not = !draining_status & (fdata_in[(DATA_WIDTH-1) - i]
                                       ^ crc_data[(POLY_SIZE-1)]);
// spyglass enable_block SelfDeterminedExpr-ML
       if(xor_or_not == 1'b1)
        crc_data = ({crc_data [((POLY_SIZE-1)-1):0],1'b0 } ^ tp[POLY_SIZE-1:0]);
       else
        crc_data   = {crc_data [((POLY_SIZE-1)-1):0],1'b0 };
      end
      fcalc_crc = crc_data ;
     end
   endfunction


   // This function re-orders the bits/bytes of data according
   // to the parameters passed through.
   function [DATA_WIDTH-1:0] fdata_ro0;
    input [DATA_WIDTH-1:0] data_ro_in;
    begin : FUNC_REORDER_DATA
     reg   [DATA_WIDTH-1:0] data_ro_out;
     integer             i;

      for (i = 0; i < DATA_WIDTH; i = i+1) begin
        data_ro_out[i] = data_ro_in[i];
      end
      fdata_ro0 = data_ro_out;
     end
   endfunction


   // This function directly reverse ordering of bits of data according
   // to the parameters passed through.
   function [DATA_WIDTH-1:0] fdata_ro1;
    input [DATA_WIDTH-1:0] data_ro_in;
    begin : FUNC_REORDER_DATA
     reg   [DATA_WIDTH-1:0] data_ro_out;
     integer             i,j;

      for (i = 0; i < DATA_WIDTH; i = i+1) begin
          j              = DATA_WIDTH - 1 - i;
          data_ro_out[i] = data_ro_in[j];
      end
      fdata_ro1 = data_ro_out;
     end
   endfunction


   // This function re-orders the bits/bytes of data according
   // to the parameters passed through using:
   // byte reverse, bit forward ordering
   function [DATA_WIDTH-1:0] fdata_ro2;
    input [DATA_WIDTH-1:0] data_ro_in;
    begin : FUNC_REORDER_DATA
     reg   [DATA_WIDTH-1:0] data_ro_out;
     integer             i,j;

      for (i = 0; i < DATA_WIDTH; i = i+1) begin
// spyglass disable_block SelfDeterminedExpr-ML
// SMD: Self determined expression found
// SJ: The expression indexing the vector/array will never exceed the bound of the vector/array.
          j              = (i & 7) + (((DATA_WIDTH>>3)-1 - (i>>3))<<3);
// spyglass enable_block SelfDeterminedExpr-ML
          data_ro_out[i] = data_ro_in[j];
      end
      fdata_ro2 = data_ro_out;
     end
   endfunction


   // This function re-orders the bits/bytes of data according
   // to the parameter passed through using:
   // byte forward, bit reverse ordering
   function [DATA_WIDTH-1:0] fdata_ro3;
    input [DATA_WIDTH-1:0] data_ro_in;
    begin : FUNC_REORDER_DATA
     reg   [DATA_WIDTH-1:0] data_ro_out;
     integer             i,j;

      for (i = 0; i < DATA_WIDTH; i = i+1) begin
          j              = (i | 7)-(i & 7);
          data_ro_out[j] = data_ro_in[i];
      end
      fdata_ro3 = data_ro_out;
     end
   endfunction


  // This function will left-shift the input data by a number of bits
  // that specified by the parameter.
  function [POLY_SIZE-1:0] fshift_crc_nxt;
   input  [POLY_SIZE-1:0] crc_out_fnc;
    begin : FSHIFT_CRC_NXT
     reg [POLY_SIZE-1:0] shifted_data;
     integer             i;
     shifted_data = crc_out_fnc;
     for (i = 0;i < DATA_WIDTH; i = i + 1)
       shifted_data = shifted_data << 1'b1; 

      fshift_crc_nxt =  shifted_data;
    end
  endfunction



generate
  if ((CRC_CFG & 6) == 0) begin : GEN_cfg_00x
    assign crc_xor_constant = {POLY_SIZE{1'b0}};
  end

  if (((CRC_CFG & 6) == 2) && ((POLY_SIZE & 1) == 0)) begin : GEN_cfg_01x_evn_ps
    assign crc_xor_constant = {(POLY_SIZE / 2){2'b01}} ;
  end

  if (((CRC_CFG & 6) == 2) && ((POLY_SIZE & 1) == 1)) begin : GEN_cfg_01x_odd_ps
    assign crc_xor_constant = {1'b1,{((POLY_SIZE-1)/2){2'b01}}};
  end

  if (((CRC_CFG & 6) == 4) && ((POLY_SIZE & 1) == 0)) begin : GEN_cfg_10x_evn_ps
    assign crc_xor_constant = {(POLY_SIZE / 2){2'b10}} ;
  end

  if (((CRC_CFG & 6) == 4) && ((POLY_SIZE & 1) == 1)) begin : GEN_cfg_10x_odd_ps
    assign crc_xor_constant = {1'b0,{((POLY_SIZE-1)/2){2'b10}}};
  end

  if ((CRC_CFG & 6) == 6) begin : GEN_cfg_11x
    assign crc_xor_constant = {POLY_SIZE{1'b1}};
  end
endgenerate

generate
  if ((CRC_CFG & 1) == 0) begin : GEN_crc_rst_zeros
    assign reset_crc_reg    = {POLY_SIZE{1'b0}};
  end

  if ((CRC_CFG & 1) == 1) begin : GEN_crc_rst_ones
    assign reset_crc_reg    = {POLY_SIZE{1'b1}};
  end
endgenerate


  assign crc_ok_remn      = gen_crc_rem(crc_xor_constant);

generate
  if (BIT_ORDER <= 0) begin : GEN_ORDER0
    assign data_in_ro           = fdata_ro0(data_in);
    assign crc_xord_swaped      = fdata_ro0 (crc_xor_res);
  end

  if (BIT_ORDER == 1) begin : GEN_ORDER1
    assign data_in_ro           = fdata_ro1(data_in);
    assign crc_xord_swaped      = fdata_ro1 (crc_xor_res);
  end

  if (BIT_ORDER == 2) begin : GEN_ORDER2
    assign data_in_ro           = fdata_ro2(data_in);
    assign crc_xord_swaped      = fdata_ro2 (crc_xor_res);
  end

  if (BIT_ORDER >= 3) begin : GEN_ORDER3
    assign data_in_ro           = fdata_ro3(data_in);
    assign crc_xord_swaped      = fdata_ro3 (crc_xor_res);
  end
endgenerate

  assign crc_out_next_shifted = fshift_crc_nxt(crc_out_int);
  assign crc_result           = fcalc_crc (data_in_ro, crc_out_int,
                                           draining_status_next);

generate
  if ((POLY_2_DATA_RATIO > 1) && ((DATA_WIDTH & 1) == 1)) begin : GEN_odd_ptrn
    assign crc_ins_mask         = (data_pointer_next[0] == 1'b0) ?
                                   crc_xor_constant[DATA_WIDTH*2-1:DATA_WIDTH]
                                   : crc_xor_constant[DATA_WIDTH-1:0];           
  end else                                               begin : GEN_reg_ptrn
    assign crc_ins_mask         = crc_xor_constant[DATA_WIDTH-1:0];              
  end
endgenerate
                                 
  assign crc_xor_res          = (crc_out_int[POLY_SIZE-1:POLY_SIZE-DATA_WIDTH]
                                 ^ crc_ins_mask);
  assign crc_drn_dat          = crc_xord_swaped;
  assign crc_ok_result        = (crc_out_temp == crc_ok_remn);
  assign data_pointer_minus_1 = data_pointer[3:0] - 4'b1;
  assign data_pointer_next    = ((draining & enable)==1'b1) ?
                                        ((data_pointer == 5'b0) ? 5'b0 : {1'b0, data_pointer_minus_1})
                                        : data_pointer;


  always @ (draining_status  or drain_done_int or data_pointer_next
            or crc_drn_dat or crc_out_next_shifted or drain
            or data_in or crc_result ) begin : gen_next_states_PROC
    if(draining_status == 1'b0) begin
      if((drain & (~drain_done_int)) == 1'b1) begin
        draining_status_next = 1'b1;
        data_out_next        = crc_drn_dat;
        crc_out_next         = crc_out_next_shifted;
        drain_done_next      = drain_done_int;
      end  
      else begin
        draining_status_next = 1'b0;
        data_out_next        = data_in ;
        crc_out_next         = crc_result;
        drain_done_next      = drain_done_int;
      end  
    end
    else begin 
      if(data_pointer_next == 5'b0) begin 
        draining_status_next = 1'b0 ;
        data_out_next        = data_in ;
        crc_out_next         = crc_result;
        drain_done_next      = 1'b1;
      end
      else begin
        draining_status_next = 1'b1 ;
        data_out_next        = crc_drn_dat ;
        crc_out_next         = crc_out_next_shifted;
        drain_done_next      = drain_done_int;
      end   
    end
    
   end

  always @ (crc_in or crc_out_next or ld_crc_n) begin : gen_crc_out_temp_PROC
    if(ld_crc_n == 1'b0) begin
      crc_out_temp      = crc_in;
    end
    else begin
      crc_out_temp      = crc_out_next;
    end    
   end
                                     
  always @ (posedge clk or negedge rst_n) begin : DW_crc_s_PROC
    if(rst_n == 1'b0) begin 
      data_pointer    <= INITIAL_POINTER ;
      crc_out_rg      <= {POLY_SIZE{1'b0}} ;
      data_out_int    <= {DATA_WIDTH{1'b0}} ;
      draining_status <= 1'b0 ;
      drain_done_int  <= 1'b0 ;
      crc_ok_int      <= 1'b0;
     end 
    else if(init_n == 1'b0) begin 
      data_pointer    <= INITIAL_POINTER ;
      crc_out_rg      <= {POLY_SIZE{1'b0}} ;
      data_out_int    <= {DATA_WIDTH{1'b0}} ;
      draining_status <= 1'b0 ;
      drain_done_int  <= 1'b0 ;
      crc_ok_int      <= 1'b0;
     end 
    else if(enable == 1'b1) begin
      draining_status <= draining_status_next;
      data_pointer    <= data_pointer_next ;
      data_out_int    <= data_out_next ;
      crc_out_rg      <= crc_out_temp ^ reset_crc_reg ;
      drain_done_int  <= drain_done_next ;
      crc_ok_int      <= crc_ok_result;
    end
   end


   assign crc_out_int = crc_out_rg ^ reset_crc_reg ;


   assign crc_out    = crc_out_int;
   assign draining   = draining_status;
   assign data_out   = data_out_int;
   assign crc_ok     = crc_ok_int;
   assign drain_done = drain_done_int;

   
   
endmodule

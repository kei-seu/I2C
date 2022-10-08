
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
// Filename    : DW_apb_i2c_bcm05.v
// Revision    : $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_bcm05.v#3 $
// Author      : Vikas Gokhale       5/17/04
// Description : DW_apb_i2c_bcm05.v Verilog module for DW_apb_i2c
//
// DesignWare IP ID: 15919a8c
//
////////////////////////////////////////////////////////////////////////////////


module kei_DW_apb_i2c_bcm05 (
        clk,
        rst_n,
        init_n,
        inc_req_n,
        other_addr_g,
        word_count,
        empty,
        almost_empty,
        half_full,
        almost_full,
        full,
        error,
        this_addr,
        this_addr_g,
        next_word_count,
        next_empty_n,
        next_full,
        next_error
        );

parameter DEPTH         =  8;   // RANGE 4 to 16777216
parameter ADDR_WIDTH    =  3;   // RANGE 2 to 24
parameter COUNT_WIDTH   =  4;   // RANGE 3 to 25
parameter AE_LVL        =  2;   // RANGE 1 to DEPTH-1
parameter AF_LVL        =  2;   // RANGE 1 to DEPTH-1
parameter ERR_MODE      =  0;   // RANGE 0 to 1
parameter SYNC_DEPTH    =  2;   // RANGE 1 to 4
parameter IO_MODE       =  1;   // RANGE 0 to 1

parameter PIPE_GRAY     = 0;    // RANGE 0 to 1
parameter VERIF_EN      = 1;    // RANGE 0 to 5

localparam GRAY_VERIF_EN     = ((VERIF_EN==2)?4:((VERIF_EN==3)?1:VERIF_EN));
   

input                                 clk;              // clock input
input                                 rst_n;            // active low async reset
input                                 init_n;           // active low sync. reset
input                                 inc_req_n;        // active high request to advance
input  [COUNT_WIDTH-1 : 0]            other_addr_g;     // Gray pointer form oppos. I/F
output [COUNT_WIDTH-1 : 0]            word_count;       // Local word count output
output                                empty;            // Empty status flag
output                                almost_empty;     // Almost Empty status flag
output                                half_full;        // Half full status flag
output                                almost_full;      // Almost full status flag
output                                full;             // Full status flag
output                                error;            // Error status flag
output [ADDR_WIDTH-1 : 0]             this_addr;        // Local RAM address
output [COUNT_WIDTH-1 : 0]            this_addr_g;      // Gray coded pointer to other domain
output [COUNT_WIDTH-1 : 0]            next_word_count;  // Look ahead word count
output                                next_empty_n;     // Look ahead empty flag (active low)
output                                next_full;        // Look ahead full flag
output                                next_error;       // Look ahead error flag



 
localparam [COUNT_WIDTH-1 : 0] A_EMPTY_VECTOR  = AE_LVL;
localparam [COUNT_WIDTH-1 : 0] A_FULL_VECTOR   = DEPTH - AF_LVL;
localparam [COUNT_WIDTH-1 : 0] HLF_FULL_VECTOR = (DEPTH+1)/2;
localparam [COUNT_WIDTH-1 : 0] FULL_COUNT_BUS  = DEPTH;
localparam [COUNT_WIDTH-1 : 0] BUS_LOW         = 0;
localparam [COUNT_WIDTH-1 : 0] RESIDUAL_VALUE_BUS = ((1 << COUNT_WIDTH ) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1))) );
localparam [COUNT_WIDTH-1 : 0] OFFSET_RESIDUAL_BUS = (((((1 << COUNT_WIDTH ) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1))) ))/2 ));
localparam [COUNT_WIDTH-1 : 0] START_VALUE_BUS = ((((1 << COUNT_WIDTH ) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1))) ))/2 );
localparam [COUNT_WIDTH-1 : 0] END_VALUE_BUS = ((1 << COUNT_WIDTH ) -  1 - (((((1 << COUNT_WIDTH ) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1))) ))/2 )));
localparam [COUNT_WIDTH-1 : 0] COUNT_SIZED_ONE = 1;
localparam [ADDR_WIDTH-1 : 0]  ADDR_SIZED_ONE  = 1;
localparam [ADDR_WIDTH-1 : 0]  MODULUSM1 = (DEPTH==(1 << (COUNT_WIDTH-1)))? 0 :
                                            DEPTH + 1 - (DEPTH & 1);

localparam [COUNT_WIDTH-1 : 0] START_VALUE_GRAY_BUS = (START_VALUE_BUS  ^ (START_VALUE_BUS >> 1));

wire  [COUNT_WIDTH-1 : 0]       next_count_int;
wire  [ADDR_WIDTH-1 : 0]        next_this_addr_int;
wire  [COUNT_WIDTH-1 : 0]       next_this_addr_g_int;
wire                            next_empty_int;
wire                            next_almost_empty_int;
wire                            next_half_full_int;
wire                            next_almost_full_int;
wire                            next_full_int;

wire                            next_almost_empty;
wire                            next_half_full;
wire                            next_almost_full;
wire                            error_seen;
wire                            next_error_int;

wire  [COUNT_WIDTH-1 : 0]       count;

wire                            next_empty;

wire  [COUNT_WIDTH-1 : 0]       raw_sync;
wire  [COUNT_WIDTH-1 : 0]       other_addr_g_sync;

wire  [COUNT_WIDTH-1 : 0]       next_this_addr_g;
wire  [COUNT_WIDTH-1 : 0]       other_addr_decoded;

wire                            advance;
wire  [COUNT_WIDTH   : 0]       succesive_count_big;
wire  [COUNT_WIDTH-1 : 0]       succesive_count;
wire  [ADDR_WIDTH   : 0]        succesive_addr_big;
wire  [ADDR_WIDTH-1 : 0]        succesive_addr;

wire  [COUNT_WIDTH-1 : 0]       advanced_count;
reg   [COUNT_WIDTH-1 : 0]       next_word_count_int;
wire  [ADDR_WIDTH-1 : 0]        next_this_addr;

wire  [COUNT_WIDTH  : 0]        temp1;

wire  [COUNT_WIDTH-1 : 0]       wrd_count_p1;

wire  [COUNT_WIDTH-1 : 0]       wr_addr;
wire  [COUNT_WIDTH-1 : 0]       rd_addr;

wire                            at_end;
wire                            at_end_n;

reg  [COUNT_WIDTH-1 : 0]        count_int;
reg  [ADDR_WIDTH-1 : 0]         this_addr_int;
reg  [COUNT_WIDTH-1 : 0]        this_addr_g_int;
reg  [COUNT_WIDTH-1 : 0]        word_count_int;
 
reg                             empty_int;
reg                             almost_empty_int;
reg                             half_full_int;
reg                             almost_full_int;
reg                             full_int;
reg                             error_int;


 

  assign next_almost_empty     = (next_word_count_int <= A_EMPTY_VECTOR) ? 1'b1 : 1'b0;
  assign next_half_full        = (next_word_count_int >= HLF_FULL_VECTOR) ? 1'b1 : 1'b0; 
  assign next_almost_full      = (next_word_count_int >= A_FULL_VECTOR) ? 1'b1 : 1'b0; 
  assign next_empty            = (next_word_count_int == BUS_LOW) ? 1'b1 : 1'b0; 
  assign next_full_int         = (next_word_count_int == FULL_COUNT_BUS) ? 1'b1 : 1'b0; 

  assign error_seen            = !inc_req_n && at_end;

generate
  if (ERR_MODE == 0) begin : GEN_em_eq_0
    assign next_error_int        = error_seen || error_int;
  end else begin :              GET_em_ne_0
    assign next_error_int        = error_seen;
  end
endgenerate

  assign next_count_int        = advanced_count ^ START_VALUE_BUS;
  assign next_this_addr_int    = next_this_addr;

generate
 if (PIPE_GRAY==0) begin : GEN_PG_EQ_0
  assign next_this_addr_g_int  = next_this_addr_g ^ START_VALUE_GRAY_BUS;
 end else begin : GEN_NXT_NE_0
  reg [COUNT_WIDTH-1 : 0] next_this_addr_g_int_dly;
  always @ (posedge clk or negedge rst_n) begin : pipe_gray_PROC
    if (!rst_n)
       next_this_addr_g_int_dly <= {COUNT_WIDTH{1'b0}};
    else if (!init_n)
       next_this_addr_g_int_dly <= {COUNT_WIDTH{1'b0}};
    else
       next_this_addr_g_int_dly <= next_this_addr_g ^ START_VALUE_GRAY_BUS;
  end

  assign next_this_addr_g_int  = next_this_addr_g_int_dly;
 end
endgenerate

  assign next_empty_int        = ~next_empty;
  assign next_almost_empty_int = ~next_almost_empty;
  assign next_half_full_int    = next_half_full;
  assign next_almost_full_int  = next_almost_full;
 

// spyglass disable_block CheckDelayTimescale-ML
// SMD: Delay is used without defining timescale compiler directive
// SJ: The design incorporates delays for behavioral simulation. Timescale compiler directive is assumed to be defined in the test bench.
  always @ (posedge clk or negedge rst_n) begin : state_regs_PROC
     if (!rst_n) begin
       count_int <=  {COUNT_WIDTH{1'b0}};
       this_addr_int <=  {ADDR_WIDTH{1'b0}};
       this_addr_g_int <=  {COUNT_WIDTH{1'b0}};
       word_count_int <=  {COUNT_WIDTH{1'b0}};
       empty_int <=  1'b0;
       almost_empty_int <=  1'b0;
       half_full_int <=  1'b0;
       almost_full_int <=  1'b0;
       full_int <=  1'b0;
       error_int <=  1'b0;
     end else if (!init_n) begin
       count_int <=  {COUNT_WIDTH{1'b0}};
       this_addr_int <=  {ADDR_WIDTH{1'b0}};
       this_addr_g_int <=  {COUNT_WIDTH{1'b0}};
       word_count_int <=  {COUNT_WIDTH{1'b0}};
       empty_int <=  1'b0;
       almost_empty_int <=  1'b0;
       half_full_int <=  1'b0;
       almost_full_int <=  1'b0;
       full_int <=  1'b0;
       error_int <=  1'b0;
     end else begin
       count_int <=  next_count_int ;
       this_addr_int <=  next_this_addr_int ;
       this_addr_g_int <=  next_this_addr_g_int ;
       word_count_int <=  next_word_count_int ;
       empty_int <=  next_empty_int;
       almost_empty_int <=  next_almost_empty_int;
       half_full_int <=  next_half_full_int;
       almost_full_int <=  next_almost_full_int;
       full_int <=  next_full_int;
       error_int <=  next_error_int;
     end
    end
// spyglass enable_block CheckDelayTimescale-ML

  assign other_addr_g_sync  = raw_sync ^ START_VALUE_GRAY_BUS;

  assign count              = count_int ^ START_VALUE_BUS;
  assign word_count         = word_count_int;

  assign empty              = ~empty_int;
  assign almost_empty       = ~almost_empty_int;
  assign half_full          = half_full_int;
  assign almost_full        = almost_full_int;
  assign full               = full_int;
  assign error              = error_int;

generate
  if (IO_MODE == 0) begin :     GEN_iom_eq_0
    assign at_end         = ~empty_int;
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
    assign at_end_n       =  empty_int;
// spyglass enable_block W528
    assign rd_addr        = advanced_count;
    assign wr_addr        = other_addr_decoded;
  end else begin :              GEN_iom_ne_0
    assign at_end         =  full_int;
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
    assign at_end_n       = ~full_int;
// spyglass enable_block W528
    assign rd_addr        = other_addr_decoded;
    assign wr_addr        = advanced_count;
  end
endgenerate

  assign next_word_count    = init_n ? next_word_count_int : ({COUNT_WIDTH{1'b0}});
  assign next_empty_n       = ~next_empty && init_n;
  assign next_full          = next_full_int && init_n;
  assign next_error         = next_error_int && init_n;


  kei_DW_apb_i2c_bcm21
   #(COUNT_WIDTH, SYNC_DEPTH+8, GRAY_VERIF_EN, 2) U_sync(
    .clk_d(clk),
    .rst_d_n(rst_n),
    .data_s(other_addr_g),
    .data_d(raw_sync) );

  // Gray Code encoder
  
  function [COUNT_WIDTH-1:0] func_bin2gray ;
    input [COUNT_WIDTH-1:0]             f_b;    // input
    begin 
      func_bin2gray  = f_b ^ ( f_b >> 1 ); 
    end
  endfunction

  assign next_this_addr_g = func_bin2gray ( advanced_count );

// spyglass disable_block Ac_conv01
// SMD: Checks sequential convergence of same-domain signals synchronized in the same destination domain
// SJ: The bus being synchronized and then decoded (i.e. other_addr_decoded), is a Gray transition coded bus and is therefore safe to be followed by converging logic.
// spyglass disable_block Ac_conv02
// SMD: Checks combinational convergence of same-domain signals synchronized in the same destination domain
// SJ: The bus being synchronized and then decoded (i.e. other_addr_decoded), is a Gray transition coded bus and is therefore safe to be followed by converging logic.
  // Gray Code decoder
  
  function [COUNT_WIDTH-1:0] func_gray2bin ;
    input [COUNT_WIDTH-1:0]             f_g;    // input
    reg   [COUNT_WIDTH-1:0]             f_b;
    integer                     f_i;
    begin 
      f_b = {COUNT_WIDTH{1'b0}};
      for (f_i=COUNT_WIDTH-1 ; f_i >= 0 ; f_i=f_i-1) begin
        if (f_i < COUNT_WIDTH-1)
// spyglass disable_block SelfDeterminedExpr-ML
// SMD: Self determined expression found
// SJ: The expression indexing the vector/array will never exceed the bound of the vector/array.
          f_b[f_i] = f_g[f_i] ^ f_b[f_i+1];
// spyglass enable_block SelfDeterminedExpr-ML
        else
          f_b[f_i] = f_g[f_i];
      end // for (i
      func_gray2bin  = f_b; 
    end
  endfunction

  assign other_addr_decoded = func_gray2bin ( other_addr_g_sync );
// spyglass enable_block Ac_conv01
// spyglass enable_block Ac_conv02
 
  assign advance            = ~inc_req_n && (~at_end);

  assign advanced_count = (advance == 1'b1)? succesive_count : count;
  assign next_this_addr = (advance == 1'b1)? succesive_addr : this_addr_int;

// spyglass disable_block W164b
// SMD: Identifies assignments in which the LHS WIDTH is greater than the RHS WIDTH
// SJ: In most cases, the expressions in the code are written such that the LHS result is one bit larger than the RHS operands (or they should be at the very least). This is the most conservative approach in having one more bit on the left-hand side (LHS) than the two operands of an expression on the right-hand side (RHS).
  assign temp1              = wr_addr - rd_addr;
// spyglass enable_block W164b
  assign wrd_count_p1       = temp1[COUNT_WIDTH-1 : 0];


  assign succesive_count_big = count+COUNT_SIZED_ONE;
  assign succesive_addr_big  = this_addr_int+ADDR_SIZED_ONE;

generate
  if ((1 << ADDR_WIDTH) != DEPTH) begin : GEN_NXT_W_CNT_NOT_PWR2
    always @( wrd_count_p1 or rd_addr or wr_addr) begin : mk_this_non_pwr_2_addr_PROC
      reg [COUNT_WIDTH : 0] next_word_count_int_big;

      if (rd_addr > wr_addr)
        next_word_count_int_big = wrd_count_p1 - RESIDUAL_VALUE_BUS;
      else
// spyglass disable_block W164b
// SMD: Identifies assignments in which the LHS WIDTH is greater than the RHS WIDTH
// SJ: In most cases, the expressions in the code are written such that the LHS result is one bit larger than the RHS operands (or they should be at the very least). This is the most conservative approach in having one more bit on the left-hand side (LHS) than the two operands of an expression on the right-hand side (RHS).
        next_word_count_int_big = wrd_count_p1;
// spyglass enable_block W164b

      next_word_count_int = next_word_count_int_big[COUNT_WIDTH-1 : 0];
    end

    assign succesive_count = (this_addr_int != MODULUSM1)? succesive_count_big[COUNT_WIDTH-1:0] :
                                                        START_VALUE_BUS;
    assign succesive_addr  = (this_addr_int != MODULUSM1)? succesive_addr_big[ADDR_WIDTH-1:0]  :
                                                        BUS_LOW[ADDR_WIDTH-1 : 0];
    assign this_addr       = this_addr_int;
  end

  if ((1 << ADDR_WIDTH) == DEPTH) begin : GEN_NXT_W_CNT_PWR2
    always @( wrd_count_p1 ) begin : hook_up_pwr_2_wc_PROC
        next_word_count_int = wrd_count_p1;
    end

    assign succesive_count = succesive_count_big[COUNT_WIDTH-1:0];
    assign succesive_addr  = succesive_addr_big[ADDR_WIDTH-1:0];
    assign this_addr       = count[ADDR_WIDTH-1 : 0];
  end
endgenerate

    assign this_addr_g = this_addr_g_int;

endmodule


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
// Filename    : DW_apb_i2c_bcm57.v
// Revision    : $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_bcm57.v#11 $
// Author      : Rick Kelly    April 26, 2004
// Description : DW_apb_i2c_bcm57.v Verilog module for DW_apb_i2c
//
// DesignWare IP ID: 08e40b25
//
////////////////////////////////////////////////////////////////////////////////



  module kei_DW_apb_i2c_bcm57 (
        clk,
        rst_n,
        wr_n,
        data_in,
        wr_addr,
        rd_addr,
        data_out
        );

   parameter DATA_WIDTH = 4;    // RANGE 1 to 256
   parameter DEPTH = 8;         // RANGE 2 to 256
   parameter MEM_MODE = 0;      // RANGE 0 to 3
   parameter ADDR_WIDTH = 3;    // RANGE 1 to 8

   input                        clk;            // clock input
   input                        rst_n;          // active low async. reset
   input                        wr_n;           // active low RAM write enable
   input [DATA_WIDTH-1:0]       data_in;        // RAM write data input bus
   input [ADDR_WIDTH-1:0]       wr_addr;        // RAM write address bus
   input [ADDR_WIDTH-1:0]       rd_addr;        // RAM read address bus

   output [DATA_WIDTH-1:0]      data_out;       // RAM read data output bus


   reg [DATA_WIDTH-1:0]         mem [0 : DEPTH-1];

  wire [ADDR_WIDTH-1:0]         write_addr;
  wire                          wr_n_int;
  wire                          write_en_n;
  wire [DATA_WIDTH-1:0]         write_data;
  wire [ADDR_WIDTH-1:0]         read_addr;
  wire [DATA_WIDTH-1:0]         read_data;

  localparam [ADDR_WIDTH-1:0]   MAX_ADDR = DEPTH-1;
   
generate
  if ( DEPTH != (1 << ADDR_WIDTH) ) begin : GEN_NONPWR2_DPTH
// If read address is out of range of RAM DEPTH, then produce all zeros for read data
    assign read_data = (rd_addr <= MAX_ADDR) ? mem[read_addr] : {DATA_WIDTH{1'b0}};

    assign wr_n_int = (wr_addr <= MAX_ADDR) ? wr_n : 1'b1;
  end else begin : GEN_PWR2_DPTH
    assign read_data = mem[read_addr];
    assign wr_n_int = wr_n;
  end
endgenerate

  always @ (posedge clk or negedge rst_n) begin : mem_array_regs_PROC
    integer i;
    if (rst_n == 1'b0) begin
      for (i=0 ; i < DEPTH ; i=i+1)
        mem[i] <= {DATA_WIDTH{1'b0}};
    end else begin
      if (write_en_n == 1'b0)
// spyglass disable_block STARC-2.3.4.3
// SMD: A flip-flop should have an asynchronous set or an asynchronous reset
// SJ: This module can be specifically configured/implemented with only a synchronous reset or no resets at all.
        mem[write_addr] <= write_data;
// spyglass enable_block STARC-2.3.4.3
    end
  end

generate
  if ((MEM_MODE & 1) == 1) begin : GEN_RDDAT_REG
    reg [DATA_WIDTH-1:0] data_out_pipe;

    always @ (posedge clk or negedge rst_n) begin : retiming_rddat_reg_PROC
      if (rst_n == 1'b0) begin
        data_out_pipe <= {DATA_WIDTH{1'b0}};
      end else begin
        data_out_pipe <= read_data;
      end
    end

    assign data_out = data_out_pipe;
  end else begin : GEN_MM_NE_1
    assign data_out = read_data;
  end
endgenerate

generate
  if ((MEM_MODE & 2) == 2) begin : GEN_INPT_REGS
    reg                  we_pipe;
    reg [ADDR_WIDTH-1:0] wr_addr_pipe;
    reg [DATA_WIDTH-1:0] data_in_pipe;
    reg [ADDR_WIDTH-1:0] rd_addr_pipe;

    always @ (posedge clk or negedge rst_n) begin : retiming_regs_PROC
      if (rst_n == 1'b0) begin
        we_pipe <= 1'b0;
        wr_addr_pipe <= {ADDR_WIDTH{1'b0}};
        data_in_pipe <= {DATA_WIDTH{1'b0}};
        rd_addr_pipe <= {ADDR_WIDTH{1'b0}};
      end else begin
        we_pipe <= wr_n_int;
        wr_addr_pipe <= wr_addr;
        data_in_pipe <= data_in;
        rd_addr_pipe <= rd_addr;
      end
    end

    assign write_en_n = we_pipe;
    assign write_data = data_in_pipe;
    assign write_addr = wr_addr_pipe;
    assign read_addr  = rd_addr_pipe;
  end else begin : GEN_MM_NE_2
    assign write_en_n = wr_n_int;
    assign write_data = data_in;
    assign write_addr = wr_addr;
    assign read_addr  = rd_addr;
  end
endgenerate



endmodule

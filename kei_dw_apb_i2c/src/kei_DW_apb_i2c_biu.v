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
// File Version     :        $Revision: #7 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_biu.v#7 $ 
//
// File    : DW_apb_i2c_biu.v
// Author  : Joe Mc Cann
//
//
// Created : Thu Jun 13 13:32:20 BST 2002
//
// Abstract: Apb bus interface module.
//           This module is intended for use with APB slave
//           macrocells.  The module generates output signals
//           from the APB bus interface that are intended for use in
//           the register block of the macrocell.
//
//        1: Generates the write enable (wr_en) and read
//           enable (rd_en) for register accesses to the macrocell.
//
//        2: Decodes the address bus (paddr) to generate the active
//           byte lane signal (byte_en).
//
//        3: Strips the APB address bus (paddr) to generate the
//           register offset address output (reg_addr).
//
//        4: Registers APB read data (prdata) onto the APB data bus.
//           The read data is routed to the correct byte lane in this
//           module.
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------


module kei_DW_apb_i2c_biu
(
 // APB bus interface
 pclk,
                      presetn,
                      psel,
                      penable,
                      pwrite, 
                      paddr,
                      pwdata,
                      pready,
                      pslverr,
                      prdata,
                      // regfile interface
                      wr_en,
                      rd_en,
                      slave_rdy,
                      slave_err,
                      penable_int,
                      byte_en,
                      reg_addr,
                      ipwdata,
                      iprdata
                      );

   // -------------------------------------
   // -- APB bus signals
   // -------------------------------------
   input                            pclk;      // APB clock
   input                            presetn;   // APB reset
   input                            psel;      // APB slave select
   input     [`IC_ADDR_SLICE_LHS:0] paddr;     // APB address
   input                            pwrite;    // APB write/read
   input                            penable;   // APB enable
   input      [`APB_DATA_WIDTH-1:0] pwdata;    // APB write data bus
   input                            slave_rdy; // slave ready signal
   input                            slave_err; // slave error signal
   

   // -------------------------------------
   // -- Register block interface signals
   // -------------------------------------
   input  [`MAX_APB_DATA_WIDTH-1:0] iprdata;   // Internal read data bus


   output     [`APB_DATA_WIDTH-1:0] prdata;    // APB read data bus
   output                           pready;    //Slave ready: A low  on this APB3 signal stalls an APB transaction until signal goes high.
   output                           pslverr;   //Slave error: A high on this APB3 signal indicates an error condition on the transfer.

   output                           wr_en;     // Write enable signal
   output                           rd_en;     // Read enable signal
   output                           penable_int; // Internal PENABLE Signal
   output                     [3:0] byte_en;   // Active byte lane signal
   output  [`IC_ADDR_SLICE_LHS-2:0] reg_addr;  // Register address offset
   output [`MAX_APB_DATA_WIDTH-1:0] ipwdata;   // Internal write data bus

   // -------------------------------------
   // -- Local registers & wires
   // -------------------------------------
   reg        [`APB_DATA_WIDTH-1:0] prdata;    // Registered prdata output
   reg    [`MAX_APB_DATA_WIDTH-1:0] ipwdata;   // Internal pwdata bus
   wire                       [3:0] byte_en;   // Registered byte_en output



   
   // --------------------------------------------
   // -- write/read enable -- penable --
   //
   // -- Generate write/read enable signals from
   // -- psel, penable and pwrite inputs
   // --------------------------------------------
   assign wr_en = (psel) & ( pwrite);
   assign rd_en = (psel) & (!pwrite);
   assign penable_int = penable;
   assign pready      = slave_rdy;
   assign pslverr     = slave_err;
   
   // --------------------------------------------
   // -- Register address
   //
   // -- Strips register offset address from the
   // -- APB address bus
   // --------------------------------------------
   assign reg_addr = paddr[`IC_ADDR_SLICE_LHS:2];

   
   //spyglass disable_block W415a
   //SMD: Signal may be multiply assigned (beside initialization) in the same scope
   //SJ : The signal ipwdata is updated with the default values (0's) and then only required
   //     bits are  updated. There is no functional issue. Hence this can be waived.
   // --------------------------------------------
   // -- APB write data
   //
   // -- ipwdata is zero padded before being
   // -- passed through this block
   // --------------------------------------------
   always @(pwdata) begin : IPWDATA_PROC
      ipwdata = { `MAX_APB_DATA_WIDTH{1'b0} };
      ipwdata[`APB_DATA_WIDTH-1:0] = pwdata[`APB_DATA_WIDTH-1:0];
   end
   //spyglass enable_block W415a
   
   // --------------------------------------------
   // -- Set active byte lane
   //
   // -- This bit vector is used to set the active
   // -- byte lanes for write/read accesses to the
   // -- registers
   // --------------------------------------------

    assign  byte_en = 4'b1111;


   // --------------------------------------------
   // -- APB read data.
   //
   // -- Register data enters this block on a
   // -- 32-bit bus (iprdata). The upper unused
   // -- bit(s) have been zero padded before entering
   // -- this block.  The process below strips the
   // -- active byte lane(s) from the 32-bit bus
   // -- and registers the data out to the APB
   // -- read data bus (prdata).
   // --------------------------------------------
   always @(posedge pclk or negedge presetn) begin : PRDATA_PROC
      if(presetn == 1'b0) begin
         prdata <= { `APB_DATA_WIDTH{1'b0} };
      end else begin
         if(rd_en && (!penable) ) begin
                  prdata <= iprdata;
         end
      end
   end
   
endmodule // DW_apb_i2c_biu
  

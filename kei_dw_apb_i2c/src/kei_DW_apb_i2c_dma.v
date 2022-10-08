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
// File Version     :        $Revision: #10 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_dma.v#10 $ 
//
//
// File    : DW_apb_i2c_dma.v
//
//
// Abstract: DMA interface for DW_apb_i2c macrocell.
//
//        1: Generates DMA requests and controls all DMA signals 
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------

module kei_DW_apb_i2c_dma (
   pclk,
   presetn,
   ic_enable,
   tx_full,
   rx_empty,
   ic_txflr,
   ic_rxflr,
   ic_dma_cr,
   ic_dma_tdlr,
   ic_dma_rdlr,
   tx_fifo_rst_n,
   dma_tx_ack,
   dma_rx_ack,
   dma_tx_req,
   dma_rx_req,
   dma_tx_single,
   dma_rx_single
);


  input                           pclk;          // APB clock
  input                           presetn;       // APB async reset
  input                           tx_full;       // tx fifo full
  input                           rx_empty;      // tx fifo empty
  input               [`TX_ABW:0] ic_txflr;         // tx fifo level
  input               [`RX_ABW:0] ic_rxflr;         // rx fifo level
  input                           dma_tx_ack;    // end of tx dma burst
  input                           dma_rx_ack;    // end of rx dma burst
  input                     [1:0] ic_dma_cr;     // dma control register
  input             [`TX_ABW-1:0] ic_dma_tdlr;   // dma tx data level register
  input             [`RX_ABW-1:0] ic_dma_rdlr;   // dma rx data level register
  input       [`IC_ENABLE_RS_INT-1:0] ic_enable;     // Nothing can happen until block is enabled
  input                           tx_fifo_rst_n; // Tx FIFO Reset

  output                          dma_tx_req;    // tx dma request
  output                          dma_rx_req;    // rx dma request
  output                          dma_tx_single; // tx dma single status
  output                          dma_rx_single; // rx dma single status

  // ------------------------------------------------------
  // -- local registers and wires
  // ------------------------------------------------------
  wire                            set_rx_req;
  wire                            set_tx_req;
  wire                            ic_enable_0;
  wire                            ic_dma_cr_0;
  wire                            ic_dma_cr_1;
 
  reg                             dma_tx_req;
  reg                             dma_rx_req;
  reg                             dma_tx_single;
  reg                             dma_rx_single;
  reg                             clear_rx, clear_tx;

  // --------------------------------------------------------
  // -- DMA single status output generation
  //
  // -- output control for 'dma_tx_single' & 'dma_rx_single'
  // --------------------------------------------------------

//#
//# clear_rx and clear_tx are used to clear the request lines
//# The rules of clearing the request lines are as follows
//#   1. Whenever the module is not enabled there should be no requests
//#   2. Whenever the relevant control register bit is not set there should be no corresponding request
//#   3. Whenever there is a corresponding acknowledge, the request should pulse.
//#
  
  assign ic_enable_0 = ic_enable[0];
  assign ic_dma_cr_0 = ic_dma_cr[0];
  assign ic_dma_cr_1 = ic_dma_cr[1];

  always @(ic_enable_0 or ic_dma_cr_0 or dma_rx_ack)
  begin : CLEAR_RX_PROC
    if (ic_enable_0 == 1'b0) begin
      clear_rx = 1'b1;
    end else begin
      if (ic_dma_cr_0 == 1'b0) begin
        clear_rx = 1'b1;
      end else begin
        clear_rx = dma_rx_ack;
      end
    end
  end
   
  always @(ic_enable_0 or ic_dma_cr_1 or dma_tx_ack)
  begin : CLEAR_TX_PROC
    if (ic_enable_0 == 1'b0) begin
      clear_tx = 1'b1;
    end else begin
      if (ic_dma_cr_1 == 1'b0) begin
        clear_tx = 1'b1;
      end else begin
        clear_tx = dma_tx_ack;
      end
    end
  end

//#
//# The single rx request is active provided there is an entry in the rx-fifo which can be read by DMA.
//# The single tx request is active provided there is a location availale in the tx-fifo for another DMA transmit character.
//#

  always @(posedge pclk or negedge presetn) begin : DMA_SINGLE_R_PROC
    if(presetn == 1'b0) begin
      dma_tx_single <= 1'b0;
      dma_rx_single <= 1'b0;
    end else begin
      if (clear_rx == 1'b1) begin
        dma_rx_single <= 1'b0;
      end else begin
        if (rx_empty == 1'b0) begin
          dma_rx_single <= 1'b1;
        end
      end
      
      if (clear_tx == 1'b1) begin
        dma_tx_single <= 1'b0;
      end else begin
        if (tx_full == 1'b0) begin
          dma_tx_single <= 1'b1;
        end
      end
    end
  end

//spyglass disable_block SelfDeterminedExpr-ML
//SMD: Self determined expression present in the design.
//SJ:  This Self Determined Expression is as per the design requirement. 
//     There will not be any functional issue.
//#
//# The same method is used for clearing the requests.
//# The setting of the request depends on the thresholds matching.
//# When a request is active a block of writes will be performed.
//#
  assign set_rx_req = (ic_rxflr >= ({1'b0,ic_dma_rdlr} + {{(`RX_ABW){1'b0}},1'b1}));
  //assign set_tx_req = (ic_txflr <= ic_dma_tdlr);
  // CRM_9000530770
  assign set_tx_req = (ic_txflr <= {1'b0,ic_dma_tdlr}) & tx_fifo_rst_n & (~ic_enable[`IC_ENABLE_RS_INT-1]);
//spyglass enable_block SelfDeterminedExpr-ML

//#
//# DMA channel request output generation for 'dma_tx_req' & 'dma_rx_req'
//#
  always @(posedge pclk or negedge presetn) begin : DMA_REQ_R_PROC
    if(presetn == 1'b0) begin
      dma_tx_req <= 1'b0;
      dma_rx_req <= 1'b0;
    end else begin
      if(clear_rx == 1'b1) begin
        dma_rx_req <= 1'b0;
      end else begin
        if(set_rx_req == 1'b1) begin
          dma_rx_req <= 1'b1;
        end
      end
      
      if(clear_tx == 1'b1) begin
        dma_tx_req <= 1'b0;
      end else begin
        if(set_tx_req == 1'b1) begin
          dma_tx_req <= 1'b1;
        end
      end
    end
  end
   
endmodule

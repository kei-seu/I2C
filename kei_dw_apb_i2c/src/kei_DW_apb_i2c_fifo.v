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
// File Version     :        $Revision: #14 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_fifo.v#14 $ 
//
//
// File    : DW_apb_i2c_fifo.v
//
//
// Abstract: FIFO Controller for the DW_apb_i2c macrocell
//
//        1: Instantiates the DW_apb_i2c_DWbb_fifoctl_s1_df macrocell twice.
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------


module kei_DW_apb_i2c_fifo
   (
    pclk,
    presetn,
    fifo_rst_n,
    tx_fifo_rst_n,
    set_tx_empty_en_flg_edg,
    ic_tx_tl,
    ic_rx_tl,
    tx_push,
    rx_pop,
    tx_pop_flg,
    rx_push_flg,

    tx_pop_sync,
    rx_push_sync,

    tx_empty,
    rx_full, 
    tx_full, 
    rx_empty,
    
    tx_almost_empty,
    gen_tx_almost_empty,
    tx_overflow,
    rx_almost_full,
    rx_overflow,
    rx_underflow,
    tx_wr_addr,
    tx_rd_addr,
    tx_we_n,
    rx_wr_addr,
    rx_rd_addr,
    rx_we_n
    );
   
   input                pclk;           // APB clock
   input                presetn;        // APB async reset
   input                fifo_rst_n;     // sync fifo reset
   input                tx_fifo_rst_n;     // sync fifo reset
   input                set_tx_empty_en_flg_edg;     // sync fifo reset
   input [`IC_TX_TL_RS-1:0] ic_tx_tl;        // tx fifo empty threshold
   input  [`RX_ABW-1:0] ic_rx_tl;           // rx fifo full threshold
   input                    tx_push;        // tx fifo push
   input                    rx_pop;         // rx fifo pop
   input                    tx_pop_flg;//if pclk is async. to ic_clk, this signal toggles on tx_pop signal
   input                    rx_push_flg;//if pclk is async. to ic_clk, this signal toggles on rx_push signal
   

   output                   tx_empty;       // tx fifo empty status
   output                   rx_full;        // rx fifo full status
   output                   tx_full;        // tx fifo full status   
   output                   rx_empty;       // rx fifo empty status   

   output                   tx_almost_empty;// tx fifo almost empty status
   output                   tx_overflow;    // tx fifo overflow

   output                   rx_almost_full; // rx fifo almost full status
   output                   rx_overflow;    // rx fifo overflow
   output                   rx_underflow;   // rx fifo underflow
   output   [`TX_ABW-1:0] tx_wr_addr;     // tx fifo write pointer
   output   [`TX_ABW-1:0] tx_rd_addr;     // tx fifo read pointer
   output                   tx_we_n;        // tx fifo write enable
   output   [`RX_ABW-1:0] rx_wr_addr;     // rx fifo write pointer
   output   [`RX_ABW-1:0] rx_rd_addr;     // rx fifo read pointer
   output                   rx_we_n;        // rx fifo write enable
   output                   tx_pop_sync;    // pclk sync tx fifo pop
   output                   rx_push_sync;   // pclk sync rx fifo push
   output                   gen_tx_almost_empty; 
   // ------------------------------------------------------
   // -- local registers and wires
   // ------------------------------------------------------
   reg                      tx_push_dly;
   reg                      tx_pop_sync_dly;
   reg                      rx_push_sync_dly;
   reg                      rx_pop_dly;
   
   reg                      tx_pop_flg_sync_q;
   reg                      rx_push_flg_sync_q;

   wire                     rx_empty;       // rx fifo empty status   
   wire                     tx_pop_flg_sync;
   wire                     rx_push_flg_sync;
   
   wire                     tx_pop_flg_edg;
   wire                     rx_push_flg_edg;
   //

   wire                     rx_full;        // rx fifo full status
   wire                     tx_full;        // tx fifo full status   
   
   wire                     tx_pop_sync;    // pclk sync tx fifo pop
   wire                     rx_push_sync;   // pclk sync rx fifo push
   wire                     tx_error_ir;
   wire                     rx_error_ir;
   wire                     i_rx_almost_full;
   wire                     tx_pop_n;
   wire                     tx_push_n;
   wire                     rx_pop_n;
   wire                     rx_push_n;
   wire [`TX_ABW-1:0]       tx_empty_level;
   wire [`RX_ABW-1:0]       rx_thresh;
   wire                     switch_almost_full;
   wire                     rx_thresh_eq_rx_buffer_depth;
   wire                     max_ic_rx_tl;
   reg  [`IC_TX_TL_RS:0]  tx_fifo_cmd_cntr;
   wire [`IC_TX_TL_RS:0]  tx_fifo_cmd_cntr_c;
   wire                     gen_tx_almost_empty;
   wire [`RX_ABW-1:0]       ic_rx_tl_int;
  
   wire nxten_tx_unconn, nxtf_tx_unconn, nxte_tx_unconn;
   wire nxten_rx_unconn, nxtf_rx_unconn, nxte_rx_unconn;
   wire                     tx_half_full_unconn;
   wire                     rx_half_full_unconn;
   wire                     tx_almost_full_unconn;
   wire                     rx_almost_empty_unconn;
   wire [`TX_ABW-1:0] wrdc_tx_unconn;
   wire [`RX_ABW-1:0] wrdc_rx_unconn;
   
   // ----------------------------------------------------------
   // -- Synchronization registers for input from ic_clk domain
   // ----------------------------------------------------------

   wire                     ic2pl_tx_pop_flg;
   wire                     sic2pl_tx_pop_flg_sync;
   assign ic2pl_tx_pop_flg = tx_pop_flg;
   assign tx_pop_flg_sync = sic2pl_tx_pop_flg_sync;
      kei_DW_apb_i2c_bcm21
       #(
       .F_SYNC_TYPE (`IC_SYNC_DEPTH),
       .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_tx_pop_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_tx_pop_flg)
        ,.data_d              (sic2pl_tx_pop_flg_sync)
      );


   wire                     ic2pl_rx_push_flg;
   wire                     sic2pl_rx_push_flg_sync;
   assign ic2pl_rx_push_flg = rx_push_flg;
   assign rx_push_flg_sync = sic2pl_rx_push_flg_sync;
      kei_DW_apb_i2c_bcm21
       #(
       .F_SYNC_TYPE (`IC_SYNC_DEPTH),
       .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_rx_push_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_rx_push_flg)
        ,.data_d              (sic2pl_rx_push_flg_sync) 
      );

   // ----------------------------------------------------------
   // -- Edge detection circuitry for input from ic_clk domain
   // ----------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : EDGE_DET_PROC
      if(presetn == 1'b0) begin
         tx_pop_flg_sync_q <= 1'b0; 
         rx_push_flg_sync_q <= 1'b0; 
      end else begin
         tx_pop_flg_sync_q <= tx_pop_flg_sync; 
         rx_push_flg_sync_q <= rx_push_flg_sync; 
      end
   end

   assign tx_pop_flg_edg       = ((~tx_pop_flg_sync_q   & tx_pop_flg_sync ) |(tx_pop_flg_sync_q  & (~tx_pop_flg_sync )));
   assign rx_push_flg_edg      = ((~rx_push_flg_sync_q  & rx_push_flg_sync) |(rx_push_flg_sync_q & (~rx_push_flg_sync)));

   
   // ------------------------------------------------------
   // -- overflow and underflow flags
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : ERROR_DLY_PROC
      if(presetn == 1'b0) begin
         tx_push_dly      <= 1'b0;
         tx_pop_sync_dly  <= 1'b0;
         rx_pop_dly       <= 1'b0;
         rx_push_sync_dly <= 1'b0;
         
      end else begin
         tx_push_dly      <= tx_push;
         tx_pop_sync_dly  <= tx_pop_flg_edg;
         rx_pop_dly       <= rx_pop;
         rx_push_sync_dly <= rx_push_flg_edg;
      end
   end // block: ERROR_DLY_PROC
   
   assign tx_overflow  = tx_error_ir & (tx_push_dly == 1'b1 & tx_pop_sync_dly == 1'b0);
   assign rx_overflow  = rx_error_ir & (rx_push_sync_dly == 1'b1 & rx_pop_dly == 1'b0);
   assign rx_underflow = rx_error_ir & (rx_pop_dly == 1'b1 & rx_empty == 1'b1);

   // -------------------------------------------------------
   // -- Generation of tx_push_sync and rx_pop_sync signals.
   //
   //  The tx_pop and rx_push signal are driven from the
   //  ssi_clk domain. They are synchronized over to the
   //  pclk domain here if pclk and ic_clk are asynchronous
   //  Both signal are also rising edge detected.
   // -------------------------------------------------------
   assign tx_pop_sync  = tx_pop_flg_edg;
   assign rx_push_sync = rx_push_flg_edg;

   // ------------------------------------------------------
   // -- active low input the DW_ffioctl_s1_df
   // ------------------------------------------------------
   assign tx_pop_n  = !tx_pop_sync;
   assign tx_push_n = !tx_push;
   assign rx_pop_n  = !rx_pop;
   assign rx_push_n = !rx_push_sync;

   assign tx_empty_level = ic_tx_tl[`TX_ABW-1:0];

   assign max_ic_rx_tl = (&ic_rx_tl[`RX_ABW-1:0]);
   assign ic_rx_tl_int = ic_rx_tl[`RX_ABW-1:0] + {{(`RX_ABW-1){1'b0}},1'b1};
   assign rx_thresh_eq_rx_buffer_depth = (rx_thresh == `IC_RX_BUFFER_DEPTH);
   assign rx_thresh          = (max_ic_rx_tl == 1'b1)                 ? ic_rx_tl[`RX_ABW-1:0]: ic_rx_tl_int[`RX_ABW-1:0];
   assign rx_almost_full     = (max_ic_rx_tl == 1'b1)                 ? rx_full : switch_almost_full;
   assign switch_almost_full = (rx_thresh_eq_rx_buffer_depth == 1'b1) ? rx_full : i_rx_almost_full;

   // Counter which increments on number of commands pushed in to fifo 
   // and decrements on the number of commands executed
   always @(posedge pclk or negedge presetn) begin : FIFO_CMD_CNTR_PROC
     if(presetn == 1'b0) begin
       tx_fifo_cmd_cntr <= {(`IC_TX_TL_RS+1){1'b0}};
     end
     else begin
       if (!tx_fifo_rst_n)
         tx_fifo_cmd_cntr <= {(`IC_TX_TL_RS+1){1'b0}};
       else if(set_tx_empty_en_flg_edg && tx_push)
         tx_fifo_cmd_cntr <= tx_fifo_cmd_cntr_c;
       else if(set_tx_empty_en_flg_edg && (tx_fifo_cmd_cntr !=0))
         tx_fifo_cmd_cntr <= tx_fifo_cmd_cntr - {{(`IC_TX_TL_RS){1'b0}},1'b1};
       else if(tx_push && (tx_fifo_cmd_cntr < `IC_TX_BUFFER_DEPTH))
         tx_fifo_cmd_cntr <= tx_fifo_cmd_cntr + {{(`IC_TX_TL_RS){1'b0}},1'b1};
     end
   end 

   assign tx_fifo_cmd_cntr_c = tx_fifo_cmd_cntr;
   // Generate Tx FIFO almost empty based on the command executed
   // in the ic_clk domain
   assign gen_tx_almost_empty = (tx_fifo_cmd_cntr <= {1'b0,ic_tx_tl});

   // ------------------------------------------------------
   // -- Instance of tx fifo controller
   // ------------------------------------------------------
   kei_DW_apb_i2c_bcm06
    #(`IC_TX_BUFFER_DEPTH, 2, `TX_ABW) U_tx_fifo
         (
          .clk           (pclk)
          ,.init_n       (tx_fifo_rst_n)
          ,.rst_n        (presetn)
          ,.push_req_n   (tx_push_n)
          ,.pop_req_n    (tx_pop_n)
          ,.ae_level     (tx_empty_level)
          ,.af_thresh    ({`TX_ABW{1'b1}})
          ,.we_n         (tx_we_n)
          ,.wr_addr      (tx_wr_addr)
          ,.rd_addr      (tx_rd_addr)
          ,.empty        (tx_empty)
          ,.almost_empty (tx_almost_empty)
          ,.full         (tx_full)
          //spyglass disable_block W528
          //SMD : A signal or variable is set but never read
          //SJ  : The BCM07 is a generic FIFO design, which has many features.
          //      But this use case does not use all features. Hence these signals
          //      are unused. But there is no functional issue, hence this can be 
          //      waived. 
          ,.almost_full  (tx_almost_full_unconn)
          ,.half_full    (tx_half_full_unconn)
          //spyglass enable_block W528
          ,.error        (tx_error_ir)
          //spyglass disable_block W528
          //SMD : A signal or variable is set but never read
          //SJ  : The BCM07 is a generic FIFO design, which has many features.
          //      But this use case does not use all features. Hence these signals
          //      are unused. But there is no functional issue, hence this can be 
          //      waived. 
          ,.wrd_count    (wrdc_tx_unconn)
          ,.nxt_empty_n  (nxten_tx_unconn)
          ,.nxt_full     (nxtf_tx_unconn)
          ,.nxt_error    (nxte_tx_unconn) 
          //spyglass enable_block W528
          );


   // ------------------------------------------------------
   // -- Instance of rx fifo controller
   // ------------------------------------------------------
   kei_DW_apb_i2c_bcm06
    #(`IC_RX_BUFFER_DEPTH, 2, `RX_ABW) U_rx_fifo
         (
          .clk           (pclk)
          ,.init_n       (fifo_rst_n)
          ,.rst_n        (presetn)
          ,.push_req_n   (rx_push_n)
          ,.pop_req_n    (rx_pop_n)
          ,.ae_level     ({`RX_ABW{1'b0}})
          ,.af_thresh    (rx_thresh)
          ,.we_n         (rx_we_n)
          ,.wr_addr      (rx_wr_addr)
          ,.rd_addr      (rx_rd_addr)
          ,.empty        (rx_empty)
          //spyglass disable_block W528
          //SMD : A signal or variable is set but never read
          //SJ  : The BCM07 is a generic FIFO design, which has many features.
          //      But this use case does not use all features. Hence these signals
          //      are unused. But there is no functional issue, hence this can be 
          //      waived. 
          ,.almost_empty (rx_almost_empty_unconn)
          //spyglass enable_block W528
          ,.full         (rx_full)
          ,.almost_full  (i_rx_almost_full)
          //spyglass disable_block W528
          //SMD : A signal or variable is set but never read
          //SJ  : The BCM07 is a generic FIFO design, which has many features.
          //      But this use case does not use all features. Hence these signals
          //      are unused. But there is no functional issue, hence this can be 
          //      waived. 
          ,.half_full    (rx_half_full_unconn)
          //spyglass enable_block W528
          ,.error        (rx_error_ir)
          //spyglass disable_block W528
          //SMD : A signal or variable is set but never read
          //SJ  : The BCM07 is a generic FIFO design, which has many features.
          //      But this use case does not use all features. Hence these signals
          //      are unused. But there is no functional issue, hence this can be 
          //      waived. 
          ,.wrd_count    (wrdc_rx_unconn)
          ,.nxt_empty_n  (nxten_rx_unconn)
          ,.nxt_full     (nxtf_rx_unconn)
          ,.nxt_error    (nxte_rx_unconn) 
          //spyglass enable_block W528
          );

endmodule

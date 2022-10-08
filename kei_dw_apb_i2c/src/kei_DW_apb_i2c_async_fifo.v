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
// File Version     :        $Revision: #4 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_async_fifo.v#4 $ 
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


module kei_DW_apb_i2c_async_fifo
   (
    pclk,
                                presetn,
                                ic_clk,
                                ic_rst_n,
                                ptx_fifo_rst,
                                ictx_fifo_rst,
                                set_tx_empty_en_flg_edg,
                                ic_tx_tl,
                                tx_push,
                                tx_pop,
                                tx_pop_flg,
                                tx_pop_sync,
                                ptx_empty,
                                ictx_empty,
                                ptx_full, 
                                ptx_almost_empty,
                                gen_tx_almost_empty,
                                ptx_overflow,
                                tx_wr_addr,
                                tx_rd_addr,
                                tx_we_n,
                                prx_fifo_rst,
                                icrx_fifo_rst,
                                ic_rx_tl,
                                rx_pop,
                                rx_push,
                                rx_push_flg,
                                rx_push_sync,
                                prx_full, 
                                icrx_full, 
                                prx_empty,
                                prx_almost_full,
                                prx_overflow,
                                prx_underflow,
                                rx_wr_addr,
                                rx_rd_addr,
                                rx_we_n
                                );
   
   input                pclk;            // APB clock
   input                presetn;         // APB async reset
   input                ic_clk;          // I2C clock
   input                ic_rst_n;        // I2C async reset
   
   input                ptx_fifo_rst;   // Sync Tx fifo reset
   input                ictx_fifo_rst;  // Sync Tx fifo reset
   input                set_tx_empty_en_flg_edg;     // sync fifo reset
   input [`IC_TX_TL_RS-1:0] ic_tx_tl;     // tx fifo empty threshold
   input                tx_push;          // tx fifo push
   input                tx_pop;           // tx fifo pop
   input                tx_pop_flg;       // tx fifo pop toggle from ic_clk domain
   output               tx_pop_sync;      // pclk sync tx fifo pop
   output               ptx_empty;        // pclk sync tx fifo empty status
   output               ictx_empty;       // ic_clk sync tx fifo empty status
   output               ptx_full;         // pclk sync tx fifo full status   
   output               ptx_almost_empty; // pclk sync tx fifo almost empty status
   output               gen_tx_almost_empty; // pclk sync tx fifo almost empty status based 
   output               ptx_overflow;     // pclk sync tx fifo overflow
   output [`TX_ABW-1:0] tx_wr_addr;       // tx fifo write pointer
   output [`TX_ABW-1:0] tx_rd_addr;       // tx fifo read pointer
   output               tx_we_n;          // tx fifo write enable
   
   input                prx_fifo_rst;   // Sync Rx fifo reset
   input                icrx_fifo_rst;  // Sync Rx fifo reset
   input [`RX_ABW-1:0]  ic_rx_tl;         // rx fifo full threshold
   input                rx_pop;           // rx fifo pop
   input                rx_push;          // rx fifo push
   input                rx_push_flg;      // rx fifo push toggle from ic_clk domain 
   output               rx_push_sync;     // pclk sync rx fifo push
   output               prx_full;         // pclk sync rx fifo full status
   output               icrx_full;        // ic_clk sync rx fifo full status
   output               prx_empty;        // pclk sync rx fifo empty status   
   output               prx_almost_full;  // pclk sync rx fifo almost full status
   output               prx_overflow;     // pclk sync rx fifo overflow
   output               prx_underflow;    // pclk sync rx fifo underflow
   output [`RX_ABW-1:0] rx_wr_addr;       // rx fifo write pointer
   output [`RX_ABW-1:0] rx_rd_addr;       // rx fifo read pointer
   output               rx_we_n;          // rx fifo write enable

   // ------------------------------------------------------
   // -- local registers
   // ------------------------------------------------------
   reg                      tx_pop_flg_sync_q;
   reg                      rx_push_flg_sync_q;

   reg  [`IC_TX_TL_RS:0]  tx_fifo_cmd_cntr;

   reg                      tx_push_dly;
   reg                      rx_pop_dly;
   
   // ------------------------------------------------------
   // -- local wires
   // ------------------------------------------------------
   wire                     tx_pop_flg_sync;
   wire                     rx_push_flg_sync;

   wire                     tx_pop_flg_edg;
   wire                     rx_push_flg_edg;

   wire                     tx_pop_sync;
   wire                     rx_push_sync;

   wire                     ptx_fifo_rst_n;
   wire                     ictx_fifo_rst_n;
   wire                     prx_fifo_rst_n;
   wire                     icrx_fifo_rst_n;

   wire                     tx_pop_n;
   wire                     tx_push_n;
   wire                     rx_pop_n;
   wire                     rx_push_n;

   wire [`TX_ABW:0]         tx_empty_level;
   wire                     max_ic_rx_tl;
   wire [`RX_ABW-1:0]       ic_rx_tl_int;
   wire [`RX_ABW:0]         rx_thresh;

   wire [`IC_TX_TL_RS:0]  tx_fifo_cmd_cntr_c;
   wire                     gen_tx_almost_empty;

   wire                     rx_thresh_eq_rx_buffer_depth;
   wire                     switch_almost_full;
   wire                     i_rx_almost_full;

   wire                     tx_we_n;
   wire [`TX_ABW-1:0]       tx_wr_addr;
   wire [`TX_ABW-1:0]       tx_rd_addr;
   wire                     rx_we_n;
   wire [`RX_ABW-1:0]       rx_wr_addr;
   wire [`RX_ABW-1:0]       rx_rd_addr;


   
   wire                     ptx_empty;
   wire                     ptx_full;
   wire                     ptx_almost_empty;
   wire                     ptx_overflow_i;
   wire                     ptx_overflow;
   wire [`TX_ABW:0]         ptx_word_count;

   wire                     ictx_empty;

   wire                     ptx_ae_unconn;
   wire                     ptx_hf_unconn;
   wire                     ptx_af_unconn;
   
   wire                     ictx_ae_unconn;
   wire                     ictx_hf_unconn;
   wire                     ictx_af_unconn;
   wire                     ictx_full_unconn;
   wire                     ictx_underflow_unconn;
   wire [`TX_ABW:0]         ictx_word_count_unconn;

   wire                     icrx_full;

   wire                     prx_empty;
   wire                     prx_full;
   wire                     prx_almost_full;
   wire                     prx_overflow;
   wire                     prx_overflow_tog;
   reg                      prx_overflow_tog_q;
   wire                     prx_overflow_i;
   wire                     prx_underflow_i;
   wire                     prx_underflow;
   wire [`RX_ABW:0]         prx_word_count;

   wire                     icrx_overflow_i;
   wire                     icrx_overflow_r;
   wire                     icrx_overflow_edg;
   wire                     icrx_overflow_tog;

   wire                     icrx_empty_unconn;
   wire                     icrx_ae_unconn;
   wire                     icrx_hf_unconn;
   wire                     icrx_af_unconn;
   wire [`RX_ABW:0]         icrx_word_count_unconn;
   
   wire                     prx_ae_unconn;
   wire                     prx_hf_unconn;
   wire                     prx_af_unconn;

   // ----------------------------------------------------------
   // -- Synchronization registers for input from ic_clk domain
   // ----------------------------------------------------------

   kei_DW_apb_i2c_bcm21
    #(
     .F_SYNC_TYPE (`IC_SYNC_DEPTH),
     .VERIF_EN    (`IC_VERIF_EN)
   ) 
   U_DW_apb_i2c_bcm21_ic2pl_tx_pop_flg_psyzr
   (
      .clk_d               (pclk)
     ,.rst_d_n             (presetn)
     ,.data_s              (tx_pop_flg)
     ,.data_d              (tx_pop_flg_sync)
   );


   kei_DW_apb_i2c_bcm21
    #(
     .F_SYNC_TYPE (`IC_SYNC_DEPTH),
     .VERIF_EN    (`IC_VERIF_EN)
   ) 
   U_DW_apb_i2c_bcm21_ic2pl_rx_push_flg_psyzr
   (
      .clk_d               (pclk)
     ,.rst_d_n             (presetn)
     ,.data_s              (rx_push_flg)
     ,.data_d              (rx_push_flg_sync) 
   );


   // ----------------------------------------------------------
   // -- Edge detection circuitry for input from ic_clk domain
   // ----------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : EDGE_DET_PROC
      if(presetn == 1'b0) begin
         tx_pop_flg_sync_q  <= 1'b0; 
         rx_push_flg_sync_q <= 1'b0; 
      end else begin
         tx_pop_flg_sync_q  <= tx_pop_flg_sync; 
         rx_push_flg_sync_q <= rx_push_flg_sync; 
      end
   end

   assign tx_pop_flg_edg       = (tx_pop_flg_sync_q  ^ tx_pop_flg_sync);
   assign rx_push_flg_edg      = (rx_push_flg_sync_q ^ rx_push_flg_sync);
   
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
   // -- Active low Reset signal generation
   // ------------------------------------------------------
   assign ptx_fifo_rst_n  = !ptx_fifo_rst;
   assign ictx_fifo_rst_n = !ictx_fifo_rst;
   assign prx_fifo_rst_n  = !prx_fifo_rst;
   assign icrx_fifo_rst_n = !icrx_fifo_rst;

   // ------------------------------------------------------
   // -- Active low push and pop control signal generation
   // ------------------------------------------------------
   assign tx_pop_n  = !tx_pop;
   assign tx_push_n = !tx_push;
   assign rx_pop_n  = !rx_pop;
   assign rx_push_n = !rx_push;

   // ------------------------------------------------------
   // -- Set the Almost Empty Level and Almost Full Threshold
   // ------------------------------------------------------
   assign tx_empty_level = {1'b0, ic_tx_tl[`TX_ABW-1:0]};

   assign max_ic_rx_tl = (&ic_rx_tl[`RX_ABW-1:0]);
   assign ic_rx_tl_int = ic_rx_tl[`RX_ABW-1:0] + {{(`RX_ABW-1){1'b0}},1'b1};
   
   assign rx_thresh    = (max_ic_rx_tl == 1'b1) ? {1'b0, ic_rx_tl[`RX_ABW-1:0]}: {1'b0, ic_rx_tl_int[`RX_ABW-1:0]};

   // ------------------------------------------------------
   // -- Get the Tx FIFO Almost Empty based on command execution in the ic_clk domain
   // ------------------------------------------------------
   // Counter which increments on number of commands pushed in to fifo 
   // and decrements on the number of commands executed
   always @(posedge pclk or negedge presetn) begin : FIFO_CMD_CNTR_PROC
     if(presetn == 1'b0) begin
       tx_fifo_cmd_cntr <= {(`IC_TX_TL_RS+1){1'b0}};
     end
     else begin
       if (!ptx_fifo_rst_n)
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

//// reuse-pragma attr GenerateIf @IC_CLK_TYPE==0      
//   DW_apb_i2c_bcm06 #(`IC_TX_BUFFER_DEPTH, 2, `TX_ABW) U_tx_fifo
//         (
//          .clk           (pclk)
//          ,.init_n       (ptx_fifo_rst_n)
//          ,.rst_n        (presetn)
//          ,.push_req_n   (tx_push_n)
//          ,.pop_req_n    (tx_pop_n)
//          ,.diag_n       (1'b1)
//          ,.ae_level     (tx_empty_level)
//          ,.af_thresh    ({`TX_ABW{1'b1}})
//          ,.we_n         (tx_we_n)
//          ,.wr_addr      (tx_wr_addr)
//          ,.rd_addr      (tx_rd_addr)
//          ,.empty        (ptx_empty)
//          ,.almost_empty (ptx_almost_empty)
//          ,.full         (ptx_full)
//          ,.almost_full  (ptx_almost_full_unconn)
//          ,.half_full    (ptx_half_full_unconn)
//          ,.error        (ptx_error_ir)
//          ,.wrd_count    (pwrdc_tx_unconn)
//          ,.nxt_empty_n  (pnxten_tx_unconn)
//          ,.nxt_full     (pnxtf_tx_unconn)
//          ,.nxt_error    (pnxte_tx_unconn) 
//          );


//// reuse-pragma attr GenerateIf @IC_CLK_TYPE==0      
//   DW_apb_i2c_bcm06 #(`IC_RX_BUFFER_DEPTH, 2, `RX_ABW) U_rx_fifo
//         (
//          .clk           (pclk)
//          ,.init_n       (prx_fifo_rst_n)
//          ,.rst_n        (presetn)
//          ,.push_req_n   (rx_push_n)
//          ,.pop_req_n    (rx_pop_n)
//          ,.diag_n       (1'b1)
//          ,.ae_level     ({`RX_ABW{1'b0}})
//          ,.af_thresh    (rx_thresh)
//          ,.we_n         (rx_we_n)
//          ,.wr_addr      (rx_wr_addr)
//          ,.rd_addr      (rx_rd_addr)
//          ,.empty        (prx_empty)
//          ,.almost_empty (prx_almost_empty_unconn)
//          ,.full         (prx_full)
//          ,.almost_full  (i_rx_almost_full)
//          ,.half_full    (prx_half_full_unconn)
//          ,.error        (prx_error_ir)
//          ,.wrd_count    (pwrdc_rx_unconn)
//          ,.nxt_empty_n  (pnxten_rx_unconn)
//          ,.nxt_full     (pnxtf_rx_unconn)
//          ,.nxt_error    (pnxte_rx_unconn) 
//          );



   // ------------------------------------------------------
   // -- Instance of Tx FIFO controller
   // ------------------------------------------------------
       kei_DW_apb_i2c_bcm07
        #(
           .DEPTH (`IC_TX_BUFFER_DEPTH),
           .ADDR_WIDTH (`TX_ABW),
           //spyglass disable_block SelfDeterminedExpr-ML
           //SMD: Self determined expression present in the design.
           //SJ:  This Self Determined Expression is as per the design requirement. 
           //     There will not be any functional issue.
           .COUNT_WIDTH (`TX_ABW+1),
           //spyglass enable_block SelfDeterminedExpr-ML
           .ERR_MODE(1),
           .VERIF_EN(`IC_VERIF_EN),
           .PUSH_SYNC(`IC_SYNC_DEPTH),
           .POP_SYNC(`IC_SYNC_DEPTH)
           )
           U_tx_fifo(
           .clk_push        (pclk),
           .rst_push_n      (presetn),
           .init_push_n     (ptx_fifo_rst_n),
           .push_req_n      (tx_push_n),
           .push_empty      (ptx_empty),
           //spyglass disable_block W528
           //SMD : A signal or variable is set but never read
           //SJ  : The BCM07 is a generic FIFO design, which has many features.
           //      But this use case does not use all features. Hence these signals
           //      are unused. But there is no functional issue, hence this can be 
           //      waived. 
           .push_ae         (ptx_ae_unconn),
           .push_hf         (ptx_hf_unconn),
           .push_af         (ptx_af_unconn),
           //spyglass enable_block W528
           .push_full       (ptx_full),
           .push_error      (ptx_overflow_i),
           .push_word_count (ptx_word_count),
           .we_n            (tx_we_n),
           .wr_addr         (tx_wr_addr),


           .clk_pop         (ic_clk),
           .rst_pop_n       (ic_rst_n),
           .init_pop_n      (ictx_fifo_rst_n),
           .pop_req_n       (tx_pop_n),
           .pop_empty       (ictx_empty),
           //spyglass disable_block W528
           //SMD : A signal or variable is set but never read
           //SJ  : The BCM07 is a generic FIFO design, which has many features.
           //      But this use case does not use all features. Hence these signals
           //      are unused. But there is no functional issue, hence this can be 
           //      waived. 
           .pop_ae          (ictx_ae_unconn),
           .pop_hf          (ictx_hf_unconn),
           .pop_af          (ictx_af_unconn),
           .pop_full        (ictx_full_unconn),
           .pop_error       (ictx_underflow_unconn),
           .pop_word_count  (ictx_word_count_unconn),
           //spyglass enable_block W528
           .rd_addr         (tx_rd_addr)
          );


   // ------------------------------------------------------
   // -- Instance of Rx FIFO controller
   // ------------------------------------------------------
       kei_DW_apb_i2c_bcm07
        #(
           .DEPTH (`IC_RX_BUFFER_DEPTH),
           .ADDR_WIDTH (`RX_ABW),
           //spyglass disable_block SelfDeterminedExpr-ML
           //SMD: Self determined expression present in the design.
           //SJ:  This Self Determined Expression is as per the design requirement. 
           //     There will not be any functional issue.
           .COUNT_WIDTH (`RX_ABW+1),
           //spyglass enable_block SelfDeterminedExpr-ML
           .ERR_MODE(1),
           .VERIF_EN(`IC_VERIF_EN),
           .PUSH_SYNC(`IC_SYNC_DEPTH),
           .POP_SYNC(`IC_SYNC_DEPTH)
           )
           U_rx_fifo(
           .clk_push        (ic_clk),
           .rst_push_n      (ic_rst_n),
           .init_push_n     (icrx_fifo_rst_n),
           .push_req_n      (rx_push_n),
           //spyglass disable_block W528
           //SMD : A signal or variable is set but never read
           //SJ  : The BCM07 is a generic FIFO design, which has many features.
           //      But this use case does not use all features. Hence these signals
           //      are unused. But there is no functional issue, hence this can be 
           //      waived. 
           .push_empty      (icrx_empty_unconn),
           .push_ae         (icrx_ae_unconn),
           .push_hf         (icrx_hf_unconn),
           .push_af         (icrx_af_unconn),
           //spyglass enable_block W528
           .push_full       (icrx_full),
           .push_error      (icrx_overflow_i),
           //spyglass disable_block W528
           //SMD : A signal or variable is set but never read
           //SJ  : The BCM07 is a generic FIFO design, which has many features.
           //      But this use case does not use all features. Hence these signals
           //      are unused. But there is no functional issue, hence this can be 
           //      waived. 
           .push_word_count (icrx_word_count_unconn), 
           //spyglass enable_block W528
           .we_n            (rx_we_n),
           .wr_addr         (rx_wr_addr),
          
           .clk_pop         (pclk),
           .rst_pop_n       (presetn),
           .init_pop_n      (prx_fifo_rst_n),
           .pop_req_n       (rx_pop_n),
           .pop_empty       (prx_empty),
           //spyglass disable_block W528
           //SMD : A signal or variable is set but never read
           //SJ  : The BCM07 is a generic FIFO design, which has many features.
           //      But this use case does not use all features. Hence these signals
           //      are unused. But there is no functional issue, hence this can be 
           //      waived. 
           .pop_ae          (prx_ae_unconn),
           .pop_hf          (prx_hf_unconn),
           .pop_af          (prx_af_unconn),
           //spyglass enable_block W528
           .pop_full        (prx_full),
           .pop_error       (prx_underflow_i),
           .pop_word_count  (prx_word_count),
           .rd_addr         (rx_rd_addr)
          );


   // ------------------------------------------------------
   // -- Get the Tx FIFO Almost Empty
   // ------------------------------------------------------
   assign ptx_almost_empty =  (ptx_word_count <= tx_empty_level);

   // ------------------------------------------------------
   // -- Get the Rx FIFO Almost Full
   // ------------------------------------------------------
   assign i_rx_almost_full   =  (prx_word_count >= rx_thresh);
   assign rx_thresh_eq_rx_buffer_depth = (rx_thresh == `IC_RX_BUFFER_DEPTH);
   assign switch_almost_full = (rx_thresh_eq_rx_buffer_depth == 1'b1) ? prx_full : i_rx_almost_full;
   assign prx_almost_full    = (max_ic_rx_tl == 1'b1)                 ? prx_full : switch_almost_full;

   // ------------------------------------------------------
   // -- Overflow and Underflow flags (Asynchronous Mode)
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : ERROR_DLY_ASYNC_PROC
      if(presetn == 1'b0) begin
         tx_push_dly <= 1'b0;
         rx_pop_dly  <= 1'b0;
      end else begin
         tx_push_dly <= tx_push;
         rx_pop_dly  <= rx_pop;
      end
   end // block: ERROR_DLY_ASYNC_PROC

   assign ptx_overflow  = ptx_overflow_i && tx_push_dly; 

   kei_DW_apb_i2c_regs
    
   #(1)
   U_icrx_overflow_reg (
     .clk        (ic_clk),
     .resetn     (ic_rst_n),
     .data_in    (icrx_overflow_i),
     .data_r_out (icrx_overflow_r)
   );


   // ----------------------------------------------------------
   // -- This block generates icrx_overflow_tog signal, 
   // -- which toggles on the rising edge of icrx_overflow_edg
   // ----------------------------------------------------------
   assign icrx_overflow_edg = ((icrx_overflow_i == 1'b1) && (icrx_overflow_r == 1'b0));

   kei_DW_apb_i2c_tog
    
   U_icrx_overflow_tog (
     .clk          (ic_clk),
     .resetn       (ic_rst_n),
     .tog_data_in  (icrx_overflow_edg),
     .tog_data_out (icrx_overflow_tog)
   );


   kei_DW_apb_i2c_bcm21
    #(
     .F_SYNC_TYPE (`IC_SYNC_DEPTH),
     .VERIF_EN    (`IC_VERIF_EN)
   ) 
   U_rx_overflow_sync
   (
      .clk_d               (pclk)
     ,.rst_d_n             (presetn)
     ,.data_s              (icrx_overflow_tog)
     ,.data_d              (prx_overflow_tog) 
   );


   always @(posedge pclk or negedge presetn) begin : EDGE_DET_PRX_OVERFLOW_PROC
      if(presetn == 1'b0) begin
         prx_overflow_tog_q <= 1'b0; 
      end else begin
         prx_overflow_tog_q <= prx_overflow_tog; 
      end
   end

   assign prx_overflow_i = (prx_overflow_tog_q ^ prx_overflow_tog);

   assign prx_overflow  = prx_overflow_i;
   assign prx_underflow = prx_underflow_i && rx_pop_dly;


endmodule

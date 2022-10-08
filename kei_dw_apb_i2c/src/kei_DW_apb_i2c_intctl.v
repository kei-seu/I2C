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
// File Version     :        $Revision: #20 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_intctl.v#20 $ 
//
//
// File    : DW_apb_i2c_intctl.v
//
//
// Author  : Hani Saleh
// Created : Tue Jun 18 15:57:39 BST 2002
// Abstract: Interrupt Control module for the DW_apb_i2c macrocell
//
//        1: Contains Interrupt status and raw status registers
//
//        2: Drives all interrupt signals from the I2C.
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------

module kei_DW_apb_i2c_intctl 
  (
   // APB bus interface
   pclk,
                           presetn,
                           // DW_apb_i2c_biu interface
                           rd_en,
                           // internal i2c interrupt flags
                           rx_underflow,
                           rx_overflow,  
                           rx_almost_full,
                           tx_overflow,  
                           tx_almost_empty,
                           gen_tx_almost_empty,
                           mst_activity,
                           slv_activity,
                           slv_rx_aborted,
                           slv_fifo_filled_and_flushed,
                           tx_empty_ctrl,
                           ic_rx_under_intr,
                           ic_rx_over_intr,  
                           ic_rx_full_intr, 
                           ic_tx_over_intr,  
                           ic_tx_empty_intr,
                           ic_rd_req_intr,   
                           ic_tx_abrt_intr,  
                           ic_rx_done_intr,  
                           ic_activity_intr, 
                           ic_stop_det_intr, 
                           ic_start_det_intr,
                           ic_gen_call_intr,
                           //from the toggle module
                           ic_disable,   
                           tx_abrt_flg,   
                           rx_done_flg,   
                           ic_rd_req_flg, 
                           p_det_flg, 
                           s_det_flg, 
                           rx_gen_call_flg,
                           slv_clr_leftover_flg,
                           set_tx_empty_en_flg,
                           tx_abrt_source,//tx_abrt sources combined signals
                           //regfile interface signals
                           ic_clr_intr_en,
                           ic_clr_rx_under_en,
                           ic_clr_rx_over_en,
                           ic_clr_tx_over_en,
                           ic_clr_rd_req_en,
                           ic_clr_tx_abrt_en,
                           ic_clr_rx_done_en,
                           ic_clr_activity_en,
                           ic_clr_stop_det_en,
                           ic_clr_start_det_en,
                           ic_clr_gen_call_en,
                           ic_enable,
                           ic_intr_mask,
                           ic_intr_stat,
                           ic_raw_intr_stat,
                           tx_abrt_flg_edg,
                           mst_activity_sync,
                           slv_activity_sync,
                           activity,
                           slv_rx_aborted_sync,
                           slv_fifo_filled_and_flushed_sync,
                           slv_clr_leftover_flg_edg,
                           set_tx_empty_en_flg_edg,
                           ic_tx_abrt_source,
                           ic_ack_general_call, 
                           //to top level outputs
                           ic_en
                           );
   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input pclk;       // APB clock 
   input presetn;    // APB async reset
   input rd_en;      // read enable
   input rx_overflow;  
   input rx_underflow; 
   input rx_almost_full; // rx fifo almost full status
   input tx_overflow;  
   input tx_almost_empty; 
   input gen_tx_almost_empty; 
   input mst_activity;
   input slv_activity;
   input slv_rx_aborted;
   input slv_fifo_filled_and_flushed;
   input tx_empty_ctrl;
 
   //inputs from the toggle module
   input ic_disable;
   input tx_abrt_flg;//if pclk is async. to ic_clk, this signal toggles on tx_abrt signal
   input rx_done_flg;//if pclk is async. to ic_clk, this signal toggles on rx_done signal
   input ic_rd_req_flg;//if pclk is async. to ic_clk, this signal toggles on ic_rd_req signal
   input p_det_flg;//if pclk is async. to ic_clk, this signal toggles on p_det signal
   input s_det_flg;//if pclk is async. to ic_clk, this signal toggles on s_det signal
   input rx_gen_call_flg;//if pclk is async. to ic_clk, this signal toggles on rx_gen_call signal
   input [`IC_TX_ABRT_SOURCE_RS-1:0] tx_abrt_source;//tx_abrt sources combined signals
   input slv_clr_leftover_flg;//
   input set_tx_empty_en_flg;
   
   input ic_clr_intr_en;
   input ic_clr_rx_under_en;
   input ic_clr_rx_over_en;
   input ic_clr_tx_over_en;
   input ic_clr_rd_req_en;
   input ic_clr_tx_abrt_en;
   input ic_clr_rx_done_en;
   input ic_clr_activity_en;
   input ic_clr_stop_det_en;
   input ic_clr_start_det_en;
   input ic_clr_gen_call_en;
   input ic_enable;
   input [`IC_INTR_MASK_RS-1:0]      ic_intr_mask;
   
   //OUTPUTS
   //active high inturrepts
   output                            ic_rx_over_intr;  
   output                            ic_rx_under_intr; 
   output                            ic_rx_full_intr;
   output                            ic_tx_over_intr;  
   output                            ic_tx_abrt_intr;  
   output                            ic_rx_done_intr;  
   output                            ic_rd_req_intr;
   output                            ic_tx_empty_intr; 
   output                            ic_activity_intr; 
   output                            ic_stop_det_intr;
   output                            ic_start_det_intr;
   output                            ic_gen_call_intr;
   //active low inturrepts
   
   output [`IC_RAW_INTR_STAT_RS-1:0] ic_raw_intr_stat;
   output [`IC_INTR_STAT_RS-1:0]     ic_intr_stat;
   output [`IC_TX_ABRT_SOURCE_RS-1:0] ic_tx_abrt_source;//register that indicates tx_abrt source

   // Register that indicates if general call sequenes should be ACKD'd.
   input                             ic_ack_general_call;

   output                            ic_en;//logic 1: ic is enabled
   output                            tx_abrt_flg_edg;//this output is used to flush the tx fifo buffer
   output        mst_activity_sync;
   output        slv_activity_sync;
   output                            activity;//syncronouse acticity signal 
   output                            slv_rx_aborted_sync;
   output                            slv_fifo_filled_and_flushed_sync;
   output                            slv_clr_leftover_flg_edg;
   output                            set_tx_empty_en_flg_edg;

   // ------------------------------------------------------
   // -- local registers and wires
   // ------------------------------------------------------
   reg                               ic_en;//logic 1: ic is enabled
   reg                               ic_gen_call_intr;
   reg                               ic_start_det_intr;
   reg                               ic_stop_det_intr;
   reg                               ic_activity_intr;
   reg                               ic_rx_done_intr;
   reg                               ic_tx_abrt_intr;
   reg                               ic_rd_req_intr;
   reg                               ic_tx_empty_intr;
   reg                               ic_tx_over_intr;
   reg                               ic_rx_full_intr;
   reg                               ic_rx_over_intr;
   reg                               ic_rx_under_intr;
  
   
   reg [`IC_INTR_STAT_RS-1:0]        ic_intr_stat_int;
   reg                               raw_rx_under;
   reg                               raw_rx_over;
   wire                              raw_rx_full;
   //reg                               raw_rx_full;
   reg                               raw_tx_over;
   wire                              raw_tx_empty;
   //reg                               raw_tx_empty;
   reg                               raw_rd_req;
   reg                               raw_tx_abrt;
   reg                               raw_rx_done;
   reg                               raw_activity;
   reg                               raw_stop_det;
   reg                               raw_start_det;
   reg                               raw_gen_call;
   
   //synchronization registers
   wire                              slv_rx_aborted_sync;
   wire                              slv_fifo_filled_and_flushed;
   
   reg                               tx_abrt_flg_sync_q;
   reg                               rx_done_flg_sync_q;   
   reg                               ic_rd_req_flg_sync_q;  
   reg                               p_det_flg_sync_q;
   reg                               s_det_flg_sync_q;
   reg                               rx_gen_call_flg_sync_q;   
   reg                               slv_clr_leftover_flg_sync_q;
   reg                               set_tx_empty_en_flg_sync_q;

   reg [`IC_TX_ABRT_SOURCE_RS-1:0]   tx_abrt_source_sync_q;//tx_abrt sources combined signals


   reg [`IC_TX_ABRT_SOURCE_RS-1:0]   ic_tx_abrt_source;//register that indicates tx_abrt source
   
   //wires
   wire [`IC_TX_ABRT_SOURCE_RS-1:0]  tx_abrt_source_sync;//tx_abrt sources combined signals
   wire [`IC_TX_ABRT_SOURCE_RS-1:0]  tx_abrt_source_edg;//tx_abrt sources combined signals
   wire                              mst_activity_sync; 
   wire                              slv_activity_sync; 
   wire                              ic_disable_sync; 
   
   wire                              tx_abrt_flg_sync;
   wire                              rx_done_flg_sync;  
   wire                              ic_rd_req_flg_sync;   
   wire                              p_det_flg_sync;
   wire                              s_det_flg_sync;
   wire                              rx_gen_call_flg_sync;
   wire                              slv_clr_leftover_flg_sync;
   wire                              set_tx_empty_en_flg_sync;

   wire                              tx_abrt_flg_edg;
   wire                              rx_done_flg_edg; 
   wire                              ic_rd_req_flg_edg;   
   wire                              p_det_flg_edg;
   wire                              s_det_flg_edg;
   wire                              rx_gen_call_flg_edg;   
   wire                              slv_clr_leftover_flg_edg;   
   wire                              set_tx_empty_en_flg_edg;   

   wire                              activity;
   //wires to avoid reading from output ports (RMM rule)
   wire [`IC_INTR_STAT_RS-1:0]       ic_intr_stat;

   
  
   // ----------------------------------------------------------
   // -- Synchronization registers for flags input from ic_clk domain
   // ----------------------------------------------------------
   

   wire [`IC_TX_ABRT_SOURCE_RS-1:0]  ic2pl_tx_abrt_source;
   wire [`IC_TX_ABRT_SOURCE_RS-1:0]  sic2pl_tx_abrt_source_sync;
   assign ic2pl_tx_abrt_source = tx_abrt_source;
   assign tx_abrt_source_sync = sic2pl_tx_abrt_source_sync;

      kei_DW_apb_i2c_bcm21
       #(
        .WIDTH       (`IC_TX_ABRT_SOURCE_RS),
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_tx_abrt_source_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_tx_abrt_source)
        ,.data_d              (sic2pl_tx_abrt_source_sync)
      );


   wire                              ic2pl_tx_abrt_flg;
   wire                              sic2pl_tx_abrt_flg_sync;
   assign ic2pl_tx_abrt_flg = tx_abrt_flg;
   assign tx_abrt_flg_sync = sic2pl_tx_abrt_flg_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_tx_abrt_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_tx_abrt_flg)
        ,.data_d              (sic2pl_tx_abrt_flg_sync)
      );


   wire                              ic2pl_rx_done_flg;
   wire                              ic2pl_ic_rd_req_flg;
   wire                              sic2pl_rx_done_flg_sync;  
   wire                              sic2pl_ic_rd_req_flg_sync;  
   assign ic2pl_rx_done_flg = rx_done_flg;
   assign ic2pl_ic_rd_req_flg = ic_rd_req_flg;
   assign rx_done_flg_sync = sic2pl_rx_done_flg_sync;
   assign ic_rd_req_flg_sync = sic2pl_ic_rd_req_flg_sync;

      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_rx_done_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_rx_done_flg)
        ,.data_d              (sic2pl_rx_done_flg_sync)
      );

      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_ic_rd_req_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_ic_rd_req_flg)
        ,.data_d              (sic2pl_ic_rd_req_flg_sync)
      );


   wire                               ic2pl_p_det_flg;
   wire                               sic2pl_p_det_flg_sync;
   assign ic2pl_p_det_flg = p_det_flg;
   assign p_det_flg_sync = sic2pl_p_det_flg_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_p_det_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_p_det_flg)
        ,.data_d              (sic2pl_p_det_flg_sync)
      );


   wire                              ic2pl_s_det_flg;
   wire                              sic2pl_s_det_flg_sync;
   assign ic2pl_s_det_flg = s_det_flg;
   assign s_det_flg_sync = sic2pl_s_det_flg_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_s_det_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_s_det_flg)
        ,.data_d              (sic2pl_s_det_flg_sync)
      );


   wire                              ic2pl_rx_gen_call_flg;
   wire                              sic2pl_rx_gen_call_flg_sync;
   assign ic2pl_rx_gen_call_flg = rx_gen_call_flg;
   assign rx_gen_call_flg_sync = sic2pl_rx_gen_call_flg_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_rx_gen_call_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_rx_gen_call_flg)
        ,.data_d              (sic2pl_rx_gen_call_flg_sync)
      );


   wire                              ic2pl_slv_clr_leftover_flg;
   wire                              sic2pl_slv_clr_leftover_flg_sync;
   assign ic2pl_slv_clr_leftover_flg = slv_clr_leftover_flg;
   assign slv_clr_leftover_flg_sync = sic2pl_slv_clr_leftover_flg_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_slv_clr_leftover_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_slv_clr_leftover_flg)
        ,.data_d              (sic2pl_slv_clr_leftover_flg_sync)
      );


   wire                              ic2pl_set_tx_empty_en_flg;
   wire                              sic2pl_set_tx_empty_en_flg_sync;
   assign ic2pl_set_tx_empty_en_flg = set_tx_empty_en_flg;
   assign set_tx_empty_en_flg_sync = sic2pl_set_tx_empty_en_flg_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_set_tx_empty_en_flg_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_set_tx_empty_en_flg)
        ,.data_d              (sic2pl_set_tx_empty_en_flg_sync)
      );
































    
   // ----------------------------------------------------------
   // -- Edge detection circuitry for input from ic_clk domain
   // ----------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : EDGE_DET_PROC
      if(presetn == 1'b0) begin
         tx_abrt_flg_sync_q <= 1'b0;   
         rx_done_flg_sync_q <= 1'b0;
         ic_rd_req_flg_sync_q <= 1'b0;
         p_det_flg_sync_q <= 1'b0;
         s_det_flg_sync_q <= 1'b0; 
         rx_gen_call_flg_sync_q <= 1'b0;
         slv_clr_leftover_flg_sync_q <= 1'b0;
         tx_abrt_source_sync_q <=  {`IC_TX_ABRT_SOURCE_RS{1'b0}};
         set_tx_empty_en_flg_sync_q <= 1'b0;
      end else begin
         tx_abrt_flg_sync_q <= tx_abrt_flg_sync;   
         rx_done_flg_sync_q <= rx_done_flg_sync;   
         ic_rd_req_flg_sync_q <= ic_rd_req_flg_sync; 
         p_det_flg_sync_q <= p_det_flg_sync; 
         s_det_flg_sync_q <= s_det_flg_sync;
         rx_gen_call_flg_sync_q <= rx_gen_call_flg_sync;
         slv_clr_leftover_flg_sync_q <= slv_clr_leftover_flg_sync;
         tx_abrt_source_sync_q <= tx_abrt_source_sync;
         set_tx_empty_en_flg_sync_q <= set_tx_empty_en_flg_sync;
      end
   end


   assign tx_abrt_source_edg       = ((~tx_abrt_source_sync_q       & tx_abrt_source_sync)       |(tx_abrt_source_sync_q       & (~tx_abrt_source_sync))      );   
   assign tx_abrt_flg_edg          = ((~tx_abrt_flg_sync_q          & tx_abrt_flg_sync)          |(tx_abrt_flg_sync_q          & (~tx_abrt_flg_sync))         );   
   assign rx_done_flg_edg          = ((~rx_done_flg_sync_q          & rx_done_flg_sync)          |(rx_done_flg_sync_q          & (~rx_done_flg_sync))         );
   assign ic_rd_req_flg_edg        = ((~ic_rd_req_flg_sync_q        & ic_rd_req_flg_sync)        |(ic_rd_req_flg_sync_q        & (~ic_rd_req_flg_sync))       ); 
   assign p_det_flg_edg            = ((~p_det_flg_sync_q            & p_det_flg_sync)            |(p_det_flg_sync_q            & (~p_det_flg_sync))           );
   assign s_det_flg_edg            = ((~s_det_flg_sync_q            & s_det_flg_sync)            |(s_det_flg_sync_q            & (~s_det_flg_sync))           );
   assign rx_gen_call_flg_edg      = ((~rx_gen_call_flg_sync_q      & rx_gen_call_flg_sync)      |(rx_gen_call_flg_sync_q      & (~rx_gen_call_flg_sync))     );
   assign slv_clr_leftover_flg_edg = ((~slv_clr_leftover_flg_sync_q & slv_clr_leftover_flg_sync) |(slv_clr_leftover_flg_sync_q & (~slv_clr_leftover_flg_sync)));
   assign set_tx_empty_en_flg_edg  = ((~set_tx_empty_en_flg_sync_q  & set_tx_empty_en_flg_sync)  |(set_tx_empty_en_flg_sync_q  & (~set_tx_empty_en_flg_sync)) );

   

   wire                              ic2pl_mst_activity; 
   wire                              sic2pl_mst_activity_sync;
   assign ic2pl_mst_activity = mst_activity;
   assign mst_activity_sync = sic2pl_mst_activity_sync;
   kei_DW_apb_i2c_bcm21
    #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_mst_activity_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_mst_activity)
        ,.data_d              (sic2pl_mst_activity_sync)
      );


   wire                              ic2pl_slv_activity; 
   wire                              sic2pl_slv_activity_sync;
   assign ic2pl_slv_activity = slv_activity;
   assign slv_activity_sync = sic2pl_slv_activity_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_slv_activity_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_slv_activity)
        ,.data_d              (sic2pl_slv_activity_sync)
      );


















   assign activity     = mst_activity_sync | slv_activity_sync;

   wire                      ic2pl_ic_disable;
   wire                      sic2pl_ic_disable_sync;
   assign ic2pl_ic_disable = ic_disable;
   assign ic_disable_sync  = sic2pl_ic_disable_sync;
   kei_DW_apb_i2c_bcm41
    #(
        .RST_VAL     (1),
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm41_ic2pl_ic_disable_psyzr(
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_ic_disable)
        ,.data_d              (sic2pl_ic_disable_sync)
      );




   // ----------------------------------------------------------
   // -- Generate top level signals
   // ----------------------------------------------------------
   //pclk domain top level signals
   always @(posedge pclk or negedge presetn) begin : IC_EN_PROC
      if(presetn == 1'b0) 
        begin
           ic_en <= 1'b0;
        end else 
          begin
             ic_en <= ic_enable | activity | (!ic_disable_sync);
          end
   end


   wire                              ic2pl_slv_rx_aborted;
   wire                              sic2pl_slv_rx_aborted_sync;
   assign ic2pl_slv_rx_aborted = slv_rx_aborted;
   assign slv_rx_aborted_sync = sic2pl_slv_rx_aborted_sync;
   wire                              ic2pl_slv_fifo_filled_and_flushed;
   wire                              sic2pl_slv_fifo_filled_and_flushed_sync;
   assign ic2pl_slv_fifo_filled_and_flushed = slv_fifo_filled_and_flushed;
   assign slv_fifo_filled_and_flushed_sync = sic2pl_slv_fifo_filled_and_flushed_sync;
   // ------------------------------------------------------
   // Generate the PCLK-synchronised versions of:
   // - slv_rx_aborted
   // ------------------------------------------------------
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_slv_rx_aborted_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_slv_rx_aborted)
        ,.data_d              (sic2pl_slv_rx_aborted_sync)
      );

   // ------------------------------------------------------
   // Generate the PCLK-synchronised versions of:
   // - slv_fifo_filled_and_flushed
   // ------------------------------------------------------
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_ic2pl_slv_fifo_filled_and_flushed_psyzr
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (ic2pl_slv_fifo_filled_and_flushed)
        ,.data_d              (sic2pl_slv_fifo_filled_and_flushed_sync)
      );


   // ------------------------------------------------------
   // -- Raw Interrupt Status Register - Read Only
   //
   //  This register contains the raw status of all
   //  DW_apb_i2c interrupts.
   //  Registers bits are set by hardware.
   // ------------------------------------------------------

   // tx fifo empty interrupt
   // is set and cleared under hardware control
   assign raw_tx_empty = ic_en & (tx_empty_ctrl ? gen_tx_almost_empty : tx_almost_empty);
   // rx fifo full interrupt
   // is set and cleared under hardware control
   assign raw_rx_full = rx_almost_full & ic_en;
   

    // tx fifo overflow interrupt is set by hardware
    // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_tx_fifo_overflow_PROC
      if (presetn == 1'b0)
        raw_tx_over <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_tx_over <= 1'b0;
              else
          if (tx_overflow == 1'b1)
            raw_tx_over <= 1'b1;
          else 
            if ((ic_clr_tx_over_en == 1'b1 || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_tx_over <= 1'b0;
   end
   
    // rx fifo overflow interrupt is set by hardware
    // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_rx_fifo_overflow_PROC
      if (presetn == 1'b0)
        raw_rx_over <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_rx_over <= 1'b0;
        else
          if (rx_overflow == 1'b1)
            raw_rx_over <= 1'b1;
          else
            if ((ic_clr_rx_over_en == 1'b1  || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_rx_over <= 1'b0;
    end
   
    // rx fifo underflow interrupt is set by hardware
    // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_rx_fifo_underflow_PROC
      if (presetn == 1'b0)
        raw_rx_under <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_rx_under <= 1'b0;
              else
          if (rx_underflow == 1'b1)
            raw_rx_under <= 1'b1;
          else 
            if ((ic_clr_rx_under_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_rx_under <= 1'b0;
   end
   
   // rx read request interrupt is set by hardware
   // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_rx_rd_req_PROC
      if (presetn == 1'b0)
        raw_rd_req <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_rd_req <= 1'b0;
        else
          if (ic_rd_req_flg_edg == 1'b1)
            raw_rd_req <= 1'b1;
          else 
            if ((ic_clr_rd_req_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_rd_req <= 1'b0;
   end
   
   // tx abrt interrupt is set by hardware
   // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_tx_abrt_PROC
      if (presetn == 1'b0)
        begin
           raw_tx_abrt <= 1'b0;
        end
      else
        if (ic_en == 1'b0)
          begin
             raw_tx_abrt <= 1'b0;
          end
      
        else
          begin
             if (tx_abrt_flg_edg == 1'b1)
               raw_tx_abrt <= 1'b1;
             else 
               if ((ic_clr_tx_abrt_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
                 raw_tx_abrt <= 1'b0;


          end // else: !if(ic_en == 1'b0)

   end

   // ic_tx_abrt_source register is set by hardware
   // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_ic_tx_abrt_source_PROC
      if (presetn == 1'b0)
        begin
           ic_tx_abrt_source <= {`IC_TX_ABRT_SOURCE_RS{1'b0}};
        end
      else if ((ic_clr_tx_abrt_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1)
               ic_tx_abrt_source <= {`IC_TX_ABRT_SOURCE_RS{1'b0}};
      else
        begin
           if(tx_abrt_source_edg[0] == 1'b1)  ic_tx_abrt_source[0] <= 1'b1;
           if(tx_abrt_source_edg[1] == 1'b1)  ic_tx_abrt_source[1] <= 1'b1;
           if(tx_abrt_source_edg[2] == 1'b1)  ic_tx_abrt_source[2] <= 1'b1;
           if(tx_abrt_source_edg[3] == 1'b1)  ic_tx_abrt_source[3] <= 1'b1;
           if(tx_abrt_source_edg[4] == 1'b1)  ic_tx_abrt_source[4] <= 1'b1;
           if(tx_abrt_source_edg[5] == 1'b1)  ic_tx_abrt_source[5] <= 1'b1;
           if(tx_abrt_source_edg[6] == 1'b1)  ic_tx_abrt_source[6] <= 1'b1;
           if(tx_abrt_source_edg[7] == 1'b1)  ic_tx_abrt_source[7] <= 1'b1;
           if(tx_abrt_source_edg[8] == 1'b1)  ic_tx_abrt_source[8] <= 1'b1;
           if(tx_abrt_source_edg[9] == 1'b1)  ic_tx_abrt_source[9] <= 1'b1;
           if(tx_abrt_source_edg[10] == 1'b1) ic_tx_abrt_source[10] <= 1'b1;
           if(tx_abrt_source_edg[11] == 1'b1) ic_tx_abrt_source[11] <= 1'b1;
           if(tx_abrt_source_edg[12] == 1'b1) ic_tx_abrt_source[12] <= 1'b1;
           if(tx_abrt_source_edg[13] == 1'b1) ic_tx_abrt_source[13] <= 1'b1;
           if(tx_abrt_source_edg[14] == 1'b1) ic_tx_abrt_source[14] <= 1'b1;
           if(tx_abrt_source_edg[15] == 1'b1) ic_tx_abrt_source[15] <= 1'b1;
           if(tx_abrt_source_edg[16] == 1'b1) ic_tx_abrt_source[16] <= 1'b1;
        end
   end
   // rx done interrupt is set by hardware
   // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_rx_done_PROC
      if (presetn == 1'b0)
        raw_rx_done <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_rx_done <= 1'b0;
        else
          if (rx_done_flg_edg == 1'b1)
            raw_rx_done <= 1'b1;
          else 
            if ((ic_clr_rx_done_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_rx_done <= 1'b0;
   end

   // ic activity interrupt is set by hardware
   // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_activity_PROC
      if (presetn == 1'b0)
        raw_activity <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_activity <= 1'b0;
              else
          if (activity == 1'b1)
            raw_activity <= 1'b1;
          else 
            if ((ic_clr_activity_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_activity <= 1'b0;
   end
   
   // ic start_det interrupt is set by hardware
   // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : raw_start_det_PROC
      if (presetn == 1'b0)
        raw_start_det <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_start_det <= 1'b0;
        else
          if (s_det_flg_edg == 1'b1)
            raw_start_det <= 1'b1;
          else 
            if ((ic_clr_start_det_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_start_det <= 1'b0;
   end
   
   // ic stop_det interrupt is set by hardware
   // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : RAW_STOP_DET_PROC
      if (presetn == 1'b0)
        raw_stop_det <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_stop_det <= 1'b0;
        else
          //          if (stop_det_sync == 1'b1)
          if (p_det_flg_edg == 1'b1)
            raw_stop_det <= 1'b1;
          else 
            if ((ic_clr_stop_det_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_stop_det <= 1'b0;
   end




   // ic gen_call interrupt is set by hardware
   // and cleared by a SW-read.
   always @(posedge pclk or negedge presetn) begin : RAW_GEN_CALL_PROC
      if (presetn == 1'b0)
        raw_gen_call <= 1'b0;
      else
        if (ic_en == 1'b0)
          raw_gen_call <= 1'b0;
        else
   // STAR 9000093547, 11/3/2008, JS
   // gen call interrupt will not assert if i2c is programmed to
   // NACK a gen call sequence.
          if ((rx_gen_call_flg_edg == 1'b1) 
              & ic_ack_general_call
            )
            raw_gen_call <= 1'b1;
          else 
            if ((ic_clr_gen_call_en == 1'b1   || ic_clr_intr_en == 1'b1) && rd_en == 1'b1) 
              raw_gen_call <= 1'b0;
   end

// MOH interrupt set and cleared by hardware
   
   //ic_raw_intr_stat generation

   assign          ic_raw_intr_stat[14] = 1'b0;
   assign          ic_raw_intr_stat[13] = 1'b0;
   assign          ic_raw_intr_stat[12] = 1'b0;
   assign          ic_raw_intr_stat[11] = raw_gen_call;
   assign          ic_raw_intr_stat[10] = raw_start_det;
   assign          ic_raw_intr_stat[9] = raw_stop_det;
   assign          ic_raw_intr_stat[8] = raw_activity;
   assign          ic_raw_intr_stat[7] = raw_rx_done;
   assign          ic_raw_intr_stat[6] = raw_tx_abrt;
   assign          ic_raw_intr_stat[5] = raw_rd_req;
   assign          ic_raw_intr_stat[4] = raw_tx_empty;
   assign          ic_raw_intr_stat[3] = raw_tx_over;
   assign          ic_raw_intr_stat[2] = raw_rx_full;
   assign          ic_raw_intr_stat[1] = raw_rx_over;
   assign          ic_raw_intr_stat[0] = raw_rx_under;
   
   
   // ------------------------------------------------------
   // -- Interrupt Status Register - Read Only
   //
   //  This register contains the status of all
   //  DW_apb_i2c interrupts after masking.
   // ------------------------------------------------------
   always @(ic_intr_mask or ic_raw_intr_stat) begin : ISR_PROC
        ic_intr_stat_int = ic_intr_mask & ic_raw_intr_stat;
   end
   assign ic_intr_stat = ic_intr_stat_int;
   

   // ------------------------------------------------------
   // -- Active High Interrupt Outputs
   //
   //  DW_apb_i2c interrupts can be active high or low
   //  depending on configuration parameter IC_INTR_POL
   // ------------------------------------------------------

   always @(posedge pclk or negedge presetn) begin : REGISTER_INTR_1_PROC
     if (presetn == 1'b0) begin
         ic_gen_call_intr    <= 1'd0;
         ic_start_det_intr   <= 1'd0;
         ic_stop_det_intr    <= 1'd0;
         ic_activity_intr    <= 1'd0;
         ic_rx_done_intr     <= 1'd0;
         ic_tx_abrt_intr     <= 1'd0;
         ic_rd_req_intr      <= 1'd0;
         ic_tx_empty_intr    <= 1'd0;
         ic_tx_over_intr     <= 1'd0;
         ic_rx_full_intr     <= 1'd0;
         ic_rx_over_intr     <= 1'd0;
         ic_rx_under_intr    <= 1'd0;
     end
     else begin
         ic_gen_call_intr    <= ic_intr_stat_int[11];
         ic_start_det_intr   <= ic_intr_stat_int[10];
         ic_stop_det_intr    <= ic_intr_stat_int[9] ;
         ic_activity_intr    <= ic_intr_stat_int[8] ;
         ic_rx_done_intr     <= ic_intr_stat_int[7] ;
         ic_tx_abrt_intr     <= ic_intr_stat_int[6] ;
         ic_rd_req_intr      <= ic_intr_stat_int[5] ;
         ic_tx_empty_intr    <= ic_intr_stat_int[4] ;
         ic_tx_over_intr     <= ic_intr_stat_int[3] ;
         ic_rx_full_intr     <= ic_intr_stat_int[2] ;
         ic_rx_over_intr     <= ic_intr_stat_int[1] ;
         ic_rx_under_intr    <= ic_intr_stat_int[0] ;
     end
   end

endmodule // DW_apb_i2c_intctl

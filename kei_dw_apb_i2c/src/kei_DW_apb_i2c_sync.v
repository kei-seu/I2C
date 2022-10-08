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
// File Version     :        $Revision: #19 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_sync.v#19 $ 
//
//
//
//
//
// File    : DW_apb_i2c_sync.v
// Author  : Hani Saleh
// Created : Sep, 2002
// Abstract: This module performs the synchronization of signals
//           Traveling from the pclk to the ic_clk domain
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------

// -----------------------------------------------------------
// -- Macros
// -----------------------------------------------------------


module kei_DW_apb_i2c_sync
  (
   ic_rst_n,
                         ic_clk,
                         //Signals from pclk domain
                         ic_enable,
                         ic_master,
                         ic_10bit_mst,
                         ic_hs,
                         ic_fs,
                         ic_ss,
                         tx_empty,
                         ic_10bit_slv,
                         ic_rstrt_en,
                         ic_slave_en,
                         p_det_ifaddr,
                         ic_sda_hold,
                         ic_ack_general_call,
                         //signals to ic_clk domain
                         ic_10bit_slv_sync,
                         ic_enable_sync,
                         ic_abort_sync,
                         ic_master_sync,
                         ic_hs_sync,
                         ic_fs_sync,
                         ic_ss_sync,
                         ic_10bit_mst_sync,
                         tx_empty_sync,
                         tx_empty_sync_hl,
                         ic_rstrt_en_sync,
                         ic_slave_en_sync,
                         p_det_ifaddr_sync, 
                         ic_ack_general_call_sync,
                         ic_sda_tx_hold_sync,
                         ic_sda_rx_hold_sync   
                         );

   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input ic_clk;    // module clock: runs i2c module
   input ic_rst_n;  // I2C module asynchronous reset input active low


   input [`IC_ENABLE_RS_INT-1:0] ic_enable; // logic 1: enable i2c module
   input ic_master; //logic 1: IC module is a Master; logic 0: slave
   input ic_10bit_mst; // logic 1: IC 10-bit address transfer mode
                       // logic 0: IC 7-bit address transfer mode
   input ic_10bit_slv; // logic 1: IC 10-bit address transfer mode
                       // logic 0: IC 7-bit address transfer modeg
   input ic_hs;  //logic 1: IC is in High Speed mode (3.4 Mb/s)
   input ic_fs;  //logic 1: IC is in Fast Speed mode (400 kb/s)
   input ic_ss;  //logic 1: IC is in Standard Speed mode (100 kb/s)
   input tx_empty; // tx fifo empty
   input                             ic_rstrt_en;//logic 1:Master can generate re-starts in general
   input                             ic_slave_en;//1: slave is enabled, 0:disabled
   input                             p_det_ifaddr;//Programmable option to generate STOP interrupt only if slave is addressed

// Adding IC_SDA_RX_HOLD_RS (8 bits) for calculating hold time while I2C acts as reciever
   input [`IC_SDA_HOLD_RS-1:0]         ic_sda_hold;
   input                               ic_ack_general_call;


   //outputs

   output tx_empty_sync;//tx_empty signal synchronized to ic_clk
   output ic_10bit_slv_sync ;//ic_10bit_slv signal synchronized to ic_clk
   output ic_enable_sync;//ic_enable signal synchronized to ic_clk
   output ic_abort_sync;//ic_abort signal synchronized to ic_clk
   output ic_master_sync;//ic_master signal synchronized to ic_clk
   output ic_hs_sync ;//ic_hs signal synchronized to ic_clk
   output ic_fs_sync ;//ic_fs signal synchronized to ic_clk
   output ic_ss_sync ;//ic_ss signal synchronized to ic_clk
   output ic_10bit_mst_sync;//ic_10bit_mst signal synchronized to ic_clk
   output ic_rstrt_en_sync;//logic 1:Master can generate re-starts in general
   output tx_empty_sync_hl;//logic 1:high to low edge detection of tx_empty_sync
   output ic_slave_en_sync;//1: slave is enabled, 0:disabled
   output p_det_ifaddr_sync;//Programmable option to generate STOP interrupt only if slave is addressed



   output [`IC_SDA_TX_HOLD_RS-1:0]         ic_sda_tx_hold_sync;  // SDA Hold time while I2C acts as transmitter
   output [`IC_SDA_RX_HOLD_RS-1:0]      ic_sda_rx_hold_sync;  // SDA Hold time while I2C acts as reciever
   output                               ic_ack_general_call_sync;

   // ----------------------------------------------------------
   // -- local registers
   // ----------------------------------------------------------
   reg              tx_empty_sync_r;

   // ----------------------------------------------------------
   // -- local wires
   // ----------------------------------------------------------
   wire      ic_10bit_slv_sync ;
   wire      ic_enable_sync;
   wire      ic_abort_sync;
   wire      ic_master_sync;
   wire      ic_hs_sync ;
   wire      ic_fs_sync ;
   wire      ic_ss_sync ;
   wire      ic_10bit_mst_sync ;
   wire      tx_empty_sync;
   wire      tx_empty_int;
   wire      ic_rstrt_en_sync;
   wire      ic_slave_en_sync;
   wire      p_det_ifaddr_sync;
   wire      ic_ack_general_call_sync;

   wire [`IC_SDA_HOLD_RS-1:0] ic_sda_hold_sync;

   wire [`IC_SDA_TX_HOLD_RS-1:0]         ic_sda_tx_hold_sync;
   wire [`IC_SDA_RX_HOLD_RS-1:0]      ic_sda_rx_hold_sync;



   // ----------------------------------------------------------
   // -- Synchronization registers for input from pclk domain
   // ----------------------------------------------------------

   wire [`IC_ENABLE_RS_INT-1:0] p2icl_ic_enable; 
   wire      sp2icl_ic_enable_sync;
   wire      sp2icl_ic_abort_sync;
   assign p2icl_ic_enable = ic_enable;
   assign ic_enable_sync = sp2icl_ic_enable_sync;
   assign ic_abort_sync = sp2icl_ic_abort_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_enable0_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_enable[0])
        ,.data_d              (sp2icl_ic_enable_sync)
      );

      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_enable1_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_enable[1])
        ,.data_d              (sp2icl_ic_abort_sync)
      );


   wire      p2icl_ic_ack_general_call;
   wire      sp2icl_ic_ack_general_call_sync;
   assign p2icl_ic_ack_general_call = ic_ack_general_call;
   assign ic_ack_general_call_sync = sp2icl_ic_ack_general_call_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_ack_general_call_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_ack_general_call)
        ,.data_d              (sp2icl_ic_ack_general_call_sync)
      );

      wire   ic_master_inv;
      wire   ic_master_sync_inv;
      assign ic_master_inv  = ~ic_master;
      assign ic_master_sync = ~ic_master_sync_inv;

      wire   p2icl_ic_master_inv;
      wire   sp2icl_ic_master_sync_inv;
      assign p2icl_ic_master_inv = ic_master_inv;
      assign ic_master_sync_inv = sp2icl_ic_master_sync_inv;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_master_inv_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_master_inv)
        ,.data_d              (sp2icl_ic_master_sync_inv)
      );



   wire   ic_hs_inv;
   wire   ic_hs_sync_inv;
   assign ic_hs_inv  = ~ic_hs;
   assign ic_hs_sync = ~ic_hs_sync_inv;

   wire   p2icl_ic_hs_inv;
   wire   sp2icl_ic_hs_sync_inv;
   assign p2icl_ic_hs_inv = ic_hs_inv;
   assign ic_hs_sync_inv = sp2icl_ic_hs_sync_inv;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_hs_inv_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_hs_inv)
        ,.data_d              (sp2icl_ic_hs_sync_inv)
      );


   wire      p2icl_ic_fs;
   wire      sp2icl_ic_fs_sync;
   assign p2icl_ic_fs = ic_fs;
   assign ic_fs_sync = sp2icl_ic_fs_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_fs_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_fs)
        ,.data_d              (sp2icl_ic_fs_sync)
      );


   wire      p2icl_ic_ss;
   wire      sp2icl_ic_ss_sync;
   assign p2icl_ic_ss = ic_ss;
   assign ic_ss_sync = sp2icl_ic_ss_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_ss_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_ss)
        ,.data_d              (sp2icl_ic_ss_sync)
      );

         wire   ic_10bit_mst_inv;
         wire   ic_10bit_mst_sync_inv;
         assign ic_10bit_mst_inv  = ~ic_10bit_mst;
         assign ic_10bit_mst_sync = ~ic_10bit_mst_sync_inv;

         wire   p2icl_ic_10bit_mst_inv;
         wire   sp2icl_ic_10bit_mst_sync_inv;
         assign p2icl_ic_10bit_mst_inv = ic_10bit_mst_inv;
         assign ic_10bit_mst_sync_inv = sp2icl_ic_10bit_mst_sync_inv;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_10bit_mst_inv_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_10bit_mst_inv)
        ,.data_d              (sp2icl_ic_10bit_mst_sync_inv)
      );


         wire   tx_empty_inv;
         wire   tx_empty_int_inv;
         assign tx_empty_inv  = ~tx_empty;
         assign tx_empty_int  = ~tx_empty_int_inv;

         wire   p2icl_tx_empty_inv;
         wire   sp2icl_tx_empty_int_inv;
         assign p2icl_tx_empty_inv = tx_empty_inv;
         assign tx_empty_int_inv = sp2icl_tx_empty_int_inv;

      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_tx_empty_inv_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_tx_empty_inv)
        ,.data_d              (sp2icl_tx_empty_int_inv)
      );

         wire   ic_10bit_slv_inv;
         wire   ic_10bit_slv_sync_inv;
         assign ic_10bit_slv_inv  = ~ic_10bit_slv;
         assign ic_10bit_slv_sync = ~ic_10bit_slv_sync_inv;

         wire   p2icl_ic_10bit_slv_inv;
         wire   sp2icl_ic_10bit_slv_sync_inv;
         assign p2icl_ic_10bit_slv_inv = ic_10bit_slv_inv;
         assign ic_10bit_slv_sync_inv = sp2icl_ic_10bit_slv_sync_inv;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_10bit_slv_inv_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_10bit_slv_inv)
        ,.data_d              (sp2icl_ic_10bit_slv_sync_inv)
      );



         wire   ic_rstrt_en_inv;
         wire   ic_rstrt_en_sync_inv;
         assign ic_rstrt_en_inv  = ~ic_rstrt_en;
         assign ic_rstrt_en_sync = ~ic_rstrt_en_sync_inv;

         wire   p2icl_ic_rstrt_en_inv;
         wire   sp2icl_ic_rstrt_en_sync_inv;
         assign p2icl_ic_rstrt_en_inv = ic_rstrt_en_inv;
         assign ic_rstrt_en_sync_inv = sp2icl_ic_rstrt_en_sync_inv;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_rstrt_en_inv_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_rstrt_en_inv)
        ,.data_d              (sp2icl_ic_rstrt_en_sync_inv)
      );





         wire   p2icl_ic_slave_en;
         wire   sp2icl_ic_slave_en_sync;
         assign p2icl_ic_slave_en = ic_slave_en;
         assign ic_slave_en_sync = sp2icl_ic_slave_en_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_slave_en_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_slave_en)
        ,.data_d              (sp2icl_ic_slave_en_sync)
      );


         wire   p2icl_p_det_ifaddr;
         wire   sp2icl_p_det_ifaddr_sync;
         assign p2icl_p_det_ifaddr = p_det_ifaddr;
         assign p_det_ifaddr_sync = sp2icl_p_det_ifaddr_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_p_det_ifaddr_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_p_det_ifaddr)
        ,.data_d              (sp2icl_p_det_ifaddr_sync)
      );















  
   wire [`IC_SDA_HOLD_RS-1:0]         p2icl_ic_sda_hold;
   wire [`IC_SDA_HOLD_RS-1:0]         sp2icl_ic_sda_hold_sync;
   assign p2icl_ic_sda_hold = ic_sda_hold;
   assign ic_sda_hold_sync = sp2icl_ic_sda_hold_sync;
      kei_DW_apb_i2c_bcm21
       #(
        .WIDTH       (`IC_SDA_HOLD_RS), 
        .F_SYNC_TYPE (`IC_SYNC_DEPTH),
        .VERIF_EN    (`IC_VERIF_EN)
      ) 
      U_DW_apb_i2c_bcm21_p2icl_ic_sda_hold_icsyzr
      (
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (p2icl_ic_sda_hold)
        ,.data_d              (sp2icl_ic_sda_hold_sync)
      );

  
   assign {ic_sda_rx_hold_sync, ic_sda_tx_hold_sync} = ic_sda_hold_sync;
   assign tx_empty_sync = tx_empty_int;

   // ----------------------------------------------------------
   // -- Edge detection circuitry for input from pclk domain
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : EDGE_DET_PROC
      if(ic_rst_n == 1'b0) begin
         tx_empty_sync_r    <= 1'b1;
      end else begin
         tx_empty_sync_r    <= tx_empty_int;
      end
   end
   assign tx_empty_sync_hl =  ~tx_empty_int & tx_empty_sync_r;

//   assign ic_sda_hold_sync = (`IC_CLK_TYPE == `IDENT) ? ic_sda_hold : ic_sda_hold_sync1;













endmodule // DW_apb_i2c_sync

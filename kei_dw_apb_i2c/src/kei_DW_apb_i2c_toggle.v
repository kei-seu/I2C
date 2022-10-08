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
// File Version     :        $Revision: #13 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_toggle.v#13 $ 
//
//
// File    : DW_apb_i2c_toggle.v
//
//
// Author  : Hani Saleh
// Created : Nov, 2002
// Abstract: This module generates toggle flags for the signals
//           travelling from the ic_clk to the pclk domain
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------

module kei_DW_apb_i2c_toggle
  (
   //inputs
   ic_rst_n,
                           ic_clk,
                           ic_rd_req,   
                           mst_tx_abrt,  
                           slv_tx_abrt,  
                           slv_rx_done,  
                           mst_activity,
                           slv_activity,
                           p_det,
                           s_det,
                           rx_gen_call,
                           tx_pop,
                           rx_push,
                           set_tx_empty_en,
                           //tx_abrt source indicators
                           abrt_master_dis,//Access master while disabled
                           abrt_sbyte_norstrt,//Send SBYTE while restart is disabled
                           abrt_hs_norstrt,//Hisgh Speed mode while restart disabled
                           abrt_hs_ackdet,//High Speed Master code was acknowledged
                           abrt_sbyte_ackdet,//Start Byte was acknowleged
                           abrt_gcall_read,//Try to read while sending a Gcall
                           abrt_gcall_noack,//No slave acknowledged the G.CALL
                           abrt_7b_addr_noack,//7bit 1address was not acknowledged
                           abrt_txdata_noack,//Slave did not acknowledge sent data
                           abrt_10addr1_noack,//10 bit 1address was not acknowledged
                           abrt_10b_rd_norstrt,//10 bit read command while restart is disabled
                           abrt_10addr2_noack,//10 bit 2address was not acknowledged
                           abrt_user_abrt,
                           arb_lost,
                           //slv tx_abrt source indicator
                           abrt_slvflush_txfifo,//slave flush tx fifo to request tx data
                           abrt_slv_arblost,//Slave lost the bus while it is tx data
                           abrt_slvrd_intx,//Slave request data to tx and processor wrote 
                           // a read command into the tx_fifo (9th bit is 1)
                           slv_clr_leftover,
                           //debug inputs
                           tx_current_src_en,
                           rx_current_src_en,
                           start_en,
                           re_start_en,
                           stop_en,
                           mst_debug_data,
                           mst_debug_addr,
                           slv_debug_addr,
                           slv_debug_data,
                           mst_rx_en,
                           mst_tx_en,
                           ic_enable_sync,
                           ic_hs_sync,
                           hs_mcode_en,
                           rx_addr_10bit,
                           slv_debug_cstate,
                           mst_debug_cstate,
                           ic_dis_window,
                           //outputs
                           debug_s_gen,
                           debug_p_gen,
                           debug_data,
                           debug_addr,
                           debug_rd,
                           debug_wr,
                           debug_hs,
                           debug_master_act,
                           debug_slave_act,  
                           debug_addr_10bit,
                           debug_slv_cstate,
                           debug_mst_cstate,
                           ic_current_src_en,
                           ic_disable,
                           tx_abrt_flg,   
                           rx_done_flg,   
                           ic_rd_req_flg, 
                           p_det_flg, 
                           s_det_flg, 
                           rx_gen_call_flg,
                           tx_pop_flg,    
                           rx_push_flg,  
                           slv_clr_leftover_flg,
                           set_tx_empty_en_flg,
                           tx_abrt_source//tx_abrt sources combined signals
                           
                           );

   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input ic_clk;    // module clock: runs i2c module
   input ic_rst_n;  // I2C module asynchronous reset input active low
   

   input mst_tx_abrt;//logic 1: Master aborted tx 
   input slv_tx_abrt;//logic 1: SLave aborted tx 
   input slv_rx_done;//logic 1: SLave aborted rx 
   input mst_activity;
   input slv_activity; 

   input ic_rd_req;//logic 1: I2C slave is requesting data to tx
   input s_det;//logic 1: start detected
   input p_det;//logic 1: stop detected
   input rx_gen_call;//logic 1: slv received a general call
   input set_tx_empty_en;
   
   input tx_pop;         // tx fifo pop
   input rx_push;        // rx fifo push
   
   input tx_current_src_en;//mst HS tx current source enable
   input rx_current_src_en;//mst HS rx current source enable
   input start_en;//start generation enable
   input re_start_en;//re start generation enable
   input stop_en;//stop generation enable
   input mst_debug_data;//master in data phase
   input mst_debug_addr;//master in addr phase
   input slv_debug_data;//master in data phase
   input slv_debug_addr;//master in addr phase
   input mst_rx_en;//master receiver enable 
   input mst_tx_en;//master transmit enable
   input ic_enable_sync;//IC is enabled
   input ic_hs_sync;//IC in HS mode
   input hs_mcode_en;//HS master code send enable
   input rx_addr_10bit;//Rx address is 10bit
   input [3:0] slv_debug_cstate;
   input [4:0] mst_debug_cstate;
   input slv_clr_leftover;
   input ic_dis_window;

   /////////////////////////////
   //tx_abrt source
   input                        abrt_master_dis;//Access master while disabled
   input                        abrt_sbyte_norstrt;//Send SBYTE while restart is disabled
   input                        abrt_hs_norstrt;//Hisgh Speed mode while restart disabled
   input                        abrt_hs_ackdet;//High Speed Master code was acknowledged
   input                        abrt_sbyte_ackdet;//Start Byte was acknowleged
   input                        abrt_gcall_read;//Try to read while sending a Gcall
   input                        abrt_gcall_noack;//No slave acknowledged the G.CALL
   input                        abrt_7b_addr_noack;//7bit 1address was not acknowledged
   input                        abrt_txdata_noack;//Slave did not acknowledge sent data
   input                        abrt_10addr1_noack;//10 bit 1address was not acknowledged
   input                        abrt_10b_rd_norstrt;//10 bit read command while restart is disabled
   input                        abrt_10addr2_noack;//10 bit 2address was not acknowledged
   input                        abrt_user_abrt;
   input                        arb_lost;//Abort lost issues a tx abort as well

   //slv tx_abrt source indicator
   input                        abrt_slvflush_txfifo;//slave flush tx fifo to request tx data
   input                        abrt_slv_arblost;//Slave lost the bus while it is tx data
   input                        abrt_slvrd_intx;//Slave request data to tx and processor wrote 
   // a read command into the tx_fifo (9th bit is 1)

   //outputs
   output debug_s_gen;//start generated
   output debug_p_gen;//stop generated
   output debug_data;//data phase
   output debug_addr;//address phase
   output debug_rd;// IC is reading from the bus
   output debug_wr;//IC is writing the bus
   output debug_hs;//HS Mode
   output debug_master_act;//MAster is active
   output debug_slave_act;//Slave is active
   output debug_addr_10bit;//address is 10 bit

   output ic_current_src_en;//Current source enable output
   output ic_disable;
   output [3:0] debug_slv_cstate;
   output [4:0] debug_mst_cstate;
   output slv_clr_leftover_flg;
   output set_tx_empty_en_flg;
   
   output tx_abrt_flg;//if pclk is async. to ic_clk this signal toggles on tx_abrt signal
   output rx_done_flg;//if pclk is async. to ic_clk this signal toggles on rx_done signal
   output ic_rd_req_flg;//if pclk is async. to ic_clk this signal toggles on ic_rd_req signal
   output p_det_flg;//if pclk is async. to ic_clk this signal toggles on p_det signal

   output s_det_flg;//if pclk is async. to ic_clk this signal toggles on s_det signal
   output rx_gen_call_flg;//if pclk is async. to ic_clk this signal toggles on rx_gen_call signal
   output tx_pop_flg;//if pclk is async. to ic_clk this signal toggles on tx_pop signal
   output rx_push_flg;//if pclk is async. to ic_clk this signal toggles on rx_push signal
   output [`IC_TX_ABRT_SOURCE_RS-1:0] tx_abrt_source;//tx_abrt sources combined signals
   
   // ----------------------------------------------------------
   // -- local registers
   // ----------------------------------------------------------
   reg debug_s_gen;//start generated
   reg debug_p_gen;//stop generated
   reg debug_data;//data phase
   reg debug_addr;//address phase
   reg debug_rd;// IC is reading from the bus
   reg debug_wr;//IC is writing the bus
   reg debug_hs;//HS Mode
   reg debug_master_act;//MAster is active
   reg debug_slave_act;//Slave is active
   reg debug_addr_10bit;//address is 10 bit
   reg ic_current_src_en;//Current source enable output
   reg [3:0] debug_slv_cstate;
   reg [4:0] debug_mst_cstate;

   reg    tx_abrt_r;
   reg    rx_gen_call_r;
// -------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------- //
   reg    tx_abrt_tog;
   reg    rx_done_tog;  
   reg    ic_rd_req_tog;   
   reg    p_det_tog;
   reg    s_det_tog;
   reg    rx_gen_call_tog;   
   reg    tx_pop_tog;      
   reg    rx_push_tog;
   reg    slv_clr_leftover_tog;
   reg    set_tx_empty_en_tog;
   //tx_abrt sources toggle signals
   reg abrt_txdata_noack_tog;
   reg abrt_7b_addr_noack_tog;
   reg abrt_hs_ackdet_tog;
   reg abrt_hs_norstrt_tog;
   reg abrt_sbyte_norstrt_tog;
   reg abrt_master_dis_tog;
   reg abrt_sbyte_ackdet_tog;
   reg abrt_gcall_read_tog;
   reg abrt_gcall_noack_tog;
   reg abrt_10addr1_noack_tog;
   reg abrt_10b_rd_norstrt_tog;
   reg abrt_10addr2_noack_tog;
   reg abrt_user_abrt_tog;
   reg arb_lost_tog;
   reg abrt_slvflush_txfifo_tog;
   reg abrt_slv_arblost_tog;
   reg abrt_slvrd_intx_tog;

// -------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------- //

   wire [`IC_TX_ABRT_SOURCE_RS-1:0] tx_abrt_source;
 
   
   // ----------------------------------------------------------
   // -- local wires
   // ----------------------------------------------------------
   wire  tx_abrt;
   wire  rx_done;

   wire    tx_abrt_flg;
   wire    rx_done_flg;  
   wire    ic_rd_req_flg;   
   wire    p_det_flg;
   wire    s_det_flg;
   wire    rx_gen_call_flg;   
   wire    tx_pop_flg;      
   wire    rx_push_flg;
   wire    slv_clr_leftover_flg;
   wire    set_tx_empty_en_flg;
  
   wire ic_disable_a; 
   reg  ic_disable; 
   reg  ic_disable_r; 
   reg  ic_disable_r2; 

   // ----------------------------------------------------------
   // -- Combining Mst/Slv interrupts
   // ----------------------------------------------------------
   assign rx_done   = slv_rx_done;
   assign tx_abrt   = mst_tx_abrt 
                      | slv_tx_abrt
    ;

   assign ic_disable_a = ((!ic_enable_sync) & ic_dis_window 
                          );

   always @(posedge ic_clk or negedge ic_rst_n) begin : IC_DISABLE_REG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           ic_disable_r  <= 1'b1;
           ic_disable_r2 <= 1'b1;
           ic_disable    <= 1'b1;
        end 
      else 
        begin
           ic_disable_r  <= ic_disable_a;           
           ic_disable_r2 <= ic_disable_r;           
           ic_disable    <= ic_disable_r2;           
        end
   end




// -------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------- //
    
   // ----------------------------------------------------------
   // -- This block generates slv_clr_leftover_tog signal, 
   // -- which toggles on the rising edge of slv_clr_leftover_flg
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : SLV_CLR_LEFTOVER_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           slv_clr_leftover_tog <= 1'b0;
        end 
      else 
        begin
           if(slv_clr_leftover == 1'b1)
             slv_clr_leftover_tog <= ~slv_clr_leftover_tog;
        end
   end
   // ----------------------------------------------------------
   // -- This block generates abrt_master_dis_tog signal, 
   // -- which toggles on the rising edge of abrt_master_dis
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_MASTER_DIS_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_master_dis_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_master_dis == 1'b1)
             abrt_master_dis_tog <= ~abrt_master_dis_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_sbyte_norstrt_tog signal, 
   // -- which toggles on the rising edge of abrt_sbyte_norstrt
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_SBYTE_NORSTRT_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_sbyte_norstrt_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_sbyte_norstrt == 1'b1)
             abrt_sbyte_norstrt_tog <= ~abrt_sbyte_norstrt_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_hs_norstrt_tog signal, 
   // -- which toggles on the rising edge of abrt_hs_norstrt
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_HS_NORSTRT_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_hs_norstrt_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_hs_norstrt == 1'b1)
             abrt_hs_norstrt_tog <= ~abrt_hs_norstrt_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_hs_ackdet_tog signal, 
   // -- which toggles on the rising edge of abrt_hs_ackdet
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_HS_ACKDET_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_hs_ackdet_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_hs_ackdet == 1'b1)
             abrt_hs_ackdet_tog <= ~abrt_hs_ackdet_tog;
        end
   end
   
   // ----------------------------------------------------------
   // -- This block generates abrt_sbyte_ackdet_tog signal, 
   // -- which toggles on the rising edge of abrt_sbyte_ackdet
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_SBYTE_ACKDET_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_sbyte_ackdet_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_sbyte_ackdet == 1'b1)// && (abrt_sbyte_ackdet_r == 1'b0))
             abrt_sbyte_ackdet_tog <= ~abrt_sbyte_ackdet_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_gcall_read_tog signal, 
   // -- which toggles on the rising edge of abrt_gcall_read
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_GCALL_READ_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_gcall_read_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_gcall_read == 1'b1)
             abrt_gcall_read_tog <= ~abrt_gcall_read_tog;
        end
   end
   
   // ----------------------------------------------------------
   // -- This block generates abrt_gcall_noack_tog signal, 
   // -- which toggles on the rising edge of abrt_gcall_noack
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_GCALL_NOACK_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_gcall_noack_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_gcall_noack == 1'b1)
             abrt_gcall_noack_tog <= ~abrt_gcall_noack_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_7b_addr_noack_tog signal, 
   // -- which toggles on the rising edge of abrt_7b_addr_noack
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_7B_ADDR_NOACK_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_7b_addr_noack_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_7b_addr_noack == 1'b1)
             abrt_7b_addr_noack_tog <= ~abrt_7b_addr_noack_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_txdata_noack_tog signal, 
   // -- which toggles on the rising edge of abrt_txdata_noack
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_TXDATA_NOACK_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_txdata_noack_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_txdata_noack == 1'b1)// && (abrt_txdata_noack_r == 1'b0))
             abrt_txdata_noack_tog <= ~abrt_txdata_noack_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_10addr1_noack_tog signal, 
   // -- which toggles on the rising edge of abrt_10addr1_noack
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_10ADDR1_NOACK_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_10addr1_noack_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_10addr1_noack == 1'b1)
             abrt_10addr1_noack_tog <= ~abrt_10addr1_noack_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_10b_rd_norstrt_tog signal, 
   // -- which toggles on the rising edge of abrt_10b_rd_norstrt
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_10B_RD_NORSTRT_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_10b_rd_norstrt_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_10b_rd_norstrt == 1'b1)
             abrt_10b_rd_norstrt_tog <= ~abrt_10b_rd_norstrt_tog;
        end
   end
   

   // ----------------------------------------------------------
   // -- This block generates abrt_10addr2_noack_tog signal, 
   // -- which toggles on the rising edge of abrt_10addr2_noack
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_10ADDR2_NOACK_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_10addr2_noack_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_10addr2_noack == 1'b1)
             abrt_10addr2_noack_tog <= ~abrt_10addr2_noack_tog;
        end
   end
   // ----------------------------------------------------------
   // -- This block generates abrt_user_abrt_tog signal, 
   // -- which toggles on the rising edge of abrt_user_abrt
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_USER_ABRT_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_user_abrt_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_user_abrt == 1'b1)
             abrt_user_abrt_tog <= ~abrt_user_abrt_tog;
        end
   end


   // ----------------------------------------------------------
   // -- This block generates arb_lost_tog signal, 
   // -- which toggles on the rising edge of arb_lost
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ARB_LOST_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           arb_lost_tog <= 1'b0;
        end 
      else 
        begin
           if(arb_lost == 1'b1)
             arb_lost_tog <= ~arb_lost_tog;
        end
   end

   // ----------------------------------------------------------
   // -- This block generates abrt_slvflush_txfifo_tog signal, 
   // -- which toggles on the rising edge of abrt_slvflush_txfifo
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_SLVFLUSH_TXFIFO_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_slvflush_txfifo_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_slvflush_txfifo == 1'b1)
             abrt_slvflush_txfifo_tog <= ~abrt_slvflush_txfifo_tog;
        end
   end
   
   // ----------------------------------------------------------
   // -- This block generates abrt_slv_arblost_tog signal, 
   // -- which toggles on the rising edge of abrt_slv_arblost
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_SLV_ARBLOST_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_slv_arblost_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_slv_arblost == 1'b1)
             abrt_slv_arblost_tog <= ~abrt_slv_arblost_tog;
        end
   end
   
   // ----------------------------------------------------------
   // -- This block generates abrt_slvrd_intx_tog signal, 
   // -- which toggles on the rising edge of abrt_slvrd_intx
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_SLVRD_INTX_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           abrt_slvrd_intx_tog <= 1'b0;
        end 
      else 
        begin
           if(abrt_slvrd_intx == 1'b1)
             abrt_slvrd_intx_tog <= ~abrt_slvrd_intx_tog;
        end
   end
   


   // ----------------------------------------------------------
   // -- This block generates tx_abrt_tog signal, 
   // -- which toggles on the rising edge of tx abrt
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : TX_ABRT_R_PROC
      if(ic_rst_n == 1'b0) 
        begin
           tx_abrt_r <= 1'b0;
        end 
      else 
        begin
           tx_abrt_r <= tx_abrt;           
        end
   end

   always @(posedge ic_clk or negedge ic_rst_n) begin : TX_ABRT_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           tx_abrt_tog <= 1'b0;
        end 
      else 
        begin
           if((tx_abrt == 1'b1) && (tx_abrt_r == 1'b0))
             tx_abrt_tog <= ~tx_abrt_tog;
        end
   end
   
   // ----------------------------------------------------------
   // -- This block generates rx_done_tog signal, 
   // -- which toggles on the rising edge of rx_done
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : RX_DONE_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           rx_done_tog <= 1'b0;
        end 
      else 
        begin
           if(rx_done == 1'b1)
             rx_done_tog <= ~rx_done_tog;
        end
   end

   // ----------------------------------------------------------
   // -- This block generates tx_pop_tog signal, 
   // -- which toggles on the rising edge of tx_pop
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : TX_POP_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           tx_pop_tog <= 1'b0;
        end 
      else 
        begin
           if(tx_pop == 1'b1)
             tx_pop_tog <= ~tx_pop_tog;
        end
   end

   // ----------------------------------------------------------
   // -- This block generates rx_push_tog signal, 
   // -- which toggles on the rising edge of rx_push
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : RX_PUSH_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           rx_push_tog <= 1'b0;
        end 
      else 
        begin
           if(rx_push == 1'b1)
             rx_push_tog <= ~rx_push_tog;
        end
   end
   // ----------------------------------------------------------
   // -- This block generates ic_rd_req_tog signal, 
   // -- which toggles on the rising edge of ic_rd_req
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : IC_RD_REQ_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           ic_rd_req_tog <= 1'b0;
        end 
      else 
        begin
           if(ic_rd_req == 1'b1)
             ic_rd_req_tog <= ~ic_rd_req_tog;
        end
   end
   // ----------------------------------------------------------
   // -- This block generates s_det_tog signal, 
   // -- which toggles on the rising edge of s_det
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : S_DET_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           s_det_tog <= 1'b0;
        end 
      else 
        begin
           if(s_det == 1'b1)
             s_det_tog <= ~s_det_tog;
        end
   end

   // ----------------------------------------------------------
   // -- This block generates p_det_tog signal, 
   // -- which toggles on the rising edge of p_det
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : P_DET_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           p_det_tog <= 1'b0;
        end 
      else 
        begin
           if(p_det == 1'b1)
             p_det_tog <= ~p_det_tog;
        end
   end

   // ----------------------------------------------------------
   // -- This block generates  set_tx_empty_en_tog signal, 
   // -- which toggles on the rising edge of set_tx_empty_en
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : TX_EMPTY_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           set_tx_empty_en_tog <= 1'b0;
        end 
      else 
        begin
           if(set_tx_empty_en == 1'b1)
             set_tx_empty_en_tog <= ~set_tx_empty_en_tog;
        end
   end

   // ----------------------------------------------------------
   // -- This block generates rx_gen_call_tog signal, 
   // -- which toggles on the rising edge of rx_gen_call
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : RX_GEN_CALL_R_PROC
      if(ic_rst_n == 1'b0) 
        begin
           rx_gen_call_r <= 1'b0;
        end 
      else 
        begin
           rx_gen_call_r <= rx_gen_call;           
        end
   end

   always @(posedge ic_clk or negedge ic_rst_n) begin : RX_GEN_CALL_TOG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           rx_gen_call_tog <= 1'b0;
        end 
      else 
        begin
           if((rx_gen_call == 1'b1) && (rx_gen_call_r == 1'b0))
             rx_gen_call_tog <= ~rx_gen_call_tog;
        end
   end



   assign    tx_abrt_flg          = tx_abrt_tog;
   assign    rx_done_flg          = rx_done_tog;
   assign    ic_rd_req_flg        = ic_rd_req_tog;   
   assign    p_det_flg            = p_det_tog;
   assign    s_det_flg            = s_det_tog;
   assign    rx_gen_call_flg      = rx_gen_call_tog;   
   assign    tx_pop_flg           = tx_pop_tog;      
   assign    rx_push_flg          = rx_push_tog;
   assign    slv_clr_leftover_flg = slv_clr_leftover_tog;
   assign    set_tx_empty_en_flg  = set_tx_empty_en_tog;
   assign    tx_abrt_source[0]    = abrt_7b_addr_noack_tog;
   assign    tx_abrt_source[1]    = abrt_10addr1_noack_tog;
   assign    tx_abrt_source[2]    = abrt_10addr2_noack_tog;
   assign    tx_abrt_source[3]    = abrt_txdata_noack_tog;
   assign    tx_abrt_source[4]    = abrt_gcall_noack_tog;
   assign    tx_abrt_source[5]    = abrt_gcall_read_tog;
   assign    tx_abrt_source[6]    = abrt_hs_ackdet_tog;
   assign    tx_abrt_source[8]    = abrt_hs_norstrt_tog;
   assign    tx_abrt_source[7]    = abrt_sbyte_ackdet_tog;
   assign    tx_abrt_source[10]   = abrt_10b_rd_norstrt_tog;
   assign    tx_abrt_source[12]   = arb_lost_tog;
   assign    tx_abrt_source[13]   = abrt_slvflush_txfifo_tog;
   assign    tx_abrt_source[14]   = abrt_slv_arblost_tog;
   assign    tx_abrt_source[15]   = abrt_slvrd_intx_tog;
   assign    tx_abrt_source[9]    = abrt_sbyte_norstrt_tog;
   assign    tx_abrt_source[11]   = abrt_master_dis_tog;
   assign    tx_abrt_source[16]   = abrt_user_abrt_tog;
// -------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------- //
  
// ----------------------------------------------------------
// -- This block passes the toggled or the original signal 
// -- based on the IC_CLK_TYPE paremeter
// ----------------------------------------------------------

   // ----------------------------------------------------------
   // -- Debug outputs generation
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : DEBUG_OUT_PROC
      if(ic_rst_n == 1'b0) 
        begin
           ic_current_src_en <= 1'b0;
           debug_s_gen <= 1'b0;
           debug_p_gen <= 1'b0;
           debug_data  <= 1'b0;
           debug_addr  <= 1'b0;
           debug_rd    <= 1'b0;
           debug_wr    <= 1'b0;
           debug_hs    <= 1'b0;
           debug_master_act <= 1'b0;
           debug_slave_act  <= 1'b0;
           debug_addr_10bit <= 1'b0;
           debug_slv_cstate <= 4'h0;
           debug_mst_cstate <= 5'h00;

        end 
      else 
        begin
           ic_current_src_en <= tx_current_src_en | rx_current_src_en;
           debug_s_gen <= start_en|re_start_en;
           debug_p_gen <= stop_en;
           debug_data  <= mst_debug_data | slv_debug_data;
           debug_addr  <= mst_debug_addr | slv_debug_addr;
           debug_rd    <= mst_rx_en;  
           debug_wr    <= mst_tx_en;
           debug_hs    <= ic_enable_sync & ic_hs_sync & mst_activity & (~hs_mcode_en);
           debug_master_act <= mst_activity;
           debug_slave_act  <= slv_activity;
           debug_addr_10bit <= rx_addr_10bit;
           debug_slv_cstate <= slv_debug_cstate;
           debug_mst_cstate <= mst_debug_cstate;

        end
   end


   
endmodule // DW_apb_i2c_toggle

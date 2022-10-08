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
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_tx_shift.v#19 $ 
//
//
// File    : DW_apb_i2c_rx_shift.v
//
//
// Author  : Hani Saleh
// Created : Sep  2002
// Abstract: The tx_shft module is responsible for transmitting
//           a byte of data to either a slave or master in either 
//           Master or Slave mode configuration.  This module will
//           also generate the acknowledge pulse after a byte of 
//           data has been received and generate the START and STOP
//           conditions when configured as a master.
//
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------


module kei_DW_apb_i2c_tx_shift
  (
   //top level
   ic_clk,
                             ic_rst_n,
                             //regfile
                             ic_hs_sync,
                             ic_sda_tx_hold_sync,
                             ic_spklen,
                             ic_master_sync,
                             //mstfsm signals
                             mst_tx_en,
                             mst_rx_en,
                             mst_tx_data_buf_in,
                             start_en,
                             re_start_en,
                             mst_txfifo_ld_en,
                             tx_fifo_data_buf,
                             stop_en,
                             mst_gen_ack_en,
                             // jduarte begin 20101008
                             // CRM 9000366029
                             // jduarte end 20101008
                             //slvfsm signals
                             slv_txfifo_ld_en,
                             slv_gen_ack_en,
                             slv_tx_en,
                             scl_hld_low_en,
                             slv_tx_ready,
                             slv_tx_cmplt,
                             //clk_gen signals
                             hs_mcode_en,
                             scl_lcnt_en,
                             scl_hcnt_en,
                             scl_s_hld_en,
                             scl_s_setup_en,
                             scl_p_setup_en,
                             scl_lcnt_cmplt,
                             scl_hcnt_cmplt,
                             scl_s_hld_cmplt,
                             scl_s_setup_cmplt,
                             scl_p_setup_cmplt,
                             // rx_filter signals
                             arb_lost,
                             mst_tx_ack_vld,
                             slv_tx_shift_en,
                             slv_tx_ack_vld,
                             scl_edg_hl,
                             scl_int,
                             mst_txdata_state,
                             master_read,
                             mst_rx_bit_count,
                             mstrx1_7_end,
                             //rx shift reg
                             mst_rx_ack_vld,
                             mst_rx_bwen,
                             slv_rx_ack_vld,
                             re_start_cmplt,
                             stop_cmplt,
                             mst_tx_cmplt,
                             byte_wait_scl,
                             //top level outputs
                             ic_clk_oe,
                             ic_data_oe,
                             tx_current_src_en,
                             //fifo cntl signals
                             tx_pop,
                             //fifo ram
                             tx_pop_data,
                             // from rx shift reg
                             mst_rx_data_scl,
                             rx_scl_lcnt_en,
                             rx_scl_hcnt_en,
                             slv_tx_data_en,
                             set_tx_empty_en
                             );

   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input ic_clk;// processor clock
   input ic_rst_n;// syn rst active high
   //mstfsm signals
   input [`IC_DATA_RS-1:0] mst_tx_data_buf_in; // data to be transmitted on sda data out   
   input                   mst_tx_en; // Enable tx shift register to transmit data
   input                   mst_rx_en; // Enable rx shift register to transmit data
   input                   start_en;   // Enable START condition
   input                   stop_en;   // Generate STOP condition
   input                   mst_txfifo_ld_en;// load tx_buffer from the tx fifo output
   input                   mst_gen_ack_en; // Enable Ack gen. ckt
   input                   re_start_en;   // Enable RE-START condition

// jduarte begin 20101008
// CRM 9000366029
// jduarte end 20101008

   //slvfsm
   input                   slv_txfifo_ld_en;// load tx_buffer from the tx fifo output
   input                   slv_gen_ack_en; // Enable Ack gen. ckt
   input                   slv_tx_en; // Enable tx shift register to transmit data

  
   //rx shift reg
   input                   mst_rx_ack_vld;//master RX ack pulse is valid
   input                   slv_rx_ack_vld;//slave RX ack pulse is valid
   input                   scl_hld_low_en;//Salve held scl signal low waiting for input from the processor
   input                   mst_rx_data_scl;//Master receiver scl clock signal
   input                   rx_scl_lcnt_en;//Enable low count period counter
   input                   rx_scl_hcnt_en;//Enable high count period counter
   input                   mst_rx_bwen;//master rx byte wait enable


   //regfile
   input                   ic_hs_sync;//ic is in high speed mode
   input [`IC_SDA_TX_HOLD_RS-1:0]   ic_sda_tx_hold_sync;//SDA transmit hold time num cycles.
   input [`IC_SPKLEN_RS-1:0] ic_spklen; // Spike length currently being supressed
   input                   ic_master_sync;//1 master, 0 slave.
   //from rx_filter
   input                   arb_lost;//arbitration lost to another master
   input                   slv_tx_shift_en;//logic 1:SDA data is valid and could be sampled
   input   scl_edg_hl;   // falling edge detect of SCL
   input   scl_int;//filtered input scl signal


   //from clk_gen
   input                   scl_lcnt_cmplt;//scl low count period has elapsed
   input                   scl_hcnt_cmplt;//scl high count period has elapsed
   input                   scl_s_hld_cmplt;//scl start hold count period has elapsed
   input                   scl_s_setup_cmplt;//scl start setup  count period has elapsed
   input                   scl_p_setup_cmplt;//scl stop setup  count period has elapsed
   //from mst_fsm
   input                   hs_mcode_en;//IC is in HS mode and TX the Master Code
//   input                   byte_no1;//1: this is the 1st byte ever of the current transfer

   //from fifo ram
   input [`IC_DATA_TX_CMD_RS-1:0] tx_pop_data;//Data popped from the TX fifo
   
   input                   mst_txdata_state;
   input                   master_read;
   input [3:0]             mst_rx_bit_count;
   input                   mstrx1_7_end;
   input                   slv_tx_data_en; // slave transmitting Tx-FIFO data
//   input [`IC_SMBUS_UDID_RS-1:0] smbus_udid_shift; // SMBUS UDID Shift Rrgister.

   //outputs
   output                  slv_tx_ack_vld;//logic 1:check for ack now
   output                  slv_tx_ready;//slave is ready to transmit
   output                  slv_tx_cmplt;//logic 1: slave has finished transmission
   output                  mst_tx_ack_vld;//logic 1:check for ack now
   //to mst_fsm
   output [`IC_DATA_TX_CMD_RS-1:0] tx_fifo_data_buf;//Buffer to hold data popped from tx fifo
   //to clk_gen
   output                       scl_lcnt_en;//enable low count period
   output                       scl_hcnt_en;//enable high count period
   output                       scl_s_hld_en;//enable start hold count period
   output                       scl_s_setup_en;//enable start setup count period
   output                       scl_p_setup_en;//enable stop setup count period   
   output                       re_start_cmplt;//logic 1:re-start condition has been generated        
   output                       stop_cmplt;//logic 1:stop condition has been generated        
   output                       mst_tx_cmplt;//logic 1:master tx bit completed        
   //to top level
   output                       ic_clk_oe;//Drives the SCL line transistor
   output                       ic_data_oe;//Drives the SDA line transistor
   output                       tx_current_src_en;//logic 1:enables pull up current source in HS mode
   //fifo cntl signals
   output                       tx_pop;//logic 1: pop data from TX fifo
   output                       byte_wait_scl;//logic 1: wait for scl to go high before a restart, tx, rx or stop

   output                       set_tx_empty_en;
   // ----------------------------------------------------------
   // -- local registers and wires
   // ----------------------------------------------------------
   //registers
   reg [`IC_DATA_TX_CMD_RS-1:0]    tx_fifo_data_buf;//Buffer to hold data popped from tx fifo   
   reg [`IC_DATA_RS-1:0]        tx_shift_buf;//TX shift register
   //to clk_gen
   reg                          data_scl_lcnt_en;
   reg                          scl_hcnt_en_int;
   reg                          st_scl_s_hld_en;
   reg                          re_scl_s_hld_en;
   reg                          scl_s_stp_int;
   reg                          scl_p_stp_int;   
   reg                          start_sda;
   wire                         start_sda_gated;
   reg                          start_sda_gate_r;
   reg                          stop_sda;
   wire                         stop_sda_gated;
   reg                          stop_scl;
   reg                          re_start_sda, re_start_sda_r;
   wire                         re_start_sda_gated, re_start_sda_r_gated;
   reg                          re_start_scl;
   reg                          ic_data_oe;
   reg                          ic_clk_oe;
//   wire ic_clk_oe;
   
   reg                          tx_current_src_en;
   reg                          stop_scl_lcnt_en;
   reg                          tx_data_capture;
   reg [3:0]                    tx_bit_count;
   reg                          data_sda;
   reg                          data_sda_prev_r; // Data SDA of previous SCL.
   wire                         data_sda_gated; // Data SDA gated to change when SCL in=0.
   wire                         ack_sda_gated; // ACK SDA gated to change when SCL in=0.
   reg                          mst_tx_ack_int;//logic 1: This is the ack clock cycle
   reg [3:0]                    slv_tx_bit_count;
   reg                          slv_data_sda;
   wire                         slv_data_sda_gated;
   reg                          slv_tx_ack_vld;
   reg                          slv_tx_ready;//slave is ready to transmit
   reg                          slv_tx_ready_dly1;//slave is ready to transmit, delay1
   reg                          slv_tx_ready_dly2;//slave is ready to transmit, delay2
   reg                          slv_tx_cmplt;//logic 1: slave has finished transmission
   reg                          data_scl;
   reg                          re_start_scl_lcnt_en;
   reg                          ic_data_oe_early;
   reg                          byte_wait_scl;
   reg                          scl_hld_low_en_r;
// jduarte begin 20101008
// CRM 9000366029
// jduarte end 20101008
   reg                          tx_pop;
   reg                          mst_tx_bwen;//master tx byte wait enable
   // jduarte 20101004 begin
   // CRM 9000423043
   reg                          mst_slv_ack_ext;
   reg                          mst_slv_ack_ext_r;
   reg                          sda_hold_done; // Asserted when sda hold time finished.
   // jduarte 20101004 end
// jduarte 20101108 begin
// CRM 9000424562
   reg                          scl_int_r;
// jduarte 20101108 end
   
// start 9000557489
reg set_tx_empty_en;
// end 9000557489

   
   //wires   
   wire                          ack_sda;
   wire                         scl_shld_en_int;//enable start hold count period
   wire                         scl_lcnt_en_int;//enable low count period
   wire                         sda_out_n;
   wire                         scl_out_n;
   wire                         load_sda_scl;
   wire                         load_sda_scl_int;
   wire                         ack_load;
   wire                         stop_cmplt_int;
   wire                         bit1_7_lo;
   wire                         bit1_7_hi;
   wire                         bit1_7_end;
   wire                         bit1_7_end_int;
   wire                         bit8_lo;
   wire                         bit8_hi;
   wire                         bit8_end;
   wire                         bit8_end_int;
   wire                         start_tx;
   wire                         slv_bit1_7;
   wire                         slv_inc_cnt;
   wire                         hs_no_mcode;
   wire                         tx_no_capture;
   wire                         mst_slv_ack;
   wire                         mstslv_txfld;
   wire                         byte_wait_en_int;
   wire                         byte_wait_en;
   wire                         slv_tx_data_en;
   wire                         start_lo;
   wire                         start_hld;
   wire                         no_start_hld;
   wire                         no_st_no_hld;
   wire                         re_lo;
   wire                         re_lo_int;
   wire                         re_hi;
   wire                         re_hi_int;
   wire                         re_hld;
   wire                         re_hld_int;
   wire                         re_setup;
   wire                         re_setup_int;
   wire                         stop_lo;
   wire                         stop_lo_int;
   wire                         stop_hi;
   wire                         stop_setup;
   wire                         stop_setup_int;
// jduarte 20101108 begin
// CRM 9000424562
   wire scl_int_ed;
// jduarte 20101108 end


   

   // ------------------------------------------------------
   // -- outputs assignments
   //
   // -- This is needed to resolve a reading from output 
   // ------------------------------------------------------
   assign mst_tx_ack_vld = mst_tx_ack_int;
   assign scl_lcnt_en = scl_lcnt_en_int;
   assign scl_hcnt_en = scl_hcnt_en_int;
   assign scl_s_hld_en = scl_shld_en_int;
   assign scl_s_setup_en = scl_s_stp_int;
   assign scl_p_setup_en = scl_p_stp_int;
   assign stop_cmplt = stop_cmplt_int;
   

   // ------------------------------------------------------
   // -- ic_data_oe generation
   //
   // -- This signal is used to drive the SDA output transistor
   // ------------------------------------------------------
   // 22/2/2010, jstokes, programmable SDA hold time added.
   assign sda_out_n 
     = (  ~start_sda_gated 
        | (~data_sda_gated) 
        | (~stop_sda_gated) 
        | (~re_start_sda_gated) 
        | (~re_start_sda_r_gated)
        | (~ack_sda_gated)
        | (~slv_data_sda_gated)
       );

// jduarte begin 20101008
// CRM 9000366029
//   assign scl_out_n =  (~data_scl | ~stop_scl | ~re_start_scl|~mst_rx_data_scl 
//                        | scl_hld_low_en);
//   assign load_sda_scl_int =  (re_start_scl_lcnt_en == 1'b1) || (rx_scl_hcnt_en == 1'b1) 
//                            || (scl_s_stp_int == 1'b1)     || (stop_scl_lcnt_en == 1'b1)
//                            || (scl_p_stp_int == 1'b1);
   assign scl_out_n =  ((~data_scl) | (~stop_scl) | (~re_start_scl) 
                        | (~mst_rx_data_scl) 
                        | scl_hld_low_en
                        );
                        
   assign load_sda_scl_int =  (re_start_scl_lcnt_en == 1'b1) 
                            || (rx_scl_hcnt_en == 1'b1) 
                            || (scl_s_stp_int == 1'b1)     || (stop_scl_lcnt_en == 1'b1)
                            || (scl_p_stp_int == 1'b1
                            );
// jduarte end 20101008
   
   assign load_sda_scl = (start_en == 1'b1) 
                         || (scl_hcnt_en_int == 1'b1) || (stop_cmplt_int == 1'b1)     
                         || (ack_load == 1'b1) 
                         || ((scl_shld_en_int  == 1'b1)
                            )
                         || ((rx_scl_lcnt_en == 1'b1)
                            )
                         || (slv_tx_en == 1'b1)
                         || (scl_hld_low_en_r == 1'b1)
                         || (load_sda_scl_int == 1'b1)
                         || ((scl_lcnt_en_int == 1'b1)
                         );
    
   //delay sda by 1 clk to make sure it is not changing with scl
   // and generate scl_hld_low_en_r signal by delaying scl_hld_low_en_r
   always @(posedge ic_clk or negedge ic_rst_n) begin : DLY_1_PROC
      if(ic_rst_n == 1'b0) 
        begin      
           ic_data_oe <= 1'b0;
           scl_hld_low_en_r <= 1'b0;
        end
      else 
        begin
           ic_data_oe <= ic_data_oe_early;
           scl_hld_low_en_r <= scl_hld_low_en;

        end
   end

// jduarte begin 20101008
// CRM 9000366029

// jduarte end 20101008
   
// start 9000557489
   // Generate the strobe to set the tx_empty_en in the end of the Read/Write data phase 
   always @(posedge ic_clk or negedge ic_rst_n) begin : EN_STRB_TX_EMPTY_PROC
      if(ic_rst_n == 1'b0) begin      
        set_tx_empty_en <= 1'b0;
      end
      else begin
        // Master mode read: data phase end of all read transfers
        if (
            (mst_rx_en 
            && (mst_rx_bit_count == 7) && mstrx1_7_end) ||
            // Master mode write: data phase completion of the write data transfer
            (mst_txdata_state 
              && (!master_read) 
              && (tx_bit_count == 7) && bit1_7_end) 
            // Slave mode write: Completion of last bit transmission
           || (slv_tx_en && slv_tx_data_en && (slv_tx_bit_count == 7) && slv_inc_cnt)
          )
          set_tx_empty_en <= 1'b1;
        else
          set_tx_empty_en <= 1'b0;
      end
   end
// end 9000557489
   
   //drive scl and sda outputs
   assign mst_slv_ack = ((mst_gen_ack_en == 1'b1) ||  (slv_gen_ack_en == 1'b1));

   // jduarte 20101004 begin
   // CRM 9000423043

   always @(*) begin : MST_SLV_ACK_EXT_PROC

     mst_slv_ack_ext = 1'b0;
     
     if(  (ic_clk_oe & ic_master_sync) 
        // In slave mode use external SCL.
          | (~scl_int & (~ic_master_sync)))
       begin
         if(~sda_hold_done && (~mst_slv_ack))
    mst_slv_ack_ext = 1'b1;
       end
   end

   always @(posedge ic_clk or negedge ic_rst_n) begin : MST_SLV_ACK_EXT_R_PROC
      if(ic_rst_n == 1'b0) 
        begin
          mst_slv_ack_ext_r <= 1'b0;
        end
      else
        begin
          mst_slv_ack_ext_r <= mst_slv_ack_ext;
 end
   end

   // jduarte 20101004 end
   
   always @(posedge ic_clk or negedge ic_rst_n) begin : IC_DATA_CLK_OE_PROC
      if(ic_rst_n == 1'b0) 
        begin
           ic_data_oe_early <= 1'b0;
           ic_clk_oe <= 1'b0;
        end 
      else if(load_sda_scl == 1'b1)
        begin
           ic_data_oe_early <= (arb_lost == 1'b0) ? sda_out_n : 1'b0;
           ic_clk_oe <= (arb_lost == 1'b0) ? scl_out_n : 1'b0;
        end 
      // jduarte 20101004 begin
      // CRM 9000423043
      // else if(mst_slv_ack == 1'b1)
      else if((mst_slv_ack == 1'b1) || (mst_slv_ack_ext == 1'b1) || (mst_slv_ack_ext_r == 1'b1))
      // jduarte 20101004 end
        begin
           ic_data_oe_early <= (arb_lost == 1'b0) ? sda_out_n : 1'b0;
        end
      
      else 
        begin
           ic_data_oe_early <= (arb_lost == 1'b0) ? ic_data_oe_early : 1'b0;
           if(arb_lost == 1'b1) ic_clk_oe <= 1'b0;
        end
   end
   

   // ------------------------------------------------------
   // -- Clk gen control signals
   // ------------------------------------------------------
   assign scl_shld_en_int = st_scl_s_hld_en | re_scl_s_hld_en;
   assign scl_lcnt_en_int = data_scl_lcnt_en | stop_scl_lcnt_en |re_start_scl_lcnt_en;
   
   // ------------------------------------------------------
   // -- tx_fifo data buffer
   //
   // -- This buffer is used to store the last popped data
   // -- from the tx fifo
   // ------------------------------------------------------
   assign mstslv_txfld = ((mst_txfifo_ld_en == 1'b1) 
                          || (slv_txfifo_ld_en == 1'b1)
   );
   always @(posedge ic_clk or negedge ic_rst_n) begin : POP_TX_DATA_BUF_PROC
      if(ic_rst_n == 1'b0) begin
         tx_fifo_data_buf   <= {`IC_DATA_TX_CMD_RS{1'b0}};
      end else begin
           if(mstslv_txfld == 1'b1)
           tx_fifo_data_buf <= tx_pop_data;
      end
   end
  

   // ------------------------------------------------------
   // -- tx_pop output
   //
   //  The tx_pop output is used in the pclk
   //  domain to remove data
   //  from the tx fifo.
   // ------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : POP_TX_PROC
      if(ic_rst_n == 1'b0)
        tx_pop <= 1'b0;
      else
        tx_pop <= ((mst_txfifo_ld_en == 1'b1) 
        || (slv_txfifo_ld_en == 1'b1)
        );

      
   end

   // ------------------------------------------------------
   // -- generate byte_wait_scl  byte level wait state  signal
   //
   // -- Forces the tx_shift proces,re-start and stop to wait 
   // -- for scl to go high befor touching the bus 
   // ------------------------------------------------------
   assign byte_wait_en_int = ((re_start_en == 1'b0) 
                              && (stop_en == 1'b0) 
                              && (start_en == 1'b0));
                                
   assign byte_wait_en     = ((byte_wait_en_int == 1'b1)
                              && ((mst_tx_bwen == 1'b1) || (mst_rx_bwen == 1'b1))  
                              && (scl_int == 1'b0));

   always @(posedge ic_clk or negedge ic_rst_n) begin : HCNT_WAIT_PROC
      if(ic_rst_n == 1'b0) begin
         byte_wait_scl  <= 1'b0;
      end else 
          byte_wait_scl <= byte_wait_en;
   end
    

   always @(posedge ic_clk or negedge ic_rst_n) begin : MST_TX_BWEN_PROC
      if(ic_rst_n == 1'b0) begin
         mst_tx_bwen <= 1'b0;
      end else 
        if (bit1_7_lo == 1'b1)
          mst_tx_bwen <= 1'b0;
      
        else if(bit8_hi ==1'b1)
          mst_tx_bwen <= scl_hcnt_en_int;
   end // block: MST_TX_BWEN
   

   
   // ------------------------------------------------------
   // -- generate start condition
   //
   // -- Set SDA low and wait for tHD,STA and then set SCL low
   // ------------------------------------------------------

   assign start_lo = ((start_en == 1'b1) && (scl_s_hld_cmplt == 1'b0));
   assign start_hld = ((start_en == 1'b1) && (scl_s_hld_cmplt == 1'b1));
   assign no_start_hld = ((start_en == 1'b0)&& (st_scl_s_hld_en == 1'b1));
   assign no_st_no_hld = ((start_en == 1'b0)&& (st_scl_s_hld_en == 1'b0));

   always @(posedge ic_clk or negedge ic_rst_n) begin:GEN_START_PROC
      if(ic_rst_n == 1'b0) 
        begin
          start_sda     <= 1'b1;
          st_scl_s_hld_en  <= 1'b0;
        end else 
             begin
               if(start_lo == 1'b1)
                 begin
                    start_sda     <= 1'b0;
                    st_scl_s_hld_en  <= 1'b1;
                 end
               else if (start_hld == 1'b1)
                 begin
                    start_sda     <= 1'b0;
                    st_scl_s_hld_en  <= 1'b1;
                 end
               else if (no_start_hld == 1'b1)
                 begin
                    start_sda     <= 1'b0;
                    st_scl_s_hld_en  <= 1'b0;
                 end             
               else if (no_st_no_hld == 1'b1)
                 begin
                    start_sda     <= 1'b1;
                    st_scl_s_hld_en  <= 1'b0;
                 end             
             end
   end
   

   // ------------------------------------------------------
   // -- generate re-start condition
   //
   // -- Set SDA low and wait for tHD,STA and then set SCL low
   // ------------------------------------------------------

   assign re_start_cmplt = (scl_s_setup_cmplt == 1'b1) && (scl_s_hld_cmplt == 1'b1);
   assign re_lo_int = ((scl_s_hld_cmplt == 1'b0) && (scl_s_setup_cmplt == 1'b0)&&(mst_tx_cmplt == 1'b0));
   assign re_lo = ((re_lo_int == 1'b1)&&(re_start_en == 1'b1)&&(scl_lcnt_cmplt == 1'b0));
   assign re_hi_int = ((scl_s_hld_cmplt == 1'b0)&&(mst_tx_cmplt == 1'b0));
   assign re_hi = ((re_hi_int == 1'b1)&&(re_start_en == 1'b1)&&(scl_s_setup_cmplt == 1'b0)&&(scl_lcnt_cmplt == 1'b1)&&(scl_hcnt_cmplt == 1'b0));
   assign re_setup_int = ((re_start_en == 1'b1)&&(mst_tx_cmplt == 1'b0) &&(scl_lcnt_cmplt == 1'b1));
   assign re_setup = ((re_setup_int == 1'b1)&& (scl_s_hld_cmplt == 1'b0) && (scl_s_setup_cmplt == 1'b1));
   assign re_hld_int = ((re_start_en == 1'b1) && (scl_s_hld_cmplt == 1'b1));
   assign re_hld = ((re_hld_int == 1'b1) && (scl_s_setup_cmplt == 1'b1)&&(mst_tx_cmplt == 1'b0) &&(scl_lcnt_cmplt == 1'b1));
   
   // ===========================================================
   // Extend re_start_sda by another "ic_clk" period by using
   // a further-registered version (ie., re_start_sda_r) and then
   // using the latter in exactly the same manner as re_start_sda.
   // ===========================================================
   always @(posedge ic_clk or negedge ic_rst_n) begin : GEN_RE_START_R_PROC
     if(ic_rst_n==1'd0)
       re_start_sda_r <= 1'd1;
     else
       re_start_sda_r <= re_start_sda;
   end // always

   //spyglass disable_block STARC05-2.11.3.1
   //SMD: Ensure that the sequential and combinational parts of an FSM description 
   //     should be in separate always blocks.
   //SJ:  This implmentation is as per the design requirement. 
   //     There will not be any functional issue.
   always @(posedge ic_clk or negedge ic_rst_n) begin : GEN_RE_START_PROC
      if(ic_rst_n == 1'b0) begin
             re_start_sda     <= 1'b1;
             re_start_scl     <= 1'b1;
             re_scl_s_hld_en  <= 1'b0;
             scl_s_stp_int   <= 1'b0;
             re_start_scl_lcnt_en <= 1'b0;
      end else        
          begin
             if(re_lo == 1'b1)
               begin
                  re_start_sda <= 1'b1;
                  re_start_scl <= 1'b0;
                  re_start_scl_lcnt_en <= 1'b1;
                  scl_s_stp_int <= 1'b0;
                  re_scl_s_hld_en  <= 1'b0;
               end
             else if(re_hi == 1'b1) 
               begin
                  re_start_sda <= 1'b1;
                  re_start_scl <= 1'b1;
                  re_start_scl_lcnt_en <= 1'b1;
                  re_scl_s_hld_en  <= 1'b0;

               if(scl_s_stp_int == 1'b0) begin//Bit wait state condition
                  scl_s_stp_int <= scl_int;
               end else
                  scl_s_stp_int <= 1'b1;

               end

             else if(re_setup == 1'b1)
               begin
                  re_start_sda <= 1'b0;
                  re_start_scl <= 1'b1;
                  scl_s_stp_int <= 1'b1;
                  re_scl_s_hld_en  <= 1'b1;
                  re_start_scl_lcnt_en <= 1'b1;
               end
             else if (re_hld == 1'b1)
               begin
                  re_start_sda <= 1'b0;
                  re_start_scl <= 1'b1;
                  scl_s_stp_int <= 1'b0;
                  re_scl_s_hld_en  <= 1'b0;
                  re_start_scl_lcnt_en <= 1'b0;
               end

             else if (re_start_en == 1'b0)
                 begin
                    re_start_sda     <= 1'b1;
                    re_start_scl     <= 1'b1;
                    re_scl_s_hld_en      <= 1'b0;
                    scl_s_stp_int       <= 1'b0;
                    re_start_scl_lcnt_en <= 1'b0;
                 end
          end
   end
   //spyglass enable_block STARC05-2.11.3.1
   
   
   // ------------------------------------------------------
   // -- generate stop condition
   //
   // -- Set SDA low and wait for tHD,STA and then set SCL low
   // ------------------------------------------------------
   assign stop_cmplt_int = (scl_p_setup_cmplt == 1'b1) && (scl_lcnt_cmplt == 1'b1);
   assign stop_lo_int = ((scl_p_setup_cmplt == 1'b0) &&(mst_tx_cmplt == 1'b0));
   assign stop_lo = ((stop_lo_int == 1'b1) && (stop_en == 1'b1) && (scl_lcnt_cmplt == 1'b0));
   assign stop_hi = ((stop_en == 1'b1) && (scl_p_setup_cmplt == 1'b0) && (scl_lcnt_cmplt == 1'b1)&&(mst_tx_cmplt == 1'b0));
   assign stop_setup_int = (mst_tx_cmplt == 1'b0);
   assign stop_setup = ((stop_setup_int == 1'b1) && (stop_en == 1'b1) && (scl_p_setup_cmplt == 1'b1));
   //spyglass disable_block STARC05-2.11.3.1
   //SMD: Ensure that the sequential and combinational parts of an FSM description 
   //     should be in separate always blocks.
   //SJ:  This implmentation is as per the design requirement. 
   //     There will not be any functional issue.
   always @(posedge ic_clk or negedge ic_rst_n) begin : GEN_STOP_PROC
      if(ic_rst_n == 1'b0) begin
             stop_sda     <= 1'b1;
             stop_scl     <= 1'b1;
             scl_p_stp_int  <= 1'b0;
             stop_scl_lcnt_en <= 1'b0;
      end else        
          begin
             if (stop_lo == 1'b1)
               begin
                  stop_scl_lcnt_en <= 1'b1;
                  stop_sda <= 1'b0;
                  stop_scl <= 1'b0;
                  scl_p_stp_int  <= 1'b0;
               end
             else if (stop_hi == 1'b1)
               begin
                  stop_scl_lcnt_en <= 1'b1;
                  stop_sda <= 1'b0;
                  stop_scl <= 1'b1;

                 if(scl_p_stp_int == 1'b0) begin//Bit wait state condition
                    scl_p_stp_int <= scl_int;
                 end else
                    scl_p_stp_int <= 1'b1;
               end
             else if (stop_setup == 1'b1)
               begin
                  stop_scl_lcnt_en <= 1'b1;
                  stop_sda <= 1'b1;
                  stop_scl <= 1'b1;
                  scl_p_stp_int  <= 1'b1;
               end
             else if (stop_en == 1'b0)
               begin
                 stop_sda     <= 1'b1;
                 stop_scl     <= 1'b1;
                 scl_p_stp_int  <= 1'b0;
                 stop_scl_lcnt_en <= 1'b0;
               end
            end
      end
   //spyglass enable_block STARC05-2.11.3.1


   // ------------------------------------------------------
   // -- generate ack signal
   //
   // -- Set SDA low and wait for tHD,STA and then set SCL low
   // ------------------------------------------------------

    assign ack_load = (((mst_gen_ack_en == 1'b1) && (mst_rx_ack_vld == 1'b1))
                        || ((slv_rx_ack_vld == 1'b1) && (slv_gen_ack_en == 1'b1)));
   assign ack_sda = ~ack_load;
   
   // ------------------------------------------------------
   // -- tx shift register data load
   //
   // -- The size of a data transfer is always 8 
   // -- bits.  
   // ------------------------------------------------------
   assign tx_no_capture = ((mst_tx_en == 1'b1) && (tx_data_capture == 1'b1));
   
   always @(posedge ic_clk or negedge ic_rst_n) begin : TX_SHIFT_BUF_PROC
      if(ic_rst_n == 1'b0) begin
         tx_shift_buf <= {`IC_DATA_RS{1'b0}};
         tx_data_capture <= 1'b0;
         
      end else begin
         tx_data_capture <= mst_tx_en;
         if(tx_no_capture == 1'b1)
           tx_shift_buf <= mst_tx_data_buf_in;
      end
   end


   // ------------------------------------------------------
   // -- master tx shift process
   //
   // -- The size of a data transfer is always 8 
   // -- bits.  
   // ------------------------------------------------------

   assign mst_tx_cmplt = (scl_lcnt_cmplt == 1'b1) && (scl_hcnt_cmplt ==1'b1) 
                             && (mst_tx_ack_int == 1'b1)
                          ;
   
   assign start_tx = ((mst_tx_en == 1'b1)  && (tx_data_capture == 1'b1));
   assign bit1_7_lo = ((tx_bit_count < 8) && (scl_lcnt_cmplt == 1'b0) && (scl_hcnt_cmplt == 1'b0));
   assign bit1_7_hi = ((tx_bit_count < 8) && (scl_lcnt_cmplt == 1'b1) && (scl_hcnt_cmplt == 1'b0));
   assign bit1_7_end_int = ((scl_lcnt_cmplt == 1'b1) && (data_scl_lcnt_en == 1'b1) && (scl_hcnt_en_int == 1'b1));
   assign bit1_7_end = ((bit1_7_end_int == 1'b1) && (tx_bit_count < 8) && (scl_hcnt_cmplt == 1'b1));
   assign bit8_lo = ((tx_bit_count == 8) && (scl_lcnt_cmplt == 1'b0) && (scl_hcnt_cmplt == 1'b0));
   assign bit8_hi = ((tx_bit_count == 8) && (scl_lcnt_cmplt == 1'b1) && (scl_hcnt_cmplt == 1'b0));
   assign bit8_end_int = ((scl_lcnt_cmplt == 1'b1) && (data_scl_lcnt_en == 1'b1) && (scl_hcnt_en_int == 1'b1));
   assign bit8_end = ((bit8_end_int == 1'b1) &&( tx_bit_count == 8)  && (scl_hcnt_cmplt == 1'b1));

   assign hs_no_mcode = ((ic_hs_sync == 1'b1) && (hs_mcode_en == 1'b0));


   /* ------------------------------------------------------------------
    * IMPLEMENT SDA TRANSMIT HOLD TIME
    *
    * - As a Master
    *   When the internally generated SCL goes high (pulling external 
    *   SCL low), count up to programmed hold time before allowing SDA
    *   to change.
    *
    * - As a Slave.
    *   When the externally generated SCL goes high (pulling external 
    *   SCL low), count up to programmed hold time before allowing SDA
    *   to change.
    * 
    *   Different SDA signals (data_sda , start_sda) are treated 
    *   seperately because the scenario where the previous value is
    *   captured is different for each.
    *
    */

   // jduarte 20101004 begin
   // CRM 9000423043
   // Had to move declaration of sda_hold_done higher because it is
   // now used in other preceding processes
   // reg sda_hold_done; // Asserted when sda hold time finished.
   // jduarte 20101004 end

   reg [`IC_SDA_TX_HOLD_RS-1:0] sda_hold_count_r; // Sda hold time counter.
   wire [`IC_SDA_TX_HOLD_RS-1:0] ic_sda_hold_local;
   wire [`IC_SDA_TX_HOLD_RS-1:0] ic_sda_tx_hold_sync_int;

   // 1-bit longer than ic_spklen, to cover max values.
   wire [`IC_SPKLEN_RS:0] spklen_plus_ltncy;

   //spyglass disable_block SelfDeterminedExpr-ML
   //SMD: Self determined expression present in the design.
   //SJ:  This Self Determined Expression is as per the design requirement. 
   //     There will not be any functional issue.
   // 2 cycles for meta flops on input signals
   // 2 cycles from sda_out_n to ic_data_oe
   assign spklen_plus_ltncy = 
           (9'h4+{1'h0,ic_spklen});

   assign ic_sda_tx_hold_sync_int = ic_sda_tx_hold_sync;
   //spyglass enable_block SelfDeterminedExpr-ML

   //spyglass disable_block W484
   //SMD: Possible loss of carry or borrow in addition or subtraction (Verilog)
   //SJ:  This implmentation is as per the design requirement. There is no chance 
   //     of carry/borrow overflow. There will not be any functional issue.
   // Alter the actual count time to take account of internal latencies.
   //spyglass disable_block SelfDeterminedExpr-ML
   //SMD: Self determined expression present in the design.
   //SJ:  This Self Determined Expression is as per the design requirement. 
   //     There will not be any functional issue.
   assign ic_sda_hold_local
     = ic_master_sync
       ? (ic_sda_tx_hold_sync >= 16'h3)
         // Subtract 2 to take account of the 2 registers after
         // sda_out_n before ic_data_oe.
         ? (ic_sda_tx_hold_sync - 16'h2)
         : ic_sda_tx_hold_sync
         // Only subtract when the result will not be negative/wrapped around.
       : (ic_sda_tx_hold_sync >= ({{(`IC_SDA_TX_HOLD_RS-`IC_SPKLEN_RS-1){1'b0}},spklen_plus_ltncy}
                                  +{{(`IC_SDA_TX_HOLD_RS-1){1'b0}},1'b1}
                                  ))
         // * jstokes, 30.3.11, STAR 9000368180
         //   Configurable spike supression added. Programmed spike
         //   suppression length is subtraced from SDA hold time count
         //   when operating as a slave, because SCL will not arrive here
         //   until after the spike suppression filtering.
         //
         // Reduce the implemented hold time by the latency already
         // present in sampling SCL (meta stability + spike suppression)
         // and returning SDA from this point ic_data_oe.
         ? (ic_sda_tx_hold_sync - {{(`IC_SDA_TX_HOLD_RS-`IC_SPKLEN_RS-1){1'b0}},spklen_plus_ltncy})
         : ic_sda_tx_hold_sync_int;
   //spyglass enable_block SelfDeterminedExpr-ML
   //spyglass enable_block W484



   always @(posedge ic_clk or negedge ic_rst_n) 
   begin : sda_hold_count_r_PROC
     if(~ic_rst_n) begin
       sda_hold_count_r <= {`IC_SDA_TX_HOLD_RS{1'b0}};
     end else begin
       if(  (ic_clk_oe & ic_master_sync) 
            // In slave mode use external SCL.
          | (~scl_int & (~ic_master_sync))
         ) begin
         // Don't wrap around to 0, want to hold sda_hold_done
         // until ic_clk_oe == 0.
         if(sda_hold_count_r < ic_sda_hold_local) begin
           sda_hold_count_r <= sda_hold_count_r + 1;
         end
       end else begin
         sda_hold_count_r <= {`IC_SDA_TX_HOLD_RS{1'b0}};
       end
     end
   end // sda_hold_count_r_PROC
    
  
   always @(*) begin : sda_hold_done_PROC
     sda_hold_done = 1'b0;

     case(ic_sda_tx_hold_sync) 
       // Implementing a hold time of 1 (min. possible in master mode)
       // requires no work at all.
       {{(`IC_SDA_TX_HOLD_RS-1){1'b0}},1'b1} : begin
         sda_hold_done = 1'b1;
       end
       // Implementing a hold time of 2 requires waiting until ic_clk_oe
       // is 1.
       {{(`IC_SDA_TX_HOLD_RS-2){1'b0}},2'b10} : begin
         sda_hold_done = ic_master_sync ? ic_clk_oe : ~scl_int;
       end
       // All other hold times require counter value.
       default : begin
         sda_hold_done = (sda_hold_count_r >= ic_sda_hold_local);
       end
     endcase 

   end // sda_hold_done_PROC

   always @(posedge ic_clk or negedge ic_rst_n) 
   begin : data_sda_prev_r_PROC
     if(ic_rst_n == 1'b0) begin
       data_sda_prev_r <= 1'b1;
     end else begin
       if(sda_hold_done) begin
         data_sda_prev_r <= data_sda 
               & slv_data_sda & ack_sda
               ;
       end
     end 
   end // data_sda_prev_r_PROC

   // Select the previous SDA until internal SCL has gone low.
   assign data_sda_gated = sda_hold_done ? data_sda : data_sda_prev_r;
   assign slv_data_sda_gated = sda_hold_done ? slv_data_sda : data_sda_prev_r;

   // Send previous data bit until SCL is low, when SCL goes high
   // data_sda_prev_r will have captured the value of the ACK while SCL was
   // low. When previous data was not being sent from here, data_sda_prev_r
   // will be 1, and it will be up to the sending device to 
   // implement SDA hold time.
   assign ack_sda_gated = sda_hold_done
                          ? ack_sda 
                          : data_sda_prev_r;

   // Gate start_sda as soon as is is low while scl_int == 1.                          
   always @(posedge ic_clk or negedge ic_rst_n) 
   begin : start_sda_gate_r_PROC
     if(ic_rst_n == 1'b0) begin
       start_sda_gate_r <= 1'b0;
     end else begin
       if(~start_sda_gate_r) begin
         start_sda_gate_r <= ~ic_clk_oe & (~start_sda | (~re_start_sda) | (~re_start_sda_r));
       end else begin
         start_sda_gate_r <= ~sda_hold_done;
       end
     end
   end // start_sda_gate_r_PROC


   // Stop gating (holding at 1'b0) start_sda in the same cycle that
   // scl_int goes low. Also for restart signals.
   assign start_sda_gated = (start_sda_gate_r & (~sda_hold_done)) ? 1'b0 : start_sda;
   assign re_start_sda_gated = (start_sda_gate_r & (~sda_hold_done)) ? 1'b0 : re_start_sda;
   assign re_start_sda_r_gated = (start_sda_gate_r & (~sda_hold_done)) ? 1'b0 : re_start_sda_r;


   // Gate stop_sda by default. Stop gating when stop_sda=0 and the
   // sda hold count is complete. Once stop_sda goes to 1, allow
   // stop_sda_gated to transition to 1 also.
   reg stop_sda_gate_r;
   always @(posedge ic_clk or negedge ic_rst_n) 
   begin : stop_sda_gate_r_PROC
     if(ic_rst_n == 1'b0) begin
       stop_sda_gate_r <= 1'b1;
     end else begin
       if(stop_sda_gate_r) begin
         //stop_sda_gate_r <= scl_int | stop_sda;
         stop_sda_gate_r <= ~sda_hold_done | stop_sda;
       end else begin
         stop_sda_gate_r <= stop_sda;
       end
     end
   end // stop_sda_gate_r_PROC

   // During the gating period, hold at 1. Gating period stops immediately
   // when scl_int goes low.
   assign stop_sda_gated = (stop_sda_gate_r & (~sda_hold_done)) ? 1'b1 : stop_sda;


   //spyglass disable_block SelfDeterminedExpr-ML
   //SMD: Self determined expression present in the design.
   //SJ:  This Self Determined Expression is as per the design requirement. 
   //     There will not be any functional issue.
   //spyglass disable_block STARC05-2.11.3.1
   //SMD: Ensure that the sequential and combinational parts of an FSM description 
   //     should be in separate always blocks.
   //SJ:  This implmentation is as per the design requirement. 
   //     There will not be any functional issue.
   always @(posedge ic_clk or negedge ic_rst_n) begin : MST_TX_SHIFT_PROC
      if(ic_rst_n == 1'b0) begin
         tx_bit_count <= 4'b0000;
         mst_tx_ack_int <= 1'b0;
// jduarte 20101108 begin
// CRM 9000424562
//         tx_current_src_en <= 1'b0;
// jduarte 20101108 end         
         data_sda <= 1'b1;
         data_scl <= 1'b1;
         data_scl_lcnt_en <= 1'b0;
         scl_hcnt_en_int <= 1'b0;
      end else if(start_tx == 1'b1) 
        begin
           
           if (bit1_7_lo == 1'b1)
             begin
// jduarte 20101108 begin
// CRM 9000424562
//                if ((ic_hs_sync == 1'b1) && (hs_mcode_en == 1'b0) && (tx_bit_count !=4'b0000)) 
//                      tx_current_src_en <= 1'b1;
// jduarte 20101108 end
                data_sda <= tx_shift_buf[`IC_DATA_RS - 1 - tx_bit_count];
                data_scl <= 1'b0;
                if(ack_load == 1'b0)
                      begin
                         data_scl_lcnt_en <= 1'b1;
                      end
                
                scl_hcnt_en_int <= 1'b0;
              end
           
           else if(bit1_7_hi == 1'b1)
             begin
                data_scl <= 1'b1;
                data_scl_lcnt_en <= 1'b1;
                if(scl_hcnt_en_int == 1'b0) //Bit wait state condition
                  scl_hcnt_en_int <= scl_int;
                else
                  scl_hcnt_en_int <= 1'b1;
             end
           else if(bit1_7_end == 1'b1)
           begin
              tx_bit_count <= tx_bit_count + {3'h0,1'b1};
              data_scl_lcnt_en <= 1'b0;
              scl_hcnt_en_int <= 1'b0;
           end
         
           else if(bit8_lo ==1'b1)
             begin
                mst_tx_ack_int <= 1'b1;
              
                data_sda <= 1'b1;//Keep SDA float for ack pulse
                data_scl <= 1'b0;
                data_scl_lcnt_en <= 1'b1;
                scl_hcnt_en_int <= 1'b0;
             end
           
           else if(bit8_hi ==1'b1)
             begin
                mst_tx_ack_int <= 1'b1;
              
                data_sda <= 1'b1;//Keep SDA float for ack pulse
                data_scl <= 1'b1;
                data_scl_lcnt_en <= 1'b1;

                if(scl_hcnt_en_int == 1'b0)//Bit wait state condition
                     scl_hcnt_en_int <= scl_int;
                else
                  scl_hcnt_en_int <= 1'b1;

             end
           
           else if(bit8_end ==1'b1)
           begin
              tx_bit_count <= 4'b0000;
              mst_tx_ack_int <= 1'b1;
              data_sda <= 1'b1;
              data_scl <= 1'b1;
              data_scl_lcnt_en <= 1'b0;
              scl_hcnt_en_int <= 1'b0;
           end
           
        end // if ((mst_tx_en == 1'b1)  && (tx_data_capture == 1'b1))
      else if(mst_tx_en == 1'b0)
        begin
           tx_bit_count <= 4'b0000;
           mst_tx_ack_int <= 1'b0;
// jduarte 20101108 begin
// CRM 9000424562
//           tx_current_src_en <= 1'b0;
// jduarte 20101108 end
           data_sda <= 1'b1;
           data_scl <= 1'b1;
           data_scl_lcnt_en <= 1'b0;
           scl_hcnt_en_int <= 1'b0;
        end
      
   end // block: TX_SHIFT_PROC
   //spyglass enable_block STARC05-2.11.3.1
   //spyglass enable_block SelfDeterminedExpr-ML


// jduarte 20101108 begin
// CRM 9000424562
   always @(posedge ic_clk or negedge ic_rst_n) begin : IC_CLOCK_IN_R_PROC  
       if(ic_rst_n == 1'b0) begin
           scl_int_r <= 1'b1;
       end else begin
           scl_int_r <= scl_int;
       end
   end
      
   assign scl_int_ed = scl_int && (~scl_int_r);
   
   always @(posedge ic_clk or negedge ic_rst_n) begin : TX_CURRENT_SRC_EN_PROC
       if(ic_rst_n == 1'b0) begin
            tx_current_src_en <= 1'b0;
       end else begin
            if(((tx_bit_count == 0) && bit1_7_lo) || (~hs_no_mcode)) begin
                tx_current_src_en <= 1'b0;
            end else if((tx_bit_count == 0) && scl_int_ed) begin
                tx_current_src_en <= 1'b1;
            end
       end
   end
// jduarte 20101108 end
   
   // ------------------------------------------------------
   // -- slave tx shift process
   //
   // -- The size of a data transfer is always 8 
   // -- bits.  
   // ------------------------------------------------------
   assign slv_bit1_7 = ((slv_tx_bit_count > 4'b0000) && (slv_tx_bit_count < 4'b1000) );
   assign slv_inc_cnt = ((slv_tx_bit_count < 8) && (slv_tx_shift_en == 1'b1));
   

   always @(posedge ic_clk or negedge ic_rst_n) begin : SLV_TX_SHIFT_PROC
      if(ic_rst_n == 1'b0) begin
         slv_tx_bit_count <= 4'b0000;
         slv_data_sda <= 1'b1;
         slv_tx_ack_vld <= 1'b0;
         slv_tx_ready <= 1'b0;
         slv_tx_ready_dly1 <= 1'b0;
         slv_tx_ready_dly2 <= 1'b0;
         slv_tx_cmplt <= 1'b0;
      end else if (slv_tx_en == 1'b1)
        begin
           slv_tx_ready <= slv_tx_ready_dly2;
           slv_tx_ready_dly2 <= slv_tx_ready_dly1;

   /*
           if(slv_bit1_7 == 1'b1)
`ifndef IC_ULTRA_FAST_MODE_EN
`ifndef IC_CLK_FREQ_OPTIMIZATION_EN
             slv_data_sda <= tx_fifo_data_buf[`IC_DATA_RS - 1 - slv_tx_bit_count];
`endif
`endif

           slv_tx_ready <= slv_tx_ready_dly2;
           slv_tx_ready_dly2 <= slv_tx_ready_dly1;
    */
           
           if(slv_tx_ready_dly1 == 1'b0)
             begin
                slv_data_sda <= tx_fifo_data_buf[`IC_DATA_RS - 1];
                slv_tx_ready_dly1 <= 1'b1;
             end
           else if (slv_tx_ready == 1'b0)
             slv_tx_ready_dly1 <= 1'b1;
           
           else if (slv_inc_cnt == 1'b1)
             begin
                slv_tx_bit_count <= slv_tx_bit_count + {3'h0,1'b1};
             end
           
           else if(slv_tx_bit_count == 8)
             begin
                slv_data_sda <= 1'b1;//Keep SDA float for ack pulse
                slv_tx_ack_vld <= 1'b1;
                slv_tx_cmplt <= scl_edg_hl;
             end
           
    //spyglass disable_block SelfDeterminedExpr-ML
    //SMD: Self determined expression present in the design.
    //SJ:  This Self Determined Expression is as per the design requirement. 
    //     There will not be any functional issue.
    // FM_1_7, signal assigned more than once in a single
    // flow.
    else if(slv_bit1_7 == 1'b1)
      begin
               slv_data_sda <= tx_fifo_data_buf[`IC_DATA_RS - 1 - slv_tx_bit_count];
      end
    //spyglass enable_block SelfDeterminedExpr-ML

        end // if (slv_tx_en == 1'b1)
      
      else if(slv_tx_en == 1'b0)
        begin
           slv_tx_bit_count <= 4'b0000;
           slv_data_sda <= 1'b1;
           slv_tx_ack_vld <= 1'b0;
           slv_tx_ready <= 1'b0;
           slv_tx_ready_dly1 <= 1'b0;
           slv_tx_ready_dly2 <= 1'b0;
           slv_tx_cmplt <= 1'b0;
           end
      
   end // block: SLV_TX_SHIFT_PROC
   


endmodule // DW_apb_i2c_tx_shift


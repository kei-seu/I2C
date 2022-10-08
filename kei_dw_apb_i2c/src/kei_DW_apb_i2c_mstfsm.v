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
// File Version     :        $Revision: #28 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_mstfsm.v#28 $ 
//
//
// File    : DW_apb_i2c_mstfsm.v
//
//
// Author  : Hani Saleh
// Created : Sep, 2002
// Abstract: I2C Master Control will be active when the I2C module is
//           configured for master mode of operation as defined by the
//           mode control bit.  This module will control: 
//           master-receiver or master-transmit functions in either
//           the 7-bit or 10-bit mode as defined by the ic_con 
///
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------

// -----------------------------------------------------------
// -- Macros
// -----------------------------------------------------------


module kei_DW_apb_i2c_mstfsm
  (
   ic_rst_n,
                           ic_clk,
                           //Signals from pclk domain
                           ic_enable_sync,
                           ic_abort_sync,
                           ic_master_sync,
                           ic_10bit_mst_sync,
                           ic_hs_sync,
                           tx_empty_sync,
                           tx_empty_sync_hl,
                           ic_rstrt_en_sync,
                           //signals to the int_cntl
                           mst_tx_abrt,
                           //rx filter signals
                           ic_bus_idle,
                           arb_lost,
                           ack_det,
                           //Tx shift reg signals
                           mst_tx_en,
                           mst_rx_en,
                           mst_tx_data_buf_in,
                           start_en,
                           re_start_en,
                           split_start_en,
                           mst_txfifo_ld_en,
                           tx_fifo_data_buf,
                           stop_en,
                           mst_gen_ack_en,
                           start_cmplt,   
                           re_start_cmplt,   
                           stop_cmplt,
                           mst_tx_cmplt,
                           byte_wait_scl,
                           ic_dis_window,
                           //clk_gen signals
                           hs_mcode_en,
                           min_hld_cmplt,
                           scl_lcnt_cmplt,
                           //Rx shift reg signals
                           mst_rxbyte_rdy,
                           mst_rxbyte_rdy_done,
                           mst_push_rxfifo_en,
                           mst_rx_cmplt,
                           // jduarte begin 20101108
                           // CRM 9000366029
                           rx_shift_data_done,
                           // jduarte end 20101108
                           //signals from the reg file
                           ic_hs_maddr,
                           ic_tar,
                           //slvfsm signals
                           ic_rd_req,
                           //misc signals
                           mst_activity,
                           // jduarte begin 20101008
                           // CRM 9000366029
                           // jduarte end 20101008
                           abrt_in_rcve_trns, 
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
                           mst_addr_state,
                           mst_txdata_state,
                           master_read,
                           //top level debug signals
                           mst_debug_addr,
                           mst_debug_data,
                           mst_debug_cstate
                           );

   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input ic_clk;    // module clock: runs i2c module
   input ic_rst_n;  // asynchronous reset input active low
   
   input ic_enable_sync; // logic 1: enable i2c module
   input ic_abort_sync; // logic 1: abort i2c module
   input ic_master_sync; //logic 1: IC module is a Master; logic 0: slave
   input ic_10bit_mst_sync; // logic 1: IC 10-bit address transfer mode
                       // logic 0: IC 7-bit address transfer mode
   input ic_hs_sync;  //logic 1: IC is in High Speed mode (3.4 Mb/s)
   input ic_bus_idle; //logic 1: IC bus is idle
   input tx_empty_sync; // tx fifo empty
   input tx_empty_sync_hl;//logic 1:high to low edge detection of tx_empty_sync
   input ic_rstrt_en_sync;//logic 1:Master can generate re-starts in general
   
   input arb_lost;   // logic 1: master lost arbitration
   input ack_det;    // logic 1: acknowledge detected
   input mst_rxbyte_rdy; //Indicates that a byte has been received
   input mst_rxbyte_rdy_done; //Indicates that a byte has been received in the hold_rx_byte state
   input [`IC_HS_MADDR_RS-1:0] ic_hs_maddr;//the master address code register value
   input [`IC_TAR_RS_INT-1:0]  ic_tar;//the target slave address register
   input [`IC_DATA_TX_CMD_RS-1:0] tx_fifo_data_buf;//Buffer to hold data popped from tx fifo
   input                       start_cmplt;//logic 1:start condition has been generated               
   input                       re_start_cmplt;//logic 1: restart condition has been generated                
   input                       stop_cmplt;//logic 1:stop condition has been generated         
   input                       mst_tx_cmplt;//logic 1:master bit transmission is finished             
   input                       mst_rx_cmplt;//logic 1:master bit receiption is finished   
// jduarte begin 20101108
// CRM 9000366029
   input                       rx_shift_data_done;
// jduarte end 20101108
   input                       byte_wait_scl;//logic 1: wait for scl to go high before a restart, tx, rx or stop
   input ic_rd_req;//logic 1:Slave is waiting on data from the processor to tx
   input min_hld_cmplt;//Scl hasbeen pulled low and the
                       // Minimum hold time to genearte 
                       // start conditionhas elapsed
   input                         scl_lcnt_cmplt;//logic 1:master completed low period count   
   //Outputs
   output                        ic_dis_window; // The Master FSM state under which ic_disable can be de-asserted
   output [`IC_DATA_RS-1:0]    mst_tx_data_buf_in; // data to be transmitted on sda data out
   output                        start_en;   // Enable START condition
   output                        re_start_en;   // Enable RE-START condition 
   output                        split_start_en; // Enable Split start condition
   output                        mst_tx_en; // Enable tx shift register to transmit data
   output                        mst_rx_en; // Enable rx shift register to transmit data
   output                        mst_gen_ack_en; // Enable Ack gen. ckt
   output                        mst_tx_abrt;   // logic 1: master aborted TX transfer
   output                        mst_txfifo_ld_en;// load tx_buffer from the tx fifo output
   output                        stop_en;   // Generate STOP condition
   output                        hs_mcode_en;//logic 1:master is in hs and transmitting the hs_mcode   
   output                        mst_push_rxfifo_en;//logic 1:push received data to the RX fifo
   output                        mst_activity;//logic 1: master is busy
   output                        mst_debug_addr;//logic 1:indicates master is transmitting the adress   
   output                        mst_debug_data;//logic 1:indicates master is transmitting the adress
   
// jduarte begin 20101008
// CRM 9000366029
// jduarte end 20101008
   output                        abrt_in_rcve_trns;


   /////////////////////////////
   //tx_abrt source
   output                        abrt_master_dis;//Access master while disabled
   output                        abrt_sbyte_norstrt;//Send SBYTE while restart is disabled
   output                        abrt_hs_norstrt;//Hisgh Speed mode while restart disabled
   output                        abrt_hs_ackdet;//High Speed Master code was acknowledged
   output                        abrt_sbyte_ackdet;//Start Byte was acknowleged
   output                        abrt_gcall_read;//Try to read while sending a Gcall
   output                        abrt_gcall_noack;//No slave acknowledged the G.CALL
   output                        abrt_7b_addr_noack;//7bit 1address was not acknowledged
   output                        abrt_txdata_noack;//Slave did not acknowledge sent data
   output                        abrt_10addr1_noack;//10 bit 1address was not acknowledged
   output                        abrt_10b_rd_norstrt;//10 bit read command while restart is disabled
   output                        abrt_10addr2_noack;//10 bit 2address was not acknowledged
   output                        abrt_user_abrt;
   //arb_lost ---> //Abort lost issue a tx abort as well

   output                        mst_addr_state;
   output                        mst_txdata_state;
   output                        master_read;
   output [4:0] mst_debug_cstate;

   // ----------------------------------------------------------
   // -- local registers
   // ----------------------------------------------------------
   reg [4:0] mst_current_state;
   reg [4:0] mst_next_state;

   //non registers (wires) have to be defined as regs to be used in always block
   reg [`IC_DATA_RS-1:0] mst_tx_data_buf_in;
   reg       start_en_int;//gen start condition
   reg       re_start_en_int;//gen re-start condition
   reg       mst_tx_en;//enable tx shifter
   reg       split_start_en_int; // split start
   reg       mst_rx_en;//enable rx shifter
   reg       mst_gen_ack_en_r, mst_gen_ack_en_s;//enable gen ACK in rx mode
   wire      mst_gen_ack_en;
   reg       mst_tx_abrt;//Master Tx aborted int.
   reg       master_read;//logic 1: master is reading from the bus, 0: writing
// jduarte begin 20101108
// CRM 9000366029
// jduarte begin 20101108
   reg       mst_txfifo_ld_en; //Load fifo data into TX buffer
   reg       stop_en; //Generate stop condition
   reg       delay_stop_en;
   reg       abrt_in_rcve_trns; // abort occured during receive transfer
   reg       addr_1byte_sent;//1st address byte has been sent
   reg       addr_2byte_sent;//2nd address byte has been sent
   reg       old_is_read; // Indicates if the previous transaction 
   // in a byte stream is read (1) or no transaction (0)
   // in a byte stream is write (1) or No Transaction (0)
   reg       byte_waiting_q;//Indicates there is another byte to be processed for the RX_BYTE state
   reg       mst_activity;//indicates that we can stop without performing
   //illegal action on I2C bus
   reg       hs_mcode_en;//logic 1:master is in hs and transmitting the hs_mcode
   reg       abrt_hscode_en;//logic 1: HS-code Aborted due to Ack detection
   reg       mst_push_rxfifo_en;//logic 1:push received data to the RX fifo
   reg       byte_waiting;//Indicates there is another byte to be processed for the RX_BYTE state
   reg       mst_tx_flush;//logic 1: Master has flushed the tx fifo buffer
   reg       abrt_in_idle;//logic 1: Master has generated user abort in idle state
   reg       tx_empty_hld;//Hold the value of tx_empty_sync_hl
//   reg       byte_no1;//1: this is the 1st byte ever of the current transfer
   
// jduarte begin 20101008
// CRM 9000366029
// jduarte end 20101008
   
   //tx_abrt source
   reg       abrt_master_dis;//Access master while disabled
   reg       abrt_sbyte_norstrt;//Send SBYTE while restart is disabled
   reg       abrt_hs_norstrt;//Hisgh Speed mode while restart disabled
   reg       abrt_hs_ackdet;//High Speed Master code was acknowledged
   reg       abrt_sbyte_ackdet;//Start Byte was acknowleged
   reg       abrt_gcall_read;//Try to read while sending a Gcall
   reg       abrt_gcall_noack;//No slave acknowledged the G.CALL
   reg       abrt_7b_addr_noack;//7bit 1address was not acknowledged
   reg       abrt_txdata_noack;//Slave did not acknowledge sent data
   reg       abrt_10addr1_noack;//10 bit 1address was not acknowledged
   reg       abrt_10b_rd_norstrt;//10 bit read command while restart is disabled
   reg       abrt_10addr2_noack;//10 bit 2address was not acknowledged
   reg       abrt_user_abrt;//User aborted
   //arb_lost ---> //Abort lost issue a tx abort as well
   reg       ic_abort_sync_d;
   reg       ic_abort_chk_win;
   reg       ic_enable_sync_chk_win;

   
   // ----------------------------------------------------------
   // -- local wires
   // ----------------------------------------------------------
   wire       start_en;//gen start condition
   wire       re_start_en;//gen re-start condition
   wire       split_start_en;
   wire       mst_addr_state;
   wire       mst_txdata_state;
   wire       ic_dis_window;


   // ----------------------------------------------------------
   // -- state variables (gray coded)
   // ----------------------------------------------------------
   parameter IDLE            = 5'b00000;//0
   parameter GEN_START       = 5'b00001;//1
   parameter TX_HS_MCODE     = 5'b00011;//3
   parameter POP_TX_DATA     = 5'b00010;//2
   parameter CHECK_IC_TAR    = 5'b00110;//6
   parameter RX_BYTE         = 5'b00111;//7
   parameter GEN_STOP        = 5'b00101;//5
   parameter TX7_1ST_ADDR    = 5'b00100;//4
   parameter TX10_1ST_ADDR   = 5'b01100;//c
   parameter TX10_2ND_ADDR   = 5'b01101;//d
   parameter GEN_RSTRT_SBYTE = 5'b01110;//e
   parameter TX_BYTE         = 5'b01011;//b
   parameter GEN_RSTRT_10BIT = 5'b1010;//a
   parameter GEN_RSTRT_7BIT  = 5'b01001;//9
   parameter GEN_RSTRT_HS    = 5'b01000;//8
   parameter GEN_SPLIT_STOP  = 5'b01111;//f
   parameter GEN_SPLIT_START = 5'b10101;//15
// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108

   assign ic_dis_window = (mst_next_state == IDLE); 

   assign mst_addr_state = ic_10bit_mst_sync ? ((mst_current_state == TX10_1ST_ADDR) & addr_2byte_sent): addr_1byte_sent;
   assign mst_txdata_state = (mst_current_state == TX_BYTE);



   // ----------------------------------------------------------
   // -- Assigning outputs
   // ----------------------------------------------------------
   assign    start_en = start_en_int;
   assign    re_start_en = re_start_en_int;
   assign    split_start_en = split_start_en_int;
   
   // ----------------------------------------------------------
   // -- state assignment
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : FSM_SEQ_PROC
      if(ic_rst_n == 1'b0) begin
         mst_current_state <= IDLE;
      end else begin
         if (             
             (ic_master_sync  == 1'b0)
             || (arb_lost == 1'b1)
             )  begin
            mst_current_state <= IDLE;
         end else begin
                 mst_current_state <= mst_next_state;
         end
      end
   end

   //spyglass disable_block STARC05-2.11.3.1
   //SMD: Ensure that the sequential and combinational parts of an FSM description 
   //     should be in separate always blocks.
   //SJ:  This implmentation is as per the design requirement. 
   //     There will not be any functional issue.
   // ----------------------------------------------------------
   // -- FSM Flags
   // ----------------------------------------------------------
   //start enable control flag   
   always @(posedge ic_clk or negedge ic_rst_n) begin : START_EN_INT_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           start_en_int <= 1'b0;
        end
      else
        begin
           if (
               (mst_current_state == TX_HS_MCODE) || 
                  (mst_current_state == CHECK_IC_TAR)
               || (mst_current_state == TX7_1ST_ADDR) 
               || (mst_current_state == TX10_1ST_ADDR)
               || (mst_current_state == IDLE)
               || ((mst_next_state == GEN_SPLIT_START) 
                   && (min_hld_cmplt == 1'b1)
                   && (start_cmplt == 1'b1))
               )
             begin
                start_en_int <= 1'b0;
             end

           else if (mst_next_state == GEN_START)
             begin
                start_en_int <= 1'b1;
             end
           
           else if (mst_next_state == GEN_SPLIT_START)
             begin
                start_en_int <= (start_en_int == 1'b0) ? ic_bus_idle:1'b1;
             end


        end // else: !if(ic_rst_n == 1'b0)
   end // block: START_EN_INT_FLAG_PROC
   //spyglass enable_block STARC05-2.11.3.1
   
   
   //restart enable control flag
   always @(posedge ic_clk or negedge ic_rst_n) begin : RE_START_EN_INT_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           re_start_en_int <= 1'b0;
        end
      else
        begin
           if ((mst_next_state == GEN_RSTRT_7BIT) || (mst_next_state == GEN_RSTRT_10BIT)
               || (mst_next_state == GEN_RSTRT_HS) 
               || (mst_next_state == GEN_RSTRT_SBYTE) 
               )
             begin
                re_start_en_int <= ~byte_wait_scl;
             end
           else if ((mst_current_state == TX_BYTE) 
               || (mst_current_state == RX_BYTE) 
                     || (mst_current_state == CHECK_IC_TAR) ||(mst_current_state == TX7_1ST_ADDR) 
                     || (mst_current_state == TX10_1ST_ADDR)||(mst_current_state == IDLE)
                     || (mst_current_state == TX_HS_MCODE)
                     )
             begin
                re_start_en_int <= 1'b0;
             end
        end // else: !if(ic_rst_n == 1'b0)

   end // block: RE_START_EN_INT_FLAG_PROC

   always @(posedge ic_clk or negedge ic_rst_n) begin : SPLIT_START_EN_INT_PROC
     if(ic_rst_n==1'b0) begin
       split_start_en_int <= 1'd0;
     end else begin
       if(mst_next_state == GEN_SPLIT_START)
         split_start_en_int <= 1'd1;
       else
         split_start_en_int <= 1'd0;
     end
   end
   
   //previous transaction direction   
   always @(posedge ic_clk or negedge ic_rst_n) begin : OLD_IS_READ_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           old_is_read <= 1'b0;
        end
      else
        begin
           if (mst_current_state == IDLE)             
             begin
                old_is_read <= 1'b0;
             end
             
           else if (mst_current_state == TX_BYTE) 
             begin
                old_is_read <= 1'b0;
             end
           else  if (mst_current_state == RX_BYTE)
             begin
                old_is_read <= 1'b1;
             end
        end // else: !if(ic_rst_n == 1'b0)
   end // block: OLD_IS_READ_FLAG_PROC
   
   //1st address byte sent flag   
   always @(posedge ic_clk or negedge ic_rst_n) begin : ADDR1_SENT_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           addr_1byte_sent <=1'b0;
        end
      else
        begin
           if ((mst_current_state == IDLE)
               ||(mst_current_state == GEN_SPLIT_START)
               )
             begin
                addr_1byte_sent <= 1'b0;
             end
           
           else if ((mst_current_state == TX7_1ST_ADDR) 
               || (mst_current_state == TX10_1ST_ADDR))
             begin
                addr_1byte_sent <= 1'b1;
             end
        end // else: !if(ic_rst_n == 1'b0)
   end // block: ADDR1_SENT_FLAG_PROC
   
   
   //2nd address byte sent flag
   always @(posedge ic_clk or negedge ic_rst_n) begin : ADDR2_SENT_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           addr_2byte_sent <=1'b0;
        end
      else
        begin
           if ((mst_current_state == IDLE)
               ||(mst_current_state == GEN_SPLIT_START)
               )
             begin
                addr_2byte_sent <= 1'b0;
             end
           else if (mst_current_state == TX10_2ND_ADDR)
             begin
                addr_2byte_sent <= 1'b1;
             end
           
        end // else: !if(ic_rst_n == 1'b0)
   end // block: ADDR2_SENT_FLAG_PROC
   //RX_BYTE state byte is waiting flag
   always @(posedge ic_clk or negedge ic_rst_n) begin : BYTE_WAITING_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           byte_waiting_q <= 1'b0;
        end
      else
        begin
// jduarte begin 20101008
// CRM 9000366029
//           if (((mst_next_state == RX_BYTE) && (byte_waiting == 1'b0)) 
//               || (mst_current_state == IDLE))
//             begin
//                byte_waiting_q <= 1'b0;
//             end
//           else if (mst_next_state == RX_BYTE)
//             begin
//                byte_waiting_q <= 1'b1;
//             end
           if (((mst_next_state == RX_BYTE) && (byte_waiting == 1'b0)) 
               || (mst_current_state == IDLE))
             begin
                byte_waiting_q <= 1'b0;
             end
           else if (mst_next_state == RX_BYTE)
             begin
                byte_waiting_q <= 1'b1;
             end
// jduarte end 20101008
        end // else: !if(ic_rst_n == 1'b0)
   end // block: BYTE_WAITING_FLAG_PROC
   //master activity flag
   always @(posedge ic_clk or negedge ic_rst_n) begin : MST_ACTIVITY_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
           mst_activity <= 1'b0;
        end
      else
        begin
           if (mst_current_state != IDLE) 
             begin
                mst_activity <= 1'b1;
             end
           else
             mst_activity <= 1'b0;
        end // else: !if(ic_rst_n == 1'b0)
   end // block: MST_ACTIVITY_FLAG_PROC
   
   //master flushed tx fifo buffer
   always @(posedge ic_clk or negedge ic_rst_n) begin : MST_TX_FLUSH_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
              mst_tx_flush <= 1'b0;
        end
      else
        begin
           if ((mst_current_state == GEN_START) 
               || (ic_enable_sync  == 1'b0)
               || (ic_rd_req == 1'b1)
               )
             //                  else  if (mst_current_state == GEN_START)
             begin
              mst_tx_flush <= 1'b0;
             end
           
           else if((mst_current_state != IDLE) && mst_tx_abrt)
             begin
              mst_tx_flush <= 1'b1;
             end
          else if((mst_current_state == IDLE) && (abrt_in_idle || abrt_user_abrt || abrt_master_dis || abrt_sbyte_norstrt
                     || abrt_hs_norstrt 
               ))
             begin
              mst_tx_flush <= 1'b1;
             end
        end // else: !if(ic_rst_n == 1'b0)
   end // block: MST_ACTIVITY_FLAG_PROC

  // =======================================================================
  // Generate "abrt_in_idle".
  // 1. This is necessary to ensure that the state machine should not procceed 
  // as there are commands in tx fifo until the fifo is flushed due to user abort. 
  // =======================================================================
   always @(posedge ic_clk or negedge ic_rst_n) begin : ABRT_IN_IDLE_PROC 
   if (ic_rst_n == 1'b0)
     abrt_in_idle <= 1'b0;
   else if(mst_current_state == GEN_START)
     abrt_in_idle <= 1'b0;
   else if((mst_current_state == IDLE) && abrt_user_abrt)
     abrt_in_idle <= 1'b1;
   end // block: ABRT_IN_IDLE_PROC


      //master tx_empty_hld generation
   always @(posedge ic_clk or negedge ic_rst_n) begin : TX_EMPTY_FLAG_PROC
      if(ic_rst_n == 1'b0) 
        begin
              tx_empty_hld <= 1'b0;
        end
      else
        begin

           if ((mst_current_state == GEN_START) 
               || (ic_enable_sync  == 1'b0)
               || (ic_rd_req == 1'b1)     
               )
             begin
                tx_empty_hld <= 1'b0;
             end
          else if(tx_empty_sync == 1'b1)
             begin
                tx_empty_hld <= 1'b0;
             end
          else if((mst_current_state == IDLE) && (abrt_user_abrt || abrt_master_dis || abrt_sbyte_norstrt
                     || abrt_hs_norstrt 
               ))
            begin
                tx_empty_hld <= 1'b0;
             end

           else if((tx_empty_sync_hl == 1'b1) && (mst_current_state == IDLE))
             begin
              tx_empty_hld <= 1'b1;
             end
        end // else: !if(ic_rst_n == 1'b0)
   end // block: MST_ACTIVITY_FLAG_PROC

   //spyglass disable_block W415a
   //SMD: Signal may be multiply assigned (beside initialization) in the same scope
   //SJ : Few signals are updated with the default values and then only if required
   //     the signal is updated, based on the required condition. There is no functional 
   //     issue. Hence this can be waived.
   // ----------------------------------------------------------
   // -- This combinational process calculates the next state
   // -- and generate the outputs 
   // -- (Check RMM, 2nd Edition, Page 112)
   // ----------------------------------------------------------
   always @(
            ic_master_sync
            or ic_enable_sync
            or ic_10bit_mst_sync 
            or tx_empty_sync
            or ack_det
            or mst_current_state
            or delay_stop_en
            or arb_lost
            or ic_tar
            or tx_fifo_data_buf
            or old_is_read
            or addr_1byte_sent
            or byte_waiting_q
            or ic_bus_idle
            or ic_hs_maddr
            or ic_hs_sync 
            or scl_lcnt_cmplt
            or abrt_hscode_en
            or addr_2byte_sent 
            or mst_rxbyte_rdy
            or mst_rxbyte_rdy_done
            or start_cmplt
            or re_start_cmplt
            or stop_cmplt
            or mst_tx_cmplt
            or mst_rx_cmplt
            or ic_rstrt_en_sync
            or byte_wait_scl
            or mst_tx_flush
            or tx_empty_hld
            or min_hld_cmplt
            or ic_abort_sync
            or ic_abort_sync_d
            or ic_abort_chk_win
            or ic_enable_sync_chk_win
            or mst_activity
// jduarte begin 20101008
// CRM 9000366029
// jduarte end 20101008
            ) begin: FSM_COMB_PROC

      //set default values
      mst_tx_abrt = arb_lost;
      mst_tx_en = 1'b0;
      mst_rx_en = 1'b0;
      mst_gen_ack_en_s = 1'b0;
      mst_txfifo_ld_en = 1'b0;
      stop_en = 1'b0;
      master_read = 1'b0;
// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108
      hs_mcode_en = 1'b0;             
      mst_push_rxfifo_en = 1'b0;
      mst_tx_data_buf_in = {`IC_DATA_RS{1'b1}};
      mst_next_state = IDLE;
      byte_waiting = 1'b0; 

// jduarte begin 20101008
// CRM 9000366029
// jduarte end 20101008

      abrt_master_dis = 1'b0;//Access master while disabled
      abrt_sbyte_norstrt = 1'b0;//Send SBYTE while restart is disabled
      abrt_hs_norstrt = 1'b0;//Hisgh Speed mode while restart disabled
      abrt_hs_ackdet = 1'b0;//High Speed Master code was acknowledged
      abrt_sbyte_ackdet = 1'b0;//Start Byte was acknowleged
      abrt_gcall_read = 1'b0;//Try to read while sending a Gcall
      abrt_gcall_noack = 1'b0;//No slave acknowledged the G.CALL
      abrt_7b_addr_noack = 1'b0;//7bit 1address was not acknowledged
      abrt_txdata_noack = 1'b0;//Slave did not acknowledge sent data
      abrt_10addr1_noack = 1'b0;//10 bit 1address was not acknowledged
      abrt_10b_rd_norstrt = 1'b0;//10 bit read command while restart is disabled
      abrt_10addr2_noack = 1'b0;//10 bit 2address was not acknowledged
      abrt_user_abrt = 1'b0;

      case (mst_current_state)
        IDLE :
          begin
             //Control signals initialization
             mst_tx_abrt = 1'b0;
             mst_tx_en = 1'b0;
             mst_rx_en = 1'b0;
             mst_gen_ack_en_s = 1'b0;
             mst_txfifo_ld_en = 1'b0;
             stop_en = 1'b0;
             hs_mcode_en = 1'b0;             
             mst_push_rxfifo_en = 1'b0;
             mst_tx_data_buf_in = {`IC_DATA_RS{1'b1}};
             byte_waiting = 1'b0;             

             if(ic_abort_sync == 1'b1) begin //user initiated abort
               if(ic_abort_sync_d == 1'b0 || mst_activity == 1'b1) begin 
                 mst_tx_abrt = 1'b1;//user abort
                 abrt_user_abrt = 1'b1;
               end
               mst_next_state = IDLE;//Remain in the idle state
             end
             else if (
                 (((mst_tx_flush == 1'b0)&&(tx_empty_sync   == 1'b0)) || // TX FIFO has data in it
                 ((mst_tx_flush == 1'b1)&&(tx_empty_hld == 1'b1))) &&  // TX FIFO has data in it
                 (ic_bus_idle == 1'b1) // The bus is free
                 ) 
               begin
                  //
                    if(
                      ((ic_rstrt_en_sync == 1'b0) &&//re_start is disabled and 
                         (
                          (ic_hs_sync == 1'b1) || //High speed transfer
                          (ic_tar[11:10] == 2'b11)))//send a start byte
                          || (ic_master_sync  == 1'b0)//master is disabled
                         ) 
                         begin
                           mst_tx_abrt = 1'b1;//Abrt invalid transaction while re_start is disabled

                           if(ic_master_sync  == 1'b0) abrt_master_dis  = 1'b1;
                           if(ic_tar[11:10] == 2'b11)  abrt_sbyte_norstrt = 1'b1;
                           if(ic_hs_sync == 1'b1)      abrt_hs_norstrt = 1'b1;
                           mst_next_state = IDLE;//Camp on Idle 
                         end
                       else
                        mst_next_state = GEN_START;//Generate a start condition and go ahead with the transfer
               end 
             else 
               begin
                  mst_next_state = IDLE;//Remain in the idle state
               end
          end // case: IDLE
        
        
        // =========================================================================================
        // When "start_cmplt" is asserted, this Master will have satisfied the minimum time for SDA
        // to stay LOW and move on to pulling SCL to LOW. This is t[HD,STA] requirement.
        // Meanwhile "min_hld_cmplt" waits to be asserted whenever SDA is pulled LOW, potentially
        // by *other* Masters.
        // Thus, if "start_cmplt" is HIGH and "min_hld_cmplt" is HIGH as well, then this Master have
        // already discovered that, after waiting for t[HD;STA], the I2C bus requires arbitration.
        // =========================================================================================

        GEN_START: begin //This state generates a Start Condition on the I2C bus

          if(ic_hs_sync == 1'b1)
            hs_mcode_en = 1'b1;//Use FS timing if in High Speed Mode

          if(start_cmplt == 1'b1) begin  //We still own the bus (Has a start condition been detected?)
                                         //Start detected go on

            //LK--ToBeDeleted if(min_hld_cmplt == 1'b1) //Another master is on the bus
            //LK--ToBeDeleted                           // and The minimum hold time to generate
            //LK--ToBeDeleted                           // a start has elapsed
            //LK--ToBeDeleted                           // So park on the idle state until
            //LK--ToBeDeleted                           // the bus is idle again
            //LK--ToBeDeleted   mst_next_state = IDLE;

            //LK--ToBeDeleted else if(ic_tar[11] == 1'b1)     //if ic_tar[11]=1 then  We are sending General Call or Start byte
            if((ic_tar[11] == 1'b1)      //if ic_tar[11]=1 then  We are sending General Call or Start byte
               )
              mst_next_state = CHECK_IC_TAR;//Decide if we are sending General Call or start byte

            else  if (ic_hs_sync == 1'b1) begin //Are we in High speed mode?
              mst_next_state = TX_HS_MCODE;     // We are in HS mode so send the HS Master Code
            end

            else begin                      //if (ic_tar[11] = 1'b0) we are sending normal data
              mst_txfifo_ld_en = 1'b1;      // load the FIFO data into the tx buf
                                            // (pop data from tx fifo)
              mst_next_state = POP_TX_DATA; //Complete Pop data process and process the data to be send
            end
          end // if (start_cmplt == 1'b1)

          else begin
            mst_next_state = GEN_START; // Wait for the Start condition to be detected,
                                        // so loopback to GEN_START
          end // else: !if(start_cmplt == 1'b1)
        end // case: GEN_START
        

        TX_HS_MCODE://This state transmits the HS Master Code on the I2C bus
          begin
             mst_tx_data_buf_in = {`IC_HS_CODE,ic_hs_maddr}; //Fill the data buf with the correct value
             hs_mcode_en = 1'b1;//State that we are sending the HS mode Master Code (MCODE)
             
               mst_tx_en = ~byte_wait_scl; // Enable Transmission of HS Master Code
             
             if (mst_tx_cmplt == 1'b1)
               begin
                  if(ack_det == 1'b1) begin //MCODE should not be acknowledged (something is wrong)
                     mst_tx_en = 1'b0; // Stop TX of the data
                     hs_mcode_en = 1'b0;//We finished sending the MCODE
                     mst_tx_abrt = 1'b1;//Master aborted Transmission
                     
                     abrt_hs_ackdet = 1'b1;
                     
                     mst_next_state = GEN_STOP;//Generate a stop condition and quit the bus
                     
                  end
                  else
                  begin //We still own the bus and no SLAVE 
                     // acknowledged the  MCODE (correct behavior)
                     hs_mcode_en = 1'b0;//We finished transmitting the MCODE
                     mst_tx_en = 1'b0; // Disable Transmitter
                     mst_next_state = GEN_RSTRT_HS;
                  end 
               end
             else 
               begin//We are still waiting for a start or arb lost or ack or not ack signals
                  mst_next_state = TX_HS_MCODE;
               end
             
          end // case: TX_HS_MCODE
        
        
        CHECK_IC_TAR://This State sends general call or start byte to the I2C bus 
          begin
              if(ic_tar[11:10] == 2'b10) begin //Are we sending a general call address?
                mst_tx_data_buf_in   = 8'h00;// Load Tx data buffer with a general Call "00h"

                hs_mcode_en = ic_hs_sync;//1'b1;//Use FS timing if in High Speed Mode
                   mst_tx_en = ~byte_wait_scl; // Enable transmitter to send the Gen. Call if we are not in byte waiting mode

                if (mst_tx_cmplt == 1'b1) begin
                   if (ack_det == 1'b1)  begin //We still own the bus, has a slave acknowldged the Gen Call
                      mst_tx_en = 1'b0;//We have an acknowledge so procede to next byte
                      mst_txfifo_ld_en = 1'b1; // Load the FIFO data into the tx buf
                      mst_next_state = POP_TX_DATA;
                      
                   end else
                     begin 
                        //No slave ackwnoledged the General call so abort transfer
                        mst_tx_abrt = 1'b1;//Master aborted transfer
                        abrt_gcall_noack =  1'b1;//No slave acknowledged the G.CALL
                        mst_next_state = GEN_STOP;//Generate a stop condition
                     end 
                end
                else begin
                   mst_next_state = CHECK_IC_TAR; // Wait for an ACK signal
                end
             end
             
             else //if(ic_tar[11:10] == 2'b11) //Tx Start Byte
              begin 
                 hs_mcode_en = ic_hs_sync;//Use FS timing if in High Speed Mode
                 
                 mst_tx_data_buf_in   = 8'h01; //Set the Start Byte data
                 
                   mst_tx_en = ~byte_wait_scl; //Enable the transmitter

                 if (mst_tx_cmplt == 1'b1) //Start byte should not be acknwledged (correct behavior)
                   begin
                       if (ack_det == 1'b1)
                        begin //something is wrong on the bus
                           mst_tx_abrt = 1'b1;
                         abrt_sbyte_ackdet = 1'b1;
                           
                           mst_next_state = GEN_STOP;
                        end 
                      else
                        begin
                           mst_tx_en = 1'b0;
                           mst_next_state = GEN_RSTRT_SBYTE;
                        end
                   end
                 else
                   mst_next_state = CHECK_IC_TAR;
              end // if (ic_tar[11:10] = 2'b11)
          end // case: CHECK_IC_TAR
        
        
        
        POP_TX_DATA:
          begin
             mst_txfifo_ld_en = 1'b0; //Latch the Fifo data into the TX buffer
             mst_tx_en = 1'b0;
             master_read = tx_fifo_data_buf[8]; // 0: Master is writing, 1: Master is reading
// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108
             if((mst_tx_cmplt == 1'b1)
                 || (mst_rx_cmplt == 1'b1)
               )
                    begin
                     mst_next_state = POP_TX_DATA;
                    end

             ////----> Case 1: we are in General call processing

             else if(ic_tar[11:10] == 2'b10) begin //IC is sending general call data
                /////
                if(master_read == 1'b0) //Master is writing
                  begin
                     mst_next_state = TX_BYTE;
                     mst_tx_en = 1'b1;
                  end
                else //Master is reading (not allowed)
                  begin
                     mst_tx_abrt = 1'b1;
                     abrt_gcall_read = 1'b1;
                     
                     mst_next_state = GEN_STOP;
                  end        
                /////
             end // if (ic_tar[11:10] == 2'b10)
             
        
             ////----> Case 2: we are in 7 bit address mode
             else
               begin
               if(ic_10bit_mst_sync == 1'b0) begin //IC is in 7 bit address mode
                /////
                
// jduarte begin 20101108
// CRM 9000366029
//                if ((master_read != old_is_read) && (addr_1byte_sent == 1'b1))//are we changing direction?
                if ((master_read != old_is_read) && (addr_1byte_sent == 1'b1))//are we changing direction?
// jduarte begin 20101108
                  begin //gen re-start condition to change the direction of the transaction
                     if(ic_rstrt_en_sync == 1'b1)
                       mst_next_state = GEN_RSTRT_7BIT;
                     else
                       mst_next_state = GEN_SPLIT_STOP;
                  end
                
                else 
                if(addr_1byte_sent == 1'b0) 
                  begin
                     mst_next_state = TX7_1ST_ADDR;
                  end 
                else 
                  begin
                          mst_next_state = TX_BYTE;
                          mst_tx_en = 1'b1;
                  end        
                /////
             ////----> Case 3: we are in 10 bit address mode
             end else 
               begin // IC is in 10 bit address mode
                  
// jduarte begin 20101108
// CRM 9000366029
//                  if ((master_read != old_is_read) && (addr_2byte_sent == 1'b1))//change dir of transfer
                  if ((master_read != old_is_read) && (addr_2byte_sent == 1'b1))//change dir of transfer
// jduarte begin 20101108
                    begin //gen re-start condition to change the direction of the transaction
                       if(ic_rstrt_en_sync == 1'b1)
                         mst_next_state = GEN_RSTRT_10BIT;
                       else
                         mst_next_state = GEN_SPLIT_STOP;
                    end
                  
                  else 
                   if(addr_1byte_sent == 1'b0)
                    begin
                       mst_next_state = TX10_1ST_ADDR;
                    end 
                  else
                    begin
                            mst_next_state = TX_BYTE;
                            mst_tx_en = 1'b1;
                    end   
                  
               end // else: !if(ic_10bit_mst_sync == 1'b0)
               end // else: !if(ic_tar[11:10] == 2'b10)
             
          end // case: POP_TX_DATA
        
        TX7_1ST_ADDR:
          begin
             master_read = tx_fifo_data_buf[8]; // 0: Master is writing, 1: Master is reading
// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108
                mst_tx_data_buf_in   = {ic_tar[6:0],master_read}; //Set the Start Byte data
             mst_tx_en = ~byte_wait_scl; //Enable the transmitter
             
             if (mst_tx_cmplt == 1'b1)
               begin
                  if (ack_det == 1'b1)
                    begin //slave acknowledged the address
                       mst_tx_en = 1'b0;//disable the transmitter
// jduarte begin 20101108
// CRM 9000366029
//                       if(master_read ==1'b1)
//                         begin
//                            if(tx_empty_sync == 1'b0) //We have more data in tx fifo
//                           begin
//                  mst_txfifo_ld_en = 1'b1; //Load the fifo data to the tx buffer
//                              byte_waiting = 1'b1;
//                           end
//                            else
//                              begin
//                                 byte_waiting = 1'b0;
//                              end
//                              byte_waiting = 1'b1;
//                           end
//                            else
//                              begin
//                                 byte_waiting = 1'b0;
//                              end
//                            mst_next_state = RX_BYTE;
//                         end
                       if(master_read ==1'b1)
                         begin
                           if(tx_empty_sync == 1'b0) //We have more data in tx fifo
                             begin
                               mst_txfifo_ld_en = 1'b1; //Load the fifo data to the tx buffer
                               byte_waiting = 1'b1;
                             end
                           else
                             begin
                               byte_waiting = 1'b0;
                             end
                           mst_next_state = RX_BYTE;
                         end
// jduarte end 20101108
                       else
                         mst_next_state = TX_BYTE;   
                    end
                  else
                  begin
                     mst_tx_abrt = 1'b1;
                     abrt_7b_addr_noack = 1'b1;
                     
                     mst_tx_en = 1'b0; //disable the transmitter
                     mst_next_state = GEN_STOP;
                  end 
               end
             else
               mst_next_state = TX7_1ST_ADDR; // Wait for an ACK signal

          end // case: TX_1ST_ADDR
        
        
        TX_BYTE:   
          begin

// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108

             if(ic_tar[11:10] == 2'b10) 
               begin
                  //IC is sending general call data
                  hs_mcode_en = ic_hs_sync;//1'b1;//Use FS timing if in High Speed Mode
               end
             else
               hs_mcode_en = 1'b0;
             
             
             mst_tx_data_buf_in = tx_fifo_data_buf[7:0];
             mst_tx_en = ~byte_wait_scl;
             
             if(mst_tx_cmplt == 1'b1)
               begin
                  if (ack_det == 1'b1)
                    begin //slave acknowledged the data bytes
                       mst_tx_en = 1'b0;//disable the transmitter
// jduarte begin 20101108
// CRM 9000366029
//                       if(tx_empty_sync == 1'b0) //We have more data in tx fifo
//                         begin
//                            mst_txfifo_ld_en = 1'b1; //Load the fifo data to the tx buffer
//                            mst_next_state = POP_TX_DATA;
//                         end
                       if((ic_abort_sync == 1'b1) || (ic_enable_sync == 1'b0)) begin //user initiated abort
                         mst_next_state = GEN_STOP;
                       end
                       else if(tx_empty_sync == 1'b0) //We have more data in tx fifo
                         begin
                            mst_txfifo_ld_en = 1'b1; //Load the fifo data to the tx buffer
                            mst_next_state = POP_TX_DATA;
                         end
// jduarte end 20101108
                       else //No more data to process
                         begin
                            mst_next_state = GEN_STOP;
                         end
                    end
                  else
                         begin
                            mst_tx_abrt = 1'b1;
                            abrt_txdata_noack = 1'b1;
                            
                            mst_tx_en = 1'b0;//disable the transmitter
                            mst_next_state = GEN_STOP;
                            
                         end
               end
             else // else: !if(ack_det == 1'b1)
                           
               mst_next_state = TX_BYTE; // Wait for an ACK signal
             
          end // case: TX_BYTE
        // =========================================================================
        //
        // =========================================================================
        RX_BYTE:   begin
            master_read = tx_fifo_data_buf[8]; // 0: Master is writing, 1: Master is reading
// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108
          if(byte_waiting_q ==1) begin
            mst_txfifo_ld_en = 1'b0; //Latch the fifo data to the tx buffer if it has been loaded before
            master_read = tx_fifo_data_buf[8]; // 0: Master is writing, 1: Master is reading
// jduarte begin 20101108
// CRM 9000366029
//             mst_gen_ack_en_s = master_read;//(master_read == 1'b1) ? 1'b1 : 1'b0;
//                                            //if next byte is RX then gen ack                 
            mst_gen_ack_en_s = master_read && (~(ic_abort_chk_win && ic_abort_sync)) && ((~ic_enable_sync_chk_win) || ic_enable_sync);//(master_read == 1'b1) ? 1'b1 : 1'b0;
                                               //if next byte is RX then gen ack
// jduarte end 20101108
          end else  begin
            mst_gen_ack_en_s = 1'b0;
          end

          mst_push_rxfifo_en = 1'b0;             
          mst_rx_en = ~byte_wait_scl;

          if (mst_rxbyte_rdy == 1'b1 && mst_rxbyte_rdy_done == 1'b0) begin //We recevied the data byte
            mst_rx_en = 1'b0;
            mst_gen_ack_en_s = 1'b0;
                 
// CRM 9000481699 Start
            mst_push_rxfifo_en = 1'b1;

            if(byte_waiting_q == 1'b1) begin
// jduarte begin 20101108
// CRM 9000366029
//              if(master_read == 1'b1) begin //byte waiting is read
//                if(tx_empty_sync == 1'b0) begin //We have more data in tx fifo
//                  mst_txfifo_ld_en = 1'b1; //Load the fifo data to the tx buffer
              if((ic_abort_chk_win == 1'b1 && ic_abort_sync == 1'b1) || ((ic_enable_sync_chk_win == 1'b1) && (ic_enable_sync == 1'b0))) begin
                mst_next_state = GEN_STOP;
              end
              else if(master_read == 1'b1) begin //byte waiting is read
                if(tx_empty_sync == 1'b0) begin //We have more data in tx fifo
                  mst_txfifo_ld_en = 1'b1; //Load the fifo data to the tx buffer
                  byte_waiting = 1'b1;
                end else begin
                  byte_waiting = 1'b0;
                end
                mst_gen_ack_en_s = 1'b0;
                mst_next_state = RX_BYTE;
              end else begin //Byte waiting is write (change direction)
                if(ic_rstrt_en_sync == 1'b0)
                  mst_next_state = GEN_SPLIT_STOP;
                else
                  mst_next_state = (ic_10bit_mst_sync == 1'b0) ? GEN_RSTRT_7BIT
                                                               : GEN_RSTRT_10BIT;                  
              end // else master_read
// jduarte end 20101108
            end else begin //no more data to process
              mst_rx_en = 1'b0;
              mst_next_state = GEN_STOP;
            end

          end // if (mst_rxbyte_rdy == 1'b1)
          else begin
            byte_waiting = (byte_waiting_q == 1'b1) ? 1'b1 : 1'b0;//preserve the value of the byte waiting flag
// jduarte begin 20101108
// CRM 9000366029
//mst_next_state = RX_BYTE;
              mst_next_state = RX_BYTE;
// jduarte end 20101108
          end // else mst_rxbyte_rdy
             
        end // case: RX_BYTE

// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108

        TX10_1ST_ADDR:
          begin
             master_read = tx_fifo_data_buf[8]; // 0: Master is writing, 1: Master is reading
// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108
// jduarte begin 20101108
// CRM 9000366029
//             if ((master_read != old_is_read) && (addr_2byte_sent == 1'b1))//change direction of transfer
             if ((master_read != old_is_read) && (addr_2byte_sent == 1'b1))//change direction of transfer
// jduarte end 20101108
               //Set the 1st ADDR Byte data + Read, we are switching dir.
               mst_tx_data_buf_in   = {`IC_SLV_ADDR_10BIT,ic_tar[9:8],master_read}; 
             else
               //Set the 1st ADDR Byte data + Write it is a normal addr phase
               mst_tx_data_buf_in   = {`IC_SLV_ADDR_10BIT,ic_tar[9:8],1'b0}; 

             mst_tx_en = ~byte_wait_scl; //Enable the transmitter
             if (mst_tx_cmplt == 1'b1)
               begin
                  if (ack_det == 1'b1)
                    begin //slave acknowledged the address
                       mst_tx_en = 1'b0;
// jduarte begin 20101108
// CRM 9000366029
//                       if ((master_read != old_is_read)&&(addr_2byte_sent == 1'b1)&&(master_read == 1'b1))// we are changing the transfer direction
//                         begin
//                            if(tx_empty_sync == 1'b0) //We have more data in tx fifo
//                              begin
//                                 mst_txfifo_ld_en = 1'b1; //Load the fifo data to the tx buffer
//                                 byte_waiting = 1'b1;
//                              end
//                            else
//                              byte_waiting = 1'b0;
//                            mst_next_state = RX_BYTE;
//                         end
//                       else
//                         mst_next_state = TX10_2ND_ADDR;
                       if ((master_read != old_is_read)&&(addr_2byte_sent == 1'b1)&&(master_read == 1'b1))// we are changing the transfer direction
                         begin
                            if(tx_empty_sync == 1'b0) //We have more data in tx fifo
                              begin
                                 mst_txfifo_ld_en = 1'b1; //Load the fifo data to the tx buffer
                                 byte_waiting = 1'b1;
                              end
                            else
                              byte_waiting = 1'b0;
                            mst_next_state = RX_BYTE;
                         end
                       else
                         mst_next_state = TX10_2ND_ADDR;
// jduarte end 20101108
                    end
                  
                  else //No Slave acknowledged the address
                    begin
                       mst_tx_abrt = 1'b1;
                       abrt_10addr1_noack = 1'b1;
                       mst_tx_en = 1'b0; //disable the transmitter
                       mst_next_state = GEN_STOP;
                    end
               end 
             else
               mst_next_state = TX10_1ST_ADDR; // Wait for an ACK signal
          end // case: TX10_1ST_ADDR
        
        TX10_2ND_ADDR:
          begin
             master_read = tx_fifo_data_buf[8]; // 0: Master is writing, 1: Master is reading
// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108
             mst_tx_data_buf_in   = ic_tar[7:0]; //Set the 2nd ADDR Byte data
             if((ic_rstrt_en_sync == 1'b0) && (master_read == 1'b1))//if re_start is disabled then you cant read in 10 bit mode
               begin
                  mst_tx_abrt = 1'b1;
                  abrt_10b_rd_norstrt = 1'b1;
                  
                  mst_next_state = GEN_STOP;//Master is reading from slave  
               end
             
             else
               begin
                  mst_tx_en = ~byte_wait_scl; //Enable the transmitter
                  if (mst_tx_cmplt == 1'b1)//ack detected
                    begin
                       if (ack_det == 1'b1)//ack detected
                         begin //slave acknowledged the address
                            mst_tx_en = 1'b0; //disable the transmitter
                            if(master_read == 1'b0) //Master is writing to slave
                              mst_next_state = TX_BYTE;
                            else
                              begin 
                                 mst_next_state =  GEN_RSTRT_10BIT;//Master is reading from slave
                              end
                         end
                       
                       else
                       begin
                          mst_tx_en = 1'b0;
                          mst_tx_abrt = 1'b1;
                          abrt_10addr2_noack = 1'b1;
                          mst_next_state = GEN_STOP;
                       end
                    end
                  else
                    mst_next_state = TX10_2ND_ADDR; // Wait for an ACK signal
               end
          end // case: TX10_2ND_ADDR
        
        GEN_RSTRT_HS:
          begin //gen re-start condition to change the direction of the transaction
             //if(ic_hs_sync == 1'b1)
               //hs_mcode_en = 1'b1;//Use FS timing if in High Speed Mode
            if(scl_lcnt_cmplt == 1'b1)
              hs_mcode_en = 1'b0;
            else
              hs_mcode_en = 1'b1;
             
             if (re_start_cmplt == 1'b1)
               begin //Re-Start detected go on
                       mst_txfifo_ld_en = 1'b1;// Load the FIFO data into the tx buf
                       mst_next_state = POP_TX_DATA;//Complete the POP TX FIFO process
               end
             
             else begin
                mst_next_state = GEN_RSTRT_HS;
             end
          end//case: GEN_RSTRT_HS;

        GEN_RSTRT_SBYTE:
          begin //gen re-start condition to change the direction of the transaction
             hs_mcode_en = ic_hs_sync;//Use FS timing if in High Speed Mode
             
             if (re_start_cmplt == 1'b1)
               begin //Re-Start detected go on
                  if(ic_hs_sync == 1'b1)
                    mst_next_state = TX_HS_MCODE;//Complete the POP TX FIFO process
                  else
                    begin
                       mst_txfifo_ld_en = 1'b1;// Load the FIFO data into the tx buf
                       mst_next_state = POP_TX_DATA;//Complete the POP TX FIFO process
                    end
               end
             
             else 
               begin
                  mst_next_state = GEN_RSTRT_SBYTE;
               end
          end//case: GEN_RSTRT_SBYTE;


        GEN_RSTRT_7BIT:
          begin //gen re-start condition to change the direction of the transaction
             if (re_start_cmplt == 1'b1)
               begin //Re-Start detected go on
                  mst_next_state = TX7_1ST_ADDR;
               end
             else begin
                mst_next_state = GEN_RSTRT_7BIT;
             end
          end//case: GEN_RSTRT_7BIT;

        GEN_RSTRT_10BIT:
          begin //gen re-start condition to change the direction of the transaction
             if (re_start_cmplt == 1'b1)
               begin //Re-Start detected go on
                  mst_next_state = TX10_1ST_ADDR;//TX10_1ST_ADDR_RD;
               end
             else begin
                mst_next_state = GEN_RSTRT_10BIT;
             end
          end//case: GEN_RSTRT_10BIT;

        GEN_SPLIT_STOP:   //used only in SS or FS Mode
          begin
             stop_en = ~byte_wait_scl; //Enable generating stop condition
             
             if ( stop_cmplt == 1'b1)
               begin
                  mst_next_state = GEN_SPLIT_START;
               end
             else
               mst_next_state = GEN_SPLIT_STOP;
             
          end // case: GEN_STOP

        GEN_SPLIT_START://This is only used in SS or FS Mode
          begin //gen stop-start condition to split a combined transaction when re_start is disabled
             master_read = tx_fifo_data_buf[8]; // 0: Master is writing, 1: Master is reading
// jduarte begin 20101108
// CRM 9000366029
// jduarte end 20101108
             
             if (start_cmplt == 1'b1)
               begin //Start detected, go on
                  if (min_hld_cmplt == 1'b1)//Another master is on the bus 
                                            // and The minimum hold time to generate
                                            // a start has elapsed
                                            // So park on the gen_split_start 
                                            // state until 
                                            // the bus is idle again
                    mst_next_state = GEN_SPLIT_START;

                  else
                      if(ic_10bit_mst_sync == 1'b0)
                    mst_next_state = TX7_1ST_ADDR;
                  else
                    mst_next_state = TX10_1ST_ADDR; //<HS>Might be redundent
               end // if (start_cmplt == 1'b1)
             
             else
               begin
                  mst_next_state = GEN_SPLIT_START;
               end
             
          end // case: GEN_SPLIT_START
        

        GEN_STOP:   
          begin
             hs_mcode_en = abrt_hscode_en;
             
             if(delay_stop_en)
               stop_en = 1'd0;
             else begin
             stop_en = ~byte_wait_scl; //Enable generating stop condition
             end 
               if ( stop_cmplt == 1'b1) begin
                  mst_next_state = IDLE; // We lost the bus
               end else
                 mst_next_state = GEN_STOP;
             
          end // case: GEN_STOP
        
        
        default :
          mst_next_state = IDLE;
        
        
      endcase // case(mst_current_state)
      
   end // block: FSM_COMB_PROC
   //spyglass enable_block W415a


  // =======================================================================
  // Generate "ic_abort_sync_d" and "ic_abort_chk_win".
  // 1. This is necessary to ensure that the ic_abort_sync is not sampled 
  // during ACK phase of receive transfer
  // 2. This is necessary to ensure that the abrt_user_abrt is generated 
  // only once in the IDLE state.
  // =======================================================================
  always @(posedge ic_clk or negedge ic_rst_n) begin
    if(!ic_rst_n) begin
      ic_abort_sync_d <= 1'b0;
      ic_abort_chk_win <= 1'b0;
    end else begin
      ic_abort_sync_d <= ic_abort_sync;
      if (rx_shift_data_done == 1'b1 
         )
        ic_abort_chk_win <= ic_abort_sync;
      else if (mst_tx_abrt == 1'b1)
        ic_abort_chk_win <= 1'b0;
    end
  end

  always @(posedge ic_clk or negedge ic_rst_n) begin
    if(!ic_rst_n) begin
      ic_enable_sync_chk_win <= 1'b0;
    end else begin
      if (rx_shift_data_done == 1'b1 
         )
        ic_enable_sync_chk_win <= ~ic_enable_sync;
      else if (ic_enable_sync == 1'b1)
        ic_enable_sync_chk_win <= 1'b0;
    end
  end  

  // ================================================================================
  // Generate "abrt_in_rcve_trns".
  // This is necessary to ensure the correct flush count value generated 
  // after user abort occurs during receive transfer due to pipelining of 
  // receive commands.
  // -->When IC_EMPTYFIFO_HOLD_EN=0, Receive transfers are pipelined . 
  // Next read command is loaded in to internal register tx_fifo_data_buf during
  // execution of current command. so, when abort happens the commands in fifo and
  // the command stored(byte_waiting_q) in internal register are flushed.
  // Hence Flushed commands = ic_txflr (fifo commands) + 1'b1(if abrt_in_rcve_trans=1)
  // --> When IC_EMPTYFIFO_HOLD_EN=1, Only First receive command is pipelined.
  // Next read command is loaded in to internal register tx_fifo_data_buf during 
  // execution of first read command. So, if abort happens during the execution of 
  // first read transfer, the commands in fifo and the command in internal register are 
  // flushed. remaining receive transfers from 2nd transfer, there is no pipelining.
  // Hence Flushed commands during first read transfer 
  //                   = ic_txflr (fifo commands) + 1'b1(if abrt_in_rcve_trans=1)
  // =================================================================================
  always @(posedge ic_clk or negedge ic_rst_n) begin
    if(!ic_rst_n) begin
      abrt_in_rcve_trns <= 1'b0;
    end else begin
      if(mst_current_state == GEN_START)
        abrt_in_rcve_trns <= 1'b0;
    else if(ic_abort_sync && ic_abort_chk_win && (mst_current_state == RX_BYTE) && byte_waiting_q)
       abrt_in_rcve_trns <= 1'b1;
    end
  end

  // =======================================================================
  // Generate "delay_stop_en".
  // This is necessary to ensure that the "stop_hi" signal, inside the TxShift
  // module, does NOT glitch prior to the "stop_lo" signal being asserted.
  // Subsequently, this removes the problem where "ic_data_oe" changes together
  // with "ic_clkc_oe" during Master-Tx.
  // =======================================================================
  always @(posedge ic_clk or negedge ic_rst_n) begin
    if(!ic_rst_n) begin
      delay_stop_en <= 1'd0;
    end else begin
      if(mst_current_state == TX_BYTE      ||
         mst_current_state == TX_HS_MCODE  ||
         mst_current_state == TX7_1ST_ADDR ||
         mst_current_state == TX10_2ND_ADDR ||
         mst_current_state == TX10_1ST_ADDR) 
        delay_stop_en <= 1'd1;
      else
        delay_stop_en <= 1'd0;
    end // else ic_rst_n
  end
  // =======================================================================
  // Generate "mst_gen_ack_en"
  // Forced the original behaviour of the signal to pulse for TWO clock
  // cycles, INSTEAD of the previous ONE.
  // This ensures that the second transition due to the ACK bit is made 1
  // clock cycle after "ic_clk_oe".
  // =======================================================================
  always @(posedge ic_clk or negedge ic_rst_n) begin
    if(!ic_rst_n) begin
      mst_gen_ack_en_r <= 1'd0;
    end else begin
      mst_gen_ack_en_r <= mst_gen_ack_en_s;
    end
  end // always

  assign mst_gen_ack_en = mst_gen_ack_en_r & mst_gen_ack_en_s;

  // =======================================================================
  // Generate "abrt_hscode_en"
  // When Master is programmed to Hs-mode and transfer abort is generated for
  // the following cases, the STOP is generated in FS Speed.(Error Conditions)
  // 1. START-Byte ACK Detected 
  // 2. HS-Code ACK detected
  // 3. General Call ACK detected
  // ========================================================================
  always @(posedge ic_clk or negedge ic_rst_n) begin
    if(!ic_rst_n) begin
      abrt_hscode_en <= 1'b0;
    end else begin
     if(mst_current_state == IDLE)
       abrt_hscode_en <= 1'b0;
     else if(ic_hs_sync && (abrt_sbyte_ackdet ||
                            abrt_hs_ackdet    ||
                            abrt_gcall_noack))
        abrt_hscode_en <= 1'b1;
    end
  end

   // ----------------------------------
   // : generate debug signals
   // ----------------------------------
   assign mst_debug_addr = ((mst_current_state == TX7_1ST_ADDR)
                            ||(mst_current_state == TX10_1ST_ADDR)
                            ||(mst_current_state == TX10_2ND_ADDR)
                            ||(mst_current_state == TX_HS_MCODE)
                            ||(mst_current_state == CHECK_IC_TAR));
   
   assign mst_debug_data = ((mst_current_state == TX_BYTE)
                            ||(mst_current_state == RX_BYTE)
   );

   assign mst_debug_cstate = mst_current_state;
   
endmodule // DW_apb_i2c_mstfsm

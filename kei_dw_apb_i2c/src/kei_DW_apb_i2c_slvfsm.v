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
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_slvfsm.v#14 $ 
//
//
// File    : DW_apb_i2c_slvfsm.v
//
//
// Author  : Hani Saleh
// Created : Sep, 2002
// Abstract: I2C Master Control will be active when the I2C module is
//           configured for slave mode of operation as defined by the
//           mode bit in ic_con register.  This module will control: 
//           slave-receiver or slave-transmit functions in either
//           the 7-bit or 10-bit mode as defined by the ic_con register
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------

// -----------------------------------------------------------
// -- Macros
// -----------------------------------------------------------

module kei_DW_apb_i2c_slvfsm
  (
   ic_rst_n
                           ,ic_clk
                           ,//Signals synchronized from pclk domain
                           ic_enable_sync
                           ,ic_10bit_slv_sync
                           ,tx_empty_sync
                           ,tx_empty_sync_hl
                           ,ic_slave_en_sync
                           ,ic_sda_setup
                           ,ic_ack_general_call
                           ,//signals to the toggle ckt
                           slv_tx_abrt
                           ,slv_rx_done
                           ,ic_rd_req
                           ,//rx filter signals
                           arb_lost
                           ,s_det
                           ,p_det
                           ,slv_ack_det
                           ,slv_rx_ack_vld
                           ,//Tx shift reg signals
                           slv_tx_en
                           ,slv_rx_en
                           ,slv_txfifo_ld_en
                           ,tx_fifo_dbuf_8
                           ,slv_gen_ack_en
                           ,scl_hld_low_en
                           ,slv_tx_cmplt
                           ,ic_data_oe
                           ,//Rx shift reg signals
                           slv_rxbyte_rdy
                           ,rx_gen_call
                           ,rx_addr_match
                           ,rx_slv_read
                           ,slv_rx_1byte_en
                           ,slv_rx_2byte_en
                           ,slv_push_rxfifo_en
                           ,slv_rx_2addr
                           //slv tx_abrt source indicator
                           ,abrt_slvflush_txfifo//slave flush tx fifo to request tx data
                           ,abrt_slv_arblost//Slave lost the bus while it is tx data
                           ,abrt_slvrd_intx//Slave request data to tx and processor wrote 
                           ,// a read command into the tx_fifo (9th bit is 1)
                           //misc.
                           slv_debug_addr
                           ,slv_debug_data
                           ,slv_activity
                           ,slv_clr_leftover
                           ,slv_debug_cstate                           
                           ,slv_rx_aborted
                           ,slv_fifo_filled_and_flushed
                           ,slv_addressed
                           ,slv_tx_data_en
                           );

   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input ic_clk;    // module clock: runs i2c module
   input ic_rst_n;  // asynchronous reset input active low
      
   input ic_enable_sync; // logic 1: enable i2c module
   input ic_10bit_slv_sync; // logic 1: IC 10-bit address transfer mode
                       // logic 0: IC 7-bit address transfer mode
   input tx_empty_sync;      // tx fifo empty
   input tx_empty_sync_hl;//logic 1:high to low edge detection of tx_empty_sync
   input arb_lost;   // logic 1: master lost arbitration
   input s_det;      // START condition detected
   input p_det;      // STOP condition detected
   input slv_ack_det;    // logic 1: acknowledge detected
   input slv_rx_ack_vld;
   input tx_fifo_dbuf_8;//Buffer to hold data popped from tx fifo
   input slv_rxbyte_rdy; //Indicates that a byte has been received
   input rx_gen_call;//General Call address has been received and acknowledged
//   input rx_start_byte;// Start byte has been received
   input rx_addr_match;//logic 1: An Address has been received and matched ours, logic 0: address fail
   input rx_slv_read;//logic 1: Slave is receiving data, logic 0: Slave has to transmit data
   input slv_tx_cmplt;//logic 1: slave has finished transmission
   input ic_data_oe;
   input ic_slave_en_sync;//1: slave is enabled, 0:disabled   
   
   input [7:0] ic_sda_setup; // SDA setup time, aka tsu;DAT
   
   input ic_ack_general_call;
   
   //Outputs
   output slv_tx_en; // Enable tx shift register to transmit data
   output slv_rx_en; // Enable rx shift register to transmit data
   output slv_gen_ack_en; // Enable Ack gen. ckt
   output slv_tx_abrt;   // logic 1: slave issued tx abort to flush the tx fifo
   output slv_rx_done;   // logic 1: slave stopped RX transfer   
   output slv_txfifo_ld_en;// load tx_buffer from the tx fifo output
   output slv_push_rxfifo_en;
   output slv_rx_1byte_en;//logic 1: we are receiving the 1st byte of a transfer
   output slv_rx_2byte_en;//logic 1: we are receiving the 2nd byte of a transfer
   output scl_hld_low_en;//logic 1:hold scl to low state (insert wait states)
   output slv_activity;//logic 1:slave is using the bus
   output ic_rd_req;//logic 1:Slave is waiting on data from the processor to tx
   output slv_debug_addr;
   output slv_debug_data;
   output slv_rx_2addr;//1: 2nd address byte in 10 bit mode has been received

   output abrt_slvflush_txfifo;//slave flush tx fifo to request tx data
   output abrt_slv_arblost;//Slave lost the bus while it is tx data
   output abrt_slvrd_intx;//Slave request data to tx and processor wrote 
   // a read command into the tx_fifo (9th bit is 1)
   output [3:0] slv_debug_cstate;//Currents state
   output slv_clr_leftover;//1: after a read request received we have more data in the 
                     // tx_fifo that was not transmitted
                     // so clear it inorder not to get the mstfsm to think
                     // that it is a data to send
   output       slv_rx_aborted;
   output       slv_fifo_filled_and_flushed;
   output       slv_addressed; // Qualifier signal to indicate the slave is addressed
   output       slv_tx_data_en; // Slave transmitting data from Tx_FIFO
   
   // ----------------------------------------------------------
   // -- local registers and wires
   // ----------------------------------------------------------
   //registers
   reg [3:0] slv_current_state;//Currents state
   reg [3:0] slv_next_state;//Next state
   reg              slv_tx_en;//enable tx shifter
   reg              slv_rx_en;//enable rx shifter
   reg              slv_gen_ack_en;//enable gen ACK in rx mode
   reg              slv_tx_abrt;//Master Tx aborted int.
   reg              slv_rx_done;//Master Rx aborted int.
   reg              slv_txfifo_ld_en; //Load fifo data into TX buffer
   reg              slv_tx_flush;//logic 1: slave has flushed the tx_fifo buffer
                          // in a byte streamis write (1) or No Transaction (0)
   reg              slv_activity;//indicates that we can stop without performing
                                 //illegal action on I2C bus
   reg              slv_push_rxfifo_en; //push data into RX_FIFO
   reg              ic_rd_req;//logic 1:Slave is waiting on data from the processor to tx
   reg              scl_hld_low_en;//Allow scl to be held low ti insert wait states
   reg              slv_rx_1byte_en;//logic 1: slave is receiving the first byte of a transfer
   reg              slv_rx_2byte_en;//logic 1: slave is receiving the first byte of a transfer
   reg              slv_rx_2addr;//1: 2nd address byte in 10 bit mode has been received


   //slave tx_abrt source indicator   
   reg abrt_slvflush_txfifo;//slave flush tx fifo to request tx data
   reg abrt_slv_arblost;//Slave lost the bus while it is tx data
   reg abrt_slvrd_intx;//Slave request data to tx and processor wrote 
   // a read command into the tx_fifo (9th bit is 1)
   reg slv_clr_leftover;//1: after a read request received we have more data in the 
                     // tx_fifo that was not transmitted
                     // so clear it inorder not to get the mstfsm to think
                     // that it is a data to send
   reg slv_rx_aborted; // indicates if a Slave-Rx operation has been aborted due to
                       // "ic_enabled" negating, and a negative ACK sent
   reg slv_fifo_filled_and_flushed; // indicates if a Slave-Rx operation has been aborted
                                    // due to "ic_enable" negating, AND with >= 1 byte
                                    // pushed into the Rx FIFO.
   reg slv_addressed              ; // Qualifier to notify whether slave is addressed or not.




   // ----------------------------------------------------------
   // -- local wires
   // ----------------------------------------------------------

   // ----------------------------------------------------------
   // -- state variables (gray coded)
   // ----------------------------------------------------------
   parameter        IDLE             = 4'b0000;//0: No activity
   parameter        RX_1BYTE         = 4'b0001;//1: Receive 1st byte
   parameter        RX10_2ND_ADDR    = 4'b0010;//2: receive the 2nd byte of 10 bit addr
   parameter        RX_LOOP          = 4'b0101;//5: Receive data loop
   parameter        TX_LOOP          = 4'b0111;//7: transmit data loop
   parameter        WAIT_TX_DATA     = 4'b0110;//6: wait for processor to supply data for slv TX
   parameter        ABORT_RX_ADDR    = 4'b0100;//4: address reception aborted due to START
   parameter        INSPECT_DATA_CMD = 4'b1000;//8: check bit 8 of IC_DATA_CMD
   // ----------------------------------------------------------
   // -- state assignment
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : FSM_SEQ_PROC
      if(ic_rst_n == 1'b0) begin
         slv_current_state <= IDLE;
      end else begin
         if ( ((slv_activity == 1'b0) && (ic_enable_sync  == 1'b0)) 
              || (ic_slave_en_sync == 1'b0)
              ) begin
            slv_current_state <= IDLE;
         end else begin
            slv_current_state <= slv_next_state;
         end
      end
   end
   
   // ----------------------------------------------------------
   // -- This combinational process calculates the next state
   // ----------------------------------------------------------
   always @(
            ic_enable_sync
            or ic_10bit_slv_sync
            or tx_empty_sync
            or slv_rxbyte_rdy
            or rx_gen_call
            or rx_addr_match
            or rx_slv_read    
            or s_det
            or p_det
            or slv_ack_det
            or slv_current_state
            or tx_empty_sync_hl
            or arb_lost
            or tx_fifo_dbuf_8
            or slv_tx_cmplt
            or slv_tx_flush
            or ic_ack_general_call
            or ic_data_oe
            ) begin: FSM_COMB_PROC
      slv_tx_abrt = 1'b0;
      slv_rx_done = 1'b0;
      slv_rx_en = 1'b0;
      slv_txfifo_ld_en = 1'b0;
      slv_push_rxfifo_en = 1'b0; //push data into RX_FIFO
      ic_rd_req = 1'b0;
      slv_rx_1byte_en = 1'b0;
      slv_rx_2byte_en = 1'b0;
      slv_next_state = IDLE;

      //slv tx_abrt source indicators
      abrt_slvflush_txfifo = 1'b0;
      abrt_slv_arblost = 1'b0;
      abrt_slvrd_intx = 1'b0;
      slv_clr_leftover = 1'b0;
      case (slv_current_state)
        IDLE:
          begin
             //Control signals initialization
             slv_tx_abrt = 1'b0;
             slv_rx_done = 1'b0;
             slv_rx_en = 1'b0;
             slv_txfifo_ld_en = 1'b0;
             slv_push_rxfifo_en = 1'b0; //push data into RX_FIFO
             ic_rd_req = 1'b0;
             slv_rx_1byte_en = 1'b0;
             slv_rx_2byte_en = 1'b0;
             
             if ((ic_enable_sync  == 1'b1) && // IC enabled
                 (s_det == 1'b1) // Start detected on the bus
                 ) begin
                slv_next_state = RX_1BYTE;
             end else begin
                slv_next_state = IDLE;
             end
          end

        // ====================================================================
        // The reception of the address, during RX_1BYTE state, is interrupted
        // by the detection of an "unexpected" START condition.
        // Restore all signals, as per in IDLE state, and immediately resume
        // address reception by entering RX_1BYTE again.
        // ====================================================================
        ABORT_RX_ADDR: begin
          slv_tx_abrt = 1'b0;
          slv_rx_done = 1'b0;
          slv_rx_en = 1'b0;
          slv_txfifo_ld_en = 1'b0;
          slv_push_rxfifo_en = 1'b0; //push data into RX_FIFO
          ic_rd_req = 1'b0;
          slv_rx_1byte_en = 1'b0;
          slv_rx_2byte_en = 1'b0;

          slv_next_state = RX_1BYTE;
        end // case
        
        // ====================================================================
        // Receiving the first (address) byte from the master, after having
        // detected the START condition earlier.
        // If a START is unexpectedly detected again, then reset all controls
        // by going into ABORT_RX_ADDR and then re-enter here.
        // If a STOP is unexpected detected, then go into IDLE.
        //
        // Made sure that if this HW generated a negative ACK, the SlvFSM goes
        // back into the idle state.
        //
        // Software now controls as to whether receiving can continue when
        // a General Call address is detected.
        // ====================================================================
        RX_1BYTE: begin
          slv_rx_en = 1'b1;
          slv_rx_1byte_en = 1'b1;
                                 // or if we are 10 bit and it is 1st or 2nd address that matches
                                 // ours or if it is a general call address

          if(s_det || p_det) begin
            slv_next_state = s_det ? ABORT_RX_ADDR : IDLE;
          end

          else if (slv_rxbyte_rdy == 1'b1) begin //We received the data byte
            slv_rx_1byte_en = 1'b0;
            slv_rx_en = 1'b0;
                  
            if(ic_data_oe==1'd0) begin
              slv_next_state = IDLE;
            end

            else 
                if(rx_gen_call == 1'b1) begin //General call address has been received
              if(ic_ack_general_call)
                slv_next_state = RX_LOOP;
              else
                slv_next_state = IDLE;
            end



            else if(rx_addr_match == 1'b0) begin 
              slv_next_state = IDLE;
            end 
                  
            else if(rx_slv_read == 1'b1) begin
              if(tx_empty_sync == 1'b0) begin
                slv_tx_abrt =1'b1;//issue tx_abrt to flush the TX buffer
                abrt_slvflush_txfifo = 1'b1;
              end

              ic_rd_req = 1'b1;
              slv_next_state = WAIT_TX_DATA;
            end


            else if(ic_10bit_slv_sync == 1'b1) begin //IC 10 bit and 1st addr byte matched
              slv_next_state = RX10_2ND_ADDR;
            end
                  
            else begin
              slv_next_state = RX_LOOP;
            end // else: !if(ic_10bit_slv_sync == 1'b1)
                  
          end // if (slv_rxbyte_rdy == 1'b1)
          else begin                         
            slv_next_state = RX_1BYTE;
          end // else: !if(slv_rxbyte_rdy == 1'b1)
        end // case: RX_BYTE
        
        // ====================================================================

        RX10_2ND_ADDR:
          begin
             slv_push_rxfifo_en = 1'b0;
             slv_rx_en = 1'b1;
             slv_rx_1byte_en = 1'b0;
             slv_rx_2byte_en = 1'b1;
                             
             if(p_det == 1'b1)
               begin
                  slv_rx_en = 1'b0;
                  slv_next_state = IDLE;
               end

             else if(s_det == 1'b1)
               begin
                  slv_rx_en = 1'b0;
                  slv_next_state = RX_1BYTE;
               end
             else if (slv_rxbyte_rdy == 1'b1) 
               begin
                  slv_rx_en = 1'b0;
                  if(rx_addr_match == 1'b1)
                   begin
                      
                        slv_next_state = RX_LOOP;
                   end
                 else
                   slv_next_state = IDLE;
              end
             else
               slv_next_state = RX10_2ND_ADDR;
             
               end // case: RX10_2ND_ADDR
        
        RX_LOOP:
          begin
             slv_rx_1byte_en = 1'b0;
             slv_rx_2byte_en = 1'b0;
             slv_push_rxfifo_en = 1'b0;    
      
             slv_rx_en = 1'b1;
             
             if(p_det == 1'b1)
               begin
                  slv_rx_en = 1'b0;
                  slv_next_state = IDLE;
               end

             else if(s_det == 1'b1)
               begin

                  slv_rx_en = 1'b0;
                  slv_next_state = RX_1BYTE;
               end
             
             else if (slv_rxbyte_rdy == 1'b1) 
               begin //We received the 2nd data byte
                  slv_rx_en = 1'b0;
                  slv_push_rxfifo_en = 1'b1;
       
    slv_next_state = RX_LOOP;
               end
             else begin
               slv_next_state = RX_LOOP;
             end
          end // case: RX_LOOP


            
        
        WAIT_TX_DATA:
          begin
             ic_rd_req = 1'b0;
             slv_txfifo_ld_en = 1'b0; //Don't Latch the Fifo data into the TX buffer yet
             
             if(p_det == 1'b1)
              begin
                 slv_next_state = IDLE;
              end
             
             else if(s_det == 1'b1)
               begin
                 slv_next_state = RX_1BYTE;
               end
             
             else 
               if(((slv_tx_flush == 1'b0) && (tx_empty_sync == 1'b0)) 
                     || ((slv_tx_flush == 1'b1) && (tx_empty_sync_hl == 1'b1)))// We have data to send
               begin
                  slv_txfifo_ld_en = 1'b1;//issue a pop tx fifo signal
                  slv_next_state = INSPECT_DATA_CMD; // was TX_LOOP;
               end
             else//keep waiting
               slv_next_state = WAIT_TX_DATA;
             
          end // case: WAIT_TX_DATA
        
        // ======================================================================
        // After the TxFIFO has been popped, inspect bit 8 of the IC_DATA_CMD
        // value written in.
        // If bit 8 eq 0, then proceed as normal.
        // If bit 8 eq 1, then alert appropriately and go back to wait for data.
        // ======================================================================
        INSPECT_DATA_CMD : begin
          if(p_det == 1'b1) begin
            slv_next_state = IDLE;
          end else if(s_det == 1'b1) begin
            slv_next_state = RX_1BYTE;
          end else if(tx_fifo_dbuf_8) begin
            slv_tx_abrt = 1'b1;
            abrt_slvrd_intx = 1'b1;
            
            slv_next_state = WAIT_TX_DATA;
          end else if(arb_lost) begin
            slv_tx_abrt = 1'b1;
            abrt_slv_arblost = 1'b1;

            slv_next_state = IDLE;
          end else begin
            slv_next_state = TX_LOOP;
          end // else arb_lost
        end // case INSPECT_DATA_CMD

        // ======================================================================
        // Transmission in progress loop.
        //
        // If the I2C Master NAK's the transfer, and the TxFIFO is still contains
        // 1 or more bytes, then a Abort_SlvFlush_TxFIFO condition is deemed to
        // have occurred.
        // ======================================================================
        
        TX_LOOP: begin
          slv_txfifo_ld_en = 1'b0; //latch tx data into the tx buf

          ic_rd_req = 1'b0;

          if(p_det == 1'b1) begin
            slv_next_state = IDLE;
          end
          else if(s_det == 1'b1) begin
            slv_next_state = RX_1BYTE;
          end
             
          else if ((arb_lost == 1'b1) || (tx_fifo_dbuf_8 == 1'b1)) begin 
                 //lost arb. or proc. wrote 1 in the 9th bit
                 // we cant read from the bus the bus now
            slv_tx_abrt = 1'b1;
            if(arb_lost == 1'b1) 
              abrt_slv_arblost = 1'b1;
            if(tx_fifo_dbuf_8 == 1'b1)
              abrt_slvrd_intx = 1'b1;
            slv_next_state = IDLE;
          end // else if 
             
          else if(slv_tx_cmplt == 1'b1) begin
            if (slv_ack_det == 1'b1) begin    //master acknowledged the data bytes
              if(tx_empty_sync == 1'b0) begin //We have more data in tx fifo
                slv_txfifo_ld_en = 1'b1;      //Load the fifo data to the tx buffer
                slv_next_state = TX_LOOP;
              end
              else begin                  //No more data to process
                slv_txfifo_ld_en = 1'b0;      //Don't Load the fifo data to the tx buffer yet
                ic_rd_req = 1'b1;             //issue a read request
                slv_next_state = WAIT_TX_DATA;//go and wait for the data

              end // else
            end // if slv_ack_det
             
            else begin                        // Master did not acknowledge the data byte
                                              // (it means we need to send no more data)
              if(tx_empty_sync == 1'b0) begin //We have more data in tx fifo
                slv_clr_leftover = 1'b1;
                abrt_slvflush_txfifo = 1'b1;
                slv_tx_abrt = 1'b1;
              end
              slv_rx_done = 1'b1;
              slv_next_state = IDLE;

            end // else slv_ack_det
          end // else slv_tx_cmplt

          else begin
            slv_next_state = TX_LOOP; // Wait for an ACK signal
          end
        end // case: TX_LOOP


        
        default: slv_next_state = IDLE;

      endcase // case(slv_current_state)
      
   end // block: FSM_COMB_PROC
  // ==========================================================================
  // Generating the ACK bit's polarity.
  //
  // Force the ACK's polarity to be negative if:
  // - the IC_ENABLE bit is 0
  // ==========================================================================
  reg ic_enable_sync_vld;

  always @(posedge ic_clk or negedge ic_rst_n) begin : ENABLE_SYNC_D_PROC
    if(!ic_rst_n) begin
      ic_enable_sync_vld <= 1'd0;
    end else begin
      if(ic_enable_sync==1'd0) begin
        if(slv_rx_ack_vld==1'd0)
          ic_enable_sync_vld <= 1'd0;
      end else begin
        ic_enable_sync_vld <= 1'd1;
      end // else ic_enable_sync
    end // else ic_rst_n
  end // always

  always @(   slv_current_state
           //LK-- or slv_rxbyte_rdy
           or s_det 
           or ic_enable_sync_vld ) begin : SLV_GEN_CK_EN_PROC
      
    slv_gen_ack_en = 1'b0;

    if(ic_enable_sync_vld) begin
      if((slv_current_state == RX_1BYTE) ||
         (slv_current_state == RX10_2ND_ADDR) ||
         (slv_current_state == RX_LOOP && s_det==1'b0)
        ) begin
        slv_gen_ack_en = 1'b1;
      end // if slv_current_state,... 
    end // if ic_enable_sync
  end 


  // ==========================================================================
  // Generating the slv_rx_aborted signal.
  //
  // This signal reacts to the negating of the IC_ENABLE register bit, and 
  // reflects the Slave FSM activity state during Slave-Rx operations.
  // This provides an indication to software that an attempt to shut down the
  // DW_apb_i2c was made when a Slave-Rx was in progress.
  // ==========================================================================
  always @(posedge ic_clk or negedge ic_rst_n) begin : SLV_TX_ABORTED_PROC 
    if(ic_rst_n==1'd0) begin
      slv_rx_aborted <= 1'd0;
    end else begin
      if(ic_enable_sync) begin
        slv_rx_aborted <= 1'd0;
      end else begin
        if(slv_current_state == RX_1BYTE ||
           slv_current_state == RX10_2ND_ADDR ||
           slv_current_state == RX_LOOP)
          slv_rx_aborted <= 1'd1;
      end // else ic_enable_sync
    end // else ic_rst_n
  end // always

  // ==========================================================================
  // Generating the slv_fifo_filled_and_flushed signal.
  //
  // This signal reacts to the negating of the IC_ENABLE register bit, and
  // reflects complete byte reception by the Slave FSM.
  // This provides an indication to software that an attempt to shut down the
  // DW_apb_i2c was made when >= 1 byte was received in a Slave-Rx operation,
  // irrespective of whether the transfer was ACK-ed or not.
  // ==========================================================================
  always @(posedge ic_clk or negedge ic_rst_n) begin : SLV_FIFO_FLUSHED_PROC 
    if(ic_rst_n==1'd0) begin
      slv_fifo_filled_and_flushed <= 1'd0;
    end else begin
      if(ic_enable_sync) begin
        slv_fifo_filled_and_flushed <= 1'd0;
      end else begin
        if(slv_current_state == RX_LOOP && slv_rxbyte_rdy)
          slv_fifo_filled_and_flushed <= 1'd1;
      end // else ic_enable_sync
    end // else ic_rst_n
  end // always

// ==========================================================
// Generating the "slv_tx_en"
//
// "slv_tx_en" is the same as that originally coded, but is
// relocated here for style and ease of reading. It is
// used to enable the tx_shift module's internals signals.
// ==========================================================
always @( slv_current_state or
          arb_lost          or
          tx_fifo_dbuf_8    or
          slv_tx_cmplt      or
          slv_ack_det       ) begin : SLV_TX_EN_PROC
  slv_tx_en    = 1'b0;

  if(slv_current_state == IDLE || 
     slv_current_state == ABORT_RX_ADDR) begin
    slv_tx_en    = 1'b0;
  end
  else if((slv_current_state == TX_LOOP)
  )
  begin
    slv_tx_en    = 1'b1;

    if(arb_lost || tx_fifo_dbuf_8) begin
      slv_tx_en    = 1'b0;
    end
    else if(slv_tx_cmplt) begin
      if(slv_ack_det) begin
        slv_tx_en    = 1'b0;

      end
      else begin
        slv_tx_en    = 1'b0;
      end
    end
  end
end

// ==========================================================
// Generating the "hold" SCL at low signal.
//
// Following piece of code previously resides within the
// Slave FSM always block.
//
// This signal ensures that the ic_clk_oe is forced to 0,
// so that the SCL on the I2C bus is driven low. This action
// primarily occurs when the I2C (Slave) needs to stretch the
// SCL's low polarity in response to a (eg.) I2C read. This
// allows time for the FIFO to be filled in the I2C (Slave)
// so that the required data can be popped for the I2C read
// to be completed.
//
// If either the START (s_det) or STOP (p_det) conditions are
// encountered, then SCL must also be released.
// ==========================================================

reg [7:0] stretch_scl_count;

always @(slv_current_state or
         stretch_scl_count or
         p_det             or
         s_det           /*or
         min_hld_cmplt     or
         slv_tx_ready*/ ) begin : SCL_HLD_LOW_EN_PROC

  scl_hld_low_en = 1'b0;

  if(slv_current_state==IDLE) begin
    scl_hld_low_en = 1'b0;
  end // IDLE

  else if(slv_current_state == WAIT_TX_DATA || slv_current_state==INSPECT_DATA_CMD) begin
    scl_hld_low_en = 1'b1;

    if(p_det==1'b1 || s_det==1'b1)
      scl_hld_low_en = 1'b0;
  end // WAIT_TX_DATA


  else if(slv_current_state == TX_LOOP) begin
    if(stretch_scl_count=={8{1'b1}}) begin
      scl_hld_low_en = 1'b0;
    end else
      scl_hld_low_en = 1'b1;
    // if((slv_tx_ready == 1'b1) && (min_hld_cmplt == 1'b1))
    //   scl_hld_low_en = 1'b0;
    // else
    //   scl_hld_low_en = 1'b1; 
  end // TX_LOOP
end

// ==========================================================
// Counter to add ensure setup time for SDA changes to rising
// edge of SCL is adhered to.
//
// This counter will ensure "scl_hld_low_en" is maintained
// low for the programmed value ("ic_sda_setup") before
// releasing it. This applies for the Slave FSM moving from
// the WAIT_TX_DATA to the TX_LOOP state(transmit) or from
// the WAIT_RX_FULL to the RX_LOOP state(receive) states.
// ==========================================================
always @(posedge ic_clk or negedge ic_rst_n) begin : STRETCH_SCL_COUNT_PROC
  if(ic_rst_n==1'b0) begin
    stretch_scl_count <= 8'd0;
  end else begin
    if(slv_current_state==IDLE || slv_current_state==WAIT_TX_DATA || slv_current_state==INSPECT_DATA_CMD 
    )
      stretch_scl_count <= 8'd0;
    else if(slv_current_state==TX_LOOP
       )begin
      if(stretch_scl_count >= ic_sda_setup)
        stretch_scl_count <= {8{1'b1}};
      else
        stretch_scl_count <= stretch_scl_count + 8'd1;
    end // else if
  end // else ic_rst_n
end // always

   // ----------------------------------------------------------
   // -- FSM Flags
   // ----------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : SLV_FSM_FLAGS_PROC
      if(ic_rst_n == 1'b0) begin
         
         slv_activity <= 1'b0;
         slv_tx_flush <= 1'b0;
         slv_rx_2addr <= 1'b0;
  
          end
        else 
          begin
             //slv flushed tx fifo buffer
             if ((slv_current_state == IDLE) 
                 || (slv_current_state == TX_LOOP)              
                 )
               begin
                  slv_tx_flush <= 1'b0;
               end
             
             else if((slv_current_state == RX_1BYTE) 
                     || (slv_current_state == RX10_2ND_ADDR)
                     || (slv_current_state == INSPECT_DATA_CMD))
               begin
                  slv_tx_flush <= slv_tx_abrt;
               end
             
             //slave activity flag
             if (slv_current_state != IDLE)
               begin
                  slv_activity <= 1'b1;
               end
             else
               slv_activity <= 1'b0;
             
             //10bit addr 2nd byte has been received
             if (slv_current_state == IDLE)                   
               begin
                  slv_rx_2addr <= 1'b0;
               end
             
             else if (slv_current_state == RX10_2ND_ADDR)
               begin
              slv_rx_2addr <= 1'b1;
               end

         
          end       
   end // block: FSM_FLAGS_PROC

   // ----------------------------------------------------
   // -- Slave addressed
   // -- Generate the signal which indicates the slave is addressed,
   // -- the slave is notified as addressed based on slave current state.
   // -- The slave is addressed on following conditions :
   // -- 7-bit address mode -> if address match in RX_1BYTE state, 
   // -- 10-bit address mode -> if address match in RX_1BYTE (MSB address) & RX10_2ND_ADDR (LSB address).

    always @(posedge ic_clk or negedge ic_rst_n) begin : SLV_ADDRESSED_PROC
      if(ic_rst_n == 1'b0) begin
        slv_addressed <= 1'b0;
      end
      else begin
        if(p_det || s_det)
          slv_addressed <= 1'b0;
        else if(ic_10bit_slv_sync) begin
           if((rx_addr_match & slv_rx_2byte_en)
               || (slv_rx_2addr & rx_slv_read)
              )  // Check for address match in second address byte for all writes 
             slv_addressed <= 1'b1;                                               // If read happens, after second address, check in RX_1BYTE state 
        end
        else begin
          if(rx_addr_match & slv_rx_1byte_en) begin
             slv_addressed <= 1'b1;
          end
        end
      end
    end

 // ----------------------------------------------------------
   // -- Qualifier for setup count enable in RX_LOOP state after
   // holding the line in WAIT_RX_FULL state due to Receive fifo
   // full. 
   // This counter will ensure "scl_hld_low_en" is maintained
   // low for the programmed value ("ic_sda_setup") before
   // releasing it during the issue of data ACK phase. 
   // ------------------------------------------------------------


   // ----------------------------------
   // -- generate debug signals
   // ----------------------------------
   
   assign slv_debug_addr = ((slv_current_state == RX_1BYTE)
                            ||(slv_current_state == RX10_2ND_ADDR));
   
   assign slv_debug_data = ((slv_current_state == RX_LOOP)
                            ||(slv_current_state == TX_LOOP)
                           );

   assign slv_debug_cstate = slv_current_state;

   assign slv_tx_data_en = (slv_current_state == TX_LOOP) 
                            ;


endmodule // DW_apb_i2c_slvfsm

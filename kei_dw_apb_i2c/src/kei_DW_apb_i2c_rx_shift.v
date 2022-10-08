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
// File Version     :        $Revision: #18 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_rx_shift.v#18 $ 
//
//
// File    : DW_apb_i2c_rx_shift.v
//
//
// Author  : Hani Saleh
// Created : Sep  2002
// Abstract: The rx_shft_reg module is responsible for receiving
//           a byte of data to either a slave or master in either 
//           Master or Slave mode configuration.  This module will
//           also generate the acknowledge pulse after a byte of 
//           data has been received 
//
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------

module kei_DW_apb_i2c_rx_shift
  (
   ic_clk
                             ,ic_rst_n
                             ,//regfile
                             ic_hs_sync
                             ,//mstfsm signals
                             mst_rx_en
                             ,mst_push_rxfifo_en
                             ,mst_rxbyte_rdy   
                             ,mst_rx_cmplt
                             ,// jduarte end 20101008
                             //slvfsm signals
                             slv_rx_en
                             ,slv_rx_1byte_en
                             ,slv_rx_2byte_en
                             ,rx_slv_read
                             ,slv_push_rxfifo_en
                             ,slv_rxbyte_rdy
                             ,slv_rx_2addr
                             ,rx_gen_call
                             ,rx_addr_match
                             ,rx_addr_10bit
                             ,rx_hs_mcode
                             ,//clk_gen signals
                             hs_mcode_en
                             ,ic_ack_general_call
                             ,rx_scl_lcnt_en
                             ,rx_scl_hcnt_en
                             ,scl_lcnt_cmplt
                             ,scl_hcnt_cmplt
                             ,//from rx_filter
                             sda_int
                             ,sda_vld
                             ,slv_rx_ack_vld
                             ,scl_int
                             ,scl_edg_hl
                             ,//rx shift reg
                             mst_rx_ack_vld
                             ,// jduarte begin 20101108
                             // CRM 9000366029
                             rx_shift_data_done
                             ,// jduarte end 20101108
                             //top level outputs
                             rx_current_src_en
                             ,//fifo cntl signals
                             rx_push
                             ,//regfile
                             ic_sar
                             ,ic_10bit_slv
                             ,mst_rxbyte_rdy_done
                             ,//fifo ram
                             rx_push_data
                             ,//tx_shift_reg
                             mst_rx_bwen
                             ,mst_rx_data_scl
                             ,mst_rx_bit_count
                             ,mstrx1_7_end
                             );

   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input ic_clk;// processor clock
   input ic_rst_n;// syn rst active high
   //mstfsm signals
   input                    mst_rx_en; // Enable rx shift register to transmit data
   input                    mst_push_rxfifo_en;//logic 1:push received data to the RX fifo
// jduarte begin 20101008
// CRM 9000366029
// jduarte end 20101008
   //slvfsm signals
   input                    slv_rx_en;//slave enable RX
   input                    slv_rx_1byte_en;//slave receive 1st byte
   input                    slv_rx_2byte_en;//slave receive 2nd byte
   input                    slv_push_rxfifo_en;//slave push data to rx fifo enable
   input                    slv_rx_2addr;//1: 2nd address byte in 10 bit mode has been received

   //regfile
   input                    ic_hs_sync;//ic is in high speed mode
   //from rx_filter
   input                    sda_int;//SDA bus value
   input                    sda_vld;//SDA value is valid
   input                    scl_int;//internal filtered input SCL line
   input                    scl_edg_hl;   // falling edge detect of SCL

   //from clk_gen
   input                    scl_lcnt_cmplt;//Low count completed
   input                    scl_hcnt_cmplt;//High count completed
   //regfile
   input [`IC_SAR_RS-1:0]  ic_sar;//IC module address to other Masters
   input                    ic_10bit_slv;//IC slave 10 bit address mode selection
   input                    hs_mcode_en;//IC in HS mode and transmitting the HS Master Code
   input                    ic_ack_general_call;
   //OUTPUTS
   output                    rx_slv_read;//logic 1:slave is written
   output                    mst_rx_ack_vld;//logic 1:check for ack now

// jduarte begin 20101108
// CRM 9000366029
   output                    rx_shift_data_done;
// jduarte end 20101108


   //to fifo ram
   output [`IC_DATA_FIFO_RS-1:0] rx_push_data;//push data to rx fifo

   //to slv_fsm
   output                         mst_rxbyte_rdy;//logic 1: master received byte is ready
   output                         mst_rxbyte_rdy_done;
   output    mst_rx_cmplt;//master rx completed

   output                        slv_rxbyte_rdy; //Indicates that a byte has been received
   output                        rx_gen_call;//General Call address has been received and acknowledged
//   output                        rx_start_byte;// Start byte has been received
   output                        rx_addr_match;//logic 1: An Address has been received and matched ours, logic 0: address fail
   output                        rx_addr_10bit;//Rx address is 10bit
   output                        rx_hs_mcode;//logic 1:High speed mode code has been received




   //to fifo cntl
   output                         rx_push;//logic 1: push data to rx fifo
   //to clk_gen
   output                         rx_scl_lcnt_en;
   output                         rx_scl_hcnt_en;
   //to top level
   output                         rx_current_src_en;//logic 1:enables pull up current source in HS mode
   output slv_rx_ack_vld;//logic 1:slave receiver ack is valid
   //to tx shift reg
   output              mst_rx_data_scl;//Master rx generated clock signal
   output              mst_rx_bwen;//master rx byte wait enable

   output [3:0]        mst_rx_bit_count;
   output              mstrx1_7_end;
   // ----------------------------------------------------------
   // -- local wires
   // ----------------------------------------------------------
   //registers
   reg [`IC_DATA_RS-1:0]         mst_rx_shift_reg;//Master RX shift register
   reg [`IC_DATA_RS-1:0]         slv_rx_shift_reg;//Slave RX shift register
   //to clk_gen
   reg                           rx_scl_lcnt_en;
   reg                           rx_scl_hcnt_en;
   
   reg                           rx_current_src_en;
   reg [`IC_DATA_FIFO_RS-1:0]    rx_push_data;
   reg [3:0]                     mst_rx_bit_count;
   reg                           mst_rx_data_scl;
   reg                           mst_rx_ack_int;//logic 1: This is the ack clock cycle
   reg                           mst_rxbyte_rdy;//logic 1: 1 byte has been received and ready
   reg                           slv_rx_ack_vld;
   reg [3:0]                     slv_rx_bit_count;
   reg [3:0]                     scl_hl_edg_cntr;
   reg                           slv_rxbyte_rdy;
   reg                           rx_gen_call;
   reg                           rx_addr_match;
   reg                           rx_addr_10bit;
   reg                           rx_hs_mcode;
   reg                           rx_slv_read;
   reg                            rx_slv_read_s;

   reg                           rx_push;
   reg                           mst_rx_bwen;//master rx byte wait enable
// jduarte begin 20101108
// CRM 9000424562
   reg                           scl_int_r;
// jduarte end 20101108
   reg    mst_rxbyte_rdy_done;
   //wires   
   wire rx_rdy_en;
   wire slvrx_bit1_7_lo;
   wire slvrx_bit1_7_hi;
   wire slvrx_bit8;
   wire rx_mcode;
   wire rx_10bit_1addr;
   wire rx_10b_in7bit;
   wire rx_7bit_addr;
   wire rx_2byte;
   wire rx_10bit_2addr;
   wire mst_rx_cmplt;
   wire mst_enrx;
   wire mstrx1_7_lo;
   wire mstrx1_7_hi;
   wire mstrx1_7_end;
   wire mstrx1_7_end_int;
   wire mstrx_8_lo;
   wire mstrx_8_hi;
   wire mstrx_8_end;
   wire mstrx_8_end_int;
   wire [2:0] mst_rx_bit_count_2to0;
   wire [2:0] slv_rx_bit_count_2to0;
// jduarte begin 20101108
// CRM 9000424562
   wire scl_int_ed;
// jduarte end 20101108
   
   
// jduarte begin 20101108
// CRM 9000366029
   wire rx_shift_data_done;
// jduarte end 20101108
   assign mst_rx_bit_count_2to0 = mst_rx_bit_count[2:0];
   assign slv_rx_bit_count_2to0 = slv_rx_bit_count[2:0];
   //assigning outputs to internal signal
   assign    mst_rx_ack_vld = mst_rx_ack_int;
   // ------------------------------------------------------
   // -- rx_push output
   //
   //  The rx_push output is used in the pclk
   //  domain to remove data
   //  from the tx fifo.
   // ------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : PUSH_RX_PROC
      if(ic_rst_n == 1'b0)
        rx_push <= 1'b0;
      else
        rx_push <= (slv_push_rxfifo_en == 1'b1) 
        || (mst_push_rxfifo_en == 1'b1)
        ;
   end
   

   // ------------------------------------------------------
   // -- rx_fifo data buffer
   //
   // -- This buffer is used to store the last pushed data
   // -- to the rx fifo
   // ------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin : RX_FIFO_DATA_PROC
      if(ic_rst_n == 1'b0) begin
         rx_push_data <= {`IC_DATA_FIFO_RS{1'b0}};
      end else begin
         if(mst_rxbyte_rdy== 1'b1) begin
            rx_push_data <= mst_rx_shift_reg;
         end
         else 
             if(slv_rxbyte_rdy== 1'b1) begin
            rx_push_data <= slv_rx_shift_reg;
         end
      end
   end

   // ------------------------------------------------------
   // -- slave rx shift process
   //
   // -- The size of a data transfer is always 8 
   // -- bits.  
   // ------------------------------------------------------

   assign rx_rdy_en = (slv_rx_en == 1'b1);
   assign slvrx_bit1_7_lo = ((scl_edg_hl == 1'b1) && (slv_rx_bit_count < 8));
   assign slvrx_bit1_7_hi = ((slv_rx_bit_count < 8)&&(sda_vld == 1'b1));
   assign slvrx_bit8 = (slv_rx_bit_count == 8) && ((slv_rx_1byte_en == 1'b1)
           );
   assign rx_mcode = (( slv_rx_shift_reg[`IC_DATA_RS - 1:3] == `IC_HS_CODE));
   assign rx_10bit_1addr = (( slv_rx_shift_reg[`IC_DATA_RS - 1:1] == {`IC_SLV_ADDR_10BIT,ic_sar[9:8]}) && (ic_10bit_slv == 1'b1));
   assign rx_10b_in7bit = (( slv_rx_shift_reg[`IC_DATA_RS - 1:3] == `IC_SLV_ADDR_10BIT) && (ic_10bit_slv == 1'b0));
   assign rx_7bit_addr = ((slv_rx_shift_reg[`IC_DATA_RS - 1:1] == ic_sar[6:0]) && (ic_10bit_slv == 1'b0));
   assign rx_2byte = ((slv_rx_bit_count == 8) && (slv_rx_2byte_en == 1'b1));
   assign rx_10bit_2addr = (( slv_rx_shift_reg[`IC_DATA_RS - 1:0] == ic_sar[7:0]) && (ic_10bit_slv == 1'b1));

   always @(posedge ic_clk or negedge ic_rst_n) begin : SLV_RX_SHIFT_PROC
      if(ic_rst_n == 1'b0) begin
         slv_rx_shift_reg <= {`IC_DATA_RS{1'b0}};
         slv_rx_bit_count <= 4'b0000;
         scl_hl_edg_cntr  <= 4'b0000;
         slv_rxbyte_rdy <= 1'b0;
         slv_rx_ack_vld <= 1'b0;
         rx_gen_call     <= 1'b0;
         rx_addr_match   <= 1'b0;
         rx_addr_10bit   <= 1'b0;
         rx_hs_mcode  <= 1'b0;
         //LK-- rx_slv_read      <= 1'b0;
         
      end else if (rx_rdy_en == 1'b1) begin
         slv_rx_bit_count <= (scl_hl_edg_cntr == 4'h0) ? scl_hl_edg_cntr : 
                             ((slv_rx_1byte_en == 1'b1) ? (scl_hl_edg_cntr - {3'h0,1'b1} ): scl_hl_edg_cntr);             
         
         if(slvrx_bit1_7_lo == 1'b1) begin
              scl_hl_edg_cntr <= scl_hl_edg_cntr + {3'h0,1'b1};
         end
         else if (slvrx_bit1_7_hi == 1'b1) begin
              slv_rxbyte_rdy  <= 1'b0;
              slv_rx_ack_vld  <= 1'b0;
              rx_gen_call     <= 1'b0;
              rx_addr_match   <= 1'b0;
              rx_addr_10bit   <= 1'b0;
              rx_hs_mcode  <= 1'b0;
              //LK-- rx_slv_read       <= 1'b0;
              case(slv_rx_bit_count_2to0)
                0       : slv_rx_shift_reg[7] <= sda_int;
                1       : slv_rx_shift_reg[6] <= sda_int;
                2       : slv_rx_shift_reg[5] <= sda_int;
                3       : slv_rx_shift_reg[4] <= sda_int;
                4       : slv_rx_shift_reg[3] <= sda_int;
                5       : slv_rx_shift_reg[2] <= sda_int;
                6       : slv_rx_shift_reg[1] <= sda_int;
                default : slv_rx_shift_reg[0] <= sda_int;
              endcase
         end else if(slvrx_bit8 == 1'b1) begin
             //LK-- rx_slv_read <= slv_rx_1byte_en & slv_rx_shift_reg[0];//Only the 1st addrss byte indicates the direction

             slv_rxbyte_rdy <= scl_edg_hl;

              if(scl_edg_hl == 1'b0)
                begin
                   if(rx_mcode == 1'b1)
                     begin
                        rx_hs_mcode <= 1'b1;
                        slv_rx_ack_vld <= 1'b0;//dont acknowledge  HS_MCODE
                     end
                   
                   else 
                       if( slv_rx_shift_reg[`IC_DATA_RS - 1:0] == `IC_GENERAL_CALL)
                     begin
                        rx_gen_call <=1'b1;
                        if(ic_ack_general_call)    // If the ACK_GENERAL_CALL reg is set,
                          slv_rx_ack_vld <= 1'b1;  // then ACK the address
                        else
                          slv_rx_ack_vld <= 1'b0;  // Otherwise, NAK the address.
                     end
                   
                   else if( slv_rx_shift_reg[`IC_DATA_RS - 1:0] == `IC_START_BYTE)
                     begin
                        slv_rx_ack_vld <= 1'b0;//dont acknowledge  start byte
                     end
                   else if(rx_10bit_1addr == 1'b1)
                     begin
                        rx_addr_10bit  <= 1'b1;//address received is 10 bit
                        rx_addr_match  <= ~rx_slv_read 
                                          | (rx_slv_read & slv_rx_2addr);
                        slv_rx_ack_vld <= ~rx_slv_read_s 
                                          | (rx_slv_read_s & slv_rx_2addr);//Acknowledge only
                        //if this is a switch of diriction and we 
                        // were addressed before
                     end

                   else if(rx_10b_in7bit == 1'b1)
                     begin
                        rx_addr_10bit  <= 1'b1;//address received is 10 bit 
                                               // while i2c slave is 7 bit
                        rx_addr_match  <= 1'b0;
                        slv_rx_ack_vld <= 1'b0;
                     end
                    
                   else if(rx_7bit_addr == 1'b1)
                     begin
                        rx_addr_10bit  <= 1'b0;//address received is 7 bit
                        rx_addr_match  <= 1'b1;
                        slv_rx_ack_vld <= 1'b1;
                     end
                end // if (scl_edg_hl == 1'b0)
           end // if ((slv_rx_bit_count == 8) &&...
         
         else if(rx_2byte == 1'b1) begin
            slv_rxbyte_rdy <= scl_edg_hl;

            if(scl_edg_hl == 1'b0) begin
              if(rx_10bit_2addr == 1'b1) begin
               rx_addr_match   <= rx_10bit_2addr;
               slv_rx_ack_vld <= rx_10bit_2addr;
              end // if ((slv_rx_bit_count == 8) &&...
            end
         end // if ((slv_rx_bit_count == 8) &&...
         else begin //if((slv_rx_bit_count == 8)
           slv_rx_ack_vld <= (slv_rx_bit_count == 4'h8) ? 1'b1:1'b0;

           slv_rxbyte_rdy <= scl_edg_hl;


         end 
         
      end // if ((slv_rx_en == 1'b1) && (slv_rxbyte_rdy == 1'b0))
      else if (slv_rx_en == 1'b0)
        begin
           slv_rx_shift_reg <= {`IC_DATA_RS{1'b0}};
           slv_rx_bit_count <= 4'b0000;
           scl_hl_edg_cntr  <= 4'b0000;
           slv_rxbyte_rdy   <= 1'b0;
           slv_rx_ack_vld   <= 1'b0;
           rx_gen_call     <= 1'b0;
           rx_addr_match   <= 1'b0;
           rx_addr_10bit   <= 1'b0;
           rx_hs_mcode  <= 1'b0;
           //LK-- rx_slv_read       <= 1'b0;
        end // if (slv_rx_en == 1'b0)
   end // block: SLV_RX_SHIFT_PROC

  // =====================================================
  // Generate the "rx_slv_read" signal
  //
  // "slv_rx_ack_vld" uses "rx_slv_read" originally. In
  // fixing glitches in "ic_data_oe", "slv_rx_ack_vld" now
  // uses "rx_slv_read_s". See CRM 9000083225.
  // =====================================================
  wire slv_rx_shift_reg_bit0;
  assign slv_rx_shift_reg_bit0 = slv_rx_shift_reg[0];

  always @(posedge ic_clk or negedge ic_rst_n) begin : RX_SLV_READ_PROC
    if(!ic_rst_n)
      rx_slv_read <= 1'd0;
    else
      rx_slv_read <= rx_slv_read_s;
  end // always

  always @(   slv_rx_en 
           or slvrx_bit1_7_hi
           or slvrx_bit8
           or rx_slv_read
           or slv_rx_1byte_en 
           or slv_rx_shift_reg_bit0 ) begin : RX_SLV_READ_S_PROC
    rx_slv_read_s = rx_slv_read;

    if(slv_rx_en) begin
      if(slvrx_bit1_7_hi)
        rx_slv_read_s = 1'd0;
      else if(slvrx_bit8)
        rx_slv_read_s = slv_rx_1byte_en & slv_rx_shift_reg_bit0;
    end else begin
      rx_slv_read_s = 1'd0;
    end
  end // always

   // ------------------------------------------------------
   // -- master rx shift process
   //
   // -- The size of a data transfer is always 8 
   // -- bits.  
   // ------------------------------------------------------ 

   assign mst_rx_cmplt = (scl_lcnt_cmplt == 1'b1) && (scl_hcnt_cmplt ==1'b1) && (mst_rx_ack_int == 1'b1);

   assign mst_enrx = (mst_rx_en == 1'b1);
   assign mstrx1_7_lo = ((mst_rx_bit_count < 8) && (scl_lcnt_cmplt == 1'b0));
   assign mstrx1_7_hi = ((mst_rx_bit_count < 8) && (scl_lcnt_cmplt == 1'b1) && (scl_hcnt_cmplt == 1'b0));
   assign mstrx1_7_end_int = ((scl_lcnt_cmplt == 1'b1) 
                              && (rx_scl_lcnt_en == 1'b1) && (rx_scl_hcnt_en == 1'b1));
   assign mstrx1_7_end = ((mstrx1_7_end_int == 1'b1) 
                          && (mst_rx_bit_count < 8) && (scl_hcnt_cmplt == 1'b1));
   
   assign mstrx_8_lo = ((mst_rx_bit_count == 8) && (scl_lcnt_cmplt == 1'b0) && (scl_hcnt_cmplt == 1'b0));
   assign mstrx_8_hi = ((mst_rx_bit_count == 8) && (scl_lcnt_cmplt == 1'b1) && (scl_hcnt_cmplt == 1'b0));
   assign mstrx_8_end_int = ((scl_lcnt_cmplt == 1'b1) 
                             && (rx_scl_lcnt_en == 1'b1) && (rx_scl_hcnt_en == 1'b1));
   assign mstrx_8_end = ((mstrx_8_end_int == 1'b1) && (mst_rx_bit_count == 8) && (scl_hcnt_cmplt == 1'b1));
   
// jduarte begin 20101108
// CRM 9000366029
   assign rx_shift_data_done = (mst_rx_bit_count == 4'b0111) && mstrx1_7_end;
// jduarte end 20101108
   
   //spyglass disable_block STARC05-2.11.3.1
   //SMD: Ensure that the sequential and combinational parts of an FSM description 
   //     should be in separate always blocks.
   //SJ:  This implmentation is as per the design requirement. 
   //     There will not be any functional issue.
   always @(posedge ic_clk or negedge ic_rst_n) begin : MST_RX_SHIFT_PROC
      if(ic_rst_n == 1'b0) begin
         mst_rx_shift_reg <= {`IC_DATA_RS{1'b0}};
         mst_rx_bit_count <= 4'b0000;
         mst_rx_ack_int <= 1'b0;
// jduarte begin 20101108
// CRM 9000424562
//         rx_current_src_en <= 1'b0;
// jduarte end 20101108
         mst_rxbyte_rdy <= 1'b0;
         mst_rx_data_scl <= 1'b1;
         rx_scl_lcnt_en <= 1'b0;
         mst_rxbyte_rdy_done <= 1'b0;
         rx_scl_hcnt_en <= 1'b0;
      end else if (mst_enrx == 1'b1)
        begin

         if (mstrx1_7_lo == 1'b1)
           begin
         
              mst_rx_ack_int <= 1'b0;
              
// jduarte begin 20101108
// CRM 9000424562
//              if (src_on == 1'b1)
//                rx_current_src_en <= 1'b1;
// jduarte end 20101108

              mst_rxbyte_rdy <= 1'b0;
              mst_rx_data_scl <= 1'b0;
              rx_scl_lcnt_en <= 1'b1;
              rx_scl_hcnt_en <= 1'b0;
           end
         
         else if(mstrx1_7_hi == 1'b1)
           begin
              mst_rx_data_scl <= 1'b1;
              rx_scl_lcnt_en <= 1'b1;

                if(rx_scl_hcnt_en == 1'b0)//Bit wait state condition
                  rx_scl_hcnt_en <= (scl_int == 1'b1) ? 1'b1 : 1'b0;
                else
                  rx_scl_hcnt_en <= 1'b1;
           end

         else if(mstrx1_7_end == 1'b1)
           begin
              case (mst_rx_bit_count_2to0)
                0 : mst_rx_shift_reg[7] <= sda_int;
                1 : mst_rx_shift_reg[6] <= sda_int;
                2 : mst_rx_shift_reg[5] <= sda_int;
                3 : mst_rx_shift_reg[4] <= sda_int;
                4 : mst_rx_shift_reg[3] <= sda_int;
                5 : mst_rx_shift_reg[2] <= sda_int;
                6 : mst_rx_shift_reg[1] <= sda_int;
                default : mst_rx_shift_reg[0] <= sda_int;
              endcase               
              mst_rx_bit_count <= mst_rx_bit_count + {3'h0,1'b1};
              mst_rx_data_scl <= 1'b0;
              rx_scl_lcnt_en <= 1'b0;
              rx_scl_hcnt_en <= 1'b0;
           end
         
         else if(mstrx_8_lo == 1'b1)
           begin
                mst_rxbyte_rdy <= 1'b0;
              

              mst_rx_ack_int <= 1'b1;//gen ack during the low state of SCL
// jduarte begin 20101008
// CRM 9000366029
//              rx_scl_lcnt_en <= 1'b1;
              mst_rx_data_scl <= 1'b0;
              rx_scl_lcnt_en <= 1'b1;
// jduarte end 20101008
              rx_scl_hcnt_en <= 1'b0;
           end
         
         else if(mstrx_8_hi == 1'b1)
           begin
              mst_rx_ack_int <= 1'b1;//it is scl high keep the ack sda value
              mst_rxbyte_rdy <= 1'b0;
              mst_rx_data_scl <= 1'b1;
              rx_scl_lcnt_en <= 1'b1;

                if(rx_scl_hcnt_en == 1'b0)//Bit wait state condition
                  rx_scl_hcnt_en <= (scl_int == 1'b1) ? 1'b1 : 1'b0;
                else
                  rx_scl_hcnt_en <= 1'b1;
           end

         else if(mstrx_8_end == 1'b1)
           begin
// jduarte begin 20101008
// CRM 9000366029
//              mst_rx_bit_count <= 4'b0000;
              mst_rx_bit_count <= 4'b0000;
// jduarte end 20101008

// jduarte begin 20101108
// CRM 9000424562
//              if (ic_hs_sync == 1'b1)
//                rx_current_src_en <= 1'b0;
// jduarte end 20101108
              
// CRM 9000424562

              mst_rx_ack_int <= 1'b1;
              mst_rxbyte_rdy <= 1'b1;
              mst_rxbyte_rdy_done <= 1'b0;
              mst_rx_data_scl <= 1'b1;
              rx_scl_lcnt_en <= 1'b0;
              rx_scl_hcnt_en <= 1'b0;
           end
         end
         else if (mst_rx_en == 1'b0)
               begin
                 mst_rx_bit_count <= 4'b0000;
                 mst_rx_ack_int <= 1'b0;
// jduarte begin 20101108
// CRM 9000424562
//                 rx_current_src_en <= 1'b0;
// jduarte end 20101108
                 mst_rxbyte_rdy <= 1'b0;
                 mst_rx_data_scl <= 1'b1;
                 rx_scl_lcnt_en <= 1'b0;
                 rx_scl_hcnt_en <= 1'b0;
                end
   end // block: RX_SHIFT_PROC
   //spyglass enable_block STARC05-2.11.3.1

// jduarte begin 20101108
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
            rx_current_src_en <= 1'b0;
       end else begin
            if(((mst_rx_bit_count == 0) && mstrx1_7_lo) || (~((ic_hs_sync == 1'b1) && (hs_mcode_en == 1'b0)))) begin
                rx_current_src_en <= 1'b0;
            end else if((mst_rx_bit_count == 0) && scl_int_ed) begin
                rx_current_src_en <= 1'b1;
            end
       end
   end
// jduarte end 20101108
   // ------------------------------------------------------
   // -- master rx byte wait enable process
   //
   // ------------------------------------------------------ 
      always @(posedge ic_clk or negedge ic_rst_n) begin : MST_RX_BWEN_PROC
      if(ic_rst_n == 1'b0) begin
         mst_rx_bwen <= 1'b0;
      end else 
        if (mstrx1_7_lo == 1'b1)
          mst_rx_bwen <= 1'b0;
      
        else if(mstrx_8_hi ==1'b1)
          mst_rx_bwen <= rx_scl_hcnt_en;
   end // block: MST_RX_BWEN

   
endmodule // DW_apb_i2c_rx_shift


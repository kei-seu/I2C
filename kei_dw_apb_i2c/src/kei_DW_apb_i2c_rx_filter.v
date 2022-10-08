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
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_rx_filter.v#28 $ 
//
//
// File    : DW_apb_i2c_rx_filter
//
//
// Author  : Hani Saleh
// Created : Sep, 2002
// Abstract: The rx_filter module is reponsible for filtering the
//           incoming SDA and SCL signals on the I2C Bus. This module
//           will also detect the START & STOP conditions,
//           when configured as MASTER
//           this module will determine if arbitration was lost.
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------


module kei_DW_apb_i2c_rx_filter
  (
   //top level signals
   ic_clk,
                              ic_rst_n,
                              ic_clk_in_a,
                              ic_data_in_a,
                              ic_data_oe,
                              //tx shift register signals
                              slv_tx_ack_vld,
                              mst_tx_ack_vld,
                              mst_rx_ack_vld,
                              slv_tx_shift_en,
                              //clk_gen signals
                              sda_int,
                              scl_int,
                              //reg file signals
                              ic_hs_sync,
                              ic_fs_sync,
                              p_det_ifaddr_sync,
                              // jduarte 20110105 begin
                              // CRM 9000368180
                              // Added register outputs for spike length, in ic_clk cycles
                              // The value for FS and SS modes is the same (ic_fs_spklen)
                              ic_hs_spklen,
                              ic_fs_spklen,
                              ic_master_sync,
                              ic_sda_rx_hold_sync, // SDA hold time when I2C acts as reciever
                              hs_mcode_en,
                              rx_hs_mcode,
                              ic_spklen_o,
                              // jduarte 20110105 end
                              //mstfsm signals
                              stop_en,
                              start_en,
                              re_start_en,
                              split_start_en,
                              mst_tx_en,
                              mst_rx_en,
                              mst_activity,
                              //slvfsm signals
                              slv_tx_en,
                              slv_activity,
                              slv_addressed,
                              //misc.
                              sda_vld,
                              s_det,
                              p_det,
                              p_det_intr,
                              arb_lost,
                              ack_det,
                              slv_ack_det,
                              scl_edg_hl
                              );
   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input ic_clk;// peripherial clock: runs i2c module
   input ic_rst_n;// ic reset signal active low


   input ic_clk_in_a;// Input SCL signal
   input ic_data_in_a;// Input SDA signal

   input ic_hs_sync;//IC is in high speed mode
   input ic_fs_sync;//IC is in fast speed mode
   input p_det_ifaddr_sync; // Programmable option to generate stop only if slave is addressed

   // jduarte 20110105 begin
   // CRM 9000368180
   // Added register outputs for spike length, in ic_clk cycles
   // The value for FS and SS modes is the same (ic_fs_spklen)
   input [`IC_HS_SPKLEN_RS-1:0] ic_hs_spklen;
   input [`IC_FS_SPKLEN_RS-1:0] ic_fs_spklen;
   input                        ic_master_sync;
   input [`IC_SDA_RX_HOLD_RS-1:0]  ic_sda_rx_hold_sync;  // SDA Hold time while I2C acts as transmitter
   input                        hs_mcode_en; // Master sending high speed master code
   input                        rx_hs_mcode; // pulsed when slave receives high speed master code
   output [`IC_SPKLEN_RS-1:0]   ic_spklen_o; // Spike length currently being applied
   // jduarte 20110105 end

   input ic_data_oe;// Transmit SDA signal. Need in Master mode
                     // to determine if Arbitration is lost
                    // to determine Start and stop generation

   input mst_tx_en;// logic 1: enable transmit logic
   input mst_rx_en;// logic 1: enable receive logic
   input stop_en;// master generating stop condition
   input start_en;// master generating start/re_start condition
   input re_start_en;// master generating re_start condition
   input split_start_en; // Master halts temporarily in SplitStart
   input mst_activity;//logic 1: master is busy


   input slv_tx_ack_vld;//slave tx  check for ack now
   input mst_tx_ack_vld;//master tx  check for ack now
   input mst_rx_ack_vld;//master rx  check for ack now
   input slv_tx_en; // Enable tx shift register to transmit data
   input slv_activity;//logic 1:slave is using the bus
   input slv_addressed; // Qualifier signal to indicate the slave is addressed

   // OUTPUTS
   output sda_vld;// SDA signal is valid
   output s_det;// START condition detected
   output p_det;// STOP condition detected
   output p_det_intr;// STOP condition detected based on slave addressed or not
   output arb_lost;// When confgured as MSTR, Arbitration lost
   output slv_tx_shift_en;// shift enable pulse valid when falling
                          // edge detected on SCL signal
   output sda_int;//input SDA signal
   output scl_int;//filtered input scl signal
   output ack_det;//ACK has been detected
   output slv_ack_det;//ACK has been detected

   output   scl_edg_hl;   // falling edge detect of SCL

   // ----------------------------------------------------------
   // -- local registers and wires
   // ----------------------------------------------------------
   //wires
   wire   ic_clk;
   wire   ic_rst_n;
   wire   ic_clk_in_a;
   wire   ic_data_in_a;

   wire   scl_edg_lh;   // rising edge detect of SCL
   wire   scl_edg_hl_int;   // falling edge detect of SCL
   wire   sda_edg_lh;    // rising edge detect of SDA
   wire   sda_edg_hl;    // falling edge detect of SDA


   wire   s_det_int;
   wire   p_det_int;
   wire start_stop_mstactivity;
   wire ack_bit_activity;
   wire sda_post_spk_suppression; // SDA line after Spike suppression
   wire ic_sda_rx_hold_done; // Asserted when SDA hold time is finished

   //regs
   reg           mst_arb_lost;
   reg           slv_arb_lost;
   reg           slv_tx_shift_en;
   wire          scl_sync;   
   // jduarte 20110105 begin
   // CRM 9000368180
   // The two signals below will be replaced by a counter
   //reg           scl_sync_q;   // 1 Clock delay of scl_sync
   //reg           scl_sync_qq;   // 1 Clock delay of scl_sync_q
   //reg [2:0] scl_ored;   // or scl,scl_q,&scl_qq
   // jduarte 20110105 end
   reg              scl_clk_int;   // best of 3 SCL's
   reg              scl_int_q;   // 1 clock delay of scl_clk_int
   reg [1:0] sda_cnt;   // cnt SDA samples
   reg              sda_vld_int;   // filtered SDA signal in Fast mode is valid
   wire             sda_sync;   
   // jduarte 20110105 begin
   // CRM 9000368180
   // The two signals below will be replaced by a counter
   //reg              sda_sync_q;    // 1 clock delay of sda_sync
   //reg              sda_sync_qq;    // 1 clock delay of sda_sync_q
   //reg [2:0] sda_ored;    // or sda,sda_q,&sda_qq
   // jduarte 20110105 end
   reg              sda_data_int;    // best of 3 SDA's
   reg              sda_int_q;    // 1 clock delay of sda_data_int
   reg              s_det;
   reg              p_det;
   reg              p_det_intr;
   reg               scl_is_low_q;   // scl low valid true
   reg               scl_low_vld;
   reg               scl_is_low_qq;   // 1 clock delay of scl_low_vld
   reg slv_ack_det;
   reg ack_det;
   reg scl_edg_hl_q;
   // jduarte 20110105 begin
   // CRM 9000368180
   // Added counters for timing spike length, in ic_clk cycles
   // Since FS/SS spike suppression is 50ns and HS is 10ns,
   // length of counter is dependent on the count value for FS/SS only
   reg [`IC_FS_SPKLEN_RS-1:0] ic_scl_spklen_cnt;
   reg [`IC_FS_SPKLEN_RS-1:0] ic_sda_spklen_cnt;
   // jduarte 20110105 end

   // Added counters for timing SDA HOLD time, in ic_clk cycles
   reg [`IC_SDA_RX_HOLD_RS-1:0]  ic_sda_rx_hold_cnt;
   reg [`IC_SDA_RX_HOLD_RS-1:0]  sda_prev_rx_hold;
   wire [`IC_SDA_RX_HOLD_RS-1:0]  sda_prev_rx_hold_c;
   reg sda_post_hold_done; // SDA Value after internal Hold Done  
   // ------------------------------------------------------
   // -- Edge detection combo logic
   // ------------------------------------------------------
   // SCL EDGE DETECTS
   assign scl_edg_lh = scl_int &  (~scl_int_q);
   assign scl_edg_hl_int =  ~scl_int & scl_int_q;
   assign scl_edg_hl = scl_edg_hl_int;

   // SDA EDGE DETECTS
   assign sda_edg_lh = sda_int &  (~sda_int_q);
   assign sda_edg_hl =  ~sda_int & sda_int_q;

   // SCL DETECT AND FILTERING
  // assign scl_rise_vld = scl_edg_lh | (s_det_int &  (~stop_en));
  // assign scl_fall_vld = scl_edg_hl_int | p_det_int;

   // START AND STOP DETECT FILTER
   assign s_det_int = scl_int & sda_edg_hl &  (~scl_edg_lh);
   assign p_det_int = scl_int & sda_edg_lh;
   // ------------------------------------------------------
   // -- Master and slave ack detection
   //
   // -- check the ack status during the 9th bit period
   // ------------------------------------------------------
   //master tx  ack
   always @(posedge ic_clk or negedge ic_rst_n) begin:IC_MST_ACK_CYCLE_PROC
      if(ic_rst_n == 1'b0)
        begin
             ack_det     <= 1'b0;
        end
      else
        begin
           if((mst_tx_ack_vld == 1'b1)&&(scl_edg_lh == 1'b1))
             begin
                ack_det     <= ~sda_int;
             end
           else if (mst_tx_ack_vld == 1'b0)
             begin
                ack_det     <= 1'b0;
             end
        end
   end // block: IC_MST_ACK_CYCLE_PROC

   //slave tx  ack
   always @(posedge ic_clk or negedge ic_rst_n) begin:IC_SLV_ACK_PROC
      if(ic_rst_n == 1'b0)
        begin
           slv_ack_det <= 1'b0;
        end
      else
        begin
           if((sda_vld_int == 1'b1)&&(slv_tx_ack_vld == 1'b1))
             begin
                slv_ack_det     <= ~sda_int;
             end
           else if (scl_edg_hl_q == 1)
             begin
                slv_ack_det <= 1'b0;
             end
        end // else: !if(ic_rst_n == 1'b0)
   end // block: IC_SLV_ACK_PROC

   wire          async2icl_ic_clk_in_a;
   wire          sasync2icl_scl_sync; 
   assign async2icl_ic_clk_in_a = ic_clk_in_a;
   assign scl_sync = sasync2icl_scl_sync;
   // ------------------------------------------------------
   // -- ic_clk_in_a & ic_data_in_a synchronization to ic_clk
   //
   // -- Sync the i2c bus signals to internal ic_clk
   // ------------------------------------------------------
   // ic_clk_in_a synchronization
   kei_DW_apb_i2c_bcm41
    #(
     .RST_VAL     (1), 
     .F_SYNC_TYPE (`IC_SYNC_DEPTH),
     .VERIF_EN    (0)
   ) 
   U_DW_apb_i2c_bcm41_async2icl_ic_clk_in_a_icsyzr(
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (async2icl_ic_clk_in_a)
        ,.data_d              (sasync2icl_scl_sync)
      );

   wire          async2icl_ic_data_in_a;
   wire          sasync2icl_sda_sync; 
   assign async2icl_ic_data_in_a = ic_data_in_a;
   assign sda_sync = sasync2icl_sda_sync;
   // ic_data_in_a synchronization
   kei_DW_apb_i2c_bcm41
    #(
     .RST_VAL     (1),
     .F_SYNC_TYPE (`IC_SYNC_DEPTH),
     .VERIF_EN    (0)
   ) 
   U_DW_apb_i2c_bcm41_async2icl_ic_data_in_a_icsyzr(
         .clk_d               (ic_clk)
        ,.rst_d_n             (ic_rst_n)
        ,.data_s              (async2icl_ic_data_in_a)
        ,.data_d              (sasync2icl_sda_sync)
      );

   // ------------------------------------------------------
   // -- SDA & SCL Signals filtering
   //
   // -- filter the inputs from the i2c bus
   // ------------------------------------------------------

   // jduarte 20110105 begin
   // CRM 9000368180
   // Added register outputs for spike length, in ic_clk cycles
   // The value for FS and SS modes is the same (ic_fs_spklen)

   ////SCL filtering
   //always @(scl_sync or scl_sync_q or scl_sync_qq) begin:IC_SCL_FILTER_PROC
   //   scl_ored = {scl_sync,scl_sync_q,scl_sync_qq};
   //      case((scl_ored))
   //        3'b011 : begin
   //           scl_clk_int = 1'b1;
   //        end
   //        3'b101 : begin
   //           scl_clk_int = 1'b1;
   //        end
   //        3'b110 : begin
   //           scl_clk_int = 1'b1;
   //        end
   //        3'b111 : begin
   //           scl_clk_int = 1'b1;
   //        end
   //        default : begin
   //           scl_clk_int = 1'b0;
   //        end
   //      endcase
   //end // block: SCL_FILTER
   //
   //assign scl_int = scl_clk_int;
   //
   //
   ////SDA filtering
   //always @(sda_sync or sda_sync_q or sda_sync_qq) begin:IC_SDA_FILTER_PROC
   //   sda_ored = {sda_sync,sda_sync_q,sda_sync_qq};
   //      case((sda_ored))
   //        3'b000 : begin
   //           sda_data_int = 1'b0;
   //        end
   //        3'b001 : begin
   //           sda_data_int = 1'b0;
   //        end
   //        3'b010 : begin
   //           sda_data_int = 1'b0;
   //        end
   //        3'b100 : begin
   //           sda_data_int = 1'b0;
   //        end
   //        default : begin
   //           sda_data_int = 1'b1;
   //        end
   //      endcase
   //end
   //
   //assign sda_int = sda_data_int;

   // Generate speed mode signals
   reg ic_hs;
   reg ic_hs_r;
   wire ic_fs;
   wire ic_ss;

   // Detect that rx_hs_mcode has gone 1->0
   reg rx_hs_mcode_r;
   always @(posedge ic_clk or negedge ic_rst_n) begin : rx_hs_mcode_r_PROC
     if(~ic_rst_n) rx_hs_mcode_r <= 1'b0;
     else          rx_hs_mcode_r <= rx_hs_mcode;
   end // rx_hs_mcode_r_PROC
  
   wire rx_hs_mcode_fed;
   assign rx_hs_mcode_fed = rx_hs_mcode_r & (~rx_hs_mcode);

   // falling edge detect in hs_mcode_en
   reg hs_mcode_en_r;
   always @(posedge ic_clk or negedge ic_rst_n) begin : hs_mcode_en_r_PROC
     if(~ic_rst_n) hs_mcode_en_r <= 1'b0;
     else          hs_mcode_en_r <= hs_mcode_en;
   end // hs_mcode_en_r_PROC
  
   wire hs_mcode_en_fed;
   assign hs_mcode_en_fed = hs_mcode_en_r & (~hs_mcode_en);

   // Hold until STOP
   reg hs_mcode_fed_dtctd_r;
   always @(posedge ic_clk or negedge ic_rst_n) begin : hs_mcode_fed_dtctd_r_PROC
     if(~ic_rst_n) hs_mcode_fed_dtctd_r <= 1'b0;
     else begin
       // Set when falling edge occurs
       // clear when stop occurs
       // Switch between detected master and slave mode signals
       if(~hs_mcode_fed_dtctd_r)
         hs_mcode_fed_dtctd_r <= ic_master_sync ? hs_mcode_en_fed : rx_hs_mcode_fed;
       else  
         hs_mcode_fed_dtctd_r <= ~p_det_int;
     end
   end // hs_mcode_fed_dtctd_r_PROC

   //spyglass disable_block W415a
   //SMD: Signal may be multiply assigned (beside initialization) in the same scope
   //SJ : The signal ic_hs updated with the default values and then only if required
   //     the signal is updated, based on the required condition. This is done to 
   //     assign the default value during the else branches (if any). There is no 
   //     functional issue. Hence this can be waived.
   // Decode when to switch to HS glitch suppression. We must use FS/SS by
   // default until the bus events to switch to HS speed have occured.
   always @(*) begin : ic_hs_PROC
     ic_hs = ic_hs_r;

     // Switchh to HS speed glitch suppression
     // when SCL goes 0->1, and programmed for HS speed, and the
     // HS master code has been completed.
     // This will be at the first SCL posedge after the NACK 
     // for the HS master code i.e. time tH in the I2C protocol
     // spec (Fig.22 A complete Hs-mode transfer.)
     if(hs_mcode_fed_dtctd_r & scl_edg_lh & ic_hs_sync) ic_hs = 1'b1;
     if(p_det_int)                                       ic_hs = 1'b0;
   end // ic_hs_PROC
   //spyglass enable_block W415a

   always @(posedge ic_clk or negedge ic_rst_n) begin : ic_hs_r_PROC
     if(~ic_rst_n) begin
       ic_hs_r <= 1'b0;
     end else begin
       ic_hs_r <= ic_hs;
     end
   end // ic_hs_r_PROC

   // If programmed for HS speed, but the conditions to switch to HS speed
   // have not yet been met, use FS/SS glitch suppression.
   assign ic_fs = (ic_fs_sync 
                  | (ic_hs_sync & (~ic_hs_r))
                  );

   // Decode SS as not HS and not FS
   assign ic_ss = 
                 ~ic_hs_sync & 
                 (~ic_fs_sync);

   // Output the spike length that is currently being applied
   // Used by tx_shift block in implementation of SDA hold time
   assign ic_spklen_o = (ic_hs_r) ? ic_hs_spklen : ic_fs_spklen;

   //SCL filtering
   always@(posedge ic_clk or negedge ic_rst_n) begin : SCL_CLK_INT_PROC
      if(ic_rst_n == 1'b0) begin
        ic_scl_spklen_cnt <= {`IC_FS_SPKLEN_RS{1'b0}};
        scl_clk_int       <= 1'b1;
      end else begin
        if(scl_sync != scl_clk_int) begin
          if(
              ( (ic_hs_r         ) && (ic_scl_spklen_cnt < ic_hs_spklen) ) ||
              ( 
                (ic_fs || ic_ss) &&
                (ic_scl_spklen_cnt < ic_fs_spklen) ) ) begin
            ic_scl_spklen_cnt <= ic_scl_spklen_cnt + 1;
           end else begin
             scl_clk_int <= scl_sync;
             ic_scl_spklen_cnt <= {`IC_FS_SPKLEN_RS{1'b0}};
           end
         end else begin
             ic_scl_spklen_cnt <= {`IC_FS_SPKLEN_RS{1'b0}};
        end
      end
    end

   assign scl_int = (
                    ( (ic_hs_r         ) && (ic_scl_spklen_cnt == ic_hs_spklen) ) ||
                    ( 
                    (ic_fs || ic_ss) && 
                    (ic_scl_spklen_cnt == ic_fs_spklen) ) ) ? scl_sync : scl_clk_int;

   // Detect when an SCL spike has been rejected
   wire scl_spike_rejected;
   assign scl_spike_rejected =   (scl_sync == scl_clk_int) 
                               & (ic_scl_spklen_cnt != {`IC_FS_SPKLEN_RS{1'b0}});

   // Reset SDA spike rejection counter if an SCL spike is rejected
   // while scl_clk_int == 1. To avoid missampling a START or STOP when
   // a glitch on SCL extends internally sampled SCL high time until
   // after a transition in SDA (which could come from this master)
   // This could most likely happen after a negedge of SCL, when it
   // glitches high again.
   wire reset_sda_spk_cntr;
   assign reset_sda_spk_cntr = scl_spike_rejected & scl_clk_int;

   //SDA filtering
   always@(posedge ic_clk or negedge ic_rst_n) begin : SDA_DATA_INT_PROC
      if(ic_rst_n == 1'b0) begin
        ic_sda_spklen_cnt <= {`IC_FS_SPKLEN_RS{1'b0}};
        sda_data_int      <= 1'b1;
      end else begin
        if((sda_sync != sda_data_int) & (~reset_sda_spk_cntr)) begin
          if (
              ( (ic_hs_r         ) && (ic_sda_spklen_cnt < ic_hs_spklen) ) ||
              ( 
               (ic_fs || ic_ss) &&
               (ic_sda_spklen_cnt < ic_fs_spklen) ) ) begin
            ic_sda_spklen_cnt <= ic_sda_spklen_cnt + 1;
           end else begin
             sda_data_int <= sda_sync;
             ic_sda_spklen_cnt <= {`IC_FS_SPKLEN_RS{1'b0}};
           end
         end else begin
             ic_sda_spklen_cnt <= {`IC_FS_SPKLEN_RS{1'b0}};
        end
      end
    end

   assign sda_post_spk_suppression = (
                    ( (ic_hs_r         ) && (ic_sda_spklen_cnt == ic_hs_spklen) ) ||
                    ( 
                    (ic_fs || ic_ss) && 
                    (ic_sda_spklen_cnt == ic_fs_spklen) ) ) && (~reset_sda_spk_cntr) ? sda_sync : sda_data_int;

  //spyglass disable_block SelfDeterminedExpr-ML
  //SMD: Self determined expression present in the design.
  //SJ:  This Self Determined Expression is as per the design requirement. 
  //     There will not be any functional issue.
  //--------------------------------------------------------
  //    SDA HOLD time implementation
  //  As a Master or Slave while acting as reciever I2C should hold SDA 
  //  line internally (for 300ns for FS and SS according to I2C spec), which will be programmed by using input register 
  //  ic_sda_rx_hold_sync in terms of ic_clk cycles
  //  This logic only comes in picture whenever SCL line (scl_int) is HIGH
  //---------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) 
   begin : sda_rx_hold_count_r_PROC
     if(~ic_rst_n) begin
       ic_sda_rx_hold_cnt <= {`IC_SDA_RX_HOLD_RS{1'b0}};
     end else begin
       if (scl_int && (sda_post_spk_suppression != sda_post_hold_done )) 
            begin
             if((sda_prev_rx_hold > 8'b0) && (ic_sda_rx_hold_cnt < (sda_prev_rx_hold-{{(`IC_SDA_RX_HOLD_RS-1){1'b0}},1'b1}))) 
       begin
             ic_sda_rx_hold_cnt <= ic_sda_rx_hold_cnt + {{(`IC_SDA_RX_HOLD_RS-1){1'b0}},1'b1};
          end
             end 
      else begin
              ic_sda_rx_hold_cnt <= {`IC_SDA_RX_HOLD_RS{1'b0}};
            end
       end
   end // sda_rx_hold_count_r_PROC
  //spyglass enable_block SelfDeterminedExpr-ML

  //spyglass disable_block SelfDeterminedExpr-ML
  //SMD: Self determined expression present in the design.
  //SJ:  This Self Determined Expression is as per the design requirement. 
  //     There will not be any functional issue.
  assign ic_sda_rx_hold_done = (ic_sda_rx_hold_cnt == (sda_prev_rx_hold-{{(`IC_SDA_RX_HOLD_RS-1){1'b0}},1'b1})) || (~scl_int) || (p_det_int);
  //spyglass enable_block SelfDeterminedExpr-ML
  assign sda_prev_rx_hold_c = sda_prev_rx_hold;

// logic to assign post spike suppressed SDA to post hold done register 
// whenever ic_sda_rx_hold_done is asserted
   always @(posedge ic_clk or negedge ic_rst_n) 
   begin : sda_rx_post_hold_PROC
     if(~ic_rst_n) begin
      sda_post_hold_done <= 1'b1;
     end
     else begin
     if (ic_sda_rx_hold_done)
        begin
        sda_post_hold_done <= sda_post_spk_suppression;
        end
     end
    end

  //--------------------------------------------------------------------
  //--IC_PREV_SDA_RX_HOLD Register
  //-- This Register holds the previous value of RX_HOLD programmed
  //-- to avoid the consideration of changed value while RX Hold counter
  //-- is running with the previous value
  //---------------------------------------------------------------------
  always @(posedge ic_clk or negedge ic_rst_n) begin : PREV_SDA_RX_HOLD_PROC
    if(!ic_rst_n)
      sda_prev_rx_hold <= {(`IC_SDA_RX_HOLD_RS){1'b0}};
    else begin
       if (sda_post_spk_suppression == sda_post_hold_done )
        sda_prev_rx_hold <= ic_sda_rx_hold_sync;
      else
        sda_prev_rx_hold <= sda_prev_rx_hold_c;
    end
  end

  //If ic_sda_rx_hold_sync==0 then assign sda_post_spk_suppression directly to sda_int
  //otherwise assign  sda_post_hold_done only when SCL is HIGH i.e. scl_int is HIGH
  //when scl_int is LOW assign sda_post_spk_suppression
    assign sda_int = (sda_prev_rx_hold==8'b0) ? sda_post_spk_suppression : (scl_int  ? sda_post_hold_done : sda_post_spk_suppression);

   // jduarte 20110105 end
   // ------------------------------------------------------
   // -- slv_tx_shift_en generation
   //
   // -- This signal indicates that SCL line has dropped form
   // -- High to low and enable the slave to set the sda line
   // -- to the required value to be transmitted
   // ------------------------------------------------------
   always @(
          ic_fs_sync or scl_low_vld or scl_is_low_qq 
         or ic_hs_sync
         or
         scl_edg_hl_int) begin:IC_TX_SHIFT_PROC
      if((ic_fs_sync == 1'b1) 
          || (ic_hs_sync == 1'b1)
          ) begin
         slv_tx_shift_en = (scl_low_vld == 1'b1) && ( scl_is_low_qq == 1'b0);
      end
      else //if standard mode ( ic_ss_sync == 1'b1)
        slv_tx_shift_en = scl_edg_hl_int;
   end




   // ------------------------------------------------------
   // -- slv_low_vld generation
   //
   // -- This signal indicates that SCL
   // -- line is at a valid low level
   // ------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n)begin:IC_SCL_IS_LOW_PROC
     if(ic_rst_n == 1'b0)
       scl_is_low_q <= 1'b0;
     else
       if((scl_edg_hl_int == 1'b1))
         scl_is_low_q <= 1'b1;

       else if((scl_edg_lh == 1'b1))
          scl_is_low_q <= 1'b0;
   end

   // 1 CLOCK DELAY of scl_is_low_q
   always @(posedge ic_clk or negedge ic_rst_n) begin:IC_SCL_LOW_PROC
      if(ic_rst_n == 1'b0)
        begin
           scl_is_low_qq <= 1'b0;
        end
      else
        begin
           scl_is_low_qq <= scl_is_low_q;
        end
   end

//#
//# PG
//#
//# Removed scl_low_q from the statement
//#
   //scl_low_vld generation
   always @(
       ic_hs_sync or
       ic_fs_sync or scl_is_low_q or scl_edg_hl_int or scl_edg_lh) begin:IC_LVLD_GEN_PROC
      if((ic_fs_sync == 1'b1) 
          || (ic_hs_sync == 1'b1)
          ) begin
         scl_low_vld = scl_is_low_q;
      end
      else if((scl_edg_lh == 1'b1)) begin
         scl_low_vld = 1'b0;
      end
      else begin
         scl_low_vld = scl_is_low_q | scl_edg_hl_int;
      end
   end
   // ------------------------------------------------------
   // -- sda_vld generation
   //
   // -- Indicates sda level is valid for sampling internally
   // ------------------------------------------------------
   assign sda_vld = sda_vld_int;

//#
//# PG
//#
//# removed sclK_int == 1'b1 from check
//#
   // SDA Valid detection
   always @(posedge ic_clk or negedge ic_rst_n) begin:IC_SDAVLD_DET_PROC
     if(ic_rst_n == 1'b0)
       begin
          sda_cnt <= 2'b11;
          sda_vld_int <= 1'b0;
       end
     else
       begin

          if((scl_int == 1'b0))
            sda_cnt <= 2'b00;
          else if((sda_cnt != 2'b11))
            sda_cnt <= sda_cnt + 2'b01;
          if(sda_cnt == 2'b10)//wait for three clocks in ic_hs_sync or ic_fs_sync mode before sampling sda
            sda_vld_int <= 1'b1;
          else
            sda_vld_int <= 1'b0;

       end // else: !if(ic_rst_n == 1'b0)
   end
   // ------------------------------------------------------
   // -- arb_lost signal generation
   //
   // -- arbitration lost detection circuit
   // ------------------------------------------------------

// ---------------------------------------------------------------------------
//#
//# PG
//#
//# Created the start_stop_mstactivity
//# Made start_stop_mstactivity == 1'b0 higher priority
//#
//
// Generate a signal to indicate when the I2C (as a Master) encounters
// collisions on the bus, forcing it to lose arbitration and release control
// to the other I2C Master.
//
// Performed on rising edge of the bus' SCL clock line, since the I2C setup
// time requirement will guarantee a stable SDA line.
//
// During Master-transmits, make sure this check is NOT done during the
// ACK bit, since this is NOT driven by the Master.
// During Master-receives, make sure this check is performed during the
// ACK bit, since this is driven by the Master.
//
// If a START condition ("s_det") occurs when "start_stop_mstactivity"
// is asserted, then it means that ANOTHER Master has begun transmission
// when this Master is transmitting. Since the current transmission is
// corrupted, arbitration is pointless.
// If a STOP condition occurs when "start_stop_mstactivity@ is asserted,
// then it means t[HD;DAT] is violated, and data corruption will also
// have occured.
// In both cases, there is no point continuing data transfer or arbitrating.
//
// In using the "re_start_en" and "split_start_en" signals, compensate for
// the 4 clock cycle delay for the SDA used for the arbitration detection.
// ---------------------------------------------------------------------------
   assign start_stop_mstactivity = ((start_en == 1'b0) && (stop_en == 1'b0) && (mst_activity == 1'b1));

   assign ack_bit_activity = ((mst_tx_en==1'b1 && mst_tx_ack_vld==1'b0) 
                             ) ||
                             (mst_rx_en==1'b1 && mst_rx_ack_vld==1'b1);

  reg [3:0] delay_re_start_en_or_split_start_en;
  wire      restart_splitstart;
  assign restart_splitstart = |delay_re_start_en_or_split_start_en;

  always @(posedge ic_clk or negedge ic_rst_n) begin : DELAY_RESTART_SPLIT_PROC
    if(!ic_rst_n)
      delay_re_start_en_or_split_start_en <= 4'h0;
    else begin
      delay_re_start_en_or_split_start_en[3:1] <= delay_re_start_en_or_split_start_en[2:0];
      delay_re_start_en_or_split_start_en[0]   <= re_start_en | split_start_en;
    end
  end // always

   always @(posedge ic_clk or negedge ic_rst_n) begin:IC_DET_MST_ARB_LOST_PROC
      if(ic_rst_n == 1'b0) begin
           mst_arb_lost <= 1'b0;
      end else begin
      // Signal assigned more than once on a single flow of control
        if((s_det || p_det) && start_stop_mstactivity && (!restart_splitstart))
   begin
          mst_arb_lost <= 1'b1;
   end else begin
          if (scl_edg_lh == 1'b1) begin
            if (start_stop_mstactivity == 1'b0)
              mst_arb_lost <= 1'b0;
            else
              mst_arb_lost <= (ack_bit_activity && (~ic_data_oe != sda_int))
                         ? 1'b1 : 1'b0;
          end else begin
            if (mst_activity == 1'b0)
              mst_arb_lost <= 1'b0;
          end
        end

        //if((s_det || p_det) && start_stop_mstactivity && !restart_splitstart)
          //mst_arb_lost <= 1'b1;
      end // else ic_rst_n
   end // always


//#
//# PG
//#
//# Made slv_activity == 1'b0 higher priority
//#
   always @(posedge ic_clk or negedge ic_rst_n) begin:IC_DET_SLV_ARB_LOST_PROC
      if(ic_rst_n == 1'b0)
        begin
           slv_arb_lost <= 1'b0;
        end else
          if (scl_edg_lh == 1'b1)
            if (slv_activity == 1'b0)
              slv_arb_lost <= 1'b0;
            else
              slv_arb_lost <= ((slv_tx_en == 1'b1) &&
                               (slv_tx_ack_vld == 1'b0) &&
                               (~ic_data_oe != sda_int)) ? 1'b1 : 1'b0;
          else if (slv_activity == 1'b0)
            slv_arb_lost <= 1'b0;
   end

   assign arb_lost =  mst_arb_lost | slv_arb_lost;
   // ------------------------------------------------------
   // -- 1 ic_clk period delay for some signals
   // ------------------------------------------------------
   always @(posedge ic_clk or negedge ic_rst_n) begin:IC_1DELAY_PROC
     if(ic_rst_n == 1'b0)
        begin
           s_det <= 1'b0;
           p_det <= 1'b0;
           p_det_intr <= 1'b0;
           scl_int_q <= 1'b1;
           sda_int_q <= 1'b1;
           scl_edg_hl_q <= 1'b0;
        end
     else
       begin
          scl_int_q <= scl_int;
          sda_int_q <= sda_int;
          scl_edg_hl_q <= scl_edg_hl_int;
          s_det <= s_det_int;
          p_det <= p_det_int;
          if(~ic_master_sync & p_det_ifaddr_sync)
            p_det_intr <= (slv_addressed) ? p_det_int : 1'b0;
          else begin
            p_det_intr <= p_det_int;
          end
       end // else: !if(ic_rst_n == 1'b0)
   end // block: IC_1DELAY_PROC

   

endmodule // DW_apb_i2c_rx_filter




















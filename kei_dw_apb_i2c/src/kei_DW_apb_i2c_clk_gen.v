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
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_clk_gen.v#18 $ 
//
//
// File    : DW_apb_i2c_clk_gen.v
//
//
// Author  : Hani Saleh
// Created : Sep, 2002
// Abstract: This module is used to calculate the required timing and
//           to create the SCL clock when configured as MASTER mode.
//           This module will also calculate the timing required for 
//           bus idle signal, START and STOP conditions.
//
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------

module kei_DW_apb_i2c_clk_gen
  (
   //top level signals
   ic_clk,
                            ic_rst_n,
                            //rx_filter signals
                            sda_int,
                            scl_int,
                            s_det,
                            p_det,
                            //inputs from regfile
                            ic_hcnt,
                            ic_lcnt,
                            ic_fs_lcnt,
                            ic_fs_hcnt,
                            ic_hs_sync,
                            ic_fs_sync,
                            ic_ss_sync,
                            //rx_shift_reg signals
                            hs_mcode_en,
                            scl_lcnt_en,
                            rx_scl_lcnt_en,
                            scl_hcnt_en,
                            rx_scl_hcnt_en,
                            scl_s_hld_en,
                            scl_s_setup_en,
                            scl_p_setup_en,
                            //mstfsm signals
                            ic_enable_sync,
                            ic_master_sync,
                            ic_fs_spklen,
                            ic_bus_idle,   
                            min_hld_cmplt,
                            //outputs to tx/rx shift registers
                            scl_lcnt_cmplt,
                            scl_hcnt_cmplt,
                            scl_s_hld_cmplt,
                            scl_s_setup_cmplt,
                            scl_p_setup_cmplt
                            );

   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------
   // INPUTS
   input ic_clk; // processor clock
   input ic_rst_n; // asynchronous reset, active low
   input [`IC_HS_HCNT_RS-1:0] ic_hcnt;//Holds the high count of the active mode
   // ic_hcnt defines number of 
   // ic_clks to count for a valid high time
   // of SCL clock
   input [`IC_HS_LCNT_RS-1:0] ic_lcnt;//Holds the low count of the active mode
   // ic_lcnt defines number of
   // ic_clks to count for a valid low time
   // of SCL clock
   input [`IC_FS_LCNT_RS-1:0] ic_fs_lcnt;//Fast Speed mode low count register value
   input [`IC_FS_HCNT_RS-1:0] ic_fs_hcnt;//Fast Speed mode high count register value
   input                       ic_hs_sync;//IC is in High speed mode
   input                       ic_fs_sync;//IC is in Fast Speed mode
   input                       ic_ss_sync;//IC is in Standard speed mode
   input                       sda_int;//The filtered value detected on SDA bus line
   input                       scl_int;//The filtered value detected on SCL bus line
   input                       s_det;//Start has been detected on the bus
   input                       p_det;//Stop has been detected on the bus
   input                       ic_enable_sync;//IC module enable status (sync to ic_clk)
   input                       hs_mcode_en;//Enablle HS mode Mcode tx phase (Use FS timing in HS)
   input                       scl_lcnt_en;//Master TX low period counter enable
   input                       rx_scl_lcnt_en;//Master RX low period counter enable
   input                       scl_hcnt_en;//Master TX high period counter enable
   input                       rx_scl_hcnt_en;//Master RX high period counter enable
   input                       scl_s_hld_en;//Enable Start condition hold time counter
   input                       scl_s_setup_en;//Enable Start condition setup time counter
   input                       scl_p_setup_en;//Enable Stop condition hold time counter
   input                       ic_master_sync;    //logic 1: IC module is a Master 
   

   input [`IC_FS_SPKLEN_RS-1:0]  ic_fs_spklen;


   //OUTPUTS
   output                       scl_lcnt_cmplt;//low count period has elapsed
   output                       scl_hcnt_cmplt;//high count period has elapsed
   output                       scl_s_hld_cmplt;//start hold time period has elapsed
   output                       scl_s_setup_cmplt;//start setup period has elapsed
   output                       scl_p_setup_cmplt;//stop setup period has elapsed
   output                       min_hld_cmplt;//Scl has been pulled low and the
                                              // Minimum hold time to genearte 
                                              // start conditionhas elapsed
   output                       ic_bus_idle;//logic 1:The I2C bus is idle



   // ----------------------------------------------------------
   // -- local registers and wires
   // ----------------------------------------------------------
   //registers
   reg [`IC_HS_HCNT_RS-1:0] bus_idle_cntr;
   reg                      ic_bus_idle;
   reg [`IC_HS_LCNT_RS-1:0] clkgen_lcnt;
   reg [`IC_HS_HCNT_RS-1:0] clkgen_hcnt;
   reg [`IC_HS_HCNT_RS-1:0] scl_low_cntr ;
   reg [`IC_HS_HCNT_RS-1:0] scl_high_cntr ;
   reg [`IC_HS_HCNT_RS-1:0] scl_s_hld_cntr ;
   reg [`IC_HS_HCNT_RS-1:0] scl_s_setup_cntr ;
   reg [`IC_HS_HCNT_RS-1:0] scl_p_setup_cntr ;
   reg [`IC_HS_HCNT_RS-1:0] min_hld_cntr;
   reg                      min_hld_cmplt_int;
   reg                      scl_lcnt_cmplt ;
   reg                      scl_hcnt_cmplt_int ;
   reg                      scl_int_d ;
   reg                      scl_hcnt_cmplt_d1_r;
   reg                      scl_s_hld_cmplt_int ;
   reg                      scl_s_setup_cmplt ;
   reg                      scl_p_setup_cmplt ;
   reg                      count_en;
   //wires
   wire                     comb_scl_lcnt_en;
   wire                     comb_scl_hcnt_en;
   wire                     scl_hcnt_cmplt ;
   wire [`IC_SS_LCNT_RS-1:0] idle_count;
   wire [`IC_HS_HCNT_RS-1:0] bus_idle_next;
   wire [`IC_HS_LCNT_RS-1:0] low_cnt_limit;
   wire [`IC_HS_HCNT_RS-1:0] high_cnt_limit;
   wire [`IC_HS_HCNT_RS-1:0] high_cnt_plus_latency;
   wire [`IC_HS_HCNT_RS-1:0] scl_low_next;
   wire [`IC_HS_HCNT_RS-1:0] scl_high_next;
   wire [`IC_HS_LCNT_RS-1:0] hs_low_limit;
   wire [`IC_HS_HCNT_RS-1:0] hld_lo_lmt;
   wire [`IC_HS_HCNT_RS-1:0] half_clkgen;
   wire [`IC_HS_HCNT_RS-1:0] hld_hs_lo_lmt;
   wire                      not_hs_timing;
   wire                      cap_load_100;
   wire                      cap_load_400;
   wire [`IC_HS_HCNT_RS-1:0] scl_s_hld_next;
   wire [`IC_HS_HCNT_RS-1:0] scl_s_setup_next;
   wire [`IC_HS_HCNT_RS-1:0] scl_p_setup_next;
   wire [`IC_HS_HCNT_RS-1:0] min_hld_next;
   wire                      scl_s_hld_cmplt;
   wire                      min_hld_cmplt;
   wire                      min_hld_cntr_en;


   
   // ----------------------------------------------------------
   // -- ic_bus_idle signal generation
   //
   // -- Determines if the I2C bus is idle
   // -- This procedure is used to calculate tBUF (I2C specs)
   // ----------------------------------------------------------

   // Idle count generation for Standard Speed
   //tBuf timing is taken from IC_SS_SCL_LCNT in standard mode.
   // IC_FS_SCL_HCNT from Fastspeed and High speed mode.  
   // Since High speed starts from Fastspeed, tBuf should consider IC_FS_SCL_HCNT in High Speed mode.
   assign idle_count = (ic_ss_sync ? (ic_lcnt + {{(`IC_HS_LCNT_RS-1){1'b0}},1'b1}) : (ic_fs_lcnt + {{(`IC_FS_LCNT_RS-1){1'b0}},1'b1})); 
//`ifdef IC_HIGHSPEED_MODE_EN
//        ic_hs_sync ?  (ic_hs_hcnt < `IC_HS_SCL_LOW_COUNT) ? `IC_HS_SCL_LOW_COUNT : ( ic_hs_hcnt + ic_hs_spklen + 6) :
//`endif 
//                      ic_fs_sync ?  (ic_fs_hcnt < `IC_FS_SCL_LOW_COUNT) ? `IC_FS_SCL_LOW_COUNT : ( ic_fs_hcnt + ic_fs_spklen + 6) :
//                                    (ic_ss_hcnt < `IC_SS_SCL_LOW_COUNT) ? `IC_SS_SCL_LOW_COUNT : ( ic_ss_hcnt + ic_fs_spklen + 6) ;



   always @(posedge ic_clk or negedge ic_rst_n) begin : BUS_IDLE_PROC
      if(ic_rst_n == 1'b0) begin
         ic_bus_idle <= 1'b0;
         count_en <= 1'b1;
      end else 
        begin
           ic_bus_idle <= ((ic_enable_sync == 1'b1) && (
                          (bus_idle_cntr >= idle_count)
                          )) ? 1'b1 : 1'b0;

           if(s_det == 1'b1) begin
             count_en <=  1'b0;
           end
           else if (p_det == 1'b1)
             count_en <= 1'b1;
        end
   end // block: BUS_FREE_PROC

  // ============================================================
  // Counter for determining when the bus is idle
  // 
  // If SCL goes to "0" at any time, this counter will be reset.
  // ============================================================
   assign bus_idle_next = bus_idle_cntr + {{(`IC_HS_HCNT_RS-1){1'b0}} , 1'b1};

  always @(posedge ic_clk or negedge ic_rst_n) begin : BUS_IDLE_CNTR_PROC
    if(ic_rst_n == 1'b0) begin
      bus_idle_cntr <= {`IC_HS_HCNT_RS{1'b0}};
    end else begin
         
      if((ic_enable_sync == 1'b0) || (s_det == 1'b1) 
            || sda_int==1'd0 || scl_int==1'd0
        ) begin
        bus_idle_cntr <= {`IC_HS_HCNT_RS{1'b0}};
      end else begin
        bus_idle_cntr <= ((bus_idle_cntr < idle_count) && (count_en == 1'b1)) 
                         ? bus_idle_next : bus_idle_cntr;
      end
    end // else: !if(ic_rst_n == 1'b0)
  end // block: BUS_IDLE_CNTR_PROC

   
   // ----------------------------------------------------------
   // -- clkgen_lcnt & clkgen_hcnt calculation
   //
   // -- Calculate the required low period for scl_clk output
   // -- depending on the mode of operation
   // ----------------------------------------------------------
   always @(*)
     begin: CLKGEN_CNT_PROC
        if ((ic_ss_sync == 1'b1) 
            || (ic_fs_sync == 1'b1)
            )
          begin
             clkgen_lcnt = ic_lcnt;
             clkgen_hcnt = ic_hcnt;
          end
        else//ic_hs_sync == 1
          begin
             clkgen_lcnt = (hs_mcode_en == 1'b1) ? ic_fs_lcnt : ic_lcnt;
             clkgen_hcnt = (hs_mcode_en == 1'b1) ? ic_fs_hcnt : ic_hcnt;
          end
     end
   // ----------------------------------------------------------
   // -- scl low period calculation
   //
   // -- Calculate the required low period for scl_clk output
   // -- This procedure is used to calculate tLOW (I2C specs)
   // ----------------------------------------------------------

   assign low_cnt_limit = clkgen_lcnt - 1;
   assign high_cnt_limit = clkgen_hcnt - 1;
   assign high_cnt_plus_latency = high_cnt_limit + {{(`IC_HS_HCNT_RS-`IC_FS_SPKLEN_RS){1'b0}},ic_fs_spklen} + {{(`IC_HS_HCNT_RS-3){1'b0}},3'h7}; 
   assign scl_low_next = scl_low_cntr + 1;   
   assign comb_scl_lcnt_en = scl_lcnt_en 
                             | rx_scl_lcnt_en
                            ;

   always @(posedge ic_clk or negedge ic_rst_n) begin : SCL_LOW_COUNT_PROC
      if(ic_rst_n == 1'b0) begin
         scl_lcnt_cmplt <= 1'b0;
         scl_low_cntr <= {`IC_HS_HCNT_RS{1'b0}};
         
      end else begin
         if(comb_scl_lcnt_en == 1'b0)
           begin
              scl_lcnt_cmplt<= 1'b0;
              scl_low_cntr <= {`IC_HS_HCNT_RS{1'b0}};
           end
         else if (scl_low_cntr < low_cnt_limit)
           begin
              scl_low_cntr <= scl_low_next;
              
           end
            else if (scl_low_cntr >= low_cnt_limit)
              begin
                 scl_lcnt_cmplt <= 1'b1;
              end
      end
   end // block: SCL_LOW_COUNT_PROC

 
   // ----------------------------------------------------------
   // -- scl high period calculation
   //
   // -- Calculate the required high period for scl_clk output
   // -- This procedure is used to calculate tHIGH (I2C specs)
   // ----------------------------------------------------------
   assign scl_high_next = scl_high_cntr + 1;
   assign comb_scl_hcnt_en = scl_hcnt_en 
                             | rx_scl_hcnt_en
                         ;

   always @(posedge ic_clk or negedge ic_rst_n) begin : SCL_HIGH_COUNT_PROC
      if(ic_rst_n == 1'b0) begin
         scl_hcnt_cmplt_int <= 1'b0;
         scl_high_cntr <= {`IC_HS_HCNT_RS{1'b0}};
         
      end else begin
         if(comb_scl_hcnt_en == 1'b0)
           begin
              scl_hcnt_cmplt_int<= 1'b0;
              scl_high_cntr <= {`IC_HS_HCNT_RS{1'b0}};
           end
         else if (scl_high_cntr < high_cnt_limit)
           begin
              scl_high_cntr <= scl_high_next;
              
           end
            else if (scl_high_cntr >= high_cnt_limit)
              begin
                 scl_hcnt_cmplt_int <= 1'b1;
              end
      end
   end // block: SCL_HIGH_COUNT_PROC

   always @(posedge ic_clk or negedge ic_rst_n) begin : SCL_HCNT_CMPLT_D1_PROC
     if(ic_rst_n == 1'b0) begin
       scl_hcnt_cmplt_d1_r <= 1'b0;
     end else begin
        scl_hcnt_cmplt_d1_r <= scl_hcnt_cmplt;
     end
   end



   // ------------------------------------------------------------------
   // -- 1- clock delayed version of scl_int signal
   //
   // -- Delayed scl_int signal is used to de-assert the scl high counter
   // -- when the other master pulls the SCL line before completes its
   // -- HIGH period during the ACK Phase. (sec 8.1 Synchronization of I2C Spec)
   // ------------------------------------------------------------------
    always @(posedge ic_clk or negedge ic_rst_n) begin : SCL_INT_DELAYED_PROC
      if(ic_rst_n == 1'b0) begin
        scl_int_d <= 1'b0;
      end else begin
        scl_int_d <= scl_int;
      end
   end // block: SCL_INT_DELAYED_PROC

   // ------------------------------------------------------------------------
   // -- SCL High count completion signal
   // 
   // -- Generate the high count completion signal either pre-maturely when
   // -- other master pulls the SCL line before completes its high period or
   // -- once thw high count period counter expires.
   // --------------------------------------------------------------------------
   assign scl_hcnt_cmplt = (scl_hcnt_cmplt_int 
                            || (~scl_int && scl_int_d && comb_scl_hcnt_en) || (scl_lcnt_cmplt && scl_hcnt_cmplt_d1_r)
                            );

   
   // ----------------------------------------------------------
   // -- scl Start hold time calculation
   //
   // -- Calculate the required shld period for scl_clk output
   // -- This procedure is used to calculate tHD;STA (I2C specs)
   // ----------------------------------------------------------
   assign scl_s_hld_next = scl_s_hld_cntr + 1;
   
   assign hs_low_limit = ((clkgen_lcnt>>1) - 1);
   assign not_hs_timing = ((ic_ss_sync == 1'b1)||(ic_fs_sync == 1'b1) || (hs_mcode_en == 1'b1));
   assign cap_load_100 = (hs_mcode_en == 1'b0) && (ic_hs_sync== 1'b1) && (`IC_CAP_LOADING == 100);
   assign cap_load_400 = (hs_mcode_en == 1'b0) && (ic_hs_sync== 1'b1) && (`IC_CAP_LOADING == 400);
   
   always @(posedge ic_clk or negedge ic_rst_n) begin : SCL_S_HLD_COUNT_PROC
      if(ic_rst_n == 1'b0) begin
         scl_s_hld_cmplt_int <= 1'b0;
         scl_s_hld_cntr <= {`IC_HS_HCNT_RS{1'b0}};
         
      end else begin
         if(scl_s_hld_en == 1'b0)
           begin
              scl_s_hld_cmplt_int <= 1'b0;
              scl_s_hld_cntr <= {`IC_HS_HCNT_RS{1'b0}};
           end
         else if (( 
                   not_hs_timing &&
                 (scl_s_hld_cntr < high_cnt_plus_latency))
                  ||
                  ( cap_load_100 && (scl_s_hld_cntr < low_cnt_limit))
                  ||
                  ( cap_load_400 && (scl_s_hld_cntr < hs_low_limit ))
              )
                  
           begin
              scl_s_hld_cntr <= scl_s_hld_next;
              
           end
         else 
           begin
              scl_s_hld_cmplt_int <= 1'b1;       
           end
      end
   end // block: SCL_S_HLD_COUNT_PROC
   
   // ------------------------------------------------------------------------
   // -- SCL Start/Restart Hold completion signal
   // 
   // -- Generate the Start/Restart Hold completion signal either pre-maturely when
   // -- other master pulls the SCL line before completes its Start/Restart Hold period or
   // -- once the Start/Restart count period counter expires.
   // --------------------------------------------------------------------------
   assign scl_s_hld_cmplt = (scl_s_hld_cmplt_int 
                             || (~scl_int && scl_int_d && scl_s_hld_en)
                             );


   // ----------------------------------------------------------
   // -- Minumum hold time calculation
   //
   // -- Calculate the required shld period for scl_clk output
   // -- This procedure is used to calculate tHD;STA (I2C specs)
   // ----------------------------------------------------------
   //assign hld_lo_lmt  = (clkgen_lcnt > 6 ) ? (clkgen_lcnt - 6) : 1;
   assign hld_lo_lmt  = clkgen_lcnt;
   //assign hld_hi_lmt  = (clkgen_hcnt > 6 ) ? (clkgen_hcnt - 6) : 1;
   //assign hld_hi_lmt  = clkgen_hcnt;
   assign half_clkgen = (clkgen_lcnt>>1);
   //assign hld_hs_lo_lmt = (half_clkgen > 6 ) ? (half_clkgen - 6) : 1;
   assign hld_hs_lo_lmt = half_clkgen;
   assign min_hld_next = min_hld_cntr + 1;
   
   always @(posedge ic_clk or negedge ic_rst_n) begin : MIN_HLD_COUNT_PROC
      if(ic_rst_n == 1'b0) begin
         min_hld_cmplt_int <= 1'b0;
         min_hld_cntr <= {`IC_HS_HCNT_RS{1'b0}};
         
      end else begin
         //if ((scl_int == 1'b1) || (ic_enable_sync == 1'b0) || (ic_master_sync == 1'b0))
         if ((sda_int == 1'b1) || (ic_enable_sync == 1'b0) || (ic_master_sync == 1'b0) || (p_det ==1'b1))
           begin
              min_hld_cmplt_int <= 1'b0;
              min_hld_cntr <= {`IC_HS_HCNT_RS{1'b0}};
           end
         else 
              if (( 
                  not_hs_timing && 
                  (min_hld_cntr < high_cnt_plus_latency)) 
                  ||
                  ( cap_load_100 && (min_hld_cntr < hld_lo_lmt))
                  ||
                  ( cap_load_400 && (min_hld_cntr < hld_hs_lo_lmt ))
              )
                  
                begin
                   min_hld_cntr <= min_hld_next;
                end
              else 
                begin
                   min_hld_cmplt_int <= 1'b1;       
                end // else: !if(( not_hs_timing && (min_hld_cntr < hld_hi_lmt))...
      end
   end // block: MIN_HLD_COUNT_PROC

   // ------------------------------------------------------------------------
   // -- SCL Start/Restart Minimum Hold completion signal
   // 
   // -- Generate the Start/Restart Minimum Hold completion signal either pre-maturely when
   // -- other master pulls the SCL line before completes its Start/Restart Hold minimum period or
   // -- once the Start/Restart Minimum count period counter expires.
   // --------------------------------------------------------------------------
   assign min_hld_cntr_en = (~(sda_int || (~ic_enable_sync) || (~ic_master_sync) || p_det));
   assign min_hld_cmplt = (min_hld_cmplt_int || (~scl_int && scl_int_d && min_hld_cntr_en));

   
   // ----------------------------------------------------------
   // -- scl Start setup time calculation
   //
   // -- Calculate the required shld period for scl_clk output
   // -- This procedure is used to calculate tSU;STA (I2C specs)
   // ----------------------------------------------------------
   assign scl_s_setup_next = scl_s_setup_cntr + 1;
   
   always @(posedge ic_clk or negedge ic_rst_n) begin : SCL_S_SETUP_COUNT_PROC
      if(ic_rst_n == 1'b0) begin
         scl_s_setup_cmplt <= 1'b0;
         scl_s_setup_cntr <= {`IC_HS_HCNT_RS{1'b0}};
         
      end else begin
         if(scl_s_setup_en == 1'b0)
           begin
              scl_s_setup_cmplt<= 1'b0;
              scl_s_setup_cntr <= {`IC_HS_HCNT_RS{1'b0}};
           end
         
         else if ((((ic_ss_sync == 1'b1) && 
                   (scl_s_setup_cntr < low_cnt_limit)) 
                  ||
                  (((ic_fs_sync == 1'b1) 
                  || (hs_mcode_en == 1'b1)
                  ) && (scl_s_setup_cntr < high_cnt_plus_latency)) 
                  ||
                  (cap_load_100 && (scl_s_setup_cntr < low_cnt_limit)) 
                  ||
                  (cap_load_400 && (scl_s_setup_cntr < hs_low_limit))
              ) 
              && (sda_int == 1'b1)
              )
           
           begin
              scl_s_setup_cntr <= scl_s_setup_next;
              
           end
         else
           begin
              scl_s_setup_cmplt <= 1'b1;
           end

      end
   end // block: SCL_S_SETUP_COUNT_PROC

   // ----------------------------------------------------------
   // -- scl Stop setup time calculation
   //
   // -- Calculate the required shld period for scl_clk output
   // -- This procedure is used to calculate tSU;STO (I2C specs)
   // ----------------------------------------------------------
   assign scl_p_setup_next = scl_p_setup_cntr + 1;
   
   //spyglass disable_block SelfDeterminedExpr-ML
   //SMD: Self determined expression present in the design.
   //SJ:  This Self Determined Expression is as per the design requirement. 
   //     There will not be any functional issue.
   always @(posedge ic_clk or negedge ic_rst_n) begin : SCL_P_SETUP_COUNT_PROC
      if(ic_rst_n == 1'b0) begin
         scl_p_setup_cmplt <= 1'b0;
         scl_p_setup_cntr <= {`IC_HS_HCNT_RS{1'b0}};
         
      end else begin
         if(scl_p_setup_en == 1'b0)
           begin
              scl_p_setup_cmplt<= 1'b0;
              scl_p_setup_cntr <= {`IC_HS_HCNT_RS{1'b0}};
           end
          else if ((
                  not_hs_timing &&
                  (scl_p_setup_cntr < high_cnt_plus_latency))
                  ||
                  ( cap_load_100 && (scl_p_setup_cntr < low_cnt_limit))
                  ||
                  ( cap_load_400 && (scl_p_setup_cntr < hs_low_limit ))
              )
           begin
              scl_p_setup_cntr <= scl_p_setup_next;
              
           end
         else
           begin
              scl_p_setup_cmplt <= 1'b1;
           end
      end
   end // block: SCL_P_SETUP_COUNT_PROC
   //spyglass enable_block SelfDeterminedExpr-ML

   
endmodule

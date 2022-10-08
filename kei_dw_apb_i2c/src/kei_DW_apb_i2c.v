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
// File Version     :        $Revision: #32 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c.v#32 $ 
//
//
// File    : DW_apb_i2c.v
//
//
// Abstract: The I2C module will perform as either a master or slave
//           on the I2C bus.  The I2C module is fully compliant.
//           Please refer to the databook for full details.
//
// -------------------------------------------------------------------
// -------------------------------------------------------------------
//
// Please refer to the databook for full details on the signals.
//
// These are found in the "Signal Description" section of the "Signals" chapter.
// There are details on the following
//   % Input Delays
//   % Output Delays
//   Any False Paths
//   Any Multicycle Paths
//   Any Asynchronous Signals
//
//==============================================================================
// Start License Usage
//==============================================================================
// Key Used   : DWC-APB-Advanced-Source (IP access)
//==============================================================================
// End License Usage
//==============================================================================

module kei_DW_apb_i2c (

                   ic_start_det_intr,
                   ic_stop_det_intr,
                   ic_activity_intr,
                   ic_rx_done_intr,
                   ic_tx_abrt_intr,
                   ic_rd_req_intr,
                   ic_tx_empty_intr,
                   ic_tx_over_intr,
                   ic_rx_full_intr,
                   ic_rx_over_intr,
                   ic_rx_under_intr,
                   ic_gen_call_intr,
                   ic_current_src_en,
                   //APB Slave I/O Signals
                   pclk,
                   presetn,
                   psel,
                   penable,
                   pwrite,
                   paddr,
                   pwdata,
                   prdata,
                   pready,
                   pslverr,
                   ic_clk,
                   ic_clk_in_a,
                   ic_data_in_a,
                   ic_rst_n,
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
                   debug_mst_cstate,
                   debug_slv_cstate,
                   ic_clk_oe,
                   ic_data_oe,
                   ic_en
                   );

// ------------------------------------------------------
// -- Port declaration
// ------------------------------------------------------
// Inputs
  
   input pclk;    //# APB Clock Signal, used for the bus interface unit, can be asynchronous to the I2C clocks
  
   input presetn; //# APB Reset Signal (active low)

   input psel;    //# APB Peripheral Select Signal: lasts for two pclk cycles; when asserted indicates that the peripheral has been selected for read/write operation
   input penable; //# Strobe Signal: asserted for a single pclk cycle, used for timing read/write operations
   output pready;  //Slave ready: A low  on this APB3 signal stalls an APB transaction until signal goes high.
   output pslverr; //Slave error: A high on this APB3 signal indicates an error condition on the transfer.

   input pwrite;  //# Write Signal: when high indicates a write access to the peripheral; when low indicates a read access
   
   input [`IC_ADDR_SLICE_LHS:0] paddr; //# Address Bus: uses the lower 7 bits of the address bus for register decode, ignores bits 0 and 1 so that the 8 registers are on 32 bit boundaries
   
   input [`APB_DATA_WIDTH-1:0] pwdata;//Write Data Bus: driven by the
                                   // bus master (bridge unit)
                                   // during write cycles. Can
                                   // be 8,16,32 bits wide depending
                                   // on CoreConsultant parameter APB_DATA_WIDTH

   input                        ic_rst_n;

   input ic_clk; //I2C clock, used to clock transfers
                 // in standard, fast and high speed
                 // mode when this module is acting
                 // as master, can be asynchronous to pclk

   input ic_clk_in_a; //Incoming I2C clock:  Synchronous
                       // to i2c_clk when Master
                       // (except during slave acknowledge
                       // phase).  Asynchronous in when Slave.
                       // Synchronized with meta-stability techniques

   input ic_data_in_a; // Incoming I2C Data:  Asynchronous

  

   // OUTPUTS
   

//# APB read data bus.
//# Driven after the 1st APB cycle to align with the passing back of data to the AHB by the APB bridge.
//# Varies in size and can be 8, 16 or 32-bits wide.
   output [`APB_DATA_WIDTH-1:0] prdata;

   output                       ic_rx_over_intr;
   output                       ic_rx_under_intr;
   output                       ic_tx_over_intr;
   output                       ic_tx_abrt_intr;
   output                       ic_rx_done_intr;
   output                       ic_tx_empty_intr;
   output                       ic_activity_intr;
   output                       ic_stop_det_intr;


   output                       ic_start_det_intr;
   output                       ic_rd_req_intr;
   output                       ic_rx_full_intr;
   output                       ic_gen_call_intr;





   output                       debug_s_gen;
   output                       debug_p_gen;
   output                       debug_data;
   output                       debug_addr;
   output                       debug_rd;
   output                       debug_wr;
   output                       debug_hs;

   output                       ic_current_src_en;

//# Outgoing I2C clock: Open drain synchronous with i2c_clk
   output ic_clk_oe;
//# Outgoing I2C Data: Open Drain. Synchronous to i2c_clk
   output ic_data_oe;
//# ic_en indicates whether the I2C module is enabled. Some registers can only be programmed when the ic_en is set to 0. 
//# The fifo is flushed whenever the module is disabled. There is no need for the ic_clk when the module is disabled.
   output       ic_en;
//# To assist in the debug of any problems that may arise and also to give more visibility into the internals when running on silicon,
//# some internal states are brought out so that they can be viewed.. Very helpful considering the source code is generally encrypted.
   output       debug_master_act;
   output       debug_slave_act;
   output       debug_addr_10bit;
   output [4:0] debug_mst_cstate;
   output [3:0] debug_slv_cstate;

   // ----------------------------------------------------------
   // -- local registers and wires
   // ----------------------------------------------------------

   //biu wires
   wire [`MAX_APB_DATA_WIDTH-1:0]  ipwdata;
   wire [`MAX_APB_DATA_WIDTH-1:0]  iprdata;
   wire                            wr_en;
   wire                            rd_en;
   wire [3:0]                      byte_en;
   wire [`IC_ADDR_SLICE_LHS-2:0]   reg_addr;

   //regfile wires
   wire                            rx_pop;         // rx fifo pop
   wire                            tx_push;        // tx fifo push
   wire                            fifo_rst_n;     // sync reset for fifo controllers
   wire                            tx_fifo_rst_n;  // sync reset for tx fifo
   wire                            ic_clr_intr_en;
   wire                            ic_clr_rx_under_en;
   wire                            ic_clr_rx_over_en;
   wire                            ic_clr_tx_over_en;
   wire                            ic_clr_rd_req_en;
   wire                            ic_clr_rx_done_en;
   wire                            ic_clr_tx_abrt_en;
   wire                            ic_clr_activity_en;
   wire                            ic_clr_stop_det_en;
   wire                            ic_clr_start_det_en;
   wire [`IC_TAR_RS_INT-1:0]       ic_tar;
   wire [`IC_SAR_RS-1:0]           ic_sar;
   wire [`IC_HS_MADDR_RS-1:0]      ic_hs_maddr;
   wire [`IC_FS_HCNT_RS-1:0]       ic_fs_hcnt;
   wire [`IC_FS_LCNT_RS-1:0]       ic_fs_lcnt;
   wire [`IC_INTR_MASK_RS-1:0]     ic_intr_mask;
   wire [`RX_ABW-1:0]              ic_rx_tl;
   wire [`IC_TX_TL_RS-1:0]         ic_tx_tl;
   wire [`IC_HS_HCNT_RS-1:0]       ic_hcnt;
   wire [`IC_HS_LCNT_RS-1:0]       ic_lcnt;
   wire                            ic_rstrt_en;    //logic 1:Master can generate re-starts in general
   // jduarte 20110105 begin
   // CRM 9000368180
   // Added register outputs for spike length, in ic_clk cycles
   // The value for FS and SS modes is the same (ic_fs_spklen)
   wire [`IC_SPKLEN_RS-1:0]        ic_spklen_o;
   wire [`IC_FS_SPKLEN_RS-1:0]     ic_fs_spklen;
   wire [`IC_HS_SPKLEN_RS-1:0]     ic_hs_spklen;
   // jduarte 20110105 end

   //fifo wires
   wire                            tx_empty;       // tx fifo empty status
   wire                            tx_almost_empty;// tx fifo almost empty status
   wire                            gen_tx_almost_empty;// tx fifo almost empty status
   wire                            tx_overflow;    // tx fifo overflow
   wire                            rx_almost_full; // rx fifo almost full status
   wire                            rx_overflow;    // rx fifo overflow
   wire                            rx_underflow;   // rx fifo underflow
   wire [`TX_ABW-1:0]              tx_wr_addr;     // tx fifo write pointer
   wire [`TX_ABW-1:0]              tx_rd_addr;     // tx fifo read pointer
   wire                            tx_we_n;        // tx fifo write enable
   wire [`RX_ABW-1:0]              rx_wr_addr;     // rx fifo write pointer
   wire [`RX_ABW-1:0]              rx_rd_addr;     // rx fifo read pointer
   wire                            rx_we_n;        // rx fifo write enable

   //ram wires
   wire [`IC_DATA_FIFO_RS-1:0]     rx_pop_data;
   wire [`IC_DATA_TX_CMD_RS-1:0]   tx_push_data;   // data to the tx fifo
   wire [`IC_DATA_TX_CMD_RS-1:0]   tx_pop_data;    // data from the tx fifo

   //internal inturrupt signal wires
   wire                             activity;
   wire                             mst_activity_sync;
   wire                             slv_activity_sync;

   // register decode wires
   wire [`IC_ENABLE_RS_INT-1:0]     ic_enable;
   wire                             ic_master;
   wire                             ic_10bit_mst;
   wire                             ic_10bit_slv;
   wire                             ic_hs;
   wire                             ic_fs;
   wire                             ic_ss;
   //rx_filter wires
   wire                             sda_vld;// SDA signal is valid
   wire                             s_det;// START condition detected
   wire                             p_det;// STOP condition detected
   wire                             p_det_intr;// STOP condition detected based on slave addressed or master active
   wire                             arb_lost;// When confgured as MSTR Arbitration lost
   wire                             slv_tx_shift_en;// shift enable pulse valid when falling
                                                    // edge detected on SCL signal
   wire                             ack_det;//ACK has been detected
   wire                             slv_ack_det;//ACK has been detected
   wire                             slv_rx_ack_vld;
   wire                             sda_int;//input SDA signal
   wire                             scl_int;//input scl signal

   wire                             scl_edg_hl;     // falling edge detect of SCL

   //signals feeding rx_filter from other ic_clk domain modules
   wire                             ic_dis_window;

   //clkgen wires
   wire                             scl_lcnt_cmplt;   //low count period has elapsed
   wire                             scl_hcnt_cmplt;   //high count period has elapsed
   wire                             scl_s_hld_cmplt;  //start hold period has elapsed
   wire                             scl_s_setup_cmplt;//start setup period has elapsed
   wire                             scl_p_setup_cmplt;//stop setup period has elapsed

   //signals feeding the clk_gen
   wire                             ic_enable_sync;     //IC module enable status sync to ic_clk
   wire                             ic_abort_sync;     //IC module abort status sync to ic_clk

   //mstfsm wires
   wire [`IC_DATA_RS-1:0]           mst_tx_data_buf_in; //data to be transmitted on sda data out
   wire                             start_en;           //Enable START condition
   wire                             re_start_en;        //Enable RE-START condition
   wire                             mst_tx_en;          //Enable tx shift register to transmit data
   wire                             split_start_en;     //SPLIT_START condition is in effect.
   wire                             mst_rx_en;          //Enable rx shift register to transmit data
   wire                             mst_gen_ack_en;     //Enable Ack gen. ckt
   wire                             mst_push_rxfifo_en; //logic 1:push received data to the RX fifo
   wire                             mst_txfifo_ld_en;   //load tx_buffer from the tx fifo output
   wire                             stop_en;            //Generate STOP condition
   wire                             hs_mcode_en;        //logic 1:master is in hs and transmitting the hs_mcode
   wire                             tx_empty_sync;      //tx_empty signal synchronized to ic_clk

   wire                             mst_tx_abrt;        //tx aborted
   wire                             mst_activity;       //master using the bus

// jduarte begin 20101008
// CRM 9000366029
// jduarte end 20101008
   wire                             abrt_in_rcve_trns;   //abort occured during receive transfer
   wire                             slv_tx_en;            // Enable tx shift register to transmit data
   wire                             slv_gen_ack_en;       // Enable Ack gen. ckt
   wire                             slv_tx_abrt;          // logic 1: master aborted TX transfer
   wire                             slv_rx_done;          // logic 1: master aborted RX transfer
   wire                             slv_txfifo_ld_en;     // load tx_buffer from the tx fifo wire
   wire                             scl_hld_low_en;       //logic 1: hold scl to low state (insert wait states)
   wire                             ic_rd_req;            //logic 1: Slave is waiting on data from the processor to tx

   //wires feeding mstfsm
   wire                             ic_bus_idle;        //logic 1: IC bus is idle

   //slvfsm wires
   wire                             slv_rx_en;            // Enable rx shift register to transmit data
   wire                             slv_push_rxfifo_en;
   wire                             slv_rx_1byte_en;      //logic 1: we are receiving the 1st byte of a transfer
   wire                             slv_rx_2byte_en;      //logic 1: we are receiving the 2nd byte of a transfer
   wire                             slv_activity;         //Slave is using the bus

   //signals feeding the slv fsm
   wire                             slv_rxbyte_rdy;
   wire                             rx_gen_call;
   wire                             rx_addr_match;
   wire                             rx_addr_10bit;
   wire                             rx_hs_mcode;
   wire                             slv_tx_cmplt;

   //rx shift  register wires
   wire                             rx_slv_read;       //logic 1: slave is written
   wire                             mst_rx_ack_vld;    //logic 1: check for ack now
   wire                             mst_rx_cmplt;
// jduarte begin 20101108
// CRM 9000366029
   wire                             rx_shift_data_done;
// jduarte end 20101108
   //to mst_fsm
   wire                             mst_rxbyte_rdy;    //logic 1: master received byte is ready
   //to clk_gen
   wire                             rx_scl_lcnt_en;
   wire                             rx_scl_hcnt_en;
   //tx shift register wires
   wire                             slv_tx_ack_vld;    //logic 1: check for ack now
   wire                             mst_tx_ack_vld;    //logic 1: check for ack now
   wire                             mst_rx_data_scl;
   //to clk_gen
   wire                             byte_wait_scl;
   //to fifo ram
   wire [`IC_DATA_FIFO_RS-1:0]      rx_push_data;      //push data to rx fifo
   //to fifo cntl
   wire                             rx_push;           //logic 1: push data to rx fifo
   //to top level
   wire                             rx_current_src_en; //logic 1: enables pull up current source in HS mode

   //to mst_fsm
   wire [`IC_DATA_TX_CMD_RS-1:0]    tx_fifo_data_buf;  //Buffer to hold data popped from tx fifo
   //to clk_gen
   wire                             scl_lcnt_en;       //enable low count period
   wire                             scl_hcnt_en;       //enable high count period
   wire                             scl_s_hld_en;      //Enable Start condition hold time counter
   wire                             scl_s_setup_en;    //Enable Start condition setup time counter
   wire                             scl_p_setup_en;    //Enable Stop condition hold time counter
   //to top level
   wire                             ic_clk_oe;//Drives the SCL line transistor
   wire                             tx_current_src_en;//1:enables pull up current source in HS mode
   //fifo cntl signals
   wire                             tx_pop;            //logic 1: pop data from TX fifo

   //intctl wires
   wire [`IC_INTR_STAT_RS-1:0]     ic_intr_stat;
   wire [`IC_RAW_INTR_STAT_RS-1:0] ic_raw_intr_stat;
   wire                            tx_abrt_flg_edg;
   wire                            ic_rx_over_intr;
   wire                            ic_rx_under_intr;
   wire                            ic_rx_full_intr;
   wire                            ic_tx_over_intr;
   wire                            ic_tx_abrt_intr;
   wire                            ic_rx_done_intr;
   wire                            ic_rd_req_intr;
   wire                            ic_tx_empty_intr;
   wire                            ic_gen_call_intr;
   wire                            ic_activity_intr;
   wire                            ic_stop_det_intr;
   wire                            ic_start_det_intr;

   //i2c_sync module wires
   wire                            ic_master_sync;    //logic 1: IC module is a Master
                                                      //logic 0: IC module is a Slave
   wire                            ic_10bit_slv_sync; //logic 1: IC Master 10-bit address transfer mode
                                                      //logic 0: IC Master 7-bit address transfer mode
   wire                            ic_hs_sync;        //logic 1: IC is in High Speed mode (3.4 Mb/s)
   wire                            ic_fs_sync;        //logic 1: IC is in Fast Speed mode (400 kb/s)
   wire                            ic_ss_sync;        //logic 1: IC is in Standard Speed mode (100 kb/s)
   wire                            ic_10bit_mst_sync; //logic 1: IC Slave 10-bit address transfer mode
                                                      //logic 0: IC Slave 7-bit address transfer mode
   wire                             ic_rstrt_en_sync; //logic 1: Master can generate re-starts in general

   //tx shift wires
   wire                            re_start_cmplt;
   wire                            stop_cmplt;
   wire                            mst_tx_cmplt;

   //debug wires
   wire                            mst_debug_data;
   wire                            mst_debug_addr;

   //top level wires
   wire                            ic_current_src_en;

//#
//# Although the DMA signals may not exist on the I/O, we need to create a placeholder to allow the code to compile.
//# That is why inputs (dma_tx_ack and dma_rx_ack) have a wire declared for themselves
//#
   wire                            mst_rxbyte_rdy_done;

   //toggle wires
   wire rx_done_flg;
   wire ic_rd_req_flg;
   wire tx_abrt_flg;
   wire ic_disable;
   wire p_det_flg;
   wire s_det_flg;
   wire rx_gen_call_flg;
   wire tx_pop_flg;
   wire rx_push_flg;
   wire tx_empty_sync_hl;
   wire ic_clr_gen_call_en;
   
   wire slv_tx_ready_unconn;
   wire mst_addr_state_unconn;

   wire ic_data_oe; //Outgoing I2C Data: Open Drain
                       // Synchronous to i2c_clk
   wire ic_data_oe_int; //Outgoing I2C Data: Open Drain
                       // Synchronous to i2c_clk
   wire [`IC_TX_ABRT_SOURCE_RS-1:0] tx_abrt_source;

   wire [`IC_TX_ABRT_SOURCE_RS-1:0] ic_tx_abrt_source;//tx_abrt sources combined signals

   /////////////////////////////
   //tx_abrt source
   wire                        abrt_master_dis;     // Access master while disabled
   wire                        abrt_sbyte_norstrt;  // Send SBYTE while restart is disabled
   wire                        abrt_hs_norstrt;     // High Speed mode while restart disabled
   wire                        abrt_hs_ackdet;      // High Speed Master code was acknowledged
   wire                        abrt_sbyte_ackdet;   // Start Byte was acknowleged
   wire                        abrt_gcall_read;     // Try to read while sending a Gcall
   wire                        abrt_7b_addr_noack;  // 7bit 1address was not acknowledged
   wire                        abrt_txdata_noack;   // Slave did not acknowledge sent data
   wire                        abrt_10addr1_noack;  // 10 bit 1address was not acknowledged
   wire                        abrt_10b_rd_norstrt; // 10 bit read command while restart is disabled
   wire                        abrt_10addr2_noack;  // 10 bit 2address was not acknowledged
   //slv tx_abrt source indicator
   wire                        abrt_slvflush_txfifo; // slave flush tx fifo to request tx data
   wire                        abrt_slv_arblost;     // Slave lost the bus while it is tx data
   wire                        abrt_slvrd_intx;      // Slave request data to tx and processor wrote
   wire                        abrt_user_abrt;      // user aborted

   // a read command into the tx_fifo (9th bit is 1)

   wire                        slv_debug_data;
   wire                        slv_debug_addr;
   wire                        ic_slave_en;
   wire                        ic_slave_en_sync;
   wire                        p_det_ifaddr;
   wire                        p_det_ifaddr_sync;
   wire                        slv_rx_2addr;
   wire                        tx_pop_sync;
   wire                        rx_push_sync;
   wire                        rx_full;
   wire                        tx_full;
   wire                        rx_empty;
   wire                        slv_rx_aborted;
   wire                        slv_fifo_filled_and_flushed;
   wire                        slv_rx_aborted_sync;
   wire                        slv_fifo_filled_and_flushed_sync;
   wire                        tx_empty_ctrl;

   wire [4:0] mst_debug_cstate;
   wire [3:0] slv_debug_cstate;
   wire [4:0] debug_mst_cstate;
   wire [3:0] debug_slv_cstate;
   wire       min_hld_cmplt;
   wire       abrt_gcall_noack;
   wire       slv_clr_leftover;
   wire       slv_clr_leftover_flg;
   wire       slv_clr_leftover_flg_edg;
   wire       mst_rx_bwen;
   wire       slv_addressed; // Qualifier signal to indicate the slave is addressed
   wire       set_tx_empty_en_flg;
   wire       set_tx_empty_en_flg_edg;

   wire [`IC_SDA_TX_HOLD_RS-1:0]         ic_sda_tx_hold_sync; //  Hold time value used when I2C acts as transmitter 
   wire [`IC_SDA_RX_HOLD_RS-1:0]      ic_sda_rx_hold_sync; // Hold time value used when I2C acts as reciever
   wire [`IC_SDA_HOLD_RS-1:0]  ic_sda_hold; // SDA hold register containing recieve hold time and transmit hold time values.
   wire                        ic_ack_general_call;
   wire [`IC_SDA_SETUP_RS-1:0] ic_sda_setup;
   wire                        ic_ack_general_call_sync;
   wire                        master_read;
   wire [3:0]                  mst_rx_bit_count;
   wire                        mstrx1_7_end;
   wire                        slv_tx_data_en;

   wire                        mst_txdata_state;
   wire                        set_tx_empty_en;
   wire                        penable_int;//# Internal PENABLE Signal
   

   assign ic_data_oe = ic_data_oe_int;

//#
//# Generates toggle flags for the signals travelling from the ic_clk to the pclk domain.
//# Looks for edges on signals to indicate a toggle then these edges can be detected as changes in pclk domain.
//#
   kei_DW_apb_i2c_toggle
    U_DW_apb_i2c_toggle (
      //inputs
      .ic_rst_n(ic_rst_n),
                                          .ic_clk(ic_clk),
                                          .ic_rd_req(ic_rd_req),
                                          .mst_tx_abrt(mst_tx_abrt),
                                          .slv_tx_abrt(slv_tx_abrt),
                                          .slv_rx_done(slv_rx_done),
                                          .mst_activity(mst_activity),
                                          .slv_activity(slv_activity),
                                          .p_det(p_det_intr),
                                          .s_det(s_det),
                                          .rx_gen_call(rx_gen_call),
                                          .tx_pop(tx_pop),
                                          .rx_push(rx_push),
                                          .set_tx_empty_en(set_tx_empty_en),
                                          //master tx_abrt source indicators
                                          .abrt_master_dis(abrt_master_dis),     // Access master while disabled
                                          .abrt_sbyte_norstrt(abrt_sbyte_norstrt),  // Send SBYTE while restart is disabled
                                          .abrt_hs_norstrt(abrt_hs_norstrt),     // High Speed mode while restart disabled
                                          .abrt_hs_ackdet(abrt_hs_ackdet),      // High Speed Master code was acknowledged
                                          .abrt_sbyte_ackdet(abrt_sbyte_ackdet),   // Start Byte was acknowleged
                                          .abrt_gcall_read(abrt_gcall_read),     // Try to read while sending a Gcall
                                          .abrt_gcall_noack(abrt_gcall_noack),    // No slave acknowledged the G.CALL
                                          .abrt_7b_addr_noack(abrt_7b_addr_noack),  // 7bit 1address was not acknowledged
                                          .abrt_txdata_noack(abrt_txdata_noack),   // Slave did not acknowledge sent data
                                          .abrt_10addr1_noack(abrt_10addr1_noack),  // 10 bit 1address was not acknowledged
                                          .abrt_10b_rd_norstrt(abrt_10b_rd_norstrt), // 10 bit read command while restart is disabled
                                          .abrt_10addr2_noack(abrt_10addr2_noack),  // 10 bit 2address was not acknowledged
                                          .abrt_user_abrt(abrt_user_abrt),
                                          .arb_lost(arb_lost),
                                          .slv_clr_leftover(slv_clr_leftover),
                                          //slv tx_abrt source indicator
                                          .abrt_slvflush_txfifo(abrt_slvflush_txfifo), // Slave flush tx fifo to request tx data
                                          .abrt_slv_arblost(abrt_slv_arblost),     // Slave lost the bus while it is tx data
                                          .abrt_slvrd_intx(abrt_slvrd_intx),      // Slave request data to tx and processor wrote
                                          //debug inputs
                                          .tx_current_src_en(tx_current_src_en),
                                          .rx_current_src_en(rx_current_src_en),
                                          .start_en(start_en),
                                          .re_start_en(re_start_en),
                                          .stop_en(stop_en),
                                          .mst_debug_data(mst_debug_data),
                                          .mst_debug_addr(mst_debug_addr),
                                          .slv_debug_data(slv_debug_data),
                                          .slv_debug_addr(slv_debug_addr),
                                          .mst_rx_en(mst_rx_en),
                                          .mst_tx_en(mst_tx_en),
                                          .ic_enable_sync(ic_enable_sync),
                                          .ic_hs_sync(ic_hs_sync),
                                          .hs_mcode_en(hs_mcode_en),
                                          .rx_addr_10bit(rx_addr_10bit),
                                          .mst_debug_cstate(mst_debug_cstate),
                                          .slv_debug_cstate(slv_debug_cstate),
                                          .ic_dis_window(ic_dis_window),
                                          //outputs
                                          .debug_s_gen(debug_s_gen),
                                          .debug_p_gen(debug_p_gen),
                                          .debug_data(debug_data),
                                          .debug_addr(debug_addr),
                                          .debug_rd(debug_rd),
                                          .debug_wr(debug_wr),
                                          .debug_hs(debug_hs),
                                          .debug_master_act(debug_master_act),
                                          .debug_slave_act(debug_slave_act),
                                          .debug_addr_10bit(debug_addr_10bit),
                                          .debug_mst_cstate(debug_mst_cstate),
                                          .debug_slv_cstate(debug_slv_cstate),
                                          .ic_current_src_en(ic_current_src_en),
                                          .tx_abrt_flg(tx_abrt_flg),
                                          .ic_disable(ic_disable),
                                          .rx_done_flg(rx_done_flg),
                                          .ic_rd_req_flg(ic_rd_req_flg),
                                          .p_det_flg(p_det_flg),
                                          .s_det_flg(s_det_flg),
                                          .rx_gen_call_flg(rx_gen_call_flg),
                                          .tx_pop_flg(tx_pop_flg),
                                          .rx_push_flg(rx_push_flg),
                                          .tx_abrt_source(tx_abrt_source),
                                          .slv_clr_leftover_flg(slv_clr_leftover_flg),
                                          .set_tx_empty_en_flg(set_tx_empty_en_flg)
                                          );



   // Instantiation for the IC pclk to ic_clk synchronization module
   kei_DW_apb_i2c_sync
    U_DW_apb_i2c_sync
     (
      .ic_rst_n(ic_rst_n),
      .ic_clk(ic_clk),
      //Signals from pclk domain
      .ic_enable(ic_enable),
      .ic_master(ic_master),
      .ic_10bit_mst(ic_10bit_mst),
      .ic_hs(ic_hs),
      .ic_fs(ic_fs),
      .ic_ss(ic_ss),
      .tx_empty(tx_empty),
      .ic_10bit_slv(ic_10bit_slv),
      .ic_rstrt_en(ic_rstrt_en),
      .ic_slave_en(ic_slave_en),
      .p_det_ifaddr(p_det_ifaddr),
      .ic_sda_hold(ic_sda_hold),
      .ic_ack_general_call(ic_ack_general_call),
      //signals to ic_clk domain
      .ic_10bit_slv_sync(ic_10bit_slv_sync),
      .ic_enable_sync(ic_enable_sync),
      .ic_abort_sync(ic_abort_sync),
      .ic_master_sync(ic_master_sync),
      .ic_hs_sync(ic_hs_sync),
      .ic_fs_sync(ic_fs_sync),
      .ic_ss_sync(ic_ss_sync),
      .p_det_ifaddr_sync(p_det_ifaddr_sync),
      .ic_10bit_mst_sync(ic_10bit_mst_sync),
      .tx_empty_sync(tx_empty_sync),
      .tx_empty_sync_hl(tx_empty_sync_hl),
      .ic_rstrt_en_sync(ic_rstrt_en_sync),
      .ic_slave_en_sync(ic_slave_en_sync),
      .ic_ack_general_call_sync(ic_ack_general_call_sync),
      .ic_sda_tx_hold_sync(ic_sda_tx_hold_sync),
      .ic_sda_rx_hold_sync(ic_sda_rx_hold_sync)      
      );


   // Instantiation for IC Interrupt Interface
   kei_DW_apb_i2c_intctl
    U_DW_apb_i2c_intctl
     (
      // APB bus interface
      .pclk(pclk),
      .presetn(presetn),
      // DW_apb_i2c_biu interface
      .rd_en(rd_en),
      //from toggle.v
      .ic_disable(ic_disable),
      .tx_abrt_flg(tx_abrt_flg),
      .rx_done_flg(rx_done_flg),
      .ic_rd_req_flg(ic_rd_req_flg),
      .p_det_flg(p_det_flg),
      .s_det_flg(s_det_flg),
      .rx_gen_call_flg(rx_gen_call_flg),
      .slv_clr_leftover_flg(slv_clr_leftover_flg),
      .set_tx_empty_en_flg(set_tx_empty_en_flg),
      .gen_tx_almost_empty(gen_tx_almost_empty),
      .tx_abrt_source(tx_abrt_source),
      // internal i2c interrupt flags
      .rx_underflow(rx_underflow),
      .rx_overflow(rx_overflow),
      .rx_almost_full(rx_almost_full),
      .tx_overflow(tx_overflow),
      .tx_almost_empty(tx_almost_empty),
      .mst_activity(mst_activity),
      .slv_activity(slv_activity),
      .slv_rx_aborted(slv_rx_aborted),
      .slv_fifo_filled_and_flushed(slv_fifo_filled_and_flushed),
      .tx_empty_ctrl(tx_empty_ctrl),
      .ic_rx_under_intr(ic_rx_under_intr),
      .ic_rx_over_intr(ic_rx_over_intr),
      .ic_rx_full_intr(ic_rx_full_intr),
      .ic_tx_over_intr(ic_tx_over_intr),
      .ic_tx_empty_intr(ic_tx_empty_intr),
      .ic_rd_req_intr(ic_rd_req_intr),
      .ic_tx_abrt_intr(ic_tx_abrt_intr),
      .ic_rx_done_intr(ic_rx_done_intr),
      .ic_activity_intr(ic_activity_intr),
      .ic_stop_det_intr(ic_stop_det_intr),
      .ic_start_det_intr(ic_start_det_intr),
      .ic_gen_call_intr(ic_gen_call_intr),
      //regfile interface signals
      .ic_clr_intr_en(ic_clr_intr_en),
      .ic_clr_rx_under_en(ic_clr_rx_under_en),
      .ic_clr_rx_over_en(ic_clr_rx_over_en),
      .ic_clr_tx_over_en(ic_clr_tx_over_en),
      .ic_clr_rd_req_en(ic_clr_rd_req_en),
      .ic_clr_tx_abrt_en(ic_clr_tx_abrt_en),
      .ic_clr_rx_done_en(ic_clr_rx_done_en),
      .ic_clr_activity_en(ic_clr_activity_en),
      .ic_clr_stop_det_en(ic_clr_stop_det_en),
      .ic_clr_start_det_en(ic_clr_start_det_en),
      .ic_clr_gen_call_en(ic_clr_gen_call_en),
      .ic_enable(ic_enable[0]),
      .ic_intr_mask(ic_intr_mask),
      .ic_intr_stat(ic_intr_stat),
      .ic_raw_intr_stat(ic_raw_intr_stat),
      .tx_abrt_flg_edg(tx_abrt_flg_edg),
      //spyglass disable_block W528
      //SMD : A signal or variable is set but never read
      //SJ  : The slave clear left over flag is used to clear the Tx FIFO
      //      only during the non-UFM and non-async fifo mode. In other  
      //      configuration this will not be used. But there is no functional 
      //      issue, hence this can be waived.
      .slv_clr_leftover_flg_edg(slv_clr_leftover_flg_edg),
      //spyglass enable_block W528
      .set_tx_empty_en_flg_edg(set_tx_empty_en_flg_edg),
      .mst_activity_sync(mst_activity_sync),
      .slv_activity_sync(slv_activity_sync),
      .activity(activity),
      .ic_tx_abrt_source(ic_tx_abrt_source),
      .ic_ack_general_call(ic_ack_general_call),
      .slv_rx_aborted_sync(slv_rx_aborted_sync),
      .slv_fifo_filled_and_flushed_sync(slv_fifo_filled_and_flushed_sync),
      //to top level outputs
      .ic_en(ic_en)
      );



   // Instantiation for tx shift register
   kei_DW_apb_i2c_tx_shift
    U_DW_apb_i2c_tx_shift
     (
      //top level
      .ic_clk(ic_clk),
      .ic_rst_n(ic_rst_n),
      //regfile
      .ic_hs_sync(ic_hs_sync),
      .ic_master_sync(ic_master_sync),
      .ic_sda_tx_hold_sync(ic_sda_tx_hold_sync), 
      .ic_spklen(ic_spklen_o),
      //mstfsm signals
      .mst_tx_en(mst_tx_en),
      .mst_rx_en(mst_rx_en),
      .mst_tx_data_buf_in(mst_tx_data_buf_in),
      .start_en(start_en),
      .re_start_en(re_start_en),
      .mst_txfifo_ld_en(mst_txfifo_ld_en),
      .tx_fifo_data_buf(tx_fifo_data_buf),
      .stop_en(stop_en),
      .mst_gen_ack_en(mst_gen_ack_en),
      .re_start_cmplt(re_start_cmplt),
      .stop_cmplt(stop_cmplt),
      .mst_tx_cmplt(mst_tx_cmplt),
      .byte_wait_scl(byte_wait_scl),
      // jduarte begin 20101008
      // CRM 9000366029
      // jduarte end 20101008
      //slvfsm signals
      .slv_txfifo_ld_en(slv_txfifo_ld_en),
      .slv_gen_ack_en(slv_gen_ack_en),
      .slv_tx_en(slv_tx_en),
      .scl_hld_low_en(scl_hld_low_en),
      //spyglass disable_block W528
      //SMD : A signal or variable is set but never read
      //SJ  : The Slave Tx ready is provided for the debugging purpose at 
      //      the top level file. But it is unused. But there is no functional 
      //      issue, hence this can be waived. 
      .slv_tx_ready(slv_tx_ready_unconn),
      //spyglass enable_block W528
      .slv_tx_cmplt(slv_tx_cmplt),
      .slv_tx_data_en(slv_tx_data_en),
      //clk_gen signals
      .hs_mcode_en(hs_mcode_en),
      .scl_lcnt_en(scl_lcnt_en),
      .scl_hcnt_en(scl_hcnt_en),
      .scl_s_hld_en(scl_s_hld_en),
      .scl_s_setup_en(scl_s_setup_en),
      .scl_p_setup_en(scl_p_setup_en),
      .scl_lcnt_cmplt(scl_lcnt_cmplt),
      .scl_hcnt_cmplt(scl_hcnt_cmplt),
      .scl_s_hld_cmplt(scl_s_hld_cmplt),
      .scl_s_setup_cmplt(scl_s_setup_cmplt),
      .scl_p_setup_cmplt(scl_p_setup_cmplt),
      //from rx_filter
      .arb_lost(arb_lost),
      .mst_tx_ack_vld(mst_tx_ack_vld),
      .slv_tx_shift_en(slv_tx_shift_en),
      .slv_tx_ack_vld(slv_tx_ack_vld),
      .scl_edg_hl(scl_edg_hl),
      .mst_txdata_state(mst_txdata_state),
      .master_read(master_read),
      .mst_rx_bit_count(mst_rx_bit_count),
      .mstrx1_7_end(mstrx1_7_end),
      .mst_rx_ack_vld(mst_rx_ack_vld),
      .mst_rx_data_scl(mst_rx_data_scl),
      .rx_scl_lcnt_en(rx_scl_lcnt_en),
      .rx_scl_hcnt_en(rx_scl_hcnt_en),
      .mst_rx_bwen(mst_rx_bwen),
      .slv_rx_ack_vld(slv_rx_ack_vld),
      //top level outputs
      .ic_clk_oe(ic_clk_oe),
      .ic_data_oe(ic_data_oe_int),
      .tx_current_src_en(tx_current_src_en),
      //fifo cntl signals
      .tx_pop(tx_pop),
      //fifo ram
      .tx_pop_data(tx_pop_data),
      //rx_filter
      .scl_int(scl_int),
      .set_tx_empty_en(set_tx_empty_en)
      );




   // Instantiation for rx shift register
   kei_DW_apb_i2c_rx_shift
    U_DW_apb_i2c_rx_shift
     (
      .ic_clk(ic_clk)
      ,.ic_rst_n(ic_rst_n)
      ,//regfile
      .ic_hs_sync(ic_hs_sync)
      ,//mstfsm signals
      .mst_rx_en(mst_rx_en)
      ,.mst_push_rxfifo_en(mst_push_rxfifo_en)
      ,.mst_rxbyte_rdy(mst_rxbyte_rdy)
      ,.mst_rx_cmplt(mst_rx_cmplt)
      ,// jduarte end 20101008
      //slvfsm signals
      .slv_rx_en(slv_rx_en)
      ,.slv_rx_1byte_en(slv_rx_1byte_en)
      ,.slv_rx_2byte_en(slv_rx_2byte_en)
      ,.rx_slv_read(rx_slv_read)
      ,.slv_push_rxfifo_en(slv_push_rxfifo_en)
      ,.slv_rxbyte_rdy(slv_rxbyte_rdy)
      ,.rx_gen_call(rx_gen_call)
      ,.rx_addr_match(rx_addr_match)
      ,.rx_addr_10bit(rx_addr_10bit)
      ,.rx_hs_mcode(rx_hs_mcode)
      ,.slv_rx_2addr(slv_rx_2addr)
      ,//clk_gen signals
      .hs_mcode_en(hs_mcode_en)
      ,.rx_scl_lcnt_en(rx_scl_lcnt_en)
      ,.rx_scl_hcnt_en(rx_scl_hcnt_en)
      ,.scl_lcnt_cmplt(scl_lcnt_cmplt)
      ,.scl_hcnt_cmplt(scl_hcnt_cmplt)
      ,//from rx_filter
      .sda_int(sda_int)
      ,.sda_vld(sda_vld)
      ,.slv_rx_ack_vld(slv_rx_ack_vld)
      ,.scl_int(scl_int)
      ,.scl_edg_hl(scl_edg_hl)
      ,//rx shift reg
      .mst_rx_ack_vld(mst_rx_ack_vld)
      ,// jduarte begin 20101108
      // CRM 9000366029
      .rx_shift_data_done(rx_shift_data_done)
      ,// jduarte end 20101108
      //top level outputs
      .rx_current_src_en(rx_current_src_en)
      ,//fifo cntl signals
      .rx_push(rx_push)
      ,//regfile
      .ic_sar(ic_sar)
      ,.ic_10bit_slv(ic_10bit_slv)
      ,.ic_ack_general_call(ic_ack_general_call_sync)
      ,.mst_rxbyte_rdy_done(mst_rxbyte_rdy_done)
      ,//fifo ram
      .rx_push_data(rx_push_data)
      ,.mst_rx_bwen(mst_rx_bwen)
      ,.mst_rx_data_scl(mst_rx_data_scl)
      ,.mst_rx_bit_count(mst_rx_bit_count)
      ,.mstrx1_7_end(mstrx1_7_end)
      );

   // Instantiation for APB_Interface
   kei_DW_apb_i2c_biu
    U_DW_apb_i2c_biu
     (
      .pclk(pclk),
      .presetn(presetn),
      .psel(psel),
      .penable(penable),
      .pwrite(pwrite),
      .paddr(paddr),
      .pwdata(pwdata),
      .iprdata(iprdata),
      .ipwdata(ipwdata),
      .prdata(prdata),
      .pready(pready),
      .pslverr(pslverr),
      .wr_en(wr_en),
      .rd_en(rd_en),
      .slave_rdy(slave_rdy),
      .slave_err(slave_err),
      .penable_int(penable_int),
      .byte_en(byte_en),
      .reg_addr(reg_addr)
      );

   // Instantiation for slave state machine
   kei_DW_apb_i2c_slvfsm
    U_DW_apb_i2c_slvfsm
     (
      .ic_rst_n(ic_rst_n)
      ,.ic_clk(ic_clk)
      ,//Signals from pclk domain
      .ic_enable_sync(ic_enable_sync)
      ,.ic_10bit_slv_sync(ic_10bit_slv_sync)
      ,.tx_empty_sync(tx_empty_sync)
      ,.tx_empty_sync_hl(tx_empty_sync_hl)
      ,.ic_slave_en_sync(ic_slave_en_sync)
      ,.ic_sda_setup(ic_sda_setup)
      ,.ic_ack_general_call(ic_ack_general_call_sync)
      ,//signals to the int_cntl
      .slv_tx_abrt(slv_tx_abrt)
      ,.slv_rx_done(slv_rx_done)
      ,.ic_rd_req(ic_rd_req)
      ,.slv_rx_aborted(slv_rx_aborted)
      ,.slv_fifo_filled_and_flushed(slv_fifo_filled_and_flushed)
      ,//rx filter signals
      .arb_lost(arb_lost)
      ,.s_det(s_det)
      ,.p_det(p_det)
      ,.slv_ack_det(slv_ack_det)
      ,.slv_rx_ack_vld(slv_rx_ack_vld)
      ,//Tx shift reg signals
      .slv_tx_en(slv_tx_en)
      ,.slv_rx_en(slv_rx_en)
      ,.slv_txfifo_ld_en(slv_txfifo_ld_en)
      ,.tx_fifo_dbuf_8(tx_fifo_data_buf[8])
      ,.slv_gen_ack_en(slv_gen_ack_en)
      ,.scl_hld_low_en(scl_hld_low_en)
      ,.ic_data_oe(ic_data_oe)
      ,//Rx shift reg signals
      .slv_rxbyte_rdy(slv_rxbyte_rdy)
      ,.rx_gen_call(rx_gen_call)
      ,.rx_addr_match(rx_addr_match)
      ,.rx_slv_read(rx_slv_read)
      ,.slv_rx_1byte_en(slv_rx_1byte_en)
      ,.slv_rx_2byte_en(slv_rx_2byte_en)
      ,.slv_push_rxfifo_en(slv_push_rxfifo_en)
      ,.slv_tx_cmplt(slv_tx_cmplt)
      ,.slv_rx_2addr(slv_rx_2addr)
      //slv tx_abrt source indicator
      ,.abrt_slvflush_txfifo(abrt_slvflush_txfifo)//slave flush tx fifo to request tx data
      ,.abrt_slv_arblost(abrt_slv_arblost)//Slave lost the bus while it is tx data
      ,.abrt_slvrd_intx(abrt_slvrd_intx)//Slave request data to tx and processor wrote
      ,//misc.
      .slv_debug_addr(slv_debug_addr)
      ,.slv_debug_data(slv_debug_data)
      ,.slv_activity(slv_activity)
      ,.slv_clr_leftover(slv_clr_leftover)
      ,.slv_debug_cstate(slv_debug_cstate)      
      ,.slv_addressed(slv_addressed)
      ,.slv_tx_data_en(slv_tx_data_en)
      );

   // Instantiation for the master state machine
   kei_DW_apb_i2c_mstfsm
    U_DW_apb_i2c_mstfsm
     (
      .ic_rst_n(ic_rst_n),
      .ic_clk(ic_clk),
      //Signals from pclk domain
      .ic_enable_sync(ic_enable_sync),
      .ic_abort_sync(ic_abort_sync),
      .ic_master_sync(ic_master_sync),
      .ic_10bit_mst_sync(ic_10bit_mst_sync),
      .ic_hs_sync(ic_hs_sync),
      .tx_empty_sync(tx_empty_sync),
      .tx_empty_sync_hl(tx_empty_sync_hl),
      .ic_rstrt_en_sync(ic_rstrt_en_sync),
      //signals to the int_cntl
      .mst_tx_abrt(mst_tx_abrt),
      //rx filter signals
      .ic_bus_idle(ic_bus_idle),
      .arb_lost(arb_lost),
      .ack_det(ack_det),
      //Tx shift reg signals
      .mst_tx_en(mst_tx_en),
      .mst_rx_en(mst_rx_en),
      .mst_tx_data_buf_in(mst_tx_data_buf_in),
      .start_en(start_en),
      .split_start_en(split_start_en),
      .re_start_en(re_start_en),
      .mst_txfifo_ld_en(mst_txfifo_ld_en),
      .tx_fifo_data_buf(tx_fifo_data_buf),
      .stop_en(stop_en),
      .mst_gen_ack_en(mst_gen_ack_en),
      .start_cmplt(scl_s_hld_cmplt),
      .re_start_cmplt(re_start_cmplt),
      .stop_cmplt(stop_cmplt),
      .mst_tx_cmplt(mst_tx_cmplt),
      .ic_dis_window(ic_dis_window),
      //clk_gen signals
      .hs_mcode_en(hs_mcode_en),
      .byte_wait_scl(byte_wait_scl),
      .min_hld_cmplt(min_hld_cmplt),
      .scl_lcnt_cmplt(scl_lcnt_cmplt),
      //Rx shift reg signals
      .mst_rxbyte_rdy(mst_rxbyte_rdy),
      .mst_push_rxfifo_en(mst_push_rxfifo_en),
      .mst_rx_cmplt(mst_rx_cmplt),
      // jduarte begin 20101108
      // CRM 9000366029
      .rx_shift_data_done(rx_shift_data_done),
      .mst_rxbyte_rdy_done(mst_rxbyte_rdy_done),
      // jduarte end 20101108
      //signals from the reg file
      .ic_hs_maddr(ic_hs_maddr),
      .ic_tar(ic_tar),
      //slvfsm signals
      .ic_rd_req(ic_rd_req),
      //misc
      .mst_activity(mst_activity),
      // jduarte begin 20101008
      // CRM 9000366029
      // jduarte end 20101008
      .abrt_in_rcve_trns(abrt_in_rcve_trns),
      //tx_abrt source indicators
      .abrt_master_dis(abrt_master_dis),//Access master while disabled
      .abrt_sbyte_norstrt(abrt_sbyte_norstrt),//Send SBYTE while restart is disabled
      .abrt_hs_norstrt(abrt_hs_norstrt),//High Speed mode while restart disabled
      .abrt_hs_ackdet(abrt_hs_ackdet),//High Speed Master code was acknowledged
      .abrt_sbyte_ackdet(abrt_sbyte_ackdet),//Start Byte was acknowleged
      .abrt_gcall_read(abrt_gcall_read),//Try to read while sending a Gcall
      .abrt_gcall_noack(abrt_gcall_noack),//No slave acknowledged the G.CALL
      .abrt_7b_addr_noack(abrt_7b_addr_noack),//7bit 1address was not acknowledged
      .abrt_txdata_noack(abrt_txdata_noack),//Slave did not acknowledge sent data
      .abrt_10addr1_noack(abrt_10addr1_noack),//10 bit 1address was not acknowledged
      .abrt_10b_rd_norstrt(abrt_10b_rd_norstrt),//10 bit read command while restart is disabled
      .abrt_10addr2_noack(abrt_10addr2_noack),//10 bit 2address was not acknowledged
      .abrt_user_abrt(abrt_user_abrt),
      //spyglass disable_block W528
      //SMD : A signal or variable is set but never read
      //SJ  : The Master address state is provided for the debugging purpose at 
      //      the top level file. But it is unused. But there is no functional 
      //      issue, hence this can be waived. 
      .mst_addr_state(mst_addr_state_unconn),
      //spyglass enable_block W528
      .mst_txdata_state(mst_txdata_state),
      .master_read(master_read),
      //top level signals
      .mst_debug_addr(mst_debug_addr),
      .mst_debug_data(mst_debug_data),
      .mst_debug_cstate(mst_debug_cstate)
      );

   // Instantiation for rx_filter
   kei_DW_apb_i2c_rx_filter
    U_DW_apb_i2c_rx_filter
     (
      //top level signals
      .ic_clk(ic_clk),
      .ic_rst_n(ic_rst_n),
      .ic_clk_in_a(ic_clk_in_a),
      .ic_data_in_a(ic_data_in_a),
      .ic_data_oe(ic_data_oe_int),
      //tx shift register signals
      .slv_tx_ack_vld(slv_tx_ack_vld),
      .mst_tx_ack_vld(mst_tx_ack_vld),
      .mst_rx_ack_vld(mst_rx_ack_vld),
      .slv_tx_shift_en(slv_tx_shift_en),
      //clk_gen signals
      .sda_int(sda_int),
      .scl_int(scl_int),
      //reg file signals
      .ic_hs_sync(ic_hs_sync),
      .ic_fs_sync(ic_fs_sync),
      .p_det_ifaddr_sync(p_det_ifaddr_sync),
      // jduarte 20110105 begin
      // CRM 9000368180
      // Added register outputs for spike length, in ic_clk cycles
      // The value for FS and SS modes is the same (ic_fs_spklen)
      .ic_hs_spklen(ic_hs_spklen),
      .ic_fs_spklen(ic_fs_spklen),
      .ic_master_sync(ic_master_sync),
      .ic_sda_rx_hold_sync(ic_sda_rx_hold_sync),
      .hs_mcode_en(hs_mcode_en),
      .rx_hs_mcode(rx_hs_mcode),
      .ic_spklen_o(ic_spklen_o),
      // jduarte 20110105 end
      //mstfsm signals
      .stop_en(stop_en),
      .start_en(start_en),
      .re_start_en(re_start_en),
      .split_start_en(split_start_en),
      .mst_tx_en(mst_tx_en),
      .mst_rx_en(mst_rx_en),
      .mst_activity(mst_activity),
      //slvfsm signals
      .slv_tx_en(slv_tx_en),
      .slv_activity(slv_activity),
      //misc.
      .sda_vld(sda_vld),
      .s_det(s_det),
      .p_det(p_det),
      .p_det_intr(p_det_intr),
      .arb_lost(arb_lost),
      .ack_det(ack_det),
      .slv_ack_det(slv_ack_det),
      .scl_edg_hl(scl_edg_hl),
      .slv_addressed(slv_addressed)
      );


   // Instantiation for clk_gen
   kei_DW_apb_i2c_clk_gen
    U_DW_apb_i2c_clk_gen (
     //top level signals
     .ic_clk(ic_clk),
                                            .ic_rst_n(ic_rst_n),
                                            .ic_master_sync(ic_master_sync),
                                            //rx_filter signal
                                            .sda_int(sda_int),
                                            .scl_int(scl_int),
                                            .s_det(s_det),
                                            .p_det(p_det),
                                            //inputs from regfile
                                            .ic_hcnt(ic_hcnt),
                                            .ic_lcnt(ic_lcnt),
                                            .ic_fs_lcnt(ic_fs_lcnt),
                                            .ic_fs_hcnt(ic_fs_hcnt),
                                            .ic_hs_sync(ic_hs_sync),
                                            .ic_fs_sync(ic_fs_sync),
                                            .ic_ss_sync(ic_ss_sync),
                                            .ic_fs_spklen(ic_fs_spklen),
                                            //mstfsm signals
                                            .ic_enable_sync(ic_enable_sync),
                                            .ic_bus_idle(ic_bus_idle),
                                            .min_hld_cmplt(min_hld_cmplt),
                                            //rx_shift_reg signals
                                            .hs_mcode_en(hs_mcode_en),
                                            .scl_lcnt_en(scl_lcnt_en),
                                            .scl_hcnt_en(scl_hcnt_en),
                                            .scl_s_hld_en(scl_s_hld_en),
                                            .scl_s_setup_en(scl_s_setup_en),
                                            .scl_p_setup_en(scl_p_setup_en),
                                            .rx_scl_lcnt_en(rx_scl_lcnt_en),
                                            .rx_scl_hcnt_en(rx_scl_hcnt_en),
                                            //outputs to tx/rx shift registers
                                            .scl_lcnt_cmplt(scl_lcnt_cmplt),
                                            .scl_hcnt_cmplt(scl_hcnt_cmplt),
                                            .scl_s_hld_cmplt(scl_s_hld_cmplt),
                                            .scl_s_setup_cmplt(scl_s_setup_cmplt),
                                            .scl_p_setup_cmplt(scl_p_setup_cmplt)
                                            );

   // Instantiation for IC register file
   kei_DW_apb_i2c_regfile
    U_DW_apb_i2c_regfile (
     // APB bus interface
     .pclk(pclk),
                                            .presetn(presetn),
                                            // DW_apb_i2c_biu interface
                                            .wr_en(wr_en),
                                            .rd_en(rd_en),
                                            .slave_rdy(slave_rdy),
                                            .slave_err(slave_err),
                                            .penable_int(penable_int),
                                            .byte_en(byte_en),
                                            .reg_addr(reg_addr),
                                            .ipwdata(ipwdata),
                                            .iprdata(iprdata),
                                            .ic_enable(ic_enable),
                                            // DW_i2c_intctl interface
                                            .ic_clr_intr_en(ic_clr_intr_en),
                                            .ic_clr_rx_under_en(ic_clr_rx_under_en),
                                            .ic_clr_rx_over_en(ic_clr_rx_over_en),
                                            .ic_clr_tx_over_en(ic_clr_tx_over_en),
                                            .ic_clr_rd_req_en(ic_clr_rd_req_en),
                                            .ic_clr_tx_abrt_en(ic_clr_tx_abrt_en),
                                            .ic_clr_rx_done_en(ic_clr_rx_done_en),
                                            .ic_clr_activity_en(ic_clr_activity_en),
                                            .ic_clr_stop_det_en(ic_clr_stop_det_en),
                                            .ic_clr_start_det_en(ic_clr_start_det_en),
                                            .ic_clr_gen_call_en(ic_clr_gen_call_en),
                                            .mst_activity(mst_activity_sync),
                                            .slv_activity(slv_activity_sync),
                                            .activity(activity),
                                            .ic_tx_abrt_source(ic_tx_abrt_source),
                                            .psel(psel),
                                            //register value output
                                            .ic_tar(ic_tar),
                                            .ic_sar(ic_sar),
                                            .ic_hs_maddr(ic_hs_maddr),
                                            .ic_hcnt(ic_hcnt),
                                            .ic_lcnt(ic_lcnt),
                                            .ic_fs_hcnt(ic_fs_hcnt),
                                            .ic_fs_lcnt(ic_fs_lcnt),
                                            // jduarte 20110105 begin
                                            // CRM 9000368180
                                            // Added register outputs for spike length, in ic_clk cycles
                                            // The value for FS and SS modes is the same (ic_fs_spklen)
                                            .ic_hs_spklen(ic_hs_spklen),
                                            .ic_fs_spklen(ic_fs_spklen),
                                            // jduarte 20110105 end
                                            .ic_rx_tl_int(ic_rx_tl),
                                            .ic_tx_tl(ic_tx_tl),
                                            //register value input from intctl module
                                            .ic_intr_mask(ic_intr_mask),
                                            .ic_intr_stat(ic_intr_stat),
                                            .ic_raw_intr_stat(ic_raw_intr_stat),
                                            .ic_en(ic_en),
                                            .slv_rx_aborted_sync(slv_rx_aborted_sync),
                                            .slv_fifo_filled_and_flushed_sync(slv_fifo_filled_and_flushed_sync),
                                            //control signals
                                            .ic_hs(ic_hs),
                                            .ic_fs(ic_fs),
                                            .ic_ss(ic_ss),
                                            .ic_master(ic_master),
                                            .ic_10bit_mst(ic_10bit_mst),
                                            .ic_10bit_slv(ic_10bit_slv),
                                            .ic_slave_en(ic_slave_en),
                                            .p_det_ifaddr(p_det_ifaddr),
                                            // DW_i2c_fifo interfacs
                                            .rx_pop_data(rx_pop_data),
                                            .tx_push_data(tx_push_data),
                                            .fifo_rst_n(fifo_rst_n),
                                            .tx_fifo_rst_n(tx_fifo_rst_n),
                                            .tx_pop_sync(tx_pop_sync),
                                            .rx_push_sync(rx_push_sync),
                                            .rx_pop(rx_pop),
                                            .tx_push(tx_push),
                                            .tx_empty(tx_empty),
                                            .rx_full(rx_full),
                                            .tx_full(tx_full),
                                            .rx_empty(rx_empty),
                                            //misc
                                            .tx_abrt_flg_edg(tx_abrt_flg_edg),
                                            .abrt_in_rcve_trns(abrt_in_rcve_trns),
                                            .slv_clr_leftover_flg_edg(slv_clr_leftover_flg_edg),
                                            .ic_rstrt_en(ic_rstrt_en),
                                            .ic_sda_setup(ic_sda_setup),
                                            .ic_sda_hold(ic_sda_hold),
                                            .ic_ack_general_call(ic_ack_general_call),
                                            .tx_empty_ctrl(tx_empty_ctrl)
                                            );

   // Instantiation for IC FIFO Controller
   kei_DW_apb_i2c_fifo
    U_DW_apb_i2c_fifo (
     .pclk            (pclk),
     .presetn         (presetn),
     .fifo_rst_n      (fifo_rst_n),
     .tx_fifo_rst_n   (tx_fifo_rst_n),
     .set_tx_empty_en_flg_edg (set_tx_empty_en_flg_edg),

     .ic_tx_tl        (ic_tx_tl),
     .tx_push         (tx_push),
     .rx_pop          (rx_pop),
     .tx_pop_flg      (tx_pop_flg),
     .tx_pop_sync     (tx_pop_sync),
     .tx_empty        (tx_empty),
     .rx_full         (rx_full),
     .tx_full         (tx_full),
     .tx_almost_empty (tx_almost_empty),
     .gen_tx_almost_empty (gen_tx_almost_empty),
     .tx_overflow     (tx_overflow),
     .tx_wr_addr      (tx_wr_addr),
     .tx_rd_addr      (tx_rd_addr),
     .tx_we_n         (tx_we_n),

     .ic_rx_tl        (ic_rx_tl),
     .rx_push_flg     (rx_push_flg),
     .rx_push_sync    (rx_push_sync),
     .rx_empty        (rx_empty),
     .rx_almost_full  (rx_almost_full),
     .rx_overflow     (rx_overflow),
     .rx_underflow    (rx_underflow),
     .rx_wr_addr      (rx_wr_addr),
     .rx_rd_addr      (rx_rd_addr),
     .rx_we_n         (rx_we_n)
   );

   
   // Instantiation for IC FIFO Controller




   // Receive FIFO RAM block
   kei_DW_apb_i2c_bcm57
    #(`IC_DATA_FIFO_RS, `IC_RX_BUFFER_MOD_DEPTH, 0, `RX_ABW) U_dff_rx (
     .clk                  (pclk),
     .rst_n                (presetn),
     .wr_addr              (rx_wr_addr),
     .rd_addr              (rx_rd_addr),
     .data_in              (rx_push_data),
     .wr_n                 (rx_we_n),
     .data_out             (rx_pop_data)
   );

   // Transmit FIFO RAM block
   kei_DW_apb_i2c_bcm57
    #(`IC_DATA_TX_CMD_RS, `IC_TX_BUFFER_MOD_DEPTH, 0, `TX_ABW) U_dff_tx (
     .clk                  (pclk),
     .rst_n                (presetn),
     .wr_addr              (tx_wr_addr),
     .rd_addr              (tx_rd_addr),
     .data_in              (tx_push_data),
     .wr_n                 (tx_we_n),
     .data_out             (tx_pop_data)
   );

//-----------------------------------------------------------
//--CRC Generation/Validity check module
//--This module Generates/Validity check of the PEC byte for
//--Address Resolution Protocol commands.
//--SMBus supports ATM Header CRC : X8 + x2 + x1 + 1 = 263
//------------------------------------------------------------

endmodule

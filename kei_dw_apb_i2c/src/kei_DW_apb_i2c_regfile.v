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
// File Version     :        $Revision: #23 $ 
// Revision: $Id: //dwh/DW_ocb/DW_apb_i2c/amba_dev/src/DW_apb_i2c_regfile.v#23 $ 
//
//
// File    : DW_apb_i2c_regfile.v
//
//
// Abstract: Register Block module for the DW_apb_i2c macrocell
//
// ------------------------------------------------------------

// ------------------------------------------------------------
// -- Register address offset macros
// -- All registers are on 32-bit boundaries
// ------------------------------------------------------------

`define IC_CON_OS             8'h00
`define IC_TAR_OS             8'h04
`define IC_SAR_OS             8'h08
`define IC_HS_MADDR_OS        8'h0c
`define IC_DATA_CMD_OS        8'h10
`define IC_SS_HCNT_OS         8'h14
`define IC_SS_LCNT_OS         8'h18
`define IC_FS_HCNT_OS         8'h1c
`define IC_FS_LCNT_OS         8'h20
`define IC_HS_HCNT_OS         8'h24
`define IC_HS_LCNT_OS         8'h28
`define IC_INTR_STAT_OS       8'h2c
`define IC_INTR_MASK_OS       8'h30
`define IC_RAW_INTR_STAT_OS   8'h34
`define IC_RX_TL_OS           8'h38
`define IC_TX_TL_OS           8'h3c
`define IC_CLR_INTR_OS        8'h40
`define IC_CLR_RX_UNDER_OS    8'h44
`define IC_CLR_RX_OVER_OS     8'h48
`define IC_CLR_TX_OVER_OS     8'h4c
`define IC_CLR_RD_REQ_OS      8'h50
`define IC_CLR_TX_ABRT_OS     8'h54
`define IC_CLR_RX_DONE_OS     8'h58
`define IC_CLR_ACTIVITY_OS    8'h5c
`define IC_CLR_STOP_DET_OS    8'h60
`define IC_CLR_START_DET_OS   8'h64
`define IC_CLR_GEN_CALL_OS    8'h68
`define IC_ENABLE_OS          8'h6c
`define IC_STATUS_OS          8'h70
`define IC_TXFLR_OS           8'h74
`define IC_RXFLR_OS           8'h78
`define IC_TX_ABRT_SOURCE_OS  8'h80


`define IC_DMA_CR_OS          8'h88
`define IC_DMA_TDLR_OS        8'h8c
`define IC_DMA_RDLR_OS        8'h90

`define IC_SDA_SETUP_OS        8'h94
`define IC_ACK_GENERAL_CALL_OS 8'h98
`define IC_ENABLE_STATUS_OS    8'h9C

// jduarte 20110105 begin
// CRM 9000368180
// Added register addresses for setting length of suppressed spike
// in ic_clk cycles
`define IC_FS_SPKLEN_OS       8'ha0
`define IC_HS_SPKLEN_OS       8'ha4
// jduarte 20110105 end


`define REG_TIMEOUT_RST_OS    8'hf0

`define IC_COMP_PARAM_1_OS    8'hf4
`define IC_COMP_VERSION_OS    8'hf8
`define IC_COMP_TYPE_OS       8'hfc

`define IC_SDA_HOLD_OS        8'h7c



module kei_DW_apb_i2c_regfile (
   pclk
                           ,presetn
                           ,wr_en
                           ,rd_en
                           ,slave_rdy
                           ,slave_err
                           ,penable_int
                           ,byte_en
                           ,reg_addr
                           ,ipwdata
                           ,iprdata
                           ,ic_clr_intr_en
                           ,ic_clr_rx_under_en
                           ,ic_clr_rx_over_en
                           ,ic_clr_tx_over_en
                           ,ic_clr_rd_req_en
                           ,ic_clr_tx_abrt_en
                           ,ic_clr_rx_done_en
                           ,ic_clr_activity_en
                           ,ic_clr_stop_det_en
                           ,ic_clr_start_det_en
                           ,ic_clr_gen_call_en
                           ,mst_activity
                           ,slv_activity
                           ,activity
                           ,ic_tx_abrt_source
                           ,psel
                           ,ic_en
                           ,slv_rx_aborted_sync
                           ,slv_fifo_filled_and_flushed_sync
                           ,ic_tar
                           ,ic_sar
                           ,ic_hs_maddr
                           ,ic_fs_hcnt
                           ,ic_fs_lcnt
                           ,ic_intr_mask
                           ,ic_rx_tl_int
                           ,ic_tx_tl
                           ,ic_enable
                           ,ic_hcnt
                           ,ic_lcnt
                           ,// jduarte 20110105 begin
                           // CRM 9000368180
                           // Added outputs for length of suppressed spike
                           // in ic_clk cycles
                           // The same value is used for FS and SS (ic_fs_spklen)
                           ic_fs_spklen
                           ,ic_hs_spklen
                           // jduarte 20110105 end   
                           ,ic_intr_stat
                           ,ic_raw_intr_stat
                           ,ic_hs
                           ,ic_fs
                           ,ic_ss
                           ,ic_master
                           ,ic_10bit_mst
                           ,ic_10bit_slv
                           ,ic_slave_en
                           ,p_det_ifaddr
                           ,tx_empty_ctrl
                           ,rx_pop_data
                           ,tx_push_data
                           ,fifo_rst_n
                           ,tx_fifo_rst_n
                           ,tx_pop_sync
                           ,rx_push_sync
                           ,rx_pop
                           ,tx_push
                           ,tx_empty
                           ,rx_full
                           ,tx_full
                           ,rx_empty
                           //misc.
                           ,tx_abrt_flg_edg
                           ,abrt_in_rcve_trns
                           ,slv_clr_leftover_flg_edg
                           ,ic_rstrt_en                           
                           ,ic_sda_setup
                           ,ic_sda_hold
                           ,ic_ack_general_call
                           );

   // ------------------------------------------------------
   // -- Port declaration
   // ------------------------------------------------------

   input pclk;                                           // APB clock
   input presetn;                                        // APB async reset
   input wr_en;                                          // write enable
   input rd_en;                                          // read enable
   input                              penable_int;       // internal penable signal
   input [3:0]                       byte_en;            // active byte lane
   input [`IC_ADDR_SLICE_LHS-2:0]     reg_addr;          // register address offset
   input [`MAX_APB_DATA_WIDTH-1:0]    ipwdata;           // internal APB write data
   input [`IC_INTR_STAT_RS-1:0]       ic_intr_stat;
   input [`IC_RAW_INTR_STAT_RS-1:0]   ic_raw_intr_stat;
   input [`IC_DATA_FIFO_RS-1:0]       rx_pop_data;       // data from the rx fifo
   input                              tx_abrt_flg_edg;   // tx aborted transfer
   input                              abrt_in_rcve_trns;     // user abort occured during receive transfer
   input                              slv_clr_leftover_flg_edg;
   input                              tx_pop_sync;       // pclk sync tx fifo pop
   input                              rx_push_sync;      // pclk sync rx fifo push
   input                              tx_empty;          // tx fifo empty status
   input                              rx_full;           // rx fifo full status
   input                              tx_full;           // tx fifo full status
   input                              rx_empty;          // rx fifo empty status
   input                              mst_activity;      // IC module I2C Master activity status
   input                              slv_activity;      // IC module I2C Slave activity status
   input                              activity;          // IC module I2C activity status
   input  [`IC_TX_ABRT_SOURCE_RS-1:0] ic_tx_abrt_source; // tx_abrt sources combined signals
   input                              psel;

   input                              ic_en;
   input                              slv_rx_aborted_sync;    // Slave-Rx aborted due to IC_ENABLE
   input                              slv_fifo_filled_and_flushed_sync; // Slave-Rx data discarded due to IC_ENABLE

   output [`IC_DATA_TX_CMD_RS-1:0]    tx_push_data;         // data to the tx fifo
   output                             rx_pop;               // rx fifo pop
   output                             tx_push;              // tx fifo push
   output                             slave_rdy;            // slave ready signal
   output                             slave_err;            // slave error signal
   output                             fifo_rst_n;           // sync reset for fifo controllers
   output                             tx_fifo_rst_n;        // sync reset for tx controllers
   output [`MAX_APB_DATA_WIDTH-1:0]   iprdata;              // internal APB read data
   output [`IC_ENABLE_RS_INT-1:0]     ic_enable;            // ic is enabled
   output                             ic_clr_intr_en;       // clear all inturrepts
   output                             ic_clr_rx_under_en;   // clear rx_under int.
   output                             ic_clr_rx_over_en;    // clear rx_over int.
   output                             ic_clr_tx_over_en;    // clear tx_over
   output                             ic_clr_rd_req_en;     // clear rd_req int.
   output                             ic_clr_tx_abrt_en;    // clear tx_abrt int.
   output                             ic_clr_rx_done_en;    // clear rx_done int.
   output                             ic_clr_activity_en;   // clear activity int.
   output                             ic_clr_stop_det_en;   // clear stop_det int.
   output                             ic_clr_start_det_en;  // clear start_det int
   output                             ic_clr_gen_call_en;   // clear gen_call int
   output [`IC_TAR_RS_INT-1:0]        ic_tar;               //Target address
   output [`IC_SAR_RS-1:0]            ic_sar;               //slave module address
                                                            // ic_sar_opt_en name is used for decoding signal
                                                            //slave address
   output [`IC_HS_MADDR_RS-1:0]       ic_hs_maddr;//High speed master unique code
   output [`IC_FS_HCNT_RS-1:0]        ic_fs_hcnt;//Fast Speed mode High count register value
   output [`IC_FS_LCNT_RS-1:0]        ic_fs_lcnt;//Fast Speed mode low count register value
   output [`IC_INTR_MASK_RS-1:0]      ic_intr_mask;//Interrupt mask register
   output [`RX_ABW-1:0]               ic_rx_tl_int;//receive threshold
   output [`IC_HS_HCNT_RS-1:0]        ic_hcnt;//Holds the high count of the active mode
   output [`IC_HS_LCNT_RS-1:0]        ic_lcnt;//Holds the low count of the active mode
   output [`IC_TX_TL_RS-1:0]          ic_tx_tl;//transmit empty level
   // jduarte 20110105 begin
   // CRM 9000368180
   // Added outputs for length of suppressed spike
   // in ic_clk cycles
   // The same value is used for FS and SS (ic_fs_spklen)
   output [`IC_FS_SPKLEN_RS-1:0]      ic_fs_spklen;
   output [`IC_HS_SPKLEN_RS-1:0]      ic_hs_spklen;
   // jduarte 20110105 end   
   output                             ic_hs;// ic is in high speed mode
   output                             ic_fs;// ic is in fast speed mode
   output                             ic_ss;// ic is in std. speed mode
   output                             ic_master;// ic is master, logic 0:slave
   output                             ic_10bit_mst;//ic master address is 10 bit
   output                             ic_10bit_slv;//ic slave address is 10 bit
   output                             ic_rstrt_en;// Master can generate re-starts in general
   output                             ic_slave_en;//1: slave is enabled, 0:disabled
   output                             p_det_ifaddr;// programmable option to detect Stop interrupt only if slave is addressed
   output                             tx_empty_ctrl;// TX FIFO empty interrupt control

   output [`IC_SDA_SETUP_RS-1:0]      ic_sda_setup;

// Adding IC_SDA_RX_HOLD_RS (8 bits) for calculating hold time while I2C acts as reciever
// ic_sda_hold[15:0] Used as transmit hold time
// ic_sda_hold[23:16] Used as recieve hold time
   output [`IC_SDA_HOLD_RS-1:0]       ic_sda_hold; 
   output                             ic_ack_general_call;

   // ----------------------------------------------------------
   // -- local registers and wires
   // ----------------------------------------------------------
   //wires
   wire [7:0]                         rx_fifo_depth;
   wire [7:0]                         tx_fifo_depth;
   // read write enable signals
   wire                               ic_tx_abrt_source_en;

   wire                               wr_en_int;
   wire                               reg_wr_en;
   wire                               reg_rd_en;
   wire                               ic_con_en;
   wire                               ic_con_we;
   wire                               ic_tar_en;
   wire                               ic_tar_we;
   wire                               ic_sar_en;
   wire                               ic_sar_we;
   wire                               ic_hs_maddr_en;
   wire                               ic_hs_maddr_we;
   wire                               ic_data_cmd_en;
   wire                               ic_ss_hcnt_en;
   wire                               ic_ss_lcnt_en;
   wire                               ic_fs_hcnt_en;
   wire                               ic_fs_lcnt_en;
   wire                               ic_hs_hcnt_en;
   wire                               ic_hs_lcnt_en;
   wire                               ic_ss_hcnt_we;
   wire                               ic_ss_lcnt_we;
   wire                               ic_fs_hcnt_we;
   wire                               ic_fs_lcnt_we;
   wire                               ic_hs_hcnt_we;
   wire                               ic_hs_lcnt_we;
   // jduarte 20110105 begin
   // CRM 9000368180
   // Added enable and write enable control signals for registers
   // setting the length of suppressed spike
   wire                               ic_fs_spklen_en;
   wire                               ic_fs_spklen_we;
   wire                               ic_hs_spklen_en;
   wire                               ic_hs_spklen_we;   
   // jduarte 20110105   
   wire                               ic_intr_stat_en;
   wire                               ic_intr_mask_en;
   wire                               ic_intr_mask_we;
   wire                               ic_raw_intr_stat_en;
   wire                               ic_rx_tl_en;
   wire                               ic_rx_tl_we;
   wire                               ic_tx_tl_en;
   wire                               ic_tx_tl_we;
   wire                               ic_clr_intr_en;
   wire                               ic_clr_rx_over_en;
   wire                               ic_clr_rx_under_en;
   wire                               ic_clr_tx_over_en;
   wire                               ic_clr_tx_abrt_en;
   wire                               ic_clr_rx_done_en;
   wire                               ic_clr_rd_req_en;
   wire                               ic_clr_activity_en;
   wire                               ic_clr_stop_det_en;
   wire                               ic_clr_start_det_en;
   wire                               ic_clr_gen_call_en;
   wire                               ic_enable_en;
   wire                               ic_enable_we;

   wire                               ic_status_en;
   wire                               ic_txflr_en;
   wire                               ic_rxflr_en;

   wire                               ic_comp_param_1_en;
   wire                               ic_comp_version_en;
   wire                               ic_comp_type_en;
   wire                               ic_sda_setup_en;
   wire                               ic_sda_setup_we;
   wire                               ic_ack_general_call_en;
   wire                               ic_ack_general_call_we;
   wire                               ic_enable_status_en;
   wire [`IC_ENABLE_STATUS_RS-1:0]    ic_enable_status;
   wire                               ic_sda_hold_en;
   wire                               ic_sda_hold_we;

   wire [31:0]                        ic_comp_param_1;
   wire [31:0]                        ic_comp_version;
   wire [31:0]                        ic_comp_type;

   wire [1:0]                         speed;
   wire [`IC_STATUS_RS-1:0]           ic_status;

   wire [`IC_CON_RS-1:0]              ic_con;
   // Registers defintion
   reg [`IC_CON_RS-1:0]               ic_con_pre;
// reuse-pragma   endSub IC_CON_PRE 

   wire [`IC_TAR_RS_INT-1:0]          ic_tar;
   reg [`IC_TAR_RS-1:0]               ic_tar_reg;
   reg [`IC_SAR_RS-1:0]               ic_sar;

   reg [`IC_SS_HCNT_RS-1:0]           r_ic_ss_hcnt;
   reg [`IC_SS_LCNT_RS-1:0]           r_ic_ss_lcnt;
   reg [`IC_FS_HCNT_RS-1:0]           r_ic_fs_hcnt;
   reg [`IC_FS_LCNT_RS-1:0]           r_ic_fs_lcnt;
   reg [`IC_HS_HCNT_RS-1:0]           r_ic_hs_hcnt;
   reg [`IC_HS_LCNT_RS-1:0]           r_ic_hs_lcnt;

   reg [`IC_HS_MADDR_RS-1:0]          ic_hs_maddr;
// jduarte 20110105 begin
// CRM 9000368180
// Added registers for setting length of suppressed spike
// in ic_clk cycles
// The same value is used for FS and SS (r_ic_fs_spklen)
   reg [`IC_FS_SPKLEN_RS-1:0]         r_ic_fs_spklen;
   reg [`IC_HS_SPKLEN_RS-1:0]         r_ic_hs_spklen;
// jduarte 20110105 end
   
   wire [`IC_SS_HCNT_RS-1:0]          hcr_ic_ss_hcnt;
   wire [`IC_SS_LCNT_RS-1:0]          hcr_ic_ss_lcnt;
   wire [`IC_FS_HCNT_RS-1:0]          hcr_ic_fs_hcnt;
   wire [`IC_FS_LCNT_RS-1:0]          hcr_ic_fs_lcnt;
   wire [`IC_HS_HCNT_RS-1:0]          hcr_ic_hs_hcnt;
   wire [`IC_HS_LCNT_RS-1:0]          hcr_ic_hs_lcnt;

   wire [`IC_SS_HCNT_RS-1:0]          ic_ss_hcnt;
   wire [`IC_SS_LCNT_RS-1:0]          ic_ss_lcnt;
   wire [`IC_FS_HCNT_RS-1:0]          ic_fs_hcnt;
   wire [`IC_FS_LCNT_RS-1:0]          ic_fs_lcnt;
   wire [`IC_HS_HCNT_RS-1:0]          ic_hs_hcnt;
   wire [`IC_HS_LCNT_RS-1:0]          ic_hs_lcnt;
// jduarte 20110105 begin
// CRM 9000368180
// Added wires for length of suppressed spike
// in ic_clk cycles
// The same value is used for FS and SS (ic_fs_spklen)
   wire [`IC_FS_SPKLEN_RS-1:0]        ic_fs_spklen;
   wire [`IC_HS_SPKLEN_RS-1:0]        ic_hs_spklen;
// jduarte 20110105 end

   wire                               fifo_rst_n;
   wire                               fix_a, fix_b, fix_c;
   reg                                fifo_rst_n_int;

   reg [`IC_INTR_MASK_RS-1:0]         ic_intr_mask;
   wire [`IC_ENABLE_RS_INT-1:0]       ic_enable;
   reg [`IC_ENABLE_RS-1:0]            ic_enable_reg;

   reg [`TX_ABW:0]                    ic_txflr;
   reg [`TX_ABW:0]                    ic_txflr_flushed;
   reg [`RX_ABW:0]                    ic_rxflr;
   reg [`IC_SDA_SETUP_RS-1:0]         ic_sda_setup;

// Adding IC_SDA_RX_HOLD_RS (8 bits) for calculating hold time while I2C acts as reciever
   reg [`IC_SDA_HOLD_RS-1:0]          ic_sda_hold;
   reg                                ic_ack_general_call;


   reg [`IC_HS_HCNT_RS-1:0]           ic_hcnt;//not real regs, to be used in always block
   reg [`IC_HS_LCNT_RS-1:0]           ic_lcnt;//not real regs, to be used in always block
   reg [`IC_RX_TL_RS-1:0]             ic_rx_tl;
   wire [`RX_ABW-1:0]                 ic_rx_tl_int;
   reg [`IC_TX_TL_RS-1:0]             ic_tx_tl;
   reg [`MAX_APB_DATA_WIDTH-1:0]      iprdata;
   reg                                activity_r;
   reg                                mst_activity_r;
   reg                                slv_activity_r;

   reg [`REG_TIMEOUT_WIDTH-1:0]       reg_timeout_rst; // register timeout reset value reg.
   reg [`REG_TIMEOUT_WIDTH-1:0]       reg_timeout;     // register timeout counter register
   reg                                slave_err;       // slave error register.
   reg                                reg_timeout_err_r; // Register timeout delayed.
   wire                               slave_err_int;   // slave error internal wire.
   wire                               slave_errors;    // OR-ed error signals.
   wire                               reg_timeout_err; // register timeout counter flag.
   wire                               slvrd_err;       // read command in slave mode error.
   wire                               mstslv_err;      // Master & Slave simultaneously enabled.
   wire                               reg_ready_low;   // register not ready.
   reg                                slave_rdy;     // slave ready register.
   wire                               psetup_ph;       // slave ready.

   wire                               reg_timeout_rst_en;       // Reg timeout register address decoding enable.
   wire                               reg_timeout_rst_we;       // Reg timeout register write enable.


   wire [`IC_TAR_RS-1:0]               ic_tar_int;
   wire [`IC_SAR_RS-1:0]               ic_sar_int;
   wire [`IC_INTR_MASK_RS-1:0]         ic_intr_mask_int;
   wire [`IC_SDA_HOLD_RS-1:0]          ic_sda_hold_int;

   wire               ic_hs;
   wire               ic_fs;
   wire               ic_ss;

   // ------------------------------------------------------
   // -- Address decoder
   //
   //  Decodes the register address offset input(reg_addr)
   //  to produce enable (select) signals for each of the
   //  SW-registers in the macrocell
   // ------------------------------------------------------
   assign ic_con_en                 = ({2'b00,reg_addr} == (`IC_CON_OS                >> 2));
   assign ic_tar_en                 = ({2'b00,reg_addr} == (`IC_TAR_OS                >> 2));
   assign ic_sar_en                 = ({2'b00,reg_addr} == (`IC_SAR_OS                >> 2));
   assign ic_data_cmd_en            = ({2'b00,reg_addr} == (`IC_DATA_CMD_OS           >> 2));
   assign ic_ss_hcnt_en             = ({2'b00,reg_addr} == (`IC_SS_HCNT_OS            >> 2));
   assign ic_ss_lcnt_en             = ({2'b00,reg_addr} == (`IC_SS_LCNT_OS            >> 2));
   assign ic_fs_hcnt_en             = ({2'b00,reg_addr} == (`IC_FS_HCNT_OS            >> 2));
   assign ic_fs_lcnt_en             = ({2'b00,reg_addr} == (`IC_FS_LCNT_OS            >> 2));
   assign ic_hs_maddr_en            = ({2'b00,reg_addr} == (`IC_HS_MADDR_OS           >> 2));
   assign ic_hs_hcnt_en             = ({2'b00,reg_addr} == (`IC_HS_HCNT_OS            >> 2));
   assign ic_hs_lcnt_en             = ({2'b00,reg_addr} == (`IC_HS_LCNT_OS            >> 2));
   assign ic_intr_stat_en           = ({2'b00,reg_addr} == (`IC_INTR_STAT_OS          >> 2));
   assign ic_intr_mask_en           = ({2'b00,reg_addr} == (`IC_INTR_MASK_OS          >> 2));
   assign ic_raw_intr_stat_en       = ({2'b00,reg_addr} == (`IC_RAW_INTR_STAT_OS      >> 2));
   assign ic_rx_tl_en               = ({2'b00,reg_addr} == (`IC_RX_TL_OS              >> 2));
   assign ic_tx_tl_en               = ({2'b00,reg_addr} == (`IC_TX_TL_OS              >> 2));
   assign ic_clr_intr_en            = ({2'b00,reg_addr} == (`IC_CLR_INTR_OS           >> 2));
   assign ic_clr_rx_under_en        = ({2'b00,reg_addr} == (`IC_CLR_RX_UNDER_OS       >> 2));
   assign ic_clr_rx_over_en         = ({2'b00,reg_addr} == (`IC_CLR_RX_OVER_OS        >> 2));
   assign ic_clr_tx_over_en         = ({2'b00,reg_addr} == (`IC_CLR_TX_OVER_OS        >> 2));
   assign ic_clr_rd_req_en          = ({2'b00,reg_addr} == (`IC_CLR_RD_REQ_OS         >> 2));
   assign ic_clr_tx_abrt_en         = ({2'b00,reg_addr} == (`IC_CLR_TX_ABRT_OS        >> 2));
   assign ic_clr_rx_done_en         = ({2'b00,reg_addr} == (`IC_CLR_RX_DONE_OS        >> 2));
   assign ic_clr_activity_en        = ({2'b00,reg_addr} == (`IC_CLR_ACTIVITY_OS       >> 2));
   assign ic_clr_stop_det_en        = ({2'b00,reg_addr} == (`IC_CLR_STOP_DET_OS       >> 2));
   assign ic_clr_start_det_en       = ({2'b00,reg_addr} == (`IC_CLR_START_DET_OS      >> 2));
   assign ic_clr_gen_call_en        = ({2'b00,reg_addr} == (`IC_CLR_GEN_CALL_OS       >> 2));
   assign ic_enable_en              = ({2'b00,reg_addr} == (`IC_ENABLE_OS             >> 2));
   assign ic_status_en              = ({2'b00,reg_addr} == (`IC_STATUS_OS             >> 2));
   assign ic_txflr_en               = ({2'b00,reg_addr} == (`IC_TXFLR_OS              >> 2));
   assign ic_rxflr_en               = ({2'b00,reg_addr} == (`IC_RXFLR_OS              >> 2));
   assign ic_tx_abrt_source_en      = ({2'b00,reg_addr} == (`IC_TX_ABRT_SOURCE_OS     >> 2));
   assign ic_comp_param_1_en        = ({2'b00,reg_addr} == (`IC_COMP_PARAM_1_OS       >> 2));
   assign ic_comp_version_en        = ({2'b00,reg_addr} == (`IC_COMP_VERSION_OS       >> 2));
   assign ic_comp_type_en           = ({2'b00,reg_addr} == (`IC_COMP_TYPE_OS          >> 2));
   assign ic_sda_setup_en           = ({2'b00,reg_addr} == (`IC_SDA_SETUP_OS          >> 2));
   assign ic_ack_general_call_en    = ({2'b00,reg_addr} == (`IC_ACK_GENERAL_CALL_OS   >> 2));
   assign ic_enable_status_en       = ({2'b00,reg_addr} == (`IC_ENABLE_STATUS_OS      >> 2));
   assign ic_sda_hold_en            = ({2'b00,reg_addr} == (`IC_SDA_HOLD_OS           >> 2));

// configure wr_en_int for error_response disable by assigning values fom wr_en.
   assign wr_en_int       = penable_int & wr_en;
   //#reg_wr_en_signal goes high in the last cycle of a write transfer if timeout error is not triggered.
   //#reg_rd_en_signal is active when register is ready and when rd_en=1 in case
   //#it is the first transaction cycle or it is the cycle where reg_ready_low_signal has just gone low.
   assign reg_wr_en       = wr_en & penable_int & slave_rdy & (!reg_timeout_err_r);
   assign reg_rd_en       = rd_en & (!reg_ready_low) & ( !penable_int | (!slave_rdy & (!reg_timeout_err)) );


//# ------------------------------------------------------
//#  Write enable signals for writeable SW-registers.
//# ------------------------------------------------------
   assign ic_con_we       = ic_con_en       & wr_en_int;
   assign ic_tar_we       = ic_tar_en       & wr_en_int;
   assign ic_sar_we       = ic_sar_en       & wr_en_int;
   assign ic_hs_maddr_we  = ic_hs_maddr_en  & wr_en_int;

   assign ic_ss_hcnt_we   = ic_ss_hcnt_en   & wr_en_int;
   assign ic_ss_lcnt_we   = ic_ss_lcnt_en   & wr_en_int;
   assign ic_fs_hcnt_we   = ic_fs_hcnt_en   & wr_en_int;
   assign ic_fs_lcnt_we   = ic_fs_lcnt_en   & wr_en_int;
   assign ic_hs_hcnt_we   = ic_hs_hcnt_en   & wr_en_int;
   assign ic_hs_lcnt_we   = ic_hs_lcnt_en   & wr_en_int;

   assign ic_intr_mask_we = ic_intr_mask_en & wr_en_int;
   assign ic_rx_tl_we     = ic_rx_tl_en     & wr_en_int;
   assign ic_tx_tl_we     = ic_tx_tl_en     & wr_en_int;
   assign ic_enable_we    = ic_enable_en    & wr_en_int;
   assign ic_sda_setup_we = ic_sda_setup_en & wr_en_int;
   assign ic_sda_hold_we  = ic_sda_hold_en  & wr_en_int;
   assign ic_ack_general_call_we = ic_ack_general_call_en & wr_en_int;

   assign rx_pop     = (byte_en[0] == 1'b1 && ic_data_cmd_en == 1'b1 && reg_rd_en == 1'b1) ? 1'b1 : 1'b0;
   assign tx_push    = (byte_en[1] == 1'b1 && ic_data_cmd_en == 1'b1 && reg_wr_en == 1'b1) ? 1'b1 : 1'b0;

// jduarte 20110105 begin
// CRM 9000368180
// Added enable and write enable control signals for registers
// setting the length of suppressed spike
   assign ic_fs_spklen_en = ({2'b00,reg_addr} == (`IC_FS_SPKLEN_OS >> 2));
   assign ic_fs_spklen_we = ic_fs_spklen_en & wr_en_int;
   assign ic_hs_spklen_en = ({2'b00,reg_addr} == (`IC_HS_SPKLEN_OS >> 2));
   assign ic_hs_spklen_we = ic_hs_spklen_en & wr_en_int;

   assign reg_timeout_rst_en = ({2'b00,reg_addr} == (`REG_TIMEOUT_RST_OS >> 2));
   assign reg_timeout_rst_we = reg_timeout_rst_en & wr_en_int;

  // ------------------------------------------------------
  // -- SLAVE_RDY REGISTER
  // Register that indicates ready status of slave
  // A high on the register in Access phase indicates end of transaction.
  // ------------------------------------------------------
  assign reg_ready_low   = ic_data_cmd_en  & ( (tx_full & wr_en) | (rx_empty & rd_en) );
  
  always @ (posedge pclk or negedge presetn) begin : SLAVE_RDY_PROC
    if (presetn == 1'b0) begin
        slave_rdy <= 1'b1;
    end else begin
      if ((ic_data_cmd_en == 1'b0) || (mstslv_err == 1'b1) || (slvrd_err ==1'b1))   begin
        slave_rdy <= 1'b1;
      end else if (reg_timeout_err == 1'b1) begin
        slave_rdy <= 1'b1;
      end else begin
        if (psetup_ph == 1'b1) begin  
          slave_rdy <= !(reg_ready_low);
        end else begin
          if (reg_ready_low == 1'b0) begin  
            slave_rdy <= 1'b1;  
          end    
        end  
      end
    end
  end // SLAVE_RDY_PROC

  assign psetup_ph = (penable_int == 1'b0); 


  // ------------------------------------------------------
  // -- REG_TIMEOUT REGISTER
  // CountDown Register for transfer timeout when slave is not able to complete transfer
  // The counter counts down from a reset value until slave becomes ready or timeout is reached.
  // ------------------------------------------------------
  always @ (posedge pclk or negedge presetn) begin : REG_TIMEOUT_PROC
    if (presetn == 1'b0) begin
      reg_timeout <= `REG_TIMEOUT_VALUE;
    end else begin
      if (penable_int == 1'b0) begin
        reg_timeout <= reg_timeout_rst;
      end else if ((slave_rdy == 1'b0) && (penable_int == 1'b1)) begin
        if (reg_timeout != {(`REG_TIMEOUT_WIDTH){1'b0}}) begin
          reg_timeout <= reg_timeout - {{(`REG_TIMEOUT_WIDTH-1){1'b0}}, 1'b1};
        end
      end
    end // RESET not active
  end // IC_HAS_POSITIVE_REG_TIMEOUT_WIDTH

  assign mstslv_err    = ((ic_con_en==1'b1) && (wr_en==1'b1) && (ic_enable[0]==1'b0) && (byte_en[0]==1'b1) && (ipwdata[0]!=ipwdata[6])) ? 1'b1 : 1'b0;
 
  assign slvrd_err     = ((ic_data_cmd_en==1'b1) && (wr_en==1'b1) && (ic_enable[0]==1'b1) && (ic_con[6]==1'b0) && (byte_en[1]==1'b1) && (ipwdata[8]==1'b1)) ? 1'b1 : 1'b0;

  // assign reg_timeout_err = !(|reg_timeout);
  assign reg_timeout_err = (reg_timeout_rst == {{(`REG_TIMEOUT_WIDTH-1){1'b0}}, 1'b1}) ? (reg_ready_low & penable_int & ic_data_cmd_en) : ((reg_timeout == {{(`REG_TIMEOUT_WIDTH-1){1'b0}}, 1'b1}) && (ic_data_cmd_en == 1'b1) && (penable_int == 1'b1));

  assign slave_errors  = ((mstslv_err | slvrd_err | (reg_timeout_err & ic_data_cmd_en))==1'b1) ? 1'b1 : 1'b0;
  assign slave_err_int = slave_err;
 
  always @(posedge pclk or negedge presetn) begin : SLAVE_ERR_PROC
    if(presetn == 1'b0) begin
      slave_err <= 1'b0;
      reg_timeout_err_r <= 1'b0;
    end else begin
      reg_timeout_err_r <= reg_timeout_err;   
      if (slave_err_int == 1'b1) begin
        slave_err <= 1'b0;
      end else begin
        slave_err <= (slave_errors & psel);
      end        
      // slave_err <= slave_err_int ? 1'b0 : ( slave_errors & psel & (!penable) );
    end
  end // SLAVE_ERR_PROC      


// jduarte 20110105   
   
  // ------------------------------------------------------
  // -- Status Register - Read Only
  //
  //  5-bit register
  //
  //  The bits of this regsiter 'ic_status' reflect the status
  //  of the FIFO buffers and the activity of I2C bus.
  //  Registers bits are set/reset by hardware.
  //
  //  This register is split into the following bit fields
  //
  //  [4] - RFF  - Receive FIFO Full Status
  //  [3] - RFNE - Receive FIFO Not Empty Status
  //  [2] - TFE  - Transmit FIFO Empty Status
  //  [1] - TFNE - Transmit FIFO Not Full Status
  //  [0] - Activity - I2C activity  Status
  //
  // ------------------------------------------------------
  always @(posedge pclk or negedge presetn) begin : activity_r_PROC
    if(presetn == 1'b0) begin
      activity_r     <=  1'b0;
      mst_activity_r <=  1'b0;
      slv_activity_r <=  1'b0;
    end else begin
      activity_r     <= activity;
      slv_activity_r <= slv_activity;
      mst_activity_r <= mst_activity;
    end
  end



  assign ic_status[6]  = (slv_activity_r == 1'b1);
  assign ic_status[5]  = (mst_activity_r == 1'b1);
  assign ic_status[4]  = (rx_full     == 1'b1);
  assign ic_status[3]  = (rx_empty    == 1'b0);
  assign ic_status[2]  = (tx_empty    == 1'b1);
  assign ic_status[1]  = (tx_full     == 1'b0);
  assign ic_status[0]  = (activity_r  == 1'b1);

  // ------------------------------------------------------
  // ic_enable_status register - Read-only
  //
  // The bit of this register reflect the status of the
  // operating status of the DW_apb_i2c, particularly in
  // response to the setting of the IC_ENABLE bit to "0".
  //
  // [0] - ic_en
  // [1] - slave receive aborted (negative ACK)
  // [2] - slave RxFIFO filled and flushed
  // ------------------------------------------------------

  assign ic_enable_status[0] = ic_en;
  assign ic_enable_status[1] = slv_rx_aborted_sync;
  assign ic_enable_status[2] = slv_fifo_filled_and_flushed_sync;

  // ------------------------------------------------------
  // -- Tx FIFO level Register - Read Only
  //
  //  This register contains the number of valid data
  //  entries in the transmit FIFO buffer.
  //  Registers bits are set/reset by hardware.
  // ------------------------------------------------------
  always @(posedge pclk or negedge presetn) begin : IC_TXFLR_PROC
    if(presetn == 1'b0) begin
      ic_txflr <= { `TX_ABW+1{1'b0} };
    end else begin
      if((ic_enable[0] == 1'b0)  
        || (tx_fifo_rst_n == 1'b0)
       ) begin
        ic_txflr <= { `TX_ABW+1{1'b0} };
      end else begin
        if(tx_push == 1'b1 && tx_pop_sync == 1'b0 && ic_txflr < `IC_TX_BUFFER_DEPTH) begin
          // When data is pushed in the Tx FIFO increment this register
          // Do let this register value exceed the Tx FIFO depth
          ic_txflr <= ic_txflr + {{(`TX_ABW){1'b0}},1'b1};
        end
        else if(tx_push == 1'b0 && tx_pop_sync == 1'b1 && ic_txflr != 0) begin
          // When data is poped from the Tx FIFO decrement this register
          // Do let this register value go below zero
          ic_txflr <= ic_txflr - {{(`TX_ABW){1'b0}},1'b1};
        end
        else if(tx_push == 1'b1 && tx_pop_sync == 1'b1 && ic_txflr == `IC_TX_BUFFER_DEPTH) begin
          // If data is pushed and poped simultaneously from the Tx FIFO if Tx-FIFO is full, 
          // consider only pop but not push since FIFO is already full.
          ic_txflr <= ic_txflr - {{(`TX_ABW){1'b0}},1'b1};
        end
      end
    end
  end

 // ------------------------------------------------------
  // -- Tx FIFO level flushed Register - Read Only
  //
  //  This register contains the number of valid data
  //  entries flushed from the transmit FIFO buffer.
  // ------------------------------------------------------
  always @(posedge pclk or negedge presetn) begin : IC_TXFLR_BKP_PROC
    if(presetn == 1'b0) begin
      ic_txflr_flushed <= { `TX_ABW+1{1'b0} };
    end else begin
      if(ic_enable[0] == 1'b0) begin
        ic_txflr_flushed <= { `TX_ABW+1{1'b0} };
      end
      else if (tx_abrt_flg_edg) begin
        if(abrt_in_rcve_trns)
          ic_txflr_flushed <= ic_txflr + {{(`TX_ABW){1'b0}},1'b1};
        else 
          ic_txflr_flushed <= ic_txflr;
      end
    end
  end

  // ------------------------------------------------------
  // -- Rx FIFO level Register - Read Only
  //
  //  This register contians the number of valid data
  //  entries in the receive FIFO buffer.
  //  Registers bits are set/reset by hardware.
  // ------------------------------------------------------
  always @(posedge pclk or negedge presetn) begin : IC_RXFLR_PROC
    if(presetn == 1'b0) begin
      ic_rxflr <= { `RX_ABW+1{1'b0} };
    end else begin
       if((ic_enable[0] == 1'b0)
          || (fifo_rst_n == 1'b0)
         ) begin       
        ic_rxflr <= { `RX_ABW+1{1'b0} };
      end else begin
        if(rx_push_sync == 1'b1 && rx_pop == 1'b0 && ic_rxflr < `IC_RX_BUFFER_DEPTH) begin
          // When data is pushed in the Rx FIFO increment this register
          // Do let this register value exceed the Rx FIFO depth
          ic_rxflr <= ic_rxflr + {{(`RX_ABW){1'b0}},1'b1};
        end else begin
          if(rx_push_sync == 1'b0 && rx_pop == 1'b1 && ic_rxflr != 0) begin
            // When data is poped from the Rx FIFO decrement this register
            // Do let this register value go below zero
            ic_rxflr <= ic_rxflr - {{(`RX_ABW){1'b0}},1'b1};
          end
        end
      end
    end
  end


  // ------------------------------------------------------
  // -- IC_ENABLE register
  //
  // -- Write control for 'icenable'
  // -- Can be written unless IC_ENABLE = '0'
  // -- Can never write a zero.
  // ------------------------------------------------------
  always @(posedge pclk or negedge presetn) begin:IC_ENABLE_PROC
     if(presetn == 1'b0) begin
          ic_enable_reg <= {`IC_ENABLE_RS{1'b0}};
     end else begin
        if ((ic_enable_we == 1'b1) && (byte_en[0] == 1'b1)) begin
           //ic_enable_reg[`IC_ENABLE_RS-1:0] <= ipwdata[`IC_ENABLE_RS-1:0];
           // 9000521680 : Abort
           ic_enable_reg[0] <= ipwdata[0];
           if (!ic_enable_reg[1] & ipwdata[1])
             ic_enable_reg[1] <= ic_enable[0];
           else if (tx_abrt_flg_edg)
             ic_enable_reg[1] <= 1'b0;
        end
        else if (tx_abrt_flg_edg)
          ic_enable_reg[1] <= 1'b0;
     end
  end
  assign ic_enable = ic_enable_reg[`IC_ENABLE_RS_INT-1:0];

      

  // ------------------------------------------------------
  // -- IC_CON register
  //
  // -- Write control for 'ic_con'
  // -- Can't be written unless IC_ENABLE[0] = '0'
  // -- Can never write a zero.
  // -- If I2C_DYNAMIC_TAR_UPDATE mode is enabled IC_CON[4] is read only
  // ------------------------------------------------------

//  always @(posedge pclk or negedge presetn) begin: IC_CON_PROC
//     if(presetn == 1'b0) begin
//        ic_con_pre <= {`IC_SLAVE_DISABLE, `IC_RESTART_EN,`IC_10BITADDR_MASTER,`IC_10BITADDR_SLAVE,`IC_MAX_SPEED_MODE,`IC_MASTER_MODE};
//     end else begin
//        if ((ic_con_we == 1'b1) && (byte_en[0] == 1'b1) && (ic_enable[0] == 1'b0))
//          begin
//             if ((ipwdata[2:1] != 2'b00) && ( ipwdata[2:1] <= (`IC_MAX_SPEED_MODE)))
//               ic_con_pre[2:1] <= ipwdata[2:1];
//             else
//               ic_con_pre[2:1] <= `IC_MAX_SPEED_MODE;

//             ic_con_pre[0] <= ipwdata[0];
//             ic_con_pre[3] <= ipwdata[3];
//             ic_con_pre[`IC_CON_RS-1:5] <= ipwdata[`IC_CON_RS-1:5];

//             if(`I2C_DYNAMIC_TAR_UPDATE)
//              ic_con_pre[4] <= `IC_10BITADDR_MASTER;
//             else
//               ic_con_pre[4] <= ipwdata[4];
//          end
//     end
//  end

  always @(posedge pclk or negedge presetn) begin: IC_CON_PROC
    if(presetn == 1'b0) begin
       ic_con_pre <= {2'b00, `IC_SLAVE_DISABLE, `IC_RESTART_EN,`IC_10BITADDR_MASTER,`IC_10BITADDR_SLAVE,`IC_MAX_SPEED_MODE,`IC_MASTER_MODE};
    end
    else begin
      if ((ic_con_we == 1'b1) && (ic_enable[0] == 1'b0)) begin
        if (byte_en[1:0] == 2'b10) begin
          ic_con_pre[`IC_CON_RS-1] <= ipwdata[0];
        end
        else if((byte_en[3:0] != 4'b0100) && (byte_en[3:0] != 4'b1000) && (byte_en[3:0] != 4'b1100))  begin
          ic_con_pre[0] <= ipwdata[0];

          if ((ipwdata[2:1] != 2'b00) && ( ipwdata[2:1] <= (`IC_MAX_SPEED_MODE)))
            ic_con_pre[2:1] <= ipwdata[2:1];
          else
            ic_con_pre[2:1] <= `IC_MAX_SPEED_MODE;

          ic_con_pre[3] <= ipwdata[3];

            ic_con_pre[4] <= ipwdata[4];

          ic_con_pre[7:5] <= ipwdata[7:5];

          if (byte_en[1:0] == 2'b11)
            ic_con_pre[`IC_CON_RS-1] <= ipwdata[8];
        end   
      end
    end
  end


   assign ic_con[8:0] = ic_con_pre[8:0];







   assign speed = ic_con[2:1];



   // ------------------------------------------------------
   // -- IC_TAR register
   //
   // -- Write control for 'ic_sar'
   // -- Can't be written unless IC_ENABLE[0] = '0'
   // -- Or a dy_wr_mode_en (i.e. dynamic tar update) occurs
   // -- Can never write a zero.
   // ------------------------------------------------------
   // Reset value for bit 12, address format, 10 or 7 bit.

   // 9000234850 : False FM_1_4: Do not assign signal/variable to
   // asynchronous set/reset.
   always @(posedge pclk or negedge presetn) begin: IC_TAR_REG_PROC
     if(presetn == 1'b0)
       ic_tar_reg <= {
                  2'b0,
                  `IC_DEFAULT_TAR_SLAVE_ADDR
        };
     else begin
       if ( (
         (!ic_enable[0]) ) && (ic_tar_we == 1'b1)) begin
         case(byte_en)
           4'b0001 : ic_tar_reg[7:0] <= ipwdata[7:0];
           4'b0010 : ic_tar_reg[`IC_TAR_RS-1:8] <= ipwdata[`IC_TAR_RS-1-8:0];
           4'b0011 : ic_tar_reg[`IC_TAR_RS-1:0] <= ipwdata[`IC_TAR_RS-1:0];
           4'b1111 : ic_tar_reg[`IC_TAR_RS-1:0] <= ipwdata[`IC_TAR_RS-1:0];
           default : ic_tar_reg[`IC_TAR_RS-1:0] <= ic_tar_int[`IC_TAR_RS-1:0];
         endcase 
       end
     end
   end


   assign ic_tar_int = ic_tar_reg;
   assign ic_tar     = ic_tar_reg[`IC_TAR_RS_INT-1:0];

   // -- IC_SAR register
   //
   // -- Write control for 'ic_sar'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // -- Can never write a zero.
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin: IC_SAR_REG_PROC
     if(presetn == 1'b0)
       ic_sar <= `IC_SAR_IN;
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_sar_we == 1'b1)) begin
           case(byte_en)
             4'b0001 : ic_sar[7:0] <= ipwdata[7:0];
             4'b0010 : ic_sar[`IC_SAR_RS-1:8] <= ipwdata[`IC_SAR_RS-1-8:0];
             4'b0011 : ic_sar[`IC_SAR_RS-1:0] <= ipwdata[`IC_SAR_RS-1:0];
             4'b1111 : ic_sar[`IC_SAR_RS-1:0] <= ipwdata[`IC_SAR_RS-1:0];
             default : ic_sar[`IC_SAR_RS-1:0] <= ic_sar_int[`IC_SAR_RS-1:0];
           endcase
        end
     end
   end
    
   assign ic_sar_int = ic_sar;


   // ------------------------------------------------------
   // -- IC_HS_MADDR register
   //
   // -- Write control for 'ic_hs_maddr'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin:IC_HS_MADDR_PROC
      if(presetn == 1'b0) begin
         ic_hs_maddr <= `IC_HS_MADDR_IN;
      end else begin
         if ((ic_hs_maddr_we == 1'b1) && (byte_en[0] == 1'b1) && (ic_enable[0] == 1'b0)) begin
            ic_hs_maddr[`IC_HS_MADDR_RS-1:0] <= ipwdata[`IC_HS_MADDR_RS-1:0];
         end
      end
   end


   assign tx_push_data    = (byte_en == 4'b0010) ? { ipwdata[0],   8'h00 } : ipwdata[8:0];
  // jduarte end 20101108

  // Need to eliminate the registers when they are not required.
   assign hcr_ic_ss_hcnt = r_ic_ss_hcnt  ;
   assign hcr_ic_ss_lcnt = r_ic_ss_lcnt  ;
   assign hcr_ic_fs_hcnt = r_ic_fs_hcnt  ;
   assign hcr_ic_fs_lcnt = r_ic_fs_lcnt  ;
   assign hcr_ic_hs_hcnt = r_ic_hs_hcnt  ;
   assign hcr_ic_hs_lcnt = r_ic_hs_lcnt  ;


   assign ic_ss_hcnt = hcr_ic_ss_hcnt ;
   assign ic_ss_lcnt = hcr_ic_ss_lcnt ;
   assign ic_fs_hcnt = hcr_ic_fs_hcnt ;
   assign ic_fs_lcnt = hcr_ic_fs_lcnt ;
   assign ic_hs_hcnt = hcr_ic_hs_hcnt ;
   assign ic_hs_lcnt = hcr_ic_hs_lcnt ;
   // jduarte 20110105 begin  
   // CRM 9000368180
   assign ic_fs_spklen = r_ic_fs_spklen;   
   assign ic_hs_spklen = r_ic_hs_spklen;   
   // jduarte 20110105 end  

   //spyglass disable_block W415a
   //SMD: Signal may be multiply assigned (beside initialization) in the same scope
   //SJ:  This implmentation is as per the design requirement. 
   //     There will not be any functional issue.
   //spyglass disable_block STARC05-2.2.3.3
   //SMD: Do not assign over the same signal in an always construct for sequential circuits
   //SJ:  This implmentation is as per the design requirement. 
   //     There will not be any functional issue.
   // ------------------------------------------------------
   // -- IC_SS_HCNT register
   //
   // -- Write control for 'ic_ss_hcnt'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // -- Can never write a zero.
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_SS_HCNT_REG_PROC
     if(presetn == 1'b0) begin
       r_ic_ss_hcnt <= `IC_SS_HCNT_IN;
     end
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_ss_hcnt_we == 1'b1)) begin
           case(byte_en)
             4'b0001 : r_ic_ss_hcnt[7:0] <= ipwdata[7:0];
             4'b0010 :
               begin
                  if({ipwdata[`IC_SS_HCNT_RS-1-8:0], ic_ss_hcnt[7:0]} >= `IC_HCNT_LO_LIMIT)
                    r_ic_ss_hcnt[`IC_SS_HCNT_RS-1:8] <= ipwdata[`IC_SS_HCNT_RS-1-8:0];
                  else
                    r_ic_ss_hcnt <= `IC_HCNT_LO_LIMIT;
               end

             4'b0011 : r_ic_ss_hcnt[`IC_SS_HCNT_RS-1:0] <= (ipwdata[`IC_SS_HCNT_RS-1:0] >= `IC_HCNT_LO_LIMIT) ? ipwdata[`IC_SS_HCNT_RS-1:0]: `IC_HCNT_LO_LIMIT;
             4'b1111 : r_ic_ss_hcnt[`IC_SS_HCNT_RS-1:0] <= (ipwdata[`IC_SS_HCNT_RS-1:0] >= `IC_HCNT_LO_LIMIT) ? ipwdata[`IC_SS_HCNT_RS-1:0]: `IC_HCNT_LO_LIMIT;
             default : r_ic_ss_hcnt[`IC_SS_HCNT_RS-1:0] <= ic_ss_hcnt[`IC_SS_HCNT_RS-1:0];
           endcase
        end
     end
   end

   // ------------------------------------------------------
   // -- IC_SS_LCNT register
   //
   // -- Write control for 'ic_ss_lcnt'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // -- Can never write a zero.
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_SS_LCNT_REG_PROC
       if(presetn == 1'b0) begin
       r_ic_ss_lcnt <= `IC_SS_LCNT_IN;
     end
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_ss_lcnt_we == 1'b1)) begin
           case(byte_en)
             4'b0001 : r_ic_ss_lcnt[7:0] <= ipwdata[7:0];
             4'b0010 :
               begin
                  if({ipwdata[`IC_SS_LCNT_RS-1-8:0], ic_ss_lcnt[7:0]} >= `IC_LCNT_LO_LIMIT)
                    r_ic_ss_lcnt[`IC_SS_LCNT_RS-1:8] <= ipwdata[`IC_SS_LCNT_RS-1-8:0];
                  else
                    r_ic_ss_lcnt <= `IC_LCNT_LO_LIMIT;
               end

             4'b0011 : r_ic_ss_lcnt[`IC_SS_LCNT_RS-1:0] <= (ipwdata[`IC_SS_LCNT_RS-1:0] >= `IC_LCNT_LO_LIMIT)? ipwdata[`IC_SS_LCNT_RS-1:0]: `IC_LCNT_LO_LIMIT;
             4'b1111 : r_ic_ss_lcnt[`IC_SS_LCNT_RS-1:0] <= (ipwdata[`IC_SS_LCNT_RS-1:0] >= `IC_LCNT_LO_LIMIT) ? ipwdata[`IC_SS_LCNT_RS-1:0] : `IC_LCNT_LO_LIMIT;
             default : r_ic_ss_lcnt[`IC_SS_LCNT_RS-1:0] <= ic_ss_lcnt[`IC_SS_LCNT_RS-1:0];
           endcase
        end
     end
   end

   // ------------------------------------------------------
   // -- IC_FS_HCNT register
   //
   // -- Write control for 'ic_fs_hcnt'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // -- Can never write a zero.
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_FS_HCNT_REG_PROC
     if(presetn == 1'b0)
       r_ic_fs_hcnt <= `IC_FS_HCNT_IN;
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_fs_hcnt_we == 1'b1)) begin
           case(byte_en)
             4'b0001 : r_ic_fs_hcnt[7:0] <= ipwdata[7:0];
             4'b0010 :
               begin
                  if({ipwdata[`IC_FS_HCNT_RS-1-8:0], ic_fs_hcnt[7:0]} >= `IC_HCNT_LO_LIMIT)
                    r_ic_fs_hcnt[`IC_FS_HCNT_RS-1:8] <= ipwdata[`IC_FS_HCNT_RS-1-8:0];
                  else
                    r_ic_fs_hcnt <= `IC_HCNT_LO_LIMIT;
               end

             4'b0011 : r_ic_fs_hcnt[`IC_FS_HCNT_RS-1:0] <= (ipwdata[`IC_FS_HCNT_RS-1:0] >= `IC_HCNT_LO_LIMIT)? ipwdata[`IC_FS_HCNT_RS-1:0]: `IC_HCNT_LO_LIMIT;
             4'b1111 : r_ic_fs_hcnt[`IC_FS_HCNT_RS-1:0] <= (ipwdata[`IC_FS_HCNT_RS-1:0] >= `IC_HCNT_LO_LIMIT) ? ipwdata[`IC_FS_HCNT_RS-1:0] : `IC_HCNT_LO_LIMIT;
             default : r_ic_fs_hcnt[`IC_FS_HCNT_RS-1:0] <= ic_fs_hcnt[`IC_FS_HCNT_RS-1:0];

           endcase
        end
     end
   end




   // ------------------------------------------------------
   // -- IC_FS_LCNT register
   //
   // -- Write control for 'ic_fs_lcnt'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // -- Can never write a zero.
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_FS_LCNT_REG_PROC
     if(presetn == 1'b0)
       r_ic_fs_lcnt <= `IC_FS_LCNT_IN;
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_fs_lcnt_we == 1'b1)) begin
           case(byte_en)
             4'b0001 : r_ic_fs_lcnt[7:0] <= ipwdata[7:0];
             4'b0010 :
               begin
                  if({ipwdata[`IC_FS_LCNT_RS-1-8:0], ic_fs_lcnt[7:0]} >= `IC_LCNT_LO_LIMIT)
                    r_ic_fs_lcnt[`IC_FS_LCNT_RS-1:8] <= ipwdata[`IC_FS_LCNT_RS-1-8:0];
                  else
                    r_ic_fs_lcnt <= `IC_LCNT_LO_LIMIT;
               end

             4'b0011 : r_ic_fs_lcnt[`IC_FS_LCNT_RS-1:0] <= (ipwdata[`IC_FS_LCNT_RS-1:0] >= `IC_LCNT_LO_LIMIT)? ipwdata[`IC_FS_LCNT_RS-1:0]: `IC_LCNT_LO_LIMIT;
             4'b1111 : r_ic_fs_lcnt[`IC_FS_LCNT_RS-1:0] <= (ipwdata[`IC_FS_LCNT_RS-1:0] >= `IC_LCNT_LO_LIMIT) ? ipwdata[`IC_FS_LCNT_RS-1:0] : `IC_LCNT_LO_LIMIT;
             default : r_ic_fs_lcnt[`IC_FS_LCNT_RS-1:0] <= ic_fs_lcnt[`IC_FS_LCNT_RS-1:0];
           endcase
        end
     end
   end

   // ------------------------------------------------------
   // -- IC_HS_HCNT register
   //
   // -- Write control for 'ic_hs_hcnt'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // -- Can never write a zero.
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_HS_HCNT_REG_PROC
     if(presetn == 1'b0)
       r_ic_hs_hcnt <= `IC_HS_HCNT_IN;
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_hs_hcnt_we == 1'b1)) begin
           case(byte_en)

             4'b0001 : r_ic_hs_hcnt[7:0] <= ipwdata[7:0];
             4'b0010 :
               begin
                  if({ipwdata[`IC_HS_HCNT_RS-1-8:0], ic_hs_hcnt[7:0]} >= `IC_HCNT_LO_LIMIT)
                    r_ic_hs_hcnt[`IC_HS_HCNT_RS-1:8] <= ipwdata[`IC_HS_HCNT_RS-1-8:0];
                  else
                    r_ic_hs_hcnt <= `IC_HCNT_LO_LIMIT;
               end

             4'b0011 : r_ic_hs_hcnt[`IC_HS_HCNT_RS-1:0] <= (ipwdata[`IC_HS_HCNT_RS-1:0] >= `IC_HCNT_LO_LIMIT)? ipwdata[`IC_HS_HCNT_RS-1:0]: `IC_HCNT_LO_LIMIT;
             4'b1111 : r_ic_hs_hcnt[`IC_HS_HCNT_RS-1:0] <= (ipwdata[`IC_HS_HCNT_RS-1:0] >= `IC_HCNT_LO_LIMIT) ? ipwdata[`IC_HS_HCNT_RS-1:0] : `IC_HCNT_LO_LIMIT;
             default : r_ic_hs_hcnt[`IC_HS_HCNT_RS-1:0] <= ic_hs_hcnt[`IC_HS_HCNT_RS-1:0];
           endcase
        end
     end
   end




   // ------------------------------------------------------
   // -- IC_HS_LCNT register
   //
   // -- Write control for 'ic_hs_lcnt'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // -- Can never write a zero.
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_HS_LCNT_REG_PROC
     if(presetn == 1'b0)
       r_ic_hs_lcnt <= `IC_HS_LCNT_IN;
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_hs_lcnt_we == 1'b1)) begin
           case(byte_en)
             4'b0001 : r_ic_hs_lcnt[7:0] <= ipwdata[7:0];
             4'b0010 :
               begin
                  if({ipwdata[`IC_HS_LCNT_RS-1-8:0], ic_hs_lcnt[7:0]} >= `IC_LCNT_LO_LIMIT)
                    r_ic_hs_lcnt[`IC_HS_LCNT_RS-1:8] <= ipwdata[`IC_HS_LCNT_RS-1-8:0];
                  else
                    r_ic_hs_lcnt <= `IC_LCNT_LO_LIMIT;
               end

             4'b0011 : r_ic_hs_lcnt[`IC_HS_LCNT_RS-1:0] <= (ipwdata[`IC_HS_LCNT_RS-1:0] >= `IC_LCNT_LO_LIMIT)? ipwdata[`IC_HS_LCNT_RS-1:0]: `IC_LCNT_LO_LIMIT;
             4'b1111 : r_ic_hs_lcnt[`IC_HS_LCNT_RS-1:0] <= (ipwdata[`IC_HS_LCNT_RS-1:0] >= `IC_LCNT_LO_LIMIT) ? ipwdata[`IC_HS_LCNT_RS-1:0] : `IC_LCNT_LO_LIMIT;
             default : r_ic_hs_lcnt[`IC_HS_LCNT_RS-1:0] <= ic_hs_lcnt[`IC_HS_LCNT_RS-1:0];
           endcase
        end
     end
   end

  //spyglass enable_block STARC05-2.2.3.3
  //spyglass enable_block W415a

   // jduarte 20110105 begin  
   // CRM 9000368180
   // ic_fs_spklen and ic_hs_spklen registers
   // maximum width of these registers is set to 8 bit because
   // maximum value of IC_FS_SPKLEN and IC_HS_SPKLEN is set to 255
   
   // ------------------------------------------------------
   // -- IC_FS_SPKLEN register
   //
   // -- Write control for 'ic_fs_spklen'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_FS_SPKLEN_REG_PROC
     if(presetn == 1'b0) begin
       r_ic_fs_spklen <= `IC_DEFAULT_FS_SPKLEN;
     end
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_fs_spklen_we == 1'b1)) begin
           case(byte_en)
             4'b0001 : r_ic_fs_spklen[`IC_FS_SPKLEN_RS-1:0] <= (ipwdata[`IC_FS_SPKLEN_RS-1:0] >= `IC_FS_SPKLEN_LO_LIMIT)? ipwdata[`IC_FS_SPKLEN_RS-1:0]: `IC_FS_SPKLEN_LO_LIMIT; 
             4'b0011 : r_ic_fs_spklen[`IC_FS_SPKLEN_RS-1:0] <= (ipwdata[`IC_FS_SPKLEN_RS-1:0] >= `IC_FS_SPKLEN_LO_LIMIT)? ipwdata[`IC_FS_SPKLEN_RS-1:0]: `IC_FS_SPKLEN_LO_LIMIT;
             4'b1111 : r_ic_fs_spklen[`IC_FS_SPKLEN_RS-1:0] <= (ipwdata[`IC_FS_SPKLEN_RS-1:0] >= `IC_FS_SPKLEN_LO_LIMIT)? ipwdata[`IC_FS_SPKLEN_RS-1:0]: `IC_FS_SPKLEN_LO_LIMIT;
             default : r_ic_fs_spklen[`IC_FS_SPKLEN_RS-1:0] <= ic_fs_spklen[`IC_FS_SPKLEN_RS-1:0];
           endcase
        end
     end
    end

   
   // ------------------------------------------------------
   // -- IC_HS_SPKLEN register
   //
   // -- Write control for 'ic_hs_spklen'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_HS_SPKLEN_REG_PROC
     if(presetn == 1'b0)
       r_ic_hs_spklen <= `IC_DEFAULT_HS_SPKLEN;
     else begin
        if ((ic_enable[0] == 1'b0) && (ic_hs_spklen_we == 1'b1)) begin
           case(byte_en)
             4'b0001 : r_ic_hs_spklen[`IC_HS_SPKLEN_RS-1:0] <= (ipwdata[`IC_HS_SPKLEN_RS-1:0] >= `IC_HS_SPKLEN_LO_LIMIT)? ipwdata[`IC_HS_SPKLEN_RS-1:0]: `IC_HS_SPKLEN_LO_LIMIT;
             4'b0011 : r_ic_hs_spklen[`IC_HS_SPKLEN_RS-1:0] <= (ipwdata[`IC_HS_SPKLEN_RS-1:0] >= `IC_HS_SPKLEN_LO_LIMIT)? ipwdata[`IC_HS_SPKLEN_RS-1:0]: `IC_HS_SPKLEN_LO_LIMIT;
             4'b1111 : r_ic_hs_spklen[`IC_HS_SPKLEN_RS-1:0] <= (ipwdata[`IC_HS_SPKLEN_RS-1:0] >= `IC_HS_SPKLEN_LO_LIMIT)? ipwdata[`IC_HS_SPKLEN_RS-1:0]: `IC_HS_SPKLEN_LO_LIMIT;
             default : r_ic_hs_spklen[`IC_HS_SPKLEN_RS-1:0] <= ic_hs_spklen[`IC_HS_SPKLEN_RS-1:0];
           endcase
        end
     end
   end


   
   // ------------------------------------------------------
   // -- REG_TIMEOUT_RST register
   //
   // -- Write control for 'REG_TIMEOUT_RST'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : REG_TIMEOUT_RST_PROC
     if(presetn == 1'b0)
         reg_timeout_rst <= `REG_TIMEOUT_VALUE;
     else if ((ic_enable[0] == 1'b0) && (reg_timeout_rst_we == 1'b1)) begin
       if (byte_en[0]==1'b1) reg_timeout_rst[`REG_TIMEOUT_WIDTH-1:0] <= ipwdata[`REG_TIMEOUT_WIDTH-1:0];
     end
   end


     
   // jduarte 20110105 end  



   // ------------------------------------------------------
   // -- IC_INTR_MASK register
   //
   // -- Write control for 'ic_intr_mask'
   // -- Can be written unless IC_ENABLE[0] = '0'
   // -- Can never write a zero.
   // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin:IC_INTR_MASK_PROC
      if(presetn == 1'b0) begin
        ic_intr_mask <= 15'h8ff;
      end else begin

        if (ic_intr_mask_we == 1'b1) begin
          case(byte_en)
            4'b0001 : begin
                        ic_intr_mask[7:0] <= ipwdata[7:0];
                      end
            4'b0010 : begin
                        ic_intr_mask[`IC_INTR_MASK_RS-4:8] <= ipwdata[`IC_INTR_MASK_RS-4-8:0];
                        ic_intr_mask[14] <= 1'b0;
                        ic_intr_mask[13] <= 1'b0;

                         ic_intr_mask[12] <= 1'b0;
                      end
            4'b0011 : begin
                        ic_intr_mask[`IC_INTR_MASK_RS-4:0] <= ipwdata[`IC_INTR_MASK_RS-4:0];
                        ic_intr_mask[14] <= 1'b0;

                        ic_intr_mask[13] <= 1'b0;

                        ic_intr_mask[12] <= 1'b0;
                      end
            4'b1111 : begin
                        ic_intr_mask[`IC_INTR_MASK_RS-4:0] <= ipwdata[`IC_INTR_MASK_RS-4:0];
                        ic_intr_mask[14] <= 1'b0;
                        ic_intr_mask[13] <= 1'b0;

                        ic_intr_mask[12] <= 1'b0;
                      end
            default : ic_intr_mask[`IC_INTR_MASK_RS-1:0] <= ic_intr_mask_int[`IC_INTR_MASK_RS-1:0];
          endcase
        end

      end
   end // block: IC_INTR_MASK_PROC

   assign ic_intr_mask_int = ic_intr_mask;

// ------------------------------------------------------
// -- IC_RX_TL register
//
// -- Write control for 'ic_rx_tl'
// -- This can never have a value greater that the rx_fifo_depth
// -- This is restricted to a maximum of 8 bits
// ------------------------------------------------------
  assign rx_fifo_depth = `IC_RX_BUFFER_DEPTH - 9'h01;
  assign ic_rx_tl_int  = ic_rx_tl[`RX_ABW-1:0];

  always @(posedge pclk or negedge presetn) begin : IC_RX_TL_PROC
    if (presetn == 1'b0) begin
      ic_rx_tl <= `IC_RX_TL_IN;
    end else begin
      if ((ic_rx_tl_we == 1'b1) && (byte_en[0] == 1'b1)) begin
        if (ipwdata[`IC_RX_TL_RS-1:0] <= rx_fifo_depth) begin
          ic_rx_tl <= ipwdata[`IC_RX_TL_RS-1:0];
        end else begin
          ic_rx_tl <= rx_fifo_depth;
        end
      end
    end
  end

// ------------------------------------------------------
// -- IC_TX_TL register
//
// -- Write control for 'ic_tx_tl'
//- This can never have a value greater than the tx_fifo_depth.
//- This is restricted to a maximum of 8 bits in width
// ------------------------------------------------------
   assign tx_fifo_depth = `IC_TX_BUFFER_DEPTH - 9'h01;

   always @(posedge pclk or negedge presetn) begin : IC_TX_TL_PROC
     if(presetn == 1'b0) begin
       ic_tx_tl <= `IC_TX_TL_IN;
     end else begin
       if ((ic_tx_tl_we == 1'b1) && (byte_en[0] == 1'b1)) begin
         if (ipwdata[`IC_TX_TL_RS-1:0] <= tx_fifo_depth) begin
           ic_tx_tl <= ipwdata[`IC_TX_TL_RS-1:0];
         end else begin
           ic_tx_tl <= tx_fifo_depth;
         end
       end
     end
   end



  // ------------------------------------------------------
  // SDA Setup register writes from the APB interface
  // This 8-bit register controls the minimum amount of
  // clock cycles the SCL is forced low when it is stretched
  // during Slave reads such that the data contents can be
  // fetched.
  // See pg 32, I2C Spec v2.1.
  // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : IC_SDA_SETUP_REG_PROC
     if(presetn == 1'b0)
       ic_sda_setup <= `IC_DEFAULT_SDA_SETUP;
     else begin
       if(ic_sda_setup_we == 1'b1 && byte_en[0] == 1'b1 && ic_enable[0] == 1'b0 ) begin
         ic_sda_setup[`IC_SDA_SETUP_RS-1:0] <= ipwdata[`IC_SDA_SETUP_RS-1:0];
       end
     end // else presetn
   end
  // ------------------------------------------------------
  // SDA Hold register writes from the APB interface
  // This 24-bit register which contains two parts:
  // IC_SDA_TX_HOLD which is IC_SDA_HOLD[15:0] and IC_SDA_RX_HOLD which is IC_SDA_HOLD[23:16]
  // IC_SDA_TX_HOLD is used whenever I2C acts as trasmitter to delay the change in SDA after SCL goes LOW.
  // IC_SDA_RX_HOLD is used whenever I2C acts as reciever to internally delay SDA line while SCL is HIGH.
  // ------------------------------------------------------
  always @(posedge pclk or negedge presetn) begin : IC_SDA_HOLD_REG_PROC
     if(presetn == 1'b0) begin
       ic_sda_hold <= `IC_DEFAULT_SDA_HOLD;
     end
     else begin
       if(ic_sda_hold_we == 1'b1 && ic_enable[0] == 1'b0) begin
           case(byte_en)
             4'b1111 : ic_sda_hold[`IC_SDA_HOLD_RS-1:0]                      <= ipwdata[`IC_SDA_HOLD_RS-1:0];
             default : ic_sda_hold[`IC_SDA_HOLD_RS-1:0]                      <= ic_sda_hold_int[`IC_SDA_HOLD_RS-1:0];
           endcase
       end
     end // else presetn
   end
   
    assign ic_sda_hold_int = ic_sda_hold; 

  // ------------------------------------------------------
  // ACK_GENERAL_CALL register writes from the APB interface.
  // This 1-bit register controls whether, in Slave mode
  // **only**, if the I2C will assert the ACK bit whenever
  // a general call address is received.
  // ------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : ACK_GENERAL_PROC
     if(presetn==1'b0)
       ic_ack_general_call <= `IC_DEFAULT_ACK_GENERAL_CALL;
     else begin
       if(ic_ack_general_call_we==1'd1 && byte_en[0])
         ic_ack_general_call <= ipwdata[0];
     end // else presetn
   end // always




//##################################################################################
//# Identification Registers for DesignWare Peripherals
//##################################################################################

// The following signals include fixed version, type info registers and cc_constant values which will be pre-defined and constant.
  assign ic_comp_param_1[31:24] = 8'b0;
  assign ic_comp_param_1[23:16] = `ENCODED_IC_TX_BUFFER_DEPTH;
  assign ic_comp_param_1[15:8]  = `ENCODED_IC_RX_BUFFER_DEPTH;
  assign ic_comp_param_1[7]     = `IC_ADD_ENCODED_PARAMS;
  assign ic_comp_param_1[6]     = `IC_HAS_DMA;
  assign ic_comp_param_1[5]     = `IC_INTR_IO;
  assign ic_comp_param_1[4]     = `IC_HC_COUNT_VALUES;
  assign ic_comp_param_1[3:2]   = `IC_MAX_SPEED_MODE;
  assign ic_comp_param_1[1:0]   = `ENCODED_APB_DATA_WIDTH;
  assign ic_comp_version        = `IC_VERSION_ID;
  assign ic_comp_type           = 32'h44570140;

  // ------------------------------------------------------
  // -- APB read data mux
  //
  // -- The data from the selected register is
  // -- placed on a zero-padded 32-bit read data bus.
  // ------------------------------------------------------
  always @ (*)
  begin: IPRDATA_PROC
    iprdata = {32{1'b0}};
    case (1'b1)
      ic_hs_maddr_en       : iprdata[`IC_HS_MADDR_RS-1:0]       = ic_hs_maddr ;
      ic_hs_hcnt_en        : iprdata[`IC_HS_HCNT_RS-1:0]        = ic_hs_hcnt  ;
      ic_hs_lcnt_en        : iprdata[`IC_HS_LCNT_RS-1:0]        = ic_hs_lcnt  ;
      ic_fs_hcnt_en        : iprdata[`IC_FS_HCNT_RS-1:0]        = ic_fs_hcnt  ;
      ic_fs_lcnt_en        : iprdata[`IC_FS_LCNT_RS-1:0]        = ic_fs_lcnt  ;

      // jduarte 20110105 begin
      // CRM 9000368180
      ic_fs_spklen_en      : iprdata[`IC_FS_SPKLEN_RS-1:0]      = ic_fs_spklen[`IC_FS_SPKLEN_RS-1:0];   
      ic_hs_spklen_en      : iprdata[`IC_HS_SPKLEN_RS-1:0]      = ic_hs_spklen[`IC_HS_SPKLEN_RS-1:0];   
      // jduarte 20110105 end
      reg_timeout_rst_en   : iprdata[`REG_TIMEOUT_WIDTH-1:0]    = reg_timeout_rst[`REG_TIMEOUT_WIDTH-1:0];   
      ic_con_en            : begin 
                              iprdata[`IC_CON_RS-1:0] =  ic_con;
                             end
      ic_sar_en            : iprdata[`IC_SAR_RS-1:0]            = ic_sar;
      ic_tar_en            : begin
                              iprdata[11:0]           = ic_tar_reg[11:0] ;
                             end

      ic_data_cmd_en       : iprdata[`IC_DATA_RS-1:0]           = rx_pop_data;
      ic_ss_hcnt_en        : iprdata[`IC_SS_HCNT_RS-1:0]        = ic_ss_hcnt;
      ic_ss_lcnt_en        : iprdata[`IC_SS_LCNT_RS-1:0]        = ic_ss_lcnt;
      ic_intr_stat_en      : iprdata[`IC_INTR_STAT_RS-1:0]      = ic_intr_stat;
      ic_intr_mask_en      : iprdata[`IC_INTR_MASK_RS-1:0]      = ic_intr_mask;
      ic_raw_intr_stat_en  : iprdata[`IC_RAW_INTR_STAT_RS-1:0]  = ic_raw_intr_stat;
      ic_rx_tl_en          : iprdata[`IC_RX_TL_RS-1:0]          = ic_rx_tl;
      ic_tx_tl_en          : iprdata[`IC_TX_TL_RS-1:0]          = ic_tx_tl;
      ic_enable_en         : iprdata[`IC_ENABLE_RS-1:0]         = ic_enable_reg;
      ic_status_en         : begin
                            iprdata[`IC_STATUS_RS-1:0]          = ic_status;
                            end
      ic_txflr_en          : iprdata[`TX_ABW:0]                 = ic_txflr;
      ic_rxflr_en          : iprdata[`RX_ABW:0]                 = ic_rxflr;
      ic_clr_gen_call_en   : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[11];
      ic_clr_start_det_en  : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[10];
      ic_clr_stop_det_en   : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[9];
      ic_clr_activity_en   : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[8];
      ic_clr_rx_done_en    : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[7];
      ic_clr_tx_abrt_en    : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[6];
      ic_clr_rd_req_en     : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[5];
      ic_clr_tx_over_en    : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[3];
      ic_clr_rx_over_en    : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[1];
      ic_clr_rx_under_en   : iprdata[`IC_CLR_INTR_RS-1:0]       = ic_raw_intr_stat[0];
      ic_clr_intr_en       : iprdata[`IC_CLR_INTR_RS-1:0]       = |ic_raw_intr_stat;
      ic_tx_abrt_source_en : iprdata[`IC_TX_ABRT_SOURCE_RS+6+`TX_ABW:0] = {ic_txflr_flushed,{6{1'b0}},ic_tx_abrt_source};
      ic_comp_param_1_en   : iprdata[31:0]                      = ic_comp_param_1;
      ic_comp_version_en   : iprdata[31:0]                      = ic_comp_version;
      ic_comp_type_en      : iprdata[31:0]                      = ic_comp_type;
      ic_sda_setup_en      : iprdata[31:0]                      = {24'd0, ic_sda_setup};
      ic_sda_hold_en       : iprdata[`IC_SDA_HOLD_RS-1:0]       = ic_sda_hold;

      ic_ack_general_call_en:iprdata[0]                         = ic_ack_general_call;

      ic_enable_status_en  : iprdata[`IC_ENABLE_STATUS_RS-1:0]  = ic_enable_status;
    endcase
  end

   // ------------------------------------------------------
   // -- Synchronous reset for rx and tx fifos
   //
   //  The fifo read and write pointers are reset when
   //  presetn is activated and when the IC_ENABLE[0]
   //  is cleared.
   // ------------------------------------------------------
   assign fifo_rst_n = ((ic_enable_we  == 1'b0) && (ic_enable[0] == 1'b1) 
                         && (tx_abrt_flg_edg == 1'b0)
                       ) ||
                       ((ic_enable_we  == 1'b1) && (ipwdata[0] == 1'b1) && (ic_enable[0] == 1'b1) 
                          && (tx_abrt_flg_edg == 1'b0) 
                        && (byte_en[0] == 1'b1))
                        || ((ic_enable_we == 1'b1) && (byte_en[0] != 1'b1)
                          && ((ic_enable[0]==1'b1) ? (tx_abrt_flg_edg == 1'b0) : 1'b1)
                        );

   // ------------------------------------------------------
   // Fix for STAR 9000108249
   // Whenever a Tx-abort occurs, the TxFIFO is now *HELD* in
   // a flushed/reset state. This forces further writes into
   // the TxFIFO to be completely ignored, thereby avoiding
   // the condition where the DW_apb_i2c can potentially stall
   // (as per STAR - not transmitting when TXFLR is > 0).
   //
   // To re-enable successful writes into the TxFIFO, without
   // toggling IC_ENABLE, a READ of the IC_CLR_TX_ABRT register
   // is required.
   // ------------------------------------------------------

   // assign tx_fifo_rst_n = fifo_rst_n && (slv_clr_leftover_flg_edg == 1'b0);
   assign tx_fifo_rst_n = (fifo_rst_n_int & ic_enable[0])
                         && (slv_clr_leftover_flg_edg == 1'b0)
                         ;

   assign fix_a = ic_clr_tx_abrt_en | fifo_rst_n_int
                  ;
   assign fix_b = fix_a & fifo_rst_n; 
   assign fix_c = ~ic_enable[0] | fix_b;

   always @(posedge pclk or negedge presetn) begin : FIFO_RST_N_PROC
     if(!presetn)
       fifo_rst_n_int <= 1'd0;
     else
       fifo_rst_n_int <= fix_c;
   end // always
   

   // ------------------------------------------------------
   // -- Control signal generation
   //
   // -- The control signals to indicate mode and speed
   // -- Register decode assignments
   // ------------------------------------------------------
   assign ic_hs        = (speed == 2'b11)
   ;
   assign ic_fs        = (speed == 2'b10)
   ;
   assign ic_ss        = (speed == 2'b01);
   assign ic_master    = (ic_con[0] == 1'b1);
   assign ic_10bit_mst = (ic_con[4] == 1'b1);
   assign ic_10bit_slv = (ic_con[3] == 1'b1);
   assign ic_rstrt_en  = (ic_con[5] == 1'b1);
   assign ic_slave_en  = (ic_con[6] == 1'b0);
   assign p_det_ifaddr = (ic_con[7] == 1'b1);
   assign tx_empty_ctrl = (ic_con[8] == 1'b1);
   // ------------------------------------------------------
   // -- Count registers mux
   //
   // -- The data from the appropriate register is
   // -- passed to the DW_apb_i2c_clk_gen.v.
   // ------------------------------------------------------
   always @(ic_ss_hcnt or ic_ss_lcnt 
           or ic_ss or ic_fs_hcnt or ic_fs_lcnt
            or ic_hs_hcnt or ic_hs_lcnt or ic_hs
            ) begin: IC_COUNT_MUX_PROC
     begin
        if(ic_ss == 1'b1)
          begin
             ic_hcnt = ic_ss_hcnt;
             ic_lcnt = ic_ss_lcnt;
          end
        else if(ic_hs == 1'b1)
          begin
             ic_hcnt = ic_hs_hcnt;
             ic_lcnt = ic_hs_lcnt;
          end
        else
          begin
             ic_hcnt = ic_fs_hcnt;
             ic_lcnt = ic_fs_lcnt;
          end
     end
   end
endmodule



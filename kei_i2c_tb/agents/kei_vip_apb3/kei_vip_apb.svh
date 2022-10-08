//=======================================================================
// COPYRIGHT (C) 2018-2020 RockerIC, Ltd.
// This software and the associated documentation are confidential and
// proprietary to RockerIC, Ltd. Your use or disclosure of this software
// is subject to the terms and conditions of a consulting agreement
// between you, or your company, and RockerIC, Ltd. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
// VisitUs  : www.rockeric.com
// Support  : support@rockeric.com
// WeChat   : eva_bill 
//-----------------------------------------------------------------------
`ifndef KEI_VIP_APB_SVH
`define KEI_VIP_APB_SVH


`include "kei_vip_apb_transfer.sv"
`include "kei_vip_apb_config.sv"

`include "kei_vip_apb_master_driver.svh"
`include "kei_vip_apb_master_monitor.svh"
`include "kei_vip_apb_master_sequencer.svh"
`include "kei_vip_apb_master_agent.svh"

`include "kei_vip_apb_slave_driver.svh"
`include "kei_vip_apb_slave_monitor.svh"
`include "kei_vip_apb_slave_sequencer.svh"
`include "kei_vip_apb_slave_agent.svh"


`include "kei_vip_apb_master_driver.sv"       
`include "kei_vip_apb_master_monitor.sv"
`include "kei_vip_apb_master_sequencer.sv"
`include "kei_vip_apb_master_agent.sv"
`include "kei_vip_apb_master_seq_lib.sv"

`include "kei_vip_apb_slave_driver.sv"       
`include "kei_vip_apb_slave_monitor.sv"
`include "kei_vip_apb_slave_sequencer.sv"
`include "kei_vip_apb_slave_agent.sv"
`include "kei_vip_apb_slave_seq_lib.sv"

`include "kei_vip_apb_reg_adapter.sv"


   
`endif //  `ifndef KEI_VIP_APB_SVH

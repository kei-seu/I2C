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
`ifndef KEI_VIP_APB_MASTER_SEQUENCER_SVH
`define KEI_VIP_APB_MASTER_SEQUENCER_SVH

class kei_vip_apb_master_sequencer extends uvm_sequencer #(kei_vip_apb_transfer);

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////
  kei_vip_apb_config cfg;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(kei_vip_apb_master_sequencer)
     // USER: Register fields 
  `uvm_component_utils_end

  // new - constructor
  extern function new (string name, uvm_component parent);

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Implementation (private) interface
  //
  //////////////////////////////////////////////////////////////////////////////

  // The virtual interface used to drive and view HDL signals.
  virtual kei_vip_apb_if vif;

endclass : kei_vip_apb_master_sequencer

`endif // KEI_VIP_APB_MASTER_SEQUENCER_SVH



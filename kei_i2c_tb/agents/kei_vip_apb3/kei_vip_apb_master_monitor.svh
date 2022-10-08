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
`ifndef KEI_VIP_APB_MASTER_MONITOR_SVH
`define KEI_VIP_APB_MASTER_MONITOR_SVH

class kei_vip_apb_master_monitor extends uvm_monitor;

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////
  kei_vip_apb_config cfg;

  // This field controls if this monitor has its checkers enabled
  // (by default checkers are on)
  bit checks_enable = 1;

  // This field controls if this monitor has its coverage enabled
  // (by default coverage is on)
  bit coverage_enable = 1;

  // This property is the virtual interface needed for this component to drive
  // and view HDL signals
  virtual kei_vip_apb_if vif;
  // USER: Add your fields here


  // The following is the analysis port that allows this monitor's transaction
  // information to be sent to other verification componets such as
  // scoreboards
  uvm_analysis_port #(kei_vip_apb_transfer) item_collected_port;

  // This macro performs UVM object creation, type control manipulation, and 
  // factory registration
  `uvm_component_utils_begin(kei_vip_apb_master_monitor)
     `uvm_field_int(checks_enable, UVM_ALL_ON)
     `uvm_field_int(coverage_enable, UVM_ALL_ON)
     // USER: Register fields here
  `uvm_component_utils_end

   // new - constructor     
   extern function new(string name, uvm_component parent=null);

   // uvm run phase
   extern virtual task run();

  // Events needed to trigger covergroups
  event kei_vip_apb_master_cov_transaction;

  // Transfer collected covergroup
  covergroup kei_vip_apb_master_cov_trans @kei_vip_apb_master_cov_transaction;
    // USER implemented coverpoints
  endgroup : kei_vip_apb_master_cov_trans

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Implementation (private) interface
  //
  //////////////////////////////////////////////////////////////////////////////

  //This is the transaction being collected by this monitor	
  protected kei_vip_apb_transfer trans_collected;

  // This method is responsible for collecting transactions, checking,
  // and updating coverage 
  extern virtual protected task monitor_transactions();

  // This is the methods that collects transactions
  extern virtual protected task collect_transfer();

  // This is the method that performs checks on a transaction
  extern protected function void perform_transfer_checks();

  // This is the method that updates coverage based on a transaction
  extern protected function void perform_transfer_coverage();

endclass : kei_vip_apb_master_monitor

`endif // KEI_VIP_APB_MASTER_MONITOR_SVH


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
`ifndef KEI_VIP_APB_MASTER_DRIVER_SVH
`define KEI_VIP_APB_MASTER_DRIVER_SVH

class kei_vip_apb_master_driver extends uvm_driver #(kei_vip_apb_transfer);

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////
  kei_vip_apb_config cfg;

  // USER: Add your fields here

  // This macro performs UVM object creation, type control manipulation, and 
  // factory registration
  `uvm_component_utils_begin(kei_vip_apb_master_driver)
     // USER: Register fields here
  `uvm_component_utils_end

  // new - constructor
  extern function new (string name, uvm_component parent);

  // uvm run phase
  extern virtual task run();

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Implementation (private) interface
  //
  //////////////////////////////////////////////////////////////////////////////

  // The virtual interface used to drive and view HDL signals.
  virtual kei_vip_apb_if vif;

  // This is the method that is responsible for getting sequence transactions
  // and driving the transaction into the DUT
  extern virtual protected task get_and_drive();
 
  // This method drives a sequence trasnaction onto the interface
  extern virtual protected task drive_transfer(kei_vip_apb_transfer t);

  // This method reset interface signals
  extern virtual protected task reset_listener();
 
  // This method that is responsible for sending an idle cycle to the DUT
  extern protected task do_idle();
  // This method that is to trigger write transaction
  extern protected task do_write(kei_vip_apb_transfer t);
  // This method that is to trigger read transaction
  extern protected task do_read(kei_vip_apb_transfer t);

endclass : kei_vip_apb_master_driver

`endif // KEI_VIP_APB_MASTER_DRIVER_SVH

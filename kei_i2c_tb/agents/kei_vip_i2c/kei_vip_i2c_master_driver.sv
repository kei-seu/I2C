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


`ifndef KEI_VIP_I2C_MASTER_DRIVER_SVH
`define KEI_VIP_I2C_MASTER_DRIVER_SVH

class kei_vip_i2c_master_driver extends uvm_driver #(kei_vip_i2c_master_transaction);

  uvm_analysis_port #(kei_vip_i2c_master_transaction)   trans_port;

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////
  kei_vip_i2c_master_driver_common common;

  /** @cond PRIVATE */
  /** Configuration object copy to be used in set/get operations. */
  kei_vip_i2c_agent_configuration cfg_snapshot;
  /** 
   * Semaphore to help collect transaction response in a pipelined transaction.
   * This is used in collecting response from the verilog module through virtual interfaces.
   */
  local semaphore collect_xact;

  /**
   * Event triggers when master driver consumes the transaction object. 
   * At this point, transaction object is not yet processed or transmitted on the bus.
   */
  uvm_event TX_XACT_CONSUMED;

  /** Event triggers when START condition is generated by master */
  uvm_event EVENT_START_GENERATED;
  
  /** Event triggers when STOP condition is generated by master */
  uvm_event EVENT_STOP_GENERATED;
  
  /** Event triggers when ACK is generated by master */
  uvm_event EVENT_ACK_GENERATED;
  
  /** Event triggers when NACK is generated by master */
  uvm_event EVENT_NACK_GENERATED;
  
  /** Event triggers when ACK is received by master */
  uvm_event EVENT_ACK_RECEIVED;
  
  /** Event triggers when NACK is received by master */
  uvm_event EVENT_NACK_RECEIVED;
  
  /** Event triggers when REPEATED START condition is generated by master */
  uvm_event EVENT_REPEATED_START_GENERATED;
  
  /** Event triggers when START BYTE is generated by master */
  uvm_event EVENT_START_BYTE_TRANSMITED;
  
  /** Event triggers when GENERAL CALL address is sent by master */
  uvm_event EVENT_GENERAL_CALL_ADDR_SENT;
  
  /** Event triggers when second byte of GENERAL CALL command is sent by master */
  uvm_event EVENT_GENERAL_CALL_SEC_BYTE_SENT;
  
  /** Event triggers when master loses arbitration */
  uvm_event EVENT_ARBITRATION_LOSS_DETECTED;

  // ****************************************************************************
  // Local Data Properties
  // ****************************************************************************
  /** @cond PRIVATE */
  /** Configuration object for this transactor. */
  local kei_vip_i2c_agent_configuration  cfg;
  /** @endcond */

  /**
   * Event pool associated with this driver
   */
  uvm_event_pool event_pool;


  /** Exception list handle for randomizing exceptions */
  //kei_vip_i2c_master_transaction_exception_list randomized_transaction_exception_list;


  `uvm_register_cb(kei_vip_i2c_master_driver, kei_vip_i2c_master_driver_callback)
  // This macro performs UVM object creation, type control manipulation, and 
  // factory registration
  `uvm_component_utils_begin(kei_vip_i2c_master_driver)
     // USER: Register fields here
     `uvm_field_object(cfg, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  extern function new (string name, uvm_component parent);

  // uvm run phase
  extern function void build_phase(uvm_phase phase);
  /**
   * Called when a new configuration is applied to the VIP 
   * This task drives the new configuration to the VIP.
   */
  extern task reconfigure_via_task(kei_vip_i2c_configuration cfg);
  /**
   * Callback issued after pulling a transaction descriptor out of its input 
   * TLM port, but before acting on the transaction descriptor in any way.
   *
   * @param xact A reference to the transaction descriptor object of interest.
   * 
   * @param drop A <i>ref</i> argument, which if set by the user's callback implementation
   * causes the component to discard the transaction descriptor without further action
   */
  extern virtual protected function void post_seq_item_get(kei_vip_i2c_master_transaction xact, ref bit drop);

/** @cond PRIVATE */

  // ****************************************************************************
  // Internal Utilities
  // ****************************************************************************
  
  /** Method which converts model events into driver events. */
  extern virtual protected task source_events();
  
  /** 
   * This task gets kei_vip_i2c_master_transaction from the sequencer.
   * This task drives the transaction to the VIP.
   */
  extern task consume_from_seq_item_port();

  /**
   * Callback issued after pulling a transaction descriptor out of its input 
   * TLM port, but before acting on the transaction descriptor in any way.
   *
   * This method issues the <i>post_seq_item_get</i> callback.
   * 
   * Overriding implementations in extended classes must call the super version of this method.
   * 
   * @param xact A reference to the transaction descriptor object of interest.
   * 
   * @param drop A <i>ref</i> argument, which if set by the user's callback implementation
   * causes the component to discard the transaction descriptor without further action
   */
  extern virtual task post_seq_item_get_cb_exec(kei_vip_i2c_master_transaction xact, ref bit drop);

  /** 
   * This task collects the transaction response and passes it to the sequencer
   * through put_response.
   */
  extern task put_response_to_seq_item_port(kei_vip_i2c_master_transaction xact, int drop = 0);
  
  /**
   * This task assign the virtual interfaces to #common
   */
  extern function void assign_vif();
  /** @endcond */

  /** Run phase of UVM which calls consume_from_seq_item_port task */
  extern task run_phase(uvm_phase phase);


endclass : kei_vip_i2c_master_driver

function kei_vip_i2c_master_driver::new (string name, uvm_component parent);
  super.new(name, parent);
  collect_xact = new(1);
  trans_port = new("trans_port",this);
endfunction

function void kei_vip_i2c_master_driver::build_phase(uvm_phase phase);
  `uvm_info("build_phase", $sformatf("%s: starting...",get_type_name()), UVM_LOW)
  if(!uvm_config_db#(kei_vip_i2c_agent_configuration)::get(this, "", "cfg", cfg)) begin
    `uvm_fatal("build_phase", "Unable to get the master agent configuration and failed to extract config info from the object")
  end

  if(cfg.i2c_if == null) begin
    `uvm_fatal("build_phase", "A virtual interface was not received through the config object")
  end

  common = kei_vip_i2c_master_driver_common::type_id::create("common"); 
  common.cfg = this.cfg;
  this.assign_vif();

  event_pool = new("event_pool");
  if(cfg.enable_driver_events == 1) begin
    TX_XACT_CONSUMED = event_pool.get("TX_XACT_CONSUMED");
    EVENT_START_GENERATED = event_pool.get("EVENT_START_GENERATED");
    EVENT_STOP_GENERATED = event_pool.get("EVENT_STOP_GENERATED");
    EVENT_ACK_GENERATED = event_pool.get("EVENT_ACK_GENERATED");
    EVENT_NACK_GENERATED = event_pool.get("EVENT_NACK_GENERATED");
    EVENT_ACK_RECEIVED = event_pool.get("EVENT_ACK_RECEIVED");
    EVENT_NACK_RECEIVED = event_pool.get("EVENT_NACK_RECEIVED");
    EVENT_REPEATED_START_GENERATED = event_pool.get("EVENT_REPEATED_START_GENERATED");
    EVENT_START_BYTE_TRANSMITED = event_pool.get("EVENT_START_BYTE_TRANSMITED");
    EVENT_GENERAL_CALL_ADDR_SENT = event_pool.get("EVENT_GENERAL_CALL_ADDR_SENT");
    EVENT_GENERAL_CALL_SEC_BYTE_SENT = event_pool.get("EVENT_GENERAL_CALL_SEC_BYTE_SENT");
    EVENT_ARBITRATION_LOSS_DETECTED = event_pool.get("EVENT_ARBITRATION_LOSS_DETECTED");
  end
  `uvm_info("build_phase", $sformatf("%s: finishing...",get_type_name()), UVM_LOW)
endfunction

task kei_vip_i2c_master_driver::reconfigure_via_task(kei_vip_i2c_configuration cfg);
  if(!$cast(this.cfg, cfg))
    `uvm_fatal("CASTFAIL", "I2C configuration handle type inconsistence")
  common.reconfigure_via_task(cfg);
endtask

function void kei_vip_i2c_master_driver::post_seq_item_get(kei_vip_i2c_master_transaction xact, ref bit drop);
  // EMPTY
endfunction

task kei_vip_i2c_master_driver::source_events();
  if(cfg.enable_driver_events == 1) begin
//    fork
//       common.source_event(common.i2c_if.event_master_start_generated          , EVENT_START_GENERATED          );
//       common.source_event(common.i2c_if.event_master_stop_generated           , EVENT_STOP_GENERATED           );
//       common.source_event(common.i2c_if.event_master_ack_generated            , EVENT_ACK_GENERATED            );
//       common.source_event(common.i2c_if.event_master_nack_generated           , EVENT_NACK_GENERATED           );
//       common.source_event(common.i2c_if.event_master_ack_received             , EVENT_ACK_RECEIVED             );
//       common.source_event(common.i2c_if.event_master_nack_received            , EVENT_NACK_RECEIVED            );
//       common.source_event(common.i2c_if.event_master_repeated_start_generated , EVENT_REPEATED_START_GENERATED );
//       common.source_event(common.i2c_if.event_master_start_byte_transmited    , EVENT_START_BYTE_TRANSMITED    );
//       common.source_event(common.i2c_if.event_master_general_call_addr_sent   , EVENT_GENERAL_CALL_ADDR_SENT   );
//       common.source_event(common.i2c_if.event_master_general_call_sec_byte_sent   ,    EVENT_GENERAL_CALL_SEC_BYTE_SENT);
//       common.source_event(common.i2c_if.event_master_arbitration_loss_detected, EVENT_ARBITRATION_LOSS_DETECTED);
//    join
  end
endtask

task kei_vip_i2c_master_driver::consume_from_seq_item_port();
  kei_vip_i2c_master_transaction trans;
  kei_vip_i2c_master_transaction trans_out;
  bit success = 0;
  bit drop = 0;
  forever begin
    trans = new();
    `uvm_info("consume_from_seq_item_port", "Get request item from sequencer...", UVM_DEBUG)
    seq_item_port.get_next_item(trans);
    
    
    `uvm_info("consume_from_seq_item_port", "Got request item from sequencer...", UVM_DEBUG)
    // TODO:: if trans.exception_list or randomized_transaction_exception_list ??
    // branches open here
    drop = 0;
    // callback called for loading exceptions from callbacks
    post_seq_item_get_cb_exec(trans, drop);

    if(drop) begin
      `uvm_info("consume_from_seq_item_port", "Drop bit set through post_seq_item_get callback. Transaction dropped", UVM_DEBUG)
      // put response to seq_item_port
      seq_item_port.put_response(trans);
    end
    else begin
      // Fatal if transaction received from sequencer is not valid
      if(!trans.is_valid()) begin
        `uvm_fatal("consume_from_seq_item_port", "Transaction received from the sequencer failed the is_valid() check")
      end
      // Drive transaction to bus
      //common.send_xact(trans, trans.get_type_name());
      common.send_xact(trans);
      // Put response object to seq_item_port
      put_response_to_seq_item_port(trans);
      `uvm_info("consume_from_seq_item_port", $sformatf("kei_vip_i2c_master_driver: Driving transaction with cmd %s", trans.cmd), UVM_LOW)
      $cast(trans_out,trans.clone());
      trans_port.write(trans_out);
      if(trans_out != null) begin
        $display("mater driver get trans from seq, print_driver_trans");
        trans_out.print();
      end
      drop = 0;
    end
    // Acknowledge item_done() to sequencer
    seq_item_port.item_done();
    `uvm_info("consume_from_seq_item_port", "Transaction Process in Driver Complete...", UVM_DEBUG)
  end
endtask

task kei_vip_i2c_master_driver::post_seq_item_get_cb_exec(kei_vip_i2c_master_transaction xact, ref bit drop);
  post_seq_item_get(xact, drop);
  `uvm_do_callbacks(kei_vip_i2c_master_driver, kei_vip_i2c_master_driver_callback, post_seq_item_get(this, xact, drop)) 
endtask

task kei_vip_i2c_master_driver::put_response_to_seq_item_port(kei_vip_i2c_master_transaction xact, int drop = 0);
  kei_vip_i2c_master_transaction resp;
  if(cfg.enable_put_response) begin
    fork
      begin : collect_and_put_response_thread
        // Grap semaphore
        collect_xact.get();
        // Cast received xact to local resp
        if(!$cast(resp, xact.clone()))
          `uvm_error("put_response_to_seq_item_port", "Failed attempting to cast response object in Master Driver")
        // Collect response attributes values from virtual interface
        // 
        common.collect_response_from_vif(resp);  
        resp.set_id_info(xact);
        // Put response to seq_item_port
        seq_item_port.put_response(resp);
        // Release semphore
        collect_xact.put();
      end // collect_and_put_response_thread
    join_none
  end // if(cfg.enable_put_response)
endtask

function void kei_vip_i2c_master_driver::assign_vif();
  common.assign_vif(cfg.i2c_if); 
endfunction

task kei_vip_i2c_master_driver::run_phase(uvm_phase phase);
  `uvm_info("run_phase", "kei_vip_i2c_master_driver::Starting...", UVM_LOW)
  `uvm_info("run_phase", "Wait for Reset...", UVM_DEBUG)
  common.wait_for_reset(); 
  `uvm_info("run_phase", "Wait for Observed...", UVM_DEBUG)
  fork
    source_events();
  //join_none
  consume_from_seq_item_port();
  `uvm_info("run_phase", "kei_vip_i2c_master_driver::Finishing...", UVM_LOW)
  join_none
endtask

`endif // KEI_VIP_I2C_MASTER_DRIVER_SVH

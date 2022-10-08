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


`ifndef KEI_VIP_I2C_SLAVE_MONITOR_SVH
`define KEI_VIP_I2C_SLAVE_MONITOR_SVH

class kei_vip_i2c_slave_monitor extends uvm_monitor;
  //////////////////////////////////////////////////////////////////////////////
  //
  /** 
   * Analysis Port which collects transaction observed on bus. Monitor
   * writes to this port when the complete transaction observed on the bus.
   */
  uvm_analysis_port #(kei_vip_i2c_slave_transaction)   xact_observed_port;

  /** 
   * Analysis Port which collects data observed on bus. Monitor writes the response
   * object to this analysis port immediately after it observes data on the bus, instead
   * of waiting for the complete transaction to appear on the bus.
   */
  uvm_analysis_port #(kei_vip_i2c_slave_transaction)   data_observed_port;

  kei_vip_i2c_slave_monitor_common   common;

  kei_vip_i2c_agent_configuration  cfg_snapshot;
  
  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////
  local kei_vip_i2c_agent_configuration cfg;

  // This field controls if this monitor has its checkers enabled
  // (by default checkers are on)
  bit checks_enable = 1;

  // This field controls if this monitor has its coverage enabled
  // (by default coverage is on)
  bit coverage_enable = 1;

  int xact_cnt=0;

  uvm_event   EVENT_START_CONDITION; 
  uvm_event   EVENT_STOP_CONDITION; 
  uvm_event   EVENT_ACK_RECEIVED; 
  uvm_event   EVENT_NACK_RECEIVED; 
  uvm_event   EVENT_START_BYTE; 
  uvm_event   EVENT_GEN_CALL; 
  uvm_event   EVENT_SLAVE_ADD_7_B; 
  uvm_event   EVENT_SLAVE_ADD_10_B; 
  uvm_event   EVENT_GET_PACKET; 
  uvm_event   EVENT_REPEATED_START_CONDITION; 

  // This macro performs UVM object creation, type control manipulation, and 
  // factory registration
  `uvm_component_utils_begin(kei_vip_i2c_slave_monitor)
     `uvm_field_int(checks_enable, UVM_ALL_ON)
     `uvm_field_int(coverage_enable, UVM_ALL_ON)
     // USER: Register fields here
  `uvm_component_utils_end

   // new - constructor     
   extern function new(string name, uvm_component parent=null);

   // uvm build phase
   extern function void build_phase(uvm_phase phase);

   // uvm run phase
   extern virtual task run_phase(uvm_phase phase);

//   extern virtual function void report_phase(uvm_phase phase);

  // Events needed to trigger covergroups
  event kei_vip_i2c_slave_cov_transaction;

  // Transfer collected covergroup
  covergroup kei_vip_i2c_slave_cov_trans @kei_vip_i2c_slave_cov_transaction;
    // USER implemented coverpoints
  endgroup : kei_vip_i2c_slave_cov_trans

//  extern virtual function void set_common(kei_vip_i2c_slave_monitor_common common);

//  extern virtual task get_cfg_via_task(ref kei_vip_i2c_configuration cfg);

  extern virtual protected task source_events();

  //extern virtual protected task source_callbacks();
//  extern virtual protected function void pre_slave_xact_observed_put(kei_vip_i2c_slave_transaction xact, ref bit drop);
//
//  extern virtual protected function void slave_xact_observed_cov(kei_vip_i2c_slave_transaction xact);
//
//  extern virtual protected function void slave_transaction_started(kei_vip_i2c_slave_transaction xact);
//
//  extern virtual protected function void slave_transaction_ended(kei_vip_i2c_slave_transaction xact);
//  
//  extern virtual protected function void slave_transaction_repeated_start(kei_vip_i2c_slave_transaction xact);
//
//  extern virtual protected function void pre_slave_xact_observed_put_cb_exec(kei_vip_i2c_slave_transaction xact, ref bit drop);
//  
//  extern virtual protected function void slave_xact_observed_cov_cb_exec(kei_vip_i2c_slave_transaction xact);
  extern virtual task reconfigure_via_task(kei_vip_i2c_configuration cfg);
//  extern virtual protected function void slave_transaction_started_cb_exec(kei_vip_i2c_slave_transaction xact);
//  
//  extern virtual protected function void slave_transaction_ended_cb_exec(kei_vip_i2c_slave_transaction xact);
//  
//  extern virtual protected function void slave_transaction_repeated_start_cb_exec(kei_vip_i2c_slave_transaction xact);
//
//  extern virtual function void config_pre_output_port_put_cb_exec(kei_vip_i2c_agent_configuration cfg);
//
//  extern virtual protected function void startup_cb_exec();
  extern function void assign_vif();
//  extern virtual task kei_vip_apply_cfg();
//  extern task collect_errors();
  extern task received_and_sent();

endclass : kei_vip_i2c_slave_monitor

function kei_vip_i2c_slave_monitor::new(string name,uvm_component parent=null);
    super.new(name,parent);
    xact_observed_port = new("xact_observed_port", this);
    data_observed_port = new("data_observed_port", this);
endfunction

function void kei_vip_i2c_slave_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("build_phase", "kei_vip_i2c_slave_monitor: Starting...",UVM_LOW)
    if(cfg==null && !uvm_config_db#(kei_vip_i2c_agent_configuration)::get(this,"","cfg",cfg)) begin
      `uvm_fatal("build_phase", "Unable to get the slave agent configuration and failed to extract config info from the object")
    end else begin
        if(cfg.i2c_if==null)begin
            `uvm_fatal("build_phase", "A virtual interface was not received through the config object")
        end
        else begin
          common=kei_vip_i2c_slave_monitor_common::type_id::create("common"); 
          common.cfg = this.cfg;
          this.assign_vif();
        end
    end
    `uvm_info("build_phase", $sformatf("%s: finishing...",get_type_name()), UVM_LOW)
  endfunction

task kei_vip_i2c_slave_monitor::reconfigure_via_task(kei_vip_i2c_configuration cfg);
  if(!$cast(this.cfg, cfg))
    `uvm_fatal("CASTFAIL", "I2C configuration handle type inconsistence")
  common.reconfigure_via_task(cfg);
endtask


task kei_vip_i2c_slave_monitor::source_events();
fork
    /*
    forever begin
        @common.event_mon_start_confition);
        EVENT_START_CONDITION.trigger; 
    end
    forever begin
        @common.event_mon_stop_confition);
        EVENT_STOP_CONDITION.trigger; 
    end
    forever begin
        @common.event_mon_ack_received);
        EVENT_ACK_RECEIVED.trigger; 
    end
    forever begin
        @common.event_mon_nack_received);
        EVENT_NACK_RECEIVED.trigger; 
    end
    forever begin
        @common.event_mon_start_byte);
        EVENT_START_BYTE.trigger; 
    end
    forever begin
        @common.event_mon_gen_call);
        EVENT_GEN_CALL.trigger; 
    end
    forever begin
        @common.event_mon_slave_add_7_b);
        EVENT_SLAVE_ADD_7_B.trigger; 
    end
    forever begin
        @common.event_mon_slave_add_10_b);
        EVENT_SLAVE_ADD_10_B.trigger; 
    end
    forever begin
        @common.event_mon_get_packet);
        EVENT_GET_PACKET.trigger; 
    end
    forever begin
        @common.event_mon_repeated_start_condition);
        EVENT_REPEATED_START_CONDITION.trigger; 
    end
    */
join

endtask

function void kei_vip_i2c_slave_monitor::assign_vif();
  common.assign_vif(cfg.i2c_if); 
endfunction

task kei_vip_i2c_slave_monitor::received_and_sent();
  kei_vip_i2c_slave_transaction trans = new();
  kei_vip_i2c_slave_transaction trans_tmp = new();
  fork
       common.collect_transfer(trans);
      forever begin
          wait(trans.data.size()!=0 | common.end_flag);
          $cast(trans_tmp,trans.clone());
          xact_observed_port.write(trans_tmp);
          data_observed_port.write(trans_tmp);
          $display("slave monitor get trans, print_slv_mon_trans");
          trans_tmp.print();
          trans.data.delete();
          common.end_flag = 0;
      end
  join_none
endtask

task kei_vip_i2c_slave_monitor::run_phase(uvm_phase phase);
   super.run_phase(phase);
  `uvm_info("run_phase", "kei_vip_i2c_slave_monitor::Starting...", UVM_LOW)
  `uvm_info("run_phase", "Wait for Reset...", UVM_DEBUG)
  common.wait_for_reset(); 
  `uvm_info("run_phase", "Wait for Observed...", UVM_DEBUG)
  fork
   source_events();
   received_and_sent();
  join_none
  
  `uvm_info("run_phase", "kei_vip_i2c_slave_monitor::Finishing...", UVM_LOW)
endtask

`endif // KEI_VIP_I2C_SLAVE_MONITOR_SVH


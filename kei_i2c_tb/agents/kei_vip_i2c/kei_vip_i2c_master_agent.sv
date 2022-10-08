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


`ifndef KEI_VIP_I2C_MASTER_AGENT_SVH
`define KEI_VIP_I2C_MASTER_AGENT_SVH

class kei_vip_i2c_master_agent extends uvm_agent;

  local bit configure_vip_for_first_time=0;
  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////
  local kei_vip_i2c_agent_configuration cfg;
  protected kei_vip_i2c_agent_configuration cfg_snapshot;
  // The following are the verification components that make up
  // this agent
  kei_vip_i2c_master_driver driver;
  kei_vip_i2c_master_sequencer sequencer;
  kei_vip_i2c_master_monitor monitor;
  kei_vip_i2c_vif vif;

  // USER: Add your fields here

  // This macro performs UVM object creation, type control manipulation, and 
  // factory registration
  `uvm_component_utils_begin(kei_vip_i2c_master_agent)
    // USER: Register your fields here
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_object(cfg, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  extern function new (string name="kei_vip_i2c_master_agent", uvm_component parent=null);

  // uvm build phase
  extern function void build_phase(uvm_phase phase);

  // uvm connection phase
  extern function void connect_phase(uvm_phase phase);
  
  extern virtual task reconfigure_via_task(kei_vip_i2c_agent_configuration cfg);

  extern task run_phase(uvm_phase phase);

  extern task handle_runtime_rst();
  //////////////////////////////////////////////////////////////////////////////
  //
  //  Implementation (private) interface
  //
  //////////////////////////////////////////////////////////////////////////////


endclass : kei_vip_i2c_master_agent

function kei_vip_i2c_master_agent::new(string name="kei_vip_i2c_master_agent",uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function void kei_vip_i2c_master_agent::build_phase(uvm_phase phase);
  int active_int;
  bit active_bit;
  string xml_inst_name = this.get_full_name();

  super.build_phase(phase);
  `uvm_info("build_phase","kei_vip_i2c_master_agent: starting...",UVM_LOW)

  if(cfg==null && !uvm_config_db#(kei_vip_i2c_agent_configuration)::get(this,"","cfg",cfg)) begin
    `uvm_fatal("build_phase","'cfg' is null. An kei_vip_i2c_agent_configuration object or derivitive object must be set using the UVM configuration infrastructure.")
  end else begin
    if(!$cast(cfg_snapshot,cfg.clone())) begin
      `uvm_fatal("build_phase","unable to cast the received configuration.")
  end else begin
    if(uvm_config_db#(kei_vip_i2c_vif)::get(this,"","vif",vif)) begin
      if(cfg.i2c_if != null) begin
        `uvm_warning("build_phase","thie virtual interface is valid in the received.")
        cfg.set_i2c_if(vif);
        cfg_snapshot.set_i2c_if(vif);
      end else begin
        `uvm_warning("build_phase","applying the virtual interface received throng the config db to the confuration.")
        cfg.set_i2c_if(vif);
        cfg_snapshot.set_i2c_if(vif);
      end
    end else begin
      if(cfg.i2c_if == null) begin
        `uvm_fatal("build_phase","a virtual interface was not received either through the config db")
      end
    end
  end
end

if (uvm_config_db#(bit)::get(this,"","is_active",active_bit)) begin
  is_active = uvm_active_passive_enum'(active_bit);
  cfg.is_active = active_bit;
end 
else if(uvm_config_db#(int)::get(this,"","is_active",active_int)) begin
  is_active = uvm_active_passive_enum'(active_int);
  cfg.is_active = active_int;
end
else if(uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active)) begin
  cfg.is_active = int'(is_active);
end

if(cfg.is_active) begin
 `uvm_info("build_phase","creating active agent",UVM_LOW)
 driver=kei_vip_i2c_master_driver::type_id::create("driver",this);
 sequencer = kei_vip_i2c_master_sequencer::type_id::create("sequencer",this);
 monitor = kei_vip_i2c_master_monitor::type_id::create("monitor",this);
end
else begin
  `uvm_info("build_phase","creating passive agent",UVM_LOW)
   monitor = kei_vip_i2c_master_monitor::type_id::create("monitor",this);
end

this.cfg.inst = $sformatf("%s.monitor",this.get_full_name());
uvm_config_db#(kei_vip_i2c_agent_configuration)::set(this,"monitor","cfg",cfg);

if(cfg.is_active) begin
  this.cfg.inst=$sformatf("%s.driver",this.get_full_name());
  uvm_config_db#(kei_vip_i2c_agent_configuration)::set(this,"driver","cfg",cfg);
  this.cfg.inst=$sformatf("%s.sequencer",this.get_full_name());
  uvm_config_db#(kei_vip_i2c_agent_configuration)::set(this,"sequencer","cfg",cfg);
end

this.cfg.inst= this.get_full_name();
`uvm_info("build_phase","agent configuration",UVM_LOW)


//TODO others 

  `uvm_info("build_phase","kei_vip_i2c_master_agent: finishing...",UVM_LOW)
endfunction : build_phase

function void kei_vip_i2c_master_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("connect_phase","kei_vip_i2c_master_agent: starting...",UVM_LOW)
  if(cfg.is_active) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
  end
  `uvm_info("connect_phase","kei_vip_i2c_master_agent: finishing...",UVM_LOW)
endfunction : connect_phase

task kei_vip_i2c_master_agent::reconfigure_via_task(kei_vip_i2c_agent_configuration cfg);
  kei_vip_i2c_agent_configuration agent_cfg;

  if(configure_vip_for_first_time) begin
    if($cast(agent_cfg,cfg)) begin
      //monitor.confi_pre_output_port_put_cb_exec(agent_cfg);
      this.cfg.copy(agent_cfg);
    end
  end

  if($cast(agent_cfg,cfg)) begin
    `uvm_info("reconfigure_via_task", $sformatf("configuration at %s:\n%s",get_full_name(),agent_cfg.sprint()),UVM_LOW)
  end

  //monirot.reconfigure_via_task(cfg);
  if(agent_cfg.is_active) begin
    driver.reconfigure_via_task(cfg);
    sequencer.reconfigure(cfg);
  end

  configure_vip_for_first_time = 1'b1;
endtask : reconfigure_via_task

task kei_vip_i2c_master_agent::run_phase(uvm_phase phase);
  `uvm_info("run_phase","kei_vip_i2c_master_agent run phase: starting...",UVM_LOW)
  super.run_phase(phase);

  //monitor.wait_for_rst();
  reconfigure_via_task(cfg);

//  fork
//    handle_runtime_rst();
//  join_none

  `uvm_info("run_phase","kei_vip_i2c_master_agent run phase: finishing...",UVM_LOW)
endtask : run_phase

task kei_vip_i2c_master_agent::handle_runtime_rst();
//  forever  begin
    //monitor.wait_for_rst();
    reconfigure_via_task(cfg);
//  end
endtask : handle_runtime_rst

`endif // KEI_VIP_I2C_MASTER_AGENT_SVH


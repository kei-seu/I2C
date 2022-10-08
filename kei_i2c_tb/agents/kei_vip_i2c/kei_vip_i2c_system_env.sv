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

`ifndef KEI_VIP_I2C_SYSTEM_ENV_SV
`define KEI_VIP_I2C_SYSTEM_ENV_SV

class kei_vip_i2c_system_env  extends uvm_env;

  kei_vip_i2c_vif   vif;

  kei_vip_i2c_master_agent  master[$];
  kei_vip_i2c_slave_agent   slave[$];

  kei_vip_i2c_system_sequencer  sequencer;

  protected kei_vip_i2c_system_configuration   cfg_snapshot;

  local kei_vip_i2c_system_configuration cfg;

uvm_report_object  reporter = this;

uvm_event_pool  event_pool;

int intermediate_report = 1;

protected bit is_running;

protected uvm_phase  hdl_cmd_phase;

local int original_verbosity;

`uvm_component_utils_begin(kei_vip_i2c_system_env)
  `uvm_field_object(cfg, UVM_ALL_ON)
`uvm_component_utils_end

extern function new(string name="kei_vip_i2c_system_env", uvm_component parent = null);

extern virtual function void build_phase(uvm_phase phase);

extern virtual function void connect_phase(uvm_phase phase);

//extern virtual task run_phase(uvm_phase phase);

//extern function void display_checked_out_features();

//extern virtual function void report_phase(uvm_phase phase);

//extern virtual function void final_phase(uvm_phase phase);

//extern virtual function void phase_started(uvm_phase phase);

//extern virtual function void pre_abort();

//extern virtual function string get_suite_name();

extern virtual task reconfigure(kei_vip_i2c_configuration cfg);

extern virtual function void get_cfg(ref kei_vip_i2c_configuration cfg);

extern virtual protected function void change_static_cfg(kei_vip_i2c_configuration cfg);

extern virtual protected function void change_dynamic_cfg(kei_vip_i2c_configuration cfg);

extern virtual protected function void get_static_cfg(ref kei_vip_i2c_configuration cfg);

extern virtual protected function void get_dynamic_cfg(ref kei_vip_i2c_configuration cfg);

//extern virtual protected function bit is_valid_cfg_type(kei_vip_i2c_configuration cfg);

virtual protected function bit get_is_running();
  get_is_running = this.is_running;
endfunction : get_is_running

endclass : kei_vip_i2c_system_env

function kei_vip_i2c_system_env::new(string name="kei_vip_i2c_system_env",uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function void kei_vip_i2c_system_env::build_phase(uvm_phase phase);
  string method_name = "build_phase";
  int build_ok = 1;
  super.build_phase(phase);

  if(!uvm_config_db#(kei_vip_i2c_system_configuration)::get(this,"","cfg",cfg) || (cfg == null)) 
  begin
    `uvm_fatal(method_name, "'cfg' is null. An kei_vip_i2c_system_configuration object or derivitive object must be set using the verification methodology specific configuration infrastructure.");
  end 
  else 
  begin
      //if(!cfg.is_valid(0)) begin  //don't understand how to implement this function
      if(!$cast(cfg_snapshot,cfg.clone())) 
      begin
          `uvm_fatal(method_name,"unable to cast the received configuration");
          build_ok = 0;
      end 

      if (cfg.i2c_if == null) begin

          if(uvm_config_db#(kei_vip_i2c_vif)::get(this,"","vif",vif)) 
          begin
              cfg.set_if(vif);
              cfg_snapshot.set_if(vif);
          end 
          else 
          begin
              `uvm_fatal(method_name, "a vritual interface was not received.");
              build_ok=0;
          end
      end
      //else begin            
      //        cfg.set_if(vif);
      //        cfg_snapshot.set_if(vif);
      //    end 
  
    end

  if(build_ok) begin
      for(int i=0; i<cfg.num_masters; i++) begin
        kei_vip_i2c_master_agent master_agent = kei_vip_i2c_master_agent::type_id::create($sformatf("master[%0d]",i),this);
        master.push_back(master_agent);
        cfg.master_cfg[i].agent_id = i;
        cfg.master_cfg[i].inst = $sformatf("%s.master[%0d]",this.get_full_name(),i); 
        uvm_config_db#(kei_vip_i2c_agent_configuration)::set(this,$sformatf("master[%0d]",i),"cfg",cfg.master_cfg[i]);
      end

      for(int i=0; i<cfg.num_slaves; i++) begin
         kei_vip_i2c_slave_agent slave_agent = kei_vip_i2c_slave_agent::type_id::create($sformatf("slave[%0d]",i),this);
        slave.push_back(slave_agent);
        cfg.slave_cfg[i].agent_id = i;
        cfg.slave_cfg[i].inst = $sformatf("%s.slave[%0d]",this.get_full_name(),i); 
        uvm_config_db#(kei_vip_i2c_agent_configuration)::set(this,$sformatf("slave[%0d]",i),"cfg",cfg.slave_cfg[i]);
      end

      sequencer = kei_vip_i2c_system_sequencer::type_id::create("sequencer",this);
      uvm_config_db#(kei_vip_i2c_system_configuration)::set(this,"sequencer","cfg",cfg);
  end
endfunction : build_phase

function void kei_vip_i2c_system_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  for(int i=0; i<cfg.num_masters; i++) begin
    sequencer.master_sequencer[i] = master[i].sequencer;
  end

  for(int i=0; i<cfg.num_slaves; i++) begin
    sequencer.slave_sequencer[i] = slave[i].sequencer;
  end
endfunction : connect_phase

function void kei_vip_i2c_system_env::change_static_cfg(kei_vip_i2c_configuration cfg);
//  this.cfg.copy_static_data(cfg);
//  this.cfg_snapshot.copy_static_data(cfg);
endfunction : change_static_cfg

function void kei_vip_i2c_system_env::change_dynamic_cfg(kei_vip_i2c_configuration cfg);
//  this.cfg.copy_dynamic_data(cfg);
//  this.cfg_snapshot.copy_dynamic_data(cfg);
endfunction : change_dynamic_cfg

function void kei_vip_i2c_system_env::get_static_cfg(ref kei_vip_i2c_configuration cfg);
  if(cfg==null) begin
    void'($cast(cfg,this.cfg.create()));
  end
 // cfg.copy_static_data(this.cfg);
endfunction : get_static_cfg

function void kei_vip_i2c_system_env::get_dynamic_cfg(ref kei_vip_i2c_configuration cfg);
  if(cfg==null) begin
    void'($cast(cfg,this.cfg.create()));
  end
 // cfg.copy_dynamic_data(this.cfg);
endfunction : get_dynamic_cfg

task kei_vip_i2c_system_env::reconfigure(kei_vip_i2c_configuration cfg);
  kei_vip_i2c_system_configuration sys_cfg;
  cfg.inst = this.get_full_name();

  if(!$cast(sys_cfg,cfg)) begin
    `uvm_fatal("reconfigure","unable to cast the received configration.");
  end

  foreach(sys_cfg.master_cfg[i]) begin
    kei_vip_i2c_agent_configuration master_cfg;
    if(!$cast(master_cfg,sys_cfg.master_cfg[i])) begin
      `uvm_fatal("reconfigure","unable to cast the received configuration.");
    end
    master_cfg.inst = $sformatf("%s.master[%0d]",this.get_full_name(),i);
    if(master[i] != null) master[i].reconfigure_via_task(sys_cfg.master_cfg[i]);
  end

  foreach(sys_cfg.slave_cfg[i]) begin
    kei_vip_i2c_agent_configuration slave_cfg;
    if(!$cast(slave_cfg,sys_cfg.slave_cfg[i])) begin
      `uvm_fatal("reconfigure","unable to cast the received configuration.");
    end
    slave_cfg.inst = $sformatf("%s.slave[%0d]",this.get_full_name(),i);
    if(slave[i] != null) slave[i].reconfigure_via_task(sys_cfg.slave_cfg[i]);
  end

endtask : reconfigure

function void kei_vip_i2c_system_env::get_cfg(ref kei_vip_i2c_configuration cfg);
  $cast(cfg, this.cfg);
endfunction : get_cfg


`endif // KEI_VIP_I2C_SYSTEM_ENV_SV


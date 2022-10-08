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


`ifndef KEI_VIP_I2C_SYSTEM_SEQUENCER_SV
`define KEI_VIP_I2C_SYSTEM_SEQUENCER_SV

class kei_vip_i2c_system_sequencer  extends kei_vip_i2c_sequencer;

  kei_vip_i2c_master_sequencer     master_sequencer[];
  kei_vip_i2c_slave_sequencer      slave_sequencer[];

  protected kei_vip_i2c_system_configuration  cfg_snapshot;
  local kei_vip_i2c_system_configuration  cfg;
//  kei_vip_i2c_agent_configuration    sqr_cfg;
//  kei_vip_i2c_configuration    i2c_cfg;

  `uvm_component_utils_begin(kei_vip_i2c_system_sequencer)
       `uvm_field_object(cfg, UVM_ALL_ON)
  `uvm_component_utils_end

  extern function new(string name="kei_vip_i2c_system_sequencer", uvm_component parent=null);

  extern function void build_phase(uvm_phase phase);

  extern virtual function void get_cfg(ref kei_vip_i2c_configuration cfg);

endclass : kei_vip_i2c_system_sequencer

function kei_vip_i2c_system_sequencer::new(string name="kei_vip_i2c_system_sequencer",uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function void  kei_vip_i2c_system_sequencer::get_cfg(ref kei_vip_i2c_configuration cfg);
   $cast(cfg, this.cfg);
   //cfg = this.cfg;
endfunction : get_cfg

function void kei_vip_i2c_system_sequencer::build_phase(uvm_phase phase);
    string method_name = "build_phase";
    super.build_phase(phase);

    if(cfg == null && !uvm_config_db#(kei_vip_i2c_system_configuration)::get(this,"","cfg",cfg)) begin
        `uvm_fatal(method_name,"'cfg' is null,an kei_vip_i2c_system_configureation object or derivitive object must be set using the UVM configruartion infrastructure.")
      end else begin
        if(cfg.i2c_if ==null) begin
          `uvm_fatal("new", "A virtual interface was not received either throught the config db, or therough the configuration object");
        end else begin
        `uvm_info("new", "provided 'cfg' is valid, using to define configuration.", UVM_LOW);
        master_sequencer = new[cfg.num_masters];
        slave_sequencer  = new[cfg.num_slaves];
        if(!$cast(this.cfg,cfg.clone())) begin
          `uvm_fatal("new","unable to use configuration infrastructure provided 'cfg' to create a new configuration which can be stored as 'cfg'.unable to continue.");
        end else if(!$cast(this.cfg_snapshot,cfg.clone())) begin
           `uvm_fatal("new","unable to use configuration infrastructure provided 'cfg' to create a new configuration which can be stored as 'cfg_snapshot'.unable to continue.")
      end
    end
  end

endfunction : build_phase

`endif // KEI_VIP_I2C_SYSTEM_SEQUENCER_SV

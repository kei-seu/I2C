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


`ifndef KEI_VIP_I2C_SLAVE_SEQUENCER_SVH
`define KEI_VIP_I2C_SLAVE_SEQUENCER_SVH

class kei_vip_i2c_slave_sequencer extends kei_vip_i2c_sequencer #(kei_vip_i2c_slave_transaction);

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////
  kei_vip_i2c_agent_configuration cfg;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(kei_vip_i2c_slave_sequencer)
     // USER: Register fields 
     `uvm_field_object(cfg, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  extern function new (string name="kei_vip_i2c_slave_sequencer",uvm_component parent=null);

  extern virtual function void build_phase(uvm_phase phase);

  extern virtual function void reconfigure(kei_vip_i2c_configuration cfg);

  extern virtual function void get_cfg(ref kei_vip_i2c_configuration cfg);

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Implementation (private) interface
  //
  //////////////////////////////////////////////////////////////////////////////

endclass : kei_vip_i2c_slave_sequencer

function kei_vip_i2c_slave_sequencer::new(string name="kei_vip_i2c_slave_sequencer",uvm_component parent=null);
  super.new(name,parent);
endfunction : new

function void kei_vip_i2c_slave_sequencer::build_phase(uvm_phase phase);
    string method_name = "build_phase";
    super.build_phase(phase);

  begin
    if(cfg == null) begin
      if(uvm_config_db#(kei_vip_i2c_agent_configuration)::get(this,"","cfg",cfg) && (cfg!=null)) begin
        `uvm_info(method_name,"cfg get ok",UVM_LOW)
        if(!($cast(this.cfg,cfg.clone()))) begin
          `uvm_fatal(method_name, "Failed when attempting to cast kei_vip_i2c_slave_configuration");
        end
      end else begin
        `uvm_fatal(method_name, "'cfg' is null. An kei_vip_i2c_slave_configuration object or derivative object must be set using the configuration infrastructure or via reconfigure.");
      end
    end
  end
endfunction : build_phase

function void kei_vip_i2c_slave_sequencer::reconfigure(kei_vip_i2c_configuration cfg); 
  /*   if(cfg==null) begin
        `uvm_error("reconfigure", "Recfg is null."); end
        else begin
            this.cfg = cfg; end 
*/
     if (!$cast(this.cfg, cfg)) begin 
    `uvm_error("reconfigure", "Failed attempting to assign 'cfg' argument to sequencer 'cfg' field."); 
  end 
endfunction 

function void  kei_vip_i2c_slave_sequencer::get_cfg(ref kei_vip_i2c_configuration cfg);
   cfg = this.cfg;
endfunction : get_cfg

`endif // KEI_VIP_I2C_SLAVE_SEQUENCER_SVH



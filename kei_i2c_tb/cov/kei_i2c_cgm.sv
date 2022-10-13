

`ifndef KEI_I2C_CGM_SV
`define KEI_I2C_CGM_SV

// Coverage Model
class kei_i2c_cgm extends uvm_component;

  // Analysis import declarion below
  uvm_analysis_imp_apb_master #(kei_vip_apb_transfer,kei_i2c_cgm) apb_trans_observed_imp;
	uvm_analysis_imp_i2c_slave #(kei_vip_i2c_slave_transaction,kei_i2c_cgm) i2c_trans_observed_imp;
  
  // Events
  uvm_event kei_i2c_field_access_bd_e; //  register field backdoor access event
  uvm_event kei_i2c_field_access_fd_e; //  register field frontdoor access event
  
  kei_i2c_config cfg;
  ral_block_kei_i2c rgm;
  virtual kei_i2c_if vif;
  
  `uvm_component_utils(kei_i2c_cgm)
  
  // TODO
  // Covergroup definition below
  
  function new(string name = "kei_i2c_cgm", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // TLM port instances
    i2c_trans_observed_imp = new("i2c_trans_observed_imp",this);
    apb_trans_observed_imp = new("apb_trans_observed_imp",this);
    
    // Get global uvm event
    kei_i2c_field_access_bd_e = uvm_event_pool::get_global("kei_i2c_field_access_bd_e");
    kei_i2c_field_access_fd_e = uvm_event_pool::get_global("kei_i2c_field_access_fd_e");
    
    if(!uvm_config_db#(kei_i2c_config)::get(this,"","cfg",cfg))
      begin
        `uvm_error("build_phase","Unable to get kei_i2c_config from uvm_config_db")
      end
    rgm = cfg.rgm;
    vif = cfg.vif;
    
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
  
  virtual function void write_apb_master(kei_vip_apb_transfer tr);
    // TODO
  endfunction
  
  virtual function void write_i2c_slave(kei_vip_i2c_slave_transaction tr);
    // TODO
  endfunction
  
endclass


`endif // KEI_I2C_CGM_SV

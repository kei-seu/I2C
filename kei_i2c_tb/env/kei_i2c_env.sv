
`ifndef KEI_I2C_ENV_SV
`define KEI_I2C_ENV_SV

class kei_i2c_env extends uvm_component;

  // top configuration
  virtual kei_i2c_if vif;
  
  virtual kei_i2c_backdoor_if backdoor_vif;
  
  virtual kei_vip_i2c_if i2c_vif;
  
  kei_i2c_config cfg;

  kei_vip_apb_master_agent apb_mst;

  kei_vip_i2c_master_agent i2c_mst;
  
  kei_vip_i2c_slave_agent i2c_slv;

  // top scoreboard
  kei_i2c_master_scoreboard sbd_mst;

  // top virtual sequencer
  kei_i2c_virtual_sequencer sqr;

  // top coverage model
  kei_i2c_cgm cgm;

  // top register model and related components
  ral_block_kei_i2c rgm;
  kei_vip_apb_reg_adapter adapter;
  uvm_reg_predictor #(kei_vip_apb_transfer) predictor;

  `uvm_component_utils(kei_i2c_env)

  function new (string name = "kei_i2c_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(kei_i2c_config)::get(this, "", "cfg", cfg)) 
      begin
        `uvm_error("build_phase", "Unable to get kei_i2c_config from uvm_config_db")
      end
      
    if(!uvm_config_db#(virtual kei_i2c_if)::get(this,"","vif",vif))
      begin
        `uvm_error("GETVIF","cannot get kei_i2c_if handle from config DB")
      end
    cfg.vif = vif;
    
    if(!uvm_config_db#(virtual kei_i2c_backdoor_if)::get(this,"","backdoor_vif",backdoor_vif))
      begin
        `uvm_error("GETVIF","cannot get kei_i2c_backdoor_if handle from config DB")
      end
    cfg.backdoor_vif = backdoor_vif;
    
    if(!uvm_config_db#(virtual kei_vip_i2c_if)::get(this,"","i2c_vif",i2c_vif))
      begin
        `uvm_error("GETVIF","cannot get kei_vip_i2c_if handle from config DB")
      end
    cfg.i2c_vif = i2c_vif;
      
    if(!uvm_config_db #(ral_block_kei_i2c)::get(this, "", "rgm", rgm))  
      begin
        `uvm_info("build_phase", "Unable to get ral_block_kei_i2c from uvm_config_db and create a RGM locally", UVM_LOW)
        rgm = ral_block_kei_i2c::type_id::create("rgm", this);
        rgm.build();
        rgm.lock_model();
      end
    cfg.rgm = rgm;
    cfg.rgm.cg_addr_enable = cfg.reg_model_cg_addr_enable;
    uvm_config_db#(ral_block_kei_i2c)::set(this,"*","rgm", rgm);
    adapter = kei_vip_apb_reg_adapter::type_id::create("adapter", this);
    predictor = uvm_reg_predictor#(kei_vip_apb_transfer)::type_id::create("predictor", this);

    uvm_config_db#(kei_vip_apb_config)::set(this, "apb_mst*", "cfg", cfg.apb_cfg);
    apb_mst = kei_vip_apb_master_agent::type_id::create("apb_mst", this);

    void'(uvm_config_db#(virtual kei_vip_i2c_if)::get(this, "", "i2c_vif", cfg.i2c_cfg.master_cfg[0].i2c_if));
    uvm_config_db#(kei_vip_i2c_agent_configuration)::set(this, "i2c_mst*", "cfg", cfg.i2c_cfg.master_cfg[0]);
    i2c_mst = kei_vip_i2c_master_agent::type_id::create("i2c_mst", this);

    void'(uvm_config_db#(virtual kei_vip_i2c_if)::get(this, "", "i2c_vif", cfg.i2c_cfg.slave_cfg[0].i2c_if));
    uvm_config_db#(kei_vip_i2c_agent_configuration)::set(this, "i2c_slv*", "cfg", cfg.i2c_cfg.slave_cfg[0]);
    i2c_slv = kei_vip_i2c_slave_agent::type_id::create("i2c_slv", this);
    
    uvm_config_db#(kei_i2c_config)::set(this, "sbd_mst", "cfg", cfg);
    sbd_mst = kei_i2c_master_scoreboard::type_id::create("sbd_mst", this);

    uvm_config_db#(kei_i2c_config)::set(this, "sqr", "cfg", cfg);
    sqr = kei_i2c_virtual_sequencer::type_id::create("sqr", this);
    
    uvm_config_db#(kei_i2c_config)::set(this, "cgm", "cfg", cfg);
    cgm = kei_i2c_cgm::type_id::create("cgm", this);
  
  endfunction: build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // TODO
    // connect monitor analysis port to scoreboard
    apb_mst.monitor.item_collected_port.connect(sbd_mst.apb_trans_observed_imp); 
		i2c_slv.monitor.xact_observed_port.connect(sbd_mst.i2c_trans_observed_imp);
    
    // TODO
    // connect monitor analysis port to coverage model
    apb_mst.monitor.item_collected_port.connect(cgm.apb_trans_observed_imp); 
		i2c_slv.monitor.xact_observed_port.connect(cgm.i2c_trans_observed_imp);
    
    // virtual sequencer routing with sub-sequencers
    sqr.apb_mst_sqr = apb_mst.sequencer;
    sqr.i2c_mst_sqr = i2c_mst.sequencer;
    sqr.i2c_slv_sqr = i2c_slv.sequencer;
    
    // register model integration
    rgm.default_map.set_sequencer(apb_mst.sequencer,adapter);
    apb_mst.monitor.item_collected_port.connect(predictor.bus_in);
    predictor.map = rgm.default_map;
    predictor.adapter = adapter;
    
  endfunction: connect_phase

endclass


`endif

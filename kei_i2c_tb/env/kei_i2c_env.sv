
`ifndef KEI_I2C_ENV_SV
`define KEI_I2C_ENV_SV

class kei_i2c_env extends uvm_component;

  // top configuration
  kei_i2c_config cfg;

  kei_vip_apb_master_agent apb_mst;

  kei_vip_i2c_master_agent i2c_mst;

  kei_vip_i2c_slave_agent i2c_slv;

  // top scoreboard
  kei_i2c_scoreboard sbd;

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

  endfunction: build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // TODO
    // connect monitor analysis port to scoreboard
      
    // TODO
    // connect monitor analysis port to coverage model

    // virtual sequencer routing with sub-sequencers

    // register model integration

  endfunction: connect_phase

endclass


`endif

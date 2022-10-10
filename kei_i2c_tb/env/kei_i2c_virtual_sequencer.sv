

`ifndef KEI_I2C_VIRTUAL_SEQUENCER_SV
`define KEI_I2C_VIRTUAL_SEQUENCER_SV

class kei_i2c_virtual_sequencer extends uvm_sequencer;
  kei_vip_apb_master_sequencer apb_mst_sqr;
  kei_vip_i2c_master_sequencer i2c_mst_sqr;
  kei_vip_i2c_slave_sequencer i2c_slv_sqr;
  ral_block_kei_i2c rgm;
  virtual kei_i2c_if vif;

  `uvm_component_utils(kei_i2c_virtual_sequencer)

  function new (string name = "kei_i2c_virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // configuration items below would be needed by virtual sequence
    if(!uvm_config_db#(virtual kei_i2c_if)::get(this,"","vif",vif))
      `uvm_error("GETVIF","cannot get kei_i2c_if handle from config DB")
    if(!uvm_config_db#(ral_block_kei_i2c)::get(this,"","rgm",rgm))
      `uvm_error("GETRGM","cannot get RGM handle from config DB")
      
  endfunction

endclass

`endif // KEI_I2C_VIRTUAL_SEQUENCER_SV

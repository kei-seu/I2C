
`ifndef KEI_I2C_BASE_SEQUENCE_SV
`define KEI_I2C_BASE_SEQUENCE_SV

virtual class kei_i2c_base_sequence extends uvm_sequence #(kei_vip_i2c_slave_transaction);

  ral_block_kei_i2c rgm;

  kei_vip_i2c_configuration cfg;

  `uvm_declare_p_sequencer(kei_vip_i2c_master_sequencer)

  // Register model variables:
  uvm_status_e status;
  rand uvm_reg_data_t data;

  virtual task pre_body();
    if(!uvm_config_db #(ral_block_kei_i2c)::get(m_sequencer, "", "rgm", rgm)) begin
      `uvm_error("body", "Unable to find ral_block_kei_i2c in uvm_config_db")
    end
    p_sequencer.get_cfg(cfg);
  endtask
endclass


`endif // KEI_I2C_BASE_SEQUENCE_SV

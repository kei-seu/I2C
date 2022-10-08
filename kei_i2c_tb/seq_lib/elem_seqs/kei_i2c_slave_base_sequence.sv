
`ifndef KEI_I2C_SLAVE_BASE_SEQUENCE_SV
`define KEI_I2C_SLAVE_BASE_SEQUENCE_SV

virtual class kei_i2c_slave_base_sequence extends uvm_sequence #(kei_vip_i2c_slave_transaction);

  ral_block_kei_i2c rgm;
  kei_vip_i2c_configuration cfg;

  // Register model variables:
  uvm_status_e status;
  rand uvm_reg_data_t data;

  `uvm_declare_p_sequencer(kei_vip_i2c_slave_sequencer)

  function new (string name = "kei_i2c_slave_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    // TODO
    // Attach element sequences below
  endtask
endclass


`endif // KEI_I2C_SLAVE_BASE_SEQUENCE_SV

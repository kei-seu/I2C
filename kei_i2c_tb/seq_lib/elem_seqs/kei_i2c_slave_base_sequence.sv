
`ifndef KEI_I2C_SLAVE_BASE_SEQUENCE_SV
`define KEI_I2C_SLAVE_BASE_SEQUENCE_SV

virtual class kei_i2c_slave_base_sequence extends uvm_sequence #(kei_vip_i2c_slave_transaction);
  
  // WRITE/READ data packet content
  rand bit [7:0] packet[];

  rand int nack_addr = -1;
  rand int nack_data = -1;
  rand int nack_addr_count = -1;

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
    if(!uvm_config_db #(ral_block_kei_i2c)::get(m_sequencer, "", "rgm", rgm)) begin
      `uvm_error("body", "Unable to find ral_block_kei_i2c in uvm_config_db")
    end
    p_sequencer.get_cfg(cfg);
    // TODO
    // Attach element sequences below
  endtask
endclass


`endif // KEI_I2C_SLAVE_BASE_SEQUENCE_SV

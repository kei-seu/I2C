
`ifndef KEI_I2C_SLAVE_RX_SEQ_SV
`define KEI_I2C_SLAVE_RX_SEQ_SV

class kei_i2c_slave_rx_seq extends kei_i2c_slave_base_sequence;

  `uvm_object_utils(kei_i2c_slave_rx_seq)

 

  function new (string name = "kei_apb_config_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // KEI_I2C_SLAVE_RX_SEQ_SV

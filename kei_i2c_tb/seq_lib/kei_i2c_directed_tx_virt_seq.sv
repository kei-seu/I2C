`ifndef KEI_I2C_DIRECTED_TX_VIRT_SEQ_SV
`define KEI_I2C_DIRECTED_TX_VIRT_SEQ_SV
class kei_i2c_directed_tx_virt_seq extends kei_i2c_base_virtual_sequence;

  `uvm_object_utils(kei_i2c_directed_tx_virt_seq)

  function new (string name = "kei_i2c_directed_tx_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();

    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // KEI_I2C_DIRECTED_TX_VIRT_SEQ_SV
`ifndef KEI_I2C_QUICK_REG_ACCESS_VIRT_SEQ_SV
`define KEI_I2C_QUICK_REG_ACCESS_VIRT_SEQ_SV
class kei_i2c_quick_reg_access_virt_seq extends kei_i2c_base_virtual_sequence;

  `uvm_object_utils(kei_i2c_quick_reg_access_virt_seq)

  function new (string name = "kei_i2c_quick_reg_access_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();

    #1ms;
    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // KEI_I2C_QUICK_REG_ACCESS_VIRT_SEQ_SV

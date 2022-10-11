`ifndef KEI_I2C_REG_HW_RESET_VIRT_SEQ_SV
`define KEI_I2C_REG_HW_RESET_VIRT_SEQ_SV
class kei_i2c_reg_hw_reset_virt_seq extends kei_i2c_base_virtual_sequence;

  `uvm_object_utils(kei_i2c_reg_hw_reset_virt_seq)

  function new (string name = "kei_i2c_reg_hw_reset_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);

    // TODO
    `uvm_info("BLTINSEQ","register reset sequence started",UVM_LOW)
    reg_rst_seq = new();
    rgm.reset();
    reg_rst_seq.model = rgm;
    reg_rst_seq.start(p_sequencer.apb_mst_sqr); 
    `uvm_info("BLTINSEQ","register reset sequence finished",UVM_LOW)
    
    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // KEI_I2C_REG_HW_RESET_VIRT_SEQ_SV

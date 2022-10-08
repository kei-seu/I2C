
`ifndef KEI_APB_BASE_SEQUENCE_SV
`define KEI_APB_BASE_SEQUENCE_SV

virtual class kei_apb_base_sequence extends uvm_sequence #(kei_vip_apb_transfer);

  ral_block_kei_i2c rgm;

  
  `uvm_declare_p_sequencer(kei_vip_apb_master_sequencer)

  // Register model variables:
  uvm_status_e status;
  rand uvm_reg_data_t data;

  function new (string name = "kei_apb_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    // TODO
    // Attach element sequences below
  endtask
endclass

`endif // KEI_APB_BASE_SEQUENCE_SV

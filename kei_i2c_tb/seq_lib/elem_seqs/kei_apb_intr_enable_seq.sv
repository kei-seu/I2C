
`ifndef KEI_APB_INTR_ENABLE_SEQ_SV
`define KEI_APB_INTR_ENABLE_SEQ_SV

class kei_apb_intr_enable_seq extends kei_apb_base_sequence;

  `uvm_object_utils(kei_apb_intr_enable_seq)


  function new (string name = "kei_apb_intr_enable_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();


    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // KEI_APB_INTR_ENABLE_SEQ_SV


`ifndef KEI_APB_WAIT_DETECT_ABORT_SOURCE_SEQ_SV
`define KEI_APB_WAIT_DETECT_ABORT_SOURCE_SEQ_SV

class kei_apb_wait_detect_abort_source_seq extends kei_apb_base_sequence;

  `uvm_object_utils(kei_apb_wait_detect_abort_source_seq)

  function new (string name = "kei_apb_wait_detect_abort_source_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();

    while(1) begin
      rgm.IC_RAW_INTR_STAT.mirror(status);
      if(rgm.IC_RAW_INTR_STAT.TX_ABRT.get() == 1) break;
      repeat(100) @(p_sequencer.vif.cb_mon);
    end
    
    rgm.IC_TX_ABRT_SOURCE.mirror(status);
    
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_7B_ADDR_NOACK.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_7B_ADDR_NOACK", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_10ADDR1_NOACK.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_10ADDR1_NOACK", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_10ADDR2_NOACK.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_10ADDR2_NOACK", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_TXDATA_NOACK.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_TXDATA_NOACK", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_GCALL_NOACK.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_GCALL_NOACK", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_GCALL_READ.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_GCALL_READ", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_HS_ACKDET.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_HS_ACKDET", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_SBYTE_ACKDET.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_SBYTE_ACKDET", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_HS_NORSTRT.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_HS_NORSTRT", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_SBYTE_NORSTRT.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_SBYTE_NORSTRT", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_10B_RD_NORSTRT.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_10B_RD_NORSTRT", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_MASTER_DIS.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_MASTER_DIS", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ARB_LOST.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ARB_LOST", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_SLVFLUSH_TXFIFO.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_SLVFLUSH_TXFIFO", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_SLV_ARBLOST.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_SLV_ARBLOST", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_SLVRD_INTX.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_SLVRD_INTX", UVM_LOW)
    if(rgm.IC_TX_ABRT_SOURCE.ABRT_USER_ABRT.get() == 1) `uvm_info(get_type_name(), "TX ABORT because of ABRT_USER_ABRT", UVM_LOW)

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // KEI_APB_WAIT_DETECT_ABORT_SOURCE_SEQ_SV

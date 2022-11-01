`ifndef KEI_APB_INTR_CLEAR_SEQ_SV
`define KEI_APB_INTR_CLEAR_SEQ_SV

class kei_apb_intr_clear_seq extends kei_apb_base_sequence;

  `uvm_object_utils(kei_apb_intr_clear_seq)

  constraint cstr{
    soft intr_id == 0;
  }

  function new (string name = "kei_apb_intr_clear_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();

    rgm.IC_RAW_INTR_STAT.mirror(status);
    case(intr_id)
      IC_RX_OVER_INTR_ID         : rgm.IC_CLR_RX_OVER.mirror(status);
      IC_RX_UNDER_INTR_ID        : rgm.IC_CLR_RX_UNDER.mirror(status);
      IC_TX_OVER_INTR_ID         : rgm.IC_CLR_TX_OVER.mirror(status);
      IC_TX_ABRT_INTR_ID         : rgm.IC_CLR_TX_ABRT.mirror(status); 
      IC_RX_DONE_INTR_ID         : rgm.IC_CLR_RX_DONE.mirror(status); 
      //IC_TX_EMPTY_INTR_ID        : NOTE:: NO REG; 
      IC_ACTIVITY_INTR_ID        : rgm.IC_CLR_ACTIVITY.mirror(status); 
      IC_STOP_DET_INTR_ID        : rgm.IC_CLR_STOP_DET.mirror(status); 
      IC_START_DET_INTR_ID       : rgm.IC_CLR_START_DET.mirror(status); 
      IC_RD_REQ_INTR_ID          : rgm.IC_CLR_RD_REQ.mirror(status); 
      //IC_RX_FULL_INTR_ID         : NOTE:: NO REG;  
      IC_GEN_CALL_INTR_ID        : rgm.IC_CLR_GEN_CALL.mirror(status); 
      //IC_RESTART_DET_INTR_ID     : NOTE:: NO REG;    
      //IC_MASTER_ON_HOLD_INTR_ID  : NOTE:: NO REG;   
      IC_ALL_INTR_ID             : rgm.IC_CLR_INTR.mirror(status);
      default : `uvm_error("INTRCL", $sformatf("The interrupt id [%0d] could not be clear via software register", intr_id))
    endcase
    repeat(100) @(p_sequencer.vif.cb_mon);
    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // KEI_APB_INTR_CLEAR_SEQ_SV

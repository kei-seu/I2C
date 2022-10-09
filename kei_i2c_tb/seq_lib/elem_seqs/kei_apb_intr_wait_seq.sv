`ifndef KEI_APB_INTR_WAIT_SEQ_SV
`define KEI_APB_INTR_WAIT_SEQ_SV

class kei_apb_intr_wait_seq extends kei_apb_base_sequence;

  constraint cstr{
    soft intr_id == 0;
  }

  `uvm_object_utils(kei_apb_intr_wait_seq)

  function new (string name = "kei_apb_intr_wait_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();

    while(1) begin
      rgm.IC_RAW_INTR_STAT.mirror(status);
      case(intr_id)
        IC_RX_OVER_INTR_ID         : if(rgm.IC_RAW_INTR_STAT.RX_OVER.get() == 1) break;
        IC_RX_UNDER_INTR_ID        : if(rgm.IC_RAW_INTR_STAT.RX_UNDER.get() == 1) break;
        IC_TX_OVER_INTR_ID         : if(rgm.IC_RAW_INTR_STAT.TX_OVER.get() == 1) break;
        IC_TX_ABRT_INTR_ID         : if(rgm.IC_RAW_INTR_STAT.TX_ABRT.get() == 1) break;
        IC_RX_DONE_INTR_ID         : if(rgm.IC_RAW_INTR_STAT.RX_DONE.get() == 1) break;
        IC_TX_EMPTY_INTR_ID        : if(rgm.IC_RAW_INTR_STAT.TX_EMPTY.get() == 1) break;
        IC_ACTIVITY_INTR_ID        : if(rgm.IC_RAW_INTR_STAT.ACTIVITY.get() == 1) break;
        IC_STOP_DET_INTR_ID        : if(rgm.IC_RAW_INTR_STAT.STOP_DET.get() == 1) break;
        IC_START_DET_INTR_ID       : if(rgm.IC_RAW_INTR_STAT.START_DET.get() == 1) break;
        IC_RD_REQ_INTR_ID          : if(rgm.IC_RAW_INTR_STAT.RD_REQ.get() == 1) break;
        IC_RX_FULL_INTR_ID         : if(rgm.IC_RAW_INTR_STAT.RX_FULL.get() == 1) break;
        IC_GEN_CALL_INTR_ID        : if(rgm.IC_RAW_INTR_STAT.GEN_CALL.get() == 1) break;
        IC_RESTART_DET_INTR_ID     : if(rgm.IC_RAW_INTR_STAT.RESTART_DET.get() == 1) break;
        IC_MASTER_ON_HOLD_INTR_ID  : if(rgm.IC_RAW_INTR_STAT.MASTER_ON_HOLD.get() == 1) break;
        default : `uvm_error("INTRCL", $sformatf("The interrupt id [%0d] could does not exist in IC_RAW_INTR_STAT field", intr_id))
      endcase
      repeat(100) @(p_sequencer.vif.cb_mon);
    end

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // KEI_APB_INTR_WAIT_SEQ_SV

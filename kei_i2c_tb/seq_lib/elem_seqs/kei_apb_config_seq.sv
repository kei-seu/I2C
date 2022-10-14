
`ifndef KEI_APB_CONFIG_SEQ_SV
`define KEI_APB_CONFIG_SEQ_SV

class kei_apb_config_seq extends kei_apb_base_sequence;

  `uvm_object_utils(kei_apb_config_seq)

  constraint def_cstr {
    soft SPEED == -1;
    soft IC_10BITADDR_MASTER == -1;
    soft IC_TAR == -1;
    soft IC_FS_SCL_HCNT == -1;
    soft IC_FS_SCL_LCNT == -1;
    soft ENABLE == -1;
    soft IC_SAR == -1;
  }

  function new (string name = "kei_apb_config_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();
    
    if(SPEED >= 0) rgm.IC_CON.SPEED.set(SPEED);
    //rgm.IC_CON.MASTER_MODE.set('h1);
    if(IC_10BITADDR_MASTER >= 0) rgm.IC_CON.IC_10BITADDR_MASTER.set(IC_10BITADDR_MASTER);
    rgm.IC_CON.update(status);

    if(IC_TAR >= 0) rgm.IC_TAR.IC_TAR.set(IC_TAR);
    rgm.IC_TAR.update(status);

    if(IC_SAR >= 0) rgm.IC_SAR.IC_SAR.set(IC_SAR);
    rgm.IC_SAR.update(status);

    if(IC_FS_SCL_HCNT >= 0) rgm.IC_FS_SCL_HCNT.write(status, IC_FS_SCL_HCNT); 
    if(IC_FS_SCL_LCNT >= 0) rgm.IC_FS_SCL_LCNT.write(status, IC_FS_SCL_LCNT); 

    if(ENABLE >= 0) rgm.IC_ENABLE.ENABLE.set('h1);
    rgm.IC_ENABLE.update(status);
    

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // KEI_APB_CONFIG_SEQ_SV

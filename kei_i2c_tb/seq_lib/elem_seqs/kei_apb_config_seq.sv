
`ifndef KEI_APB_CONFIG_SEQ_SV
`define KEI_APB_CONFIG_SEQ_SV

class kei_apb_config_seq extends kei_apb_base_sequence;

  `uvm_object_utils(kei_apb_config_seq)

  constraint def_cstr {
    soft SPEED == -1;
    soft MASTER_MODE ==-1;
    soft IC_10BITADDR_MASTER == -1;
    soft IC_RESTART_EN == -1;
    soft IC_TAR == -1;
    soft IC_SS_SCL_HCNT == -1;
    soft IC_SS_SCL_LCNT == -1;
    soft IC_FS_SCL_HCNT == -1;
    soft IC_FS_SCL_LCNT == -1;
    soft IC_HS_SCL_HCNT == -1;
    soft IC_HS_SCL_LCNT == -1;
    soft ENABLE == -1;
    soft IC_SAR == -1;
    soft SPECIAL == -1;
    soft GC_OR_START == -1;
  }

  function new (string name = "kei_apb_config_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();
    
    if(SPEED >= 0) rgm.IC_CON.SPEED.set(SPEED);
    if(MASTER_MODE >= 0) rgm.IC_CON.MASTER_MODE.set(MASTER_MODE);
    if(IC_10BITADDR_MASTER >= 0) rgm.IC_CON.IC_10BITADDR_MASTER.set(IC_10BITADDR_MASTER);
    if(IC_RESTART_EN >= 0) rgm.IC_CON.IC_RESTART_EN.set(IC_RESTART_EN);
    rgm.IC_CON.update(status);

    if(IC_TAR >= 0) rgm.IC_TAR.IC_TAR.set(IC_TAR);
    if(SPECIAL >= 0) rgm.IC_TAR.SPECIAL.set(SPECIAL);
    if(GC_OR_START >= 0) rgm.IC_TAR.GC_OR_START.set(GC_OR_START);
    rgm.IC_TAR.update(status);

    if(IC_SAR >= 0) rgm.IC_SAR.IC_SAR.set(IC_SAR);
    rgm.IC_SAR.update(status);

    if(IC_SS_SCL_HCNT >= 0) rgm.IC_SS_SCL_HCNT.write(status, IC_SS_SCL_HCNT); 
    if(IC_SS_SCL_LCNT >= 0) rgm.IC_SS_SCL_LCNT.write(status, IC_SS_SCL_LCNT); 
    if(IC_FS_SCL_HCNT >= 0) rgm.IC_FS_SCL_HCNT.write(status, IC_FS_SCL_HCNT); 
    if(IC_FS_SCL_LCNT >= 0) rgm.IC_FS_SCL_LCNT.write(status, IC_FS_SCL_LCNT); 
    if(IC_HS_SCL_HCNT >= 0) rgm.IC_HS_SCL_HCNT.write(status, IC_HS_SCL_HCNT); 
    if(IC_HS_SCL_LCNT >= 0) rgm.IC_HS_SCL_LCNT.write(status, IC_HS_SCL_LCNT); 
    
    if(ENABLE >= 0) rgm.IC_ENABLE.ENABLE.set(ENABLE);
    rgm.IC_ENABLE.update(status);
    

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // KEI_APB_CONFIG_SEQ_SV

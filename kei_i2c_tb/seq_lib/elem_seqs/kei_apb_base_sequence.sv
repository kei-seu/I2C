
`ifndef KEI_APB_BASE_SEQUENCE_SV
`define KEI_APB_BASE_SEQUENCE_SV

virtual class kei_apb_base_sequence extends uvm_sequence #(kei_vip_apb_transfer);

  ral_block_kei_i2c rgm;

  // WRITE/READ data packet content
  rand bit [7:0] packet[];
  rand int intr_id = 0;

  // RGM register field value
  rand int SPEED = -1;
  rand int IC_10BITADDR_MASTER = -1;
  rand int IC_TAR = -1;
  rand int IC_FS_SCL_HCNT = -1;
  rand int IC_FS_SCL_LCNT = -1;
  rand int ENABLE = -1;
  rand int DAT = -1;
  rand int CMD = -1;
  rand int IC_SAR = -1;
  
  `uvm_declare_p_sequencer(kei_vip_apb_master_sequencer)

  // Register model variables:
  uvm_status_e status;
  rand uvm_reg_data_t data;

  function new (string name = "kei_apb_base_sequence");
    super.new(name);
  endfunction

  virtual task body();
    if(!uvm_config_db #(ral_block_kei_i2c)::get(m_sequencer, "", "rgm", rgm)) begin
      `uvm_error("body", "Unable to find ral_block_kei_i2c in uvm_config_db")
    end
    // TODO
    // Attach element sequences below
  endtask
  
endclass

`endif // KEI_APB_BASE_SEQUENCE_SV

`ifndef KEI_I2C_MASTER_ADDRESS_CG_VIRT_SEQ_SV
`define KEI_I2C_MASTER_ADDRESS_CG_VIRT_SEQ_SV
class kei_i2c_master_address_cg_virt_seq extends kei_i2c_base_virtual_sequence;
  
  int i;
  bit [9:0] address[] = '{10'b1001110011,`KEI_VIP_I2C_SLAVE0_ADDRESS,10'b0001110011,10'b0000110011};
  
  `uvm_object_utils(kei_i2c_master_address_cg_virt_seq)
  
  function new (string name = "kei_i2c_master_address_cg_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);
    
    foreach(address[i]) begin
    
    `uvm_do_on_with(apb_cfg_seq,
										p_sequencer.apb_mst_sqr,
										{SPEED == 2;
										IC_10BITADDR_MASTER == 0;
										IC_TAR == address[i];
										IC_FS_SCL_HCNT == 200;
										IC_FS_SCL_LCNT == 200;})
    
    cfg.i2c_cfg.slave_cfg[0].enable_10bit_addr = 0; 
    cfg.i2c_cfg.slave_cfg[0].slave_address = address[i];
    env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
    
    rgm.IC_ENABLE.ENABLE.set('h1);
    rgm.IC_ENABLE.update(status);
    
    `uvm_do_on_with(apb_write_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                      {packet.size() == 1;
                      packet[0] == 8'b11110000;
                       })
    
    `uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)
    
    rgm.IC_ENABLE.ENABLE.set('h0);
    rgm.IC_ENABLE.update(status);
    
    end
    
    foreach(address[i]) begin
    
    `uvm_do_on_with(apb_cfg_seq,
										p_sequencer.apb_mst_sqr,
										{SPEED == 2;
										IC_10BITADDR_MASTER == 1;
										IC_TAR == address[i];
										IC_FS_SCL_HCNT == 200;
										IC_FS_SCL_LCNT == 200;})
    
    cfg.i2c_cfg.slave_cfg[0].enable_10bit_addr = 1; 
    cfg.i2c_cfg.slave_cfg[0].slave_address = address[i];
    env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
    
    rgm.IC_ENABLE.ENABLE.set('h1);
    rgm.IC_ENABLE.update(status);
    
    `uvm_do_on_with(apb_write_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                      {packet.size() == 1;
                      packet[0] == 8'b00001111;
                       })
    
    `uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)
    
    rgm.IC_ENABLE.ENABLE.set('h0);
    rgm.IC_ENABLE.update(status);
    
    end
    
    foreach(address[j]) begin
      rgm.IC_ENABLE.ENABLE.set(0);
      rgm.IC_ENABLE.update(status);
      rgm.IC_SAR.IC_SAR.set(address[j]);
      rgm.IC_SAR.update(status);
      rgm.IC_ENABLE.ENABLE.set(1);
      rgm.IC_ENABLE.update(status);
    end
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
    
  endtask

endclass
`endif
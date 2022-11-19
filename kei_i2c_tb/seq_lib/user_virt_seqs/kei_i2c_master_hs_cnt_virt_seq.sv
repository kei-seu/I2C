`ifndef KEI_I2C_MASTER_HS_CNT_VIRT_SEQ_SV
`define KEI_I2C_MASTER_HS_CNT_VIRT_SEQ_SV
class kei_i2c_master_hs_cnt_virt_seq extends kei_i2c_base_virtual_sequence;
  
  `uvm_object_utils(kei_i2c_master_hs_cnt_virt_seq)
  
  function new (string name = "kei_i2c_master_hs_cnt_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);
    
    //hs模式的数据传输过程与ss和fs不同，故需要对i2c vip进行特殊配置
    cfg.i2c_cfg.slave_cfg[0].bus_speed = HIGHSPEED_MODE;
    env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
    
    // test 1Mbs in HS mode
     
    `uvm_do_on_with(apb_cfg_seq,
										p_sequencer.apb_mst_sqr,
										{SPEED == 3;
										IC_10BITADDR_MASTER == 0;
										IC_TAR == `KEI_VIP_I2C_SLAVE0_ADDRESS;
										IC_HS_SCL_HCNT == 50;
										IC_HS_SCL_LCNT == 50;
                    ENABLE == 1;})
    
    `uvm_do_on_with(apb_write_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                      {packet.size() == 1;
                      packet[0] == 8'b11110000;})
    
    `uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)
    
    `uvm_do_on(apb_wait_empty_seq,p_sequencer.apb_mst_sqr)
    
    #10us;
    
    // test 3.4Mbs in HS mode
    
    rgm.IC_ENABLE_ENABLE.set(0);
    rgm.IC_ENABLE.update(status);
    
    `uvm_do_on_with(apb_cfg_seq,
										p_sequencer.apb_mst_sqr,
										{IC_HS_SCL_HCNT == 15;
										IC_HS_SCL_LCNT == 15;
                    ENABLE == 1;})
    
    `uvm_do_on_with(apb_write_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                      {packet.size() == 1;
                      packet[0] == 8'b00001111;})
    
    `uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)
    
    `uvm_do_on(apb_wait_empty_seq,p_sequencer.apb_mst_sqr)
    
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
    
  endtask

endclass
`endif
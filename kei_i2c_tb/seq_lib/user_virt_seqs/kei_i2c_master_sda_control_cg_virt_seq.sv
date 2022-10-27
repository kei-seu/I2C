`ifndef KEI_I2C_MASTER_SDA_CONTROL_CG_VIRT_SEQ_SV
`define KEI_I2C_MASTER_SDA_CONTROL_CG_VIRT_SEQ_SV
class kei_i2c_master_sda_control_cg_virt_seq extends kei_i2c_base_virtual_sequence;
  
  `uvm_object_utils(kei_i2c_master_sda_control_cg_virt_seq)
  
  bit [7:0]time_set[] = '{8'd5,8'd50,8'd150};
  
  function new (string name = "kei_i2c_master_sda_control_cg_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);
    
    `uvm_do_on_with(apb_cfg_seq,
										p_sequencer.apb_mst_sqr,
										{SPEED ==2; 
										IC_10BITADDR_MASTER == 0;
										IC_TAR == `KEI_VIP_I2C_SLAVE0_ADDRESS;
										IC_FS_SCL_HCNT == 200;
										IC_FS_SCL_LCNT == 200;})
                    
    // test RX HOLD TIME
    
    foreach(time_set[i]) 
      begin
        rgm.IC_SDA_HOLD_IC_SDA_RX_HOLD.set(time_set[i]);
        rgm.IC_SDA_HOLD.update(status);
        rgm.IC_ENABLE_ENABLE.set(1);
        rgm.IC_ENABLE.update(status);
        fork
          `uvm_do_on_with(apb_read_packet_seq,
                          p_sequencer.apb_mst_sqr,
                          {packet.size() == 1;})
          `uvm_do_on_with(i2c_slv_read_resp_seq,
                          p_sequencer.i2c_slv_sqr,
                          {packet.size() == 1;
                          packet[0] == 8'b11110000;})
        join
        rgm.IC_ENABLE_ENABLE.set(0);
        rgm.IC_ENABLE.update(status);
      end
      
    // test TX HOLD TIME
    
    foreach(time_set[i]) 
      begin
        rgm.IC_SDA_HOLD_IC_SDA_TX_HOLD.set(time_set[i]);
        rgm.IC_SDA_HOLD.update(status);
        rgm.IC_ENABLE_ENABLE.set(1);
        rgm.IC_ENABLE.update(status);
        fork
          `uvm_do_on_with(apb_write_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                      {packet.size() == 1;
                      packet[0] == 8'b00001111;})
          `uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)
        join
        rgm.IC_ENABLE_ENABLE.set(0);
        rgm.IC_ENABLE.update(status);
      end
    
    // test SET UP TIME
    
    foreach(time_set[i]) 
      begin
        rgm.IC_SDA_SETUP_SDA_SETUP.set(time_set[i]);
        rgm.IC_SDA_SETUP.update(status);
        rgm.IC_ENABLE_ENABLE.set(1);
        rgm.IC_ENABLE.update(status);
        rgm.IC_ENABLE_ENABLE.set(0);
        rgm.IC_ENABLE.update(status);
      end
     
    `uvm_do_on(apb_wait_empty_seq,p_sequencer.apb_mst_sqr)
    
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
    
  endtask

endclass
`endif
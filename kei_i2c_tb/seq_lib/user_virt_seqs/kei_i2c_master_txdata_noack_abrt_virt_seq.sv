
`ifndef KEI_I2C_MASTER_TXDATA_NOACK_ABRT_VIRT_SEQ_SV
`define KEI_I2C_MASTER_TXDATA_NOACK_ABRT_VIRT_SEQ_SV

class kei_i2c_master_txdata_noack_abrt_virt_seq extends kei_i2c_base_virtual_sequence;

  `uvm_object_utils(kei_i2c_master_txdata_noack_abrt_virt_seq)

  function new (string name = "kei_i2c_master_txdata_noack_abrt_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);
    
    /*
    当i2c_slv_write_resp_seq的成员变量nack_data为1时，
    代表着i2c vip在第一次数据阶段的acknowledge周期产生nack
    */

    `uvm_do_on_with(apb_cfg_seq,
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_TAR == `KEI_VIP_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                    ENABLE == 1;})
		
    `uvm_do_on_with(apb_write_packet_seq, 
                    p_sequencer.apb_mst_sqr,
                    {packet.size() == 1; 
                    packet[0] == 8'b11110000;})
    
    fork                
      `uvm_do_on_with(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr,{nack_data == 1;})
    join_none  
    
    `uvm_do_on(apb_wait_detect_abort_source_seq, p_sequencer.apb_mst_sqr)
    
    if(vif.get_intr(IC_TX_ABRT_INTR_ID) !== 1'b1)
      `uvm_error("INTRERR", "interrupt output IC_TX_ABRT_INTR_ID is not high")
    else
      `uvm_info("INTRERR", "interrupt output IC_TX_ABRT_INTR_ID is high", UVM_LOW)
    
    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
		
    #10us;

    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // KEI_I2C_MASTER_TXDATA_NOACK_ABRT_VIRT_SEQ_SV

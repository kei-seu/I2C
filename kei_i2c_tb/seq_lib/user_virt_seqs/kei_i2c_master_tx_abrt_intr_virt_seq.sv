`ifndef KEI_I2C_MASTER_TX_ABRT_INTR_VIRT_SEQ_SV
`define KEI_I2C_MASTER_TX_ABRT_INTR_VIRT_SEQ_SV

class kei_i2c_master_tx_abrt_intr_virt_seq extends kei_i2c_base_virtual_sequence;

  `uvm_object_utils(kei_i2c_master_tx_abrt_intr_virt_seq)

  function new (string name = "kei_i2c_master_tx_abrt_intr_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);
    
    /*
    tx_abort中断主要发生在dut作为transmitter且无法完成预期传输动作时，
    亦可通过配置IC_ENABLE_ABORT寄存器来人为中止传输、产生tx_abort中断
    */
    
    `uvm_do_on_with(apb_cfg_seq,
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_TAR == `KEI_VIP_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                    ENABLE == 1;})
		
    rgm.IC_INTR_MASK.M_TX_ABRT.set(1);
    rgm.IC_INTR_MASK.update(status);
    
    `uvm_do_on_with(apb_write_packet_seq,
                    p_sequencer.apb_mst_sqr,
                    {packet.size() == 8;
										packet[0] == 8'b00000001;
										packet[1] == 8'b00000010;
										packet[2] == 8'b00000100;
										packet[3] == 8'b00001000;
										packet[4] == 8'b00010000;
										packet[5] == 8'b00100000;
										packet[6] == 8'b01000000;
										packet[7] == 8'b10000000;})

    fork
      `uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
    join_none
    
    #100us;
    
    rgm.IC_ENABLE.ABORT.set(1);
    rgm.IC_ENABLE.update(status);
    
    fork
      `uvm_do_on_with(apb_intr_wait_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_TX_ABRT_INTR_ID;})
      `uvm_do_on(apb_wait_detect_abort_source_seq, p_sequencer.apb_mst_sqr)
    join  
      
    if(vif.get_intr(IC_TX_ABRT_INTR_ID) !== 1'b1)
      `uvm_error("INTRERR", "interrupt output IC_TX_ABRT_INTR_ID is not high")
    else
      `uvm_info("INTRERR", "interrupt output IC_TX_ABRT_INTR_ID is high", UVM_LOW)
		
    `uvm_do_on_with(apb_intr_clear_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_TX_ABRT_INTR_ID;})
    
    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
		
    #10us;

    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // KEI_I2C_MASTER_TX_ABRT_INTR_VIRT_SEQ_SV

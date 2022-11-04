`ifndef KEI_I2C_MASTER_STOP_DET_INTR_VIRT_SEQ_SV
`define KEI_I2C_MASTER_STOP_DET_INTR_VIRT_SEQ_SV

class kei_i2c_master_stop_det_intr_virt_seq extends kei_i2c_base_virtual_sequence;

  `uvm_object_utils(kei_i2c_master_stop_det_intr_virt_seq)

  function new (string name = "kei_i2c_master_stop_det_intr_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);
    
    /*
    apb_intr_wait_seq这个elem_seq会通过mirror IC_RAW_INTR_STAT寄存器的值来获得原始中断；
    但是IC_INTR_STAT寄存器的值以及dut interrupt 端口的值对应屏蔽中断，
    需要修改IC_INTR_MASK寄存器的相应位，来控制某个中断是否被屏蔽（1不屏蔽，0屏蔽）；
    诸如IC_CLR_START_DET的一系列中断清除寄存器，对这些寄存器进行读操作，
    即可清除IC_RAW_INTR_STAT和IC_INTR_STAT中对应中断
    */
    
    `uvm_do_on_with(apb_cfg_seq,
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_TAR == `KEI_VIP_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                    ENABLE == 1;})
		
    rgm.IC_INTR_MASK.M_ACTIVITY.set(1);
    rgm.IC_INTR_MASK.M_START_DET.set(1);
    rgm.IC_INTR_MASK.M_STOP_DET.set(1);
    rgm.IC_INTR_MASK.update(status);
    
    `uvm_do_on_with(apb_write_packet_seq,
                    p_sequencer.apb_mst_sqr,
                    {packet.size() == 2;
                    packet[0] == 8'b00000001;
                    packet[1] == 8'b00000010;})

    fork
      `uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
    join_none
    
    `uvm_do_on_with(apb_intr_wait_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_STOP_DET_INTR_ID;})
    
    if(vif.get_intr(IC_STOP_DET_INTR_ID) !== 1'b1)
      `uvm_error("INTRERR", "interrupt output IC_STOP_DET_INTR_ID is not high")
    else
      `uvm_info("INTRERR", "interrupt output IC_STOP_DET_INTR_ID is high", UVM_LOW)
		
    `uvm_do_on_with(apb_intr_clear_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_ACTIVITY_INTR_ID;})
    `uvm_do_on_with(apb_intr_clear_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_START_DET_INTR_ID;})
    `uvm_do_on_with(apb_intr_clear_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_STOP_DET_INTR_ID;})
    
    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
		
    #10us;

    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // KEI_I2C_MASTER_STOP_DET_INTR_VIRT_SEQ_SV

`ifndef KEI_I2C_MASTER_TIMEOUT_CG_VIRT_SEQ_SV
`define KEI_I2C_MASTER_TIMEOUT_CG_VIRT_SEQ_SV
class kei_i2c_master_timeout_cg_virt_seq extends kei_i2c_base_virtual_sequence;
  
  `uvm_object_utils(kei_i2c_master_timeout_cg_virt_seq)
  
  bit [3:0]timeout[] = '{4'd2,4'd5,4'd15};
  
  function new (string name = "kei_i2c_master_timeout_cg_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);
    
    /*
    REG_TIMEOUT_RST_REG_TIMEOUT_RST_rw的值决定了dut作为slave向apb master通过pready做出回应时，
    pready的最长置0时间；该时间等于REG_TIMEOUT_RST_REG_TIMEOUT_RST_rw*apb时钟周期
    */
    
    `uvm_do_on_with(apb_cfg_seq,
										p_sequencer.apb_mst_sqr,
										{SPEED ==2; 
										IC_10BITADDR_MASTER == 0;
										IC_TAR == `KEI_VIP_I2C_SLAVE0_ADDRESS;
										IC_FS_SCL_HCNT == 200;
										IC_FS_SCL_LCNT == 200;})
                   
    foreach(timeout[i]) 
      begin
        rgm.REG_TIMEOUT_RST_REG_TIMEOUT_RST_rw.set(timeout[i]);
        rgm.REG_TIMEOUT_RST.update(status);
        rgm.IC_ENABLE_ENABLE.set(1);
        rgm.IC_ENABLE.update(status);
        fork
          `uvm_do_on_with(apb_write_nocheck_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                      {packet.size() == 9;
                      packet[0] == 8'b00000001;
                      packet[1] == 8'b00000010;
                      packet[2] == 8'b00000100;
                      packet[3] == 8'b00001000;
                      packet[4] == 8'b00010000;
                      packet[5] == 8'b00100000;
                      packet[6] == 8'b01000000;
                      packet[7] == 8'b10000000;
                      packet[8] == 8'b11111111;})
          `uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)
        join
        rgm.IC_ENABLE_ENABLE.set(0);
        rgm.IC_ENABLE.update(status);
      end
     
    `uvm_do_on(apb_wait_empty_seq,p_sequencer.apb_mst_sqr)
    
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
    
  endtask

endclass
`endif
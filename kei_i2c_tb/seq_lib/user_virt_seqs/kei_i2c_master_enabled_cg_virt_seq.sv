`ifndef KEI_I2C_MASTER_ENABLED_CG_VIRT_SEQ_SV
`define KEI_I2C_MASTER_ENABLED_CG_VIRT_SEQ_SV
class kei_i2c_master_enabled_cg_virt_seq extends kei_i2c_base_virtual_sequence;

  `uvm_object_utils(kei_i2c_master_enabled_cg_virt_seq)

  function new (string name = "kei_i2c_master_enabled_cg_virt_seq");
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
                    
		//disable DUT before write
    rgm.IC_ENABLE.ENABLE.set(0);
    rgm.IC_ENABLE.update(status);
    rgm.IC_ENABLE_STATUS.mirror(status);
		`uvm_do_on_with(apb_write_packet_seq,
										p_sequencer.apb_mst_sqr,
										{packet.size() == 2;
										packet[0] == 8'b00000001;
										packet[1] == 8'b00000010;})
		
    //enable DUT before write, disable DUT before send to i2c   
    rgm.IC_ENABLE.ENABLE.set(1);
    rgm.IC_ENABLE.update(status);
    rgm.IC_ENABLE_STATUS.mirror(status);
    `uvm_do_on_with(apb_write_packet_seq,
										p_sequencer.apb_mst_sqr,
										{packet.size() == 2;
										packet[0] == 8'b00000100;
										packet[1] == 8'b00001000;})
    rgm.IC_STATUS.mirror(status);
    rgm.IC_ENABLE.ENABLE.set(0);
    rgm.IC_ENABLE.update(status);
    rgm.IC_ENABLE_STATUS.mirror(status);
    rgm.IC_STATUS.mirror(status);
    
    //disable DUT between write
    rgm.IC_ENABLE.ENABLE.set(1);
    rgm.IC_ENABLE.update(status);
    fork
      `uvm_do_on_with(apb_write_nocheck_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                      {packet.size() == 2;
                      packet[0] == 8'b00010000;
                      packet[1] == 8'b00100000;})
    join_none                
    while(1) 
      begin
        rgm.IC_STATUS.mirror(status);
        if(rgm.IC_STATUS.TFE.get() == 0) 
          begin
            rgm.IC_ENABLE.ENABLE.set(0);
            rgm.IC_ENABLE.update(status);
            rgm.IC_ENABLE_STATUS.mirror(status);
            rgm.IC_STATUS.mirror(status);
          break;
        end
      end
    
    //after disable DUT, enable DUT before write
    rgm.IC_ENABLE.ENABLE.set(1);
    rgm.IC_ENABLE.update(status);
    rgm.IC_ENABLE_STATUS.mirror(status);
    `uvm_do_on_with(apb_write_packet_seq,
										p_sequencer.apb_mst_sqr,
										{packet.size() == 2;
										packet[0] == 8'b01000000;
										packet[1] == 8'b10000000;})
		`uvm_do_on(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr)
    rgm.IC_STATUS.mirror(status);
    
    
		`uvm_do_on(apb_wait_empty_seq,p_sequencer.apb_mst_sqr)
		
		#10us;
		
    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif
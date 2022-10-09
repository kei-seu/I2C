`ifndef KEI_I2C_QUICK_REG_ACCESS_VIRT_SEQ_SV
`define KEI_I2C_QUICK_REG_ACCESS_VIRT_SEQ_SV
class kei_i2c_quick_reg_access_virt_seq extends kei_i2c_base_virtual_sequence;

  `uvm_object_utils(kei_i2c_quick_reg_access_virt_seq)

  function new (string name = "kei_i2c_quick_reg_access_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();//等待reset释放
    vif.wait_apb(10);//等待10个周期

    // TODO
		
		/*	//以下的寄存器设置均是对某个域做set，而不是对某个reg整个做set，是为了不改变其他域的值
    rgm.IC_CON.SPEED.set('h2);//设置为fast模式
    rgm.IC_TAR.IC_TAR.set(`LVC_I2C_SLAVE0_ADDRESS);//设置target地址
    // SCL_HCNT + SCL_LCNT = I2C baud clock T 
    // 2us + 2us -> 1000/4 = 250Kb/s 满足fast模式要求
    rgm.IC_FS_SCL_HCNT.set(200); // 设置时钟，高电平2us 
    rgm.IC_FS_SCL_LCNT.set(200); // 设置时钟，低电平2us

    rgm.IC_ENABLE.ENABLE.set('h1);//把整个ip enable，上面的设置均需要在非enable的状态下进行
		
		
								
								
    rgm.IC_DATA_CMD.DAT.set(8'b1100_1100);
    rgm.IC_DATA_CMD.CMD.set('h0); // WRITE=0, READ=1
		
    //rgm.update(status);//不要对整个rgm做update，不然会对状态寄存器进行写操作
		
		update_regs('{rgm.IC_CON,
									rgm.IC_TAR,
									rgm.IC_FS_SCL_HCNT,
									rgm.IC_FS_SCL_LCNT,
									rgm.IC_ENABLE,
									rgm.IC_DATA_CMD});
		
		*/
		
		`uvm_do_on_with(apb_cfg_seq,
										p_sequencer.apb_mst_sqr,
										{SPEED == 2;
										IC_10BITADDR_MASTER ==0;
										IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
										IC_FS_SCL_HCNT == 200;
										IC_FS_SCL_LCNT == 200;
										ENABLE == 1;})
										
		`uvm_do_on_with(apb_write_packet_seq,
										p_sequencer.apb_mst_sqr,
										{packet.size() == 1;
										packet[0] == 8'b11001100;})
		
    rgm.IC_ENABLE.mirror(status, UVM_CHECK);
		
		#10us;
    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass
`endif // KEI_I2C_QUICK_REG_ACCESS_VIRT_SEQ_SV

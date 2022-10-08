//=======================================================================
// COPYRIGHT (C) 2018-2020 RockerIC, Ltd.
// This software and the associated documentation are confidential and
// proprietary to RockerIC, Ltd. Your use or disclosure of this software
// is subject to the terms and conditions of a consulting agreement
// between you, or your company, and RockerIC, Ltd. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
// VisitUs  : www.rockeric.com
// Support  : support@rockeric.com
// WeChat   : eva_bill 
//-----------------------------------------------------------------------
`ifndef KEI_VIP_APB_SLAVE_DRIVER_SV
`define KEI_VIP_APB_SLAVE_DRIVER_SV

function kei_vip_apb_slave_driver::new (string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

task kei_vip_apb_slave_driver::run();
   fork
     get_and_drive();
     reset_listener();
     drive_response();
   join_none
endtask : run

task kei_vip_apb_slave_driver::get_and_drive();
  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), "sequencer got next item", UVM_HIGH)
    void'($cast(rsp, req.clone()));
    rsp.set_sequence_id(req.get_sequence_id());
    seq_item_port.item_done(rsp);
    `uvm_info(get_type_name(), "sequencer item_done_triggered", UVM_HIGH)
  end
endtask : get_and_drive

task kei_vip_apb_slave_driver::drive_response();
  `uvm_info(get_type_name(), "drive_response", UVM_HIGH)
  forever begin
    @(vif.cb_slv);
    if(vif.cb_slv.psel === 1'b1 && vif.cb_slv.penable === 1'b0) begin
      case(vif.cb_slv.pwrite)
        1'b1    : this.do_write();
        1'b0    : this.do_read();
        default : `uvm_error(get_type_name(), "ERROR pwrite signal value")
      endcase
    end
    else begin
      this.do_idle();
    end
  end
endtask : drive_response

task kei_vip_apb_slave_driver::reset_listener();
  `uvm_info(get_type_name(), "reset_listener ...", UVM_HIGH)
  fork
    forever begin
      @(negedge vif.rstn); // ASYNC reset
      vif.prdata <= 0;
      vif.pslverr <= 0;
      vif.pready <= cfg.slave_pready_default_value;
      this.mem.delete(); // reset internal memory
    end
  join_none
endtask: reset_listener

task kei_vip_apb_slave_driver::do_idle();
  `uvm_info(get_type_name(), "do_idle", UVM_HIGH)
  vif.cb_slv.prdata <= 0;
  vif.cb_slv.pready <= cfg.slave_pready_default_value;
  vif.cb_slv.pslverr <= 0;
endtask: do_idle

task kei_vip_apb_slave_driver::do_write();
  bit[31:0] addr;
  bit[31:0] data;
  int pready_add_cycles = cfg.get_pready_additional_cycles();
  bit pslverr_status =  cfg.get_pslverr_status();
  `uvm_info(get_type_name(), "do_write", UVM_HIGH)
  wait(vif.penable === 1'b1);
  addr = vif.cb_slv.paddr;
  data = vif.cb_slv.pwdata;
  mem[addr] = data;
  if(pready_add_cycles > 0) begin
    #1ps;
    vif.pready  <= 0;
    repeat(pready_add_cycles) @(vif.cb_slv);
  end
  #1ps;
  vif.pready  <= 1;
  vif.pslverr <= pslverr_status;
  fork
    begin
      @(vif.cb_slv);
      vif.cb_slv.pready <= cfg.slave_pready_default_value;
      vif.cb_slv.pslverr <= 0;
    end
  join_none
endtask: do_write

task kei_vip_apb_slave_driver::do_read();
  bit[31:0] addr;
  bit[31:0] data;
  int pready_add_cycles = cfg.get_pready_additional_cycles();
  bit pslverr_status =  cfg.get_pslverr_status();
  `uvm_info(get_type_name(), "do_read", UVM_HIGH)
  wait(vif.penable === 1'b1);
  addr = vif.cb_slv.paddr;
  if(mem.exists(addr))
    data = mem[addr];
  else
    data = DEFAULT_READ_VALUE;
  if(pready_add_cycles > 0) begin
    #1ps;
    vif.pready  <= 0;
    repeat(pready_add_cycles) @(vif.cb_slv);
  end
  #1ps;
  vif.pready  <= 1;
  vif.pslverr <= pslverr_status;
  vif.prdata  <= data;
  fork
    begin
      @(vif.cb_slv);
      vif.cb_slv.pready <= cfg.slave_pready_default_value;
      vif.cb_slv.pslverr <= 0;
    end
  join_none
endtask: do_read

`endif // KEI_VIP_APB_SLAVE_DRIVER_SV

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
`ifndef KEI_VIP_APB_MASTER_DRIVER_SV
`define KEI_VIP_APB_MASTER_DRIVER_SV

function kei_vip_apb_master_driver::new (string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

task kei_vip_apb_master_driver::run();
   fork
     get_and_drive();
     reset_listener();
   join_none
endtask : run

task kei_vip_apb_master_driver::get_and_drive();
  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), "sequencer got next item", UVM_HIGH)
    drive_transfer(req);
    void'($cast(rsp, req.clone()));
    rsp.set_sequence_id(req.get_sequence_id());
    rsp.set_transaction_id(req.get_transaction_id());
    seq_item_port.item_done(rsp);
    `uvm_info(get_type_name(), "sequencer item_done_triggered", UVM_HIGH)
  end
endtask : get_and_drive

task kei_vip_apb_master_driver::drive_transfer (kei_vip_apb_transfer t);
  `uvm_info(get_type_name(), "drive_transfer", UVM_HIGH)
  case(t.trans_kind)
    IDLE    : this.do_idle();
    WRITE   : this.do_write(t);
    READ    : this.do_read(t);
    default : `uvm_error("ERRTYPE", "unrecognized transaction type")
  endcase
endtask : drive_transfer

task kei_vip_apb_master_driver::do_write(kei_vip_apb_transfer t);
  `uvm_info(get_type_name(), "do_write ...", UVM_HIGH)
  @(vif.cb_mst);
  vif.cb_mst.paddr <= t.addr;
  vif.cb_mst.pwrite <= 1;
  vif.cb_mst.psel <= 1;
  vif.cb_mst.penable <= 0;
  vif.cb_mst.pwdata <= t.data;
  @(vif.cb_mst);
  vif.cb_mst.penable <= 1;
  #10ps;
  wait(vif.pready === 1);
  #1ps;
  if(vif.pslverr === 1) begin
    t.trans_status = ERROR;
    if(cfg.master_pslverr_status_severity ==  UVM_ERROR)
      `uvm_error(get_type_name(), "PSLVERR asserted!")
    else
      `uvm_warning(get_type_name(), "PSLVERR asserted!")
  end
  else begin
    t.trans_status = OK;
  end
  repeat(t.idle_cycles) this.do_idle();
endtask: do_write

task kei_vip_apb_master_driver::do_read(kei_vip_apb_transfer t);
  `uvm_info(get_type_name(), "do_write ...", UVM_HIGH)
  @(vif.cb_mst);
  vif.cb_mst.paddr <= t.addr;
  vif.cb_mst.pwrite <= 0;
  vif.cb_mst.psel <= 1;
  vif.cb_mst.penable <= 0;
  @(vif.cb_mst);
  vif.cb_mst.penable <= 1;
  #10ps;
  wait(vif.pready === 1);
  #1ps;
  if(vif.pslverr === 1) begin
    t.trans_status = ERROR;
    if(cfg.master_pslverr_status_severity ==  UVM_ERROR)
      `uvm_error(get_type_name(), "PSLVERR asserted!")
    else
      `uvm_warning(get_type_name(), "PSLVERR asserted!")
  end
  else begin
    t.trans_status = OK;
  end
  t.data = vif.prdata;
  repeat(t.idle_cycles) this.do_idle();
endtask: do_read

task kei_vip_apb_master_driver::do_idle();
  `uvm_info(get_type_name(), "do_idle ...", UVM_HIGH)
  @(vif.cb_mst);
  vif.cb_mst.psel <= 0;
  vif.cb_mst.penable <= 0;
  vif.cb_mst.pwdata <= 0;
endtask:do_idle

task kei_vip_apb_master_driver::reset_listener();
  `uvm_info(get_type_name(), "reset_listener ...", UVM_HIGH)
  fork
    forever begin
      @(negedge vif.rstn); // ASYNC reset
      vif.paddr <= 0;
      vif.pwrite <= 0;
      vif.psel <= 0;
      vif.penable <= 0;
      vif.pwdata <= 0;
    end
  join_none
endtask

`endif // KEI_VIP_APB_MASTER_DRIVER_SV

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

`ifndef KEI_VIP_APB_REG_ADAPTER_SV
`define KEI_VIP_APB_REG_ADAPTER_SV

class kei_vip_apb_reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(kei_vip_apb_reg_adapter)
  function new(string name = "kei_vip_apb_reg_adapter");
    super.new(name);
    provides_responses = 1;
  endfunction
  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    kei_vip_apb_transfer t = kei_vip_apb_transfer::type_id::create("t");
    t.trans_kind = (rw.kind == UVM_WRITE) ? WRITE : READ;
    t.addr = rw.addr;
    t.data = rw.data;
    t.idle_cycles = 1;
    return t;
  endfunction
  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    kei_vip_apb_transfer t;
    if (!$cast(t, bus_item)) begin
      `uvm_fatal("CASTFAIL","Provided bus_item is not of the correct type")
      return;
    end
    rw.kind = (t.trans_kind == WRITE) ? UVM_WRITE : UVM_READ;
    rw.addr = t.addr;
    rw.data = t.data;
    rw.status = t.trans_status == OK ? UVM_IS_OK : UVM_NOT_OK;
  endfunction
endclass

`endif // KEI_VIP_APB_REG_ADAPTER

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
`ifndef KEI_VIP_APB_MASTER_SEQ_LIB_SV
`define KEI_VIP_APB_MASTER_SEQ_LIB_SV

//------------------------------------------------------------------------------
// SEQUENCE: default
//------------------------------------------------------------------------------
typedef class kei_vip_apb_transfer;
typedef class kei_vip_apb_master_sequencer;

class kei_vip_apb_master_base_sequence extends uvm_sequence #(kei_vip_apb_transfer);

  `uvm_object_utils(kei_vip_apb_master_base_sequence)    
  function new(string name=""); 
    super.new(name);
  endfunction : new

endclass : kei_vip_apb_master_base_sequence 

// USER: Add your sequences here

class kei_vip_apb_master_single_write_sequence extends kei_vip_apb_master_base_sequence;
  rand bit [31:0]      addr;
  rand bit [31:0]      data;
  kei_vip_apb_trans_status     trans_status;

  `uvm_object_utils(kei_vip_apb_master_single_write_sequence)    
  function new(string name=""); 
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Starting sequence", UVM_HIGH)
	  `uvm_do_with(req, {trans_kind == WRITE; addr == local::addr; data == local::data;})
    get_response(rsp);
    trans_status = rsp.trans_status;
    `uvm_info(get_type_name(),$psprintf("Done sequence: %s",req.convert2string()), UVM_HIGH)
  endtask: body

endclass: kei_vip_apb_master_single_write_sequence

class kei_vip_apb_master_single_read_sequence extends kei_vip_apb_master_base_sequence;
  rand bit [31:0]      addr;
  rand bit [31:0]      data;
  kei_vip_apb_trans_status     trans_status;

  `uvm_object_utils(kei_vip_apb_master_single_read_sequence)    
  function new(string name=""); 
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Starting sequence", UVM_HIGH)
	  `uvm_do_with(req, {trans_kind == READ; addr == local::addr;})
    get_response(rsp);
    trans_status = rsp.trans_status;
    data = rsp.data;
    `uvm_info(get_type_name(),$psprintf("Done sequence: %s",req.convert2string()), UVM_HIGH)
  endtask: body

endclass: kei_vip_apb_master_single_read_sequence

class kei_vip_apb_master_write_read_sequence extends kei_vip_apb_master_base_sequence;
  rand bit [31:0]    addr;
  rand bit [31:0]    data;
  rand int           idle_cycles; 
  kei_vip_apb_trans_status     trans_status;
  constraint cstr{
    idle_cycles == 0;
  }

  `uvm_object_utils(kei_vip_apb_master_write_read_sequence)    
  function new(string name=""); 
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Starting sequence", UVM_HIGH)
	  `uvm_do_with(req,  {trans_kind == WRITE; 
                        addr == local::addr; 
                        data == local::data;
                        idle_cycles == local::idle_cycles;
                       })
    get_response(rsp);
    `uvm_do_with(req, {trans_kind == READ; addr == local::addr;})
    get_response(rsp);
    data = rsp.data;
    trans_status = rsp.trans_status;
    `uvm_info(get_type_name(),$psprintf("Done sequence: %s",req.convert2string()), UVM_HIGH)
  endtask: body

endclass: kei_vip_apb_master_write_read_sequence
  
class kei_vip_apb_master_burst_write_sequence extends kei_vip_apb_master_base_sequence;
  rand bit [31:0]      addr;
  rand bit [31:0]      data[];
  kei_vip_apb_trans_status     trans_status;
  constraint cstr{
    soft data.size() inside {4, 8, 16, 32};
    foreach(data[i]) soft data[i] == addr + (i << 2);
  }

  `uvm_object_utils(kei_vip_apb_master_burst_write_sequence)    
  function new(string name=""); 
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Starting sequence", UVM_HIGH)
    trans_status = OK;
    foreach(data[i]) begin
	    `uvm_do_with(req, {trans_kind == WRITE; 
                         addr == local::addr + (i<<2); 
                         data == local::data[i];
                         idle_cycles == 0;
                        })
      get_response(rsp);
    end
    `uvm_do_with(req, {trans_kind == IDLE;})
    get_response(rsp);
    trans_status = rsp.trans_status == ERROR ? ERROR : trans_status;
    `uvm_info(get_type_name(),$psprintf("Done sequence: %s",req.convert2string()), UVM_HIGH)
  endtask: body
endclass: kei_vip_apb_master_burst_write_sequence

class kei_vip_apb_master_burst_read_sequence extends kei_vip_apb_master_base_sequence;
  rand bit [31:0]      addr;
  rand bit [31:0]      data[];
  kei_vip_apb_trans_status     trans_status;
  constraint cstr{
    soft data.size() inside {4, 8, 16, 32};
  }
  `uvm_object_utils(kei_vip_apb_master_burst_read_sequence)
  function new(string name=""); 
    super.new(name);
  endfunction : new

  virtual task body();
    `uvm_info(get_type_name(),"Starting sequence", UVM_HIGH)
    trans_status = OK;
    foreach(data[i]) begin
	    `uvm_do_with(req, {trans_kind == READ; 
                         addr == local::addr + (i<<2); 
                         idle_cycles == 0;
                        })
      get_response(rsp);
      data[i] = rsp.data;
    end
    `uvm_do_with(req, {trans_kind == IDLE;})
    get_response(rsp);
    trans_status = rsp.trans_status == ERROR ? ERROR : trans_status;
    `uvm_info(get_type_name(),$psprintf("Done sequence: %s",req.convert2string()), UVM_HIGH)
  endtask: body
endclass: kei_vip_apb_master_burst_read_sequence


`endif // KEI_VIP_APB_MASTER_SEQ_LIB_SV


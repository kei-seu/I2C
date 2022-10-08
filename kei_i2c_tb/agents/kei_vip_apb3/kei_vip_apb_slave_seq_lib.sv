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
`ifndef KEI_VIP_APB_SLAVE_SEQ_LIB_SV
`define KEI_VIP_APB_SLAVE_SEQ_LIB_SV

//------------------------------------------------------------------------------
// SEQUENCE: example
//------------------------------------------------------------------------------
class example_kei_vip_apb_slave_seq extends uvm_sequence #(kei_vip_apb_transfer);

    function new(string name=""); 
      super.new(name);
    endfunction : new
  
  `uvm_object_utils(example_kei_vip_apb_slave_seq)    

    kei_vip_apb_transfer this_transfer;
  
    virtual task body();
      `uvm_info(get_type_name(),"Starting example sequence", UVM_HIGH)
       `uvm_do(this_transfer) 
	
      `uvm_info(get_type_name(),$psprintf("Done example sequence: %s",this_transfer.convert2string()), UVM_HIGH)
 
    endtask
  
endclass : example_kei_vip_apb_slave_seq

`endif // kei_vip_apb_SLAVE_SEQ_LIB_SV


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
`ifndef KEI_VIP_CONFIGURATION_SV
`define KEI_VIP_CONFIGURATION_SV

class kei_vip_configuration extends uvm_sequence_item;

  string inst;
   
   /**
    * CONSTRUCTOR : Create a new configuration instance, passing the appropriate argument
    * values to the parent class.
    *
    * @param name Instance name of the configuration
    */
   extern function new (string name = "kei_vip_configuration");
   
   // **********************************************************************************************
   //   SVT shorthand macros 
   // **********************************************************************************************
   `uvm_object_utils_begin(kei_vip_configuration)
   `uvm_field_string(inst, UVM_ALL_ON)
   `uvm_object_utils_end

endclass

function kei_vip_configuration::new(string name = "kei_vip_configuration");
    super.new(name);
endfunction : new

`endif // KEI_VIP_CONFIGURATION_SV

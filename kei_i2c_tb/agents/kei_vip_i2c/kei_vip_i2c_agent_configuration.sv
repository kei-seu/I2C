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

`ifndef KEI_VIP_I2C_AGENT_CONFIGURATION_SV
`define KEI_VIP_I2C_AGENT_CONFIGURATION_SV

class kei_vip_i2c_agent_configuration extends kei_vip_i2c_configuration;
  string inst;
  //Controls transition/state coverage collection
  bit coverage_enable =0;

  //Controls toggle coverage collection
  bit toggle_coverage_enable = 0;

  /*
    Enables protocol checks coverage collection.
     Possible values are as follows :
    
     - 1 : Enable
     - 0 : Disable
    */
  bit checks_coverage_enable = 1'b0;

  //Specifies the active and passive agents. is_active is 1 for active agent and 0 for passive agent
  bit is_active = 0;

  //Specifies if protcol checks are enabled or disabled
  bit checks_enable = 1;

  //Specifies if XML generation for PA is enabled.
  bit enable_xml_gen = 0;

  //Determines in which format the file should write the transaction data.
  // A value 0 indicates XML format, 1 indicates FSDB and 2 indicates both XML and FSDB.
  //svt_xml_writer::format_type_enum pa_format_type;  ---TODO 

  //Specifies if Monitor Traffic Log is enabled or disabled
  bit enable_traffic_log = 1;

  /*
  Determines if slave sequences are blocking or non-blocking.
    * Possible values are as follows :
    *
    * - 0 : Slave sequences will be non-blocking
    * - 1 : Slave sequences will be blocking
  */
  bit enable_slave_blocking = 0;

  /*
  Enables transaction-specific slave logs.
    * Possible values are as follows :
    *
    * - 0 : Slave logs will display complete bus activity
    * - 1 : Slave logs will display transaction-specific activity  
  */
  bit enable_slave_trans_log = 0;

  extern function new (string name = "kei_vip_i2c_agent_configuration");

  `uvm_object_utils_begin(kei_vip_i2c_agent_configuration)
      `uvm_field_int ( coverage_enable       , UVM_ALL_ON | UVM_BIN | UVM_NOPRINT)
      `uvm_field_int ( toggle_coverage_enable, UVM_ALL_ON | UVM_BIN | UVM_NOPRINT)
      `uvm_field_int ( checks_coverage_enable, UVM_ALL_ON | UVM_BIN )
      `uvm_field_int ( is_active             , UVM_ALL_ON | UVM_BIN )
      `uvm_field_int ( checks_enable         , UVM_ALL_ON | UVM_BIN )
      `uvm_field_int ( enable_xml_gen        , UVM_ALL_ON | UVM_BIN )
      `uvm_field_int ( enable_traffic_log    , UVM_ALL_ON | UVM_BIN )
      `uvm_field_int ( enable_slave_blocking , UVM_ALL_ON | UVM_BIN )
      `uvm_field_int ( enable_slave_trans_log, UVM_ALL_ON | UVM_BIN )
      //`uvm_field_enum (svt_xml_writer::format_type_enum, pa_format_type,)      
  `uvm_object_utils_end

  //Method to turn reasonable constraints on/off as a block.
  extern virtual function int reasonable_constraint_mode (bit on_off);

  extern virtual function int static_rand_mode(bit on_off);
   
  // Does a basic validation of this transaction object  
  extern virtual function bit is_valid (bit silent =1);

endclass

function kei_vip_i2c_agent_configuration::new(string name = "kei_vip_i2c_agent_configuration");
    super.new(name);
endfunction

function int kei_vip_i2c_agent_configuration::static_rand_mode(bit on_off);
  static_rand_mode = super.static_rand_mode(on_off);
endfunction : static_rand_mode

function int kei_vip_i2c_agent_configuration::reasonable_constraint_mode(bit on_off);
  reasonable_constraint_mode = super.reasonable_constraint_mode(on_off);
endfunction: reasonable_constraint_mode

function bit kei_vip_i2c_agent_configuration::is_valid (bit silent =1);
  is_valid = super.is_valid(silent);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(coverage_enable,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(toggle_coverage_enable,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(checks_coverage_enable,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(is_active,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(checks_enable,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_xml_gen,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_traffic_log,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_slave_blocking,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_slave_trans_log,0,1)
endfunction



`endif // KEI_VIP_I2C_AGENT_CONFIGURATION_SV

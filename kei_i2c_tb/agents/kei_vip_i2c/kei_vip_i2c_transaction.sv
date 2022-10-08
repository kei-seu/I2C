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
`ifndef KEI_VIP_I2C_TRANSACTION_SV
`define KEI_VIP_I2C_TRANSACTION_SV

/**
* This class represents data transaction for I2C Master and Slave Agents 
* and used by kei_vip_i2c_master_agent and kei_vip_i2c_slave_agent. <br/>
* 
* This class contains attributes of the transaction like command, address, 
* data, etc. <br/>
* 
* This class is also used directly by monitor to construct the response 
* object.
*/

class kei_vip_i2c_transaction extends uvm_sequence_item;

  kei_vip_i2c_agent_configuration cfg = null;

  /**
   * @grouphdr Response_Object Response Object fields 
   * This group contains attributes which are related to objects available 
   * only in response object for Master/Slave Agents.
   */
  
  /** 
   * It Specifies the type of command to perform. Possible commands are<br/>
   * 
   * - I2C_WRITE     :  Write Command
   * - I2C_READ      :  Read Command
   * - I2C_GEN_CALL  :  General command for broadcasting
   * - I2C_DEVICE_ID : Device ID request command
   * . 
   * Use in Master Agent : <i>Request Object & Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   * 
   * For reasonable constraint please refer to #reasonable_cmd
   */
  rand command_enum cmd = I2C_WRITE;
  
  /**
   * It specifies slave address for the command. <br/>  
   * 
   * Master Agent use this for both in request and response object. <br/>
   * Slave Agent use this only in response object. <br/>
   *
   * Use in Master Agent : <i>Request Object & Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   *
   * For reasonable constraint please refer to #reasonable_addr
   */
  rand bit [`KEI_VIP_I2C_SLA_ADD_WIDTH-1:0] addr = `KEI_VIP_I2C_SLAVE0_ADDRESS;
  
  /** 
   * It contains the user data to be generated on the Bus. <br/> 
   *
   * Use in Master Agent : <i>Request Object & Response Object </i><br/>
   * Use in Slave Agent  : <i>Request Object & Response Object </i><br/>
   */
  rand bit [7:0] data [];
  
  /**
   * Specifies the master to enable 10 bit addressing.
   */
  rand bit addr_10bit = 0;

  /**
   * Used to control the relative frequency of 10bit addressing
   * produced by randomization with the reasonable_addr_10bit constraint.
   */
  int unsigned ADDR_10BIT_ON_wt = 0;
  
  /**
   * Used to control the relative frequency of 7bit addressing
   * produced by randomization with the reasonable_addr_10bit constraint.
   */
  int unsigned ADDR_10BIT_OFF_wt = 1;  

  /**
   * @groupname Response_Object
   *
   * Signals START from Master. <br/>
   * Possible values are <br/>
   *
   * - 1 : Start detected
   * - 0 : Start not detected  
   * .
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */
  bit start_detected;
  
  /**
   * @groupname Response_Object
   *
   * Signals STOP from Master. <br/>
   * Possible values are <br/>
   *
   * - 1 : Stop detected
   * - 0 : Stop not detected  
   * .
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  bit stop_detected;
  
  /**
   * @groupname Response_Object
   *
   * Signals response as ACK/NACK. <br/>
   * Possible values are <br/>
   *
   * - 1 : ACK detected
   * - 0 : NACK detected  
   * .
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  bit ack_detected [];
  
  /**
   * @groupname Response_Object
   *
   * Signals Repeated Start. <br/>
   * Possible values are <br/>
   *
   * - 1 : Repeated Start detected
   * - 0 : Repeated Start not detected  
   * .
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  bit rep_start_detected;
  
  /**
   * @groupname Response_Object
   *
   * Signals Read/Write. <br/>
   * Possible values are <br/>
   *
   * - 1 : Read command detected
   * - 0 : Write command detected  
   * .
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  bit read_write; 
  
  /**
   * @groupname Response_Object
   *
   * Stores start time of START condition sent by Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int start_detected_st;
  
  /**
   * @groupname Response_Object
   *
   * Stores end time of START condition sent by Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int start_detected_et;
  
  /**
   * @groupname Response_Object
   *
   * Stores start time of STOP condition sent by Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int stop_detected_st;
  
  /**
   * @groupname Response_Object
   *
   * Stores end time of STOP condition sent by Master. <br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int stop_detected_et;
  
  /**
   * @groupname Response_Object
   *
   * Stores start time of ACK/NACK response for all data bytes.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int ack_detected_st [];
  
  /**
   * @groupname Response_Object
   *
   * Stores end time of ACK/NACK response for all data bytes.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int ack_detected_et [];
  
  /**
   * @groupname Response_Object
   *
   * Stores start time of REPEATED START from Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int rep_start_detected_st;
  
  /**
   * @groupname Response_Object
   *
   * Stores end time of REPEATED START from Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */
  int rep_start_detected_et;
  
  /**
   * @groupname Response_Object
   *
   * Stores start time of READ/WRITE command from Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */
  int read_write_st;
  
  /**
   * @groupname Response_Object
   *
   * Stores end time of READ/WRITE command from Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int read_write_et;
  
  /**
   * @groupname Response_Object
   *
   * Stores start time of Slave Address from Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int addr_st;
  
  /**
   * @groupname Response_Object
   *
   * Stores end time of Slave Address from Master.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int addr_et;
  
  /**
   * @groupname Response_Object
   *
   * Stores start time of all bytes of DATA. <br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int data_st [];
  
  /**
   * @groupname Response_Object
   *
   * Stores end time of all bytes of DATA.<br/>
   * Time is represented in timescale used (100ps by default).<br/>
   *
   * Use in Master Agent : <i>Response Object </i><br/>
   * Use in Slave Agent  : <i>Response Object </i><br/>
   */      
  int data_et [];
  
  /** 
   * Enable/Disable the command fired from Master. Possible values are :
   * 1 : Command is sent to BFM. <br/> 
   * 0 : Command is not sent to BFM. <br/> 
   * 
   * Use in Master Agent : <i>Request Object  </i><br/>
   * Use in Slave Agent  : <i>Request Object </i><br/>
   * 
   */
  bit enable_cmd = 1;
  
  /** 
   * Enable/disable the sequence data fired driving. Possible values are :
   * 1 : Agent Driver uses sequence data <br/>
   * 0 : Agent Driver ignores the sequence data <br/>
   * 
   * Use in Master Agent : <i>Request Object  </i><br/>
   * Use in Slave Agent  : <i>Request Object </i><br/>
   * 
   */
  bit enable_pkt = 1;
  
  /** 
   * Enable/disable configuration driving. Possible values are :
   * 1 : Configuration is sent to BFM. <br/>
   * 0 : Configuration is not sent to BFM. <br/>
   * 
   * Use in Master Agent : <i>Request Object  </i><br/>
   * Use in Slave Agent  : <i>Request Object </i><br/>
   * 
   */
  bit enable_cfg = 1;

  /** 
   * SMBUS General ARP command argument 
   */
   bit [7:0] gnrl_arp_arg;

  /** 
   * SMBUS DIRECT ARP command argument 
   */
   
   bit 	     drct_arp_arg;
   
   /** 
    * valid_ranges constraints prevent illegal and/or not supported by the 
    * Protocol & VIP.
   * These should ONLY be disabled if the parameters covered by them are 
   * turned off. If these are turned off without the constraints being 
   * turned off it can lead to problems during randomization. </br>
   * In situations involving extended classes, issues with name conflicts
   * can arise. If the extended (e.g., cust_kei_vip_i2c_master_transaction) 
   * and base (e.g., kei_vip_i2c_master_transaction) classes both use the same 
   * valid_ranges’ constraint name, then the ‘valid_ranges’ constraint 
   * in the extended class (e.g., cust_kei_vip_i2c_master_transaction), will 
   * override the ‘valid_ranges’ constraint in the base class (e.g., 
   * kei_vip_i2c_master_transaction). Because the valid_ranges constraints 
   * must be retained most of the time, classes extensions should prefix
   * the name of the constraint block to ensure uniqueness, e.g. 
   * “cust_valid_ranges”.
    */
   constraint valid_ranges {
      if((cfg!=null)&&(cfg.bus_type == I2C_BUS ))   cmd inside {I2C_READ,    I2C_WRITE ,    I2C_GEN_CALL,   I2C_DEVICE_ID};
      if((cfg!=null)&&(cfg.bus_type == I2C_BUS ))   data.size() inside {[1:5120]};
      else data.size() inside {[1:1024]};
   }
   
   /**
    * Reasonable constraint for #cmd   <br/>                    
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
   * as a block via the #reasonable_constraint_mode method.<br/>                           
   */
   constraint reasonable_cmd {
      if((cfg!=null)&&(cfg.bus_type == I2C_BUS ))  cmd inside {I2C_READ,    I2C_WRITE };
   }

  /**
   * Reasonable constraint for #byte_dat <br/>                       
   * Specifies the range within which byte count can take a value.<br/> 
   * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
   * as a block via the #reasonable_constraint_mode method. <br/>                          
   */
   constraint reasonable_data {
      if((cfg!=null)&&(cfg.bus_type == I2C_BUS ))   data.size() inside {[1:10]};
      else data.size() inside {[1:1024]};
   }
   
  /**                       
   * Reasonable constraint for #addr <br/>
   * Takes one of the supported Slave addresses.<br/>
   * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
   * as a block via the #reasonable_constraint_mode method. <br/>                          
   */
  constraint reasonable_addr {  	  
    addr inside {10'b1100110011, 10'b1100110000};
  }

  /**
   * Reasonable constraint for #addr_10bit <br/>                     
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
   * as a block via the #reasonable_constraint_mode method. <br/>                          
   */
  constraint reasonable_addr_10bit {
    addr_10bit dist {
                      0 :/ADDR_10BIT_OFF_wt,
                      1 :/ADDR_10BIT_ON_wt
                    };
  }
      
  /**
   * UVM field automation macros 
   */
  `uvm_object_utils_begin(kei_vip_i2c_transaction)
    `uvm_field_enum(command_enum, cmd , UVM_ALL_ON|UVM_ENUM)
    `uvm_field_object(cfg                 , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(addr                   , UVM_ALL_ON|UVM_HEX)
    `uvm_field_array_int(data             , UVM_ALL_ON|UVM_HEX)
    `uvm_field_int(addr_10bit             , UVM_ALL_ON)
    `uvm_field_int(start_detected         , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(stop_detected          , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(rep_start_detected     , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(read_write             , UVM_ALL_ON)
    `uvm_field_int(start_detected_st      , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(start_detected_et      , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(stop_detected_st       , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(stop_detected_et       , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_array_int(ack_detected     , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_array_int(ack_detected_st  , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_array_int(ack_detected_et  , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(rep_start_detected_st  , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(rep_start_detected_et  , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(read_write_st          , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(read_write_et          , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(addr_st                , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(addr_et                , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_array_int(data_st          , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_array_int(data_et          , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(enable_cmd             , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(enable_pkt             , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(enable_cfg             , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(ADDR_10BIT_ON_wt       , UVM_ALL_ON|UVM_NOPRINT)
    `uvm_field_int(ADDR_10BIT_OFF_wt      , UVM_ALL_ON|UVM_NOPRINT)
  `uvm_object_utils_end

  /**
   * CONSTRUCTOR : Create a new transaction instance, passing the appropriate 
   * argument values to the parent class.
   *
   * @param name Instance name of the transaction
   */
  extern function new (string name = "kei_vip_i2c_transaction");

  /**
   * Method to turn reasonable constraints on/off as a block.
   * 
   * @param on_off Enable/Disable the constraint mode
   */
  extern virtual function int reasonable_constraint_mode (bit on_off);

  /**
   * Checks to see that the data field values are valid.
   *
   * @param silent bit indicating whether failures should result in warning 
   * messages.
   * @param kind This int indicates the type of is_avalid check to attempt. 
   * Only supported kind value is `SVT_TRANSACTION_BASE_TYPE::COMPLETE, 
   * which results in verification that the non-static data members are all 
   * valid. All other kind values result in a return value of 1.
   */
  extern virtual function bit is_valid (bit silent = 1);
endclass

function kei_vip_i2c_transaction::new(string name = "kei_vip_i2c_transaction");
    super.new(name);
endfunction

function int kei_vip_i2c_transaction::reasonable_constraint_mode (bit on_off);
  reasonable_cmd.constraint_mode(on_off);
  reasonable_addr.constraint_mode(on_off);
  return on_off;
endfunction


function bit kei_vip_i2c_transaction::is_valid (bit silent = 1);
  is_valid = 1;
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(addr,0,10'b11_1111_1111)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(addr_10bit,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(ADDR_10BIT_ON_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(ADDR_10BIT_OFF_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(start_detected,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(stop_detected,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(rep_start_detected,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(read_write,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(start_detected_st,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(start_detected_et,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(stop_detected_st,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(stop_detected_et,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(rep_start_detected_st,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(rep_start_detected_et,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(read_write_st,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(read_write_et,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(addr_st,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(addr_et,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_cmd,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_pkt,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_cfg,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(gnrl_arp_arg,0,8'hFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(drct_arp_arg,0,1)
endfunction


`endif // KEI_VIP_I2C_TRANSACTION_SV

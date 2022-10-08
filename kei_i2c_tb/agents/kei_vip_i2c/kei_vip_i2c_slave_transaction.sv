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
`ifndef KEI_VIP_I2C_SLAVE_TRANSACTION_SV
`define KEI_VIP_I2C_SLAVE_TRANSACTION_SV

class kei_vip_i2c_slave_transaction extends kei_vip_i2c_transaction;

  /** Object used to hold exceptions for a transaction */
  //kei_vip_i2c_slave_transaction_exception_list exception_list = null;

  /**
   * Specifies if Slave has to respond with a NACK if it receives self
   * address on Bus.<br/>
   * - 1 : Slave responds with a NACK if self-address of Slave is
   * transmitted on Bus<br/>
   * - 0 : Slave responds with an ACK if self address of Slave was
   * transmitted on Bus.<br/>
   * .
   * For reasonable constraint please refer to #reasonable_slave_nack_addr
   */
  rand bit nack_addr = 0;

  /**
   * Specifies the number of times Slave has to respond with NACK on
   * detecting self-address on Bus
   *
   * For valid ranges please refer to #slave_valid_ranges
   */
  rand bit [31:0] nack_addr_count = 32'h0000;

  /**
   * If value of clk_stretch_time_after_byte is greater than zero,Slave
   * holds SCL line low for the duration specified by the value after
   * every byte transmitted by Master.
   */
  int unsigned clk_stretch_time_after_byte = 0;

  /**
   * If value of clk_stretch_time_addr_byte is greater than zero, Slave
   * holds SCL line low for the duration specified by the value when
   * Master transmits Slave address. It is a bit level stretching.
   */
  int unsigned clk_stretch_time_addr_byte = 0;

  /**
   * If value of clk_stretch_time_data_byte is greater than zero Slave
   * holds SCL line low for the duration specified by the value when
   * it transmits or receives the data byte. It is a bit level stretching.
   */
  int unsigned clk_stretch_time_data_byte = 0;

  /**
   * This variable is used to enable/disable random clock stretching
   * after every byte transmitted by Master.
   */
  bit enable_random_clk_stretch_time_after_byte = 1'b0;

  /**
   * This variable is used to enable/disable random clock stretching
   * for each bit in address phase. It is a bit level stretching.
   */
  bit enable_random_clk_stretch_time_addr_byte = 1'b0;

  /**
   * This variable is used to enable/disable random clock stretching
   * for each bit in data phase. It is a bit level stretching.
   */
  bit enable_random_clk_stretch_time_data_byte = 1'b0;

  /**
   * This variable is used to select position at which bit-level
   * clock stretching in address phase will be done by slave.
   */
  rand bit [3:0] clk_stretch_bit_level_addr_pos  = 4'b0000;

  /**
   * This variable is used to select position at which bit-level
   * clock stretching in data phase will be done by slave.
   */
  rand bit [3:0] clk_stretch_bit_level_data_pos  = 4'b0000;

  /**
   * This variable is used to select position at which byte-level
   * clock stretching will be done by slave.
   */
  rand bit [31:0] clk_stretch_byte_level_pos = 32'h0000;

  /**
   * Dumps the EEPROM memory in Slave BFM from the file specified by files
   * handle passed< as second argument.
   * <u>Note</u>: <i>This configuration takes effect if Slave is configured
   * as an EEPROM Slave.</i>
   */
  bit [31:0] eeprom_mem_dump = 32'h0000;

  /**
   * Loads the EEPROM memory in Slave BFM with the data specified in files
   * handle passed as second argument. Note: This configuration occurs
   * only if Slave is configured as an EEPROM Slave.
   */
  bit [31:0] eeprom_mem_load = 32'h0000;

  /**
   * If the value of nack_data is greater than zero, Slave responds with a
   * NACK while receiving data from Bus. Slave sends NACK for the
   * particular data byte for which it was configured. If the value is 3,
   * Slave sends NACK at 3rd data byte.
   */
  rand bit [31:0] nack_data = 32'h0000;

  /**
   * Used to control the relative frequency of slave response = NACK in address phase
   * produced by randomization with the reasonable_nack_addr constraint.
   */
  int unsigned NACK_ADDRESS_ON_wt = 0;

  /**
   * Used to control the relative frequency of slave response = ACK in address phase
   * produced by randomization with the reasonable_nack_addr constraint.
   */
  int unsigned NACK_ADDRESS_OFF_wt = 1;

  /**
   * slave_valid_ranges constraints prevent illegal and/or not supported
   * by the Protocol & VIP.
   * These should ONLY be disabled if the parameters covered by them are
   * turned off. If these are turned off without the constraints being
   * turned off it can lead to problems during randomization. </br>
   * In situations involving extended classes, issues with name conflicts
   * can arise. If the extended (e.g., cust_kei_vip_i2c_slave_transaction) and
   * base (e.g., kei_vip_i2c_slave_transaction) classes both use the same
   * slave_valid_ranges’ constraint name, then the ‘slave_valid_ranges’
   * constraint in the extended class (e.g.,cust_kei_vip_i2c_slave_transaction),
   * will override the ‘slave_valid_ranges’ constraint in the base class
   * (e.g., kei_vip_i2c_msater_transaction). Because the slave_valid_ranges
   * constraints must be retained most of the time, classes extensions
   * should prefix the name of the constraint block to ensure uniqueness,
   * e.g. “cust_slave_valid_ranges”.
   */

  /**
   * Temporary variable used to hold onto the XML writer currently being used for XML generation.
   * Only valid within call to save_prop_vals_to_xml().
   */
  // kei_vip_xml_writer active_writer = null;

  constraint slave_valid_ranges {
    nack_addr_count inside {[0:31]};
    clk_stretch_bit_level_addr_pos inside {[0:8]};
    clk_stretch_bit_level_data_pos inside {[0:8]};
    clk_stretch_byte_level_pos <= data.size();
  }

  /**
   * Reasonable constraint for #nack_addr <br/>
   *
   * Constraint can take values 0 or 1 as per the weights set.<br/>
   * By default weight is set to 0 for value 1.<br/>
   * This constraint is ON by default; reasonable constraints can be enabled/disabled <br/>
   * as a block via the #reasonable_constraint_mode method.<br/>
   */
  constraint reasonable_nack_addr {
    nack_addr dist {
      0  :/NACK_ADDRESS_OFF_wt,
      1  :/NACK_ADDRESS_ON_wt
    };
  }

  constraint reasonable_nack_data {
    soft nack_data == 0;
  }

  /**
   * Reasonable constraint for clk_stretch_bit_level_addr_pos.
   */
  constraint reasonable_clk_stretch_bit_level_addr_pos {
    clk_stretch_bit_level_addr_pos inside {[1:8]};
  }

  /**
   * Reasonable constraint for clk_stretch_bit_level_data_pos.
   */
  constraint reasonable_clk_stretch_bit_level_data_pos {
    clk_stretch_bit_level_data_pos inside {[1:8]};
  }

  /**
   * Reasonable constraint for clk_stretch_byte_level_pos.
   */
  constraint reasonable_clk_stretch_byte_level_pos {
    clk_stretch_byte_level_pos inside {[1:data.size()]};
  }

  `uvm_object_utils_begin(kei_vip_i2c_slave_transaction)
  `uvm_object_utils_end

  extern function new (string name = "kei_vip_i2c_slave_transaction");
  extern function bit is_valid (bit silent =1);

endclass

function kei_vip_i2c_slave_transaction::new(string name = "kei_vip_i2c_slave_transaction");
  super.new(name);
endfunction
function  bit kei_vip_i2c_slave_transaction::is_valid(bit silent =1);
  is_valid = super.is_valid(silent);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(nack_addr,0,1);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(nack_addr_count,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clk_stretch_time_after_byte,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clk_stretch_time_addr_byte,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clk_stretch_time_data_byte,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_random_clk_stretch_time_after_byte,0,1);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_random_clk_stretch_time_addr_byte,0,1);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_random_clk_stretch_time_data_byte,0,1);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clk_stretch_bit_level_addr_pos,0,4'b1111);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clk_stretch_bit_level_data_pos,0,4'b1111);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clk_stretch_byte_level_pos,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(eeprom_mem_dump,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(eeprom_mem_load,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(nack_data,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(NACK_ADDRESS_ON_wt,0,32'hFFFF_FFFF);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(NACK_ADDRESS_OFF_wt,0,32'hFFFF_FFFF);
endfunction

`endif // KEI_VIP_I2C_SLAVE_TRANSACTION_SV

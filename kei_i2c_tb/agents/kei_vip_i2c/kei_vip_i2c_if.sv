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


`ifndef KEI_VIP_I2C_IF_SV
`define KEI_VIP_I2C_IF_SV

interface kei_vip_i2c_if (input bit CLK);

  /** 
   * This signal is connected to the SCL (serial clock) of 
   * all connected masters/slaves. All masters/slaves drive their 
   * SCL on this signal of the corresponding instance of this port interface.
   * The output SCL from all masters/slaves is wired AND by this signal.
   */ 
  wand  SCL;
  
  /**
   * This signal is connected to the SDA (serial data) of
   * all connected masters/slaves. All masters/slaves drive their
   * SDA on this signal of the corresponding instance of this port interface.
   * The output SDA from all masters/slaves is wired AND by this signal.
   */ 
  wand  SDA;

  /**
   * This signal is connected to the SMBALRT (serial data) of
   * all connected masters/slaves. All masters/slaves drive their
   * SMBALRT on this signal of the corresponding instance of this port interface.
   * The output SMBALRT from all masters/slaves is wired AND by this signal.
   */ 
  wand  SMBALRT;
  
  /** 
   * Reset signal 
   * Reset is generated from the testbench. This reset is used to
   * reset master/slave bfm, monitor and checker.
   */ 
  bit RST ;

  /** 
   * Determines whether to pullup the SCL & SDA from Master & Slave. 
   * When the value is 1 then SCL & SDA will be pulled up to '1'.
   */ 
  bit enable_pullup_resistor = 1'b1;   

  logic scl_master;
  logic smbalrt_master;
  logic sda_master;

  // @Lusang NOTE::
  // Must use '===' instead of '==' to take 'x' value as a state, and thus
  // drive SCL/SDA high-z value while in bus idle state
  assign SCL = scl_master === 0 ? 1'b0 : 1'bz;
  assign SDA = sda_master === 0 ? 1'b0 : 1'bz;
  assign SMBALRT = smbalrt_master === 0 ? 1'b0 : 1'bz;


  logic scl_slave;
  logic smbalrt_slave;
  logic sda_slave;

  assign SCL = scl_slave === 0 ? 1'b0 : 1'bz;
  assign SDA = sda_slave === 0 ? 1'b0 : 1'bz;
  assign SMBALRT = smbalrt_slave === 0 ? 1'b0 : 1'bz;

  modport kei_vip_i2c_master_modport (
    input  RST,
    input  CLK,
    inout  SCL,
    inout  SMBALRT,
    inout  SDA
  );

 modport kei_vip_i2c_slave_modport (
    input  RST,
    input  CLK,
    inout  SCL,
    inout  SMBALRT,
    inout  SDA
  );

  modport kei_vip_i2c_monitor_modport (
    input  RST,
    input  CLK,
    inout  SCL,
    inout  SMBALRT,
    inout  SDA
  );


  event event_master_start_generated          ;
  event event_master_stop_generated           ;
  event event_master_ack_generated            ;
  event event_master_nack_generated           ;
  event event_master_ack_received             ;
  event event_master_nack_received            ;
  event event_master_repeated_start_generated ;
  event event_master_start_byte_transmited    ;
  event event_master_general_call_addr_sent   ;
  event event_master_general_call_sec_byte_sent   ;
  event event_master_arbitration_loss_detected;

  assign (weak0, weak1) SCL = enable_pullup_resistor ? 1 : 0;
  assign (weak0, weak1) SDA = enable_pullup_resistor ? 1 : 0;
  assign (weak0, weak1) SMBALRT = enable_pullup_resistor ? 1 : 0;
  //assign SCL = enable_pullup_resistor ? 1 : 0;
  //assign SDA = enable_pullup_resistor ? 1 : 0;
  //assign SMBALRT = enable_pullup_resistor ? 1 : 0;
  // Coverage and assertions to be implemented here.
  // USER: Add assertions/coverage here

endinterface : kei_vip_i2c_if

`endif // KEI_VIP_I2C_IF_SV

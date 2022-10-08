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
`ifndef KEI_VIP_I2C_MASTER_TRANSACTION_SV
`define KEI_VIP_I2C_MASTER_TRANSACTION_SV

class kei_vip_i2c_master_transaction extends kei_vip_i2c_transaction;
    /** 
   * Specifies if Master has to generate Repeated START (Sr) or a STOP (P)
   * condition after the current transaction <br/>					   
   * - 1 : Generates Repeated START (Sr) condition.<br/>
   * - 0 : Generates STOP (P) condition.<br/>
   * .
   * For reasonable constraint please refer to #reasonable_sr_or_p_gen 
   */
  rand bit sr_or_p_gen = 0;
  
  /**
   * This count determines the number of time Master will try <br/>
   * to complete the current transaction before dumping it in <br/> 
   * case of not getting an ACK from Slave or when it loses arbitration.<br/> 
   * Possible values are 1 to 7.<br/>
   * 
   * For valid ranges please refer to #master_valid_ranges  
   */
  rand bit [2:0] num_of_retry = 3'b001;
    /** 
   * This byte is sent as second byte after General Call address is sent 
   * on the bus by Master.<br/> Possible Values are :
   * 
   * <dl>
   * <dt> 00000110 (H‘06’)  </dt> 
   * <dd> Reset and write programmable part of slave address by hardware.
   * On receiving this 2-byte sequence, all devices designed to respond to 
   * the general call address will reset and take in the programmable part 
   * of their address. Precautions have to be taken to ensure that a 
   * device is not pulling down the SDA or SCL line after applying the 
   * supply voltage, since these low levels would block the bus.
   * </dd>
   * <dt> 00000100 (H‘04’)  </dt> 
   * <dd> Write programmable part of slave address by hardware. All devices 
   * which define the programmable part of their address by hardware 
   * (and which respond to the general call address) will latch this 
   * programmable part at the reception of this two byte sequence. The 
   * device will not reset.
   * <dd/>
   * <dt> 00000000 (H‘00’) </dt>
   * <dd> This code is not allowed to be used as the second byte.<br/>
   * <dd/>
   * <dt> Other Values </dt>
   * <dd> The remaining codes have not been fixed and devices must ignore 
   * them.
   * <dd/>
   * <dl/> 
   *  
   *  For reasonable constraint please refer to #reasonable_sec_byte_gen_call 
   */
  rand bit [7:0] sec_byte_gen_call = 8'h04;
  /** 
   * Specifies if Master has to send START byte at the beginning of the 
   * transaction. Possible values are<br/>
   * 
   * - 1 : Master sends Start Byte
   * - 0 : Master doesnot send Start Byte  
   * .
   * For reasonable constraint please refer to #reasonable_send_start_byte 
   */
  rand bit send_start_byte = 0;
  
  /** 
   * This is the time interval between completions of a transaction to the start of 
   * next transaction for Master. <br/> 
   * Time is represented in timescale used (100ps by default).<br/>
   * 
   * For reasonable constraint please refer to #reasonable_idle_time 
   */
  rand bit [31:0] idle_time = 32'h0001;
  
  /** 
   * Specifies if Master has to dump the current transaction <br/> 
   * or retry if it loses arbitration. <br/>
   * - 1 : Dump the current transaction.<br/>
   * - 0 : Retry to complete the current transaction 
   * .
   */
  rand  bit abort_if_arb_lost = 0; 
  
  /** 
   * Specifies that Master has to arbitrate for the current transaction.<br/> 
   * If this configuration parameter is set, Master waits till a START condition is <br/> 
   * generated on the bus by other Master on the bus then start the received transaction.<br/>  
   * NOTE : If this configuration parameter is set when only single MasterBFM is present in <br/> 
   * the environment, causes the sequence to hang.<br/> 
   * - 1 : Wait for START condition before Starting the next transaction on the bus.<br/>  
   * - 0 : Does not wait for START from another Master to start the next transaction.<br/> 
   * .
   */
  rand bit arbitrate = 0;
  /** 
   * Specifies if Master has to abort the current transaction<br/> 
   * or retry it to complete if receives a NACK from Slave.<br/> 
   * - 1 : Retry to complete the current transaction<br/> 
   * - 0 : Abort (dump) the current transaction.<br/> 
   * .
   */
  rand bit retry_if_nack = 0;
  
  /**
   * Used to control the relative frequency of repeated start
   * produced by randomization with the reasonable_sr_or_p_gen constraint.
   */
  int unsigned SR_OR_P_GEN_REPEATED_wt = 0;
  
  /**
   * Used to control the relative frequency of stop
   * produced by randomization with the reasonable_sr_or_p_gen constraint.
   */
  int unsigned SR_OR_P_GEN_STOP_wt = 1;

  /**
   * Used to control the relative frequency of sending start byte
   * produced by randomization with the reasonable_send_start_byte constraint.
   */
  int unsigned START_BYTE_ON_wt = 0;
  
  /**
   * Used to control the relative frequency of not sending start byte
   * produced by randomization with the reasonable_send_start_byte constraint.
   */
  int unsigned START_BYTE_OFF_wt = 1;

  /**
   * Used to control the relative frequency of retrying transfer when arbitration lost
   * produced by randomization with the reasonable_abort_if_arb_lost constraint.
   */
  int unsigned ABORT_IF_ARB_LOST_ON_wt = 0;
  
  /**
   * Used to control the relative frequency of aborting transfer when arbitration lost
   * produced by randomization with the reasonable_abort_if_arb_lost constraint.
   */
  int unsigned ABORT_IF_ARB_LOST_OFF_wt = 1;
  /**
   * Used to control the relative frequency of no arbitration from master
   * produced by randomization with the reasonable_arbitrate constraint.
   */
  int unsigned ARBITRATE_ON_wt = 0;
  
  /**
   * Used to control the relative frequency of arbitration from master
   * produced by randomization with the reasonable_arbitrate constraint.
   */
  int unsigned ARBITRATE_OFF_wt = 1;

  /**
   * Used to control the relative frequency of retry from master
   * produced by randomization with the reasonable_retry_if_nack constraint.
   */
  int unsigned RETRY_IF_NACK_ON_wt = 0;
  
  /**
   * Used to control the relative frequency of not retrying from master
   * produced by randomization with the reasonable_retry_if_nack constraint.
   */
  int unsigned RETRY_IF_NACK_OFF_wt = 1;

  /** 
   * Used to enable/disable clock stretching from Master after 
   * every byte transmitted by Master. The clock stretching will
   * be for random number of reference clock cycles and the maximum
   * and minimum range for the random number can be configured through
   * macros SVT_I2C_RAND_CLOCK_STRETCH_MAX & SVT_I2C_RAND_CLOCK_STRETCH_MIN 
   */
  bit enable_clk_stretch_after_byte = 1'b0;
  
  /** 
   * Used to select position at which byte-level clock 
   * stretching will be done by Master.
   */
  rand bit [31:0] clk_stretch_byte_level_pos = 32'h0000;
  /**
   * When the master requests for Device Id, according to the frame format
   * as per the protocol, after the ACK is received for the slave address, a
   * Repeated START is generated by the Master. However, m_device_id_gen_stop
   * can be configured to 1 to force a STOP instead of a Repeated START.
   */
  rand bit m_device_id_gen_stop = 0;

  /**
   * When the master requests for Device Id, according to the frame format
   * as per the protocol, 1st and 2nd byte of the device id is followed by
   * an ACK from the master. However, nack_at_device_id_byte can be configured 
   * to generate NACK instead of ACK. This variable can be configured to any 
   * integer value n. In case the rollback feature is not enabled, setting the
   * value of the variable to 3 will not have any effect as the 3rd byte will
   * already be followed by a NACK (as per the protocol).
   */
  rand int nack_at_device_id_byte = 0;

  /**
   * When the master requests for Device ID, according to the frame format
   * as per the protocol, the 3rd byte of the dvice id is followed by a NACK
   * from the master. However, device_id_rollback_iteration can be configured
   * by the user to force an ACK instead of a NACK. This will enable the rollback
   * feature and the slave will keep sending the device id bytes all over again 
   * untill a NACK is received on either of the 3 bytes of device id. This 
   * variable can be set to any value of n, depending on how many times the user
   * wants to force a NACK on the 3rd byte.
   */
  rand int device_id_rollback_iteration = 0;

  //-----------------------------------------------------------------------------------
  /* TODO:: To un-commend later 
  //-----------------------------------------------------------------------------------

//   /** 
//    * master_valid_ranges constraints prevent illegal and/or not supported 
//    * by the Protocol & VIP. 
//    * These should ONLY be disabled if the parameters covered by them are 
//    * turned off. If these are turned off without the constraints being 
//    * turned off it can lead to problems during randomization. </br>
//    * In situations involving extended classes, issues with name conflicts 
//    * can arise. If the extended (e.g., cust_svt_i2c_master_transaction) and 
//    * base (e.g., svt_i2c_master_transaction) classes both use the same 
//    * master_valid_ranges’ constraint name, then the ‘master_valid_ranges’ 
//    * constraint in the extended class (e.g.,cust_svt_i2c_master_transaction), 
//    * will override the ‘master_valid_ranges’ constraint in the base class 
//    * (e.g., svt_i2c_msater_transaction). Because the master_valid_ranges 
//    * constraints must be retained most of the time, classes extensions 
//    * should prefix the name of the constraint block to ensure uniqueness, 
//    * e.g. “cust_master_valid_ranges”.
//    */
// 
   constraint master_valid_ranges {
     idle_time inside {[0:1000]};
     num_of_retry inside { [0:7]};
     sec_byte_gen_call inside { 8'h04, 8'h06 };
     clk_stretch_byte_level_pos <= data.size();
     nack_at_device_id_byte inside {[0:`KEI_VIP_I2C_NACK_AT_DEVICE_ID_BYTE_MAX_VALID]};
     device_id_rollback_iteration inside {[0:`KEI_VIP_I2C_DEVICE_ID_ROLLBACK_ITER_MAX_VALID]};
   }
// 
//   /** 
//    * Reasonable constraint for #sr_or_p_gen <br/>                      
//    *
//    * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
//    * as a block via the #reasonable_constraint_mode method.<br/>                           
//    */
   constraint reasonable_sr_or_p_gen {
     sr_or_p_gen dist {
                        0 :/SR_OR_P_GEN_STOP_wt,
                        1 :/SR_OR_P_GEN_REPEATED_wt
                      };
   }
//   /** 
//    * Reasonable constraint for #idle_time <br/>                      
//    *
//    * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
//    * as a block via the #reasonable_constraint_mode method.<br/>                           
//    */
   constraint reasonable_idle_time {
     idle_time dist { 
                      0 := 1,
                      [1:10] := 100000,
                      [11:1000] := 1
                    };
   }
//     
//   /**
//    * Reasonable constraint for #sec_byte_gen_call<br/>                       
//    *
//    * Specifies that the second byte after general call address must be either 8'h06 or 8'h04 <br/> 	     
//    * This constraint is ON by default; reasonable constraints can be enabled/disabled <br/>
//    * as a block via the #reasonable_constraint_mode method. <br/>                          
//    */
   constraint reasonable_sec_byte_gen_call {
     sec_byte_gen_call inside {8'h04, 8'h06};
   }
//     
//   /**
//    * Reasonable constraint for #send_start_byte <br/>                     
//    *
//    * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
//    * as a block via the #reasonable_constraint_mode method. <br/>                          
//    */
   constraint reasonable_send_start_byte {
     send_start_byte dist {
                            0 :/START_BYTE_OFF_wt,
                            1 :/START_BYTE_ON_wt
                          };
   } 
//   /** 
//    * Reasonable constraint for #abort_if_arb_lost <br/>                     
//    *
//    * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
//    * as a block via the #reasonable_constraint_mode method. <br/>                          
//    */
//  
   constraint reasonable_abort_if_arb_lost {
     abort_if_arb_lost dist {
                              0 :/ABORT_IF_ARB_LOST_OFF_wt,
                              1 :/ABORT_IF_ARB_LOST_ON_wt
                            };
   }
// 
//   /** 
//    * Reasonable constraint for #arbitrate <br/>                     
//    *
//    * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
//    * as a block via the #reasonable_constraint_mode method. <br/>                          
//    */
   constraint reasonable_arbitrate {
     arbitrate dist {
                      0 :/ARBITRATE_OFF_wt,
                      1 :/ARBITRATE_ON_wt
                    };
   }
//     
//   /**
//    * Reasonable constraint for #retry_if_nack <br/>                     
//    *
//    * This constraint is ON by default; reasonable constraints can be enabled/disabled<br/> 
//    * as a block via the #reasonable_constraint_mode method. <br/>                          
//    */
   constraint reasonable_retry_if_nack {
     retry_if_nack dist {
                          0 :/RETRY_IF_NACK_OFF_wt,
                          1 :/RETRY_IF_NACK_ON_wt
                        };
   }
//   
//   /**
//    * Reasonable constraint for clk_stretch_byte_level_pos.
//    */
//   constraint reasonable_clk_stretch_byte_level_pos {
//     clk_stretch_byte_level_pos inside {[0:data.size()]};
//   }
// 
//   /**
//    * Reasonable constraint for m_device_id_gen_stop.
//    */
   constraint reasonable_m_device_id_gen_stop {
     m_device_id_gen_stop dist {
                                 0 := 1,
                                 1 := 0
                               };
   }
// 
//   /**
//    * Reasonable constraint for nack_at_device_id_byte.
//    */
   constraint reasonable_nack_at_device_id_byte {
     nack_at_device_id_byte inside {[0:20]};
   }
// 
//   /**
//    * Reasonable constraint for device_id_rollback_iteration.
//    */
   constraint reasonable_device_id_rollback_iteration {
     device_id_rollback_iteration inside {[0:5]};
   }

  `uvm_object_utils_begin(kei_vip_i2c_master_transaction)
  `uvm_object_utils_end

  extern function new (string name = "kei_vip_i2c_master_transaction");
  extern function bit is_valid (bit silent =1);

endclass

function kei_vip_i2c_master_transaction::new(string name = "kei_vip_i2c_master_transaction");
    super.new(name);
endfunction
function  bit kei_vip_i2c_master_transaction::is_valid(bit silent =1);
  is_valid = super.is_valid(silent);
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(sr_or_p_gen,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(num_of_retry,0,3'b111)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(sec_byte_gen_call,0,8'hFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(send_start_byte,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(idle_time,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(abort_if_arb_lost,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(arbitrate,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(retry_if_nack,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(SR_OR_P_GEN_REPEATED_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(SR_OR_P_GEN_STOP_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(START_BYTE_ON_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(START_BYTE_OFF_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(ABORT_IF_ARB_LOST_ON_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(ABORT_IF_ARB_LOST_OFF_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(ARBITRATE_ON_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(ARBITRATE_OFF_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(RETRY_IF_NACK_ON_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(RETRY_IF_NACK_OFF_wt,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_clk_stretch_after_byte,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clk_stretch_byte_level_pos,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(m_device_id_gen_stop,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(nack_at_device_id_byte,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(device_id_rollback_iteration,32'h0,32'hFFFF_FFFF)

endfunction
`endif // KEI_VIP_I2C_MASTER_TRANSACTION_SV

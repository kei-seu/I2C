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
`ifndef KEI_VIP_I2C_CONFIGURATION_SV
`define KEI_VIP_I2C_CONFIGURATION_SV

class kei_vip_i2c_configuration extends kei_vip_configuration;
  bus_type_enum  bus_type = I2C_BUS;
  /*
  I2C bus speed 
   * Specifies the I2C bus speed. The legal values, and their meanings, are as follows:
   *
   *  - STANDARD_MODE   : Stanadard Mode
   *  - FAST_MODE       : Fast mode 
   *  - HIGH_SPEED_MODE : High Speed Mode
   *  - FAST_MODE_PLUS  : Fast Mode Plus
   *  Default Value : STANDARD_MODE 
   */
  bus_speed_enum bus_speed = STANDARD_MODE;

  string inst;

  /*
  Defines the high time of SCL clock for standard speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns  
   * For reasonable constraint please refer to #reasonable_scl_high_time_ss    
   * 
   * Default Value : 4000 
   */
  rand int unsigned scl_high_time_ss = `KEI_VIP_I2C_CLK_HIGH_SS;

  /*
  Defines the low time of SCL clock for standard speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   * 
   * For reasonable constraint please refer to #reasonable_scl_low_time_ss 
   *  
   * Default Value : 4700
   */
  rand int unsigned scl_low_time_ss = `KEI_VIP_I2C_CLK_LOW_SS;

  /*
  Defines the high time offset for SCL clock for standard speed mode 
   * This is used to model the rise time of SCL in standard speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns  
   * For reasonable constraint please refer to #reasonable_scl_high_time_offset_ss    
   * 
   * Default Value : 1000
   */
  rand int unsigned scl_high_time_offset_ss = `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_SS;

  /*
  Defines the low time offset for SCL clock for standard speed mode 
   * This is used to model the fall time of SCL in standard speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   * 
   * For reasonable constraint please refer to #reasonable_scl_low_time_offset_ss 
   *  
   * Default Value : 300
   */ 
   rand int unsigned scl_low_time_offset_ss = `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_SS;

   /*
   Defines the minimum setup time for start for standard speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_sta_time_ss  
   *
   * Default Value : 4700  
   */
  rand int unsigned min_su_sta_time_ss = `KEI_VIP_I2C_MIN_SU_STA_SS;

  /*
  Defines the minimum setup time for stop for standard speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_sto_time_ss  
   * 
   * Default value : 4000 
   */
  rand int unsigned min_su_sto_time_ss = `KEI_VIP_I2C_MIN_SU_STO_SS;

  /** 
   * Defines the minimum setup time for data for standard speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_dat_time_ss  
   */
  rand int unsigned min_su_dat_time_ss = `KEI_VIP_I2C_MIN_SU_DAT_SS;

  /** 
   * Defines the minimum hold time for start for standard speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_hd_sta_time_ss  
   * 
   * Default Value : 4000 
   */
  rand int unsigned min_hd_sta_time_ss = `KEI_VIP_I2C_MIN_HD_STA_SS;
  
  /** 
   * Defines the minimum hold time for data for standard speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_hd_dat_time_ss  
   * 
   * Default Value : 300 
   */
  rand int unsigned min_hd_dat_time_ss = `KEI_VIP_I2C_MIN_HD_DAT_SS;
   
  /** 
   * Defines the maximum hold time for data for standard speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_max_hd_dat_time_ss  
   * 
   * Default Value : 3450 
   */
  rand int unsigned max_hd_dat_time_ss = `KEI_VIP_I2C_MAX_HD_DAT_SS;
  
  /** 
   * Defines the bus free time  for standard speed mode           
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_tbuf_time_ss  
   *
   * Default Value : 4700 
   */
  rand int unsigned tbuf_time_ss = `KEI_VIP_I2C_TBUF_TIME_SS;
  
  /** 
   * Defines the high time of SCL clock for fast speed mode          
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_scl_high_time_fs    
   *
   * Default Value : 600 
   */   
  rand int unsigned scl_high_time_fs = `KEI_VIP_I2C_CLK_HIGH_FS;
  
  /** 
   * Defines the low time of SCL clock for fast speed mode
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_scl_low_time_fs    
   * 
   * Default Value : 1300 
   */   
  rand int unsigned scl_low_time_fs = `KEI_VIP_I2C_CLK_LOW_FS;

  /** 
   * Defines the high time offset for SCL clock for fast speed mode 
   * This is used to model the rise time of SCL in fast speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns  
   * For reasonable constraint please refer to #reasonable_scl_high_time_offset_fs    
   * 
   * Default Value : 300  
   */   
  rand int unsigned scl_high_time_offset_fs = `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FS;
  
  /** 
   * Defines the low time offset for SCL clock for fast speed mode 
   * This is used to model the fall time of SCL in fast speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   * 
   * For reasonable constraint please refer to #reasonable_scl_low_time_offset_fs 
   *  
   * Default Value : 300 
   */
  rand int unsigned scl_low_time_offset_fs = `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FS;
  
  /** 
   * Defines the minimum setup time for start for fast speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_sta_time_fs  
   * 
   * Default Value : 600 
   */
  rand int unsigned min_su_sta_time_fs = `KEI_VIP_I2C_MIN_SU_STA_FS;
  
  /** 
   * Defines the minimum setup time for stop for fast speed mode   
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_sto_time_fs  
   * 
   * Default Value : 600 
   */
  rand int unsigned min_su_sto_time_fs = `KEI_VIP_I2C_MIN_SU_STO_FS;
  
  /** 
   * Defines the minimum setup time for data for fast speed mode    
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_dat_time_fs  
   * 
   * Default Value : 100 
   */
  rand int unsigned min_su_dat_time_fs = `KEI_VIP_I2C_MIN_SU_DAT_FS;
  
  /** 
   * Defines the minimum hold time for start for fast speed mode   
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_hd_sta_time_fs  
   * 
   * Default Value : 600 
   */
  rand int unsigned min_hd_sta_time_fs = `KEI_VIP_I2C_MIN_HD_STA_FS;
  
  /** 
   * Defines the minimum hold time for data for fast speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_hd_dat_time_fs  
   * 
   * Default Value : 300 
   */
  rand int unsigned min_hd_dat_time_fs = `KEI_VIP_I2C_MIN_HD_DAT_FS;
  
  /** 
   * Defines the maximum hold time for data for fast speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_max_hd_dat_time_fs  
   * 
   * Default Value : 900 
   */
  rand int unsigned max_hd_dat_time_fs = `KEI_VIP_I2C_MAX_HD_DAT_FS;
  
  /** 
   * Defines the bus free time for  fast speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_tbuf_time_fs  
   * 
   * Default Value : 1300
   */
  rand int unsigned tbuf_time_fs = `KEI_VIP_I2C_TBUF_TIME_FS;

  /** 
   * Defines the high time of SCL clock for high speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_scl_high_time_hs  
   * 
   * Default Value : 100
   */
  rand int unsigned scl_high_time_hs = `KEI_VIP_I2C_CLK_HIGH_HS;
  
  /** 
   * Defines the low time of SCL clock for high speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_scl_low_time_hs    
   * 
   * Default Value : 200
   */
  rand int unsigned scl_low_time_hs = `KEI_VIP_I2C_CLK_LOW_HS;

  /** 
   * Defines the high time offset for SCL clock for high speed mode 
   * This is used to model the rise time of SCL in high speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns  
   * For reasonable constraint please refer to #reasonable_scl_high_time_offset_hs    
   * 
   * Default Value : 40  
   */   
  rand int unsigned scl_high_time_offset_hs = `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_HS;
  
  /** 
   * Defines the low time offset for SCL clock for high speed mode 
   * This is used to model the fall time of SCL in high speed mode 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   * 
   * For reasonable constraint please refer to #reasonable_scl_low_time_offset_hs 
   *  
   * Default Value : 40 
   */
  rand int unsigned scl_low_time_offset_hs = `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_HS;
  
  /** 
   * Defines the minimum setup time for start for high speed mode   
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_sta_time_hs  
   * 
   * Default Value : 160
   */
  rand int unsigned min_su_sta_time_hs = `KEI_VIP_I2C_MIN_SU_STA_HS;
  
  /** 
   * Defines the minimum setup time for stop for high speed mode   
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_sto_time_hs  
   * 
   * Default Value : 160
   */
  rand int unsigned min_su_sto_time_hs = `KEI_VIP_I2C_MIN_SU_STO_HS;
  
  /** 
   * Defines the minimum setup time for data for high speed mode   
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_dat_time_hs  
   * 
   * Default Value : 10
   */
  rand int unsigned min_su_dat_time_hs = `KEI_VIP_I2C_MIN_SU_DAT_HS;
  
  /** 
   * Defines the minimum hold time for start for high speed mode   
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_hd_sta_time_hs  
   * 
   * Default Value : 160
   */
  rand int unsigned min_hd_sta_time_hs = `KEI_VIP_I2C_MIN_HD_STA_HS;
  
  /** 
   * Defines the minimum hold time for data for high speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_hd_dat_time_hs  
   * 
   * Default Value : 40
   */
  rand int unsigned min_hd_dat_time_hs = `KEI_VIP_I2C_MIN_HD_DAT_HS;
  
  /** 
   * Defines the maximum hold time for data for high speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_max_hd_dat_time_hs  
   * 
   * Default Value : 70
   */
  rand int unsigned max_hd_dat_time_hs = `KEI_VIP_I2C_MAX_HD_DAT_HS;
  
  /** 
   * Defines the bus free time for high speed mode   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_tbuf_time_hs  
   * 
   * Default Value : 1300
   */
  rand int unsigned tbuf_time_hs = `KEI_VIP_I2C_TBUF_TIME_FS;   

  /** 
   * Defines the high time of SCL clock for fast  mode  plus
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_scl_high_time_fm_plus    
   * 
   * Default Value : 260
   */   
  rand int unsigned scl_high_time_fm_plus = `KEI_VIP_I2C_CLK_HIGH_FM_PLUS;
  
  /** 
   * Defines the low time of SCL clock for fast  mode  plus
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_scl_low_time_fm_plus    
   * 
   * Default Value : 500
   */ 
  rand int unsigned scl_low_time_fm_plus = `KEI_VIP_I2C_CLK_LOW_FM_PLUS;

  /** 
   * Defines the high time offset for SCL clock for fast mode plus 
   * This is used to model the rise time of SCL in fast mode plus 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns  
   * For reasonable constraint please refer to #reasonable_scl_high_time_offset_fm_plus    
   * 
   * Default Value : 120  
   */   
  rand int unsigned scl_high_time_offset_fm_plus = `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FM_PLUS;
  
  /** 
   * Defines the low time offset for SCL clock for fast mode plus 
   * This is used to model the fall time of SCL in fast mode plus 
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   * 
   * For reasonable constraint please refer to #reasonable_scl_low_time_offset_fm_plus 
   *  
   * Default Value : 120 
   */
  rand int unsigned scl_low_time_offset_fm_plus = `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FM_PLUS;
  
  /** 
   * Defines the minimum setup time for start for fast mode plus   
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_sta_time_fm_plus  
   * 
   * Default Value : 260
   */
  rand int unsigned min_su_sta_time_fm_plus = `KEI_VIP_I2C_MIN_SU_STA_FM_PLUS;
  
  /** 
   * Defines the minimum setup time for stop for fast mode plus   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_sto_time_fm_plus  
   * 
   * Default Value : 260
   */
  rand int unsigned min_su_sto_time_fm_plus = `KEI_VIP_I2C_MIN_SU_STO_FM_PLUS;
  
  /** 
   * Defines the minimum setup time for data for fast mode plus    
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_su_dat_time_fm_plus  
   * 
   * Default Value : 50
   */
  rand int unsigned min_su_dat_time_fm_plus = `KEI_VIP_I2C_MIN_SU_DAT_FM_PLUS;
  
  /** 
   * Defines the minimum hold time for start for fast mode plus    
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_hd_sta_time_fm_plus  
   * 
   * Default Value : 260
   */
  rand int unsigned min_hd_sta_time_fm_plus = `KEI_VIP_I2C_MIN_HD_STA_FM_PLUS;

  /** 
   * Defines the minimum hold time for data for fast mode plus     
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_min_hd_dat_time_fm_plus  
   * 
   * Default Value : 300
   */
  rand int unsigned min_hd_dat_time_fm_plus = `KEI_VIP_I2C_MIN_HD_DAT_FM_PLUS;

  /** 
   * Defines the maximum hold time for data for fast mode plus     
   * Complies with I2C SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_max_hd_dat_time_fm_plus  
   * 
   * Default Value : 900
   */
  rand int unsigned max_hd_dat_time_fm_plus = `KEI_VIP_I2C_MAX_HD_DAT_FM_PLUS;
  
  /*
   * Defines the bus free time for fast mode plus   
   * Complies with I2C BUS SPECIFICATION. It accepts the value in ns 
   *
   * For reasonable constraint please refer to #reasonable_tbuf_time_fm_plus  
   * 
   * Default Value> : 500
   */
  rand int unsigned tbuf_time_fm_plus = `KEI_VIP_I2C_TBUF_TIME_FM_PLUS;   
  
  /*
   * I2C Bus support multiple masters & slaves on one bus. This variable represents the
   * number/position of the master & slave on the I2C bus.  
   * 
   * Default Value : 0
   */
  bit [31:0] agent_id = 0;
  
  /*
   * Specifies the High speed master code used by masters in High speed mode transfers
   * As per the I2C specification master code is 8 bit (00001XXX) and can have 8 different 
   * values. Only last 3 LSB bits are configurable, rest are fixed by protocol.
   * 
   * Default Value: 3'b000 
   */
  bit [2:0] master_code = 3'b000;
  
  /*
   * Specifies the slave addresses
   * 
   * Default Value: 10'b1100110011 
   */
  bit [9:0] slave_address = `KEI_VIP_I2C_SLAVE0_ADDRESS; 

  /*
   * Specifies the number of slave address ranges.
   * Value of this variable should be greater than 0 to enable
   * a single slave to respond to slave addresses which are in
   * range of slave_address_start & slave_address_end.
   * 
   * Default Value: 0
   */
  int no_of_slave_address_ranges = 0;

  //Specifies the slave start address.
  bit [9:0] slave_address_start[];

   // Specifies the slave end address.
  bit [9:0] slave_address_end[];
  
  /*
   * Specifies whether the slave is a 10 bit addressing. By default Slave is 7 bit addressing.
   * If this bit is enabled, than slave will use 10 bit addressing.
   * 
   * Default Value: 0 
   */
  bit enable_10bit_addr = 0;
  
  /** 
   * Specifies whether slave should respond to general call or not.
   * 
   * Default Value: 1 
   */
  bit enable_response_to_gen_call = 1;
  
  /** 
   * Specifies the type of slave. SVT VIP provide 3 types of slave (1)generic slave,
   * (2)eeprom slave, and (3)CCI slave. Possible values of this configuration are :  
   * - `KEI_VIP_I2C_GENERIC : Generic Slave. This type of slave provides random data
   *   for READ command fired by master.  
   * - `KEI_VIP_I2C_EEPROM  : EEPROM Slave. This type of slave saves data into EEPROM
   *   memory, which can be read back from that location. The first two
   *   data byte that will be received by the slave will be loaded into the
   *   EEPROM memory location pointer which becomes the starting address of
   *   EEPROM memory. 
   * - `KEI_VIP_I2C_CCI     : CCI Slave. This type of slave follows frame format
   *   according to the CCI protocol.  
   * .
   * Default Value: `KEI_VIP_I2C_GENERIC 
   */
  int slave_type = `KEI_VIP_I2C_GENERIC;

  /** 
   * Determines if put_response feature in driver is enabled/disabled.
   * 
   * Default Value: 1 
   */
  bit enable_put_response = 1;

  /** 
   * Determines whether 8-bit or 16-bit indexing is used for EEPROM slave.
   * 
   * Default Value: 0 
   */
  bit enable_cci_8bit = 0;

  /** 
   * Determines whether 32-bit indexing is used for EEPROM slave.
   * 
   * Default Value: 0 
   */
  bit enable_eeprom_32bit = 0;

  /** 
   * Determines whether event pool in driver is enabled/disabled.
   * 
   * Default Value: 1 
   */
  bit enable_driver_events = 1;

   /** 
    * Determines whether to pullup the SCL & SDA from Master & Slave.
    * When the value is 1 then SCL & SDA will be pulled up to '1'.
    * Possible values are as follows :
    *
    * - 0 : SCL/SDA will not be pulled up
    * - 1 : SCL/SDA will be pulled up to value '1'
    * .
    * Default Value: 1 
    */
   bit enable_pullup_resistor = `KEI_VIP_I2C_DEFAULT_PULLUP_RESISTOR;

   /** 
    * Determines whether HIGHSPEED mode will start in FM speed 
    * or FM_PLUS speed.
    * Possible values are as follows :
    *
    * - 0 : HIGHSPEED mode will start in FM speed
    * - 1 : HIGHSPEED mode will start in FM_PLUS speed
    * .
    * Default Value: 0 
    */
   bit start_hs_in_fm_plus = 1'b0;

   /** 
    * Determines whether BUS CLEAR on SDA feature is 
    * enabled or not (I2C v3.0).
    * Possible values are as follows :
    *
    * - 0 : Bus Clear on SDA feature is disabled
    * - 1 : Bus Clear on SDA feature is enabled
    * .
    * Default Value: 0 
    */
   bit enable_bus_clear_sda = 1'b0;

   /** 
    * Determines whether SCL has to be disabled when  
    * SDA is stuck LOW.
    * Possible values are as follows :
    *
    * - 0 : SCL is not disabled
    * - 1 : SCL is disabled
    * .
    * Default Value: 0 
    */
   bit enable_bus_clear_scl_off = 1'b0;
   
   /** 
    * Specifies number of SCL posedges after which  
    * SDA is held LOW.
    *
    * Default Value: 15 
    */
   int clock_count_bus_clear_sda_low = `KEI_VIP_I2C_BUS_CLEAR_CLK_COUNT_SDA_LOW;

   /** 
    * Specifies number of SCL posedges after which  
    * SDA is released after it was stuck.
    * 
    * Default Value: 3 
    */
   int clock_count_for_sda_bus_clear = `KEI_VIP_I2C_BUS_CLEAR_CLK_COUNT_FOR_SDA;

   /** 
    * Specifies delay as per set timescale for which SDA  
    * will be held LOW to declare SDA-stuck condition.
    * 
    * Default Value: 20000 
    */
   int bus_clear_sda_timeout = `KEI_VIP_I2C_BUS_CLEAR_SDA_TIMEOUT;

   /** 
    * Determines whether GLITCH INSERTION feature is 
    * enabled or not for SDA.
    * Possible values are as follows :
    *
    * - 0 : Glitch Insertion feature for SDA is disabled
    * - 1 : Glitch Insertion feature for SDA is enabled
    * .
    * Default Value: 0 
    */
   bit enable_glitch_insert_sda = 1'b0;

   /** 
    * Specifies glitch size in terms of number of reference  
    * clock cycles for SDA.
    * 
    * Default Value: 1 
    */
   int glitch_size_sda = `KEI_VIP_I2C_GLITCH_SIZE_SDA;

   /** 
    * Determines whether GLITCH INSERTION feature is 
    * enabled or not for SCL.
    * Possible values are as follows :
    *
    * - 0 : Glitch Insertion feature for SCL is disabled
    * - 1 : Glitch Insertion feature for SCL is enabled
    * .
    * Default Value: 0 
    */
   bit enable_glitch_insert_scl = 1'b0;

   /** 
    * Specifies glitch size in terms of number of reference  
    * clock cycles for SCL.
    * 
    * Default Value: 1 
    */
   int glitch_size_scl = `KEI_VIP_I2C_GLITCH_SIZE_SCL;

   /** 
    * Specifies value w.r.t. 1ns, which will become the 
    * multiplication factor for all the timing macros.
    * 
    * Default Value: 1 
    */
   real timescale_factor = 1;

   /**
    * Specifies the Device ID of the slave.
    */
   rand bit [23:0] device_id = 24'b0;

   /**
    * Time out value for detecting resert. If clock and data are held low for this time, the device detects it as reset
	*/
   rand bit [63:0] t_reset_detect_time ;   

   /**
    * Enable bit for tlow min timeout check for 100khz
    */
   bit enable_tlow_100khz_check = 0;

   /**
    * Enable bit for tlow min timeout check for 400khz
    */
   bit enable_tlow_400khz_check = 0;

   /**
    * Enable bit for tlow min timeout check for 1mhz
    */
   bit enable_tlow_1mhz_check = 0;

   kei_vip_i2c_vif i2c_if;
   
   /**
    * CONSTRUCTOR : Create a new configuration instance, passing the appropriate argument
    * values to the parent class.
    *
    * @param name Instance name of the configuration
    */
   extern function new (string name = "kei_vip_i2c_configuration");
   
   // **********************************************************************************************
   //   SVT shorthand macros 
   // **********************************************************************************************
   `uvm_object_utils_begin(kei_vip_i2c_configuration)
   `uvm_field_enum(bus_speed_enum, bus_speed    , UVM_ALL_ON)
   `uvm_field_enum(bus_type_enum, bus_type      , UVM_ALL_ON)
   `uvm_field_int (scl_high_time_ss             , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_low_time_ss              , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_high_time_offset_ss      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_low_time_offset_ss       , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_sta_time_ss           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_sto_time_ss           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_dat_time_ss           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_hd_sta_time_ss           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_hd_dat_time_ss           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (max_hd_dat_time_ss           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (tbuf_time_ss                 , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_high_time_fs             , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_low_time_fs              , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_high_time_offset_fs      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_low_time_offset_fs       , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_sta_time_fs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_sto_time_fs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_dat_time_fs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_hd_sta_time_fs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_hd_dat_time_fs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (max_hd_dat_time_fs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (tbuf_time_fs                 , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_high_time_hs             , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_low_time_hs              , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_high_time_offset_hs      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_low_time_offset_hs       , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_sta_time_hs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_sto_time_hs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_dat_time_hs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_hd_sta_time_hs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_hd_dat_time_hs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (max_hd_dat_time_hs           , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (tbuf_time_hs                 , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_high_time_fm_plus        , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_low_time_fm_plus         , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_high_time_offset_fm_plus , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (scl_low_time_offset_fm_plus  , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_sta_time_fm_plus      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_sto_time_fm_plus      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_su_dat_time_fm_plus      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_hd_sta_time_fm_plus      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (min_hd_dat_time_fm_plus      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (max_hd_dat_time_fm_plus      , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (tbuf_time_fm_plus            , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (agent_id                     , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (master_code                  , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (slave_address                , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (enable_10bit_addr            , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (enable_response_to_gen_call  , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (slave_type                   , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (enable_put_response          , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (enable_cci_8bit              , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (enable_eeprom_32bit          , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (enable_driver_events         , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (enable_pullup_resistor       , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (start_hs_in_fm_plus          , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (enable_bus_clear_sda         , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (enable_bus_clear_scl_off     , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (clock_count_bus_clear_sda_low, UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (clock_count_for_sda_bus_clear, UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (bus_clear_sda_timeout        , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (enable_glitch_insert_sda     , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (glitch_size_sda              , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (enable_glitch_insert_scl     , UVM_ALL_ON|UVM_BIN)
   `uvm_field_int (glitch_size_scl              , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int (no_of_slave_address_ranges   , UVM_ALL_ON|UVM_DEC)
   `uvm_field_array_int(slave_address_start     , UVM_ALL_ON|UVM_BIN)
   `uvm_field_array_int(slave_address_end       , UVM_ALL_ON|UVM_BIN)
   `uvm_field_real(timescale_factor             , UVM_ALL_ON|UVM_DEC)
   `uvm_field_int(device_id                     , UVM_ALL_ON|UVM_BIN|UVM_NOCOMPARE)
   `uvm_field_int(t_reset_detect_time           , UVM_ALL_ON|UVM_BIN|UVM_NOCOMPARE)
   `uvm_field_int(enable_tlow_1mhz_check               , UVM_ALL_ON|UVM_BIN|UVM_NOCOMPARE)
   `uvm_field_int(enable_tlow_400khz_check             , UVM_ALL_ON|UVM_BIN|UVM_NOCOMPARE)
   `uvm_field_int(enable_tlow_100khz_check             , UVM_ALL_ON|UVM_BIN|UVM_NOCOMPARE)
   `uvm_field_string(inst, UVM_ALL_ON)
   `uvm_object_utils_end
   // **********************************************************************************************
   //   Constraints
   // **********************************************************************************************
   
   /** 
    * Constraint for valid_ranges 
    * valid_ranges constraints prevent illegal and/or not supported values by the Protocol & VIP.
    * These should ONLY be disabled if the parameters covered by them are turned off. 
    * If these are turned off without the constraints being turned off it can lead to problems 
    * during randomization. </br>
    * In situations involving extended classes, issues with name conflicts can arise. 
    * If the extended (e.g., cust_svt_i2c_master_transaction) and base 
    * (e.g., svt_i2c_master_transaction) classes both use the same ‘valid_ranges’ constraint 
    * name, then the ‘valid_ranges’ constraint in the extended class 
    * (e.g., cust_svt_i2c_master_transaction), will override the ‘valid_ranges’ constraint 
    * in the base class (e.g., svt_i2c_msater_transaction). Because the valid_ranges constraints 
    * must be retained most of the time, classes extensions should prefix the name of the 
    * constraint block to ensure uniqueness, e.g. “cust_valid_ranges”.
    */
   constraint valid_ranges {
      scl_high_time_ss             inside {[`KEI_VIP_I2C_CLK_HIGH_SS                : `KEI_VIP_I2C_MAX_CLK_HIGH_SS              ]};
      scl_low_time_ss              inside {[`KEI_VIP_I2C_CLK_LOW_SS                 : `KEI_VIP_I2C_MAX_CLK_LOW_SS               ]};
      scl_high_time_offset_ss      inside {[`KEI_VIP_I2C_MIN_CLK_HIGH_OFFSET_SS     : `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_SS       ]};
      scl_low_time_offset_ss       inside {[`KEI_VIP_I2C_MIN_CLK_LOW_OFFSET_SS      : `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_SS        ]};
      min_su_sta_time_ss           inside {[`KEI_VIP_I2C_MIN_SU_STA_SS              : `KEI_VIP_I2C_MAX_SU_STA_SS                ]};
      min_su_sto_time_ss           inside {[`KEI_VIP_I2C_MIN_SU_STO_SS              : `KEI_VIP_I2C_MAX_SU_STO_SS                ]};
      min_su_dat_time_ss           inside {[`KEI_VIP_I2C_MIN_SU_DAT_SS              : `KEI_VIP_I2C_MAX_SU_DAT_SS                ]};
      min_hd_sta_time_ss           inside {[`KEI_VIP_I2C_MIN_HD_STA_SS              : `KEI_VIP_I2C_MAX_HD_STA_SS                ]};
      min_hd_dat_time_ss           inside {[`KEI_VIP_I2C_MIN_HD_DAT_SS              : `KEI_VIP_I2C_MIN_HD_DAT_MAX_SS            ]};
      min_hd_dat_time_ss           <= max_hd_dat_time_ss;
      max_hd_dat_time_ss           inside {[`KEI_VIP_I2C_MAX_HD_DAT_MIN_SS          : `KEI_VIP_I2C_MAX_HD_DAT_SS                ]};
      tbuf_time_ss                 inside {[`KEI_VIP_I2C_TBUF_TIME_SS               : `KEI_VIP_I2C_MAX_TBUF_TIME_SS             ]};
      scl_high_time_fs             inside {[`KEI_VIP_I2C_CLK_HIGH_FS                : `KEI_VIP_I2C_MAX_CLK_HIGH_FS              ]};
      scl_low_time_fs              inside {[`KEI_VIP_I2C_CLK_LOW_FS                 : `KEI_VIP_I2C_MAX_CLK_LOW_FS               ]};
      scl_high_time_offset_fs      inside {[`KEI_VIP_I2C_MIN_CLK_HIGH_OFFSET_FS     : `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FS       ]};
      scl_low_time_offset_fs       inside {[`KEI_VIP_I2C_MIN_CLK_LOW_OFFSET_FS      : `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FS        ]};
      min_su_sta_time_fs           inside {[`KEI_VIP_I2C_MIN_SU_STA_FS              : `KEI_VIP_I2C_MAX_SU_STA_FS                ]};
      min_su_sto_time_fs           inside {[`KEI_VIP_I2C_MIN_SU_STO_FS              : `KEI_VIP_I2C_MAX_SU_STO_FS                ]};
      min_su_dat_time_fs           inside {[`KEI_VIP_I2C_MIN_SU_DAT_FS              : `KEI_VIP_I2C_MAX_SU_DAT_FS                ]};
      min_hd_sta_time_fs           inside {[`KEI_VIP_I2C_MIN_HD_STA_FS              : `KEI_VIP_I2C_MAX_HD_STA_FS                ]};
      min_hd_dat_time_fs           inside {[`KEI_VIP_I2C_MIN_HD_DAT_FS              : `KEI_VIP_I2C_MIN_HD_DAT_MAX_FS            ]};
      max_hd_dat_time_fs           inside {[`KEI_VIP_I2C_MAX_HD_DAT_MIN_FS          : `KEI_VIP_I2C_MAX_HD_DAT_FS                ]};
      min_hd_dat_time_fs           <= max_hd_dat_time_fs;
      tbuf_time_fs                 inside {[`KEI_VIP_I2C_TBUF_TIME_FS               : `KEI_VIP_I2C_MAX_TBUF_TIME_FS             ]}; 
      scl_high_time_hs             inside {[`KEI_VIP_I2C_CLK_HIGH_HS                : `KEI_VIP_I2C_MAX_CLK_HIGH_HS              ]}; 
      scl_low_time_hs              inside {[`KEI_VIP_I2C_CLK_LOW_HS                 : `KEI_VIP_I2C_MAX_CLK_LOW_HS               ]}; 
      scl_high_time_offset_hs      inside {[`KEI_VIP_I2C_MIN_CLK_HIGH_OFFSET_HS     : `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_HS       ]};
      scl_low_time_offset_hs       inside {[`KEI_VIP_I2C_MIN_CLK_LOW_OFFSET_HS      : `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_HS        ]};
      min_su_sta_time_hs           inside {[`KEI_VIP_I2C_MIN_SU_STA_HS              : `KEI_VIP_I2C_MAX_SU_STA_HS                ]}; 
      min_su_sto_time_hs           inside {[`KEI_VIP_I2C_MIN_SU_STO_HS              : `KEI_VIP_I2C_MAX_SU_STO_HS                ]}; 
      min_su_dat_time_hs           inside {[`KEI_VIP_I2C_MIN_SU_DAT_HS              : `KEI_VIP_I2C_MAX_SU_DAT_HS                ]}; 
      min_hd_sta_time_hs           inside {[`KEI_VIP_I2C_MIN_HD_STA_HS              : `KEI_VIP_I2C_MAX_HD_STA_HS                ]}; 
      min_hd_dat_time_hs           inside {[`KEI_VIP_I2C_MIN_HD_DAT_HS              : `KEI_VIP_I2C_MIN_HD_DAT_MAX_HS            ]}; 
      max_hd_dat_time_hs           inside {[`KEI_VIP_I2C_MAX_HD_DAT_MIN_HS          : `KEI_VIP_I2C_MAX_HD_DAT_HS                ]}; 
      min_hd_dat_time_hs           <= max_hd_dat_time_hs;
      tbuf_time_hs                 inside {[`KEI_VIP_I2C_TBUF_TIME_FS               : `KEI_VIP_I2C_MAX_TBUF_TIME_FS             ]};
      scl_high_time_fm_plus        inside {[`KEI_VIP_I2C_CLK_HIGH_FM_PLUS           : `KEI_VIP_I2C_MAX_CLK_HIGH_FM_PLUS         ]};
      scl_low_time_fm_plus         inside {[`KEI_VIP_I2C_CLK_LOW_FM_PLUS            : `KEI_VIP_I2C_MAX_CLK_LOW_FM_PLUS          ]};
      scl_high_time_offset_fm_plus inside {[`KEI_VIP_I2C_MIN_CLK_HIGH_OFFSET_FM_PLUS: `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FM_PLUS  ]};
      scl_low_time_offset_fm_plus  inside {[`KEI_VIP_I2C_MIN_CLK_LOW_OFFSET_FM_PLUS : `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FM_PLUS   ]};
      min_su_sta_time_fm_plus      inside {[`KEI_VIP_I2C_MIN_SU_STA_FM_PLUS         : `KEI_VIP_I2C_MAX_SU_STA_FM_PLUS           ]};
      min_su_sto_time_fm_plus      inside {[`KEI_VIP_I2C_MIN_SU_STO_FM_PLUS         : `KEI_VIP_I2C_MAX_SU_STO_FM_PLUS           ]};
      min_su_dat_time_fm_plus      inside {[`KEI_VIP_I2C_MIN_SU_DAT_FM_PLUS         : `KEI_VIP_I2C_MAX_SU_DAT_FM_PLUS           ]};
      min_hd_sta_time_fm_plus      inside {[`KEI_VIP_I2C_MIN_HD_STA_FM_PLUS         : `KEI_VIP_I2C_MAX_HD_STA_FM_PLUS           ]};
      min_hd_dat_time_fm_plus      inside {[`KEI_VIP_I2C_MIN_HD_DAT_FM_PLUS         : `KEI_VIP_I2C_MIN_HD_DAT_FM_MAX_PLUS       ]};
      max_hd_dat_time_fm_plus      inside {[`KEI_VIP_I2C_MAX_HD_DAT_FM_MIN_PLUS     : `KEI_VIP_I2C_MAX_HD_DAT_FM_PLUS           ]};
      min_hd_dat_time_fm_plus      <= max_hd_dat_time_fm_plus;
      tbuf_time_fm_plus            inside {[`KEI_VIP_I2C_TBUF_TIME_FM_PLUS          : `KEI_VIP_I2C_MAX_TBUF_TIME_FM_PLUS        ]};
   }

   /** 
    * Reasonable constraint for #scl_high_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_scl_high_time_ss { 
      scl_high_time_ss == `KEI_VIP_I2C_CLK_HIGH_SS;
   }

   /** 
    * Reasonable constraint for #scl_low_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_scl_low_time_ss { 
      scl_low_time_ss == `KEI_VIP_I2C_CLK_LOW_SS;
   }

   /** 
    * Reasonable constraint for #scl_high_time_offset_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_scl_high_time_offset_ss { 
      scl_high_time_offset_ss == `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_SS;
   }

   /** 
    * Reasonable constraint for #scl_low_time_offset_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_scl_low_time_offset_ss { 
      scl_low_time_offset_ss == `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_SS;
   }
   
   /** 
    * Reasonable constraint for #min_su_sta_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_min_su_sta_time_ss { 
      min_su_sta_time_ss == `KEI_VIP_I2C_MIN_SU_STA_SS;
   }

   /** 
    * Reasonable constraint for #min_su_sto_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_min_su_sto_time_ss { 
      min_su_sto_time_ss == `KEI_VIP_I2C_MIN_SU_STO_SS;
   }

   /** 
    * Reasonable constraint for #min_su_dat_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_min_su_dat_time_ss { 
      min_su_dat_time_ss == `KEI_VIP_I2C_MIN_SU_DAT_SS;
   }

   /** 
    * Reasonable constraint for #min_hd_sta_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_min_hd_sta_time_ss { 
      min_hd_sta_time_ss == `KEI_VIP_I2C_MIN_HD_STA_SS;
   }

   /** 
    * Reasonable constraint for #min_hd_dat_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_min_hd_dat_time_ss { 
      min_hd_dat_time_ss == `KEI_VIP_I2C_MIN_HD_DAT_SS;
   }

   /** 
    * Reasonable constraint for #max_hd_dat_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_max_hd_dat_time_ss { 
      max_hd_dat_time_ss == `KEI_VIP_I2C_MAX_HD_DAT_SS;
   }

   /** 
    * Reasonable constraint for #tbuf_time_ss 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_tbuf_time_ss { 
      tbuf_time_ss == `KEI_VIP_I2C_TBUF_TIME_SS;
   }

   /**
    * Reasonable constraint for #scl_high_time_fs 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_scl_high_time_fs { 
      scl_high_time_fs == `KEI_VIP_I2C_CLK_HIGH_FS;
   }
   
   /** 
    * Reasonable constraint for #scl_low_time_fs 
    *
    * This constraint is ON by default; reasonable constraints can be enabled/disabled
    * as a block via the #reasonable_constraint_mode method.
    */
   constraint reasonable_scl_low_time_fs { 
      scl_low_time_fs == `KEI_VIP_I2C_CLK_LOW_FS;
   }

   /** 
    * Reasonable constraint for #scl_high_time_offset_fs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_high_time_offset_fs { 
    scl_high_time_offset_fs == `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FS;
  }

  /** 
   * Reasonable constraint for #scl_low_time_offset_fs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_low_time_offset_fs { 
    scl_low_time_offset_fs == `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FS;
  }

  /** 
   * Reasonable constraint for #min_su_sta_time_fs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_sta_time_fs { 
    min_su_sta_time_fs == `KEI_VIP_I2C_MIN_SU_STA_FS;
  }

  /** 
   * Reasonable constraint for #min_su_sto_time_fs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_sto_time_fs { 
    min_su_sto_time_fs == `KEI_VIP_I2C_MIN_SU_STO_FS;
  }

  /** 
   * Reasonable constraint for #min_su_dat_time_fs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_dat_time_fs { 
    min_su_dat_time_fs == `KEI_VIP_I2C_MIN_SU_DAT_FS;
  }

  /** 
   * Reasonable constraint for #min_hd_sta_time_fs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_hd_sta_time_fs { 
    min_hd_sta_time_fs == `KEI_VIP_I2C_MIN_HD_STA_FS;
  }

  /** 
   * Reasonable constraint for #min_hd_dat_time_fs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_hd_dat_time_fs { 
    min_hd_dat_time_fs == `KEI_VIP_I2C_MIN_HD_DAT_FS;
  }

  /** 
   * Reasonable constraint for #max_hd_dat_time_fs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_max_hd_dat_time_fs { 
    max_hd_dat_time_fs == `KEI_VIP_I2C_MAX_HD_DAT_FS;
  }

  /**
   * Reasonable constraint for #tbuf_time_fs 
   * 
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_tbuf_time_fs { 
    tbuf_time_fs == `KEI_VIP_I2C_TBUF_TIME_FS;
  }

  /** 
   * Reasonable constraint for #scl_high_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_high_time_hs { 
    scl_high_time_hs == `KEI_VIP_I2C_CLK_HIGH_HS;
  }

  /** 
   * Reasonable constraint for #scl_low_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_low_time_hs { 
    scl_low_time_hs == `KEI_VIP_I2C_CLK_LOW_HS;
  }

  /** 
   * Reasonable constraint for #scl_high_time_offset_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_high_time_offset_hs { 
    scl_high_time_offset_hs == `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_HS;
  }

  /** 
   * Reasonable constraint for #scl_low_time_offset_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_low_time_offset_hs { 
    scl_low_time_offset_hs == `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_HS;
  }

  /** 
   * Reasonable constraint for #min_su_sta_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_sta_time_hs { 
    min_su_sta_time_hs == `KEI_VIP_I2C_MIN_SU_STA_HS;
  }
    
  /**
   * Reasonable constraint for #min_su_sto_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_sto_time_hs { 
    min_su_sto_time_hs == `KEI_VIP_I2C_MIN_SU_STO_HS;
  }

  /** 
   * Reasonable constraint for #min_su_dat_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_dat_time_hs { 
    min_su_dat_time_hs == `KEI_VIP_I2C_MIN_SU_DAT_HS;
  }

  /** 
   * Reasonable constraint for #min_hd_sta_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_hd_sta_time_hs { 
    min_hd_sta_time_hs == `KEI_VIP_I2C_MIN_HD_STA_HS;
  }

  /** 
   * Reasonable constraint for #min_hd_dat_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_hd_dat_time_hs { 
    min_hd_dat_time_hs == `KEI_VIP_I2C_MIN_HD_DAT_HS;
  }

  /** 
   * Reasonable constraint for #max_hd_dat_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_max_hd_dat_time_hs { 
    max_hd_dat_time_hs == `KEI_VIP_I2C_MAX_HD_DAT_HS;
  }

  /** 
   * Reasonable constraint for #tbuf_time_hs 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_tbuf_time_hs { 
    tbuf_time_hs == `KEI_VIP_I2C_TBUF_TIME_FS;
  }

  /** 
   * Reasonable constraint for #scl_high_time_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_high_time_fm_plus { 
    scl_high_time_fm_plus == `KEI_VIP_I2C_CLK_HIGH_FM_PLUS;
  }

  /** 
   * Reasonable constraint for #scl_low_time_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_low_time_fm_plus { 
    scl_low_time_fm_plus == `KEI_VIP_I2C_CLK_LOW_FM_PLUS;
  }

  /** 
   * Reasonable constraint for #scl_high_time_offset_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_high_time_offset_fm_plus { 
    scl_high_time_offset_fm_plus == `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FM_PLUS;
  }

  /** 
   * Reasonable constraint for #scl_low_time_offset_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_scl_low_time_offset_fm_plus { 
    scl_low_time_offset_fm_plus == `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FM_PLUS;
  }

  /** 
   * Reasonable constraint for #min_su_sta_time_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_sta_time_fm_plus { 
    min_su_sta_time_fm_plus == `KEI_VIP_I2C_MIN_SU_STA_FM_PLUS;
  }

  /**
   * Reasonable constraint for #min_su_sto_time_fm_plus  
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_sto_time_fm_plus { 
    min_su_sto_time_fm_plus == `KEI_VIP_I2C_MIN_SU_STO_FM_PLUS;
  }

  /** 
   * Reasonable constraint for #min_su_dat_time_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_su_dat_time_fm_plus { 
    min_su_dat_time_fm_plus == `KEI_VIP_I2C_MIN_SU_DAT_FM_PLUS;
  }

  /** 
   * Reasonable constraint for #min_hd_sta_time_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_hd_sta_time_fm_plus { 
    min_hd_sta_time_fm_plus == `KEI_VIP_I2C_MIN_HD_STA_FM_PLUS;
  }

  /** 
   * Reasonable constraint for #min_hd_dat_time_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_min_hd_dat_time_fm_plus { 
    min_hd_dat_time_fm_plus == `KEI_VIP_I2C_MIN_HD_DAT_FM_PLUS;
  }

  /**
   *  Reasonable constraint for #max_hd_dat_time_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_max_hd_dat_time_fm_plus { 
    max_hd_dat_time_fm_plus == `KEI_VIP_I2C_MAX_HD_DAT_FM_PLUS;
  }

  /** 
   * Reasonable constraint for #tbuf_time_fm_plus 
   *
   * This constraint is ON by default; reasonable constraints can be enabled/disabled
   * as a block via the #reasonable_constraint_mode method.
   */
  constraint reasonable_tbuf_time_fm_plus { 
    tbuf_time_fm_plus == `KEI_VIP_I2C_TBUF_TIME_FM_PLUS;
  }

  constraint reasonable_device_id {
    device_id inside {[0:0]};
  }  

  //Method to turn reasonable constraints on/off as a block.
  extern virtual function int reasonable_constraint_mode (bit on_off);
   
  // Extend the copy routine to copy the virtual interface
  extern virtual function void do_copy(uvm_object rhs);
   
  //Method to turn static config param randomization on/off as a block.
  extern virtual function int static_rand_mode(bit on_off);
  
  //Does a basic validation of this transaction object   
  extern virtual function bit is_valid (bit silent =1);

  //Assigns a interface to this configuration.
  extern function void set_i2c_if(kei_vip_i2c_vif i2c_if);

  // Set number of slave address regions to be defined.
  extern function void set_slave_address_ranges_num(int no_of_slave_address_ranges);
  
   //Set slave start and end address for a slave address region.
  extern function void set_slave_address(int index, bit[`KEI_VIP_I2C_SLA_ADD_WIDTH-1:0] addr_start, bit[`KEI_VIP_I2C_SLA_ADD_WIDTH-1:0] addr_end);

  //Check if passed slave address is valid.
  extern function bit is_valid_slave_address(bit[`KEI_VIP_I2C_SLA_ADD_WIDTH-1:0] addr);
  
  //Initialise all timing variables.
  extern function void timing_vars();

endclass

function kei_vip_i2c_configuration::new(string name = "kei_vip_i2c_configuration");
    super.new(name);
endfunction : new

function int kei_vip_i2c_configuration::static_rand_mode(bit on_off);

    scl_high_time_ss.rand_mode(on_off);
    scl_low_time_ss.rand_mode(on_off);
    scl_high_time_offset_ss.rand_mode(on_off);
    scl_low_time_offset_ss.rand_mode(on_off);
    min_su_sta_time_ss.rand_mode(on_off);
    min_su_sto_time_ss.rand_mode(on_off);
    min_su_dat_time_ss.rand_mode(on_off);
    min_hd_sta_time_ss.rand_mode(on_off);
    min_hd_dat_time_ss.rand_mode(on_off);
    max_hd_dat_time_ss.rand_mode(on_off);
    tbuf_time_ss.rand_mode(on_off);
    
    scl_high_time_fs.rand_mode(on_off);
    scl_low_time_fs.rand_mode(on_off);
    scl_high_time_offset_fs.rand_mode(on_off);
    scl_low_time_offset_fs.rand_mode(on_off);
    min_su_sta_time_fs.rand_mode(on_off);
    min_su_sto_time_fs.rand_mode(on_off);
    min_su_dat_time_fs.rand_mode(on_off);
    min_hd_sta_time_fs.rand_mode(on_off);
    min_hd_dat_time_fs.rand_mode(on_off);
    max_hd_dat_time_fs.rand_mode(on_off);
    tbuf_time_fs.rand_mode(on_off);

    scl_high_time_hs.rand_mode(on_off);
    scl_low_time_hs.rand_mode(on_off);
    scl_high_time_offset_hs.rand_mode(on_off);
    scl_low_time_offset_hs.rand_mode(on_off);
    min_su_sta_time_hs.rand_mode(on_off);
    min_su_sto_time_hs.rand_mode(on_off);
    min_su_dat_time_hs.rand_mode(on_off);
    min_hd_sta_time_hs.rand_mode(on_off);
    min_hd_dat_time_hs.rand_mode(on_off);
    max_hd_dat_time_hs.rand_mode(on_off);
    tbuf_time_hs.rand_mode(on_off);

    scl_high_time_fm_plus.rand_mode(on_off);
    scl_low_time_fm_plus.rand_mode(on_off);
    scl_high_time_offset_fm_plus.rand_mode(on_off);
    scl_low_time_offset_fm_plus.rand_mode(on_off);
    min_su_sta_time_fm_plus.rand_mode(on_off);
    min_su_sto_time_fm_plus.rand_mode(on_off);
    min_su_dat_time_fm_plus.rand_mode(on_off);
    min_hd_sta_time_fm_plus.rand_mode(on_off);
    min_hd_dat_time_fm_plus.rand_mode(on_off);
    max_hd_dat_time_fm_plus.rand_mode(on_off);
    tbuf_time_fm_plus.rand_mode(on_off);

    device_id.rand_mode(on_off);
  return on_off;
endfunction: static_rand_mode

function int kei_vip_i2c_configuration::reasonable_constraint_mode(bit on_off);
    
    reasonable_scl_high_time_ss.constraint_mode(on_off);
    reasonable_scl_low_time_ss.constraint_mode(on_off);
    reasonable_scl_high_time_offset_ss.constraint_mode(on_off);
    reasonable_scl_low_time_offset_ss.constraint_mode(on_off);
    reasonable_min_su_sta_time_ss.constraint_mode(on_off);
    reasonable_min_su_sto_time_ss.constraint_mode(on_off);
    reasonable_min_su_dat_time_ss.constraint_mode(on_off);
    reasonable_min_hd_sta_time_ss.constraint_mode(on_off);
    reasonable_min_hd_dat_time_ss.constraint_mode(on_off);
    reasonable_max_hd_dat_time_ss.constraint_mode(on_off);
    reasonable_tbuf_time_ss.constraint_mode(on_off);
    
    reasonable_scl_high_time_fs.constraint_mode(on_off);
    reasonable_scl_low_time_fs.constraint_mode(on_off);
    reasonable_scl_high_time_offset_fs.constraint_mode(on_off);
    reasonable_scl_low_time_offset_fs.constraint_mode(on_off);
    reasonable_min_su_sta_time_fs.constraint_mode(on_off);
    reasonable_min_su_sto_time_fs.constraint_mode(on_off);
    reasonable_min_su_dat_time_fs.constraint_mode(on_off);
    reasonable_min_hd_sta_time_fs.constraint_mode(on_off);
    reasonable_min_hd_dat_time_fs.constraint_mode(on_off);
    reasonable_max_hd_dat_time_fs.constraint_mode(on_off);
    reasonable_tbuf_time_fs.constraint_mode(on_off);

    reasonable_scl_high_time_hs.constraint_mode(on_off);
    reasonable_scl_low_time_hs.constraint_mode(on_off);
    reasonable_scl_high_time_offset_hs.constraint_mode(on_off);
    reasonable_scl_low_time_offset_hs.constraint_mode(on_off);
    reasonable_min_su_sta_time_hs.constraint_mode(on_off);
    reasonable_min_su_sto_time_hs.constraint_mode(on_off);
    reasonable_min_su_dat_time_hs.constraint_mode(on_off);
    reasonable_min_hd_sta_time_hs.constraint_mode(on_off);
    reasonable_min_hd_dat_time_hs.constraint_mode(on_off);
    reasonable_max_hd_dat_time_hs.constraint_mode(on_off);
    reasonable_tbuf_time_hs.constraint_mode(on_off);

    reasonable_scl_high_time_fm_plus.constraint_mode(on_off);
    reasonable_scl_low_time_fm_plus.constraint_mode(on_off);
    reasonable_scl_high_time_offset_fm_plus.constraint_mode(on_off);
    reasonable_scl_low_time_offset_fm_plus.constraint_mode(on_off);
    reasonable_min_su_sta_time_fm_plus.constraint_mode(on_off);
    reasonable_min_su_sto_time_fm_plus.constraint_mode(on_off);
    reasonable_min_su_dat_time_fm_plus.constraint_mode(on_off);
    reasonable_min_hd_sta_time_fm_plus.constraint_mode(on_off);
    reasonable_min_hd_dat_time_fm_plus.constraint_mode(on_off);
    reasonable_max_hd_dat_time_fm_plus.constraint_mode(on_off);
    reasonable_tbuf_time_fm_plus.constraint_mode(on_off);

    reasonable_device_id.constraint_mode(on_off);
    return on_off;
endfunction : reasonable_constraint_mode

function void kei_vip_i2c_configuration::do_copy(uvm_object rhs);
    kei_vip_i2c_configuration rhs_;
    super.do_copy(rhs);
    $cast(rhs_,rhs);
    i2c_if = rhs_.i2c_if;
endfunction : do_copy

function void kei_vip_i2c_configuration::set_i2c_if(kei_vip_i2c_vif i2c_if);
  this.i2c_if = i2c_if;
endfunction : set_i2c_if

function void kei_vip_i2c_configuration::set_slave_address_ranges_num(int no_of_slave_address_ranges);
  this.no_of_slave_address_ranges = no_of_slave_address_ranges;
  slave_address_start = new[no_of_slave_address_ranges](slave_address_start);
  slave_address_end = new[no_of_slave_address_ranges](slave_address_end);
endfunction : set_slave_address_ranges_num

function void kei_vip_i2c_configuration::set_slave_address(int index, bit[`KEI_VIP_I2C_SLA_ADD_WIDTH-1:0] addr_start, bit[`KEI_VIP_I2C_SLA_ADD_WIDTH-1:0] addr_end);
    this.slave_address_start[index] = addr_start;
    this.slave_address_end[index] = addr_end;
endfunction : set_slave_address

function bit kei_vip_i2c_configuration::is_valid_slave_address(bit[`KEI_VIP_I2C_SLA_ADD_WIDTH-1:0] addr);
  if(this.no_of_slave_address_ranges>0) begin
    for(int i=0;i<no_of_slave_address_ranges;i++) begin
      if(enable_10bit_addr) begin
        if(slave_address_start[i][9:0] == slave_address_end[i][9:0])
          return (addr[9:0] == this.slave_address_start[i][9:0]);
        if(addr[9:0] >= slave_address_start[i][9:0] && addr[9:0] <= slave_address_end[i][9:0])
          return 1;
      end else begin
        if(slave_address_start[i][6:0] == slave_address_end[i][6:0])
          return (addr[6:0] == this.slave_address_start[i][6:0]);
        if(addr[6:0] >= slave_address_start[i][6:0] && addr[6:0] <= slave_address_end[i][6:0])
          return 1;
      end
    end
  end else begin
    return enable_10bit_addr ? (addr[9:0] == this.slave_address[9:0]) : (addr[6:0] == this.slave_address[6:0]);
  end
  return 0;
endfunction : is_valid_slave_address

function void kei_vip_i2c_configuration::timing_vars();
  scl_high_time_ss         = `KEI_VIP_I2C_CLK_HIGH_SS*timescale_factor;
  scl_low_time_ss          = `KEI_VIP_I2C_CLK_LOW_SS*timescale_factor;
  scl_high_time_offset_ss  = `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_SS*timescale_factor;
  scl_low_time_offset_ss   = `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_SS*timescale_factor;
  min_su_sta_time_ss       = `KEI_VIP_I2C_MIN_SU_STA_SS*timescale_factor;
  min_su_sto_time_ss       = `KEI_VIP_I2C_MIN_SU_STO_SS*timescale_factor;
  min_su_dat_time_ss       = `KEI_VIP_I2C_MIN_SU_DAT_SS*timescale_factor;
  min_hd_sta_time_ss       = `KEI_VIP_I2C_MIN_HD_STA_SS*timescale_factor;
  min_hd_dat_time_ss       = `KEI_VIP_I2C_MIN_HD_DAT_SS*timescale_factor;
  max_hd_dat_time_ss       = `KEI_VIP_I2C_MAX_HD_DAT_SS*timescale_factor;
  tbuf_time_ss             = `KEI_VIP_I2C_TBUF_TIME_SS*timescale_factor;
  scl_high_time_fs         = `KEI_VIP_I2C_CLK_HIGH_FS*timescale_factor;
  scl_low_time_fs          = `KEI_VIP_I2C_CLK_LOW_FS*timescale_factor;
  scl_high_time_offset_fs  = `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FS*timescale_factor;
  scl_low_time_offset_fs   = `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FS*timescale_factor;
  min_su_sta_time_fs       = `KEI_VIP_I2C_MIN_SU_STA_FS*timescale_factor;
  min_su_sto_time_fs       = `KEI_VIP_I2C_MIN_SU_STO_FS*timescale_factor;
  min_su_dat_time_fs       = `KEI_VIP_I2C_MIN_SU_DAT_FS*timescale_factor;
  min_hd_sta_time_fs       = `KEI_VIP_I2C_MIN_HD_STA_FS*timescale_factor;
  min_hd_dat_time_fs       = `KEI_VIP_I2C_MIN_HD_DAT_FS*timescale_factor;
  max_hd_dat_time_fs       = `KEI_VIP_I2C_MAX_HD_DAT_FS*timescale_factor;
  tbuf_time_fs             = `KEI_VIP_I2C_TBUF_TIME_FS*timescale_factor;
  scl_high_time_hs         = `KEI_VIP_I2C_CLK_HIGH_HS*timescale_factor;
  scl_low_time_hs          = `KEI_VIP_I2C_CLK_LOW_HS*timescale_factor;
  scl_high_time_offset_hs  = `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_HS*timescale_factor;
  scl_low_time_offset_hs   = `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_HS*timescale_factor;
  min_su_sta_time_hs       = `KEI_VIP_I2C_MIN_SU_STA_HS*timescale_factor;
  min_su_sto_time_hs       = `KEI_VIP_I2C_MIN_SU_STO_HS*timescale_factor;
  min_su_dat_time_hs       = `KEI_VIP_I2C_MIN_SU_DAT_HS*timescale_factor;
  min_hd_sta_time_hs       = `KEI_VIP_I2C_MIN_HD_STA_HS*timescale_factor;
  min_hd_dat_time_hs       = `KEI_VIP_I2C_MIN_HD_DAT_HS*timescale_factor;
  max_hd_dat_time_hs       = `KEI_VIP_I2C_MAX_HD_DAT_HS*timescale_factor;
  tbuf_time_hs             = `KEI_VIP_I2C_TBUF_TIME_FS*timescale_factor;
  scl_high_time_fm_plus         = `KEI_VIP_I2C_CLK_HIGH_FM_PLUS*timescale_factor;
  scl_low_time_fm_plus          = `KEI_VIP_I2C_CLK_LOW_FM_PLUS*timescale_factor;
  scl_high_time_offset_fm_plus  = `KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FM_PLUS*timescale_factor;
  scl_low_time_offset_fm_plus   = `KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FM_PLUS*timescale_factor;
  min_su_sta_time_fm_plus       = `KEI_VIP_I2C_MIN_SU_STA_FM_PLUS*timescale_factor;
  min_su_sto_time_fm_plus       = `KEI_VIP_I2C_MIN_SU_STO_FM_PLUS*timescale_factor;
  min_su_dat_time_fm_plus       = `KEI_VIP_I2C_MIN_SU_DAT_FM_PLUS*timescale_factor;
  min_hd_sta_time_fm_plus       = `KEI_VIP_I2C_MIN_HD_STA_FM_PLUS*timescale_factor;
  min_hd_dat_time_fm_plus       = `KEI_VIP_I2C_MIN_HD_DAT_FM_PLUS*timescale_factor;
  max_hd_dat_time_fm_plus       = `KEI_VIP_I2C_MAX_HD_DAT_FM_PLUS*timescale_factor;
  tbuf_time_fm_plus             = `KEI_VIP_I2C_TBUF_TIME_FM_PLUS*timescale_factor;
endfunction : timing_vars

function bit kei_vip_i2c_configuration::is_valid (bit silent =1);
  is_valid = 1;
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_high_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_low_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_high_time_offset_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_low_time_offset_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_sta_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_sto_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_dat_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_hd_sta_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_hd_dat_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(max_hd_dat_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(tbuf_time_ss,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_high_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_low_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_high_time_offset_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_low_time_offset_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_sta_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_sto_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_dat_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_hd_sta_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_hd_dat_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(max_hd_dat_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(tbuf_time_fs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_high_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_low_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_high_time_offset_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_low_time_offset_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_sta_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_sto_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_dat_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_hd_sta_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_hd_dat_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(max_hd_dat_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(tbuf_time_hs,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_high_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_low_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_high_time_offset_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(scl_low_time_offset_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_sta_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_sto_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_su_dat_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_hd_sta_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(min_hd_dat_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(max_hd_dat_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(tbuf_time_fm_plus,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(agent_id,0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(master_code,0,3'b111)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(slave_address,0,10'b11_1111_1111) 
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(no_of_slave_address_ranges,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_10bit_addr,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_response_to_gen_call,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(slave_type,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_put_response,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_cci_8bit,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_eeprom_32bit,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_driver_events,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_pullup_resistor,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(start_hs_in_fm_plus,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_bus_clear_sda,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_bus_clear_scl_off,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clock_count_bus_clear_sda_low,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(clock_count_for_sda_bus_clear,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(bus_clear_sda_timeout,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_glitch_insert_sda,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(glitch_size_sda,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_glitch_insert_scl,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(glitch_size_scl,32'h0,32'hFFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(device_id,0,24'hFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(t_reset_detect_time,0,64'hFFFF_FFFF_FFFF_FFFF)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_tlow_100khz_check,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_tlow_400khz_check,0,1)
  `KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(enable_tlow_1mhz_check,0,1)
endfunction

`endif // KEI_VIP_I2C_CONFIGURATION_SV

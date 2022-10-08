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

`ifndef KEI_VIP_I2C_DEFINES_SVH
`define KEI_VIP_I2C_DEFINES_SVH

  //----------------------------------------------------------------------
  // Virtual interface
  //----------------------------------------------------------------------
  `ifdef SVT_COSIM
    `define I2C_MASTER_MODPORT  svt_i2c_master_modport
    `define I2C_SLAVE_MODPORT   svt_i2c_slave_modport
    `define I2C_MONITOR_MODPORT svt_i2c_monitor_modport
  `else
    `define I2C_MASTER_MODPORT  kei_vip_i2c_master_modport
    `define I2C_SLAVE_MODPORT   kei_vip_i2c_slave_modport
    `define I2C_MONITOR_MODPORT kei_vip_i2c_monitor_modport
  `endif

  `define KEI_VIP_I2C_STANDARD_MODE                  	1
  `define KEI_VIP_I2C_FAST_MODE                      	2
  `define KEI_VIP_I2C_HIGHSPEED_MODE                 	3     
  `define KEI_VIP_I2C_FAST_MODE_PLUS                   4

  `define KEI_VIP_I2C_READ                             1
  `define KEI_VIP_I2C_WRITE                            0
  `define KEI_VIP_I2C_GEN_CALL                         2
  `define KEI_VIP_I2C_DEVICE_ID                        3

  `define KEI_VIP_I2C_BUS                              0 
  `define KEI_VIP_I2C_I3C_BUS                          1 
  `define KEI_VIP_SMBUS_BUS                            2 

  // Bus parameters
  `define KEI_VIP_I2C_SLA_ADD_WIDTH                   10

  //---------------------------------------------------------------------
  // Timing Parameter For Standard Speed Mode (assuming clock period of 1ns)
  //---------------------------------------------------------------------
  `define KEI_VIP_I2C_CLK_HIGH_SS      			 4000      //high period of the SCL clock
  `define KEI_VIP_I2C_CLK_LOW_SS       			 4700      //low period of the SCL clock
  `define KEI_VIP_I2C_MIN_SU_STA_SS    			 4700      //set-up time for a repeated start condition,start no this parameter
  `define KEI_VIP_I2C_MIN_SU_STO_SS    			 4000      //set-up time for stop condition
  `define KEI_VIP_I2C_MIN_SU_DAT_SS    			 250       //data set-up time
  `define KEI_VIP_I2C_MIN_HD_STA_SS    			 4000      //hold time (repeated) start condition
  `define KEI_VIP_I2C_MIN_HD_DAT_SS    			 300       //data hold time min
  `define KEI_VIP_I2C_MAX_HD_DAT_SS    			 3450      //data hold time max
  `define KEI_VIP_I2C_TBUF_TIME_SS     			 4700      //bus free time between a stop and start condition
  `define KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_SS 1000       //max rise time of both sda and scl signals
  `define KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_SS  300        //max fall time of both sda and scl signals
  `define KEI_VIP_I2C_MIN_CLK_HIGH_OFFSET_SS 0          //min rise time of both sda and scl signals
  `define KEI_VIP_I2C_MIN_CLK_LOW_OFFSET_SS  0          //min fall time of both sda and scl signals
  //---------------------------------------------------------------------
  // Timing Parameter For Fast Speed Mode (assuming clock period of 1ns)
  //---------------------------------------------------------------------
  `define KEI_VIP_I2C_CLK_HIGH_FS      			   600
  `define KEI_VIP_I2C_CLK_LOW_FS       			   1300
  `define KEI_VIP_I2C_MIN_SU_STA_FS    			   600
  `define KEI_VIP_I2C_MIN_SU_STO_FS    			   600
  `define KEI_VIP_I2C_MIN_SU_DAT_FS    			   100
  `define KEI_VIP_I2C_MIN_HD_STA_FS    			   600
  `define KEI_VIP_I2C_MIN_HD_DAT_FS    			   300
  `define KEI_VIP_I2C_MAX_HD_DAT_FS    			   900
  `define KEI_VIP_I2C_TBUF_TIME_FS     			   1300
  `define KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FS   300
  `define KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FS    300
  `define KEI_VIP_I2C_MIN_CLK_HIGH_OFFSET_FS   20
  `define KEI_VIP_I2C_MIN_CLK_LOW_OFFSET_FS    20
  //---------------------------------------------------------------------
  // Timing Parameter For High Speed Mode  (assuming clock period of 1ns) Cb = 100
  //---------------------------------------------------------------------
  `define KEI_VIP_I2C_CLK_HIGH_HS      			     100 
  `define KEI_VIP_I2C_CLK_LOW_HS       			     200 
  `define KEI_VIP_I2C_MIN_SU_STA_HS    			     160
  `define KEI_VIP_I2C_MIN_SU_STO_HS    			     160
  `define KEI_VIP_I2C_MIN_SU_DAT_HS    			     10 
  `define KEI_VIP_I2C_MIN_HD_STA_HS    			     160
  `define KEI_VIP_I2C_MIN_HD_DAT_HS    			     40 
  `define KEI_VIP_I2C_MAX_HD_DAT_HS    			     70 
  `define KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_HS     40 
  `define KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_HS      40 
  `define KEI_VIP_I2C_MIN_CLK_HIGH_OFFSET_HS     10 
  `define KEI_VIP_I2C_MIN_CLK_LOW_OFFSET_HS      10 
  //---------------------------------------------------------------------
  // Timing Parameter For Fast Mode plus speed (assuming clock period of 1ns)
  //---------------------------------------------------------------------
  `define KEI_VIP_I2C_CLK_HIGH_FM_PLUS               260
  `define KEI_VIP_I2C_CLK_LOW_FM_PLUS                500
  `define KEI_VIP_I2C_MIN_SU_STA_FM_PLUS             260
  `define KEI_VIP_I2C_MIN_SU_STO_FM_PLUS             260
  `define KEI_VIP_I2C_MIN_SU_DAT_FM_PLUS             50
  `define KEI_VIP_I2C_MIN_HD_STA_FM_PLUS             260
  `define KEI_VIP_I2C_MIN_HD_DAT_FM_PLUS             300
  `define KEI_VIP_I2C_MAX_HD_DAT_FM_PLUS             900
  `define KEI_VIP_I2C_TBUF_TIME_FM_PLUS              500
  `define KEI_VIP_I2C_MAX_CLK_HIGH_OFFSET_FM_PLUS    120
  `define KEI_VIP_I2C_MAX_CLK_LOW_OFFSET_FM_PLUS     120
  `define KEI_VIP_I2C_MIN_CLK_HIGH_OFFSET_FM_PLUS    0
  `define KEI_VIP_I2C_MIN_CLK_LOW_OFFSET_FM_PLUS     0
  
  //---------------------------------------------------------------------
  // MAX Timing Parameter For Standard Speed Mode (assuming clock period of 1ns)
  //---------------------------------------------------------------------
  `define KEI_VIP_I2C_MAX_CLK_HIGH_SS      	 10000
  `define KEI_VIP_I2C_MAX_CLK_LOW_SS       	 10000
  `define KEI_VIP_I2C_MAX_SU_STA_SS    			 10000
  `define KEI_VIP_I2C_MAX_SU_STO_SS    			 10000
  `define KEI_VIP_I2C_MAX_SU_DAT_SS    			 1000
  `define KEI_VIP_I2C_MAX_HD_STA_SS    			 6000
  `define KEI_VIP_I2C_MIN_HD_DAT_MAX_SS			 1000
  `define KEI_VIP_I2C_MAX_HD_DAT_MIN_SS			 2000  
  `define KEI_VIP_I2C_MAX_TBUF_TIME_SS     	 10000
  //---------------------------------------------------------------------
  // MAX Timing Parameter For Fast Speed Mode (assuming clock period of 1ns)
  //---------------------------------------------------------------------
  `define KEI_VIP_I2C_MAX_CLK_HIGH_FS      	 10000
  `define KEI_VIP_I2C_MAX_CLK_LOW_FS       	 10000
  `define KEI_VIP_I2C_MAX_SU_STA_FS    			 1500
  `define KEI_VIP_I2C_MAX_SU_STO_FS    			 1500
  `define KEI_VIP_I2C_MAX_SU_DAT_FS    			 500
  `define KEI_VIP_I2C_MAX_HD_STA_FS    			 1500
  `define KEI_VIP_I2C_MIN_HD_DAT_MAX_FS			 500
  `define KEI_VIP_I2C_MAX_HD_DAT_MIN_FS			 800
  `define KEI_VIP_I2C_MAX_TBUF_TIME_FS     	 2500
  //---------------------------------------------------------------------
  // MAX Timing Parameter For High Speed Mode  (assuming clock period of 1ns) Cb = 100
  //---------------------------------------------------------------------
  `define KEI_VIP_I2C_MAX_CLK_HIGH_HS      	 1000 
  `define KEI_VIP_I2C_MAX_CLK_LOW_HS       	 1000 
  `define KEI_VIP_I2C_MAX_SU_STA_HS    			 1000
  `define KEI_VIP_I2C_MAX_SU_STO_HS    			 1000
  `define KEI_VIP_I2C_MAX_SU_DAT_HS    			 50 
  `define KEI_VIP_I2C_MAX_HD_STA_HS    			 400
  `define KEI_VIP_I2C_MIN_HD_DAT_MAX_HS			 50 
  `define KEI_VIP_I2C_MAX_HD_DAT_MIN_HS			 60 
  //---------------------------------------------------------------------
  // MAX Timing Parameter For Fast Mode plus speed (assuming clock period of 1ns)
  //---------------------------------------------------------------------
  `define KEI_VIP_I2C_MAX_CLK_HIGH_FM_PLUS     1000
  `define KEI_VIP_I2C_MAX_CLK_LOW_FM_PLUS      1000
  `define KEI_VIP_I2C_MAX_SU_STA_FM_PLUS       1000
  `define KEI_VIP_I2C_MAX_SU_STO_FM_PLUS       1000
  `define KEI_VIP_I2C_MAX_SU_DAT_FM_PLUS       100
  `define KEI_VIP_I2C_MAX_HD_STA_FM_PLUS       500
  `define KEI_VIP_I2C_MIN_HD_DAT_FM_MAX_PLUS   500
  `define KEI_VIP_I2C_MAX_HD_DAT_FM_MIN_PLUS   800
  `define KEI_VIP_I2C_MAX_TBUF_TIME_FM_PLUS    1000
  //----------------------------------------------------------------------
  // Define for the slave type
  //----------------------------------------------------------------------
  `define KEI_VIP_I2C_GENERIC                                1
  `define KEI_VIP_I2C_EEPROM                                 2
  `define	KEI_VIP_I2C_SLAVE0_ADDRESS	            	10'b1100110011
  `define	KEI_VIP_I2C_SLAVE1_ADDRESS		            10'b1100110000
  `define KEI_VIP_I2C_SLAVE_ADDRESS_NON_EXISTING   10'b1101000000
  //----------------------------------------------------------------------
  // Define for others 
  //----------------------------------------------------------------------
  `define KEI_VIP_I2C_DEFAULT_PULLUP_RESISTOR                1
  `define KEI_VIP_I2C_BUS_CLEAR_CLK_COUNT_SDA_LOW            15
  `define KEI_VIP_I2C_BUS_CLEAR_CLK_COUNT_FOR_SDA            3
  `define KEI_VIP_I2C_BUS_CLEAR_SDA_TIMEOUT                  20000
  `define KEI_VIP_I2C_GLITCH_SIZE_SDA                        1
  `define KEI_VIP_I2C_GLITCH_SIZE_SCL                        1
  `define KEI_VIP_RELEVANT                                   -1
  `define KEI_VIP_I2C_MAX_NUM_MASTERS                        16
  `define KEI_VIP_I2C_MAX_NUM_SLAVES                         16

  //----------------------------------------------------------------------
  // Define for the object property set & get methods
  //----------------------------------------------------------------------

  //----------------------------------------------------------------------
  // Define for the master transaction
  //----------------------------------------------------------------------
  `define KEI_VIP_I2C_NACK_AT_DEVICE_ID_BYTE_MAX_VALID       50       
  `define KEI_VIP_I2C_DEVICE_ID_ROLLBACK_ITER_MAX_VALID      15
  
  //----------------------------------------------------------------------
  // Define for check whether data range is valid
  //----------------------------------------------------------------------
  `define KEI_VIP_DATA_UTIL_IS_VALID_BV_W_RANGE(PROP, MIN, MAX) \
    if(!(PROP>=MIN && PROP<=MAX)) begin is_valid = 0; if(!silent) `uvm_warning(get_type_name(),$sformatf("%s value is out of range!","PROP")); end\
      else if (!is_valid) is_valid = 0;\
        else is_valid = 1;

    


`endif // KEI_VIP_I2C_DEFINES_SVH

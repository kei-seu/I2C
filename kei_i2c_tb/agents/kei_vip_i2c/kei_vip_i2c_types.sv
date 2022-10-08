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

`ifndef KEI_VIP_I2C_TYPES_SV
`define KEI_VIP_I2C_TYPES_SV
  
  //----------------------------------------------------------------------
  // Virtual interface
  //----------------------------------------------------------------------
  `ifdef SVT_COSIM
    typedef virtual svt_i2c_if kei_vip_i2c_vif;
  `else
    typedef virtual kei_vip_i2c_if kei_vip_i2c_vif;
  `endif

  /** 
   * Tpedef:Enum to represent Bus Speed. SVT I2C VIP provide 4 types of bus speed:
   * 1. Standard speed
   * 2. Fast mode
   * 3. High speed mode
   * 4. Fast mode plus
   */
  typedef enum bit[2:0]
  {
   STANDARD_MODE   = `KEI_VIP_I2C_STANDARD_MODE   , /**< Specifies Standard Mode   */   
   FAST_MODE       = `KEI_VIP_I2C_FAST_MODE       , /**< Specifies Fast Mode       */   
   HIGHSPEED_MODE  = `KEI_VIP_I2C_HIGHSPEED_MODE  , /**< Specifies High Speed Mode */
   FAST_MODE_PLUS  = `KEI_VIP_I2C_FAST_MODE_PLUS    /**< Specifies Fast Mode Plusn */
  } bus_speed_enum;

  
  //----------------------------------------------------------------------
  // Enumerated type definition for the type of command to be given by 
  // Master BFM 
  //----------------------------------------------------------------------
  typedef enum bit [7:0] 
  {
    I2C_WRITE       = `KEI_VIP_I2C_WRITE,
    I2C_READ        = `KEI_VIP_I2C_READ,
    I2C_GEN_CALL    = `KEI_VIP_I2C_GEN_CALL,
    I2C_DEVICE_ID   = `KEI_VIP_I2C_DEVICE_ID
  } command_enum;

  typedef enum bit [1:0] {
	  I2C_BUS = `KEI_VIP_I2C_BUS,
	  MIPI_I3C_BUS = `KEI_VIP_I2C_I3C_BUS,
	  SMBUS_BUS = `KEI_VIP_SMBUS_BUS
  } bus_type_enum;

  
  function bit[2:0] get_bus_type(bus_type_enum bus_type);
     case(bus_type)
       I2C_BUS      : get_bus_type   = `KEI_VIP_I2C_BUS    ;
       MIPI_I3C_BUS : get_bus_type   = `KEI_VIP_I2C_I3C_BUS;
       SMBUS_BUS    : get_bus_type   = `KEI_VIP_SMBUS_BUS  ;
       default:get_bus_type = `KEI_VIP_I2C_BUS;
     endcase // case (type)
  endfunction // bit

  function bit[2:0] get_bus_speed(bus_speed_enum speed);
    case(speed)
      STANDARD_MODE   : get_bus_speed = `KEI_VIP_I2C_STANDARD_MODE ; 
      FAST_MODE       : get_bus_speed = `KEI_VIP_I2C_FAST_MODE     ;   
      HIGHSPEED_MODE  : get_bus_speed = `KEI_VIP_I2C_HIGHSPEED_MODE;
      FAST_MODE_PLUS  : get_bus_speed = `KEI_VIP_I2C_FAST_MODE_PLUS;
      default:
        begin
        end
    endcase // case (speed)
  endfunction // bit

    //----------------------------------------------------------------------
  // Function    : get_enum_command
  // Description : This function maps the command type to the enumerated 
  //               command type
  //----------------------------------------------------------------------
  function command_enum get_enum_command(bit [7:0] cmd);
    begin
      case(cmd)
        `KEI_VIP_I2C_WRITE         : get_enum_command = I2C_WRITE;
        `KEI_VIP_I2C_READ          : get_enum_command = I2C_READ;
        `KEI_VIP_I2C_GEN_CALL      : get_enum_command = I2C_GEN_CALL;
        `KEI_VIP_I2C_DEVICE_ID     : get_enum_command = I2C_DEVICE_ID;
	      default:
          begin
            $display("Error:Invalid command enum");
          end
      endcase // case (cmd)
    end
  endfunction // command

  //----------------------------------------------------------------------
  // Function    : get_command
  // Description : This function maps the enumerated command type to
  //               cmd define
  //----------------------------------------------------------------------
   function bit [7:0] get_command(command_enum cmd_enum);
      begin
	      case(cmd_enum)
           I2C_WRITE      : get_command = `KEI_VIP_I2C_WRITE;
           I2C_READ       : get_command = `KEI_VIP_I2C_READ;
           I2C_GEN_CALL   : get_command = `KEI_VIP_I2C_GEN_CALL;
           I2C_DEVICE_ID  : get_command = `KEI_VIP_I2C_DEVICE_ID;
	         default:
             begin
		           $display("Error:Invalid Master command");
             end
	      endcase // case (cmd)
      end
   endfunction // get_command

`endif // KEI_VIP_I2C_TYPES_SV

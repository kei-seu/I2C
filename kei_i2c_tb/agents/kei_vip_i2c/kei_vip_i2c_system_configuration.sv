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

`ifndef KEI_VIP_I2C_SYSTEM_CONFIGURATION_SV
`define KEI_VIP_I2C_SYSTEM_CONFIGURATION_SV

class kei_vip_i2c_system_configuration extends kei_vip_configuration;
  
 kei_vip_i2c_vif i2c_if;

  /** @cond PRIVATE */
  /** 
   * @groupname i2c_clock
   * This parameter indicates whether a common clock should be used
   * for all the components in the system or not.
   * When set, a common clock supplied to the top level interface 
   * is used for all the masters, slaves and interconnect in 
   * the system. This mode is to be used if all components are
   * expected to run at the same frequency.
   * When not set, the user needs to supply a clock for each of the
   * port level interfaces. This mode is useful when some components
   * need to run at a different clock frequency from other
   * components in the system.<br>
   * Currently not supported
   */
  bit  common_clock_mode = 1;

  /** 
   * @groupname reset
   * This parameter indicates whether a common reset should be used
   * for all the components in the system or not.
   * When set, a common reset supplied to the top level interface 
   * is used for all the masters, slaves and interconnect in 
   * the system. This mode is to be used if all components are
   * expected to use the same reset signal.
   * When not set, the user needs to supply a reset for each of the
   * port level interfaces. This mode is useful when some components
   * need to be reset at a different time from other
   * components in the system.<br>
   * Currently not supported
   */
  bit  common_reset_mode = 1;
  
  /** 
   * @groupname i2c_bus-speed
   * This parameter indicates whether a common bus-speed should be used
   * for all the components in the system or not.
   * When set, a common bus-speed supplied to the top level interface 
   * is used for all the masters, slaves and interconnect in 
   * the system. This mode is to be used if all components are
   * expected to run at the same frequency.
   * When not set, the user needs to supply a bus-speed for each of the
   * port level interfaces. This mode is useful when some components
   * need to run at a different bus speed from other omponents in the 
   * system.<br>
   * Currently not supported
   */
  bit common_bus_speed_mode = 1;
  
  //----------------------------------------------------------------------------
  /** Randomizable variables */
  // ---------------------------------------------------------------------------

  /** 
   * @groupname i2c_master_slave_config
   * Number of masters in the system 
   * - Min value: 1
   * - Max value: `SVT_I2C_MAX_NUM_MASTERS
   * - Configuration type: Static 
   * .
   */
  rand int num_masters;

  /** 
   * @groupname i2c_master_slave_config
   * Number of slaves in the system 
   * - Min value: 1
   * - Max value: `SVT_I2C_MAX_NUM_SLAVES
   * - Configuration type: Static
   * .
   */
  rand int num_slaves;

  /** 
   * @groupname i2c_master_slave_config
   * Array holding the configuration of all the masters in the system.
   * Size of the array is equal to svt_i2c_system_configuration::num_masters.
   * @size_control svt_i2c_system_configuration::num_masters
   */
  rand kei_vip_i2c_agent_configuration master_cfg[];

  /** 
   * @groupname i2c_master_slave_config
   * Array holding the configuration of all the slaves in the system.
   * Size of the array is equal to svt_i2c_system_configuration::num_slaves.
   * @size_control svt_i2c_system_configuration::num_slaves
   */
  rand kei_vip_i2c_agent_configuration slave_cfg[];

  // ***************************************************************************
  // Constraints
  // ***************************************************************************

  constraint system_configuration_valid_ranges {
    num_masters > 0;
    num_slaves  > 0;
    num_masters <= `KEI_VIP_I2C_MAX_NUM_MASTERS;
    num_slaves  <= `KEI_VIP_I2C_MAX_NUM_SLAVES ;
    master_cfg.size() == num_masters;
    slave_cfg.size()  == num_slaves ;
  }

  /**
   * pre_randomize does the following:
   * 1) Allocate master and slave configuration object arrays
   */
  extern function void pre_randomize ();

   /**
   * Method to turn reasonable constraints on/off as a block.
   */
  extern virtual function int reasonable_constraint_mode (bit on_off);
   
  /** Extend the VMM copy routine to copy the virtual interface */
  extern virtual function void do_copy(uvm_object rhs);

  
  /**
   * Method to turn static config param randomization on/off as a block.
   */
  extern virtual function int static_rand_mode(bit on_off);
  
   /**
   * Assigns a system interface to this configuration.
   *
   * @param i2c_if Interface for the I2C system
   */
  extern function void set_if(kei_vip_i2c_vif i2c_if);

  /**
   * Allocates the master and slave configurations before a user sets the
   * parameters.  This function is to be called if (and before) the user sets
   * the configuration parameters by setting each parameter individually and
   * not by randomizing the system configuration. 
   */
  extern function void create_sub_cfgs(int num_masters = 1, int num_slaves = 1, bus_speed_enum speed= STANDARD_MODE, bit enable_pullup_resistor = 1);

  /** Set the bus speed for all master_cfg[] and slave_cfg[] */   
  extern function void set_bus_speed(bus_speed_enum speed= STANDARD_MODE);

  /** Retrun the number of masters in system */   
  extern function int get_num_masters();

  /** Return the number of slaves in system */   
  extern function int get_num_slaves();

  /** Set the enable_pullup_resistor for all master_cfg[] and slave_cfg[] */   
  extern function void set_pullup_resistor(bit enable_pullup_resistor = 1);
 
   // ========================================================================================
  // The following method must not be called by users even if they are public
  // ========================================================================================
  /** @cond PRIVATE */
  extern virtual function void set_num_masters (int num_masters, int kind = -1);
  extern virtual function void set_num_slaves (int num_slaves, int kind = -1);
 
   /**
   * This method returns the maximum packer bytes value required by the I2C SVT
   * suite. This is checked against UVM_MAX_PACKER_BYTES to make sure the specified
   * setting is sufficient for the I2C SVT suite.
   */
//  extern virtual function int get_packer_max_bytes_required();

  `uvm_object_utils_begin(kei_vip_i2c_system_configuration)
    `uvm_field_int(common_clock_mode, UVM_NOCOPY|UVM_BIN|UVM_ALL_ON)
    `uvm_field_int(common_reset_mode, UVM_NOCOPY|UVM_BIN|UVM_ALL_ON)
    `uvm_field_int(common_bus_speed_mode, UVM_NOCOPY|UVM_BIN|UVM_ALL_ON)
    `uvm_field_int(num_masters, UVM_NOCOPY|UVM_DEC|UVM_ALL_ON)
    `uvm_field_int(num_slaves, UVM_NOCOPY|UVM_DEC|UVM_ALL_ON)
    `uvm_field_array_object(master_cfg, UVM_NOCOPY|UVM_NOPACK|UVM_DEEP)
    `uvm_field_array_object(slave_cfg, UVM_NOCOPY|UVM_NOPACK|UVM_DEEP)
  `uvm_object_utils_end

  extern function new (string name = "kei_vip_i2c_system_configuration");

endclass : kei_vip_i2c_system_configuration


function kei_vip_i2c_system_configuration::new(string name = "kei_vip_i2c_system_configuration");
    super.new(name);
endfunction : new

function void kei_vip_i2c_system_configuration::pre_randomize();
    create_sub_cfgs(`KEI_VIP_I2C_MAX_NUM_MASTERS,`KEI_VIP_I2C_MAX_NUM_SLAVES);
endfunction : pre_randomize

function void kei_vip_i2c_system_configuration::set_if(kei_vip_i2c_vif i2c_if);
  this.i2c_if = i2c_if;

  if(this.i2c_if !=null) begin
    foreach(master_cfg[i]) begin
      master_cfg[i].set_i2c_if(this.i2c_if);
    end

    foreach(slave_cfg[i]) begin
      slave_cfg[i].set_i2c_if(this.i2c_if);
    end
  end
endfunction : set_if

function void kei_vip_i2c_system_configuration::create_sub_cfgs(int num_masters=1,int num_slaves=1,bus_speed_enum speed = STANDARD_MODE, bit enable_pullup_resistor=1);
    this.num_masters = num_masters;
    this.num_slaves = num_slaves;
    master_cfg = new[num_masters](master_cfg);

    foreach(master_cfg[i]) begin
      master_cfg[i] = new();
      if(this.i2c_if != null) begin
        master_cfg[i].set_i2c_if(i2c_if);
      end
      master_cfg[i].agent_id = i;
    end

    slave_cfg = new[num_slaves](slave_cfg);

    foreach(slave_cfg[i]) begin
      slave_cfg[i] = new();
      if(this.i2c_if != null) begin
        slave_cfg[i].set_i2c_if(i2c_if);
      end
      slave_cfg[i].agent_id =i;
    end
    set_bus_speed(speed);
    set_pullup_resistor(enable_pullup_resistor);

endfunction : create_sub_cfgs

function void kei_vip_i2c_system_configuration::set_bus_speed(bus_speed_enum speed = STANDARD_MODE);
    foreach(master_cfg[i])
      master_cfg[i].bus_speed = speed;
    foreach(slave_cfg[i])
      slave_cfg[i].bus_speed = speed;
endfunction : set_bus_speed

function void kei_vip_i2c_system_configuration::set_pullup_resistor(bit enable_pullup_resistor=1);
    foreach(master_cfg[i])
      master_cfg[i].enable_pullup_resistor = enable_pullup_resistor;
    foreach(slave_cfg[i])
      slave_cfg[i].enable_pullup_resistor = enable_pullup_resistor;
endfunction : set_pullup_resistor

function void kei_vip_i2c_system_configuration::do_copy(uvm_object rhs);
    kei_vip_i2c_system_configuration rhs_;
    super.do_copy(rhs);
    $cast(rhs_,rhs);
    i2c_if = rhs_.i2c_if;
endfunction : do_copy

function int kei_vip_i2c_system_configuration::static_rand_mode(bit on_off);
    static_rand_mode = on_off;
endfunction : static_rand_mode

function int kei_vip_i2c_system_configuration::reasonable_constraint_mode(bit on_off);
    reasonable_constraint_mode = on_off;
endfunction : reasonable_constraint_mode

function void kei_vip_i2c_system_configuration::set_num_masters(int num_masters,int kind = -1);
  this.num_masters = num_masters;
endfunction : set_num_masters

function int kei_vip_i2c_system_configuration::get_num_masters();
  get_num_masters = num_masters;
endfunction : get_num_masters

function void kei_vip_i2c_system_configuration::set_num_slaves(int num_slaves,int kind = -1);
  this.num_slaves = num_slaves;
endfunction : set_num_slaves

function int kei_vip_i2c_system_configuration::get_num_slaves();
  get_num_slaves = num_slaves;
endfunction : get_num_slaves


`endif // KEI_VIP_I2C_SYSTEM_CONFIGURATION_SV 


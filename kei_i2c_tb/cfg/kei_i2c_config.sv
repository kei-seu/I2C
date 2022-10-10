`ifndef KEI_I2C_CONFIG_SV
`define KEI_I2C_CONFIG_SV

class kei_i2c_config extends uvm_object;

  kei_vip_apb_config apb_cfg;
  kei_vip_i2c_system_configuration i2c_cfg;
  ral_block_kei_i2c rgm;

  `uvm_object_utils(kei_i2c_config)

  function new (string name = "kei_i2c_config");
    super.new(name);
    apb_cfg = kei_vip_apb_config::type_id::create("apb_cfg");
    i2c_cfg = kei_vip_i2c_system_configuration::type_id::create("i2c_cfg");
    do_apb_cfg();
    do_i2c_cfg();
  endfunction

  function void do_apb_cfg();
    // TODO
  endfunction


  function void do_i2c_cfg();
  
    i2c_cfg.num_masters = 1;
    i2c_cfg.num_slaves = 1;
    i2c_cfg.create_sub_cfgs(i2c_cfg.num_masters, i2c_cfg.num_slaves);

    // By default 
    // I2C master agent as passive
    i2c_cfg.master_cfg[0].bus_speed             = kei_vip_i2c_pkg::STANDARD_MODE;
    i2c_cfg.master_cfg[0].master_code           = 3'b000;
    i2c_cfg.master_cfg[0].enable_10bit_addr     = 0;
    i2c_cfg.master_cfg[0].is_active             = 0;

    // I2C slave agent as active
    i2c_cfg.slave_cfg[0].slave_address          = `KEI_VIP_I2C_SLAVE0_ADDRESS;
    i2c_cfg.slave_cfg[0].enable_10bit_addr      = 0;
    i2c_cfg.slave_cfg[0].device_id              = 24'b0;
    i2c_cfg.slave_cfg[0].is_active              = 1;
    
  endfunction

endclass

`endif // KEI_I2C_CONFIG_SV

`ifndef KEI_I2C_CONFIG_SV
`define KEI_I2C_CONFIG_SV

class kei_i2c_config extends uvm_object;

  kei_vip_apb_config apb_cfg;
  kei_vip_i2c_system_configuration i2c_cfg;
  ral_block_kei_i2c rgm;

  `uvm_object_utils(kei_i2c_config)

  function new (string name = "kei_i2c_config");
    super.new(name);

  endfunction

  function void do_apb_cfg();
    // TODO
  endfunction


  function void do_i2c_cfg();

  endfunction

endclass

`endif // KEI_I2C_CONFIG_SV

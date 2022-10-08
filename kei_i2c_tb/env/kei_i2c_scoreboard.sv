
`ifndef KEI_I2C_SCOREBOARD_SV
`define KEI_I2C_SCOREBOARD_SV

class kei_i2c_scoreboard extends uvm_component;

  // TODO
  // Analysis FIFO declarion below

  `uvm_component_utils(kei_i2c_scoreboard)

  function new (string name = "kei_i2c_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction


endclass

`endif // KEI_I2C_SCOREBOARD_SV


`ifndef KEI_I2C_PKG_SV
`define KEI_I2C_PKG_SV

package kei_i2c_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import kei_vip_apb_pkg::*;
  import kei_vip_i2c_pkg::*;
  `include "kei_vip_i2c_defines.svh"

  `include "ral_kei_i2c.sv"
  `include "kei_i2c_configs.svh"
  `include "kei_i2c_cgm.sv"
  `include "kei_i2c_master_scoreboard.sv"
  `include "kei_i2c_virtual_sequencer.sv"
  `include "kei_i2c_env.sv"
  `include "kei_i2c_element_sequences.svh"
  `include "kei_i2c_virtual_sequences.svh"
  `include "kei_i2c_tests.svh"

endpackage

`endif // KEI_I2C_PKG_SV

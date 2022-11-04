
`ifndef KEI_I2C_USER_TESTS_SVH
`define KEI_I2C_USER_TESTS_SVH

`include "kei_i2c_master_address_cg_test.sv"

`include "kei_i2c_master_ss_cnt_test.sv"
`include "kei_i2c_master_fs_cnt_test.sv"
`include "kei_i2c_master_hs_cnt_test.sv"

`include "kei_i2c_master_sda_control_cg_test.sv"

`include "kei_i2c_master_timeout_cg_test.sv"

`include "kei_i2c_master_enabled_cg_test.sv"

`include "kei_i2c_master_stop_det_intr_test.sv"
`include "kei_i2c_master_tx_abrt_intr_test.sv"
`include "kei_i2c_master_rx_full_intr_test.sv"
`include "kei_i2c_master_rx_over_intr_test.sv"


`endif // KEI_I2C_USER_TESTS_SVH


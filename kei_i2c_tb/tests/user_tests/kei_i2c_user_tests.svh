
`ifndef KEI_I2C_USER_TESTS_SVH
`define KEI_I2C_USER_TESTS_SVH

`include "kei_i2c_master_address_cg_test.sv"

`include "kei_i2c_master_ss_cnt_test.sv"
`include "kei_i2c_master_fs_cnt_test.sv"
`include "kei_i2c_master_hs_cnt_test.sv"
`include "kei_i2c_master_hs_master_code_test.sv"

`include "kei_i2c_master_sda_control_cg_test.sv"

`include "kei_i2c_master_timeout_cg_test.sv"

`include "kei_i2c_master_enabled_cg_test.sv"

`include "kei_i2c_master_stop_det_intr_test.sv"
`include "kei_i2c_master_tx_abrt_intr_test.sv"
`include "kei_i2c_master_tx_over_intr_test.sv"
`include "kei_i2c_master_rx_full_intr_test.sv"
`include "kei_i2c_master_rx_over_intr_test.sv"
`include "kei_i2c_master_rx_under_intr_test.sv"

`include "kei_i2c_master_10b_rd_norstrt_abrt_test.sv"
`include "kei_i2c_master_sbyte_norstrt_abrt_test.sv"
`include "kei_i2c_master_txdata_noack_abrt_test.sv"
`include "kei_i2c_master_7b_addr_noack_abrt_test.sv"
`include "kei_i2c_master_10b_addr1_noack_abrt_test.sv"
`include "kei_i2c_master_10b_addr2_noack_abrt_test.sv"
`include "kei_i2c_master_hs_norstrt_abrt_test.sv"
`include "kei_i2c_master_gcall_noack_abrt_test.sv"
`include "kei_i2c_master_gcall_read_abrt_test.sv"
`include "kei_i2c_master_sbyte_ackdet_abrt_test.sv"
`include "kei_i2c_master_hs_ackdet_abrt_test.sv"
`include "kei_i2c_master_arb_lost_abrt_test.sv"
`include "kei_i2c_master_master_dis_abrt_test.sv"

`endif // KEI_I2C_USER_TESTS_SVH


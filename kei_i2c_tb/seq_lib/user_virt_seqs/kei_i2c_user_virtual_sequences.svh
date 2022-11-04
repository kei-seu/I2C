
`ifndef KEI_I2C_USER_VIRTUAL_SEQUENCES_SVH
`define KEI_I2C_USER_VIRTUAL_SEQUENCES_SVH

`include "kei_i2c_master_address_cg_virt_seq.sv"

`include "kei_i2c_master_ss_cnt_virt_seq.sv"
`include "kei_i2c_master_fs_cnt_virt_seq.sv"
`include "kei_i2c_master_hs_cnt_virt_seq.sv"

`include "kei_i2c_master_sda_control_cg_virt_seq.sv"

`include "kei_i2c_master_timeout_cg_virt_seq.sv"

`include "kei_i2c_master_enabled_cg_virt_seq.sv"

`include "kei_i2c_master_stop_det_intr_virt_seq.sv"
`include "kei_i2c_master_tx_abrt_intr_virt_seq.sv"
`include "kei_i2c_master_rx_full_intr_virt_seq.sv"
`include "kei_i2c_master_rx_over_intr_virt_seq.sv"

`endif // KEI_I2C_USER_VIRTUAL_SEQUENCES_SVH


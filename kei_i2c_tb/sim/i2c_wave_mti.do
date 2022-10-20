onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 23 -group i2c_if /kei_i2c_tb/i2c_if/CLK
add wave -noupdate -height 23 -group i2c_if /kei_i2c_tb/i2c_if/RST
add wave -noupdate -height 23 -group i2c_if /kei_i2c_tb/i2c_if/SCL
add wave -noupdate -height 23 -group i2c_if /kei_i2c_tb/i2c_if/SDA
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/rstn
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/paddr
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/pwrite
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/psel
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/penable
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/pwdata
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/prdata
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/pready
add wave -noupdate -height 23 -group apb_if /kei_i2c_tb/apb_if/pslverr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/pslverr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/pclk
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/presetn
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/psel
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/penable
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/pready
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/pwrite
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/paddr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/pwdata
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group apb_port /kei_i2c_tb/dut/prdata
add wave -noupdate -height 23 -group I2C_DUT -group system_ports /kei_i2c_tb/dut/ic_rst_n
add wave -noupdate -height 23 -group I2C_DUT -group system_ports /kei_i2c_tb/dut/ic_clk
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group i2c_ports /kei_i2c_tb/dut/ic_clk_in_a
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group i2c_ports /kei_i2c_tb/dut/ic_data_in_a
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group i2c_ports /kei_i2c_tb/dut/ic_current_src_en
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group i2c_ports /kei_i2c_tb/dut/ic_clk_oe
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group i2c_ports /kei_i2c_tb/dut/ic_data_oe
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group i2c_ports /kei_i2c_tb/dut/ic_en
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_activity_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_rx_over_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_rx_under_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_tx_over_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_tx_abrt_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_rx_done_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_tx_empty_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_stop_det_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_start_det_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_rd_req_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_rx_full_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group interrupts /kei_i2c_tb/dut/ic_gen_call_intr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_p_gen
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_s_gen
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_data
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_addr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_rd
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_wr
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_hs
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_master_act
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_slave_act
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_addr_10bit
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_mst_cstate
add wave -noupdate -height 23 -group I2C_DUT -height 23 -group debug_ports /kei_i2c_tb/dut/debug_slv_cstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 235
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {856 ps}

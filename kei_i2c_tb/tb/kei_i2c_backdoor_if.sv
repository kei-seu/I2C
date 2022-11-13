
`ifndef KEI_I2C_BACKDOOR_IF_SV
`define KEI_I2C_BACKDOOR_IF_SV
interface kei_i2c_backdoor_if(input bit clk);
  
  //tx_push_data,tx_push,rx_pop均是wire类型，无法直接赋值，需要force语句强制赋值
  task IC_DATA_CMD_backdoor_write_data(input bit [7:0]data);
    force kei_i2c_tb.dut.U_DW_apb_i2c_regfile.tx_push_data = {1'b0,data};
    force kei_i2c_tb.dut.U_DW_apb_i2c_regfile.tx_push = 1'b1;
    repeat(3) @(posedge clk);
    release kei_i2c_tb.dut.U_DW_apb_i2c_regfile.tx_push;
  endtask
  
  task IC_DATA_CMD_backdoor_read_data(output bit [7:0]data);
    data = kei_i2c_tb.dut.U_DW_apb_i2c_regfile.rx_pop_data;
    force kei_i2c_tb.dut.U_DW_apb_i2c_regfile.rx_pop = 1'b1;
    repeat(3) @(posedge clk);
    release kei_i2c_tb.dut.U_DW_apb_i2c_regfile.rx_pop;
  endtask
  
  function void i2c_if_SDA();
    force kei_i2c_tb.i2c_if.SDA = 1'b1;
  endfunction
  
endinterface
`endif // KEI_I2C_BACKDOOR_IF_SV

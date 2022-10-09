
`ifndef KEI_I2C_SLAVE_WRITE_RESPONSE_SEQ_SV
`define KEI_I2C_SLAVE_WRITE_RESPONSE_SEQ_SV

class kei_i2c_slave_write_response_seq extends kei_i2c_slave_base_sequence;

  `uvm_object_utils(kei_i2c_slave_write_response_seq)

  constraint def_cstr {
    soft nack_addr == 0;
    soft nack_data == 0;
    soft nack_addr_count == 0;
  }

  function new (string name = "kei_apb_config_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering...", UVM_HIGH)
    super.body();

    `uvm_do_with(req,  
                {local::nack_addr >= 0 -> nack_addr == local::nack_addr;
                 local::nack_data >= 0 -> nack_data == local::nack_data;
                 local::nack_addr_count >= 0-> nack_addr_count == local::nack_addr_count;
                })

    if(cfg.enable_put_response == 1) get_response(rsp);

    `uvm_info("body", "Exiting...", UVM_HIGH)
  endtask

endclass

`endif // KEI_I2C_SLAVE_WRITE_RESPONSE_SEQ_SV

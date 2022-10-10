`ifndef KEI_I2C_BASE_TEST_SV
`define KEI_I2C_BASE_TEST_SV

virtual class kei_i2c_base_test extends uvm_test;

  kei_i2c_config cfg;

  kei_i2c_env env;

  function new(string name = "kei_i2c_base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = kei_i2c_config::type_id::create("cfg");
    uvm_config_db#(kei_i2c_config)::set(this,"env","cfg", cfg);
    env = kei_i2c_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_root::get().set_report_verbosity_level_hier(UVM_HIGH);
    uvm_root::get().set_report_max_quit_count(10);
    //uvm_root::get().set_timeout(10ms);//有bug，设置为10ms，实际10us就会超时退出
  endfunction

  task run_phase(uvm_phase phase);
    // NOTE:: raise objection to prevent simulation stopping
    phase.raise_objection(this);
    this.run_top_virtual_sequence();
    // NOTE:: drop objection to request simulation stopping
    phase.drop_objection(this);
  endtask

  virtual task run_top_virtual_sequence();
    // User to implement this task in the child tests
  endtask
endclass: kei_i2c_base_test

`endif // KEI_I2C_BASE_TEST_SV

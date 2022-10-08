//=======================================================================
// COPYRIGHT (C) 2018-2020 RockerIC, Ltd.
// This software and the associated documentation are confidential and
// proprietary to RockerIC, Ltd. Your use or disclosure of this software
// is subject to the terms and conditions of a consulting agreement
// between you, or your company, and RockerIC, Ltd. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
// VisitUs  : www.rockeric.com
// Support  : support@rockeric.com
// WeChat   : eva_bill 
//-----------------------------------------------------------------------
`ifndef KEI_VIP_APB_TESTS_SV
`define KEI_VIP_APB_TESTS_SV

import kei_vip_apb_pkg::*;

class kei_vip_apb_env extends uvm_env;
  kei_vip_apb_master_agent mst;
  kei_vip_apb_slave_agent slv;
  `uvm_component_utils(kei_vip_apb_env)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mst = kei_vip_apb_master_agent::type_id::create("mst", this);
    slv = kei_vip_apb_slave_agent::type_id::create("slv", this);
  endfunction
endclass

class kei_vip_apb_base_test extends uvm_test;
  kei_vip_apb_env env;
  kei_vip_apb_config cfg;
  `uvm_component_utils(kei_vip_apb_base_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = kei_vip_apb_config::type_id::create("cfg");
    // USER TODO
    // Option-1 manually set the config parameters 
    // cfg.slave_pready_default_value = 1;
    // cfg.slave_pready_random = 1;
    // cfg.slave_pslverr_random = 1;
    // Option-2 randomize the config parameters
    // void'(cfg.randomize());
    uvm_config_db#(kei_vip_apb_config)::set(this,"env.*","cfg", cfg);
    env = kei_vip_apb_env::type_id::create("env", this);
  endfunction
endclass

class kei_vip_apb_base_test_sequence extends uvm_sequence #(kei_vip_apb_transfer);
  bit[31:0] mem[bit[31:0]];
  `uvm_object_utils(kei_vip_apb_base_test_sequence)
  function new(string name=""); 
    super.new(name);
  endfunction : new
  function bit check_mem_data(bit[31:0] addr, bit[31:0] data);
    if(mem.exists(addr)) begin
      if(data != mem[addr]) begin
        `uvm_error("CMPDATA", $sformatf("addr 32'h%8x, READ DATA expected 32'h%8x != actual 32'h%8x", addr, mem[addr], data))
        return 0;
      end
      else begin
        `uvm_info("CMPDATA", $sformatf("addr 32'h%8x, READ DATA 32'h%8x comparing success!", addr, data), UVM_LOW)
        return 1;
      end
    end
    else begin
      if(data != DEFAULT_READ_VALUE) begin
        `uvm_error("CMPDATA", $sformatf("addr 32'h%8x, READ DATA expected 32'h%8x != actual 32'h%8x", addr, DEFAULT_READ_VALUE, data))
        return 0;
      end
      else begin
        `uvm_info("CMPDATA", $sformatf("addr 32'h%8x, READ DATA 32'h%8x comparing success!", addr, data), UVM_LOW)
        return 1;
      end
    end
  endfunction: check_mem_data

  task wait_reset_release();
    @(negedge kei_vip_apb_tb.rstn);
    @(posedge kei_vip_apb_tb.rstn);
  endtask

  task wait_cycles(int n);
    repeat(n) @(posedge kei_vip_apb_tb.clk);
  endtask

  function bit[31:0] get_rand_addr();
    bit[31:0] addr;
    void'(std::randomize(addr) with {addr[31:12] == 0; addr[1:0] == 0;addr != 0;});
    return addr;
  endfunction
endclass

class kei_vip_apb_single_transaction_sequence extends kei_vip_apb_base_test_sequence;
  kei_vip_apb_master_single_write_sequence single_write_seq;
  kei_vip_apb_master_single_read_sequence single_read_seq;
  kei_vip_apb_master_write_read_sequence write_read_seq;
  rand int test_num = 100;
  constraint cstr{
    soft test_num == 100;
  }
  `uvm_object_utils(kei_vip_apb_single_transaction_sequence)    
  function new(string name=""); 
    super.new(name);
  endfunction : new
  task body();
    bit[31:0] addr;
    this.wait_reset_release();
    this.wait_cycles(10);

    // TEST continous write transaction
    `uvm_info(get_type_name(), "TEST continous write transaction...", UVM_LOW)
    repeat(test_num) begin
      addr = this.get_rand_addr();
      `uvm_do_with(single_write_seq, {addr == local::addr; data == local::addr;})
      mem[addr] = addr;
    end

    // TEST continous read transaction
    `uvm_info(get_type_name(), "TEST continous read transaction...", UVM_LOW)
    repeat(test_num) begin
      addr = this.get_rand_addr();
      `uvm_do_with(single_read_seq, {addr == local::addr;})
      if(single_read_seq.trans_status == OK)
        void'(this.check_mem_data(addr, single_read_seq.data));
    end

    // TEST read transaction after write transaction
    `uvm_info(get_type_name(), "TEST read transaction after write transaction...", UVM_LOW)
    repeat(test_num) begin
      addr = this.get_rand_addr();
      `uvm_do_with(single_write_seq, {addr == local::addr; data == local::addr;})
      mem[addr] = addr;
      `uvm_do_with(single_read_seq, {addr == local::addr;})
      if(single_read_seq.trans_status == OK)
        void'(this.check_mem_data(addr, single_read_seq.data));
    end


    // TEST read transaction immediately after write transaction
    `uvm_info(get_type_name(), "TEST read transaction immediately after write transaction", UVM_LOW)
    repeat(test_num) begin
      addr = this.get_rand_addr();
      `uvm_do_with(write_read_seq, {addr == local::addr; data == local::addr;})
      mem[addr] = addr;
      if(write_read_seq.trans_status == OK)
        void'(this.check_mem_data(addr, write_read_seq.data));
    end

    // TODO
    // TEST write twice and read immediately with burst transaction
    `uvm_info(get_type_name(), "TEST write twice and read immediately with burst transaction...", UVM_LOW)
    repeat(test_num) begin
      addr = this.get_rand_addr();
      // WRITE first time
      `uvm_do_with(req,  {trans_kind == WRITE; 
                    addr == local::addr; 
                    data == local::addr;
                    idle_cycles == 0;
                   })
      mem[addr] = addr;
      get_response(rsp);
      // WRITE second time
      `uvm_do_with(req,  {trans_kind == WRITE; 
                    addr == local::addr; 
                    data == local::addr<<2;
                    idle_cycles == 0;
                   })
      mem[addr] = addr<<2;
      get_response(rsp);
      // READ immediately after WRITE
      `uvm_do_with(req, {trans_kind == READ; addr == local::addr;})
      get_response(rsp);
      if(rsp.trans_status == OK)
      void'(this.check_mem_data(addr, rsp.data));
    end

    this.wait_cycles(10);
  endtask
endclass: kei_vip_apb_single_transaction_sequence

class kei_vip_apb_single_transaction_test extends kei_vip_apb_base_test;
  `uvm_component_utils(kei_vip_apb_single_transaction_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    kei_vip_apb_single_transaction_sequence seq = new();
    phase.raise_objection(this);
    super.run_phase(phase);
    seq.start(env.mst.sequencer);
    phase.drop_objection(this);
  endtask
endclass: kei_vip_apb_single_transaction_test

class kei_vip_apb_burst_transaction_sequence extends kei_vip_apb_base_test_sequence;
  kei_vip_apb_master_burst_write_sequence burst_write_seq;
  kei_vip_apb_master_burst_read_sequence burst_read_seq;
  rand int test_num = 100;
  constraint cstr{
    soft test_num == 100;
  }
  `uvm_object_utils(kei_vip_apb_burst_transaction_sequence)
  function new(string name=""); 
    super.new(name);
  endfunction : new
  task body();
    bit[31:0] addr;
    this.wait_reset_release();
    this.wait_cycles(10);

    // TEST continous write transaction
    repeat(test_num) begin
      addr = this.get_rand_addr();
      `uvm_do_with(burst_write_seq, {addr == local::addr;})
      foreach(burst_write_seq.data[i]) begin
        mem[addr+(i<<2)] = burst_write_seq.data[i];
      end
      `uvm_do_with(burst_read_seq, {addr == local::addr; data.size() == burst_write_seq.data.size();})
      foreach(burst_read_seq.data[i]) begin
        void'(this.check_mem_data(addr+(i<<2), burst_write_seq.data[i]));
      end
    end

    this.wait_cycles(10);
  endtask
endclass: kei_vip_apb_burst_transaction_sequence

class kei_vip_apb_burst_transaction_test extends kei_vip_apb_base_test;
  `uvm_component_utils(kei_vip_apb_burst_transaction_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  task run_phase(uvm_phase phase);
    kei_vip_apb_burst_transaction_sequence seq = new();
    phase.raise_objection(this);
    super.run_phase(phase);
    seq.start(env.mst.sequencer);
    phase.drop_objection(this);
  endtask
endclass: kei_vip_apb_burst_transaction_test



`endif // KEI_VIP_APB_TESTS_SV

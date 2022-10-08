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
`timescale 1ps/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "kei_vip_apb_tests.svh"
`include "kei_vip_apb_if.sv"
module kei_vip_apb_tb;
  bit clk, rstn;
  initial begin
    fork
      begin 
        forever #5ns clk = !clk;
      end
      begin
        #100ns;
        rstn <= 1'b1;
        #100ns;
        rstn <= 1'b0;
        #100ns;
        rstn <= 1'b1;
      end
    join_none
  end

  kei_vip_apb_if intf(clk, rstn);

  initial begin
    uvm_config_db#(virtual kei_vip_apb_if)::set(uvm_root::get(), "uvm_test_top.env.mst", "vif", intf);
    uvm_config_db#(virtual kei_vip_apb_if)::set(uvm_root::get(), "uvm_test_top.env.slv", "vif", intf);
    run_test("kei_vip_apb_single_transaction_test");
  end

endmodule

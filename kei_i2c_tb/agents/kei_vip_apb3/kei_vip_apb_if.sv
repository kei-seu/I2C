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
`ifndef KEI_VIP_APB_IF_SV
`define KEI_VIP_APB_IF_SV

interface kei_vip_apb_if (input clk, input rstn);

  logic [31:0] paddr;
  logic        pwrite;
  logic        psel;
  logic        penable;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;
  logic        pslverr;

  // Control flags
  bit                has_checks = 1;
  bit                has_coverage = 1;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  // Actual Signals 
  // USER: Add interface signals

  clocking cb_mst @(posedge clk);
    // USER: Add clocking block detail
    default input #1ps output #1ps;
    output paddr, pwrite, psel, penable, pwdata;
    input prdata, pready, pslverr;
  endclocking : cb_mst

  clocking cb_slv @(posedge clk);
   // USER: Add clocking block detail
    default input #1ps output #1ps;
    input paddr, pwrite, psel, penable, pwdata;
    output prdata, pready, pslverr;
  endclocking : cb_slv

  clocking cb_mon @(posedge clk);
   // USER: Add clocking block detail
    default input #1ps output #1ps;
    input paddr, pwrite, psel, penable, pwdata, prdata, pready, pslverr;
  endclocking : cb_mon

  // Coverage and assertions to be implemented here.
  // USER: Add assertions/coverage here

  // APB command covergroup
  covergroup cg_kei_vip_apb_command @(posedge clk iff rstn);
    pwrite: coverpoint pwrite{
      type_option.weight = 0;
      bins write = {1};
      bins read  = {0};

    }
    psel : coverpoint psel{
      type_option.weight = 0;
      bins sel   = {1};
      bins unsel = {0};
    }
    cmd  : cross pwrite, psel{
      bins cmd_write = binsof(psel.sel) && binsof(pwrite.write);
      bins cmd_read  = binsof(psel.sel) && binsof(pwrite.read);
      bins cmd_idle  = binsof(psel.unsel);
    }
  endgroup: cg_kei_vip_apb_command

  // APB transaction timing group
  covergroup cg_kei_vip_apb_trans_timing_group @(posedge clk iff rstn);
    psel: coverpoint psel{
      bins single   = (0 => 1 => 1  => 0); 
      bins burst_2  = (0 => 1 [*4]  => 0); 
      bins burst_4  = (0 => 1 [*8]  => 0); 
      bins burst_8  = (0 => 1 [*16] => 0); 
      bins burst_16 = (0 => 1 [*32] => 0); 
      bins burst_32 = (0 => 1 [*64] => 0); 
    }
    penable: coverpoint penable {
      bins single = (0 => 1 => 0 [*2:10] => 1);
      bins burst  = (0 => 1 => 0         => 1);
    }
  endgroup: cg_kei_vip_apb_trans_timing_group

  // APB write & read order group
  covergroup cg_kei_vip_apb_write_read_order_group @(posedge clk iff (rstn && penable));
    write_read_order: coverpoint pwrite{
      bins write_write = (1 => 1);
      bins write_read  = (1 => 0);
      bins read_write  = (0 => 1);
      bins read_read   = (0 => 0);
    } 
  endgroup: cg_kei_vip_apb_write_read_order_group

  initial begin : coverage_control
    if(has_coverage) begin
      automatic cg_kei_vip_apb_command cg0 = new();
      automatic cg_kei_vip_apb_trans_timing_group cg1 = new();
      automatic cg_kei_vip_apb_write_read_order_group cg2 = new();
    end
  end

  // PROPERY ASSERTION
  property p_paddr_no_x;
    @(posedge clk) psel |-> !$isunknown(paddr);
  endproperty: p_paddr_no_x
  assert property(p_paddr_no_x) else `uvm_error("ASSERT", "PADDR is unknown when PSEL is high")

  property p_psel_rose_next_cycle_penable_rise;
    @(posedge clk) $rose(psel) |=> $rose(penable);
  endproperty: p_psel_rose_next_cycle_penable_rise
  assert property(p_psel_rose_next_cycle_penable_rise) else `uvm_error("ASSERT", "PENABLE not rose after 1 cycle PSEL rose")

  property p_penable_rose_next_cycle_fall;
    @(posedge clk) penable && pready |=> $fell(penable);
  endproperty: p_penable_rose_next_cycle_fall
  assert property(p_penable_rose_next_cycle_fall) else `uvm_error("ASSERT", "PENABLE not fall after 1 cycle PENABLE rose")

  property p_pwdata_stable_during_trans_phase;
    @(posedge clk) ((psel && !penable) ##1 (psel && penable)) |-> $stable(pwdata);
  endproperty: p_pwdata_stable_during_trans_phase
  assert property(p_pwdata_stable_during_trans_phase) else `uvm_error("ASSERT", "PWDATA not stable during transaction phase")

  property p_paddr_stable_until_next_trans;
    logic[31:0] addr1, addr2;
    @(posedge clk) first_match(($rose(penable),addr1=paddr) ##1 ((psel && !penable)[=1],addr2=$past(paddr))) |-> addr1 == addr2;
  endproperty: p_paddr_stable_until_next_trans
  assert property(p_paddr_stable_until_next_trans) else `uvm_error("ASSERT", "PADDR not stable until next transaction start")

  property p_pwrite_stable_until_next_trans;
    logic pwrite1, pwrite2;
    @(posedge clk) first_match(($rose(penable),pwrite1=pwrite) ##1 ((psel && !penable)[=1],pwrite2=$past(pwrite))) |-> pwrite1 == pwrite2;
  endproperty: p_pwrite_stable_until_next_trans
  assert property(p_pwrite_stable_until_next_trans) else `uvm_error("ASSERT", "PWRITE not stable until next transaction start")

  property p_prdata_available_once_penable_rose;
    @(posedge clk) penable && !pwrite && pready |-> !$stable(prdata);
  endproperty: p_prdata_available_once_penable_rose
  // @Lusang NOTE:: 
  // disable the property below since it conflicts with long
  // term hold PRDATA from the same address
  //assert property(p_prdata_available_once_penable_rose) else `uvm_error("ASSERT", "PRDATA not available once PENABLE rose")

  // PROPERTY COVERAGE
  property p_write_during_nonburst_trans;
    @(posedge clk) $rose(penable) |-> pwrite throughout (##1 (!penable)[*2] ##1 penable[=1]);
  endproperty: p_write_during_nonburst_trans
  cover property(p_write_during_nonburst_trans);

  property p_write_during_burst_trans;
    @(posedge clk) $rose(penable) |-> pwrite throughout (##2 penable);
  endproperty: p_write_during_burst_trans
  cover property(p_write_during_burst_trans);

  property p_write_read_burst_trans;
    logic[31:0] addr;
    @(posedge clk) ($rose(penable) && pwrite, addr=paddr) |-> (##2 ($rose(penable) && !pwrite && addr==paddr)); 
  endproperty: p_write_read_burst_trans
  cover property(p_write_read_burst_trans);

  property p_write_twice_read_burst_trans;
    logic[31:0] addr;
    @(posedge clk) ($rose(penable) && pwrite, addr=paddr) |-> (##2 ($rose(penable) && pwrite && addr==paddr) ##2 ($rose(penable) && !pwrite && addr==paddr) );
  endproperty: p_write_twice_read_burst_trans
  cover property(p_write_twice_read_burst_trans);

  property p_read_during_nonburst_trans;
    @(posedge clk) $rose(penable) |-> !pwrite throughout (##1 (!penable)[*2] ##1 penable[=1]);
  endproperty: p_read_during_nonburst_trans
  cover property(p_read_during_nonburst_trans);

  property p_read_during_burst_trans;
    @(posedge clk) $rose(penable) |-> !pwrite throughout (##2 penable);
  endproperty: p_read_during_burst_trans
  cover property(p_read_during_burst_trans);

  property p_read_write_read_burst_trans;
    logic[31:0] addr;
    @(posedge clk) ($rose(penable) && pwrite, addr=paddr) |-> ##2 ($rose(penable) && !pwrite && addr==paddr);  
  endproperty: p_read_write_read_burst_trans
  cover property(p_read_write_read_burst_trans);


  initial begin: assertion_control
    fork
      forever begin
        wait(rstn == 0);
        $assertoff();
        wait(rstn == 1);
        $asserton();
      end
    join_none
  end

endinterface : kei_vip_apb_if

`endif // KEI_VIP_APB_IF_SV

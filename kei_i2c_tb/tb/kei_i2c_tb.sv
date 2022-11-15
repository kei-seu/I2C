`timescale 1ns/1ps
module kei_i2c_tb;
  parameter real i2c_clk_peroid = 10ns; // 100MHz
  parameter real apb_clk_peroid = 4ns;  // 250MHz
  parameter real ref_clk_peroid = 1ns;  // 1GHz

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import kei_i2c_pkg::*;

  logic i2c_clk;
  logic i2c_rstn;
  logic apb_clk;
  logic apb_rstn;
  logic ref_clk;
  wire  i2c_sda;
  wand  i2c_scl;
  logic i2c_data_oe;
  logic i2c_clk_oe;

  // KEI I2C DUT instantiation
  kei_DW_apb_i2c dut (
    // Interrupt ports
    .ic_start_det_intr(top_if.intr[IC_START_DET_INTR_ID]),
    .ic_stop_det_intr(top_if.intr[IC_STOP_DET_INTR_ID]),
    .ic_activity_intr(top_if.intr[IC_ACTIVITY_INTR_ID]),
    .ic_rx_done_intr(top_if.intr[IC_RX_DONE_INTR_ID]),
    .ic_tx_abrt_intr(top_if.intr[IC_TX_ABRT_INTR_ID]),
    .ic_rd_req_intr(top_if.intr[IC_RD_REQ_INTR_ID]),
    .ic_tx_empty_intr(top_if.intr[IC_TX_EMPTY_INTR_ID]),
    .ic_tx_over_intr(top_if.intr[IC_TX_OVER_INTR_ID]),
    .ic_rx_full_intr(top_if.intr[IC_RX_FULL_INTR_ID]),
    .ic_rx_over_intr(top_if.intr[IC_RX_OVER_INTR_ID]),
    .ic_rx_under_intr(top_if.intr[IC_RX_UNDER_INTR_ID]),
    .ic_gen_call_intr(top_if.intr[IC_GEN_CALL_INTR_ID]),
    .ic_current_src_en(top_if.ic_current_src_en), // NO USED
    //APB Slave I/O Signals
    .pclk(apb_clk),
    .presetn(apb_rstn),
    .psel(apb_if.psel),
    .penable(apb_if.penable),
    .pwrite(apb_if.pwrite),
    .paddr(apb_if.paddr[7:0]),
    .pwdata(apb_if.pwdata),
    .prdata(apb_if.prdata),
    .pready(apb_if.pready),
    .pslverr(apb_if.pslverr),
    // DEBUG ports
    .debug_s_gen(top_if.debug_s_gen),
    .debug_p_gen(top_if.debug_p_gen),
    .debug_data(top_if.debug_data),
    .debug_addr(top_if.debug_addr),
    .debug_rd(top_if.debug_rd),
    .debug_wr(top_if.debug_wr),
    .debug_hs(top_if.debug_hs),
    .debug_master_act(top_if.debug_master_act),
    .debug_slave_act(top_if.debug_slave_act),
    .debug_addr_10bit(top_if.debug_addr_10bit),
    .debug_mst_cstate(top_if.debug_mst_cstate),
    .debug_slv_cstate(top_if.debug_slv_cstate),
    // I2C clock/reset and I2C serial ports
    .ic_clk(i2c_clk),
    .ic_rst_n(i2c_rstn),
    .ic_clk_in_a(i2c_scl),
    .ic_data_in_a(i2c_sda),
    .ic_clk_oe(i2c_clk_oe),
    .ic_data_oe(i2c_data_oe),
    .ic_en(top_if.ic_en)
  );


  initial begin 
    i2c_clk <= 0;
    apb_clk <= 0;
    ref_clk <= 0;
    fork
      forever begin
        #(i2c_clk_peroid/2.0) i2c_clk <= !i2c_clk;
      end
      forever begin
        #(apb_clk_peroid/2.0) apb_clk <= !apb_clk;
      end
      forever begin
        #(ref_clk_peroid/2.0) ref_clk <= !ref_clk;
      end
    join_none
  end
  
  // reset trigger
  initial begin 
    #10ns; 
    i2c_rstn <= 0;
    apb_rstn <= 0;
    fork
      begin
        repeat(10) @(posedge i2c_clk);
        i2c_rstn <= 1;
      end
      begin
        repeat(25) @(posedge apb_clk);
        apb_rstn <= 1;
      end
    join_none
  end

  kei_vip_apb_if apb_if(apb_clk, apb_rstn);

  kei_vip_i2c_if i2c_if(ref_clk);
  assign i2c_if.RST = !i2c_rstn;

  assign i2c_sda = i2c_data_oe ? 1'b0 : 1'bz;
  assign i2c_sda = i2c_if.SDA === 1'b0 ? 1'b0 : 1'bz;
  pullup(i2c_sda);
  assign i2c_if.SDA = i2c_data_oe ? 1'b0 : 1'bz;

  assign i2c_scl = i2c_clk_oe ? 1'b0 : 1'bz;
  assign i2c_scl = i2c_if.SCL === 1'b0 ? 1'b0 : 1'bz;
  pullup(i2c_scl);
  assign i2c_if.SCL = i2c_clk_oe ? 1'b0 : 1'bz;

  kei_i2c_if top_if();
  assign top_if.i2c_clk  = i2c_clk;
  assign top_if.i2c_rstn = i2c_rstn;
  assign top_if.apb_clk  = apb_clk;
  assign top_if.apb_rstn = apb_rstn;
  
  kei_i2c_backdoor_if backdoor_if(i2c_clk);

  initial begin 
    // do interface configuration from top tb (HW) to verification env (SW)
    uvm_config_db#(virtual kei_i2c_if)::set(uvm_root::get(), "uvm_test_top.env", "vif", top_if);
    uvm_config_db#(virtual kei_i2c_backdoor_if)::set(uvm_root::get(), "uvm_test_top.env", "backdoor_vif", backdoor_if);
    uvm_config_db#(virtual kei_vip_apb_if)::set(uvm_root::get(), "uvm_test_top.env.apb_mst*", "vif", apb_if);
    uvm_config_db#(virtual kei_vip_i2c_if)::set(uvm_root::get(), "uvm_test_top.env", "i2c_vif", i2c_if);
    run_test("kei_i2c_quick_reg_access_test");
  end

endmodule

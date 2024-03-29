
`ifndef KEI_I2C_IF_SV
`define KEI_I2C_IF_SV
interface kei_i2c_if;
  import kei_i2c_pkg::IC_INTR_NUM;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  logic i2c_clk;
  logic i2c_rstn;
  logic apb_clk;
  logic apb_rstn;

  // I2C interrupt ports 
  logic [IC_INTR_NUM-1 :0] intr;

  // I2C debug ports
  logic       debug_s_gen;
  logic       debug_p_gen;
  logic       debug_data;
  logic       debug_addr;
  logic       debug_rd;
  logic       debug_wr;
  logic       debug_hs;
  logic       debug_master_act;
  logic       debug_slave_act;
  logic       debug_addr_10bit;
  logic [4:0] debug_mst_cstate;
  logic [3:0] debug_slv_cstate;

  // I2C enable flag
  logic       ic_en;
  logic       ic_current_src_en;


  // TODO
  // user signals to be declared below

  clocking apb_ck @(posedge apb_clk);
    default input #1ps output #1ps;
  endclocking

  clocking i2c_ck @(posedge i2c_clk);
    default input #1ps output #1ps;
  endclocking

  task wait_apb(int n);
    repeat(n) @(apb_ck);
  endtask

  task wait_i2c(int n);
    repeat(n) @(i2c_ck);
  endtask

  task wait_intr(int id = -1);
    if(id > IC_INTR_NUM -1) begin
      `uvm_error("OUTRANGE", $sformatf("Interrupt id [%0d] is out of range [%0d : 0]", id, IC_INTR_NUM-1))
    end
    else begin
      if(id >= 0)
        @(intr iff intr[id] === 1'b1);
      else
        @(intr iff intr >= 0);
    end
  endtask

  function int get_intr(int id);
    if(id > IC_INTR_NUM -1) begin
      `uvm_error("OUTRANGE", $sformatf("Interrupt id [%0d] is out of range [%0d : 0]", id, IC_INTR_NUM-1))
      return -1;
    end
    else 
      return intr[id]; 
  endfunction

  task wait_rstn_release();
    fork
      @(posedge apb_rstn);
      @(posedge i2c_rstn);
    join
  endtask

endinterface
`endif // KEI_I2C_IF_SV

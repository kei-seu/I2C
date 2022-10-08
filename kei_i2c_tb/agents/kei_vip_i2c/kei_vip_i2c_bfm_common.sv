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
`ifndef KEI_VIP_I2C_BFM_COMMON_SV
`define KEI_VIP_I2C_BFM_COMMON_SV

class kei_vip_i2c_bfm_common extends uvm_object;

  kei_vip_i2c_vif i2c_if;
  uvm_component comp;
  kei_vip_i2c_configuration cfg;

  `uvm_object_utils_begin(kei_vip_i2c_bfm_common)
  `uvm_object_utils_end
  int unsigned   i2c_clk_high=0;  //clk high level time
  int unsigned   i2c_clk_low=0;   //clk low level time
  int unsigned   re_sta_su=0;     //repeat start setup time
  int unsigned   sto_su=0;        //stop setup time
  int unsigned   sta_hd=0;        //start or repeat start hold time
  int unsigned   dat_hd=0;        //data hold time,
  int unsigned   tbuf_time=0;     //bus free time between a stop and


  extern function new(string name = "kei_vip_i2c_bfm_common");

  extern virtual function void assign_vif(kei_vip_i2c_vif i2c_if);

  /** source specific event with control variable */
  extern virtual task source_event(event sv_e, uvm_event uvm_e);

  extern virtual task reconfigure_via_task(kei_vip_i2c_configuration cfg);

  //extern virtual task send_xact(kei_vip_i2c_transaction trans, string type_name);

//  extern virtual task collect_response_from_vif(kei_vip_i2c_transaction trans);
  extern task wait_data_hd_time();
  extern task clk_low_offset_gen();
  
  
  
  
  extern virtual task wait_for_reset();
endclass

function kei_vip_i2c_bfm_common::new(string name = "kei_vip_i2c_bfm_common");
  super.new(name);
endfunction

function void kei_vip_i2c_bfm_common::assign_vif(kei_vip_i2c_vif i2c_if);
  this.i2c_if = i2c_if;
endfunction

task kei_vip_i2c_bfm_common::source_event(event sv_e, uvm_event uvm_e);
  forever begin
    @(sv_e);
    uvm_e.trigger();
  end
endtask

task kei_vip_i2c_bfm_common::reconfigure_via_task(kei_vip_i2c_configuration cfg);
  this.cfg = cfg;
endtask

task  kei_vip_i2c_bfm_common::clk_low_offset_gen();
    case (cfg.bus_speed)
    STANDARD_MODE:  
        begin
            i2c_clk_high = cfg.scl_high_time_ss;
            i2c_clk_low  = cfg.scl_low_time_ss;
            re_sta_su    = cfg.min_su_sta_time_ss;
            sto_su       = cfg.min_su_sto_time_ss;
            sta_hd       = cfg.min_hd_sta_time_ss;
            dat_hd       = cfg.min_hd_dat_time_ss;
            tbuf_time    = cfg.tbuf_time_ss;        
        end
    FAST_MODE: 
        begin
            i2c_clk_high = cfg.scl_high_time_fs;
            i2c_clk_low  = cfg.scl_low_time_fs;
            re_sta_su    = cfg.min_su_sta_time_fs;
            sto_su       = cfg.min_su_sto_time_fs;
            sta_hd       = cfg.min_hd_sta_time_fs;
            dat_hd       = cfg.min_hd_dat_time_fs;
            tbuf_time    = cfg.tbuf_time_fs;
        end
    HIGHSPEED_MODE:  
        begin
            i2c_clk_high = cfg.scl_high_time_hs;
            i2c_clk_low  = cfg.scl_low_time_hs;  
            re_sta_su    = cfg.min_su_sta_time_hs;
            sto_su       = cfg.min_su_sto_time_hs;
            sta_hd       = cfg.min_hd_sta_time_hs;
            dat_hd       = cfg.min_hd_dat_time_hs;
            tbuf_time    = cfg.tbuf_time_hs;
        end
    FAST_MODE_PLUS:  
        begin
            i2c_clk_high = cfg.scl_high_time_fm_plus;
            i2c_clk_low  = cfg.scl_low_time_fm_plus;
            re_sta_su    = cfg.min_su_sta_time_fm_plus;
            sto_su       = cfg.min_su_sto_time_fm_plus;
            sta_hd       = cfg.min_hd_sta_time_fm_plus;
            dat_hd       = cfg.min_hd_dat_time_fm_plus;
            tbuf_time    = cfg.tbuf_time_fm_plus;
        end
    default:  
        begin
            i2c_clk_high = cfg.scl_high_time_ss;
            i2c_clk_low  = cfg.scl_low_time_ss;
            re_sta_su    = cfg.min_su_sta_time_ss;
            sto_su       = cfg.min_su_sto_time_ss;
            sta_hd       = cfg.min_hd_sta_time_ss;
            dat_hd       = cfg.min_hd_dat_time_ss;
            tbuf_time    = cfg.tbuf_time_ss;      
        end
  endcase
endtask : clk_low_offset_gen

task  kei_vip_i2c_bfm_common::wait_data_hd_time(); 
  for(int i=0; i<=dat_hd;i++)
    @(posedge i2c_if.CLK);
endtask : wait_data_hd_time

//task kei_vip_i2c_bfm_common::send_xact(kei_vip_i2c_transaction trans, string type_name);
  // Child class to implement
//endtask

//task kei_vip_i2c_bfm_common::collect_response_from_vif(kei_vip_i2c_transaction trans);
  // Child class to implement
//endtask

task kei_vip_i2c_bfm_common::wait_for_reset();
  // wait for reset release
  @(negedge i2c_if.RST);
  //wait(i2c_if.`I2C_MASTER_MODPORT.RST === 'b0);
endtask
`endif // KEI_VIP_I2C_BFM_COMMON_SV


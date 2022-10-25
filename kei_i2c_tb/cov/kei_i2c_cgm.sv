

`ifndef KEI_I2C_CGM_SV
`define KEI_I2C_CGM_SV

// Coverage Model
class kei_i2c_cgm extends uvm_component;

  // Analysis import declarion below
  uvm_analysis_imp_apb_master #(kei_vip_apb_transfer,kei_i2c_cgm) apb_trans_observed_imp;
	uvm_analysis_imp_i2c_slave #(kei_vip_i2c_slave_transaction,kei_i2c_cgm) i2c_trans_observed_imp;
  
  // Events
  uvm_event kei_i2c_field_access_bd_e; //  register field backdoor access event
  uvm_event kei_i2c_field_access_fd_e; //  register field frontdoor access event
  
  kei_i2c_config cfg;
  ral_block_kei_i2c rgm;
  virtual kei_i2c_if vif;
  
  /** variable to enable and disable coverage model */ 
  bit enable;
  
  `uvm_component_utils(kei_i2c_cgm)
  
  // TODO
  // Covergroup definition below
  
  //--------------------------------------------------
  // T2 I2C PROTOCOL
  //--------------------------------------------------
  // T2.1 target and slave address
  covergroup target_address_and_slave_address_cg with function sample(bit[9:0]addr, string field);
    option.name = "target_address_and_slave_address_cg";
    TAR_BITS10: coverpoint addr[9:7] iff(field == "TAR"){
      wildcard bins range1 = {3'b1xx};
      wildcard bins range2 = {3'b0xx};
    }

    TAR_BITS7: coverpoint addr[6:0] iff(field == "TAR"){
      wildcard bins range1 = {7'b1xx_xxxx};
      wildcard bins range2 = {7'b0xx_xxxx};
    }

    SAR_BITS10: coverpoint addr[9:7] iff(field == "SAR"){
      wildcard bins range1 = {3'b1xx};
      wildcard bins range2 = {3'b0xx};
    }

    SAR_BITS7: coverpoint addr[6:0] iff(field == "SAR"){
      wildcard bins range1 = {7'b1xx_xxxx};
      wildcard bins range2 = {7'b0xx_xxxx};
    }

  endgroup

  // T2.2 speed modes
  covergroup speed_modes_cg with function sample(bit[15:0] val, string field);
    option.name = "speed_modes_cg";
    SPEED: coverpoint val iff(field == "SPEED") {
      bins standard = {1};
      bins fast = {2};
      bins high = {3};
    }
    
    // In SS mode, the frequency of SCL is 0 - 100 Kbs
    // To ensure that there is no 0 rate in the actual situation and the sim
    // does not time out, we just test 50 - 100 Kbs
    // Refer to the period of i2c_clk 100 MHz
    // Fastest:
    // The count value is 100MHz / 100Kbs = 1000 = SS_SCL_HCNT + SS_SCL_LCNT
    // Slowest:
    // The count value is 100MHz / 50Kbs = 2000 = SS_SCL_HCNT + SS_SCL_LCNT
    SS_SCL_HCNT: coverpoint val iff(field == "SS_SCL_HCNT") {
      bins max = {[900:1100]};
      bins min = {[400:600]};
    }
    SS_SCL_LCNT: coverpoint val iff(field == "SS_SCL_LCNT") {
      bins max = {[900:1100]};
      bins min = {[400:600]};
    }
    
     // In FS mode, the frequency of SCL is <= 400 Kbs
    // To ensure frequency FS > SS, we just test 100 - 400 Kbs
    // Refer to the period of i2c_clk 100MHz
    // Fastest:
    // The count value is 100MHz / 400Kbs = 250 = FS_SCL_HCNT + FS_SCL_LCNT
    // Slowest:
    // The count value is 100MHz / 100Kbs = 1000 = FS_SCL_HCNT + FS_SCL_LCNT
    FS_SCL_HCNT: coverpoint val iff(field == "FS_SCL_HCNT") {
      bins max = {[400:600]};
      bins min = {[100:150]};
    }
    FS_SCL_LCNT: coverpoint val iff(field == "FS_SCL_LCNT") {
      bins max = {[400:600]};
      bins min = {[100:150]};
    }
    
    // In HS mode, the frequency of SCL is <= 3.4 Mbs
    // To ensure frequency of HS, we test 1 - 3.4 Mbs
    // Refer to the period of i2c_clk 100MHz
    // Fastest:
    // The count value is 100MHz / 3.4Mbs ~= 30 = HS_SCL_HCNT + HS_SCL_LCNT
    // Slowest:
    // The count value is 100MHz / 1Mbs = 100 = HS_SCL_HCNT + HS_SCL_LCNT
    HS_SCL_HCNT: coverpoint val iff(field == "HS_SCL_HCNT") {
      bins max = {[40:60]};
      bins min = {[10:20]};
    }
    HS_SCL_LCNT: coverpoint val iff(field == "HS_SCL_LCNT") {
      bins max = {[40:60]};
      bins min = {[10:20]};
    }

  endgroup

  // T2.3 7bits or 10bits addressing
  covergroup bits7_or_bits10_addressing_cg with function sample(bit bits10);
    option.name = "bits7_or_bits10_addressing_cg";
    BITS7_OR_BITS10: coverpoint bits10{
      bins bits7  = {0};
      bins bits10 = {1};
    }
  endgroup

  // T2.4 restart condition
  covergroup restart_condition_cg with function sample(bit rt);
    option.name = "restart_condition_cg";
    RESTART: coverpoint rt {
      bins disabled = {0};
      bins enabled  = {1};
    }
  endgroup

  //--------------------------------------------------
  // T3 I2C MODULE STATUS
  //--------------------------------------------------
  // T3.1 module activity, master activity
  covergroup activity_cg with function sample(bit act, string field);
    option.name = "activity_cg";
    ACTIVITY: coverpoint act iff(field == "ACTIVITY") {
      bins idle = {0};
      bins busy = {1};
    }
    MST_ACTIVITY: coverpoint act iff(field == "MST_ACTIVITY") {
      bins idle = {0};
      bins busy = {1};
    }
  endgroup

  // T3.2 module enable control bit and enabled status bit
  covergroup enabled_cg with function sample(bit en, string field);
    option.name = "enabled_cg";
    ENABLE_CTRL: coverpoint en iff(field == "ENABLE_CTRL") {
      bins dis = {0};
      bins en = {1};
    }
    ENABLE_STATUS: coverpoint en iff(field == "ENABLE_STATUS") {
      bins dis = {0};
      bins en = {1};
    }
  endgroup

  //--------------------------------------------------
  // T4 I2C DATA BUFFER
  //--------------------------------------------------
  // T4.1 TX FIFO empty/full/overflow
  covergroup tx_fifo_status_cg with function sample(bit empty, bit nfull);
    option.name = "tx_fifo_status_cg";
    EMPTY: coverpoint empty {
      bins empty = {1};
      bins not_empty = {0};
    }
    NOT_FULL: coverpoint nfull {
      bins not_full = {1};
      bins full = {0};
    }
  endgroup

  // T4.2 RX FIFO empty/full/overflow
  covergroup rx_fifo_status_cg with function sample(bit full, bit nempty);
    option.name = "rx_fifo_status_cg";
    FULL: coverpoint full {
      bins full = {1};
      bins not_full = {0};
    }
    NOT_EMPTY: coverpoint nempty {
      bins not_empty = {1};
      bins empty = {0};
    }
  endgroup

  //--------------------------------------------------
  // T5 I2C INTERRUPT
  //--------------------------------------------------
  // T5.1 interrupt status registers
  covergroup interrupt_status_cg with function sample(bit[13:0] stat);
    option.name = "interrupt_status_cg";
    STATUS: coverpoint stat{
      wildcard bins MASTER_ON_HOLD = {14'b1x_xxxx_xxxx_xxxx};   
      wildcard bins RESTART_DET    = {14'bx1_xxxx_xxxx_xxxx};   
      wildcard bins GEN_CALL	     = {14'bxx_1xxx_xxxx_xxxx};   
      wildcard bins START_DET		   = {14'bxx_x1xx_xxxx_xxxx};   
      wildcard bins STOP_DET		   = {14'bxx_xx1x_xxxx_xxxx};   
      wildcard bins ACTIVITY		   = {14'bxx_xxx1_xxxx_xxxx};   
      wildcard bins RX_DONE	   	   = {14'bxx_xxxx_1xxx_xxxx};   
      wildcard bins TX_ABRT	   	   = {14'bxx_xxxx_x1xx_xxxx};   
      wildcard bins RD_REQ	  	   = {14'bxx_xxxx_xx1x_xxxx};   
      wildcard bins TX_EMPTY		   = {14'bxx_xxxx_xxx1_xxxx};   
      wildcard bins TX_OVER	  	   = {14'bxx_xxxx_xxxx_1xxx};   
      wildcard bins RX_FULL	  	   = {14'bxx_xxxx_xxxx_x1xx};   
      wildcard bins RX_OVER	   	   = {14'bxx_xxxx_xxxx_xx1x};   
      wildcard bins RX_UNDER  	   = {14'bxx_xxxx_xxxx_xxx1};   
    }
  endgroup
  // T5.2 interrupt clear registers
  covergroup interrupt_clear_cg with function sample(bit clr, string field);
    option.name = "interrupt_clear_cg";
    CLR_INTR      : coverpoint clr iff(field == "CLR_INTR")      { bins clr = {1};}       
    CLR_RX_UNDER  : coverpoint clr iff(field == "CLR_RX_UNDER")  { bins clr = {1};}   
    CLR_RX_OVER   : coverpoint clr iff(field == "CLR_RX_OVER")   { bins clr = {1};}    
    CLR_TX_OVER   : coverpoint clr iff(field == "CLR_TX_OVER")   { bins clr = {1};}    
    CLR_RD_REQ    : coverpoint clr iff(field == "CLR_RD_REQ")    { bins clr = {1};}    
    CLR_TX_ABRT   : coverpoint clr iff(field == "CLR_TX_ABRT")   { bins clr = {1};}    
    CLR_RX_DONE   : coverpoint clr iff(field == "CLR_RX_DONE")   { bins clr = {1};}    
    CLR_ACTIVITY  : coverpoint clr iff(field == "CLR_ACTIVITY")  { bins clr = {1};}   
    CLR_STOP_DET  : coverpoint clr iff(field == "CLR_STOP_DET")  { bins clr = {1};}   
    CLR_START_DET : coverpoint clr iff(field == "CLR_START_DET") { bins clr = {1};}    
    CLR_GEN_CALL  : coverpoint clr iff(field == "CLR_GEN_CALL")  { bins clr = {1};}   
  endgroup

  // T5.3 interrupt hardware output sigals (flags)
  covergroup interrupt_hardware_outputs_cg with function sample(bit[IC_INTR_NUM-1:0] intr);
    option.name = "interrupt_hardware_outputs_cg";
    INTERRUPT: coverpoint intr{
      wildcard bins IC_RX_OVER_INTR_ID    = {12'bxxxx_xxxx_xxx1};
      wildcard bins IC_RX_UNDER_INTR_ID   = {12'bxxxx_xxxx_xx1x};
      wildcard bins IC_TX_OVER_INTR_ID    = {12'bxxxx_xxxx_x1xx};
      wildcard bins IC_TX_ABRT_INTR_ID    = {12'bxxxx_xxxx_1xxx};
      wildcard bins IC_RX_DONE_INTR_ID    = {12'bxxxx_xxx1_xxxx};
      wildcard bins IC_TX_EMPTY_INTR_ID   = {12'bxxxx_xx1x_xxxx};
      wildcard bins IC_ACTIVITY_INTR_ID   = {12'bxxxx_x1xx_xxxx};
      wildcard bins IC_STOP_DET_INTR_ID   = {12'bxxxx_1xxx_xxxx};
      wildcard bins IC_START_DET_INTR_ID  = {12'bxxx1_xxxx_xxxx};
      wildcard bins IC_RD_REQ_INTR_ID     = {12'bxx1x_xxxx_xxxx};
      wildcard bins IC_RX_FULL_INTR_ID    = {12'bx1xx_xxxx_xxxx};
      wildcard bins IC_GEN_CALL_INTR_ID   = {12'b1xxx_xxxx_xxxx};
    }
  endgroup
  // T5.4 TX abort sources 
  covergroup interrupt_tx_abort_sources_cg with function sample(bit[16:0]src);
    option.name = "interrupt_tx_abort_sources_cg";
    ABORT_SOURCES: coverpoint src {
      wildcard bins ABRT_USER_ABRT	      = {17'b1_xxxx_xxxx_xxxx_xxxx};  
      wildcard bins ABRT_SLVRD_INTX	      = {17'bx_1xxx_xxxx_xxxx_xxxx};  
      wildcard bins ABRT_SLV_ARBLOST	    = {17'bx_x1xx_xxxx_xxxx_xxxx};  
      wildcard bins ABRT_SLVFLUSH_TXFIFO  = {17'bx_xx1x_xxxx_xxxx_xxxx};    
      wildcard bins ARB_LOST	            = {17'bx_xxx1_xxxx_xxxx_xxxx};  
      wildcard bins ABRT_MASTER_DIS	      = {17'bx_xxxx_1xxx_xxxx_xxxx};  
      wildcard bins ABRT_10B_RD_NORSTRT	  = {17'bx_xxxx_x1xx_xxxx_xxxx};  
      wildcard bins ABRT_SBYTE_NORSTRT    = {17'bx_xxxx_xx1x_xxxx_xxxx};  
      wildcard bins ABRT_HS_NORSTRT	      = {17'bx_xxxx_xxx1_xxxx_xxxx};  
      wildcard bins ABRT_SBYTE_ACKDET	    = {17'bx_xxxx_xxxx_1xxx_xxxx};  
      wildcard bins ABRT_HS_ACKDET	      = {17'bx_xxxx_xxxx_x1xx_xxxx};  
      wildcard bins ABRT_GCALL_READ	      = {17'bx_xxxx_xxxx_xx1x_xxxx};  
      wildcard bins ABRT_GCALL_NOACK	    = {17'bx_xxxx_xxxx_xxx1_xxxx};  
      wildcard bins ABRT_TXDATA_NOACK	    = {17'bx_xxxx_xxxx_xxxx_1xxx};  
      wildcard bins ABRT_10ADDR2_NOACK    = {17'bx_xxxx_xxxx_xxxx_x1xx}; 	
      wildcard bins ABRT_10ADDR1_NOACK	  = {17'bx_xxxx_xxxx_xxxx_xx1x};   
      wildcard bins ABRT_7B_ADDR_NOACK    = {17'bx_xxxx_xxxx_xxxx_xxx1};  
    }
  endgroup

  //--------------------------------------------------
  // T6 I2C SDA CONTROL
  //--------------------------------------------------
  covergroup sda_control_cg with function sample(bit[7:0]rxh, bit[15:0] txh, bit[7:0] stp, string field);
    option.name = "sda_control_cg";
    RX_HOLD: coverpoint rxh iff(field == "SDA_HOLD"){
      bins MAX = {[100:$]};
      bins NORMAL = {[10:99]};
      bins MIN = {[1:9]};
    }
    TX_HOLD: coverpoint txh iff(field == "SDA_HOLD"){
      bins MAX = {[100:$]};
      bins NORMAL = {[10:99]};
      bins MIN = {[1:9]};
    }
    SDA_SETUP: coverpoint stp iff(field == "SDA_SETUP") {
      bins MAX = {[100:$]};
      bins NORMAL = {[10:99]};
      bins MIN = {[1:9]};
    }
  endgroup

  //--------------------------------------------------
  // T7 I2C TIMEOUT COUNTER
  //--------------------------------------------------
  covergroup timeout_counter_cg with function sample(bit[3:0] cnt);
    option.name = "timeout_counter_cg";
    TIMEOUT_COUNTER: coverpoint cnt {
      bins MAX = {[10:$]};
      bins NORMAL = {[4:9]};
      bins MIN = {[1:3]};
    }
  endgroup
  
  function new(string name = "kei_i2c_cgm", uvm_component parent = null);
    super.new(name, parent);
    
    //Coverage instances
    target_address_and_slave_address_cg = new();
    speed_modes_cg = new();
    bits7_or_bits10_addressing_cg = new();
    restart_condition_cg = new();
    activity_cg = new();
    enabled_cg = new();
    tx_fifo_status_cg = new();
    rx_fifo_status_cg = new();
    interrupt_status_cg = new();
    interrupt_clear_cg = new();
    interrupt_hardware_outputs_cg = new();
    interrupt_tx_abort_sources_cg = new();
    sda_control_cg = new();
    timeout_counter_cg = new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // TLM port instances
    i2c_trans_observed_imp = new("i2c_trans_observed_imp",this);
    apb_trans_observed_imp = new("apb_trans_observed_imp",this);
    
    // Get global uvm event
    kei_i2c_field_access_bd_e = uvm_event_pool::get_global("kei_i2c_field_access_bd_e");
    kei_i2c_field_access_fd_e = uvm_event_pool::get_global("kei_i2c_field_access_fd_e");
    
    if(!uvm_config_db#(kei_i2c_config)::get(this,"","cfg",cfg))
      begin
        `uvm_error("build_phase","Unable to get kei_i2c_config from uvm_config_db")
      end
    rgm = cfg.rgm;
    vif = cfg.vif;
    enable = cfg.coverage_model_enable;
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    do_sample_reg();
    do_sample_signals();
  endtask
  
  virtual function void write_apb_master(kei_vip_apb_transfer tr);
    uvm_reg r;
    if(tr.trans_status == kei_vip_apb_pkg::ERROR) return;
    r = cfg.rgm.default_map.get_reg_by_offset(tr.addr);
    kei_i2c_field_access_fd_e.trigger(r);
  endfunction
  
  virtual function void write_i2c_slave(kei_vip_i2c_slave_transaction tr);
    // TODO
  endfunction
  
  virtual task do_sample_reg();
    uvm_object tmp;
    uvm_reg r;
    fork
      forever begin
        wait(enable);
        fork
          kei_i2c_field_access_fd_e.wait_trigger_data(tmp);
          kei_i2c_field_access_bd_e.wait_trigger_data(tmp);
        join_any
        disable fork;
        void'($cast(r, tmp));
        // ensure RGM mirror value has been updated by monitor transaction
        #1ps; 
        if(r.get_name() == "IC_TAR") begin
          target_address_and_slave_address_cg.sample(rgm.IC_TAR_IC_TAR.get(), "TAR");//rgm.IC_TAR_IC_TAR等价于rgm.IC_TAR.IC_TAR
        end
        else if(r.get_name() == "IC_SAR") begin
          target_address_and_slave_address_cg.sample(rgm.IC_SAR_IC_SAR.get(), "SAR");
        end
        else if(r.get_name() == "IC_CON") begin
          speed_modes_cg.sample(rgm.IC_CON_SPEED.get(), "SPEED");
          bits7_or_bits10_addressing_cg.sample(rgm.IC_CON_IC_10BITADDR_MASTER.get());
          restart_condition_cg.sample(rgm.IC_CON_IC_RESTART_EN.get());
        end
        else if(r.get_name() == "IC_SS_SCL_LCNT") begin
          speed_modes_cg.sample(rgm.IC_SS_SCL_LCNT_IC_SS_SCL_LCNT.get(), "SS_SCL_LCNT");
        end
        else if(r.get_name() == "IC_SS_SCL_HCNT") begin
          speed_modes_cg.sample(rgm.IC_SS_SCL_HCNT_IC_SS_SCL_HCNT.get(), "SS_SCL_HCNT");
        end
        else if(r.get_name() == "IC_FS_SCL_LCNT") begin
          speed_modes_cg.sample(rgm.IC_FS_SCL_LCNT_IC_FS_SCL_LCNT.get(), "FS_SCL_LCNT");
        end
        else if(r.get_name() == "IC_FS_SCL_HCNT") begin
          speed_modes_cg.sample(rgm.IC_FS_SCL_HCNT_IC_FS_SCL_HCNT.get(), "FS_SCL_HCNT");
        end
        else if(r.get_name() == "IC_HS_SCL_LCNT") begin
          speed_modes_cg.sample(rgm.IC_HS_SCL_LCNT_IC_HS_SCL_LCNT.get(), "HS_SCL_LCNT");
        end
        else if(r.get_name() == "IC_HS_SCL_HCNT") begin
          speed_modes_cg.sample(rgm.IC_HS_SCL_HCNT_IC_HS_SCL_HCNT.get(), "HS_SCL_HCNT");
        end
        else if(r.get_name() == "IC_STATUS") begin
          activity_cg.sample(rgm.IC_STATUS_ACTIVITY.get(), "ACTIVITY");
          activity_cg.sample(rgm.IC_STATUS_MST_ACTIVITY.get(), "MST_ACTIVITY");
          tx_fifo_status_cg.sample(rgm.IC_STATUS_TFE.get(), rgm.IC_STATUS_TFNF.get());
          rx_fifo_status_cg.sample(rgm.IC_STATUS_RFF.get(), rgm.IC_STATUS_RFNE.get());
        end
        else if(r.get_name() == "IC_ENABLE") begin
          enabled_cg.sample(rgm.IC_ENABLE_ENABLE.get(), "ENABLE_CTRL");
        end
        else if(r.get_name() == "IC_ENABLE_STATUS") begin
          enabled_cg.sample(rgm.IC_ENABLE_STATUS_IC_EN.get(), "ENABLE_STATUS");
        end
        else if(r.get_name() == "IC_INTR_STAT") begin
          interrupt_status_cg.sample(rgm.IC_INTR_STAT.get());
        end
        else if(r.get_name() == "IC_RAW_INTR_STAT") begin
          interrupt_status_cg.sample(rgm.IC_RAW_INTR_STAT.get());
        end
        else if(r.get_name() == "IC_CLR_INTR") begin
          interrupt_clear_cg.sample(1, "CLR_INTR");
        end
        else if(r.get_name() == "IC_CLR_RX_UNDER") begin
          interrupt_clear_cg.sample(1, "CLR_RX_UNDER");
        end
        else if(r.get_name() == "IC_CLR_RX_OVER") begin
          interrupt_clear_cg.sample(1, "CLR_RX_OVER");
        end
        else if(r.get_name() == "IC_CLR_TX_OVER") begin
          interrupt_clear_cg.sample(1, "CLR_TX_OVER");
        end
        else if(r.get_name() == "IC_CLR_RD_REQ") begin
          interrupt_clear_cg.sample(1, "CLR_RD_REQ");
        end
        else if(r.get_name() == "IC_CLR_TX_ABRT") begin
          interrupt_clear_cg.sample(1, "CLR_TX_ABRT");
        end
        else if(r.get_name() == "IC_CLR_RX_DONE") begin
          interrupt_clear_cg.sample(1, "CLR_RX_DONE");
        end
        else if(r.get_name() == "IC_CLR_ACTIVITY") begin
          interrupt_clear_cg.sample(1, "CLR_ACTIVITY");
        end
        else if(r.get_name() == "IC_CLR_STOP_DET") begin
          interrupt_clear_cg.sample(1, "CLR_STOP_DET");
        end
        else if(r.get_name() == "IC_CLR_START_DET") begin
          interrupt_clear_cg.sample(1, "CLR_START_DET");
        end
        else if(r.get_name() == "IC_CLR_GEN_CALL") begin
          interrupt_clear_cg.sample(1, "CLR_GEN_CALL");
        end
        else if(r.get_name() == "IC_TX_ABRT_SOURCE") begin
          interrupt_tx_abort_sources_cg.sample(rgm.IC_TX_ABRT_SOURCE.get());
        end
        else if(r.get_name() == "IC_SDA_HOLD") begin
          sda_control_cg.sample(rgm.IC_SDA_HOLD_IC_SDA_RX_HOLD.get(),rgm.IC_SDA_HOLD_IC_SDA_TX_HOLD.get(),"","SDA_HOLD");
        end
        else if(r.get_name() == "IC_SDA_SETUP") begin
          sda_control_cg.sample("","",rgm.IC_SDA_SETUP_SDA_SETUP.get(),"SDA_SETUP");
        end
        else if(r.get_name() == "REG_TIMEOUT_RST") begin
          timeout_counter_cg.sample(rgm.REG_TIMEOUT_RST.get());
        end
      end
    join_none
  endtask

  virtual task do_sample_signals();
    fork
      forever begin
        @(vif.intr iff vif.apb_rstn && enable && vif.intr !== 0);
        interrupt_hardware_outputs_cg.sample(vif.intr);
      end
    join_none
  endtask
  
endclass


`endif // KEI_I2C_CGM_SV

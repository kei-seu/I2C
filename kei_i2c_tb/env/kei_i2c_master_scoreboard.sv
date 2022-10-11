
`ifndef KEI_I2C_MASTER_SCOREBOARD_SV
`define KEI_I2C_MASTER_SCOREBOARD_SV

`uvm_analysis_imp_decl(_apb_master)
`uvm_analysis_imp_decl(_i2c_slave)

class kei_i2c_master_scoreboard extends uvm_component;
  
  kei_i2c_config cfg;
  // TODO
  // Analysis FIFO declarion below
  uvm_analysis_imp_apb_master #(kei_vip_apb_transfer,kei_i2c_master_scoreboard) apb_trans_observed_imp;
	uvm_analysis_imp_i2c_slave #(kei_vip_i2c_slave_transaction,kei_i2c_master_scoreboard) i2c_trans_observed_imp;
  
  kei_vip_apb_transfer apb_trans_observed[$];
  kei_vip_i2c_slave_transaction i2c_trans_observed[$];
  bit[7:0] write_data_expected[$];
  bit[7:0] write_data_observed[$];
  bit[7:0] read_data_expected[$];
  bit[7:0] read_data_observed[$];

  /** variable to enable and disable scoreboard */  
  bit enable = 1;
  /** number of WRITE/READ transaction expected by refmod */
  int write_count_expected = 0;
  int read_count_expected = 0;
  /** number of WRITE/READ transaction observed by slave */
  int write_count_observed = 0;
  int read_count_observed = 0;
  /** variable to count no. of mismatch in master and slave transaction */
  int mismatch_count = 0;
  int retry_count;
  
  `uvm_component_utils(kei_i2c_master_scoreboard)

  function new (string name = "kei_i2c_master_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_trans_observed_imp = new("apb_trans_observed_imp", this);
    i2c_trans_observed_imp = new("i2c_trans_observed_imp", this);

    if(!uvm_config_db #(kei_i2c_config)::get(this, "", "cfg", cfg)) begin
      `uvm_error("build_phase", "Unable to get kei_i2c_config from uvm_config_db")
    end
    enable = cfg.master_scoreboard_enable;
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    fork
      i2c_refmod();
      i2c_write_comparer();
      i2c_read_comparer();
    join_none
  endtask

  virtual function void write_apb_master(kei_vip_apb_transfer tr);
    uvm_reg r;
    if(enable) begin
      r = cfg.rgm.default_map.get_reg_by_offset(tr.addr);
      if(r.get_name() == "IC_DATA_CMD" &&
        ( (tr.trans_kind == kei_vip_apb_pkg::WRITE && cfg.rgm.IC_DATA_CMD_CMD.get() == RGM_WRITE && cfg.rgm.IC_STATUS_TFNF.get())  || 
        (tr.trans_kind == kei_vip_apb_pkg::READ && cfg.rgm.IC_DATA_CMD_CMD.get() == RGM_READ && cfg.rgm.IC_STATUS_RFNE.get()) )
      )
      apb_trans_observed.push_back(tr);
    end
  endfunction: write_apb_master

  virtual function void write_i2c_slave(kei_vip_i2c_slave_transaction tr);
    if(enable) begin
      i2c_trans_observed.push_back(tr);
      foreach(tr.data[i]) begin
        if(tr.cmd == I2C_WRITE) begin
          write_data_observed.push_back(tr.data[i]);
          write_count_observed++;
        end
        else if(tr.cmd == I2C_READ) begin
          read_data_observed.push_back(tr.data[i]);
          read_count_observed++;
        end
      end
    end
  endfunction: write_i2c_slave

  task i2c_refmod();
    kei_vip_apb_transfer tr;
    ral_reg_kei_i2c_IC_DATA_CMD data_cmd_r;
    bit[7:0] data;
    data_cmd_r = new("data_cmd_r");
    data_cmd_r.build();
    forever begin
      wait(apb_trans_observed.size() > 0) tr = apb_trans_observed.pop_front();
      data_cmd_r.set(tr.data);
      if(tr.trans_kind == kei_vip_apb_pkg::WRITE && cfg.rgm.IC_DATA_CMD_CMD.get() == RGM_WRITE) begin
        write_data_expected.push_back(data_cmd_r.DAT.get());
        write_count_expected++;
      end
      else if(tr.trans_kind == kei_vip_apb_pkg::READ && cfg.rgm.IC_DATA_CMD_CMD.get() == RGM_READ) begin
        read_data_expected.push_back(data_cmd_r.DAT.get());
        read_count_expected++;
      end
    end
  endtask

  task i2c_write_comparer();
    bit[7:0] exp, obs;
    forever begin
      fork
        wait(write_data_expected.size() > 0) exp = write_data_expected.pop_front();
        wait(write_data_observed.size() > 0) obs = write_data_observed.pop_front();
      join
      compare_transaction(exp, obs);
    end
  endtask

  task i2c_read_comparer();
    bit[7:0] exp, obs;
    forever begin
      fork
        wait(read_data_expected.size() > 0) exp = read_data_expected.pop_front();
        wait(read_data_observed.size() > 0) obs = read_data_observed.pop_front();
      join
      compare_transaction(exp, obs);
    end
  endtask


  function void compare_transaction(bit[7:0] exp, bit[7:0] obs);
    bit mismatch_detected = 0 ;

    if(exp != obs) begin
      `uvm_error(get_type_name(), $sformatf("Byte transferred different in expected value is %h and slave observed value is %h", exp, obs))
      mismatch_detected = 1;
    end

    // check for no mismatch
    if(!mismatch_detected)
      `uvm_info(get_type_name(), $sformatf("Trans match between expected %h and observed %h", exp, obs), UVM_LOW)
    else
      mismatch_count++;
  endfunction: compare_transaction

  // ------------------------------------------------------------------------------------------------
  // report phase
  // ------------------------------------------------------------------------------------------------
  virtual function void report_phase(uvm_phase phase);
    if(enable) begin
      `uvm_info(get_type_name(),
      $sformatf("\n\
  ----------------------------------------------\n\
 | ScoreBoard Report                             |\n\
  ---------------------------------------------- \n\
 | Transactions write expected by Refmod %5d   |\n\
 | Transactions  read expected by Refmod %5d   |\n\
 | Transactions write observed by Slave  %5d   |\n\
 | Transactions  read observed by Slave  %5d   |\n\
 | Mismatch in transactions              %5d   |\n\
  ---------------------------------------------- ",
      write_count_expected, read_count_expected, write_count_observed, read_count_observed, mismatch_count), UVM_LOW);
      
      if((write_count_expected==0 && read_count_expected==0) || (write_count_observed==0 && read_count_observed==0)) begin
        `uvm_error(get_type_name(),$sformatf("Scoreboard Error : NO transaction observed on the bus"))
      end  
      if(write_data_expected.size() != 0) begin
        `uvm_error(get_type_name(),$sformatf("Scoreboard Error : expected write transaction queue still have %0d pending transaction",write_data_expected.size()))
      end
      if(read_data_expected.size() != 0) begin
        `uvm_error(get_type_name(),$sformatf("Scoreboard Error : expected read transaction queue still have %0d pending transaction",read_data_expected.size()))
      end
      if(write_data_observed.size() != 0) begin
        `uvm_error(get_type_name(),$sformatf("Scoreboard Error : observed write transaction queue still have %0d pending transaction",write_data_observed.size()))
      end
      if(read_data_observed.size() != 0) begin
        `uvm_error(get_type_name(),$sformatf("Scoreboard Error : observed read transaction queue still have %0d pending transaction",read_data_observed.size()))
      end
      if(write_count_expected != write_count_observed) begin
        `uvm_error(get_type_name(),$sformatf("Scoreboard Error : Mismatch detected in number of write transaction of expected - %0d and observed - %0d",write_count_expected, write_count_observed))
      end
      if(read_count_expected != read_count_observed) begin
        `uvm_error(get_type_name(),$sformatf("Scoreboard Error : Mismatch detected in number of read transaction of expected - %0d and observed - %0d",read_count_expected,read_count_observed))
      end
    end
  endfunction: report_phase

endclass

`endif // KEI_I2C_MASTER_SCOREBOARD_SV

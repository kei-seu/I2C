`ifndef RAL_KEI_I2C
`define RAL_KEI_I2C

import uvm_pkg::*;

class ral_reg_kei_i2c_IC_CON extends uvm_reg;
	rand uvm_reg_field MASTER_MODE;
	rand uvm_reg_field SPEED;
	rand uvm_reg_field IC_10BITADDR_SLAVE;
	rand uvm_reg_field IC_10BITADDR_MASTER;
	rand uvm_reg_field IC_RESTART_EN;
	rand uvm_reg_field IC_SLAVE_DISABLE;
	rand uvm_reg_field STOP_DET_IFADDRESSED;
	rand uvm_reg_field TX_EMPTY_CTRL;
	uvm_reg_field RX_FIFO_FULL_HLD_CTRL;
	uvm_reg_field STOP_DET_IF_MASTER_ACTIVE;
	uvm_reg_field RSVD_BUS_CLEAR_FEATURE_CTRL;
	uvm_reg_field RSVD_IC_CON_1;
	uvm_reg_field RSVD_OPTIONAL_SAR_CTRL;
	uvm_reg_field RSVD_SMBUS_SLAVE_QUICK_EN;
	uvm_reg_field RSVD_SMBUS_ARP_EN;
	uvm_reg_field RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN;
	uvm_reg_field RSVD_IC_CON_2;

	function new(string name = "kei_i2c_IC_CON");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.MASTER_MODE = uvm_reg_field::type_id::create("MASTER_MODE",,get_full_name());
      this.MASTER_MODE.configure(this, 1, 0, "RW", 0, 1'h1, 1, 0, 0);
      this.SPEED = uvm_reg_field::type_id::create("SPEED",,get_full_name());
      this.SPEED.configure(this, 2, 1, "RW", 0, 2'h3, 1, 0, 0);
      this.IC_10BITADDR_SLAVE = uvm_reg_field::type_id::create("IC_10BITADDR_SLAVE",,get_full_name());
      this.IC_10BITADDR_SLAVE.configure(this, 1, 3, "RW", 0, 1'h1, 1, 0, 0);
      this.IC_10BITADDR_MASTER = uvm_reg_field::type_id::create("IC_10BITADDR_MASTER",,get_full_name());
      this.IC_10BITADDR_MASTER.configure(this, 1, 4, "RW", 0, 1'h1, 1, 0, 0);
      this.IC_RESTART_EN = uvm_reg_field::type_id::create("IC_RESTART_EN",,get_full_name());
      this.IC_RESTART_EN.configure(this, 1, 5, "RW", 0, 1'h1, 1, 0, 0);
      this.IC_SLAVE_DISABLE = uvm_reg_field::type_id::create("IC_SLAVE_DISABLE",,get_full_name());
      this.IC_SLAVE_DISABLE.configure(this, 1, 6, "RW", 0, 1'h1, 1, 0, 0);
      this.STOP_DET_IFADDRESSED = uvm_reg_field::type_id::create("STOP_DET_IFADDRESSED",,get_full_name());
      this.STOP_DET_IFADDRESSED.configure(this, 1, 7, "RW", 0, 1'h0, 1, 0, 0);
      this.TX_EMPTY_CTRL = uvm_reg_field::type_id::create("TX_EMPTY_CTRL",,get_full_name());
      this.TX_EMPTY_CTRL.configure(this, 1, 8, "RW", 0, 1'h0, 1, 0, 0);
      this.RX_FIFO_FULL_HLD_CTRL = uvm_reg_field::type_id::create("RX_FIFO_FULL_HLD_CTRL",,get_full_name());
      this.RX_FIFO_FULL_HLD_CTRL.configure(this, 1, 9, "RO", 0, 1'h0, 1, 0, 0);
      this.STOP_DET_IF_MASTER_ACTIVE = uvm_reg_field::type_id::create("STOP_DET_IF_MASTER_ACTIVE",,get_full_name());
      this.STOP_DET_IF_MASTER_ACTIVE.configure(this, 1, 10, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_BUS_CLEAR_FEATURE_CTRL = uvm_reg_field::type_id::create("RSVD_BUS_CLEAR_FEATURE_CTRL",,get_full_name());
      this.RSVD_BUS_CLEAR_FEATURE_CTRL.configure(this, 1, 11, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_IC_CON_1 = uvm_reg_field::type_id::create("RSVD_IC_CON_1",,get_full_name());
      this.RSVD_IC_CON_1.configure(this, 4, 12, "RO", 0, 4'h0, 1, 0, 0);
      this.RSVD_OPTIONAL_SAR_CTRL = uvm_reg_field::type_id::create("RSVD_OPTIONAL_SAR_CTRL",,get_full_name());
      this.RSVD_OPTIONAL_SAR_CTRL.configure(this, 1, 16, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_SLAVE_QUICK_EN = uvm_reg_field::type_id::create("RSVD_SMBUS_SLAVE_QUICK_EN",,get_full_name());
      this.RSVD_SMBUS_SLAVE_QUICK_EN.configure(this, 1, 17, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_ARP_EN = uvm_reg_field::type_id::create("RSVD_SMBUS_ARP_EN",,get_full_name());
      this.RSVD_SMBUS_ARP_EN.configure(this, 1, 18, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN = uvm_reg_field::type_id::create("RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN",,get_full_name());
      this.RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN.configure(this, 1, 19, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_IC_CON_2 = uvm_reg_field::type_id::create("RSVD_IC_CON_2",,get_full_name());
      this.RSVD_IC_CON_2.configure(this, 12, 20, "RO", 0, 12'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CON)

endclass : ral_reg_kei_i2c_IC_CON


class ral_reg_kei_i2c_IC_TAR extends uvm_reg;
	rand uvm_reg_field IC_TAR;
	rand uvm_reg_field GC_OR_START;
	rand uvm_reg_field SPECIAL;
	uvm_reg_field RSVD_IC_10BITADDR_MASTER;
	uvm_reg_field RSVD_DEVICE_ID;
	uvm_reg_field RSVD_IC_TAR_1;
	uvm_reg_field RSVD_SMBUS_QUICK_CMD;
	uvm_reg_field RSVD_IC_TAR_2;

	function new(string name = "kei_i2c_IC_TAR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_TAR = uvm_reg_field::type_id::create("IC_TAR",,get_full_name());
      this.IC_TAR.configure(this, 10, 0, "RW", 0, 10'h33, 1, 0, 0);
      this.GC_OR_START = uvm_reg_field::type_id::create("GC_OR_START",,get_full_name());
      this.GC_OR_START.configure(this, 1, 10, "RW", 0, 1'h0, 1, 0, 0);
      this.SPECIAL = uvm_reg_field::type_id::create("SPECIAL",,get_full_name());
      this.SPECIAL.configure(this, 1, 11, "RW", 0, 1'h0, 1, 0, 0);
      this.RSVD_IC_10BITADDR_MASTER = uvm_reg_field::type_id::create("RSVD_IC_10BITADDR_MASTER",,get_full_name());
      this.RSVD_IC_10BITADDR_MASTER.configure(this, 1, 12, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_DEVICE_ID = uvm_reg_field::type_id::create("RSVD_DEVICE_ID",,get_full_name());
      this.RSVD_DEVICE_ID.configure(this, 1, 13, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_IC_TAR_1 = uvm_reg_field::type_id::create("RSVD_IC_TAR_1",,get_full_name());
      this.RSVD_IC_TAR_1.configure(this, 2, 14, "RO", 0, 2'h0, 1, 0, 0);
      this.RSVD_SMBUS_QUICK_CMD = uvm_reg_field::type_id::create("RSVD_SMBUS_QUICK_CMD",,get_full_name());
      this.RSVD_SMBUS_QUICK_CMD.configure(this, 1, 16, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_IC_TAR_2 = uvm_reg_field::type_id::create("RSVD_IC_TAR_2",,get_full_name());
      this.RSVD_IC_TAR_2.configure(this, 15, 17, "RO", 0, 15'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_TAR)

endclass : ral_reg_kei_i2c_IC_TAR


class ral_reg_kei_i2c_IC_SAR extends uvm_reg;
	rand uvm_reg_field IC_SAR;
	uvm_reg_field RSVD_IC_SAR;

	function new(string name = "kei_i2c_IC_SAR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_SAR = uvm_reg_field::type_id::create("IC_SAR",,get_full_name());
      this.IC_SAR.configure(this, 10, 0, "RW", 0, 10'h33, 1, 0, 0);
      this.RSVD_IC_SAR = uvm_reg_field::type_id::create("RSVD_IC_SAR",,get_full_name());
      this.RSVD_IC_SAR.configure(this, 22, 10, "RO", 0, 22'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_SAR)

endclass : ral_reg_kei_i2c_IC_SAR


class ral_reg_kei_i2c_IC_HS_MADDR extends uvm_reg;
	rand uvm_reg_field IC_HS_MAR;
	uvm_reg_field RSVD_IC_HS_MAR;

	function new(string name = "kei_i2c_IC_HS_MADDR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_HS_MAR = uvm_reg_field::type_id::create("IC_HS_MAR",,get_full_name());
      this.IC_HS_MAR.configure(this, 3, 0, "RW", 0, 3'h1, 1, 0, 0);
      this.RSVD_IC_HS_MAR = uvm_reg_field::type_id::create("RSVD_IC_HS_MAR",,get_full_name());
      this.RSVD_IC_HS_MAR.configure(this, 29, 3, "RO", 0, 29'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_HS_MADDR)

endclass : ral_reg_kei_i2c_IC_HS_MADDR


class ral_reg_kei_i2c_IC_DATA_CMD extends uvm_reg;
	rand uvm_reg_field DAT;
	rand uvm_reg_field CMD;
	uvm_reg_field RSVD_STOP;
	uvm_reg_field RSVD_RESTART;
	uvm_reg_field RSVD_FIRST_DATA_BYTE;
	uvm_reg_field RSVD_IC_DATA_CMD;

	function new(string name = "kei_i2c_IC_DATA_CMD");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DAT = uvm_reg_field::type_id::create("DAT",,get_full_name());
      this.DAT.configure(this, 8, 0, "RW", 1, 8'h0, 1, 0, 1);
      this.CMD = uvm_reg_field::type_id::create("CMD",,get_full_name());
      this.CMD.configure(this, 1, 8, "WO", 1, 1'h0, 1, 0, 0);
      this.RSVD_STOP = uvm_reg_field::type_id::create("RSVD_STOP",,get_full_name());
      this.RSVD_STOP.configure(this, 1, 9, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_RESTART = uvm_reg_field::type_id::create("RSVD_RESTART",,get_full_name());
      this.RSVD_RESTART.configure(this, 1, 10, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_FIRST_DATA_BYTE = uvm_reg_field::type_id::create("RSVD_FIRST_DATA_BYTE",,get_full_name());
      this.RSVD_FIRST_DATA_BYTE.configure(this, 1, 11, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_DATA_CMD = uvm_reg_field::type_id::create("RSVD_IC_DATA_CMD",,get_full_name());
      this.RSVD_IC_DATA_CMD.configure(this, 20, 12, "RO", 1, 20'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_DATA_CMD)

endclass : ral_reg_kei_i2c_IC_DATA_CMD


class ral_reg_kei_i2c_IC_SS_SCL_HCNT extends uvm_reg;
	rand uvm_reg_field IC_SS_SCL_HCNT;
	uvm_reg_field RSVD_IC_SS_SCL_HIGH_COUNT;

	function new(string name = "kei_i2c_IC_SS_SCL_HCNT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_SS_SCL_HCNT = uvm_reg_field::type_id::create("IC_SS_SCL_HCNT",,get_full_name());
      this.IC_SS_SCL_HCNT.configure(this, 16, 0, "RW", 0, 16'h190, 1, 0, 1);
      this.RSVD_IC_SS_SCL_HIGH_COUNT = uvm_reg_field::type_id::create("RSVD_IC_SS_SCL_HIGH_COUNT",,get_full_name());
      this.RSVD_IC_SS_SCL_HIGH_COUNT.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_SS_SCL_HCNT)

endclass : ral_reg_kei_i2c_IC_SS_SCL_HCNT


class ral_reg_kei_i2c_IC_SS_SCL_LCNT extends uvm_reg;
	rand uvm_reg_field IC_SS_SCL_LCNT;
	uvm_reg_field RSVD_IC_SS_SCL_LOW_COUNT;

	function new(string name = "kei_i2c_IC_SS_SCL_LCNT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_SS_SCL_LCNT = uvm_reg_field::type_id::create("IC_SS_SCL_LCNT",,get_full_name());
      this.IC_SS_SCL_LCNT.configure(this, 16, 0, "RW", 0, 16'h1d6, 1, 0, 1);
      this.RSVD_IC_SS_SCL_LOW_COUNT = uvm_reg_field::type_id::create("RSVD_IC_SS_SCL_LOW_COUNT",,get_full_name());
      this.RSVD_IC_SS_SCL_LOW_COUNT.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_SS_SCL_LCNT)

endclass : ral_reg_kei_i2c_IC_SS_SCL_LCNT


class ral_reg_kei_i2c_IC_FS_SCL_HCNT extends uvm_reg;
	rand uvm_reg_field IC_FS_SCL_HCNT;
	uvm_reg_field RSVD_IC_FS_SCL_HCNT;

	function new(string name = "kei_i2c_IC_FS_SCL_HCNT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_FS_SCL_HCNT = uvm_reg_field::type_id::create("IC_FS_SCL_HCNT",,get_full_name());
      this.IC_FS_SCL_HCNT.configure(this, 16, 0, "RW", 0, 16'h3c, 1, 0, 1);
      this.RSVD_IC_FS_SCL_HCNT = uvm_reg_field::type_id::create("RSVD_IC_FS_SCL_HCNT",,get_full_name());
      this.RSVD_IC_FS_SCL_HCNT.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_FS_SCL_HCNT)

endclass : ral_reg_kei_i2c_IC_FS_SCL_HCNT


class ral_reg_kei_i2c_IC_FS_SCL_LCNT extends uvm_reg;
	rand uvm_reg_field IC_FS_SCL_LCNT;
	uvm_reg_field RSVD_IC_FS_SCL_LCNT;

	function new(string name = "kei_i2c_IC_FS_SCL_LCNT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_FS_SCL_LCNT = uvm_reg_field::type_id::create("IC_FS_SCL_LCNT",,get_full_name());
      this.IC_FS_SCL_LCNT.configure(this, 16, 0, "RW", 0, 16'h82, 1, 0, 1);
      this.RSVD_IC_FS_SCL_LCNT = uvm_reg_field::type_id::create("RSVD_IC_FS_SCL_LCNT",,get_full_name());
      this.RSVD_IC_FS_SCL_LCNT.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_FS_SCL_LCNT)

endclass : ral_reg_kei_i2c_IC_FS_SCL_LCNT


class ral_reg_kei_i2c_IC_HS_SCL_HCNT extends uvm_reg;
	rand uvm_reg_field IC_HS_SCL_HCNT;
	uvm_reg_field RSVD_IC_HS_SCL_HCNT;

	function new(string name = "kei_i2c_IC_HS_SCL_HCNT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_HS_SCL_HCNT = uvm_reg_field::type_id::create("IC_HS_SCL_HCNT",,get_full_name());
      this.IC_HS_SCL_HCNT.configure(this, 16, 0, "RW", 0, 16'h6, 1, 0, 1);
      this.RSVD_IC_HS_SCL_HCNT = uvm_reg_field::type_id::create("RSVD_IC_HS_SCL_HCNT",,get_full_name());
      this.RSVD_IC_HS_SCL_HCNT.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_HS_SCL_HCNT)

endclass : ral_reg_kei_i2c_IC_HS_SCL_HCNT


class ral_reg_kei_i2c_IC_HS_SCL_LCNT extends uvm_reg;
	rand uvm_reg_field IC_HS_SCL_LCNT;
	uvm_reg_field RSVD_IC_HS_SCL_LOW_CNT;

	function new(string name = "kei_i2c_IC_HS_SCL_LCNT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_HS_SCL_LCNT = uvm_reg_field::type_id::create("IC_HS_SCL_LCNT",,get_full_name());
      this.IC_HS_SCL_LCNT.configure(this, 16, 0, "RW", 0, 16'h10, 1, 0, 1);
      this.RSVD_IC_HS_SCL_LOW_CNT = uvm_reg_field::type_id::create("RSVD_IC_HS_SCL_LOW_CNT",,get_full_name());
      this.RSVD_IC_HS_SCL_LOW_CNT.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_HS_SCL_LCNT)

endclass : ral_reg_kei_i2c_IC_HS_SCL_LCNT


class ral_reg_kei_i2c_IC_INTR_STAT extends uvm_reg;
	uvm_reg_field R_RX_UNDER;
	uvm_reg_field R_RX_OVER;
	uvm_reg_field R_RX_FULL;
	uvm_reg_field R_TX_OVER;
	uvm_reg_field R_TX_EMPTY;
	uvm_reg_field R_RD_REQ;
	uvm_reg_field R_TX_ABRT;
	uvm_reg_field R_RX_DONE;
	uvm_reg_field R_ACTIVITY;
	uvm_reg_field R_STOP_DET;
	uvm_reg_field R_START_DET;
	uvm_reg_field R_GEN_CALL;
	uvm_reg_field R_RESTART_DET;
	uvm_reg_field R_MASTER_ON_HOLD;
	uvm_reg_field RSVD_R_SCL_STUCK_AT_LOW;
	uvm_reg_field RSVD_IC_INTR_STAT;

	function new(string name = "kei_i2c_IC_INTR_STAT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.R_RX_UNDER = uvm_reg_field::type_id::create("R_RX_UNDER",,get_full_name());
      this.R_RX_UNDER.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.R_RX_OVER = uvm_reg_field::type_id::create("R_RX_OVER",,get_full_name());
      this.R_RX_OVER.configure(this, 1, 1, "RO", 1, 1'h0, 1, 0, 0);
      this.R_RX_FULL = uvm_reg_field::type_id::create("R_RX_FULL",,get_full_name());
      this.R_RX_FULL.configure(this, 1, 2, "RO", 1, 1'h0, 1, 0, 0);
      this.R_TX_OVER = uvm_reg_field::type_id::create("R_TX_OVER",,get_full_name());
      this.R_TX_OVER.configure(this, 1, 3, "RO", 1, 1'h0, 1, 0, 0);
      this.R_TX_EMPTY = uvm_reg_field::type_id::create("R_TX_EMPTY",,get_full_name());
      this.R_TX_EMPTY.configure(this, 1, 4, "RO", 1, 1'h0, 1, 0, 0);
      this.R_RD_REQ = uvm_reg_field::type_id::create("R_RD_REQ",,get_full_name());
      this.R_RD_REQ.configure(this, 1, 5, "RO", 1, 1'h0, 1, 0, 0);
      this.R_TX_ABRT = uvm_reg_field::type_id::create("R_TX_ABRT",,get_full_name());
      this.R_TX_ABRT.configure(this, 1, 6, "RO", 1, 1'h0, 1, 0, 0);
      this.R_RX_DONE = uvm_reg_field::type_id::create("R_RX_DONE",,get_full_name());
      this.R_RX_DONE.configure(this, 1, 7, "RO", 1, 1'h0, 1, 0, 0);
      this.R_ACTIVITY = uvm_reg_field::type_id::create("R_ACTIVITY",,get_full_name());
      this.R_ACTIVITY.configure(this, 1, 8, "RO", 1, 1'h0, 1, 0, 0);
      this.R_STOP_DET = uvm_reg_field::type_id::create("R_STOP_DET",,get_full_name());
      this.R_STOP_DET.configure(this, 1, 9, "RO", 1, 1'h0, 1, 0, 0);
      this.R_START_DET = uvm_reg_field::type_id::create("R_START_DET",,get_full_name());
      this.R_START_DET.configure(this, 1, 10, "RO", 1, 1'h0, 1, 0, 0);
      this.R_GEN_CALL = uvm_reg_field::type_id::create("R_GEN_CALL",,get_full_name());
      this.R_GEN_CALL.configure(this, 1, 11, "RO", 1, 1'h0, 1, 0, 0);
      this.R_RESTART_DET = uvm_reg_field::type_id::create("R_RESTART_DET",,get_full_name());
      this.R_RESTART_DET.configure(this, 1, 12, "RO", 1, 1'h0, 1, 0, 0);
      this.R_MASTER_ON_HOLD = uvm_reg_field::type_id::create("R_MASTER_ON_HOLD",,get_full_name());
      this.R_MASTER_ON_HOLD.configure(this, 1, 13, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_R_SCL_STUCK_AT_LOW = uvm_reg_field::type_id::create("RSVD_R_SCL_STUCK_AT_LOW",,get_full_name());
      this.RSVD_R_SCL_STUCK_AT_LOW.configure(this, 1, 14, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_INTR_STAT = uvm_reg_field::type_id::create("RSVD_IC_INTR_STAT",,get_full_name());
      this.RSVD_IC_INTR_STAT.configure(this, 17, 15, "RO", 1, 17'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_INTR_STAT)

endclass : ral_reg_kei_i2c_IC_INTR_STAT


class ral_reg_kei_i2c_IC_INTR_MASK extends uvm_reg;
	rand uvm_reg_field M_RX_UNDER;
	rand uvm_reg_field M_RX_OVER;
	rand uvm_reg_field M_RX_FULL;
	rand uvm_reg_field M_TX_OVER;
	rand uvm_reg_field M_TX_EMPTY;
	rand uvm_reg_field M_RD_REQ;
	rand uvm_reg_field M_TX_ABRT;
	rand uvm_reg_field M_RX_DONE;
	rand uvm_reg_field M_ACTIVITY;
	rand uvm_reg_field M_STOP_DET;
	rand uvm_reg_field M_START_DET;
	rand uvm_reg_field M_GEN_CALL;
	uvm_reg_field M_RESTART_DET_read_only;
	uvm_reg_field M_MASTER_ON_HOLD_read_only;
	uvm_reg_field RSVD_M_SCL_STUCK_AT_LOW;
	uvm_reg_field RSVD_IC_INTR_STAT;

	function new(string name = "kei_i2c_IC_INTR_MASK");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.M_RX_UNDER = uvm_reg_field::type_id::create("M_RX_UNDER",,get_full_name());
      this.M_RX_UNDER.configure(this, 1, 0, "RW", 0, 1'h1, 1, 0, 0);
      this.M_RX_OVER = uvm_reg_field::type_id::create("M_RX_OVER",,get_full_name());
      this.M_RX_OVER.configure(this, 1, 1, "RW", 0, 1'h1, 1, 0, 0);
      this.M_RX_FULL = uvm_reg_field::type_id::create("M_RX_FULL",,get_full_name());
      this.M_RX_FULL.configure(this, 1, 2, "RW", 0, 1'h1, 1, 0, 0);
      this.M_TX_OVER = uvm_reg_field::type_id::create("M_TX_OVER",,get_full_name());
      this.M_TX_OVER.configure(this, 1, 3, "RW", 0, 1'h1, 1, 0, 0);
      this.M_TX_EMPTY = uvm_reg_field::type_id::create("M_TX_EMPTY",,get_full_name());
      this.M_TX_EMPTY.configure(this, 1, 4, "RW", 0, 1'h1, 1, 0, 0);
      this.M_RD_REQ = uvm_reg_field::type_id::create("M_RD_REQ",,get_full_name());
      this.M_RD_REQ.configure(this, 1, 5, "RW", 0, 1'h1, 1, 0, 0);
      this.M_TX_ABRT = uvm_reg_field::type_id::create("M_TX_ABRT",,get_full_name());
      this.M_TX_ABRT.configure(this, 1, 6, "RW", 0, 1'h1, 1, 0, 0);
      this.M_RX_DONE = uvm_reg_field::type_id::create("M_RX_DONE",,get_full_name());
      this.M_RX_DONE.configure(this, 1, 7, "RW", 0, 1'h1, 1, 0, 0);
      this.M_ACTIVITY = uvm_reg_field::type_id::create("M_ACTIVITY",,get_full_name());
      this.M_ACTIVITY.configure(this, 1, 8, "RW", 0, 1'h0, 1, 0, 0);
      this.M_STOP_DET = uvm_reg_field::type_id::create("M_STOP_DET",,get_full_name());
      this.M_STOP_DET.configure(this, 1, 9, "RW", 0, 1'h0, 1, 0, 0);
      this.M_START_DET = uvm_reg_field::type_id::create("M_START_DET",,get_full_name());
      this.M_START_DET.configure(this, 1, 10, "RW", 0, 1'h0, 1, 0, 0);
      this.M_GEN_CALL = uvm_reg_field::type_id::create("M_GEN_CALL",,get_full_name());
      this.M_GEN_CALL.configure(this, 1, 11, "RW", 0, 1'h1, 1, 0, 0);
      this.M_RESTART_DET_read_only = uvm_reg_field::type_id::create("M_RESTART_DET_read_only",,get_full_name());
      this.M_RESTART_DET_read_only.configure(this, 1, 12, "RO", 0, 1'h0, 1, 0, 0);
      this.M_MASTER_ON_HOLD_read_only = uvm_reg_field::type_id::create("M_MASTER_ON_HOLD_read_only",,get_full_name());
      this.M_MASTER_ON_HOLD_read_only.configure(this, 1, 13, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_M_SCL_STUCK_AT_LOW = uvm_reg_field::type_id::create("RSVD_M_SCL_STUCK_AT_LOW",,get_full_name());
      this.RSVD_M_SCL_STUCK_AT_LOW.configure(this, 1, 14, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_IC_INTR_STAT = uvm_reg_field::type_id::create("RSVD_IC_INTR_STAT",,get_full_name());
      this.RSVD_IC_INTR_STAT.configure(this, 17, 15, "RO", 0, 17'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_INTR_MASK)

endclass : ral_reg_kei_i2c_IC_INTR_MASK


class ral_reg_kei_i2c_IC_RAW_INTR_STAT extends uvm_reg;
	uvm_reg_field RX_UNDER;
	uvm_reg_field RX_OVER;
	uvm_reg_field RX_FULL;
	uvm_reg_field TX_OVER;
	uvm_reg_field TX_EMPTY;
	uvm_reg_field RD_REQ;
	uvm_reg_field TX_ABRT;
	uvm_reg_field RX_DONE;
	uvm_reg_field ACTIVITY;
	uvm_reg_field STOP_DET;
	uvm_reg_field START_DET;
	uvm_reg_field GEN_CALL;
	uvm_reg_field RESTART_DET;
	uvm_reg_field MASTER_ON_HOLD;
	uvm_reg_field RSVD_SCL_STUCK_AT_LOW;
	uvm_reg_field RSVD_IC_RAW_INTR_STAT;

	function new(string name = "kei_i2c_IC_RAW_INTR_STAT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.RX_UNDER = uvm_reg_field::type_id::create("RX_UNDER",,get_full_name());
      this.RX_UNDER.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RX_OVER = uvm_reg_field::type_id::create("RX_OVER",,get_full_name());
      this.RX_OVER.configure(this, 1, 1, "RO", 1, 1'h0, 1, 0, 0);
      this.RX_FULL = uvm_reg_field::type_id::create("RX_FULL",,get_full_name());
      this.RX_FULL.configure(this, 1, 2, "RO", 1, 1'h0, 1, 0, 0);
      this.TX_OVER = uvm_reg_field::type_id::create("TX_OVER",,get_full_name());
      this.TX_OVER.configure(this, 1, 3, "RO", 1, 1'h0, 1, 0, 0);
      this.TX_EMPTY = uvm_reg_field::type_id::create("TX_EMPTY",,get_full_name());
      this.TX_EMPTY.configure(this, 1, 4, "RO", 1, 1'h0, 1, 0, 0);
      this.RD_REQ = uvm_reg_field::type_id::create("RD_REQ",,get_full_name());
      this.RD_REQ.configure(this, 1, 5, "RO", 1, 1'h0, 1, 0, 0);
      this.TX_ABRT = uvm_reg_field::type_id::create("TX_ABRT",,get_full_name());
      this.TX_ABRT.configure(this, 1, 6, "RO", 1, 1'h0, 1, 0, 0);
      this.RX_DONE = uvm_reg_field::type_id::create("RX_DONE",,get_full_name());
      this.RX_DONE.configure(this, 1, 7, "RO", 1, 1'h0, 1, 0, 0);
      this.ACTIVITY = uvm_reg_field::type_id::create("ACTIVITY",,get_full_name());
      this.ACTIVITY.configure(this, 1, 8, "RO", 1, 1'h0, 1, 0, 0);
      this.STOP_DET = uvm_reg_field::type_id::create("STOP_DET",,get_full_name());
      this.STOP_DET.configure(this, 1, 9, "RO", 1, 1'h0, 1, 0, 0);
      this.START_DET = uvm_reg_field::type_id::create("START_DET",,get_full_name());
      this.START_DET.configure(this, 1, 10, "RO", 1, 1'h0, 1, 0, 0);
      this.GEN_CALL = uvm_reg_field::type_id::create("GEN_CALL",,get_full_name());
      this.GEN_CALL.configure(this, 1, 11, "RO", 1, 1'h0, 1, 0, 0);
      this.RESTART_DET = uvm_reg_field::type_id::create("RESTART_DET",,get_full_name());
      this.RESTART_DET.configure(this, 1, 12, "RO", 1, 1'h0, 1, 0, 0);
      this.MASTER_ON_HOLD = uvm_reg_field::type_id::create("MASTER_ON_HOLD",,get_full_name());
      this.MASTER_ON_HOLD.configure(this, 1, 13, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_SCL_STUCK_AT_LOW = uvm_reg_field::type_id::create("RSVD_SCL_STUCK_AT_LOW",,get_full_name());
      this.RSVD_SCL_STUCK_AT_LOW.configure(this, 1, 14, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_RAW_INTR_STAT = uvm_reg_field::type_id::create("RSVD_IC_RAW_INTR_STAT",,get_full_name());
      this.RSVD_IC_RAW_INTR_STAT.configure(this, 17, 15, "RO", 1, 17'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_RAW_INTR_STAT)

endclass : ral_reg_kei_i2c_IC_RAW_INTR_STAT


class ral_reg_kei_i2c_IC_RX_TL extends uvm_reg;
	rand uvm_reg_field RX_TL;
	uvm_reg_field RSVD_IC_RX_TL;

	function new(string name = "kei_i2c_IC_RX_TL");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.RX_TL = uvm_reg_field::type_id::create("RX_TL",,get_full_name());
      this.RX_TL.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
      this.RSVD_IC_RX_TL = uvm_reg_field::type_id::create("RSVD_IC_RX_TL",,get_full_name());
      this.RSVD_IC_RX_TL.configure(this, 24, 8, "RO", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_RX_TL)

endclass : ral_reg_kei_i2c_IC_RX_TL


class ral_reg_kei_i2c_IC_TX_TL extends uvm_reg;
	rand uvm_reg_field TX_TL;
	uvm_reg_field RSVD_IC_TX_TL;

	function new(string name = "kei_i2c_IC_TX_TL");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TX_TL = uvm_reg_field::type_id::create("TX_TL",,get_full_name());
      this.TX_TL.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
      this.RSVD_IC_TX_TL = uvm_reg_field::type_id::create("RSVD_IC_TX_TL",,get_full_name());
      this.RSVD_IC_TX_TL.configure(this, 24, 8, "RO", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_TX_TL)

endclass : ral_reg_kei_i2c_IC_TX_TL


class ral_reg_kei_i2c_IC_CLR_INTR extends uvm_reg;
	uvm_reg_field CLR_INTR;
	uvm_reg_field RSVD_IC_CLR_INTR;

	function new(string name = "kei_i2c_IC_CLR_INTR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_INTR = uvm_reg_field::type_id::create("CLR_INTR",,get_full_name());
      this.CLR_INTR.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_INTR = uvm_reg_field::type_id::create("RSVD_IC_CLR_INTR",,get_full_name());
      this.RSVD_IC_CLR_INTR.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_INTR)

endclass : ral_reg_kei_i2c_IC_CLR_INTR


class ral_reg_kei_i2c_IC_CLR_RX_UNDER extends uvm_reg;
	uvm_reg_field CLR_RX_UNDER;
	uvm_reg_field RSVD_IC_CLR_RX_UNDER;

	function new(string name = "kei_i2c_IC_CLR_RX_UNDER");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_RX_UNDER = uvm_reg_field::type_id::create("CLR_RX_UNDER",,get_full_name());
      this.CLR_RX_UNDER.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_RX_UNDER = uvm_reg_field::type_id::create("RSVD_IC_CLR_RX_UNDER",,get_full_name());
      this.RSVD_IC_CLR_RX_UNDER.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_RX_UNDER)

endclass : ral_reg_kei_i2c_IC_CLR_RX_UNDER


class ral_reg_kei_i2c_IC_CLR_RX_OVER extends uvm_reg;
	uvm_reg_field CLR_RX_OVER;
	uvm_reg_field RSVD_IC_CLR_RX_OVER;

	function new(string name = "kei_i2c_IC_CLR_RX_OVER");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_RX_OVER = uvm_reg_field::type_id::create("CLR_RX_OVER",,get_full_name());
      this.CLR_RX_OVER.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_RX_OVER = uvm_reg_field::type_id::create("RSVD_IC_CLR_RX_OVER",,get_full_name());
      this.RSVD_IC_CLR_RX_OVER.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_RX_OVER)

endclass : ral_reg_kei_i2c_IC_CLR_RX_OVER


class ral_reg_kei_i2c_IC_CLR_TX_OVER extends uvm_reg;
	uvm_reg_field CLR_TX_OVER;
	uvm_reg_field RSVD_IC_CLR_TX_OVER;

	function new(string name = "kei_i2c_IC_CLR_TX_OVER");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_TX_OVER = uvm_reg_field::type_id::create("CLR_TX_OVER",,get_full_name());
      this.CLR_TX_OVER.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_TX_OVER = uvm_reg_field::type_id::create("RSVD_IC_CLR_TX_OVER",,get_full_name());
      this.RSVD_IC_CLR_TX_OVER.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_TX_OVER)

endclass : ral_reg_kei_i2c_IC_CLR_TX_OVER


class ral_reg_kei_i2c_IC_CLR_RD_REQ extends uvm_reg;
	uvm_reg_field CLR_RD_REQ;
	uvm_reg_field RSVD_IC_CLR_RD_REQ;

	function new(string name = "kei_i2c_IC_CLR_RD_REQ");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_RD_REQ = uvm_reg_field::type_id::create("CLR_RD_REQ",,get_full_name());
      this.CLR_RD_REQ.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_RD_REQ = uvm_reg_field::type_id::create("RSVD_IC_CLR_RD_REQ",,get_full_name());
      this.RSVD_IC_CLR_RD_REQ.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_RD_REQ)

endclass : ral_reg_kei_i2c_IC_CLR_RD_REQ


class ral_reg_kei_i2c_IC_CLR_TX_ABRT extends uvm_reg;
	uvm_reg_field CLR_TX_ABRT;
	uvm_reg_field RSVD_IC_CLR_TX_ABRT;

	function new(string name = "kei_i2c_IC_CLR_TX_ABRT");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_TX_ABRT = uvm_reg_field::type_id::create("CLR_TX_ABRT",,get_full_name());
      this.CLR_TX_ABRT.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_TX_ABRT = uvm_reg_field::type_id::create("RSVD_IC_CLR_TX_ABRT",,get_full_name());
      this.RSVD_IC_CLR_TX_ABRT.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_TX_ABRT)

endclass : ral_reg_kei_i2c_IC_CLR_TX_ABRT


class ral_reg_kei_i2c_IC_CLR_RX_DONE extends uvm_reg;
	uvm_reg_field CLR_RX_DONE;
	uvm_reg_field RSVD_IC_CLR_RX_DONE;

	function new(string name = "kei_i2c_IC_CLR_RX_DONE");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_RX_DONE = uvm_reg_field::type_id::create("CLR_RX_DONE",,get_full_name());
      this.CLR_RX_DONE.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_RX_DONE = uvm_reg_field::type_id::create("RSVD_IC_CLR_RX_DONE",,get_full_name());
      this.RSVD_IC_CLR_RX_DONE.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_RX_DONE)

endclass : ral_reg_kei_i2c_IC_CLR_RX_DONE


class ral_reg_kei_i2c_IC_CLR_ACTIVITY extends uvm_reg;
	uvm_reg_field CLR_ACTIVITY;
	uvm_reg_field RSVD_IC_CLR_ACTIVITY;

	function new(string name = "kei_i2c_IC_CLR_ACTIVITY");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_ACTIVITY = uvm_reg_field::type_id::create("CLR_ACTIVITY",,get_full_name());
      this.CLR_ACTIVITY.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_ACTIVITY = uvm_reg_field::type_id::create("RSVD_IC_CLR_ACTIVITY",,get_full_name());
      this.RSVD_IC_CLR_ACTIVITY.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_ACTIVITY)

endclass : ral_reg_kei_i2c_IC_CLR_ACTIVITY


class ral_reg_kei_i2c_IC_CLR_STOP_DET extends uvm_reg;
	uvm_reg_field CLR_STOP_DET;
	uvm_reg_field RSVD_IC_CLR_STOP_DET;

	function new(string name = "kei_i2c_IC_CLR_STOP_DET");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_STOP_DET = uvm_reg_field::type_id::create("CLR_STOP_DET",,get_full_name());
      this.CLR_STOP_DET.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_STOP_DET = uvm_reg_field::type_id::create("RSVD_IC_CLR_STOP_DET",,get_full_name());
      this.RSVD_IC_CLR_STOP_DET.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_STOP_DET)

endclass : ral_reg_kei_i2c_IC_CLR_STOP_DET


class ral_reg_kei_i2c_IC_CLR_START_DET extends uvm_reg;
	uvm_reg_field CLR_START_DET;
	uvm_reg_field RSVD_IC_CLR_START_DET;

	function new(string name = "kei_i2c_IC_CLR_START_DET");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_START_DET = uvm_reg_field::type_id::create("CLR_START_DET",,get_full_name());
      this.CLR_START_DET.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_START_DET = uvm_reg_field::type_id::create("RSVD_IC_CLR_START_DET",,get_full_name());
      this.RSVD_IC_CLR_START_DET.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_START_DET)

endclass : ral_reg_kei_i2c_IC_CLR_START_DET


class ral_reg_kei_i2c_IC_CLR_GEN_CALL extends uvm_reg;
	uvm_reg_field CLR_GEN_CALL;
	uvm_reg_field RSVD_IC_CLR_GEN_CALL;

	function new(string name = "kei_i2c_IC_CLR_GEN_CALL");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CLR_GEN_CALL = uvm_reg_field::type_id::create("CLR_GEN_CALL",,get_full_name());
      this.CLR_GEN_CALL.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_CLR_GEN_CALL = uvm_reg_field::type_id::create("RSVD_IC_CLR_GEN_CALL",,get_full_name());
      this.RSVD_IC_CLR_GEN_CALL.configure(this, 31, 1, "RO", 1, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_CLR_GEN_CALL)

endclass : ral_reg_kei_i2c_IC_CLR_GEN_CALL


class ral_reg_kei_i2c_IC_ENABLE extends uvm_reg;
	rand uvm_reg_field ENABLE;
	rand uvm_reg_field ABORT;
	rand uvm_reg_field TX_CMD_BLOCK;
	uvm_reg_field RSVD_SDA_STUCK_RECOVERY_ENABLE;
	uvm_reg_field RSVD_IC_ENABLE_1;
	uvm_reg_field RSVD_SMBUS_CLK_RESET;
	uvm_reg_field RSVD_SMBUS_SUSPEND_EN;
	uvm_reg_field RSVD_SMBUS_ALERT_EN;
	uvm_reg_field RSVD_IC_ENABLE_2;

	function new(string name = "kei_i2c_IC_ENABLE");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.ENABLE = uvm_reg_field::type_id::create("ENABLE",,get_full_name());
      this.ENABLE.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
      this.ABORT = uvm_reg_field::type_id::create("ABORT",,get_full_name());
      this.ABORT.configure(this, 1, 1, "RW", 0, 1'h0, 1, 0, 0);
      this.TX_CMD_BLOCK = uvm_reg_field::type_id::create("TX_CMD_BLOCK",,get_full_name());
      this.TX_CMD_BLOCK.configure(this, 1, 2, "RW", 0, 1'h0, 1, 0, 0);
      this.RSVD_SDA_STUCK_RECOVERY_ENABLE = uvm_reg_field::type_id::create("RSVD_SDA_STUCK_RECOVERY_ENABLE",,get_full_name());
      this.RSVD_SDA_STUCK_RECOVERY_ENABLE.configure(this, 1, 3, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_IC_ENABLE_1 = uvm_reg_field::type_id::create("RSVD_IC_ENABLE_1",,get_full_name());
      this.RSVD_IC_ENABLE_1.configure(this, 12, 4, "RO", 0, 12'h0, 1, 0, 0);
      this.RSVD_SMBUS_CLK_RESET = uvm_reg_field::type_id::create("RSVD_SMBUS_CLK_RESET",,get_full_name());
      this.RSVD_SMBUS_CLK_RESET.configure(this, 1, 16, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_SUSPEND_EN = uvm_reg_field::type_id::create("RSVD_SMBUS_SUSPEND_EN",,get_full_name());
      this.RSVD_SMBUS_SUSPEND_EN.configure(this, 1, 17, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_ALERT_EN = uvm_reg_field::type_id::create("RSVD_SMBUS_ALERT_EN",,get_full_name());
      this.RSVD_SMBUS_ALERT_EN.configure(this, 1, 18, "RO", 0, 1'h0, 1, 0, 0);
      this.RSVD_IC_ENABLE_2 = uvm_reg_field::type_id::create("RSVD_IC_ENABLE_2",,get_full_name());
      this.RSVD_IC_ENABLE_2.configure(this, 13, 19, "RO", 0, 13'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_ENABLE)

endclass : ral_reg_kei_i2c_IC_ENABLE


class ral_reg_kei_i2c_IC_STATUS extends uvm_reg;
	uvm_reg_field ACTIVITY;
	uvm_reg_field TFNF;
	uvm_reg_field TFE;
	uvm_reg_field RFNE;
	uvm_reg_field RFF;
	uvm_reg_field MST_ACTIVITY;
	uvm_reg_field SLV_ACTIVITY;
	uvm_reg_field RSVD_MST_HOLD_TX_FIFO_EMPTY;
	uvm_reg_field RSVD_MST_HOLD_RX_FIFO_FULL;
	uvm_reg_field RSVD_SLV_HOLD_TX_FIFO_EMPTY;
	uvm_reg_field RSVD_SLV_HOLD_RX_FIFO_FULL;
	uvm_reg_field RSVD_SDA_STUCK_NOT_RECOVERED;
	uvm_reg_field RSVD_IC_STATUS_1;
	uvm_reg_field RSVD_SMBUS_QUICK_CMD_BIT;
	uvm_reg_field RSVD_SMBUS_SLAVE_ADDR_VALID;
	uvm_reg_field RSVD_SMBUS_SLAVE_ADDR_RESOLVED;
	uvm_reg_field RSVD_SMBUS_SUSPEND_STATUS;
	uvm_reg_field RSVD_SMBUS_ALERT_STATUS;
	uvm_reg_field RSVD_IC_STATUS_2;

	function new(string name = "kei_i2c_IC_STATUS");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.ACTIVITY = uvm_reg_field::type_id::create("ACTIVITY",,get_full_name());
      this.ACTIVITY.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.TFNF = uvm_reg_field::type_id::create("TFNF",,get_full_name());
      this.TFNF.configure(this, 1, 1, "RO", 1, 1'h1, 1, 0, 0);
      this.TFE = uvm_reg_field::type_id::create("TFE",,get_full_name());
      this.TFE.configure(this, 1, 2, "RO", 1, 1'h1, 1, 0, 0);
      this.RFNE = uvm_reg_field::type_id::create("RFNE",,get_full_name());
      this.RFNE.configure(this, 1, 3, "RO", 1, 1'h0, 1, 0, 0);
      this.RFF = uvm_reg_field::type_id::create("RFF",,get_full_name());
      this.RFF.configure(this, 1, 4, "RO", 1, 1'h0, 1, 0, 0);
      this.MST_ACTIVITY = uvm_reg_field::type_id::create("MST_ACTIVITY",,get_full_name());
      this.MST_ACTIVITY.configure(this, 1, 5, "RO", 1, 1'h0, 1, 0, 0);
      this.SLV_ACTIVITY = uvm_reg_field::type_id::create("SLV_ACTIVITY",,get_full_name());
      this.SLV_ACTIVITY.configure(this, 1, 6, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_MST_HOLD_TX_FIFO_EMPTY = uvm_reg_field::type_id::create("RSVD_MST_HOLD_TX_FIFO_EMPTY",,get_full_name());
      this.RSVD_MST_HOLD_TX_FIFO_EMPTY.configure(this, 1, 7, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_MST_HOLD_RX_FIFO_FULL = uvm_reg_field::type_id::create("RSVD_MST_HOLD_RX_FIFO_FULL",,get_full_name());
      this.RSVD_MST_HOLD_RX_FIFO_FULL.configure(this, 1, 8, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_SLV_HOLD_TX_FIFO_EMPTY = uvm_reg_field::type_id::create("RSVD_SLV_HOLD_TX_FIFO_EMPTY",,get_full_name());
      this.RSVD_SLV_HOLD_TX_FIFO_EMPTY.configure(this, 1, 9, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_SLV_HOLD_RX_FIFO_FULL = uvm_reg_field::type_id::create("RSVD_SLV_HOLD_RX_FIFO_FULL",,get_full_name());
      this.RSVD_SLV_HOLD_RX_FIFO_FULL.configure(this, 1, 10, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_SDA_STUCK_NOT_RECOVERED = uvm_reg_field::type_id::create("RSVD_SDA_STUCK_NOT_RECOVERED",,get_full_name());
      this.RSVD_SDA_STUCK_NOT_RECOVERED.configure(this, 1, 11, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_STATUS_1 = uvm_reg_field::type_id::create("RSVD_IC_STATUS_1",,get_full_name());
      this.RSVD_IC_STATUS_1.configure(this, 4, 12, "RO", 1, 4'h0, 1, 0, 0);
      this.RSVD_SMBUS_QUICK_CMD_BIT = uvm_reg_field::type_id::create("RSVD_SMBUS_QUICK_CMD_BIT",,get_full_name());
      this.RSVD_SMBUS_QUICK_CMD_BIT.configure(this, 1, 16, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_SLAVE_ADDR_VALID = uvm_reg_field::type_id::create("RSVD_SMBUS_SLAVE_ADDR_VALID",,get_full_name());
      this.RSVD_SMBUS_SLAVE_ADDR_VALID.configure(this, 1, 17, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_SLAVE_ADDR_RESOLVED = uvm_reg_field::type_id::create("RSVD_SMBUS_SLAVE_ADDR_RESOLVED",,get_full_name());
      this.RSVD_SMBUS_SLAVE_ADDR_RESOLVED.configure(this, 1, 18, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_SUSPEND_STATUS = uvm_reg_field::type_id::create("RSVD_SMBUS_SUSPEND_STATUS",,get_full_name());
      this.RSVD_SMBUS_SUSPEND_STATUS.configure(this, 1, 19, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_SMBUS_ALERT_STATUS = uvm_reg_field::type_id::create("RSVD_SMBUS_ALERT_STATUS",,get_full_name());
      this.RSVD_SMBUS_ALERT_STATUS.configure(this, 1, 20, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_STATUS_2 = uvm_reg_field::type_id::create("RSVD_IC_STATUS_2",,get_full_name());
      this.RSVD_IC_STATUS_2.configure(this, 11, 21, "RO", 1, 11'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_STATUS)

endclass : ral_reg_kei_i2c_IC_STATUS


class ral_reg_kei_i2c_IC_TXFLR extends uvm_reg;
	uvm_reg_field TXFLR;
	uvm_reg_field RSVD_TXFLR;

	function new(string name = "kei_i2c_IC_TXFLR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TXFLR = uvm_reg_field::type_id::create("TXFLR",,get_full_name());
      this.TXFLR.configure(this, 4, 0, "RO", 1, 4'h0, 1, 0, 0);
      this.RSVD_TXFLR = uvm_reg_field::type_id::create("RSVD_TXFLR",,get_full_name());
      this.RSVD_TXFLR.configure(this, 28, 4, "RO", 1, 28'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_TXFLR)

endclass : ral_reg_kei_i2c_IC_TXFLR


class ral_reg_kei_i2c_IC_RXFLR extends uvm_reg;
	uvm_reg_field RXFLR;
	uvm_reg_field RSVD_RXFLR;

	function new(string name = "kei_i2c_IC_RXFLR");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.RXFLR = uvm_reg_field::type_id::create("RXFLR",,get_full_name());
      this.RXFLR.configure(this, 4, 0, "RO", 1, 4'h0, 1, 0, 0);
      this.RSVD_RXFLR = uvm_reg_field::type_id::create("RSVD_RXFLR",,get_full_name());
      this.RSVD_RXFLR.configure(this, 28, 4, "RO", 1, 28'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_RXFLR)

endclass : ral_reg_kei_i2c_IC_RXFLR


class ral_reg_kei_i2c_IC_SDA_HOLD extends uvm_reg;
	rand uvm_reg_field IC_SDA_TX_HOLD;
	rand uvm_reg_field IC_SDA_RX_HOLD;
	uvm_reg_field RSVD_IC_SDA_HOLD;

	function new(string name = "kei_i2c_IC_SDA_HOLD");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_SDA_TX_HOLD = uvm_reg_field::type_id::create("IC_SDA_TX_HOLD",,get_full_name());
      this.IC_SDA_TX_HOLD.configure(this, 16, 0, "RW", 0, 16'h1, 1, 0, 1);
      this.IC_SDA_RX_HOLD = uvm_reg_field::type_id::create("IC_SDA_RX_HOLD",,get_full_name());
      this.IC_SDA_RX_HOLD.configure(this, 8, 16, "RW", 0, 8'h0, 1, 0, 1);
      this.RSVD_IC_SDA_HOLD = uvm_reg_field::type_id::create("RSVD_IC_SDA_HOLD",,get_full_name());
      this.RSVD_IC_SDA_HOLD.configure(this, 8, 24, "RO", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_SDA_HOLD)

endclass : ral_reg_kei_i2c_IC_SDA_HOLD


class ral_reg_kei_i2c_IC_TX_ABRT_SOURCE extends uvm_reg;
	uvm_reg_field ABRT_7B_ADDR_NOACK;
	uvm_reg_field ABRT_10ADDR1_NOACK;
	uvm_reg_field ABRT_10ADDR2_NOACK;
	uvm_reg_field ABRT_TXDATA_NOACK;
	uvm_reg_field ABRT_GCALL_NOACK;
	uvm_reg_field ABRT_GCALL_READ;
	uvm_reg_field ABRT_HS_ACKDET;
	uvm_reg_field ABRT_SBYTE_ACKDET;
	uvm_reg_field ABRT_HS_NORSTRT;
	uvm_reg_field ABRT_SBYTE_NORSTRT;
	uvm_reg_field ABRT_10B_RD_NORSTRT;
	uvm_reg_field ABRT_MASTER_DIS;
	uvm_reg_field ARB_LOST;
	uvm_reg_field ABRT_SLVFLUSH_TXFIFO;
	uvm_reg_field ABRT_SLV_ARBLOST;
	uvm_reg_field ABRT_SLVRD_INTX;
	uvm_reg_field ABRT_USER_ABRT;
	uvm_reg_field RSVD_ABRT_SDA_STUCK_AT_LOW;
	uvm_reg_field RSVD_ABRT_DEVICE_WRITE;
	uvm_reg_field RSVD_IC_TX_ABRT_SOURCE;
	uvm_reg_field TX_FLUSH_CNT;

	function new(string name = "kei_i2c_IC_TX_ABRT_SOURCE");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.ABRT_7B_ADDR_NOACK = uvm_reg_field::type_id::create("ABRT_7B_ADDR_NOACK",,get_full_name());
      this.ABRT_7B_ADDR_NOACK.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_10ADDR1_NOACK = uvm_reg_field::type_id::create("ABRT_10ADDR1_NOACK",,get_full_name());
      this.ABRT_10ADDR1_NOACK.configure(this, 1, 1, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_10ADDR2_NOACK = uvm_reg_field::type_id::create("ABRT_10ADDR2_NOACK",,get_full_name());
      this.ABRT_10ADDR2_NOACK.configure(this, 1, 2, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_TXDATA_NOACK = uvm_reg_field::type_id::create("ABRT_TXDATA_NOACK",,get_full_name());
      this.ABRT_TXDATA_NOACK.configure(this, 1, 3, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_GCALL_NOACK = uvm_reg_field::type_id::create("ABRT_GCALL_NOACK",,get_full_name());
      this.ABRT_GCALL_NOACK.configure(this, 1, 4, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_GCALL_READ = uvm_reg_field::type_id::create("ABRT_GCALL_READ",,get_full_name());
      this.ABRT_GCALL_READ.configure(this, 1, 5, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_HS_ACKDET = uvm_reg_field::type_id::create("ABRT_HS_ACKDET",,get_full_name());
      this.ABRT_HS_ACKDET.configure(this, 1, 6, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_SBYTE_ACKDET = uvm_reg_field::type_id::create("ABRT_SBYTE_ACKDET",,get_full_name());
      this.ABRT_SBYTE_ACKDET.configure(this, 1, 7, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_HS_NORSTRT = uvm_reg_field::type_id::create("ABRT_HS_NORSTRT",,get_full_name());
      this.ABRT_HS_NORSTRT.configure(this, 1, 8, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_SBYTE_NORSTRT = uvm_reg_field::type_id::create("ABRT_SBYTE_NORSTRT",,get_full_name());
      this.ABRT_SBYTE_NORSTRT.configure(this, 1, 9, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_10B_RD_NORSTRT = uvm_reg_field::type_id::create("ABRT_10B_RD_NORSTRT",,get_full_name());
      this.ABRT_10B_RD_NORSTRT.configure(this, 1, 10, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_MASTER_DIS = uvm_reg_field::type_id::create("ABRT_MASTER_DIS",,get_full_name());
      this.ABRT_MASTER_DIS.configure(this, 1, 11, "RO", 1, 1'h0, 1, 0, 0);
      this.ARB_LOST = uvm_reg_field::type_id::create("ARB_LOST",,get_full_name());
      this.ARB_LOST.configure(this, 1, 12, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_SLVFLUSH_TXFIFO = uvm_reg_field::type_id::create("ABRT_SLVFLUSH_TXFIFO",,get_full_name());
      this.ABRT_SLVFLUSH_TXFIFO.configure(this, 1, 13, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_SLV_ARBLOST = uvm_reg_field::type_id::create("ABRT_SLV_ARBLOST",,get_full_name());
      this.ABRT_SLV_ARBLOST.configure(this, 1, 14, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_SLVRD_INTX = uvm_reg_field::type_id::create("ABRT_SLVRD_INTX",,get_full_name());
      this.ABRT_SLVRD_INTX.configure(this, 1, 15, "RO", 1, 1'h0, 1, 0, 0);
      this.ABRT_USER_ABRT = uvm_reg_field::type_id::create("ABRT_USER_ABRT",,get_full_name());
      this.ABRT_USER_ABRT.configure(this, 1, 16, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_ABRT_SDA_STUCK_AT_LOW = uvm_reg_field::type_id::create("RSVD_ABRT_SDA_STUCK_AT_LOW",,get_full_name());
      this.RSVD_ABRT_SDA_STUCK_AT_LOW.configure(this, 1, 17, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_ABRT_DEVICE_WRITE = uvm_reg_field::type_id::create("RSVD_ABRT_DEVICE_WRITE",,get_full_name());
      this.RSVD_ABRT_DEVICE_WRITE.configure(this, 3, 18, "RO", 1, 3'h0, 1, 0, 0);
      this.RSVD_IC_TX_ABRT_SOURCE = uvm_reg_field::type_id::create("RSVD_IC_TX_ABRT_SOURCE",,get_full_name());
      this.RSVD_IC_TX_ABRT_SOURCE.configure(this, 2, 21, "RO", 1, 2'h0, 1, 0, 0);
      this.TX_FLUSH_CNT = uvm_reg_field::type_id::create("TX_FLUSH_CNT",,get_full_name());
      this.TX_FLUSH_CNT.configure(this, 9, 23, "RO", 1, 9'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_TX_ABRT_SOURCE)

endclass : ral_reg_kei_i2c_IC_TX_ABRT_SOURCE


class ral_reg_kei_i2c_IC_SDA_SETUP extends uvm_reg;
	rand uvm_reg_field SDA_SETUP;
	uvm_reg_field RSVD_IC_SDA_SETUP;

	function new(string name = "kei_i2c_IC_SDA_SETUP");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.SDA_SETUP = uvm_reg_field::type_id::create("SDA_SETUP",,get_full_name());
      this.SDA_SETUP.configure(this, 8, 0, "RW", 0, 8'h64, 1, 0, 1);
      this.RSVD_IC_SDA_SETUP = uvm_reg_field::type_id::create("RSVD_IC_SDA_SETUP",,get_full_name());
      this.RSVD_IC_SDA_SETUP.configure(this, 24, 8, "RO", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_SDA_SETUP)

endclass : ral_reg_kei_i2c_IC_SDA_SETUP


class ral_reg_kei_i2c_IC_ACK_GENERAL_CALL extends uvm_reg;
	rand uvm_reg_field ACK_GEN_CALL;
	uvm_reg_field RSVD_IC_ACK_GEN_1_31;

	function new(string name = "kei_i2c_IC_ACK_GENERAL_CALL");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.ACK_GEN_CALL = uvm_reg_field::type_id::create("ACK_GEN_CALL",,get_full_name());
      this.ACK_GEN_CALL.configure(this, 1, 0, "RW", 0, 1'h1, 1, 0, 0);
      this.RSVD_IC_ACK_GEN_1_31 = uvm_reg_field::type_id::create("RSVD_IC_ACK_GEN_1_31",,get_full_name());
      this.RSVD_IC_ACK_GEN_1_31.configure(this, 31, 1, "RO", 0, 31'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_ACK_GENERAL_CALL)

endclass : ral_reg_kei_i2c_IC_ACK_GENERAL_CALL


class ral_reg_kei_i2c_IC_ENABLE_STATUS extends uvm_reg;
	uvm_reg_field IC_EN;
	uvm_reg_field SLV_DISABLED_WHILE_BUSY;
	uvm_reg_field SLV_RX_DATA_LOST;
	uvm_reg_field RSVD_IC_ENABLE_STATUS;

	function new(string name = "kei_i2c_IC_ENABLE_STATUS");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_EN = uvm_reg_field::type_id::create("IC_EN",,get_full_name());
      this.IC_EN.configure(this, 1, 0, "RO", 1, 1'h0, 1, 0, 0);
      this.SLV_DISABLED_WHILE_BUSY = uvm_reg_field::type_id::create("SLV_DISABLED_WHILE_BUSY",,get_full_name());
      this.SLV_DISABLED_WHILE_BUSY.configure(this, 1, 1, "RO", 1, 1'h0, 1, 0, 0);
      this.SLV_RX_DATA_LOST = uvm_reg_field::type_id::create("SLV_RX_DATA_LOST",,get_full_name());
      this.SLV_RX_DATA_LOST.configure(this, 1, 2, "RO", 1, 1'h0, 1, 0, 0);
      this.RSVD_IC_ENABLE_STATUS = uvm_reg_field::type_id::create("RSVD_IC_ENABLE_STATUS",,get_full_name());
      this.RSVD_IC_ENABLE_STATUS.configure(this, 29, 3, "RO", 1, 29'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_ENABLE_STATUS)

endclass : ral_reg_kei_i2c_IC_ENABLE_STATUS


class ral_reg_kei_i2c_IC_FS_SPKLEN extends uvm_reg;
	rand uvm_reg_field IC_FS_SPKLEN;
	uvm_reg_field RSVD_IC_FS_SPKLEN;

	function new(string name = "kei_i2c_IC_FS_SPKLEN");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_FS_SPKLEN = uvm_reg_field::type_id::create("IC_FS_SPKLEN",,get_full_name());
      this.IC_FS_SPKLEN.configure(this, 8, 0, "RW", 0, 8'h5, 1, 0, 1);
      this.RSVD_IC_FS_SPKLEN = uvm_reg_field::type_id::create("RSVD_IC_FS_SPKLEN",,get_full_name());
      this.RSVD_IC_FS_SPKLEN.configure(this, 24, 8, "RO", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_FS_SPKLEN)

endclass : ral_reg_kei_i2c_IC_FS_SPKLEN


class ral_reg_kei_i2c_IC_HS_SPKLEN extends uvm_reg;
	rand uvm_reg_field IC_HS_SPKLEN;
	uvm_reg_field RSVD_IC_HS_SPKLEN;

	function new(string name = "kei_i2c_IC_HS_SPKLEN");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_HS_SPKLEN = uvm_reg_field::type_id::create("IC_HS_SPKLEN",,get_full_name());
      this.IC_HS_SPKLEN.configure(this, 8, 0, "RW", 0, 8'h1, 1, 0, 1);
      this.RSVD_IC_HS_SPKLEN = uvm_reg_field::type_id::create("RSVD_IC_HS_SPKLEN",,get_full_name());
      this.RSVD_IC_HS_SPKLEN.configure(this, 24, 8, "RO", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_HS_SPKLEN)

endclass : ral_reg_kei_i2c_IC_HS_SPKLEN


class ral_reg_kei_i2c_REG_TIMEOUT_RST extends uvm_reg;
	rand uvm_reg_field REG_TIMEOUT_RST_rw;
	uvm_reg_field RSVD_REG_TIMEOUT_RST;

	function new(string name = "kei_i2c_REG_TIMEOUT_RST");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.REG_TIMEOUT_RST_rw = uvm_reg_field::type_id::create("REG_TIMEOUT_RST_rw",,get_full_name());
      this.REG_TIMEOUT_RST_rw.configure(this, 4, 0, "RW", 1, 4'h8, 1, 0, 0);
      this.RSVD_REG_TIMEOUT_RST = uvm_reg_field::type_id::create("RSVD_REG_TIMEOUT_RST",,get_full_name());
      this.RSVD_REG_TIMEOUT_RST.configure(this, 28, 4, "RO", 1, 28'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_REG_TIMEOUT_RST)

endclass : ral_reg_kei_i2c_REG_TIMEOUT_RST


class ral_reg_kei_i2c_IC_COMP_PARAM_1 extends uvm_reg;
	uvm_reg_field APB_DATA_WIDTH;
	uvm_reg_field MAX_SPEED_MODE;
	uvm_reg_field HC_COUNT_VALUES;
	uvm_reg_field INTR_IO;
	uvm_reg_field HAS_DMA;
	uvm_reg_field ADD_ENCODED_PARAMS;
	uvm_reg_field RX_BUFFER_DEPTH;
	uvm_reg_field TX_BUFFER_DEPTH;
	uvm_reg_field RSVD_IC_COMP_PARAM_1;

	function new(string name = "kei_i2c_IC_COMP_PARAM_1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.APB_DATA_WIDTH = uvm_reg_field::type_id::create("APB_DATA_WIDTH",,get_full_name());
      this.APB_DATA_WIDTH.configure(this, 2, 0, "RO", 0, 2'h2, 1, 0, 0);
      this.MAX_SPEED_MODE = uvm_reg_field::type_id::create("MAX_SPEED_MODE",,get_full_name());
      this.MAX_SPEED_MODE.configure(this, 2, 2, "RO", 0, 2'h3, 1, 0, 0);
      this.HC_COUNT_VALUES = uvm_reg_field::type_id::create("HC_COUNT_VALUES",,get_full_name());
      this.HC_COUNT_VALUES.configure(this, 1, 4, "RO", 0, 1'h0, 1, 0, 0);
      this.INTR_IO = uvm_reg_field::type_id::create("INTR_IO",,get_full_name());
      this.INTR_IO.configure(this, 1, 5, "RO", 0, 1'h0, 1, 0, 0);
      this.HAS_DMA = uvm_reg_field::type_id::create("HAS_DMA",,get_full_name());
      this.HAS_DMA.configure(this, 1, 6, "RO", 0, 1'h0, 1, 0, 0);
      this.ADD_ENCODED_PARAMS = uvm_reg_field::type_id::create("ADD_ENCODED_PARAMS",,get_full_name());
      this.ADD_ENCODED_PARAMS.configure(this, 1, 7, "RO", 0, 1'h1, 1, 0, 0);
      this.RX_BUFFER_DEPTH = uvm_reg_field::type_id::create("RX_BUFFER_DEPTH",,get_full_name());
      this.RX_BUFFER_DEPTH.configure(this, 8, 8, "RO", 0, 8'h7, 1, 0, 1);
      this.TX_BUFFER_DEPTH = uvm_reg_field::type_id::create("TX_BUFFER_DEPTH",,get_full_name());
      this.TX_BUFFER_DEPTH.configure(this, 8, 16, "RO", 0, 8'h7, 1, 0, 1);
      this.RSVD_IC_COMP_PARAM_1 = uvm_reg_field::type_id::create("RSVD_IC_COMP_PARAM_1",,get_full_name());
      this.RSVD_IC_COMP_PARAM_1.configure(this, 8, 24, "RO", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_COMP_PARAM_1)

endclass : ral_reg_kei_i2c_IC_COMP_PARAM_1


class ral_reg_kei_i2c_IC_COMP_VERSION extends uvm_reg;
	uvm_reg_field IC_COMP_VERSION;

	function new(string name = "kei_i2c_IC_COMP_VERSION");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_COMP_VERSION = uvm_reg_field::type_id::create("IC_COMP_VERSION",,get_full_name());
      this.IC_COMP_VERSION.configure(this, 32, 0, "RO", 0, 32'h3230322a, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_COMP_VERSION)

endclass : ral_reg_kei_i2c_IC_COMP_VERSION


class ral_reg_kei_i2c_IC_COMP_TYPE extends uvm_reg;
	uvm_reg_field IC_COMP_TYPE;

	function new(string name = "kei_i2c_IC_COMP_TYPE");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.IC_COMP_TYPE = uvm_reg_field::type_id::create("IC_COMP_TYPE",,get_full_name());
      this.IC_COMP_TYPE.configure(this, 32, 0, "RO", 0, 32'h44570140, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_kei_i2c_IC_COMP_TYPE)

endclass : ral_reg_kei_i2c_IC_COMP_TYPE


class ral_block_kei_i2c extends uvm_reg_block;
	rand ral_reg_kei_i2c_IC_CON IC_CON;
	rand ral_reg_kei_i2c_IC_TAR IC_TAR;
	rand ral_reg_kei_i2c_IC_SAR IC_SAR;
	rand ral_reg_kei_i2c_IC_HS_MADDR IC_HS_MADDR;
	rand ral_reg_kei_i2c_IC_DATA_CMD IC_DATA_CMD;
	rand ral_reg_kei_i2c_IC_SS_SCL_HCNT IC_SS_SCL_HCNT;
	rand ral_reg_kei_i2c_IC_SS_SCL_LCNT IC_SS_SCL_LCNT;
	rand ral_reg_kei_i2c_IC_FS_SCL_HCNT IC_FS_SCL_HCNT;
	rand ral_reg_kei_i2c_IC_FS_SCL_LCNT IC_FS_SCL_LCNT;
	rand ral_reg_kei_i2c_IC_HS_SCL_HCNT IC_HS_SCL_HCNT;
	rand ral_reg_kei_i2c_IC_HS_SCL_LCNT IC_HS_SCL_LCNT;
	rand ral_reg_kei_i2c_IC_INTR_STAT IC_INTR_STAT;
	rand ral_reg_kei_i2c_IC_INTR_MASK IC_INTR_MASK;
	rand ral_reg_kei_i2c_IC_RAW_INTR_STAT IC_RAW_INTR_STAT;
	rand ral_reg_kei_i2c_IC_RX_TL IC_RX_TL;
	rand ral_reg_kei_i2c_IC_TX_TL IC_TX_TL;
	rand ral_reg_kei_i2c_IC_CLR_INTR IC_CLR_INTR;
	rand ral_reg_kei_i2c_IC_CLR_RX_UNDER IC_CLR_RX_UNDER;
	rand ral_reg_kei_i2c_IC_CLR_RX_OVER IC_CLR_RX_OVER;
	rand ral_reg_kei_i2c_IC_CLR_TX_OVER IC_CLR_TX_OVER;
	rand ral_reg_kei_i2c_IC_CLR_RD_REQ IC_CLR_RD_REQ;
	rand ral_reg_kei_i2c_IC_CLR_TX_ABRT IC_CLR_TX_ABRT;
	rand ral_reg_kei_i2c_IC_CLR_RX_DONE IC_CLR_RX_DONE;
	rand ral_reg_kei_i2c_IC_CLR_ACTIVITY IC_CLR_ACTIVITY;
	rand ral_reg_kei_i2c_IC_CLR_STOP_DET IC_CLR_STOP_DET;
	rand ral_reg_kei_i2c_IC_CLR_START_DET IC_CLR_START_DET;
	rand ral_reg_kei_i2c_IC_CLR_GEN_CALL IC_CLR_GEN_CALL;
	rand ral_reg_kei_i2c_IC_ENABLE IC_ENABLE;
	rand ral_reg_kei_i2c_IC_STATUS IC_STATUS;
	rand ral_reg_kei_i2c_IC_TXFLR IC_TXFLR;
	rand ral_reg_kei_i2c_IC_RXFLR IC_RXFLR;
	rand ral_reg_kei_i2c_IC_SDA_HOLD IC_SDA_HOLD;
	rand ral_reg_kei_i2c_IC_TX_ABRT_SOURCE IC_TX_ABRT_SOURCE;
	rand ral_reg_kei_i2c_IC_SDA_SETUP IC_SDA_SETUP;
	rand ral_reg_kei_i2c_IC_ACK_GENERAL_CALL IC_ACK_GENERAL_CALL;
	rand ral_reg_kei_i2c_IC_ENABLE_STATUS IC_ENABLE_STATUS;
	rand ral_reg_kei_i2c_IC_FS_SPKLEN IC_FS_SPKLEN;
	rand ral_reg_kei_i2c_IC_HS_SPKLEN IC_HS_SPKLEN;
	rand ral_reg_kei_i2c_REG_TIMEOUT_RST REG_TIMEOUT_RST;
	rand ral_reg_kei_i2c_IC_COMP_PARAM_1 IC_COMP_PARAM_1;
	rand ral_reg_kei_i2c_IC_COMP_VERSION IC_COMP_VERSION;
	rand ral_reg_kei_i2c_IC_COMP_TYPE IC_COMP_TYPE;
   local uvm_reg_data_t m_offset;
	rand uvm_reg_field IC_CON_MASTER_MODE;
	rand uvm_reg_field MASTER_MODE;
	rand uvm_reg_field IC_CON_SPEED;
	rand uvm_reg_field SPEED;
	rand uvm_reg_field IC_CON_IC_10BITADDR_SLAVE;
	rand uvm_reg_field IC_10BITADDR_SLAVE;
	rand uvm_reg_field IC_CON_IC_10BITADDR_MASTER;
	rand uvm_reg_field IC_10BITADDR_MASTER;
	rand uvm_reg_field IC_CON_IC_RESTART_EN;
	rand uvm_reg_field IC_RESTART_EN;
	rand uvm_reg_field IC_CON_IC_SLAVE_DISABLE;
	rand uvm_reg_field IC_SLAVE_DISABLE;
	rand uvm_reg_field IC_CON_STOP_DET_IFADDRESSED;
	rand uvm_reg_field STOP_DET_IFADDRESSED;
	rand uvm_reg_field IC_CON_TX_EMPTY_CTRL;
	rand uvm_reg_field TX_EMPTY_CTRL;
	uvm_reg_field IC_CON_RX_FIFO_FULL_HLD_CTRL;
	uvm_reg_field RX_FIFO_FULL_HLD_CTRL;
	uvm_reg_field IC_CON_STOP_DET_IF_MASTER_ACTIVE;
	uvm_reg_field STOP_DET_IF_MASTER_ACTIVE;
	uvm_reg_field IC_CON_RSVD_BUS_CLEAR_FEATURE_CTRL;
	uvm_reg_field RSVD_BUS_CLEAR_FEATURE_CTRL;
	uvm_reg_field IC_CON_RSVD_IC_CON_1;
	uvm_reg_field RSVD_IC_CON_1;
	uvm_reg_field IC_CON_RSVD_OPTIONAL_SAR_CTRL;
	uvm_reg_field RSVD_OPTIONAL_SAR_CTRL;
	uvm_reg_field IC_CON_RSVD_SMBUS_SLAVE_QUICK_EN;
	uvm_reg_field RSVD_SMBUS_SLAVE_QUICK_EN;
	uvm_reg_field IC_CON_RSVD_SMBUS_ARP_EN;
	uvm_reg_field RSVD_SMBUS_ARP_EN;
	uvm_reg_field IC_CON_RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN;
	uvm_reg_field RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN;
	uvm_reg_field IC_CON_RSVD_IC_CON_2;
	uvm_reg_field RSVD_IC_CON_2;
	rand uvm_reg_field IC_TAR_IC_TAR;
	rand uvm_reg_field IC_TAR_GC_OR_START;
	rand uvm_reg_field GC_OR_START;
	rand uvm_reg_field IC_TAR_SPECIAL;
	rand uvm_reg_field SPECIAL;
	uvm_reg_field IC_TAR_RSVD_IC_10BITADDR_MASTER;
	uvm_reg_field RSVD_IC_10BITADDR_MASTER;
	uvm_reg_field IC_TAR_RSVD_DEVICE_ID;
	uvm_reg_field RSVD_DEVICE_ID;
	uvm_reg_field IC_TAR_RSVD_IC_TAR_1;
	uvm_reg_field RSVD_IC_TAR_1;
	uvm_reg_field IC_TAR_RSVD_SMBUS_QUICK_CMD;
	uvm_reg_field RSVD_SMBUS_QUICK_CMD;
	uvm_reg_field IC_TAR_RSVD_IC_TAR_2;
	uvm_reg_field RSVD_IC_TAR_2;
	rand uvm_reg_field IC_SAR_IC_SAR;
	uvm_reg_field IC_SAR_RSVD_IC_SAR;
	uvm_reg_field RSVD_IC_SAR;
	rand uvm_reg_field IC_HS_MADDR_IC_HS_MAR;
	rand uvm_reg_field IC_HS_MAR;
	uvm_reg_field IC_HS_MADDR_RSVD_IC_HS_MAR;
	uvm_reg_field RSVD_IC_HS_MAR;
	rand uvm_reg_field IC_DATA_CMD_DAT;
	rand uvm_reg_field DAT;
	rand uvm_reg_field IC_DATA_CMD_CMD;
	rand uvm_reg_field CMD;
	uvm_reg_field IC_DATA_CMD_RSVD_STOP;
	uvm_reg_field RSVD_STOP;
	uvm_reg_field IC_DATA_CMD_RSVD_RESTART;
	uvm_reg_field RSVD_RESTART;
	uvm_reg_field IC_DATA_CMD_RSVD_FIRST_DATA_BYTE;
	uvm_reg_field RSVD_FIRST_DATA_BYTE;
	uvm_reg_field IC_DATA_CMD_RSVD_IC_DATA_CMD;
	uvm_reg_field RSVD_IC_DATA_CMD;
	rand uvm_reg_field IC_SS_SCL_HCNT_IC_SS_SCL_HCNT;
	uvm_reg_field IC_SS_SCL_HCNT_RSVD_IC_SS_SCL_HIGH_COUNT;
	uvm_reg_field RSVD_IC_SS_SCL_HIGH_COUNT;
	rand uvm_reg_field IC_SS_SCL_LCNT_IC_SS_SCL_LCNT;
	uvm_reg_field IC_SS_SCL_LCNT_RSVD_IC_SS_SCL_LOW_COUNT;
	uvm_reg_field RSVD_IC_SS_SCL_LOW_COUNT;
	rand uvm_reg_field IC_FS_SCL_HCNT_IC_FS_SCL_HCNT;
	uvm_reg_field IC_FS_SCL_HCNT_RSVD_IC_FS_SCL_HCNT;
	uvm_reg_field RSVD_IC_FS_SCL_HCNT;
	rand uvm_reg_field IC_FS_SCL_LCNT_IC_FS_SCL_LCNT;
	uvm_reg_field IC_FS_SCL_LCNT_RSVD_IC_FS_SCL_LCNT;
	uvm_reg_field RSVD_IC_FS_SCL_LCNT;
	rand uvm_reg_field IC_HS_SCL_HCNT_IC_HS_SCL_HCNT;
	uvm_reg_field IC_HS_SCL_HCNT_RSVD_IC_HS_SCL_HCNT;
	uvm_reg_field RSVD_IC_HS_SCL_HCNT;
	rand uvm_reg_field IC_HS_SCL_LCNT_IC_HS_SCL_LCNT;
	uvm_reg_field IC_HS_SCL_LCNT_RSVD_IC_HS_SCL_LOW_CNT;
	uvm_reg_field RSVD_IC_HS_SCL_LOW_CNT;
	uvm_reg_field IC_INTR_STAT_R_RX_UNDER;
	uvm_reg_field R_RX_UNDER;
	uvm_reg_field IC_INTR_STAT_R_RX_OVER;
	uvm_reg_field R_RX_OVER;
	uvm_reg_field IC_INTR_STAT_R_RX_FULL;
	uvm_reg_field R_RX_FULL;
	uvm_reg_field IC_INTR_STAT_R_TX_OVER;
	uvm_reg_field R_TX_OVER;
	uvm_reg_field IC_INTR_STAT_R_TX_EMPTY;
	uvm_reg_field R_TX_EMPTY;
	uvm_reg_field IC_INTR_STAT_R_RD_REQ;
	uvm_reg_field R_RD_REQ;
	uvm_reg_field IC_INTR_STAT_R_TX_ABRT;
	uvm_reg_field R_TX_ABRT;
	uvm_reg_field IC_INTR_STAT_R_RX_DONE;
	uvm_reg_field R_RX_DONE;
	uvm_reg_field IC_INTR_STAT_R_ACTIVITY;
	uvm_reg_field R_ACTIVITY;
	uvm_reg_field IC_INTR_STAT_R_STOP_DET;
	uvm_reg_field R_STOP_DET;
	uvm_reg_field IC_INTR_STAT_R_START_DET;
	uvm_reg_field R_START_DET;
	uvm_reg_field IC_INTR_STAT_R_GEN_CALL;
	uvm_reg_field R_GEN_CALL;
	uvm_reg_field IC_INTR_STAT_R_RESTART_DET;
	uvm_reg_field R_RESTART_DET;
	uvm_reg_field IC_INTR_STAT_R_MASTER_ON_HOLD;
	uvm_reg_field R_MASTER_ON_HOLD;
	uvm_reg_field IC_INTR_STAT_RSVD_R_SCL_STUCK_AT_LOW;
	uvm_reg_field RSVD_R_SCL_STUCK_AT_LOW;
	uvm_reg_field IC_INTR_STAT_RSVD_IC_INTR_STAT;
	rand uvm_reg_field IC_INTR_MASK_M_RX_UNDER;
	rand uvm_reg_field M_RX_UNDER;
	rand uvm_reg_field IC_INTR_MASK_M_RX_OVER;
	rand uvm_reg_field M_RX_OVER;
	rand uvm_reg_field IC_INTR_MASK_M_RX_FULL;
	rand uvm_reg_field M_RX_FULL;
	rand uvm_reg_field IC_INTR_MASK_M_TX_OVER;
	rand uvm_reg_field M_TX_OVER;
	rand uvm_reg_field IC_INTR_MASK_M_TX_EMPTY;
	rand uvm_reg_field M_TX_EMPTY;
	rand uvm_reg_field IC_INTR_MASK_M_RD_REQ;
	rand uvm_reg_field M_RD_REQ;
	rand uvm_reg_field IC_INTR_MASK_M_TX_ABRT;
	rand uvm_reg_field M_TX_ABRT;
	rand uvm_reg_field IC_INTR_MASK_M_RX_DONE;
	rand uvm_reg_field M_RX_DONE;
	rand uvm_reg_field IC_INTR_MASK_M_ACTIVITY;
	rand uvm_reg_field M_ACTIVITY;
	rand uvm_reg_field IC_INTR_MASK_M_STOP_DET;
	rand uvm_reg_field M_STOP_DET;
	rand uvm_reg_field IC_INTR_MASK_M_START_DET;
	rand uvm_reg_field M_START_DET;
	rand uvm_reg_field IC_INTR_MASK_M_GEN_CALL;
	rand uvm_reg_field M_GEN_CALL;
	uvm_reg_field IC_INTR_MASK_M_RESTART_DET_read_only;
	uvm_reg_field M_RESTART_DET_read_only;
	uvm_reg_field IC_INTR_MASK_M_MASTER_ON_HOLD_read_only;
	uvm_reg_field M_MASTER_ON_HOLD_read_only;
	uvm_reg_field IC_INTR_MASK_RSVD_M_SCL_STUCK_AT_LOW;
	uvm_reg_field RSVD_M_SCL_STUCK_AT_LOW;
	uvm_reg_field IC_INTR_MASK_RSVD_IC_INTR_STAT;
	uvm_reg_field IC_RAW_INTR_STAT_RX_UNDER;
	uvm_reg_field RX_UNDER;
	uvm_reg_field IC_RAW_INTR_STAT_RX_OVER;
	uvm_reg_field RX_OVER;
	uvm_reg_field IC_RAW_INTR_STAT_RX_FULL;
	uvm_reg_field RX_FULL;
	uvm_reg_field IC_RAW_INTR_STAT_TX_OVER;
	uvm_reg_field TX_OVER;
	uvm_reg_field IC_RAW_INTR_STAT_TX_EMPTY;
	uvm_reg_field TX_EMPTY;
	uvm_reg_field IC_RAW_INTR_STAT_RD_REQ;
	uvm_reg_field RD_REQ;
	uvm_reg_field IC_RAW_INTR_STAT_TX_ABRT;
	uvm_reg_field TX_ABRT;
	uvm_reg_field IC_RAW_INTR_STAT_RX_DONE;
	uvm_reg_field RX_DONE;
	uvm_reg_field IC_RAW_INTR_STAT_ACTIVITY;
	uvm_reg_field IC_RAW_INTR_STAT_STOP_DET;
	uvm_reg_field STOP_DET;
	uvm_reg_field IC_RAW_INTR_STAT_START_DET;
	uvm_reg_field START_DET;
	uvm_reg_field IC_RAW_INTR_STAT_GEN_CALL;
	uvm_reg_field GEN_CALL;
	uvm_reg_field IC_RAW_INTR_STAT_RESTART_DET;
	uvm_reg_field RESTART_DET;
	uvm_reg_field IC_RAW_INTR_STAT_MASTER_ON_HOLD;
	uvm_reg_field MASTER_ON_HOLD;
	uvm_reg_field IC_RAW_INTR_STAT_RSVD_SCL_STUCK_AT_LOW;
	uvm_reg_field RSVD_SCL_STUCK_AT_LOW;
	uvm_reg_field IC_RAW_INTR_STAT_RSVD_IC_RAW_INTR_STAT;
	uvm_reg_field RSVD_IC_RAW_INTR_STAT;
	rand uvm_reg_field IC_RX_TL_RX_TL;
	rand uvm_reg_field RX_TL;
	uvm_reg_field IC_RX_TL_RSVD_IC_RX_TL;
	uvm_reg_field RSVD_IC_RX_TL;
	rand uvm_reg_field IC_TX_TL_TX_TL;
	rand uvm_reg_field TX_TL;
	uvm_reg_field IC_TX_TL_RSVD_IC_TX_TL;
	uvm_reg_field RSVD_IC_TX_TL;
	uvm_reg_field IC_CLR_INTR_CLR_INTR;
	uvm_reg_field CLR_INTR;
	uvm_reg_field IC_CLR_INTR_RSVD_IC_CLR_INTR;
	uvm_reg_field RSVD_IC_CLR_INTR;
	uvm_reg_field IC_CLR_RX_UNDER_CLR_RX_UNDER;
	uvm_reg_field CLR_RX_UNDER;
	uvm_reg_field IC_CLR_RX_UNDER_RSVD_IC_CLR_RX_UNDER;
	uvm_reg_field RSVD_IC_CLR_RX_UNDER;
	uvm_reg_field IC_CLR_RX_OVER_CLR_RX_OVER;
	uvm_reg_field CLR_RX_OVER;
	uvm_reg_field IC_CLR_RX_OVER_RSVD_IC_CLR_RX_OVER;
	uvm_reg_field RSVD_IC_CLR_RX_OVER;
	uvm_reg_field IC_CLR_TX_OVER_CLR_TX_OVER;
	uvm_reg_field CLR_TX_OVER;
	uvm_reg_field IC_CLR_TX_OVER_RSVD_IC_CLR_TX_OVER;
	uvm_reg_field RSVD_IC_CLR_TX_OVER;
	uvm_reg_field IC_CLR_RD_REQ_CLR_RD_REQ;
	uvm_reg_field CLR_RD_REQ;
	uvm_reg_field IC_CLR_RD_REQ_RSVD_IC_CLR_RD_REQ;
	uvm_reg_field RSVD_IC_CLR_RD_REQ;
	uvm_reg_field IC_CLR_TX_ABRT_CLR_TX_ABRT;
	uvm_reg_field CLR_TX_ABRT;
	uvm_reg_field IC_CLR_TX_ABRT_RSVD_IC_CLR_TX_ABRT;
	uvm_reg_field RSVD_IC_CLR_TX_ABRT;
	uvm_reg_field IC_CLR_RX_DONE_CLR_RX_DONE;
	uvm_reg_field CLR_RX_DONE;
	uvm_reg_field IC_CLR_RX_DONE_RSVD_IC_CLR_RX_DONE;
	uvm_reg_field RSVD_IC_CLR_RX_DONE;
	uvm_reg_field IC_CLR_ACTIVITY_CLR_ACTIVITY;
	uvm_reg_field CLR_ACTIVITY;
	uvm_reg_field IC_CLR_ACTIVITY_RSVD_IC_CLR_ACTIVITY;
	uvm_reg_field RSVD_IC_CLR_ACTIVITY;
	uvm_reg_field IC_CLR_STOP_DET_CLR_STOP_DET;
	uvm_reg_field CLR_STOP_DET;
	uvm_reg_field IC_CLR_STOP_DET_RSVD_IC_CLR_STOP_DET;
	uvm_reg_field RSVD_IC_CLR_STOP_DET;
	uvm_reg_field IC_CLR_START_DET_CLR_START_DET;
	uvm_reg_field CLR_START_DET;
	uvm_reg_field IC_CLR_START_DET_RSVD_IC_CLR_START_DET;
	uvm_reg_field RSVD_IC_CLR_START_DET;
	uvm_reg_field IC_CLR_GEN_CALL_CLR_GEN_CALL;
	uvm_reg_field CLR_GEN_CALL;
	uvm_reg_field IC_CLR_GEN_CALL_RSVD_IC_CLR_GEN_CALL;
	uvm_reg_field RSVD_IC_CLR_GEN_CALL;
	rand uvm_reg_field IC_ENABLE_ENABLE;
	rand uvm_reg_field ENABLE;
	rand uvm_reg_field IC_ENABLE_ABORT;
	rand uvm_reg_field ABORT;
	rand uvm_reg_field IC_ENABLE_TX_CMD_BLOCK;
	rand uvm_reg_field TX_CMD_BLOCK;
	uvm_reg_field IC_ENABLE_RSVD_SDA_STUCK_RECOVERY_ENABLE;
	uvm_reg_field RSVD_SDA_STUCK_RECOVERY_ENABLE;
	uvm_reg_field IC_ENABLE_RSVD_IC_ENABLE_1;
	uvm_reg_field RSVD_IC_ENABLE_1;
	uvm_reg_field IC_ENABLE_RSVD_SMBUS_CLK_RESET;
	uvm_reg_field RSVD_SMBUS_CLK_RESET;
	uvm_reg_field IC_ENABLE_RSVD_SMBUS_SUSPEND_EN;
	uvm_reg_field RSVD_SMBUS_SUSPEND_EN;
	uvm_reg_field IC_ENABLE_RSVD_SMBUS_ALERT_EN;
	uvm_reg_field RSVD_SMBUS_ALERT_EN;
	uvm_reg_field IC_ENABLE_RSVD_IC_ENABLE_2;
	uvm_reg_field RSVD_IC_ENABLE_2;
	uvm_reg_field IC_STATUS_ACTIVITY;
	uvm_reg_field IC_STATUS_TFNF;
	uvm_reg_field TFNF;
	uvm_reg_field IC_STATUS_TFE;
	uvm_reg_field TFE;
	uvm_reg_field IC_STATUS_RFNE;
	uvm_reg_field RFNE;
	uvm_reg_field IC_STATUS_RFF;
	uvm_reg_field RFF;
	uvm_reg_field IC_STATUS_MST_ACTIVITY;
	uvm_reg_field MST_ACTIVITY;
	uvm_reg_field IC_STATUS_SLV_ACTIVITY;
	uvm_reg_field SLV_ACTIVITY;
	uvm_reg_field IC_STATUS_RSVD_MST_HOLD_TX_FIFO_EMPTY;
	uvm_reg_field RSVD_MST_HOLD_TX_FIFO_EMPTY;
	uvm_reg_field IC_STATUS_RSVD_MST_HOLD_RX_FIFO_FULL;
	uvm_reg_field RSVD_MST_HOLD_RX_FIFO_FULL;
	uvm_reg_field IC_STATUS_RSVD_SLV_HOLD_TX_FIFO_EMPTY;
	uvm_reg_field RSVD_SLV_HOLD_TX_FIFO_EMPTY;
	uvm_reg_field IC_STATUS_RSVD_SLV_HOLD_RX_FIFO_FULL;
	uvm_reg_field RSVD_SLV_HOLD_RX_FIFO_FULL;
	uvm_reg_field IC_STATUS_RSVD_SDA_STUCK_NOT_RECOVERED;
	uvm_reg_field RSVD_SDA_STUCK_NOT_RECOVERED;
	uvm_reg_field IC_STATUS_RSVD_IC_STATUS_1;
	uvm_reg_field RSVD_IC_STATUS_1;
	uvm_reg_field IC_STATUS_RSVD_SMBUS_QUICK_CMD_BIT;
	uvm_reg_field RSVD_SMBUS_QUICK_CMD_BIT;
	uvm_reg_field IC_STATUS_RSVD_SMBUS_SLAVE_ADDR_VALID;
	uvm_reg_field RSVD_SMBUS_SLAVE_ADDR_VALID;
	uvm_reg_field IC_STATUS_RSVD_SMBUS_SLAVE_ADDR_RESOLVED;
	uvm_reg_field RSVD_SMBUS_SLAVE_ADDR_RESOLVED;
	uvm_reg_field IC_STATUS_RSVD_SMBUS_SUSPEND_STATUS;
	uvm_reg_field RSVD_SMBUS_SUSPEND_STATUS;
	uvm_reg_field IC_STATUS_RSVD_SMBUS_ALERT_STATUS;
	uvm_reg_field RSVD_SMBUS_ALERT_STATUS;
	uvm_reg_field IC_STATUS_RSVD_IC_STATUS_2;
	uvm_reg_field RSVD_IC_STATUS_2;
	uvm_reg_field IC_TXFLR_TXFLR;
	uvm_reg_field TXFLR;
	uvm_reg_field IC_TXFLR_RSVD_TXFLR;
	uvm_reg_field RSVD_TXFLR;
	uvm_reg_field IC_RXFLR_RXFLR;
	uvm_reg_field RXFLR;
	uvm_reg_field IC_RXFLR_RSVD_RXFLR;
	uvm_reg_field RSVD_RXFLR;
	rand uvm_reg_field IC_SDA_HOLD_IC_SDA_TX_HOLD;
	rand uvm_reg_field IC_SDA_TX_HOLD;
	rand uvm_reg_field IC_SDA_HOLD_IC_SDA_RX_HOLD;
	rand uvm_reg_field IC_SDA_RX_HOLD;
	uvm_reg_field IC_SDA_HOLD_RSVD_IC_SDA_HOLD;
	uvm_reg_field RSVD_IC_SDA_HOLD;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_7B_ADDR_NOACK;
	uvm_reg_field ABRT_7B_ADDR_NOACK;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_10ADDR1_NOACK;
	uvm_reg_field ABRT_10ADDR1_NOACK;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_10ADDR2_NOACK;
	uvm_reg_field ABRT_10ADDR2_NOACK;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_TXDATA_NOACK;
	uvm_reg_field ABRT_TXDATA_NOACK;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_GCALL_NOACK;
	uvm_reg_field ABRT_GCALL_NOACK;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_GCALL_READ;
	uvm_reg_field ABRT_GCALL_READ;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_HS_ACKDET;
	uvm_reg_field ABRT_HS_ACKDET;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_SBYTE_ACKDET;
	uvm_reg_field ABRT_SBYTE_ACKDET;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_HS_NORSTRT;
	uvm_reg_field ABRT_HS_NORSTRT;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_SBYTE_NORSTRT;
	uvm_reg_field ABRT_SBYTE_NORSTRT;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_10B_RD_NORSTRT;
	uvm_reg_field ABRT_10B_RD_NORSTRT;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_MASTER_DIS;
	uvm_reg_field ABRT_MASTER_DIS;
	uvm_reg_field IC_TX_ABRT_SOURCE_ARB_LOST;
	uvm_reg_field ARB_LOST;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_SLVFLUSH_TXFIFO;
	uvm_reg_field ABRT_SLVFLUSH_TXFIFO;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_SLV_ARBLOST;
	uvm_reg_field ABRT_SLV_ARBLOST;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_SLVRD_INTX;
	uvm_reg_field ABRT_SLVRD_INTX;
	uvm_reg_field IC_TX_ABRT_SOURCE_ABRT_USER_ABRT;
	uvm_reg_field ABRT_USER_ABRT;
	uvm_reg_field IC_TX_ABRT_SOURCE_RSVD_ABRT_SDA_STUCK_AT_LOW;
	uvm_reg_field RSVD_ABRT_SDA_STUCK_AT_LOW;
	uvm_reg_field IC_TX_ABRT_SOURCE_RSVD_ABRT_DEVICE_WRITE;
	uvm_reg_field RSVD_ABRT_DEVICE_WRITE;
	uvm_reg_field IC_TX_ABRT_SOURCE_RSVD_IC_TX_ABRT_SOURCE;
	uvm_reg_field RSVD_IC_TX_ABRT_SOURCE;
	uvm_reg_field IC_TX_ABRT_SOURCE_TX_FLUSH_CNT;
	uvm_reg_field TX_FLUSH_CNT;
	rand uvm_reg_field IC_SDA_SETUP_SDA_SETUP;
	rand uvm_reg_field SDA_SETUP;
	uvm_reg_field IC_SDA_SETUP_RSVD_IC_SDA_SETUP;
	uvm_reg_field RSVD_IC_SDA_SETUP;
	rand uvm_reg_field IC_ACK_GENERAL_CALL_ACK_GEN_CALL;
	rand uvm_reg_field ACK_GEN_CALL;
	uvm_reg_field IC_ACK_GENERAL_CALL_RSVD_IC_ACK_GEN_1_31;
	uvm_reg_field RSVD_IC_ACK_GEN_1_31;
	uvm_reg_field IC_ENABLE_STATUS_IC_EN;
	uvm_reg_field IC_EN;
	uvm_reg_field IC_ENABLE_STATUS_SLV_DISABLED_WHILE_BUSY;
	uvm_reg_field SLV_DISABLED_WHILE_BUSY;
	uvm_reg_field IC_ENABLE_STATUS_SLV_RX_DATA_LOST;
	uvm_reg_field SLV_RX_DATA_LOST;
	uvm_reg_field IC_ENABLE_STATUS_RSVD_IC_ENABLE_STATUS;
	uvm_reg_field RSVD_IC_ENABLE_STATUS;
	rand uvm_reg_field IC_FS_SPKLEN_IC_FS_SPKLEN;
	uvm_reg_field IC_FS_SPKLEN_RSVD_IC_FS_SPKLEN;
	uvm_reg_field RSVD_IC_FS_SPKLEN;
	rand uvm_reg_field IC_HS_SPKLEN_IC_HS_SPKLEN;
	uvm_reg_field IC_HS_SPKLEN_RSVD_IC_HS_SPKLEN;
	uvm_reg_field RSVD_IC_HS_SPKLEN;
	rand uvm_reg_field REG_TIMEOUT_RST_REG_TIMEOUT_RST_rw;
	rand uvm_reg_field REG_TIMEOUT_RST_rw;
	uvm_reg_field REG_TIMEOUT_RST_RSVD_REG_TIMEOUT_RST;
	uvm_reg_field RSVD_REG_TIMEOUT_RST;
	uvm_reg_field IC_COMP_PARAM_1_APB_DATA_WIDTH;
	uvm_reg_field APB_DATA_WIDTH;
	uvm_reg_field IC_COMP_PARAM_1_MAX_SPEED_MODE;
	uvm_reg_field MAX_SPEED_MODE;
	uvm_reg_field IC_COMP_PARAM_1_HC_COUNT_VALUES;
	uvm_reg_field HC_COUNT_VALUES;
	uvm_reg_field IC_COMP_PARAM_1_INTR_IO;
	uvm_reg_field INTR_IO;
	uvm_reg_field IC_COMP_PARAM_1_HAS_DMA;
	uvm_reg_field HAS_DMA;
	uvm_reg_field IC_COMP_PARAM_1_ADD_ENCODED_PARAMS;
	uvm_reg_field ADD_ENCODED_PARAMS;
	uvm_reg_field IC_COMP_PARAM_1_RX_BUFFER_DEPTH;
	uvm_reg_field RX_BUFFER_DEPTH;
	uvm_reg_field IC_COMP_PARAM_1_TX_BUFFER_DEPTH;
	uvm_reg_field TX_BUFFER_DEPTH;
	uvm_reg_field IC_COMP_PARAM_1_RSVD_IC_COMP_PARAM_1;
	uvm_reg_field RSVD_IC_COMP_PARAM_1;
	uvm_reg_field IC_COMP_VERSION_IC_COMP_VERSION;
	uvm_reg_field IC_COMP_TYPE_IC_COMP_TYPE;


covergroup cg_addr (input string name);
	option.per_instance = 1;
option.name = get_name();

	IC_CON : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h0 };
		option.weight = 1;
	}

	IC_TAR : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h4 };
		option.weight = 1;
	}

	IC_SAR : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h8 };
		option.weight = 1;
	}

	IC_HS_MADDR : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'hC };
		option.weight = 1;
	}

	IC_DATA_CMD : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h10 };
		option.weight = 1;
	}

	IC_SS_SCL_HCNT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h14 };
		option.weight = 1;
	}

	IC_SS_SCL_LCNT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h18 };
		option.weight = 1;
	}

	IC_FS_SCL_HCNT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h1C };
		option.weight = 1;
	}

	IC_FS_SCL_LCNT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h20 };
		option.weight = 1;
	}

	IC_HS_SCL_HCNT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h24 };
		option.weight = 1;
	}

	IC_HS_SCL_LCNT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h28 };
		option.weight = 1;
	}

	IC_INTR_STAT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h2C };
		option.weight = 1;
	}

	IC_INTR_MASK : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h30 };
		option.weight = 1;
	}

	IC_RAW_INTR_STAT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h34 };
		option.weight = 1;
	}

	IC_RX_TL : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h38 };
		option.weight = 1;
	}

	IC_TX_TL : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h3C };
		option.weight = 1;
	}

	IC_CLR_INTR : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h40 };
		option.weight = 1;
	}

	IC_CLR_RX_UNDER : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h44 };
		option.weight = 1;
	}

	IC_CLR_RX_OVER : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h48 };
		option.weight = 1;
	}

	IC_CLR_TX_OVER : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h4C };
		option.weight = 1;
	}

	IC_CLR_RD_REQ : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h50 };
		option.weight = 1;
	}

	IC_CLR_TX_ABRT : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h54 };
		option.weight = 1;
	}

	IC_CLR_RX_DONE : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h58 };
		option.weight = 1;
	}

	IC_CLR_ACTIVITY : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h5C };
		option.weight = 1;
	}

	IC_CLR_STOP_DET : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h60 };
		option.weight = 1;
	}

	IC_CLR_START_DET : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h64 };
		option.weight = 1;
	}

	IC_CLR_GEN_CALL : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h68 };
		option.weight = 1;
	}

	IC_ENABLE : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h6C };
		option.weight = 1;
	}

	IC_STATUS : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h70 };
		option.weight = 1;
	}

	IC_TXFLR : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h74 };
		option.weight = 1;
	}

	IC_RXFLR : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h78 };
		option.weight = 1;
	}

	IC_SDA_HOLD : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h7C };
		option.weight = 1;
	}

	IC_TX_ABRT_SOURCE : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h80 };
		option.weight = 1;
	}

	IC_SDA_SETUP : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h94 };
		option.weight = 1;
	}

	IC_ACK_GENERAL_CALL : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h98 };
		option.weight = 1;
	}

	IC_ENABLE_STATUS : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'h9C };
		option.weight = 1;
	}

	IC_FS_SPKLEN : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'hA0 };
		option.weight = 1;
	}

	IC_HS_SPKLEN : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'hA4 };
		option.weight = 1;
	}

	REG_TIMEOUT_RST : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'hF0 };
		option.weight = 1;
	}

	IC_COMP_PARAM_1 : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'hF4 };
		option.weight = 1;
	}

	IC_COMP_VERSION : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'hF8 };
		option.weight = 1;
	}

	IC_COMP_TYPE : coverpoint m_offset {
		bins accessed = { `UVM_REG_ADDR_WIDTH'hFC };
		option.weight = 1;
	}
endgroup
	function new(string name = "kei_i2c");
		super.new(name, build_coverage(UVM_CVR_ADDR_MAP));
		add_coverage(UVM_CVR_ADDR_MAP);
		if (has_coverage(UVM_CVR_ADDR_MAP))
			cg_addr = new("cg_addr");
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.IC_CON = ral_reg_kei_i2c_IC_CON::type_id::create("IC_CON",,get_full_name());
      this.IC_CON.configure(this, null, "");
      this.IC_CON.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_CON.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_CON, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.IC_CON_MASTER_MODE = this.IC_CON.MASTER_MODE;
		this.MASTER_MODE = this.IC_CON.MASTER_MODE;
		this.IC_CON_SPEED = this.IC_CON.SPEED;
		this.SPEED = this.IC_CON.SPEED;
		this.IC_CON_IC_10BITADDR_SLAVE = this.IC_CON.IC_10BITADDR_SLAVE;
		this.IC_10BITADDR_SLAVE = this.IC_CON.IC_10BITADDR_SLAVE;
		this.IC_CON_IC_10BITADDR_MASTER = this.IC_CON.IC_10BITADDR_MASTER;
		this.IC_10BITADDR_MASTER = this.IC_CON.IC_10BITADDR_MASTER;
		this.IC_CON_IC_RESTART_EN = this.IC_CON.IC_RESTART_EN;
		this.IC_RESTART_EN = this.IC_CON.IC_RESTART_EN;
		this.IC_CON_IC_SLAVE_DISABLE = this.IC_CON.IC_SLAVE_DISABLE;
		this.IC_SLAVE_DISABLE = this.IC_CON.IC_SLAVE_DISABLE;
		this.IC_CON_STOP_DET_IFADDRESSED = this.IC_CON.STOP_DET_IFADDRESSED;
		this.STOP_DET_IFADDRESSED = this.IC_CON.STOP_DET_IFADDRESSED;
		this.IC_CON_TX_EMPTY_CTRL = this.IC_CON.TX_EMPTY_CTRL;
		this.TX_EMPTY_CTRL = this.IC_CON.TX_EMPTY_CTRL;
		this.IC_CON_RX_FIFO_FULL_HLD_CTRL = this.IC_CON.RX_FIFO_FULL_HLD_CTRL;
		this.RX_FIFO_FULL_HLD_CTRL = this.IC_CON.RX_FIFO_FULL_HLD_CTRL;
		this.IC_CON_STOP_DET_IF_MASTER_ACTIVE = this.IC_CON.STOP_DET_IF_MASTER_ACTIVE;
		this.STOP_DET_IF_MASTER_ACTIVE = this.IC_CON.STOP_DET_IF_MASTER_ACTIVE;
		this.IC_CON_RSVD_BUS_CLEAR_FEATURE_CTRL = this.IC_CON.RSVD_BUS_CLEAR_FEATURE_CTRL;
		this.RSVD_BUS_CLEAR_FEATURE_CTRL = this.IC_CON.RSVD_BUS_CLEAR_FEATURE_CTRL;
		this.IC_CON_RSVD_IC_CON_1 = this.IC_CON.RSVD_IC_CON_1;
		this.RSVD_IC_CON_1 = this.IC_CON.RSVD_IC_CON_1;
		this.IC_CON_RSVD_OPTIONAL_SAR_CTRL = this.IC_CON.RSVD_OPTIONAL_SAR_CTRL;
		this.RSVD_OPTIONAL_SAR_CTRL = this.IC_CON.RSVD_OPTIONAL_SAR_CTRL;
		this.IC_CON_RSVD_SMBUS_SLAVE_QUICK_EN = this.IC_CON.RSVD_SMBUS_SLAVE_QUICK_EN;
		this.RSVD_SMBUS_SLAVE_QUICK_EN = this.IC_CON.RSVD_SMBUS_SLAVE_QUICK_EN;
		this.IC_CON_RSVD_SMBUS_ARP_EN = this.IC_CON.RSVD_SMBUS_ARP_EN;
		this.RSVD_SMBUS_ARP_EN = this.IC_CON.RSVD_SMBUS_ARP_EN;
		this.IC_CON_RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN = this.IC_CON.RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN;
		this.RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN = this.IC_CON.RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN;
		this.IC_CON_RSVD_IC_CON_2 = this.IC_CON.RSVD_IC_CON_2;
		this.RSVD_IC_CON_2 = this.IC_CON.RSVD_IC_CON_2;
      this.IC_TAR = ral_reg_kei_i2c_IC_TAR::type_id::create("IC_TAR",,get_full_name());
      this.IC_TAR.configure(this, null, "");
      this.IC_TAR.build();
      this.default_map.add_reg(this.IC_TAR, `UVM_REG_ADDR_WIDTH'h4, "RW", 0);
		this.IC_TAR_IC_TAR = this.IC_TAR.IC_TAR;
		this.IC_TAR_GC_OR_START = this.IC_TAR.GC_OR_START;
		this.GC_OR_START = this.IC_TAR.GC_OR_START;
		this.IC_TAR_SPECIAL = this.IC_TAR.SPECIAL;
		this.SPECIAL = this.IC_TAR.SPECIAL;
		this.IC_TAR_RSVD_IC_10BITADDR_MASTER = this.IC_TAR.RSVD_IC_10BITADDR_MASTER;
		this.RSVD_IC_10BITADDR_MASTER = this.IC_TAR.RSVD_IC_10BITADDR_MASTER;
		this.IC_TAR_RSVD_DEVICE_ID = this.IC_TAR.RSVD_DEVICE_ID;
		this.RSVD_DEVICE_ID = this.IC_TAR.RSVD_DEVICE_ID;
		this.IC_TAR_RSVD_IC_TAR_1 = this.IC_TAR.RSVD_IC_TAR_1;
		this.RSVD_IC_TAR_1 = this.IC_TAR.RSVD_IC_TAR_1;
		this.IC_TAR_RSVD_SMBUS_QUICK_CMD = this.IC_TAR.RSVD_SMBUS_QUICK_CMD;
		this.RSVD_SMBUS_QUICK_CMD = this.IC_TAR.RSVD_SMBUS_QUICK_CMD;
		this.IC_TAR_RSVD_IC_TAR_2 = this.IC_TAR.RSVD_IC_TAR_2;
		this.RSVD_IC_TAR_2 = this.IC_TAR.RSVD_IC_TAR_2;
      this.IC_SAR = ral_reg_kei_i2c_IC_SAR::type_id::create("IC_SAR",,get_full_name());
      this.IC_SAR.configure(this, null, "");
      this.IC_SAR.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_SAR.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_SAR, `UVM_REG_ADDR_WIDTH'h8, "RW", 0);
		this.IC_SAR_IC_SAR = this.IC_SAR.IC_SAR;
		this.IC_SAR_RSVD_IC_SAR = this.IC_SAR.RSVD_IC_SAR;
		this.RSVD_IC_SAR = this.IC_SAR.RSVD_IC_SAR;
      this.IC_HS_MADDR = ral_reg_kei_i2c_IC_HS_MADDR::type_id::create("IC_HS_MADDR",,get_full_name());
      this.IC_HS_MADDR.configure(this, null, "");
      this.IC_HS_MADDR.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_HS_MADDR.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_HS_MADDR, `UVM_REG_ADDR_WIDTH'hC, "RW", 0);
		this.IC_HS_MADDR_IC_HS_MAR = this.IC_HS_MADDR.IC_HS_MAR;
		this.IC_HS_MAR = this.IC_HS_MADDR.IC_HS_MAR;
		this.IC_HS_MADDR_RSVD_IC_HS_MAR = this.IC_HS_MADDR.RSVD_IC_HS_MAR;
		this.RSVD_IC_HS_MAR = this.IC_HS_MADDR.RSVD_IC_HS_MAR;
      this.IC_DATA_CMD = ral_reg_kei_i2c_IC_DATA_CMD::type_id::create("IC_DATA_CMD",,get_full_name());
      this.IC_DATA_CMD.configure(this, null, "");
      this.IC_DATA_CMD.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_DATA_CMD.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_DATA_CMD, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.IC_DATA_CMD_DAT = this.IC_DATA_CMD.DAT;
		this.DAT = this.IC_DATA_CMD.DAT;
		this.IC_DATA_CMD_CMD = this.IC_DATA_CMD.CMD;
		this.CMD = this.IC_DATA_CMD.CMD;
		this.IC_DATA_CMD_RSVD_STOP = this.IC_DATA_CMD.RSVD_STOP;
		this.RSVD_STOP = this.IC_DATA_CMD.RSVD_STOP;
		this.IC_DATA_CMD_RSVD_RESTART = this.IC_DATA_CMD.RSVD_RESTART;
		this.RSVD_RESTART = this.IC_DATA_CMD.RSVD_RESTART;
		this.IC_DATA_CMD_RSVD_FIRST_DATA_BYTE = this.IC_DATA_CMD.RSVD_FIRST_DATA_BYTE;
		this.RSVD_FIRST_DATA_BYTE = this.IC_DATA_CMD.RSVD_FIRST_DATA_BYTE;
		this.IC_DATA_CMD_RSVD_IC_DATA_CMD = this.IC_DATA_CMD.RSVD_IC_DATA_CMD;
		this.RSVD_IC_DATA_CMD = this.IC_DATA_CMD.RSVD_IC_DATA_CMD;
      this.IC_SS_SCL_HCNT = ral_reg_kei_i2c_IC_SS_SCL_HCNT::type_id::create("IC_SS_SCL_HCNT",,get_full_name());
      this.IC_SS_SCL_HCNT.configure(this, null, "");
      this.IC_SS_SCL_HCNT.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_SS_SCL_HCNT.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_SS_SCL_HCNT, `UVM_REG_ADDR_WIDTH'h14, "RW", 0);
		this.IC_SS_SCL_HCNT_IC_SS_SCL_HCNT = this.IC_SS_SCL_HCNT.IC_SS_SCL_HCNT;
		this.IC_SS_SCL_HCNT_RSVD_IC_SS_SCL_HIGH_COUNT = this.IC_SS_SCL_HCNT.RSVD_IC_SS_SCL_HIGH_COUNT;
		this.RSVD_IC_SS_SCL_HIGH_COUNT = this.IC_SS_SCL_HCNT.RSVD_IC_SS_SCL_HIGH_COUNT;
      this.IC_SS_SCL_LCNT = ral_reg_kei_i2c_IC_SS_SCL_LCNT::type_id::create("IC_SS_SCL_LCNT",,get_full_name());
      this.IC_SS_SCL_LCNT.configure(this, null, "");
      this.IC_SS_SCL_LCNT.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_SS_SCL_LCNT.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_SS_SCL_LCNT, `UVM_REG_ADDR_WIDTH'h18, "RW", 0);
		this.IC_SS_SCL_LCNT_IC_SS_SCL_LCNT = this.IC_SS_SCL_LCNT.IC_SS_SCL_LCNT;
		this.IC_SS_SCL_LCNT_RSVD_IC_SS_SCL_LOW_COUNT = this.IC_SS_SCL_LCNT.RSVD_IC_SS_SCL_LOW_COUNT;
		this.RSVD_IC_SS_SCL_LOW_COUNT = this.IC_SS_SCL_LCNT.RSVD_IC_SS_SCL_LOW_COUNT;
      this.IC_FS_SCL_HCNT = ral_reg_kei_i2c_IC_FS_SCL_HCNT::type_id::create("IC_FS_SCL_HCNT",,get_full_name());
      this.IC_FS_SCL_HCNT.configure(this, null, "");
      this.IC_FS_SCL_HCNT.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_FS_SCL_HCNT.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_FS_SCL_HCNT, `UVM_REG_ADDR_WIDTH'h1C, "RW", 0);
		this.IC_FS_SCL_HCNT_IC_FS_SCL_HCNT = this.IC_FS_SCL_HCNT.IC_FS_SCL_HCNT;
		this.IC_FS_SCL_HCNT_RSVD_IC_FS_SCL_HCNT = this.IC_FS_SCL_HCNT.RSVD_IC_FS_SCL_HCNT;
		this.RSVD_IC_FS_SCL_HCNT = this.IC_FS_SCL_HCNT.RSVD_IC_FS_SCL_HCNT;
      this.IC_FS_SCL_LCNT = ral_reg_kei_i2c_IC_FS_SCL_LCNT::type_id::create("IC_FS_SCL_LCNT",,get_full_name());
      this.IC_FS_SCL_LCNT.configure(this, null, "");
      this.IC_FS_SCL_LCNT.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_FS_SCL_LCNT.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_FS_SCL_LCNT, `UVM_REG_ADDR_WIDTH'h20, "RW", 0);
		this.IC_FS_SCL_LCNT_IC_FS_SCL_LCNT = this.IC_FS_SCL_LCNT.IC_FS_SCL_LCNT;
		this.IC_FS_SCL_LCNT_RSVD_IC_FS_SCL_LCNT = this.IC_FS_SCL_LCNT.RSVD_IC_FS_SCL_LCNT;
		this.RSVD_IC_FS_SCL_LCNT = this.IC_FS_SCL_LCNT.RSVD_IC_FS_SCL_LCNT;
      this.IC_HS_SCL_HCNT = ral_reg_kei_i2c_IC_HS_SCL_HCNT::type_id::create("IC_HS_SCL_HCNT",,get_full_name());
      this.IC_HS_SCL_HCNT.configure(this, null, "");
      this.IC_HS_SCL_HCNT.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_HS_SCL_HCNT.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_HS_SCL_HCNT, `UVM_REG_ADDR_WIDTH'h24, "RW", 0);
		this.IC_HS_SCL_HCNT_IC_HS_SCL_HCNT = this.IC_HS_SCL_HCNT.IC_HS_SCL_HCNT;
		this.IC_HS_SCL_HCNT_RSVD_IC_HS_SCL_HCNT = this.IC_HS_SCL_HCNT.RSVD_IC_HS_SCL_HCNT;
		this.RSVD_IC_HS_SCL_HCNT = this.IC_HS_SCL_HCNT.RSVD_IC_HS_SCL_HCNT;
      this.IC_HS_SCL_LCNT = ral_reg_kei_i2c_IC_HS_SCL_LCNT::type_id::create("IC_HS_SCL_LCNT",,get_full_name());
      this.IC_HS_SCL_LCNT.configure(this, null, "");
      this.IC_HS_SCL_LCNT.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_HS_SCL_LCNT.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_HS_SCL_LCNT, `UVM_REG_ADDR_WIDTH'h28, "RW", 0);
		this.IC_HS_SCL_LCNT_IC_HS_SCL_LCNT = this.IC_HS_SCL_LCNT.IC_HS_SCL_LCNT;
		this.IC_HS_SCL_LCNT_RSVD_IC_HS_SCL_LOW_CNT = this.IC_HS_SCL_LCNT.RSVD_IC_HS_SCL_LOW_CNT;
		this.RSVD_IC_HS_SCL_LOW_CNT = this.IC_HS_SCL_LCNT.RSVD_IC_HS_SCL_LOW_CNT;
      this.IC_INTR_STAT = ral_reg_kei_i2c_IC_INTR_STAT::type_id::create("IC_INTR_STAT",,get_full_name());
      this.IC_INTR_STAT.configure(this, null, "");
      this.IC_INTR_STAT.build();
      this.default_map.add_reg(this.IC_INTR_STAT, `UVM_REG_ADDR_WIDTH'h2C, "RO", 0);
		this.IC_INTR_STAT_R_RX_UNDER = this.IC_INTR_STAT.R_RX_UNDER;
		this.R_RX_UNDER = this.IC_INTR_STAT.R_RX_UNDER;
		this.IC_INTR_STAT_R_RX_OVER = this.IC_INTR_STAT.R_RX_OVER;
		this.R_RX_OVER = this.IC_INTR_STAT.R_RX_OVER;
		this.IC_INTR_STAT_R_RX_FULL = this.IC_INTR_STAT.R_RX_FULL;
		this.R_RX_FULL = this.IC_INTR_STAT.R_RX_FULL;
		this.IC_INTR_STAT_R_TX_OVER = this.IC_INTR_STAT.R_TX_OVER;
		this.R_TX_OVER = this.IC_INTR_STAT.R_TX_OVER;
		this.IC_INTR_STAT_R_TX_EMPTY = this.IC_INTR_STAT.R_TX_EMPTY;
		this.R_TX_EMPTY = this.IC_INTR_STAT.R_TX_EMPTY;
		this.IC_INTR_STAT_R_RD_REQ = this.IC_INTR_STAT.R_RD_REQ;
		this.R_RD_REQ = this.IC_INTR_STAT.R_RD_REQ;
		this.IC_INTR_STAT_R_TX_ABRT = this.IC_INTR_STAT.R_TX_ABRT;
		this.R_TX_ABRT = this.IC_INTR_STAT.R_TX_ABRT;
		this.IC_INTR_STAT_R_RX_DONE = this.IC_INTR_STAT.R_RX_DONE;
		this.R_RX_DONE = this.IC_INTR_STAT.R_RX_DONE;
		this.IC_INTR_STAT_R_ACTIVITY = this.IC_INTR_STAT.R_ACTIVITY;
		this.R_ACTIVITY = this.IC_INTR_STAT.R_ACTIVITY;
		this.IC_INTR_STAT_R_STOP_DET = this.IC_INTR_STAT.R_STOP_DET;
		this.R_STOP_DET = this.IC_INTR_STAT.R_STOP_DET;
		this.IC_INTR_STAT_R_START_DET = this.IC_INTR_STAT.R_START_DET;
		this.R_START_DET = this.IC_INTR_STAT.R_START_DET;
		this.IC_INTR_STAT_R_GEN_CALL = this.IC_INTR_STAT.R_GEN_CALL;
		this.R_GEN_CALL = this.IC_INTR_STAT.R_GEN_CALL;
		this.IC_INTR_STAT_R_RESTART_DET = this.IC_INTR_STAT.R_RESTART_DET;
		this.R_RESTART_DET = this.IC_INTR_STAT.R_RESTART_DET;
		this.IC_INTR_STAT_R_MASTER_ON_HOLD = this.IC_INTR_STAT.R_MASTER_ON_HOLD;
		this.R_MASTER_ON_HOLD = this.IC_INTR_STAT.R_MASTER_ON_HOLD;
		this.IC_INTR_STAT_RSVD_R_SCL_STUCK_AT_LOW = this.IC_INTR_STAT.RSVD_R_SCL_STUCK_AT_LOW;
		this.RSVD_R_SCL_STUCK_AT_LOW = this.IC_INTR_STAT.RSVD_R_SCL_STUCK_AT_LOW;
		this.IC_INTR_STAT_RSVD_IC_INTR_STAT = this.IC_INTR_STAT.RSVD_IC_INTR_STAT;
      this.IC_INTR_MASK = ral_reg_kei_i2c_IC_INTR_MASK::type_id::create("IC_INTR_MASK",,get_full_name());
      this.IC_INTR_MASK.configure(this, null, "");
      this.IC_INTR_MASK.build();
      this.default_map.add_reg(this.IC_INTR_MASK, `UVM_REG_ADDR_WIDTH'h30, "RW", 0);
		this.IC_INTR_MASK_M_RX_UNDER = this.IC_INTR_MASK.M_RX_UNDER;
		this.M_RX_UNDER = this.IC_INTR_MASK.M_RX_UNDER;
		this.IC_INTR_MASK_M_RX_OVER = this.IC_INTR_MASK.M_RX_OVER;
		this.M_RX_OVER = this.IC_INTR_MASK.M_RX_OVER;
		this.IC_INTR_MASK_M_RX_FULL = this.IC_INTR_MASK.M_RX_FULL;
		this.M_RX_FULL = this.IC_INTR_MASK.M_RX_FULL;
		this.IC_INTR_MASK_M_TX_OVER = this.IC_INTR_MASK.M_TX_OVER;
		this.M_TX_OVER = this.IC_INTR_MASK.M_TX_OVER;
		this.IC_INTR_MASK_M_TX_EMPTY = this.IC_INTR_MASK.M_TX_EMPTY;
		this.M_TX_EMPTY = this.IC_INTR_MASK.M_TX_EMPTY;
		this.IC_INTR_MASK_M_RD_REQ = this.IC_INTR_MASK.M_RD_REQ;
		this.M_RD_REQ = this.IC_INTR_MASK.M_RD_REQ;
		this.IC_INTR_MASK_M_TX_ABRT = this.IC_INTR_MASK.M_TX_ABRT;
		this.M_TX_ABRT = this.IC_INTR_MASK.M_TX_ABRT;
		this.IC_INTR_MASK_M_RX_DONE = this.IC_INTR_MASK.M_RX_DONE;
		this.M_RX_DONE = this.IC_INTR_MASK.M_RX_DONE;
		this.IC_INTR_MASK_M_ACTIVITY = this.IC_INTR_MASK.M_ACTIVITY;
		this.M_ACTIVITY = this.IC_INTR_MASK.M_ACTIVITY;
		this.IC_INTR_MASK_M_STOP_DET = this.IC_INTR_MASK.M_STOP_DET;
		this.M_STOP_DET = this.IC_INTR_MASK.M_STOP_DET;
		this.IC_INTR_MASK_M_START_DET = this.IC_INTR_MASK.M_START_DET;
		this.M_START_DET = this.IC_INTR_MASK.M_START_DET;
		this.IC_INTR_MASK_M_GEN_CALL = this.IC_INTR_MASK.M_GEN_CALL;
		this.M_GEN_CALL = this.IC_INTR_MASK.M_GEN_CALL;
		this.IC_INTR_MASK_M_RESTART_DET_read_only = this.IC_INTR_MASK.M_RESTART_DET_read_only;
		this.M_RESTART_DET_read_only = this.IC_INTR_MASK.M_RESTART_DET_read_only;
		this.IC_INTR_MASK_M_MASTER_ON_HOLD_read_only = this.IC_INTR_MASK.M_MASTER_ON_HOLD_read_only;
		this.M_MASTER_ON_HOLD_read_only = this.IC_INTR_MASK.M_MASTER_ON_HOLD_read_only;
		this.IC_INTR_MASK_RSVD_M_SCL_STUCK_AT_LOW = this.IC_INTR_MASK.RSVD_M_SCL_STUCK_AT_LOW;
		this.RSVD_M_SCL_STUCK_AT_LOW = this.IC_INTR_MASK.RSVD_M_SCL_STUCK_AT_LOW;
		this.IC_INTR_MASK_RSVD_IC_INTR_STAT = this.IC_INTR_MASK.RSVD_IC_INTR_STAT;
      this.IC_RAW_INTR_STAT = ral_reg_kei_i2c_IC_RAW_INTR_STAT::type_id::create("IC_RAW_INTR_STAT",,get_full_name());
      this.IC_RAW_INTR_STAT.configure(this, null, "");
      this.IC_RAW_INTR_STAT.build();
      this.default_map.add_reg(this.IC_RAW_INTR_STAT, `UVM_REG_ADDR_WIDTH'h34, "RO", 0);
		this.IC_RAW_INTR_STAT_RX_UNDER = this.IC_RAW_INTR_STAT.RX_UNDER;
		this.RX_UNDER = this.IC_RAW_INTR_STAT.RX_UNDER;
		this.IC_RAW_INTR_STAT_RX_OVER = this.IC_RAW_INTR_STAT.RX_OVER;
		this.RX_OVER = this.IC_RAW_INTR_STAT.RX_OVER;
		this.IC_RAW_INTR_STAT_RX_FULL = this.IC_RAW_INTR_STAT.RX_FULL;
		this.RX_FULL = this.IC_RAW_INTR_STAT.RX_FULL;
		this.IC_RAW_INTR_STAT_TX_OVER = this.IC_RAW_INTR_STAT.TX_OVER;
		this.TX_OVER = this.IC_RAW_INTR_STAT.TX_OVER;
		this.IC_RAW_INTR_STAT_TX_EMPTY = this.IC_RAW_INTR_STAT.TX_EMPTY;
		this.TX_EMPTY = this.IC_RAW_INTR_STAT.TX_EMPTY;
		this.IC_RAW_INTR_STAT_RD_REQ = this.IC_RAW_INTR_STAT.RD_REQ;
		this.RD_REQ = this.IC_RAW_INTR_STAT.RD_REQ;
		this.IC_RAW_INTR_STAT_TX_ABRT = this.IC_RAW_INTR_STAT.TX_ABRT;
		this.TX_ABRT = this.IC_RAW_INTR_STAT.TX_ABRT;
		this.IC_RAW_INTR_STAT_RX_DONE = this.IC_RAW_INTR_STAT.RX_DONE;
		this.RX_DONE = this.IC_RAW_INTR_STAT.RX_DONE;
		this.IC_RAW_INTR_STAT_ACTIVITY = this.IC_RAW_INTR_STAT.ACTIVITY;
		this.IC_RAW_INTR_STAT_STOP_DET = this.IC_RAW_INTR_STAT.STOP_DET;
		this.STOP_DET = this.IC_RAW_INTR_STAT.STOP_DET;
		this.IC_RAW_INTR_STAT_START_DET = this.IC_RAW_INTR_STAT.START_DET;
		this.START_DET = this.IC_RAW_INTR_STAT.START_DET;
		this.IC_RAW_INTR_STAT_GEN_CALL = this.IC_RAW_INTR_STAT.GEN_CALL;
		this.GEN_CALL = this.IC_RAW_INTR_STAT.GEN_CALL;
		this.IC_RAW_INTR_STAT_RESTART_DET = this.IC_RAW_INTR_STAT.RESTART_DET;
		this.RESTART_DET = this.IC_RAW_INTR_STAT.RESTART_DET;
		this.IC_RAW_INTR_STAT_MASTER_ON_HOLD = this.IC_RAW_INTR_STAT.MASTER_ON_HOLD;
		this.MASTER_ON_HOLD = this.IC_RAW_INTR_STAT.MASTER_ON_HOLD;
		this.IC_RAW_INTR_STAT_RSVD_SCL_STUCK_AT_LOW = this.IC_RAW_INTR_STAT.RSVD_SCL_STUCK_AT_LOW;
		this.RSVD_SCL_STUCK_AT_LOW = this.IC_RAW_INTR_STAT.RSVD_SCL_STUCK_AT_LOW;
		this.IC_RAW_INTR_STAT_RSVD_IC_RAW_INTR_STAT = this.IC_RAW_INTR_STAT.RSVD_IC_RAW_INTR_STAT;
		this.RSVD_IC_RAW_INTR_STAT = this.IC_RAW_INTR_STAT.RSVD_IC_RAW_INTR_STAT;
      this.IC_RX_TL = ral_reg_kei_i2c_IC_RX_TL::type_id::create("IC_RX_TL",,get_full_name());
      this.IC_RX_TL.configure(this, null, "");
      this.IC_RX_TL.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_RX_TL.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_RX_TL, `UVM_REG_ADDR_WIDTH'h38, "RW", 0);
		this.IC_RX_TL_RX_TL = this.IC_RX_TL.RX_TL;
		this.RX_TL = this.IC_RX_TL.RX_TL;
		this.IC_RX_TL_RSVD_IC_RX_TL = this.IC_RX_TL.RSVD_IC_RX_TL;
		this.RSVD_IC_RX_TL = this.IC_RX_TL.RSVD_IC_RX_TL;
      this.IC_TX_TL = ral_reg_kei_i2c_IC_TX_TL::type_id::create("IC_TX_TL",,get_full_name());
      this.IC_TX_TL.configure(this, null, "");
      this.IC_TX_TL.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_TX_TL.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_TX_TL, `UVM_REG_ADDR_WIDTH'h3C, "RW", 0);
		this.IC_TX_TL_TX_TL = this.IC_TX_TL.TX_TL;
		this.TX_TL = this.IC_TX_TL.TX_TL;
		this.IC_TX_TL_RSVD_IC_TX_TL = this.IC_TX_TL.RSVD_IC_TX_TL;
		this.RSVD_IC_TX_TL = this.IC_TX_TL.RSVD_IC_TX_TL;
      this.IC_CLR_INTR = ral_reg_kei_i2c_IC_CLR_INTR::type_id::create("IC_CLR_INTR",,get_full_name());
      this.IC_CLR_INTR.configure(this, null, "");
      this.IC_CLR_INTR.build();
      this.default_map.add_reg(this.IC_CLR_INTR, `UVM_REG_ADDR_WIDTH'h40, "RO", 0);
		this.IC_CLR_INTR_CLR_INTR = this.IC_CLR_INTR.CLR_INTR;
		this.CLR_INTR = this.IC_CLR_INTR.CLR_INTR;
		this.IC_CLR_INTR_RSVD_IC_CLR_INTR = this.IC_CLR_INTR.RSVD_IC_CLR_INTR;
		this.RSVD_IC_CLR_INTR = this.IC_CLR_INTR.RSVD_IC_CLR_INTR;
      this.IC_CLR_RX_UNDER = ral_reg_kei_i2c_IC_CLR_RX_UNDER::type_id::create("IC_CLR_RX_UNDER",,get_full_name());
      this.IC_CLR_RX_UNDER.configure(this, null, "");
      this.IC_CLR_RX_UNDER.build();
      this.default_map.add_reg(this.IC_CLR_RX_UNDER, `UVM_REG_ADDR_WIDTH'h44, "RO", 0);
		this.IC_CLR_RX_UNDER_CLR_RX_UNDER = this.IC_CLR_RX_UNDER.CLR_RX_UNDER;
		this.CLR_RX_UNDER = this.IC_CLR_RX_UNDER.CLR_RX_UNDER;
		this.IC_CLR_RX_UNDER_RSVD_IC_CLR_RX_UNDER = this.IC_CLR_RX_UNDER.RSVD_IC_CLR_RX_UNDER;
		this.RSVD_IC_CLR_RX_UNDER = this.IC_CLR_RX_UNDER.RSVD_IC_CLR_RX_UNDER;
      this.IC_CLR_RX_OVER = ral_reg_kei_i2c_IC_CLR_RX_OVER::type_id::create("IC_CLR_RX_OVER",,get_full_name());
      this.IC_CLR_RX_OVER.configure(this, null, "");
      this.IC_CLR_RX_OVER.build();
      this.default_map.add_reg(this.IC_CLR_RX_OVER, `UVM_REG_ADDR_WIDTH'h48, "RO", 0);
		this.IC_CLR_RX_OVER_CLR_RX_OVER = this.IC_CLR_RX_OVER.CLR_RX_OVER;
		this.CLR_RX_OVER = this.IC_CLR_RX_OVER.CLR_RX_OVER;
		this.IC_CLR_RX_OVER_RSVD_IC_CLR_RX_OVER = this.IC_CLR_RX_OVER.RSVD_IC_CLR_RX_OVER;
		this.RSVD_IC_CLR_RX_OVER = this.IC_CLR_RX_OVER.RSVD_IC_CLR_RX_OVER;
      this.IC_CLR_TX_OVER = ral_reg_kei_i2c_IC_CLR_TX_OVER::type_id::create("IC_CLR_TX_OVER",,get_full_name());
      this.IC_CLR_TX_OVER.configure(this, null, "");
      this.IC_CLR_TX_OVER.build();
      this.default_map.add_reg(this.IC_CLR_TX_OVER, `UVM_REG_ADDR_WIDTH'h4C, "RO", 0);
		this.IC_CLR_TX_OVER_CLR_TX_OVER = this.IC_CLR_TX_OVER.CLR_TX_OVER;
		this.CLR_TX_OVER = this.IC_CLR_TX_OVER.CLR_TX_OVER;
		this.IC_CLR_TX_OVER_RSVD_IC_CLR_TX_OVER = this.IC_CLR_TX_OVER.RSVD_IC_CLR_TX_OVER;
		this.RSVD_IC_CLR_TX_OVER = this.IC_CLR_TX_OVER.RSVD_IC_CLR_TX_OVER;
      this.IC_CLR_RD_REQ = ral_reg_kei_i2c_IC_CLR_RD_REQ::type_id::create("IC_CLR_RD_REQ",,get_full_name());
      this.IC_CLR_RD_REQ.configure(this, null, "");
      this.IC_CLR_RD_REQ.build();
      this.default_map.add_reg(this.IC_CLR_RD_REQ, `UVM_REG_ADDR_WIDTH'h50, "RO", 0);
		this.IC_CLR_RD_REQ_CLR_RD_REQ = this.IC_CLR_RD_REQ.CLR_RD_REQ;
		this.CLR_RD_REQ = this.IC_CLR_RD_REQ.CLR_RD_REQ;
		this.IC_CLR_RD_REQ_RSVD_IC_CLR_RD_REQ = this.IC_CLR_RD_REQ.RSVD_IC_CLR_RD_REQ;
		this.RSVD_IC_CLR_RD_REQ = this.IC_CLR_RD_REQ.RSVD_IC_CLR_RD_REQ;
      this.IC_CLR_TX_ABRT = ral_reg_kei_i2c_IC_CLR_TX_ABRT::type_id::create("IC_CLR_TX_ABRT",,get_full_name());
      this.IC_CLR_TX_ABRT.configure(this, null, "");
      this.IC_CLR_TX_ABRT.build();
      this.default_map.add_reg(this.IC_CLR_TX_ABRT, `UVM_REG_ADDR_WIDTH'h54, "RO", 0);
		this.IC_CLR_TX_ABRT_CLR_TX_ABRT = this.IC_CLR_TX_ABRT.CLR_TX_ABRT;
		this.CLR_TX_ABRT = this.IC_CLR_TX_ABRT.CLR_TX_ABRT;
		this.IC_CLR_TX_ABRT_RSVD_IC_CLR_TX_ABRT = this.IC_CLR_TX_ABRT.RSVD_IC_CLR_TX_ABRT;
		this.RSVD_IC_CLR_TX_ABRT = this.IC_CLR_TX_ABRT.RSVD_IC_CLR_TX_ABRT;
      this.IC_CLR_RX_DONE = ral_reg_kei_i2c_IC_CLR_RX_DONE::type_id::create("IC_CLR_RX_DONE",,get_full_name());
      this.IC_CLR_RX_DONE.configure(this, null, "");
      this.IC_CLR_RX_DONE.build();
      this.default_map.add_reg(this.IC_CLR_RX_DONE, `UVM_REG_ADDR_WIDTH'h58, "RO", 0);
		this.IC_CLR_RX_DONE_CLR_RX_DONE = this.IC_CLR_RX_DONE.CLR_RX_DONE;
		this.CLR_RX_DONE = this.IC_CLR_RX_DONE.CLR_RX_DONE;
		this.IC_CLR_RX_DONE_RSVD_IC_CLR_RX_DONE = this.IC_CLR_RX_DONE.RSVD_IC_CLR_RX_DONE;
		this.RSVD_IC_CLR_RX_DONE = this.IC_CLR_RX_DONE.RSVD_IC_CLR_RX_DONE;
      this.IC_CLR_ACTIVITY = ral_reg_kei_i2c_IC_CLR_ACTIVITY::type_id::create("IC_CLR_ACTIVITY",,get_full_name());
      this.IC_CLR_ACTIVITY.configure(this, null, "");
      this.IC_CLR_ACTIVITY.build();
      this.default_map.add_reg(this.IC_CLR_ACTIVITY, `UVM_REG_ADDR_WIDTH'h5C, "RO", 0);
		this.IC_CLR_ACTIVITY_CLR_ACTIVITY = this.IC_CLR_ACTIVITY.CLR_ACTIVITY;
		this.CLR_ACTIVITY = this.IC_CLR_ACTIVITY.CLR_ACTIVITY;
		this.IC_CLR_ACTIVITY_RSVD_IC_CLR_ACTIVITY = this.IC_CLR_ACTIVITY.RSVD_IC_CLR_ACTIVITY;
		this.RSVD_IC_CLR_ACTIVITY = this.IC_CLR_ACTIVITY.RSVD_IC_CLR_ACTIVITY;
      this.IC_CLR_STOP_DET = ral_reg_kei_i2c_IC_CLR_STOP_DET::type_id::create("IC_CLR_STOP_DET",,get_full_name());
      this.IC_CLR_STOP_DET.configure(this, null, "");
      this.IC_CLR_STOP_DET.build();
      this.default_map.add_reg(this.IC_CLR_STOP_DET, `UVM_REG_ADDR_WIDTH'h60, "RO", 0);
		this.IC_CLR_STOP_DET_CLR_STOP_DET = this.IC_CLR_STOP_DET.CLR_STOP_DET;
		this.CLR_STOP_DET = this.IC_CLR_STOP_DET.CLR_STOP_DET;
		this.IC_CLR_STOP_DET_RSVD_IC_CLR_STOP_DET = this.IC_CLR_STOP_DET.RSVD_IC_CLR_STOP_DET;
		this.RSVD_IC_CLR_STOP_DET = this.IC_CLR_STOP_DET.RSVD_IC_CLR_STOP_DET;
      this.IC_CLR_START_DET = ral_reg_kei_i2c_IC_CLR_START_DET::type_id::create("IC_CLR_START_DET",,get_full_name());
      this.IC_CLR_START_DET.configure(this, null, "");
      this.IC_CLR_START_DET.build();
      this.default_map.add_reg(this.IC_CLR_START_DET, `UVM_REG_ADDR_WIDTH'h64, "RO", 0);
		this.IC_CLR_START_DET_CLR_START_DET = this.IC_CLR_START_DET.CLR_START_DET;
		this.CLR_START_DET = this.IC_CLR_START_DET.CLR_START_DET;
		this.IC_CLR_START_DET_RSVD_IC_CLR_START_DET = this.IC_CLR_START_DET.RSVD_IC_CLR_START_DET;
		this.RSVD_IC_CLR_START_DET = this.IC_CLR_START_DET.RSVD_IC_CLR_START_DET;
      this.IC_CLR_GEN_CALL = ral_reg_kei_i2c_IC_CLR_GEN_CALL::type_id::create("IC_CLR_GEN_CALL",,get_full_name());
      this.IC_CLR_GEN_CALL.configure(this, null, "");
      this.IC_CLR_GEN_CALL.build();
      this.default_map.add_reg(this.IC_CLR_GEN_CALL, `UVM_REG_ADDR_WIDTH'h68, "RO", 0);
		this.IC_CLR_GEN_CALL_CLR_GEN_CALL = this.IC_CLR_GEN_CALL.CLR_GEN_CALL;
		this.CLR_GEN_CALL = this.IC_CLR_GEN_CALL.CLR_GEN_CALL;
		this.IC_CLR_GEN_CALL_RSVD_IC_CLR_GEN_CALL = this.IC_CLR_GEN_CALL.RSVD_IC_CLR_GEN_CALL;
		this.RSVD_IC_CLR_GEN_CALL = this.IC_CLR_GEN_CALL.RSVD_IC_CLR_GEN_CALL;
      this.IC_ENABLE = ral_reg_kei_i2c_IC_ENABLE::type_id::create("IC_ENABLE",,get_full_name());
      this.IC_ENABLE.configure(this, null, "");
      this.IC_ENABLE.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_ENABLE.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_ENABLE, `UVM_REG_ADDR_WIDTH'h6C, "RW", 0);
		this.IC_ENABLE_ENABLE = this.IC_ENABLE.ENABLE;
		this.ENABLE = this.IC_ENABLE.ENABLE;
		this.IC_ENABLE_ABORT = this.IC_ENABLE.ABORT;
		this.ABORT = this.IC_ENABLE.ABORT;
		this.IC_ENABLE_TX_CMD_BLOCK = this.IC_ENABLE.TX_CMD_BLOCK;
		this.TX_CMD_BLOCK = this.IC_ENABLE.TX_CMD_BLOCK;
		this.IC_ENABLE_RSVD_SDA_STUCK_RECOVERY_ENABLE = this.IC_ENABLE.RSVD_SDA_STUCK_RECOVERY_ENABLE;
		this.RSVD_SDA_STUCK_RECOVERY_ENABLE = this.IC_ENABLE.RSVD_SDA_STUCK_RECOVERY_ENABLE;
		this.IC_ENABLE_RSVD_IC_ENABLE_1 = this.IC_ENABLE.RSVD_IC_ENABLE_1;
		this.RSVD_IC_ENABLE_1 = this.IC_ENABLE.RSVD_IC_ENABLE_1;
		this.IC_ENABLE_RSVD_SMBUS_CLK_RESET = this.IC_ENABLE.RSVD_SMBUS_CLK_RESET;
		this.RSVD_SMBUS_CLK_RESET = this.IC_ENABLE.RSVD_SMBUS_CLK_RESET;
		this.IC_ENABLE_RSVD_SMBUS_SUSPEND_EN = this.IC_ENABLE.RSVD_SMBUS_SUSPEND_EN;
		this.RSVD_SMBUS_SUSPEND_EN = this.IC_ENABLE.RSVD_SMBUS_SUSPEND_EN;
		this.IC_ENABLE_RSVD_SMBUS_ALERT_EN = this.IC_ENABLE.RSVD_SMBUS_ALERT_EN;
		this.RSVD_SMBUS_ALERT_EN = this.IC_ENABLE.RSVD_SMBUS_ALERT_EN;
		this.IC_ENABLE_RSVD_IC_ENABLE_2 = this.IC_ENABLE.RSVD_IC_ENABLE_2;
		this.RSVD_IC_ENABLE_2 = this.IC_ENABLE.RSVD_IC_ENABLE_2;
      this.IC_STATUS = ral_reg_kei_i2c_IC_STATUS::type_id::create("IC_STATUS",,get_full_name());
      this.IC_STATUS.configure(this, null, "");
      this.IC_STATUS.build();
      this.default_map.add_reg(this.IC_STATUS, `UVM_REG_ADDR_WIDTH'h70, "RO", 0);
		this.IC_STATUS_ACTIVITY = this.IC_STATUS.ACTIVITY;
		this.IC_STATUS_TFNF = this.IC_STATUS.TFNF;
		this.TFNF = this.IC_STATUS.TFNF;
		this.IC_STATUS_TFE = this.IC_STATUS.TFE;
		this.TFE = this.IC_STATUS.TFE;
		this.IC_STATUS_RFNE = this.IC_STATUS.RFNE;
		this.RFNE = this.IC_STATUS.RFNE;
		this.IC_STATUS_RFF = this.IC_STATUS.RFF;
		this.RFF = this.IC_STATUS.RFF;
		this.IC_STATUS_MST_ACTIVITY = this.IC_STATUS.MST_ACTIVITY;
		this.MST_ACTIVITY = this.IC_STATUS.MST_ACTIVITY;
		this.IC_STATUS_SLV_ACTIVITY = this.IC_STATUS.SLV_ACTIVITY;
		this.SLV_ACTIVITY = this.IC_STATUS.SLV_ACTIVITY;
		this.IC_STATUS_RSVD_MST_HOLD_TX_FIFO_EMPTY = this.IC_STATUS.RSVD_MST_HOLD_TX_FIFO_EMPTY;
		this.RSVD_MST_HOLD_TX_FIFO_EMPTY = this.IC_STATUS.RSVD_MST_HOLD_TX_FIFO_EMPTY;
		this.IC_STATUS_RSVD_MST_HOLD_RX_FIFO_FULL = this.IC_STATUS.RSVD_MST_HOLD_RX_FIFO_FULL;
		this.RSVD_MST_HOLD_RX_FIFO_FULL = this.IC_STATUS.RSVD_MST_HOLD_RX_FIFO_FULL;
		this.IC_STATUS_RSVD_SLV_HOLD_TX_FIFO_EMPTY = this.IC_STATUS.RSVD_SLV_HOLD_TX_FIFO_EMPTY;
		this.RSVD_SLV_HOLD_TX_FIFO_EMPTY = this.IC_STATUS.RSVD_SLV_HOLD_TX_FIFO_EMPTY;
		this.IC_STATUS_RSVD_SLV_HOLD_RX_FIFO_FULL = this.IC_STATUS.RSVD_SLV_HOLD_RX_FIFO_FULL;
		this.RSVD_SLV_HOLD_RX_FIFO_FULL = this.IC_STATUS.RSVD_SLV_HOLD_RX_FIFO_FULL;
		this.IC_STATUS_RSVD_SDA_STUCK_NOT_RECOVERED = this.IC_STATUS.RSVD_SDA_STUCK_NOT_RECOVERED;
		this.RSVD_SDA_STUCK_NOT_RECOVERED = this.IC_STATUS.RSVD_SDA_STUCK_NOT_RECOVERED;
		this.IC_STATUS_RSVD_IC_STATUS_1 = this.IC_STATUS.RSVD_IC_STATUS_1;
		this.RSVD_IC_STATUS_1 = this.IC_STATUS.RSVD_IC_STATUS_1;
		this.IC_STATUS_RSVD_SMBUS_QUICK_CMD_BIT = this.IC_STATUS.RSVD_SMBUS_QUICK_CMD_BIT;
		this.RSVD_SMBUS_QUICK_CMD_BIT = this.IC_STATUS.RSVD_SMBUS_QUICK_CMD_BIT;
		this.IC_STATUS_RSVD_SMBUS_SLAVE_ADDR_VALID = this.IC_STATUS.RSVD_SMBUS_SLAVE_ADDR_VALID;
		this.RSVD_SMBUS_SLAVE_ADDR_VALID = this.IC_STATUS.RSVD_SMBUS_SLAVE_ADDR_VALID;
		this.IC_STATUS_RSVD_SMBUS_SLAVE_ADDR_RESOLVED = this.IC_STATUS.RSVD_SMBUS_SLAVE_ADDR_RESOLVED;
		this.RSVD_SMBUS_SLAVE_ADDR_RESOLVED = this.IC_STATUS.RSVD_SMBUS_SLAVE_ADDR_RESOLVED;
		this.IC_STATUS_RSVD_SMBUS_SUSPEND_STATUS = this.IC_STATUS.RSVD_SMBUS_SUSPEND_STATUS;
		this.RSVD_SMBUS_SUSPEND_STATUS = this.IC_STATUS.RSVD_SMBUS_SUSPEND_STATUS;
		this.IC_STATUS_RSVD_SMBUS_ALERT_STATUS = this.IC_STATUS.RSVD_SMBUS_ALERT_STATUS;
		this.RSVD_SMBUS_ALERT_STATUS = this.IC_STATUS.RSVD_SMBUS_ALERT_STATUS;
		this.IC_STATUS_RSVD_IC_STATUS_2 = this.IC_STATUS.RSVD_IC_STATUS_2;
		this.RSVD_IC_STATUS_2 = this.IC_STATUS.RSVD_IC_STATUS_2;
      this.IC_TXFLR = ral_reg_kei_i2c_IC_TXFLR::type_id::create("IC_TXFLR",,get_full_name());
      this.IC_TXFLR.configure(this, null, "");
      this.IC_TXFLR.build();
      this.default_map.add_reg(this.IC_TXFLR, `UVM_REG_ADDR_WIDTH'h74, "RO", 0);
		this.IC_TXFLR_TXFLR = this.IC_TXFLR.TXFLR;
		this.TXFLR = this.IC_TXFLR.TXFLR;
		this.IC_TXFLR_RSVD_TXFLR = this.IC_TXFLR.RSVD_TXFLR;
		this.RSVD_TXFLR = this.IC_TXFLR.RSVD_TXFLR;
      this.IC_RXFLR = ral_reg_kei_i2c_IC_RXFLR::type_id::create("IC_RXFLR",,get_full_name());
      this.IC_RXFLR.configure(this, null, "");
      this.IC_RXFLR.build();
      this.default_map.add_reg(this.IC_RXFLR, `UVM_REG_ADDR_WIDTH'h78, "RO", 0);
		this.IC_RXFLR_RXFLR = this.IC_RXFLR.RXFLR;
		this.RXFLR = this.IC_RXFLR.RXFLR;
		this.IC_RXFLR_RSVD_RXFLR = this.IC_RXFLR.RSVD_RXFLR;
		this.RSVD_RXFLR = this.IC_RXFLR.RSVD_RXFLR;
      this.IC_SDA_HOLD = ral_reg_kei_i2c_IC_SDA_HOLD::type_id::create("IC_SDA_HOLD",,get_full_name());
      this.IC_SDA_HOLD.configure(this, null, "");
      this.IC_SDA_HOLD.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_SDA_HOLD.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_SDA_HOLD, `UVM_REG_ADDR_WIDTH'h7C, "RW", 0);
		this.IC_SDA_HOLD_IC_SDA_TX_HOLD = this.IC_SDA_HOLD.IC_SDA_TX_HOLD;
		this.IC_SDA_TX_HOLD = this.IC_SDA_HOLD.IC_SDA_TX_HOLD;
		this.IC_SDA_HOLD_IC_SDA_RX_HOLD = this.IC_SDA_HOLD.IC_SDA_RX_HOLD;
		this.IC_SDA_RX_HOLD = this.IC_SDA_HOLD.IC_SDA_RX_HOLD;
		this.IC_SDA_HOLD_RSVD_IC_SDA_HOLD = this.IC_SDA_HOLD.RSVD_IC_SDA_HOLD;
		this.RSVD_IC_SDA_HOLD = this.IC_SDA_HOLD.RSVD_IC_SDA_HOLD;
      this.IC_TX_ABRT_SOURCE = ral_reg_kei_i2c_IC_TX_ABRT_SOURCE::type_id::create("IC_TX_ABRT_SOURCE",,get_full_name());
      this.IC_TX_ABRT_SOURCE.configure(this, null, "");
      this.IC_TX_ABRT_SOURCE.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_TX_ABRT_SOURCE.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_TX_ABRT_SOURCE, `UVM_REG_ADDR_WIDTH'h80, "RO", 0);
		this.IC_TX_ABRT_SOURCE_ABRT_7B_ADDR_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_7B_ADDR_NOACK;
		this.ABRT_7B_ADDR_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_7B_ADDR_NOACK;
		this.IC_TX_ABRT_SOURCE_ABRT_10ADDR1_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_10ADDR1_NOACK;
		this.ABRT_10ADDR1_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_10ADDR1_NOACK;
		this.IC_TX_ABRT_SOURCE_ABRT_10ADDR2_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_10ADDR2_NOACK;
		this.ABRT_10ADDR2_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_10ADDR2_NOACK;
		this.IC_TX_ABRT_SOURCE_ABRT_TXDATA_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_TXDATA_NOACK;
		this.ABRT_TXDATA_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_TXDATA_NOACK;
		this.IC_TX_ABRT_SOURCE_ABRT_GCALL_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_GCALL_NOACK;
		this.ABRT_GCALL_NOACK = this.IC_TX_ABRT_SOURCE.ABRT_GCALL_NOACK;
		this.IC_TX_ABRT_SOURCE_ABRT_GCALL_READ = this.IC_TX_ABRT_SOURCE.ABRT_GCALL_READ;
		this.ABRT_GCALL_READ = this.IC_TX_ABRT_SOURCE.ABRT_GCALL_READ;
		this.IC_TX_ABRT_SOURCE_ABRT_HS_ACKDET = this.IC_TX_ABRT_SOURCE.ABRT_HS_ACKDET;
		this.ABRT_HS_ACKDET = this.IC_TX_ABRT_SOURCE.ABRT_HS_ACKDET;
		this.IC_TX_ABRT_SOURCE_ABRT_SBYTE_ACKDET = this.IC_TX_ABRT_SOURCE.ABRT_SBYTE_ACKDET;
		this.ABRT_SBYTE_ACKDET = this.IC_TX_ABRT_SOURCE.ABRT_SBYTE_ACKDET;
		this.IC_TX_ABRT_SOURCE_ABRT_HS_NORSTRT = this.IC_TX_ABRT_SOURCE.ABRT_HS_NORSTRT;
		this.ABRT_HS_NORSTRT = this.IC_TX_ABRT_SOURCE.ABRT_HS_NORSTRT;
		this.IC_TX_ABRT_SOURCE_ABRT_SBYTE_NORSTRT = this.IC_TX_ABRT_SOURCE.ABRT_SBYTE_NORSTRT;
		this.ABRT_SBYTE_NORSTRT = this.IC_TX_ABRT_SOURCE.ABRT_SBYTE_NORSTRT;
		this.IC_TX_ABRT_SOURCE_ABRT_10B_RD_NORSTRT = this.IC_TX_ABRT_SOURCE.ABRT_10B_RD_NORSTRT;
		this.ABRT_10B_RD_NORSTRT = this.IC_TX_ABRT_SOURCE.ABRT_10B_RD_NORSTRT;
		this.IC_TX_ABRT_SOURCE_ABRT_MASTER_DIS = this.IC_TX_ABRT_SOURCE.ABRT_MASTER_DIS;
		this.ABRT_MASTER_DIS = this.IC_TX_ABRT_SOURCE.ABRT_MASTER_DIS;
		this.IC_TX_ABRT_SOURCE_ARB_LOST = this.IC_TX_ABRT_SOURCE.ARB_LOST;
		this.ARB_LOST = this.IC_TX_ABRT_SOURCE.ARB_LOST;
		this.IC_TX_ABRT_SOURCE_ABRT_SLVFLUSH_TXFIFO = this.IC_TX_ABRT_SOURCE.ABRT_SLVFLUSH_TXFIFO;
		this.ABRT_SLVFLUSH_TXFIFO = this.IC_TX_ABRT_SOURCE.ABRT_SLVFLUSH_TXFIFO;
		this.IC_TX_ABRT_SOURCE_ABRT_SLV_ARBLOST = this.IC_TX_ABRT_SOURCE.ABRT_SLV_ARBLOST;
		this.ABRT_SLV_ARBLOST = this.IC_TX_ABRT_SOURCE.ABRT_SLV_ARBLOST;
		this.IC_TX_ABRT_SOURCE_ABRT_SLVRD_INTX = this.IC_TX_ABRT_SOURCE.ABRT_SLVRD_INTX;
		this.ABRT_SLVRD_INTX = this.IC_TX_ABRT_SOURCE.ABRT_SLVRD_INTX;
		this.IC_TX_ABRT_SOURCE_ABRT_USER_ABRT = this.IC_TX_ABRT_SOURCE.ABRT_USER_ABRT;
		this.ABRT_USER_ABRT = this.IC_TX_ABRT_SOURCE.ABRT_USER_ABRT;
		this.IC_TX_ABRT_SOURCE_RSVD_ABRT_SDA_STUCK_AT_LOW = this.IC_TX_ABRT_SOURCE.RSVD_ABRT_SDA_STUCK_AT_LOW;
		this.RSVD_ABRT_SDA_STUCK_AT_LOW = this.IC_TX_ABRT_SOURCE.RSVD_ABRT_SDA_STUCK_AT_LOW;
		this.IC_TX_ABRT_SOURCE_RSVD_ABRT_DEVICE_WRITE = this.IC_TX_ABRT_SOURCE.RSVD_ABRT_DEVICE_WRITE;
		this.RSVD_ABRT_DEVICE_WRITE = this.IC_TX_ABRT_SOURCE.RSVD_ABRT_DEVICE_WRITE;
		this.IC_TX_ABRT_SOURCE_RSVD_IC_TX_ABRT_SOURCE = this.IC_TX_ABRT_SOURCE.RSVD_IC_TX_ABRT_SOURCE;
		this.RSVD_IC_TX_ABRT_SOURCE = this.IC_TX_ABRT_SOURCE.RSVD_IC_TX_ABRT_SOURCE;
		this.IC_TX_ABRT_SOURCE_TX_FLUSH_CNT = this.IC_TX_ABRT_SOURCE.TX_FLUSH_CNT;
		this.TX_FLUSH_CNT = this.IC_TX_ABRT_SOURCE.TX_FLUSH_CNT;
      this.IC_SDA_SETUP = ral_reg_kei_i2c_IC_SDA_SETUP::type_id::create("IC_SDA_SETUP",,get_full_name());
      this.IC_SDA_SETUP.configure(this, null, "");
      this.IC_SDA_SETUP.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_SDA_SETUP.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_SDA_SETUP, `UVM_REG_ADDR_WIDTH'h94, "RW", 0);
		this.IC_SDA_SETUP_SDA_SETUP = this.IC_SDA_SETUP.SDA_SETUP;
		this.SDA_SETUP = this.IC_SDA_SETUP.SDA_SETUP;
		this.IC_SDA_SETUP_RSVD_IC_SDA_SETUP = this.IC_SDA_SETUP.RSVD_IC_SDA_SETUP;
		this.RSVD_IC_SDA_SETUP = this.IC_SDA_SETUP.RSVD_IC_SDA_SETUP;
      this.IC_ACK_GENERAL_CALL = ral_reg_kei_i2c_IC_ACK_GENERAL_CALL::type_id::create("IC_ACK_GENERAL_CALL",,get_full_name());
      this.IC_ACK_GENERAL_CALL.configure(this, null, "");
      this.IC_ACK_GENERAL_CALL.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_ACK_GENERAL_CALL.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_ACK_GENERAL_CALL, `UVM_REG_ADDR_WIDTH'h98, "RW", 0);
		this.IC_ACK_GENERAL_CALL_ACK_GEN_CALL = this.IC_ACK_GENERAL_CALL.ACK_GEN_CALL;
		this.ACK_GEN_CALL = this.IC_ACK_GENERAL_CALL.ACK_GEN_CALL;
		this.IC_ACK_GENERAL_CALL_RSVD_IC_ACK_GEN_1_31 = this.IC_ACK_GENERAL_CALL.RSVD_IC_ACK_GEN_1_31;
		this.RSVD_IC_ACK_GEN_1_31 = this.IC_ACK_GENERAL_CALL.RSVD_IC_ACK_GEN_1_31;
      this.IC_ENABLE_STATUS = ral_reg_kei_i2c_IC_ENABLE_STATUS::type_id::create("IC_ENABLE_STATUS",,get_full_name());
      this.IC_ENABLE_STATUS.configure(this, null, "");
      this.IC_ENABLE_STATUS.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_ENABLE_STATUS.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_ENABLE_STATUS, `UVM_REG_ADDR_WIDTH'h9C, "RO", 0);
		this.IC_ENABLE_STATUS_IC_EN = this.IC_ENABLE_STATUS.IC_EN;
		this.IC_EN = this.IC_ENABLE_STATUS.IC_EN;
		this.IC_ENABLE_STATUS_SLV_DISABLED_WHILE_BUSY = this.IC_ENABLE_STATUS.SLV_DISABLED_WHILE_BUSY;
		this.SLV_DISABLED_WHILE_BUSY = this.IC_ENABLE_STATUS.SLV_DISABLED_WHILE_BUSY;
		this.IC_ENABLE_STATUS_SLV_RX_DATA_LOST = this.IC_ENABLE_STATUS.SLV_RX_DATA_LOST;
		this.SLV_RX_DATA_LOST = this.IC_ENABLE_STATUS.SLV_RX_DATA_LOST;
		this.IC_ENABLE_STATUS_RSVD_IC_ENABLE_STATUS = this.IC_ENABLE_STATUS.RSVD_IC_ENABLE_STATUS;
		this.RSVD_IC_ENABLE_STATUS = this.IC_ENABLE_STATUS.RSVD_IC_ENABLE_STATUS;
      this.IC_FS_SPKLEN = ral_reg_kei_i2c_IC_FS_SPKLEN::type_id::create("IC_FS_SPKLEN",,get_full_name());
      this.IC_FS_SPKLEN.configure(this, null, "");
      this.IC_FS_SPKLEN.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_FS_SPKLEN.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_FS_SPKLEN, `UVM_REG_ADDR_WIDTH'hA0, "RW", 0);
		this.IC_FS_SPKLEN_IC_FS_SPKLEN = this.IC_FS_SPKLEN.IC_FS_SPKLEN;
		this.IC_FS_SPKLEN_RSVD_IC_FS_SPKLEN = this.IC_FS_SPKLEN.RSVD_IC_FS_SPKLEN;
		this.RSVD_IC_FS_SPKLEN = this.IC_FS_SPKLEN.RSVD_IC_FS_SPKLEN;
      this.IC_HS_SPKLEN = ral_reg_kei_i2c_IC_HS_SPKLEN::type_id::create("IC_HS_SPKLEN",,get_full_name());
      this.IC_HS_SPKLEN.configure(this, null, "");
      this.IC_HS_SPKLEN.build();
	  uvm_resource_db#(bit)::set({"REG::", IC_HS_SPKLEN.get_full_name()}, "NO_REG_BIT_BASH_TEST", 1, this);
      this.default_map.add_reg(this.IC_HS_SPKLEN, `UVM_REG_ADDR_WIDTH'hA4, "RW", 0);
		this.IC_HS_SPKLEN_IC_HS_SPKLEN = this.IC_HS_SPKLEN.IC_HS_SPKLEN;
		this.IC_HS_SPKLEN_RSVD_IC_HS_SPKLEN = this.IC_HS_SPKLEN.RSVD_IC_HS_SPKLEN;
		this.RSVD_IC_HS_SPKLEN = this.IC_HS_SPKLEN.RSVD_IC_HS_SPKLEN;
      this.REG_TIMEOUT_RST = ral_reg_kei_i2c_REG_TIMEOUT_RST::type_id::create("REG_TIMEOUT_RST",,get_full_name());
      this.REG_TIMEOUT_RST.configure(this, null, "");
      this.REG_TIMEOUT_RST.build();
      this.default_map.add_reg(this.REG_TIMEOUT_RST, `UVM_REG_ADDR_WIDTH'hF0, "RW", 0);
		this.REG_TIMEOUT_RST_REG_TIMEOUT_RST_rw = this.REG_TIMEOUT_RST.REG_TIMEOUT_RST_rw;
		this.REG_TIMEOUT_RST_rw = this.REG_TIMEOUT_RST.REG_TIMEOUT_RST_rw;
		this.REG_TIMEOUT_RST_RSVD_REG_TIMEOUT_RST = this.REG_TIMEOUT_RST.RSVD_REG_TIMEOUT_RST;
		this.RSVD_REG_TIMEOUT_RST = this.REG_TIMEOUT_RST.RSVD_REG_TIMEOUT_RST;
      this.IC_COMP_PARAM_1 = ral_reg_kei_i2c_IC_COMP_PARAM_1::type_id::create("IC_COMP_PARAM_1",,get_full_name());
      this.IC_COMP_PARAM_1.configure(this, null, "");
      this.IC_COMP_PARAM_1.build();
      this.default_map.add_reg(this.IC_COMP_PARAM_1, `UVM_REG_ADDR_WIDTH'hF4, "RO", 0);
		this.IC_COMP_PARAM_1_APB_DATA_WIDTH = this.IC_COMP_PARAM_1.APB_DATA_WIDTH;
		this.APB_DATA_WIDTH = this.IC_COMP_PARAM_1.APB_DATA_WIDTH;
		this.IC_COMP_PARAM_1_MAX_SPEED_MODE = this.IC_COMP_PARAM_1.MAX_SPEED_MODE;
		this.MAX_SPEED_MODE = this.IC_COMP_PARAM_1.MAX_SPEED_MODE;
		this.IC_COMP_PARAM_1_HC_COUNT_VALUES = this.IC_COMP_PARAM_1.HC_COUNT_VALUES;
		this.HC_COUNT_VALUES = this.IC_COMP_PARAM_1.HC_COUNT_VALUES;
		this.IC_COMP_PARAM_1_INTR_IO = this.IC_COMP_PARAM_1.INTR_IO;
		this.INTR_IO = this.IC_COMP_PARAM_1.INTR_IO;
		this.IC_COMP_PARAM_1_HAS_DMA = this.IC_COMP_PARAM_1.HAS_DMA;
		this.HAS_DMA = this.IC_COMP_PARAM_1.HAS_DMA;
		this.IC_COMP_PARAM_1_ADD_ENCODED_PARAMS = this.IC_COMP_PARAM_1.ADD_ENCODED_PARAMS;
		this.ADD_ENCODED_PARAMS = this.IC_COMP_PARAM_1.ADD_ENCODED_PARAMS;
		this.IC_COMP_PARAM_1_RX_BUFFER_DEPTH = this.IC_COMP_PARAM_1.RX_BUFFER_DEPTH;
		this.RX_BUFFER_DEPTH = this.IC_COMP_PARAM_1.RX_BUFFER_DEPTH;
		this.IC_COMP_PARAM_1_TX_BUFFER_DEPTH = this.IC_COMP_PARAM_1.TX_BUFFER_DEPTH;
		this.TX_BUFFER_DEPTH = this.IC_COMP_PARAM_1.TX_BUFFER_DEPTH;
		this.IC_COMP_PARAM_1_RSVD_IC_COMP_PARAM_1 = this.IC_COMP_PARAM_1.RSVD_IC_COMP_PARAM_1;
		this.RSVD_IC_COMP_PARAM_1 = this.IC_COMP_PARAM_1.RSVD_IC_COMP_PARAM_1;
      this.IC_COMP_VERSION = ral_reg_kei_i2c_IC_COMP_VERSION::type_id::create("IC_COMP_VERSION",,get_full_name());
      this.IC_COMP_VERSION.configure(this, null, "");
      this.IC_COMP_VERSION.build();
      this.default_map.add_reg(this.IC_COMP_VERSION, `UVM_REG_ADDR_WIDTH'hF8, "RO", 0);
		this.IC_COMP_VERSION_IC_COMP_VERSION = this.IC_COMP_VERSION.IC_COMP_VERSION;
      this.IC_COMP_TYPE = ral_reg_kei_i2c_IC_COMP_TYPE::type_id::create("IC_COMP_TYPE",,get_full_name());
      this.IC_COMP_TYPE.configure(this, null, "");
      this.IC_COMP_TYPE.build();
      this.default_map.add_reg(this.IC_COMP_TYPE, `UVM_REG_ADDR_WIDTH'hFC, "RO", 0);
		this.IC_COMP_TYPE_IC_COMP_TYPE = this.IC_COMP_TYPE.IC_COMP_TYPE;
   endfunction : build

	`uvm_object_utils(ral_block_kei_i2c)


function void sample(uvm_reg_addr_t offset,
                     bit            is_read,
                     uvm_reg_map    map);
  if (get_coverage(UVM_CVR_ADDR_MAP)) begin
    m_offset = offset;
    cg_addr.sample();
  end
endfunction
endclass : ral_block_kei_i2c



`endif

TOP       = kei_i2c_tb
TEST     ?= kei_i2c_quick_reg_access_test 
VERDI    ?= 0
GUI      ?= 0
COV      ?= 1
PARTCOMP ?= 1
SEED      = `date "+%m%d%H%M%S"`
OUT      ?= out
VERB     ?= UVM_HIGH#{UVM_NONE, UVM_LOW, UVM_MEDIUM, UVM_HIGH}
INCDIR   = +incdir+../../kei_dw_apb_i2c/src \
					 +incdir+../agents/{kei_vip_apb3,kei_vip_i2c} \
					 +incdir+../{cfg,cov,reg,env,seq_lib} \
					 +incdir+../seq_lib/{.,elem_seqs,user_elem_seqs,user_virt_seqs} \
					 +incdir+../tests/{.,user_tests}
TESTLIST = kei_i2c_reg_hw_reset_test \
           kei_i2c_reg_bit_bash_test \
           kei_i2c_reg_access_test \
           kei_i2c_quick_reg_access_test \
           kei_i2c_master_directed_write_packet_test \
           kei_i2c_master_directed_read_packet_test \
           kei_i2c_master_directed_interrupt_test \
           kei_i2c_master_address_cg_test \
           kei_i2c_master_ss_cnt_test \
           kei_i2c_master_fs_cnt_test \
           kei_i2c_master_hs_cnt_test \
           kei_i2c_master_hs_master_code_test \
           kei_i2c_master_sda_control_cg_test \
           kei_i2c_master_timeout_cg_test \
           kei_i2c_master_enabled_cg_test \
           kei_i2c_master_stop_det_intr_test \
           kei_i2c_master_tx_abrt_intr_test \
           kei_i2c_master_tx_over_intr_test \
           kei_i2c_master_rx_full_intr_test \
           kei_i2c_master_rx_over_intr_test \
           kei_i2c_master_rx_under_intr_test \
           kei_i2c_master_10b_rd_norstrt_abrt_test \
           kei_i2c_master_sbyte_norstrt_abrt_test \
           kei_i2c_master_txdata_noack_abrt_test \
           kei_i2c_master_7b_addr_noack_abrt_test \
           kei_i2c_master_10b_addr1_noack_abrt_test \
           kei_i2c_master_10b_addr2_noack_abrt_test \
           kei_i2c_master_hs_norstrt_abrt_test \
           kei_i2c_master_gcall_noack_abrt_test \
           kei_i2c_master_gcall_read_abrt_test \
           kei_i2c_master_sbyte_ackdet_abrt_test \
           kei_i2c_master_hs_ackdet_abrt_test \
           kei_i2c_master_arb_lost_abrt_test \
           kei_i2c_master_master_dis_abrt_test 

VCOMP    = vlogan $(INCDIR) -full64 -sverilog -ntb_opts uvm-1.2 -timescale=1ps/1ps -l $(OUT)/log/comp_$(TOP).log  
ELAB     = vcs -full64 -sverilog -ntb_opts uvm-1.2 -debug_acc+all -debug_region+cell+encrypt -l $(OUT)/log/elab_$(TOP).log -o $(OUT)/obj/kei_i2c_tb.simv
RUN      = $(OUT)/obj/kei_i2c_tb.simv +ntb_random_seed=$(SEED) +UVM_NO_RELNOTES +UVM_VERBOSITY=$(VERB)  
COV_OPTS = -full64 -dir 
CM_DIR  ?= $(OUT)/cov.vdb
CM_REGR_DIR ?= $(OUT)/merge.vdb
CM_NAME ?= $(TEST)_$(SEED)

ifeq (1, $(strip $(PARTCOMP)))
  ELAB += -partcomp -fastpartcomp=j4 
endif

ifeq ($(VERDI),1)
	VCOMP += -kdb -lca
	RUN += -verdi
endif

ifeq ($(GUI),1)
	RUN += -gui
endif

ifeq ($(COV),1)
	ELAB  += -cm line+cond+fsm+tgl+branch+assert -cm_dir $(CM_DIR)
	RUN += -cm line+cond+fsm+tgl+branch+assert -covg_cont_on_error
endif

export SYNOPSYS_SIM_SETUP = ./synopsys_sim.setup

all: clean dcomp comp elab regr mergecov dvemergecov

prepare:
	mkdir -p $(OUT)/work
	mkdir -p $(OUT)/log
	mkdir -p $(OUT)/sim
	mkdir -p $(OUT)/obj
	mkdir -p .shadow

dcomp: prepare
	$(VCOMP)  -f kei_i2c.flist 

comp: dcomp .shadow/compile_uvm .shadow/compile_kei_vip_apb .shadow/compile_kei_vip_i2c
	$(VCOMP)  ../env/kei_i2c_pkg.sv 
	$(VCOMP)  ../tb/kei_i2c_if.sv 
	$(VCOMP)  ../tb/kei_i2c_backdoor_if.sv
	$(VCOMP)  ../tb/kei_i2c_tb.sv 

.shadow/compile_uvm:
	${VCOMP} -ntb_opts uvm-1.2	

.shadow/compile_kei_vip_apb:
	$(VCOMP) ../agents/kei_vip_apb3/kei_vip_apb_if.sv 
	$(VCOMP) ../agents/kei_vip_apb3/kei_vip_apb_pkg.sv 

.shadow/compile_kei_vip_i2c:
	$(VCOMP)  ../agents/kei_vip_i2c/kei_vip_i2c_if.sv 
	$(VCOMP)  ../agents/kei_vip_i2c/kei_vip_i2c_pkg.sv 

elab: comp
	$(ELAB) $(TOP)

run: 
	$(RUN) +UVM_TESTNAME=$(TEST) -l $(OUT)/sim/$(CM_NAME).log -cm_dir $(CM_DIR) -cm_name $(CM_NAME)  

regr: 
	for t in $(TESTLIST); do \
		$(RUN) +UVM_TESTNAME=$$t -l $(OUT)/sim/$$t.log +vpdfile+$(OUT)/sim/$$t_$(SEED)_$(VPDFILE) -cm_dir $(OUT)/$$t.vdb; \
	done

mergecov:
	urg -full64 -format both  -dir $(OUT)/*.vdb -dbname $(CM_REGR_DIR)

dvecov:
	dve $(COV_OPTS) $(CM_DIR)

dvemergecov:
	dve $(COV_OPTS) $(CM_REGR_DIR)

verdicov:
	verdi -cov -plan ../doc/vcs_vplan.hvp -covdir $(CM_DIR)

verdimergecov:
	verdi -cov -plan ../doc/vcs_vplan.hvp -covdir $(CM_REGR_DIR)

htmlmergecov:
	firefox urgReport/dashboard.html

clean:
	-rm -rf csrc DVEfiles ucli.key uvm_dpi.so vc_hdrs.h  *simv* *.vpd *.log *.sml *.fsdb work.* *.vdb
	-rm -rf AN.DB urgReport novas.conf verdiLog vdCovLog novas.rc $(OUT) .shadow
	-rm -rf eman* vhdl_objs_dir
	-rm -rf transcript vsim* regr_ucdb* work kei_i2c_tb kei_i2c_tb.vdb

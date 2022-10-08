TOP       = kei_i2c_tb
TEST     ?= kei_i2c_quick_reg_access_test
VERDI    ?= 0
GUI      ?= 0
COV      ?= 0
SEED      = `date "+%m%d%H%M%S"`
OUT      ?= out
VERB     ?= UVM_HIGH#{UVM_NONE, UVM_LOW, UVM_MEDIUM, UVM_HIGH}
INCDIR   = +incdir+../../kei_dw_apb_i2c/src \
					 +incdir+../agents/{kei_vip_apb3,kei_vip_i2c} \
					 +incdir+../{cfg,cov,reg,env,seq_lib,seq_lib/elem_seqs,tests} 
TESTLIST = kei_i2c_quick_reg_access_test kei_i2c_directed_tx_test kei_i2c_directed_rx_test


VCOMP    = vlogan $(INCDIR) -full64 -sverilog -ntb_opts uvm-1.2 -timescale=1ps/1ps -l $(OUT)/log/comp_$(TB_TOP).log  
ELAB     = vcs -full64 -sverilog -ntb_opts uvm-1.2 -debug_all -l $(OUT)/log/elab_$(TB_TOP).log 
RUN      = simv +ntb_random_seed=$(SEED) +UVM_NO_RELNOTES +UVM_VERBOSITY=$(VERB) 
COVOPTS  = -full64 -userdata ../docs/testcase.data -plan ../docs/uart_vplan.hvp -elfile ../docs/elfile.el -dir $(OUT)/cov.vdb 
CM_NAME  = $(TEST)_seed_$(SEED)

ifeq ($(VERDI),1)
	VCOMP  += -kdb
	RUN += -verdi
endif
ifeq ($(GUI),1)
	RUN += -gui
endif

ifeq ($(COV),1)
	ELAB  += -cm line+cond+fsm+tgl+branch+assert -cm_dir $(OUT)/cov.vdb
	RUN += -cm line+cond+fsm+tgl+branch+assert -covg_cont_on_error
endif

all: clean dcomp comp elab sim_all cov

prepare:
	mkdir -p $(OUT)/work
	mkdir -p $(OUT)/log
	mkdir -p $(OUT)/sim
	mkdir -p $(OUT)/obj
	mkdir -p .shadow
	mkdir -p ../docs/nd_docs

dcomp: prepare
	$(VCOMP)  -f kei_i2c.flist 


comp: .shadow/compile_uvm .shadow/compile_kei_vip_apb .shadow/compile_kei_vip_i2c
	$(VCOMP)  ../env/kei_i2c_pkg.sv 
	$(VCOMP)  ../tb/kei_i2c_if.sv 
	$(VCOMP)  ../tb/kei_i2c_tb.sv 

.shadow/compile_uvm:
	${VCOMP} -ntb_opts uvm-1.2
	@touch $@;

.shadow/compile_kei_vip_apb:
	$(VCOMP) ../agents/kei_vip_apb3/kei_vip_apb_if.sv 
	$(VCOMP) ../agents/kei_vip_apb3/kei_vip_apb_pkg.sv 
	#@touch $@;

.shadow/compile_kei_vip_i2c:
	$(VCOMP)  ../agents/kei_vip_i2c/kei_vip_i2c_if.sv 
	$(VCOMP)  ../agents/kei_vip_i2c/kei_vip_i2c_pkg.sv 
	#@touch $@;

elab: comp
	$(ELAB) $(TOP)

run: 
	$(RUN) +UVM_TESTNAME=$(TEST) -l $(OUT)/sim/$(CM_NAME).log -cm_dir $(OUT)/cov -cm_name $(CM_NAME)

regr: $(TESTLIST)
	for t in $(TESTLIST); do \
		$(RUN) +UVM_TESTNAME=$(TESTLIST) -l $(OUT)/sim/$(TESTLIST).log +vpdfile+$(OUT)/sim/$(TESTLIST)_$(SEED)_$(VPDFILE); \
	done

editcov:
	urg -format both $(COVOPTS)
	dve $(COVOPTS)

viewcov:
	urg -format both $(COVOPTS)
	firefox urgReport/dashboard.html

gendoc:
	mono /opt/NaturalDocs/NaturalDocs.exe ../docs/nd_config
  
viewdoc:
	firefox ../docs/nd_docs/index.html &

clean:
	-rm -rf csrc DVEfiles ucli.key uvm_dpi.so vc_hdrs.h  *simv* *.vpd *.log *.sml *.fsdb work.* *.vdb
	-rm -rf AN.DB urgReport novas.conf verdiLog vdCovLog novas.rc $(OUT) .shadow
	-rm -rf ../docs/nd_docs/*

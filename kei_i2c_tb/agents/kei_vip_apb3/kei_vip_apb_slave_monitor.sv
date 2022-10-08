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
`ifndef KEI_VIP_APB_SLAVE_MONITOR_SV
`define KEI_VIP_APB_SLAVE_MONITOR_SV

function kei_vip_apb_slave_monitor::new(string name, uvm_component parent=null);
  super.new(name, parent);
  trans_collected = new();
  item_collected_port = new("item_collected_port",this);
endfunction:new

// build
function void kei_vip_apb_slave_monitor::build();
   super.build();
endfunction : build  


task kei_vip_apb_slave_monitor::monitor_transactions();

   forever begin
 
      // Extract data from interface into transaction
      collect_transfer();

      // Check transaction
      if (checks_enable)
 	 perform_transfer_checks();

      // Update coverage
      if (coverage_enable)
 	 perform_transfer_coverage();

      // Publish to subscribers
      item_collected_port.write(trans_collected);

   end
endtask // monitor_transactions
   

task kei_vip_apb_slave_monitor::run();
  fork
    monitor_transactions();
  join_none
endtask // run
  
task kei_vip_apb_slave_monitor::collect_transfer();

  void'(this.begin_tr(trans_collected));
  // USER: Extract data and fill ata in kei_vip_apb_transfer trans_collected

  // Advance clock
  @(vif.cb_mon);

  // Wait for some start event..., indicate start of transaction
  void'(this.begin_tr(trans_collected));


  // Wait for some start event..., indicate end of transaction


  this.end_tr(trans_collected);
endtask // collect_transfer


// perform_transfer_checks
function void kei_vip_apb_slave_monitor::perform_transfer_checks();

 // USER: do some checks on the transfer here

endfunction : perform_transfer_checks

// perform_transfer_coverage
function void kei_vip_apb_slave_monitor::perform_transfer_coverage();

 // USER: coverage implementation

 -> kei_vip_apb_slave_cov_transaction;

endfunction : perform_transfer_coverage

`endif // KEI_VIP_APB_SLAVE_MONITOR_SV


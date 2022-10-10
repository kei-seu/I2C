
`ifndef KEI_I2C_DEFINES_SVH
`define KEI_I2C_DEFINES_SVH

// Interrupt outputs
parameter IC_INTR_NUM                = 12; 
parameter IC_RX_OVER_INTR_ID         = 0 ;  
parameter IC_RX_UNDER_INTR_ID        = 1 ;    
parameter IC_TX_OVER_INTR_ID         = 2 ;  
parameter IC_TX_ABRT_INTR_ID         = 3 ;  
parameter IC_RX_DONE_INTR_ID         = 4 ;  
parameter IC_TX_EMPTY_INTR_ID        = 5 ;  
parameter IC_ACTIVITY_INTR_ID        = 6 ;  
parameter IC_STOP_DET_INTR_ID        = 7 ;  
parameter IC_START_DET_INTR_ID       = 8 ;  
parameter IC_RD_REQ_INTR_ID          = 9 ;  
parameter IC_RX_FULL_INTR_ID         = 10;  
parameter IC_GEN_CALL_INTR_ID        = 11;  

// Interrupt internals (INTR_ID > IC_INTR_NUM)
parameter IC_RESTART_DET_INTR_ID     = 20;  
parameter IC_MASTER_ON_HOLD_INTR_ID  = 21;  

// All interrupts which could be clear by register IC_CLR_INTR
parameter IC_ALL_INTR_ID             = 100;  



parameter RGM_WRITE = 0;
parameter RGM_READ = 1;


`endif // KEI_I2C_DEFINES_SVH

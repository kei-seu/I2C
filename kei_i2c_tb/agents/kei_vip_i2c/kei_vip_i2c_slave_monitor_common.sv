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
`ifndef KEI_VIP_I2C_SLAVE_MONITOR_COMMON_SV
`define KEI_VIP_I2C_SLAVE_MONITOR_COMMON_SV

class kei_vip_i2c_slave_monitor_common extends kei_vip_i2c_bfm_common;

  `uvm_object_utils_begin(kei_vip_i2c_slave_monitor_common)
  `uvm_object_utils_end
  logic   start_flag = 0;
  logic   end_flag = 0;
  logic   rs_flag = 0;
  int unsigned ack_cnt=0;  //count ack
  int unsigned nak_cnt=0;  //count nak
  int     m=0;
  bit[9:0] tmp_data;
  bit[7:0] mon_data[$];
  int      j=0;

  function new(string name = "kei_vip_i2_slave_monitor_common");
    super.new(name);
  endfunction

  extern task monitor_start();    //monitor start generation
  extern task monitor_end(kei_vip_i2c_slave_transaction trans);      //monitor end generation
  extern task ack_counter(bit anck);  //count ack/nak number,
  extern task collect_transfer(kei_vip_i2c_slave_transaction trans);
  extern task data_ana(kei_vip_i2c_slave_transaction trans);  //analysis collected data from sda line.

endclass

task kei_vip_i2c_slave_monitor_common::data_ana(kei_vip_i2c_slave_transaction trans);  //check all protocol and collect write/read data to transaction
      
    bit      ack_nak;
    bit    flag_1=0;
        wait(start_flag); //only one time
        flag_1=1;
    forever begin
        wait(flag_1 | rs_flag);
          rs_flag=0;
        for(int i=7;i>=0;i--) begin
          @(posedge i2c_if.SCL);
          mon_data[j][i] = i2c_if.SDA;
        end
        //collect and check first byte ack/nak??
        @(posedge i2c_if.SCL);
        ack_nak = i2c_if.SDA;
        ack_counter(ack_nak);

        casex(mon_data[j])    //check first byte
          8'b0000_001x,8'b0000_010x,8'b0000_011x: 
              begin
                `uvm_error("slave monitor common","slave monitor receive reserved address")
              end
          8'b0000_0000:  //general call address
              begin                
                  trans.cmd = I2C_GEN_CALL;
                  //collect second byte
                  j++;
                  for(int i=7;i>=0;i--) begin
                    @(posedge i2c_if.SCL);
                    mon_data[j][i] = i2c_if.SDA;
                  end
                  @(posedge i2c_if.SCL);
                   ack_nak = i2c_if.SDA;
                   ack_counter(ack_nak);
              
                   m=9; j=0;
                   mon_data = {};
 //                  if(trans.send_start_byte==1'b0) begin
                   while((!end_flag) & (!rs_flag)) begin
                       @(posedge i2c_if.SCL);
                       tmp_data[m] = i2c_if.SDA;
                       @(negedge i2c_if.SCL);
                       m--;
                       if(m==0) begin
                            mon_data[j] = tmp_data[9:2];
                            ack_nak = tmp_data[1];
                            ack_counter(ack_nak);
                            m=9;
                            j++;      
                        end                                
                    end
                    if(rs_flag & j!=0) begin
                        trans.data=mon_data;  //if rs_flag==1 in this step, should sent data to trans
                         mon_data = {};
                         j=0;
                        end
//                    end
               /*   casex(mon_data[j])
                     8'h06:   //reset and write programmable part of slave address by hardware
                        begin
                           trans.sec_byte_gen_call = 8'h06;
                            m=9; j=0;
                              while((!end_flag) & (!rs_flag)) begin
                                   @(posedge i2c_if.SCL);
                                   tmp_data[m] = i2c_if.SDA;
                                   @(negedge i2c_if.SCL);
                                   m--;
                                   if(m==0) begin
                                       mon_data[j] = tmp_data[9:2];
                                       ack_nak = tmp_data[1];
                                       ack_counter(ack_nak);
                                       m=9;
                                       j++;      
                                   end                                
                              end
                              if(rs_flag & j!=0) begin
                                  trans.data=mon_data;  //if rs_flag==1 in this step, should sent data to trans
                                   mon_data = {};
                                   j=0;
                              end

                        end
                     8'h04:   //write programmable part of slave address by hardware
                           trans.sec_byte_gen_call = 8'h04;
                     8'h00:   //not allowed
                         `uvm_error("I2C MASTER MONITOR","general call second byte is zero, not allowd!!")
                     8'bxxxxxxx1:  //the 2-byte sequence is a hardware general call,master driver will continue send data.
                         begin
                              m=9; j=0;
                              while((!end_flag) & (!rs_flag)) begin
                                   @(posedge i2c_if.SCL);
                                   tmp_data[m] = i2c_if.SDA;
                                   @(negedge i2c_if.SCL);
                                   m--;
                                   if(m==0) begin
                                       mon_data[j] = tmp_data[9:2];
                                       ack_nak = tmp_data[1];
                                       ack_counter(ack_nak);
                                       m=9;
                                       j++;      
                                   end                                
                              end
                              if(rs_flag & j!=0) begin
                                  trans.data=mon_data;  //if rs_flag==1 in this step, should sent data to trans
                                   mon_data = {};
                                   j=0;
                              end
                         end
                  endcase*/
              end
          8'b0000_0001:   //start byte
              begin
//                  trans.send_start_byte=1'b1;
                  j=0;
                  flag_1=0;
                  mon_data = {};
                  continue;
              end
          8'b0000_1xxx:  //hs-mode master code
              begin
                 j=0; mon_data = {};
                 flag_1=0;
                 continue; /*
                 m=9; j++;  
                  while((!end_flag) & (!rs_flag)) begin
                        @(posedge i2c_if.SCL);
                           tmp_data[m] = i2c_if.SDA;
                           @(negedge i2c_if.SCL);
                           m--;
                           if(m==0) begin
                               mon_data[j] = tmp_data[9:2];
                               ack_nak = tmp_data[1];
                               ack_counter(ack_nak);
                               m=9;
                               j++;        
                           end               
                  end*/
              end
          8'b1111_1xxx:   //device ID, need check nak and loop.
              begin
                  trans.cmd = I2C_DEVICE_ID;
                  if(mon_data[j][0]==0)  begin  //devide ID first byte, write slave address followed
                      //while((!end_flag) & (!rs_flag)) begin
                      //   j++;
                      //for(int i=7;i>=0;i--) begin  //this byte is slave address, and wr is read
                      //    @(posedge i2c_if.SCL);
                      //     mon_data[j][i] = i2c_if.SDA; 
                      //end
                      //@(posedge i2c_if.SCL);
                      //ack_nak = i2c_if.SDA;
                      //
                      //end
                      j=0;mon_data = {};
                      continue;/*
                      m=9;
                      j++;
                      while((!end_flag) & (!rs_flag)) begin
                           @(posedge i2c_if.SCL);
                           tmp_data[m] = i2c_if.SDA;
                           @(negedge i2c_if.SCL);
                           m--;
                           if(m==0) begin
                               mon_data[j] = tmp_data[9:2];
                               ack_nak = tmp_data[1];
                               ack_counter(ack_nak);
                               m=9;
                               j++;                         
                           end
                      end*/
                  end
                  else if(mon_data[j][0]==1)  begin  //device ID byte followed re-start, read 3 bytes ID
                       m=9;
                      j=0;mon_data = {};
                      while((!end_flag) & (!rs_flag)) begin
                           @(posedge i2c_if.SCL);
                           tmp_data[m] = i2c_if.SDA;
                           @(negedge i2c_if.SCL);
                           m--;
                           if(m==0) begin
                               mon_data[j] = tmp_data[9:2];
                               ack_nak = tmp_data[1];
                               ack_counter(ack_nak);                             
                               m=9;
                               j++;                         
                           end
                      end
                  end 
              end
          8'b1111_0xxx:   //10-bit slave addressing
              begin
                  if(mon_data[j][0]==0)  begin  //10bit address first byte,write
                      if(trans.cmd == I2C_DEVICE_ID) begin
                          trans.addr_10bit = 1;
                          trans.addr[9:8] = mon_data[j][2:1];
                          j++;
                          for(int i=7;i>=0;i--) begin     //monitor 10bit address low 8 bits
                              @(posedge i2c_if.SCL);
                              mon_data[j][i] = i2c_if.SDA;
                          end
                          trans.addr[7:0] = mon_data[j][7:0];
                          //collect and check first byte ack/nak??
                          @(posedge i2c_if.SCL);
                          ack_nak = i2c_if.SDA;
                          j=0;
                          flag_1=0;mon_data = {};
                          continue;
                      end

                     // if(trans.cmd != I2C_DEVICE_ID)
                       trans.addr_10bit = 1;
                          trans.cmd = I2C_WRITE;
                      trans.addr[9:8] = mon_data[j][2:1];
                      j++;
                      for(int i=7;i>=0;i--) begin     //monitor 10bit address low 8 bits
                          @(posedge i2c_if.SCL);
                          mon_data[j][i] = i2c_if.SDA;
                      end
                      trans.addr[7:0] = mon_data[j][7:0];
                      //collect and check first byte ack/nak??
                      @(posedge i2c_if.SCL);
                      ack_nak = i2c_if.SDA;
                      ack_counter(ack_nak);
                      
                      m=9;j=0;
                      mon_data = {};
                      while((!end_flag) & (!rs_flag)) begin
                        @(posedge i2c_if.SCL);
                        tmp_data[m] = i2c_if.SDA;
                        @(negedge i2c_if.SCL);
                        m--;
                        if(m==0) begin
                          mon_data[j] = tmp_data[9:2];
                          ack_nak = tmp_data[1];
                          ack_counter(ack_nak);
                          m=9;
                          j++;                         
                        end
                      end
                      if(rs_flag & j!=0) begin
                          trans.data=mon_data;  //10bit address write data with sr end, can sent trans to port
                          mon_data = {};
                          j=0;
                      end
                  end
                  else if(mon_data[j][0]==1)  begin  //10bit second address first byte. read
                      if(trans.cmd == I2C_DEVICE_ID) begin
                          j=0;mon_data = {};
                          continue;
                      end
                     // if(trans.cmd != I2C_DEVICE_ID)
                          trans.cmd = I2C_READ;
                      m=9;j=0;mon_data = {};
                      while((!end_flag) & (!rs_flag)) begin
                        @(posedge i2c_if.SCL);
                        tmp_data[m] = i2c_if.SDA;
                        @(negedge i2c_if.SCL);
                        m--;
                        if(m==0) begin
                          mon_data[j] = tmp_data[9:2];
                          ack_nak = tmp_data[1];
                          ack_counter(ack_nak);
                          m=9;
                          j++;          
                        end
                      end
                      if(rs_flag & j!=0) begin
                          trans.data=mon_data;  //10bit address write data with sr end, can sent trans to port
                          mon_data = {};
                          j=0;
                      end
                  end
              end
          default:  //normal read and write, should seperate read and write, the last ack will be a nak generated by master when read.
              begin
                if(mon_data[j][0]==0)  begin    //write
                  if(trans.cmd == I2C_DEVICE_ID) begin
                      trans.addr[6:0] = mon_data[j][7:1];
                        flag_1=0;
                      continue;
                  end

                   // if(trans.cmd != I2C_DEVICE_ID)
                          trans.cmd = I2C_WRITE;
                    trans.addr[6:0] = mon_data[j][7:1];
                    m=9; j=0;mon_data = {};
                    while((!end_flag) & (!rs_flag)) begin
                    // j++;
                    //  for(int i=7;i>=0;i--) begin
                    //      @(posedge i2c_if.SCL);
                    //       mon_data[j][i] = i2c_if.SDA;
                    //  end
                    //  @(posedge i2c_if.SCL);
                    //  ack_nak = i2c_if.SDA;
                      @(posedge i2c_if.SCL);
                      tmp_data[m] = i2c_if.SDA;
                      @(negedge i2c_if.SCL);
                      m--;
                      if(m==0) begin
                          mon_data[j] = tmp_data[9:2];
                          ack_nak = tmp_data[1];
                          ack_counter(ack_nak);
                          m=9;
                          j++;       
                          //trans.data=mon_data;
                          //$display("mst_mon trans data is %p",trans.data);
                      end
                    end
                    if(rs_flag & j!=0) begin
                          trans.data=mon_data;  //10bit address write data with sr end, can sent trans to port
                          mon_data = {};
                          j=0;
                    end
                 end
                 else  if(mon_data[j][0]==1)  begin    //read
                   if(trans.cmd == I2C_DEVICE_ID) begin
                      trans.addr[6:0] = mon_data[j][7:1];
                      flag_1=0;
                      continue;
                  end
                    //if(trans.cmd != I2C_DEVICE_ID)
                          trans.cmd = I2C_READ;
                    trans.addr[6:0] = mon_data[j][7:1];
                     m=9; j=0;mon_data = {};
                    while((!end_flag) & (!rs_flag)) begin
                    // j++;
                    //  for(int i=7;i>=0;i--) begin
                    //      @(posedge i2c_if.SCL);
                    //       mon_data[j][i] = i2c_if.SDA;
                    //  end
                    //  @(posedge i2c_if.SCL);
                    //  ack_nak = i2c_if.SDA;
                      @(posedge i2c_if.SCL);
                      tmp_data[m] = i2c_if.SDA;
                      @(negedge i2c_if.SCL);
                      m--;
                      if(m==0) begin
                          mon_data[j] = tmp_data[9:2];
                          ack_nak = tmp_data[1];
                          ack_counter(ack_nak);
                          m=9;
                          j++;        
                      end                      
                    end
                    if(rs_flag & j!=0) begin
                          trans.data=mon_data;  //10bit address write data with sr end, can sent trans to port
                          mon_data = {};
                          j=0;
                    end
               end
              end
        endcase
    end
endtask : data_ana

task kei_vip_i2c_slave_monitor_common::ack_counter(bit anck);
    if(anck==0)  //ack
       ack_cnt++;
    else         //nak
       nak_cnt++;
endtask : ack_counter

task kei_vip_i2c_slave_monitor_common::collect_transfer(kei_vip_i2c_slave_transaction trans);
fork
     monitor_start();
     monitor_end(trans);
     data_ana(trans);
   join_none
endtask : collect_transfer

task kei_vip_i2c_slave_monitor_common::monitor_start();

  forever begin
    @(negedge i2c_if.SDA);
     begin
       if(i2c_if.SCL==1 & start_flag==0) begin
           start_flag = 1;
           end_flag = 0;
         end else if(i2c_if.SCL==1 & start_flag==1) begin
          rs_flag = 1;
         end
     end
    /*@(posedge i2c_if.CLK);
     begin
       if(i2c_if.SCL==1 & SDA_NEG==1 & start_flag==0) begin
           start_flag = 1;
           end_flag = 0;
         end else if(i2c_if.SCL==1 & SDA_NEG==1 & start_flag==1) begin
          rs_flag = 1;
          start_flag = 0;
         end
     end*/
  end
endtask : monitor_start

task kei_vip_i2c_slave_monitor_common::monitor_end(kei_vip_i2c_slave_transaction trans);

  forever begin
    @(posedge i2c_if.SDA);
    begin
        if(i2c_if.SCL==1 & start_flag==1) begin
          trans.data= mon_data;
            mon_data= {};
            j=0;
            end_flag = 1;
//            start_flag = 0;
//            rs_flag = 0;
        end
    end

   /*
    @(posedge i2c_if.CLK);  
     begin    //check these tow conditions priority????
       if(i2c_if.SCL==1 & SDA_POS==1 & (start_flag==1 | rs_flag==1)) begin
         end_flag = 1;
         start_flag = 0;
         rs_flag = 0;
       end
//       else if(i2c_if.SCL==1 & SDA_POS==1 & (start_flag==0 & rs_flag==0))
//         `uvm_error("slave monitor","start/rs and stop not match!!!")
     end
     */
  end
endtask : monitor_end

`endif // KEI_VIP_I2C_SLAVE_MONITOR_COMMON_SV

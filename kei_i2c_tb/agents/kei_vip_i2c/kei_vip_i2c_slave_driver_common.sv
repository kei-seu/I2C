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
`ifndef KEI_VIP_I2C_SLAVE_DRIVER_COMMON_SV
`define KEI_VIP_I2C_SLAVE_DRIVER_COMMON_SV

class kei_vip_i2c_slave_driver_common extends kei_vip_i2c_bfm_common;

  `uvm_object_utils_begin(kei_vip_i2c_slave_driver_common)
  `uvm_object_utils_end
  logic   start_flag = 0;
  logic   end_flag = 0;
  logic   rs_flag = 0;
  int     m=0;
  int nack_addr_count;
  bit[9:0] tmp_data;
  bit[7:0] mon_data[$];
  int      j=0;
  semaphore      lock;             //if current send the restart cmd, next transaction need not to send start cmd

  extern function new(string name = "kei_vip_i2c_slave_driver_common");

  extern task slave_start();    //SLAVE start generation
  extern task slave_end(kei_vip_i2c_slave_transaction trans);      //SLAVE end generation
  extern task data_ana(kei_vip_i2c_slave_transaction trans);  //analysis collected data from sda line.

  extern virtual task send_xact(kei_vip_i2c_slave_transaction trans);
  extern virtual task collect_response_from_vif(kei_vip_i2c_slave_transaction trans);
endclass

function kei_vip_i2c_slave_driver_common::new(string name = "kei_vip_i2c_slave_driver_common");
  super.new(name);
  lock = new(1);
endfunction

task kei_vip_i2c_slave_driver_common::send_xact(kei_vip_i2c_slave_transaction trans);
  clk_low_offset_gen();
  fork: send_xact_proc 
    slave_start();
    slave_end(trans);
    data_ana(trans);
  join_any
  // FIXED 2020-07-20
  // Once one of parallel threads exits, it should disable all of them 
  disable send_xact_proc;
endtask

task kei_vip_i2c_slave_driver_common::data_ana(kei_vip_i2c_slave_transaction trans);  //check all protocol and collect write/read data to transaction
  bit      ack_nak;
  int      n=0;
  int      deviceid=0;
  bit    flag_1=0;
 /*     wait(start_flag); //only one time
        flag_1=1;
        nack_addr_count=trans.nack_addr_count;
 */
  nack_addr_count=trans.nack_addr_count;
  forever
  begin

   /*     wait(flag_1 | rs_flag);
        if(rs_flag) begin
          rs_flag=0;
        end

*/
    wait(start_flag|rs_flag);
    begin

      if(rs_flag)
        rs_flag=0;
    end
    start_flag =0;
    for(int i=7;i>=0;i--) begin
      @(posedge i2c_if.SCL);
      mon_data[j][i] = i2c_if.SDA;
    end

    casex(mon_data[j])    //check first byte
      8'b0000_001x,8'b0000_010x,8'b0000_011x:
      begin
        `uvm_error("slave driver common","slave driver receive reserved address")
        //send nack to master
        @(negedge i2c_if.SCL);
        wait_data_hd_time();
        i2c_if.sda_slave = 1'b1;
        @(negedge i2c_if.SCL);
      //                 i2c_if.sda_slave = 1'bz;
      end
      8'b0000_0000:  //general call address   --done
      begin
        trans.cmd = I2C_GEN_CALL;
        //send ack to master
        @(negedge i2c_if.SCL);
        wait_data_hd_time();
        i2c_if.sda_slave = 1'b0;
        @(negedge i2c_if.SCL);
        //                  i2c_if.sda_slave = 1'bz;
        //collect second byte
        j++;
        for(int i=7;i>=0;i--) begin
          @(posedge i2c_if.SCL);
          mon_data[j][i] = i2c_if.SDA;
        end
        //send ack to master
        @(negedge i2c_if.SCL);
        wait_data_hd_time();
        i2c_if.sda_slave = 1'b0;
        @(negedge i2c_if.SCL);
        //                    i2c_if.sda_slave = 1'bz;
        m=8; j=0;
        while((!end_flag) & (!rs_flag)) begin
          @(posedge i2c_if.SCL);
          tmp_data[m] = i2c_if.SDA;
          @(negedge i2c_if.SCL);
          m--;
          if(m==0) begin
            mon_data[j] = tmp_data[8:1];
            wait_data_hd_time();
            i2c_if.sda_slave = 1'b0;
            m=8;
            j++;
            @(negedge i2c_if.SCL);
          //                              i2c_if.sda_slave = 1'bz;
          end
        end
        if(rs_flag & j!=0) begin
          trans.data=mon_data;  //if rs_flag==1 in this step, should sent data to trans
          mon_data = {};
          j=0;
          $display("slv_driver trans data is %p",trans.data);
        end
                  /*
                  casex(mon_data[j])
                     8'h06:   //reset and write programmable part of slave address by hardware
                           ;
                     8'h04:   //write programmable part of slave address by hardware
                           ;
                     8'h00:   //not allowed
                         `uvm_error("I2C SLAVE SLAVE","general call second byte is zero, not allowd!!")
                     8'bxxxxxxx1:  //the 2-byte sequence is a hardware general call,slave driver will continue send data.
                         begin
                              m=8; j++;
                              while((!end_flag) & (!rs_flag)) begin
                                   @(posedge i2c_if.SCL);
                                   tmp_data[m] = i2c_if.SDA;
                                   @(negedge i2c_if.SCL);
                                   m--;
                                   if(m==0) begin
                                       mon_data[j] = tmp_data[8:1];
                                       i2c_if.sda_slave = 1'b0;
                                       m=8;
                                       j++;
                                       trans.data=mon_data;
                                       $display("slv_mon trans data is %p",trans.data);
                                   end
                              end
                         end
                  endcase*/
      end
      8'b0000_0001:   //start byte-done
      begin
        j=0;
        //  flag_1=0;
        start_flag=0;
        continue;
      end
      8'b0000_1xxx:  //hs-mode slave code-done
      begin
        //send nack to master
        @(negedge i2c_if.SCL);
        wait_data_hd_time();
        i2c_if.sda_slave = 1'b1;
        @(negedge i2c_if.SCL);
        //                  i2c_if.sda_slave = 1'bz;
        j=0; continue;
                  /*//rs_flag will be trigger
                  m=9; j++;
                  while((!end_flag) & (!rs_flag)) begin
                        @(posedge i2c_if.SCL);
                        tmp_data[m] = i2c_if.SDA;
                        @(negedge i2c_if.SCL);
                        m--;
                        if(m==0) begin
                            mon_data[j] = tmp_data[9:2];
                            m=9;
                            j++;
                        end
                   end*/
      end
      8'b1111_1xxx:   //device ID, --done
      begin
        deviceid=1;
        //send ack and continue receive or transmit data
        @(negedge i2c_if.SCL);
        wait_data_hd_time();
        i2c_if.sda_slave = 1'b0;
        @(negedge i2c_if.SCL);
        //                   i2c_if.sda_slave = 1'bz;
        trans.cmd = I2C_DEVICE_ID;
        if(mon_data[j][0]==0)  begin  //devide ID first byte, write slave address followed
          //continue receive slave address, the address is 7 bits or 10 bits
          j=0;
          continue;
        end
        else if(mon_data[j][0]==1)  begin  //device ID byte followed re-start, read 3 bytes ID
          j=8;
          while((!end_flag) & (!rs_flag)) begin
            //for(int i=7; i>=0; i--) begin
            for(int i=23; i>=0; i--) begin
              wait_data_hd_time();
              i2c_if.sda_slave = cfg.device_id[i];
              @(negedge i2c_if.SCL);
              j--;
              if(j==0) begin
                j=8;
                //                                 i2c_if.sda_slave = 1'bz; // release bus to mst,
                @(negedge i2c_if.SCL);
              end
            end
          //@(negedge i2c_if.SCL);
          //receive ack/nack
          //@(posedge i2c_if.SCL);
          //if(i2c_if.SDA == 1'b1)  //nack, break;
          //    continue;

          //for(int i=7; i>=0; i--) begin
          //    @(negedge i2c_if.SCL);
          //    i2c_if.sda_slave = cfg.device_id[8+i];
          //end
          //receive ack/nack
          //@(posedge i2c_if.SCL);
          //if(i2c_if.SDA == 1'b1)  //nack, break;
          //    continue;

          //for(int i=7; i>=0; i--) begin
          //    @(negedge i2c_if.SCL);
          //    i2c_if.sda_slave = cfg.device_id[i];
          //end
          //receive ack/nack
          //@(posedge i2c_if.SCL);
          //if(i2c_if.SDA == 1'b1)  //nack, break;
          //    continue;
          end
        end
      end
      8'b1111_0xxx:   //10-bit slave addressing--done
      begin
        if(mon_data[j][2:1] == cfg.slave_address[9:8])   begin     //10bit address high two bits match
          //send ack and continue receive or transmit data
          @(negedge i2c_if.SCL);
          wait_data_hd_time();
          i2c_if.sda_slave = trans.nack_addr;
          if(mon_data[j][0]==0)  begin  //10bit address first byte,write cmd, coutinue receive the second byte, low 8 bits address
            @(negedge i2c_if.SCL);
            wait_data_hd_time();
            i2c_if.sda_slave = 1'bz;

            //   j++;
            //receive the second byte and check if it's available
            for(int i=7;i>=0;i--) begin
              @(posedge i2c_if.SCL);
              mon_data[j][i] = i2c_if.SDA;
            end

            if(mon_data[j] == cfg.slave_address[7:0])  begin   //slave low 8 bits address match,continue receive data
              @(negedge i2c_if.SCL);
              wait_data_hd_time();
              i2c_if.sda_slave = trans.nack_addr;
              @(negedge i2c_if.SCL);
              wait_data_hd_time();
              i2c_if.sda_slave = 1'bz;
              m=8;
              //j++;
              while((!end_flag) & (!rs_flag)) begin
                @(posedge i2c_if.SCL);
                tmp_data[m] = i2c_if.SDA;
                @(negedge i2c_if.SCL);
                m--;
                if(m==0) begin
                  wait_data_hd_time();
                  i2c_if.sda_slave = 1'b0;
                  mon_data[j] = tmp_data[8:1];
                  m=8;
                  j++;
                  @(negedge i2c_if.SCL);
                  wait_data_hd_time();
                  i2c_if.sda_slave = 1'bz;
                end
              end
              if(rs_flag & j!=0) begin
                trans.data=mon_data;
                mon_data={};
                j=0;
                $display("slv_driver trans data is %p",trans.data);
              end

            end //second byte match end
            else begin
              //send nack and break
              @(negedge i2c_if.SCL);
              wait_data_hd_time();
              i2c_if.sda_slave = 1'b1;
              @(negedge i2c_if.SCL);
              wait_data_hd_time();
              i2c_if.sda_slave = 1'bz;
              break;
            end  //second byte not match end
          end   //10 bits address write end
          else if(mon_data[j][0]==1) begin     //10bit address read
            //trans.data=new[3];
            m=8;n=0;
            while((!end_flag) & (!rs_flag)) begin
              //send data to master
              @(negedge i2c_if.SCL);
              wait_data_hd_time();
              i2c_if.sda_slave=trans.data[n][m-1];
              @(posedge i2c_if.SCL);
              m--;
              if(m==0) begin
                m=8;
                n++;
                @(negedge i2c_if.SCL);
                wait_data_hd_time();
                i2c_if.sda_slave = 1'bz; // release bus to mst,
              end
            end   //while end
          end   //10 bits address read end
        end   //match end
        else begin  //higt two bits not match
          //send nack and break;
          @(negedge i2c_if.SCL);
          wait_data_hd_time();
          i2c_if.sda_slave = 1'b1;
          @(negedge i2c_if.SCL);
          wait_data_hd_time();
          i2c_if.sda_slave = 1'bz;
          continue;
        end
      end
      default:  //7bit slave address read or write, should seperate read and write, --done
      begin
        if(mon_data[j][7:1] == cfg.slave_address[6:0]) begin
          if(nack_addr_count>0) begin
            //send ack to master
            @(negedge i2c_if.SCL);
            //                         wait_data_hd_time();
            i2c_if.sda_slave = trans.nack_addr;

            // release bus for sr from mst
            @(negedge i2c_if.SCL);
            //                        i2c_if.sda_slave = 1'bz;
            //till end of sr, then sample addr again
            // @(negedge i2c_if.SCL);
            // end_flag=0;
            nack_addr_count--;
          end else begin  //nack_addr_count!>0
            //send ack to master
            @(negedge i2c_if.SCL);
            wait_data_hd_time();
            i2c_if.sda_slave = 1'b0;
            if(mon_data[j][0]==0)  begin    //write
              @(negedge i2c_if.SCL);
              wait_data_hd_time();
              i2c_if.sda_slave = 1'bz;
              m=8; j=0;mon_data = {};
              while((!end_flag) & (!rs_flag)) begin
                @(posedge i2c_if.SCL);
                tmp_data[m] = i2c_if.SDA;
                @(negedge i2c_if.SCL);
                m--;
                if(m==0) begin
                  wait_data_hd_time();
                  i2c_if.sda_slave = (trans.nack_data==j+1) ? 1'b1 : 1'b0;    //send ack to master driver
                  mon_data[j] = tmp_data[8:1];
                  m=8;
                  j++;
                  @(negedge i2c_if.SCL);
                  wait_data_hd_time();
                  i2c_if.sda_slave = 1'bz;
                end
              end  //end while
              if(rs_flag & j!=0) begin
                trans.data=mon_data;
                mon_data={};
                j=0;
                $display("slv_driver trans data is %p",trans.data);
              end
            end   //end write
            else  if(mon_data[j][0]==1)  begin    //read
              if(deviceid==1) begin
                //send ack and continue receive or transmit data
                //@(negedge i2c_if.SCL);
                //i2c_if.sda_slave = trans.nack_addr;
                @(negedge i2c_if.SCL);
                wait_data_hd_time();
                i2c_if.sda_slave = 1'bz; // release bus to mst,
                @(negedge i2c_if.SCL);
              end else begin

                m=8;n=0;
                while((!end_flag) & (!rs_flag)) begin
                  //send data to master
                  @(negedge i2c_if.SCL);
                  wait_data_hd_time();
                  i2c_if.sda_slave=trans.data[n][m-1];
                  @(posedge i2c_if.SCL);
                  m--;
                  if(m==0) begin
                    m=8;
                    n++;
                    @(negedge i2c_if.SCL);
                    wait_data_hd_time();
                    i2c_if.sda_slave = 1'bz; // release bus to mst,
                    @(posedge i2c_if.SCL);
                    if(i2c_if.SDA==0)
                      continue;
                    else
                      break;
                  end
                end   //while end
              end   // end
            end   //read end
          end // nack_addr_count end

        end  //address is valid end
        else begin
          //send nack to master
          @(negedge i2c_if.SCL);
          wait_data_hd_time();
          i2c_if.sda_slave = 1'b1;
          @(negedge i2c_if.SCL);
          //                     i2c_if.sda_slave = 1'bz;
          break;
        end
      end    //default end
    endcase
  end
endtask : data_ana

task kei_vip_i2c_slave_driver_common::collect_response_from_vif(kei_vip_i2c_slave_transaction trans);
// TODO detailed bus response collection here!!!
endtask

task kei_vip_i2c_slave_driver_common::slave_start();

  forever begin
    @(negedge i2c_if.SDA);
    begin
      if(i2c_if.SCL==1)
      begin
        if(lock.try_get())  begin
          start_flag = 1;
          @(posedge i2c_if.SCL);

          end_flag = 0;
        //rs_flag=0;
        end
        else begin
          // @(negedge i2c_if.SDA);
          rs_flag = 1;
          end_flag = 0;
        //start_flag = 0;
        end
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
endtask : slave_start

task kei_vip_i2c_slave_driver_common::slave_end(kei_vip_i2c_slave_transaction trans);

  forever begin
    @(posedge i2c_if.SDA);
    begin
      if(i2c_if.SCL==1) begin
        trans.data= mon_data;
        mon_data= {};
        j=0;
        //   @(posedge i2c_if.SDA);
        lock.put();
        end_flag = 1;
        return;

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
//         `uvm_error("slave SLAVE","start/rs and stop not match!!!")
     end
     */
  end
endtask : slave_end

`endif // KEI_VIP_I2C_slave_DRIVER_COMMON_SV

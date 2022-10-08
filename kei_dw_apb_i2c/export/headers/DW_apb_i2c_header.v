//
// ABSTRACT : Register definition header file for 
//
`define DW_apb_i2c_addr_block1_BaseAddress 'h0

/* Register IC_CON */
/* I2C Control Register.
This register can be written only when the DW_apb_i2c
is disabled, which corresponds to the IC_ENABLE[0] register
being set to 0. Writes at other times have no effect.

Read/Write Access: 
  - If configuration parameter I2C_DYNAMIC_TAR_UPDATE=1, bit 4 is read only.
  - If configuration parameter IC_RX_FULL_HLD_BUS_EN =0, bit 9 is read only.
  - If configuration parameter IC_STOP_DET_IF_MASTER_ACTIVE =0, bit 10 is read only.
  - If configuration parameter IC_BUS_CLEAR_FEATURE=0, bit 11 is read only
  - If configuration parameter IC_OPTIONAL_SAR=0, bit 16 is read only
  - If configuration parameter IC_SMBUS=0, bit 17 is read only
  - If configuration parameter IC_SMBUS_ARP=0, bits 18 and 19 are read only.
 */
`define IC_CON (`DW_apb_i2c_addr_block1_BaseAddress + 'h0)
`define IC_CON_RegisterSize 32
`define IC_CON_RegisterResetValue 32'h7f
`define IC_CON_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CON */

/* Register IC_CON field MASTER_MODE */
/* This bit controls whether the DW_apb_i2c master is enabled.


NOTE: Software should ensure that if this bit is written with '1'
then bit 6 should also be written with a '1'. */
`define IC_CON_MASTER_MODE_BitAddressOffset 0
`define IC_CON_MASTER_MODE_RegisterSize 1

/* Register IC_CON field SPEED */
/* These bits control at which speed the DW_apb_i2c operates; its
setting is relevant only if one is operating the DW_apb_i2c in
master mode. Hardware protects against illegal values being
programmed by software. These bits must be programmed
appropriately for slave mode also, as it is used to capture
correct value of spike filter as per the speed mode. 

This register should be programmed only with a value in the range 
of 1 to IC_MAX_SPEED_MODE; otherwise, hardware updates this register with the value of
IC_MAX_SPEED_MODE.

1: standard mode (100 kbit/s)

2: fast mode (<=400 kbit/s) or fast mode plus (<=1000Kbit/s)

3: high speed mode (3.4 Mbit/s)

Note: This field is not applicable  when IC_ULTRA_FAST_MODE=1
 */
`define IC_CON_SPEED_BitAddressOffset 1
`define IC_CON_SPEED_RegisterSize 2

/* Register IC_CON field IC_10BITADDR_SLAVE */
/* When acting as a slave, this bit controls whether the DW_apb_i2c responds to 7- or 10-bit addresses.
 - 0: 7-bit addressing. The DW_apb_i2c ignores transactions that involve 10-bit addressing; for 7-bit addressing, only the lower 7 bits of the IC_SAR register are compared.
 - 1: 10-bit addressing. The DW_apb_i2c responds to only 10-bit addressing transfers that match the full 10 bits of the IC_SAR register.
 */
`define IC_CON_IC_10BITADDR_SLAVE_BitAddressOffset 3
`define IC_CON_IC_10BITADDR_SLAVE_RegisterSize 1

/* Register IC_CON field IC_10BITADDR_MASTER */
/* If the I2C_DYNAMIC_TAR_UPDATE configuration parameter is
set to 'No' (0), this bit is named IC_10BITADDR_MASTER and
controls whether the DW_apb_i2c starts its transfers in 7- or 10-bit
addressing mode when acting as a master.
If I2C_DYNAMIC_TAR_UPDATE is set to 'Yes' (1), the
function of this bit is handled by bit 12 of IC_TAR register, and
becomes a read-only copy called
IC_10BITADDR_MASTER_rd_only.
 - 0: 7-bit addressing
 - 1: 10-bit addressing
 */
`define IC_CON_IC_10BITADDR_MASTER_BitAddressOffset 4
`define IC_CON_IC_10BITADDR_MASTER_RegisterSize 1

/* Register IC_CON field IC_RESTART_EN */
/* Determines whether RESTART conditions may be sent when
acting as a master. Some older slaves do not support handling
RESTART conditions; however, RESTART conditions are used in
several DW_apb_i2c operations. When RESTART is disabled, the master is prohibited from
performing the following functions:
 - Sending a START BYTE
 - Performing any high-speed mode operation
 - High-speed mode operation
 - Performing direction changes in combined format mode
 - Performing a read operation with a 10-bit address
By replacing RESTART condition followed by a STOP and a
subsequent START condition, split operations are broken down
into multiple DW_apb_i2c transfers. If the above operations are
performed, it will result in setting bit 6 (TX_ABRT) of the
IC_RAW_INTR_STAT register.
. */
`define IC_CON_IC_RESTART_EN_BitAddressOffset 5
`define IC_CON_IC_RESTART_EN_RegisterSize 1

/* Register IC_CON field IC_SLAVE_DISABLE */
/* This bit controls whether I2C has its slave disabled,
which means once the presetn signal is applied, then
this bit takes on the value of the configuration parameter
IC_SLAVE_DISABLE. You have the choice of having the slave enabled
or disabled after reset is applied, which means software does not
have to configure the slave. By default, the slave is always enabled
(in reset state as well). If you need to disable it after reset, set
this bit to 1.

If this bit is set (slave is disabled), DW_apb_i2c functions only as
a master and does not perform any action that requires a slave.


NOTE: Software should ensure that if this bit is written with 0,
then bit 0 should also be written with a 0. */
`define IC_CON_IC_SLAVE_DISABLE_BitAddressOffset 6
`define IC_CON_IC_SLAVE_DISABLE_RegisterSize 1

/* Register IC_CON field STOP_DET_IFADDRESSED */
/* In slave mode:
 - 1'b1:  issues the STOP_DET interrrupt only when it is addressed.
 - 0'b0:  issues the STOP_DET irrespective of whether it's addressed or not.


NOTE: During a general call address, this slave does not issue the 
STOP_DET interrupt if STOP_DET_IF_ADDRESSED = 1'b1, even if
the slave responds to the general call address by generating ACK.
The STOP_DET interrupt is generated only when the transmitted
address matches the slave address (SAR). */
`define IC_CON_STOP_DET_IFADDRESSED_BitAddressOffset 7
`define IC_CON_STOP_DET_IFADDRESSED_RegisterSize 1

/* Register IC_CON field TX_EMPTY_CTRL */
/* This bit controls the generation 
of the TX_EMPTY interrupt, as described in the IC_RAW_INTR_STAT register.
 */
`define IC_CON_TX_EMPTY_CTRL_BitAddressOffset 8
`define IC_CON_TX_EMPTY_CTRL_RegisterSize 1

/* Register IC_CON field RX_FIFO_FULL_HLD_CTRL */
/* This bit controls whether 
DW_apb_i2c should hold the bus when the Rx FIFO is physically full to its RX_BUFFER_DEPTH,
as described in the IC_RX_FULL_HLD_BUS_EN parameter. 
 */
`define IC_CON_RX_FIFO_FULL_HLD_CTRL_BitAddressOffset 9
`define IC_CON_RX_FIFO_FULL_HLD_CTRL_RegisterSize 1

/* Register IC_CON field STOP_DET_IF_MASTER_ACTIVE */
/* In Master mode:
 - 1'b1: issues the STOP_DET interrupt only when master is active.
 - 1'b0: issues the STOP_DET irrespective of whether master is active or not.
 */
`define IC_CON_STOP_DET_IF_MASTER_ACTIVE_BitAddressOffset 10
`define IC_CON_STOP_DET_IF_MASTER_ACTIVE_RegisterSize 1

/* Register IC_CON field RSVD_BUS_CLEAR_FEATURE_CTRL */
/* BUS_CLEAR_FEATURE_CTRL Reserved bits - Read Only */
`define IC_CON_RSVD_BUS_CLEAR_FEATURE_CTRL_BitAddressOffset 11
`define IC_CON_RSVD_BUS_CLEAR_FEATURE_CTRL_RegisterSize 1

/* Register IC_CON field RSVD_IC_CON_1 */
/* IC_CON_1 Reserved bits - Read Only */
`define IC_CON_RSVD_IC_CON_1_BitAddressOffset 12
`define IC_CON_RSVD_IC_CON_1_RegisterSize 4

/* Register IC_CON field RSVD_OPTIONAL_SAR_CTRL */
/* OPTIONAL_SAR_CTRL Reserved bits - Read Only */
`define IC_CON_RSVD_OPTIONAL_SAR_CTRL_BitAddressOffset 16
`define IC_CON_RSVD_OPTIONAL_SAR_CTRL_RegisterSize 1

/* Register IC_CON field RSVD_SMBUS_SLAVE_QUICK_EN */
/* SMBUS_SLAVE_QUICK_EN Reserved bits - Read Only */
`define IC_CON_RSVD_SMBUS_SLAVE_QUICK_EN_BitAddressOffset 17
`define IC_CON_RSVD_SMBUS_SLAVE_QUICK_EN_RegisterSize 1

/* Register IC_CON field RSVD_SMBUS_ARP_EN */
/* SMBUS_ARP_EN Reserved bits - Read Only */
`define IC_CON_RSVD_SMBUS_ARP_EN_BitAddressOffset 18
`define IC_CON_RSVD_SMBUS_ARP_EN_RegisterSize 1

/* Register IC_CON field RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN */
/* SMBUS_PERSISTENT_SLV_ADDR_EN Reserved bits - Read Only */
`define IC_CON_RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN_BitAddressOffset 19
`define IC_CON_RSVD_SMBUS_PERSISTENT_SLV_ADDR_EN_RegisterSize 1

/* Register IC_CON field RSVD_IC_CON_2 */
/* IC_CON_2 Reserved bits - Read Only */
`define IC_CON_RSVD_IC_CON_2_BitAddressOffset 20
`define IC_CON_RSVD_IC_CON_2_RegisterSize 12

/* End of Register Definition for IC_CON */

/* Register IC_TAR */
/* I2C Target Address Register

If the configuration parameter I2C_DYNAMIC_TAR_UPDATE is set to 'No' (0),
this register is 12 bits wide, and bits 31:12 are reserved. This register
can be written to only when IC_ENABLE[0] is set to 0.

However, if I2C_DYNAMIC_TAR_UPDATE = 1, then the register becomes 13 bits wide.
In this case, writes to IC_TAR succeed when one of the following conditions are true:
 - DW_apb_i2c is NOT enabled (IC_ENABLE[0] is set to 0); or
 - DW_apb_i2c is enabled (IC_ENABLE[0]=1); AND DW_apb_i2c is NOT engaged in any Master (tx, rx) operation (IC_STATUS[5]=0); AND DW_apb_i2c is enabled to operate in Master mode (IC_CON[0]=1); AND there are NO entries in the TX FIFO (IC_STATUS[2]=1)
You can change the TAR address dynamically without losing the bus, only if the following conditions are met.
 - DW_apb_i2c is enabled (IC_ENABLE[0]=1); AND IC_EMPTYFIFO_HOLD_MASTER_EN configuration parameter is set to 1; AND DW_apb_i2c is enabled to operate in Master mode (IC_CON[0]=1); AND there are NO entries in the Tx FIFO and the master is in HOLD state (IC_INTR_STAT[13]=1).
 Note: If the software or application is aware that the DW_apb_i2c is not using the TAR address for the pending commands in the
    Tx FIFO, then it is possible to update the TAR address even while the Tx FIFO has entries (IC_STATUS[2]= 0).
  - It is not necessary to perform any write to this register if DW_apb_i2c is enabled as an I2C slave only.
 */
`define IC_TAR (`DW_apb_i2c_addr_block1_BaseAddress + 'h4)
`define IC_TAR_RegisterSize 32
`define IC_TAR_RegisterResetValue 32'h33
`define IC_TAR_RegisterResetMask 32'hffffffff

/* Register Field information for IC_TAR */

/* Register IC_TAR field IC_TAR */
/* This is the target address for any master transaction. When
transmitting a General Call, these bits are ignored. To generate a
START BYTE, the CPU needs to write only once into these bits.

If the IC_TAR and IC_SAR are the same, loopback exists but the
FIFOs are shared between master and slave, so full loopback is
not feasible. Only one direction loopback mode is supported
(simplex), not duplex. A master cannot transmit to itself; it can
transmit to only a slave.

 */
`define IC_TAR_IC_TAR_BitAddressOffset 0
`define IC_TAR_IC_TAR_RegisterSize 10

/* Register IC_TAR field GC_OR_START */
/* If bit 11 (SPECIAL) is set to 1 and bit 13(Device-ID) is set to 0, then this bit indicates whether a
General Call or START byte command is to be performed by the
DW_apb_i2c.
 - 0: General Call Address - after issuing a General Call, only writes may be performed. Attempting to issue a read command results in setting bit 6 (TX_ABRT) of the IC_RAW_INTR_STAT register. The DW_apb_i2c remains in General Call mode until the SPECIAL bit value (bit 11) is cleared.
 - 1: START BYTE
 */
`define IC_TAR_GC_OR_START_BitAddressOffset 10
`define IC_TAR_GC_OR_START_RegisterSize 1

/* Register IC_TAR field SPECIAL */
/* This bit indicates whether software performs a Device-ID or General Call or
START BYTE command.
 - 0: ignore bit 10 GC_OR_START and use IC_TAR normally
 - 1: perform special I2C command as specified in Device_ID or GC_OR_START bit
 */
`define IC_TAR_SPECIAL_BitAddressOffset 11
`define IC_TAR_SPECIAL_RegisterSize 1

/* Register IC_TAR field RSVD_IC_10BITADDR_MASTER */
/* IC_10BITADDR_MASTER Reserved bits - Read Only */
`define IC_TAR_RSVD_IC_10BITADDR_MASTER_BitAddressOffset 12
`define IC_TAR_RSVD_IC_10BITADDR_MASTER_RegisterSize 1

/* Register IC_TAR field RSVD_DEVICE_ID */
/* DEVICE_ID Reserved bits - Read Only */
`define IC_TAR_RSVD_DEVICE_ID_BitAddressOffset 13
`define IC_TAR_RSVD_DEVICE_ID_RegisterSize 1

/* Register IC_TAR field RSVD_IC_TAR_1 */
/* IC_TAR_1 Reserved bits - Read Only */
`define IC_TAR_RSVD_IC_TAR_1_BitAddressOffset 14
`define IC_TAR_RSVD_IC_TAR_1_RegisterSize 2

/* Register IC_TAR field RSVD_SMBUS_QUICK_CMD */
/* SMBUS_QUICK_CMD Reserved bits - Read Only */
`define IC_TAR_RSVD_SMBUS_QUICK_CMD_BitAddressOffset 16
`define IC_TAR_RSVD_SMBUS_QUICK_CMD_RegisterSize 1

/* Register IC_TAR field RSVD_IC_TAR_2 */
/* IC_TAR_2 Reserved bits - Read Only */
`define IC_TAR_RSVD_IC_TAR_2_BitAddressOffset 17
`define IC_TAR_RSVD_IC_TAR_2_RegisterSize 15

/* End of Register Definition for IC_TAR */

/* Register IC_SAR */
/* I2C Slave Address Register */
`define IC_SAR (`DW_apb_i2c_addr_block1_BaseAddress + 'h8)
`define IC_SAR_RegisterSize 32
`define IC_SAR_RegisterResetValue 32'h33
`define IC_SAR_RegisterResetMask 32'hffffffff

/* Register Field information for IC_SAR */

/* Register IC_SAR field IC_SAR */
/* The IC_SAR holds the slave address when the I2C is operating as a slave. For 7-bit
addressing, only IC_SAR[6:0] is used.

This register can be written only when the I2C interface is disabled, which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other times have
no effect.

Note: 
The default values cannot be any of the reserved address locations:
that is, 0x00 to 0x07, or 0x78 to 0x7f. The correct operation of the
device is not guaranteed if you program the IC_SAR or IC_TAR to
a reserved value. Refer to Table "I2C/SMBus Definition of Bits in First Byte" for a complete list of these reserved values.

 */
`define IC_SAR_IC_SAR_BitAddressOffset 0
`define IC_SAR_IC_SAR_RegisterSize 10

/* Register IC_SAR field RSVD_IC_SAR */
/* IC_SAR Reserved bits - Read Only */
`define IC_SAR_RSVD_IC_SAR_BitAddressOffset 10
`define IC_SAR_RSVD_IC_SAR_RegisterSize 22

/* End of Register Definition for IC_SAR */

/* Register IC_HS_MADDR */
/* I2C High Speed Master Mode Code Address Register */
`define IC_HS_MADDR (`DW_apb_i2c_addr_block1_BaseAddress + 'hc)
`define IC_HS_MADDR_RegisterSize 32
`define IC_HS_MADDR_RegisterResetValue 32'h1
`define IC_HS_MADDR_RegisterResetMask 32'hffffffff

/* Register Field information for IC_HS_MADDR */

/* Register IC_HS_MADDR field IC_HS_MAR */
/* This bit field holds the value of the I2C HS mode master code. HS-mode
master codes are reserved 8-bit codes (00001xxx) that are not used for slave
addressing or other purposes. Each master has its unique master code; up to
eight high-speed mode masters can be present on the same I2C bus system.
Valid values are from 0 to 7. This register goes away and becomes read-only
returning 0's if the IC_MAX_SPEED_MODE configuration parameter is set
to either Standard (1) or Fast (2).

This register can be written only when the I2C interface is disabled, which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other times
have no effect.

 */
`define IC_HS_MADDR_IC_HS_MAR_BitAddressOffset 0
`define IC_HS_MADDR_IC_HS_MAR_RegisterSize 3

/* Register IC_HS_MADDR field RSVD_IC_HS_MAR */
/* IC_HS_MAR Reserved bits - Read Only */
`define IC_HS_MADDR_RSVD_IC_HS_MAR_BitAddressOffset 3
`define IC_HS_MADDR_RSVD_IC_HS_MAR_RegisterSize 29

/* End of Register Definition for IC_HS_MADDR */

/* Register IC_DATA_CMD */
/* I2C Rx/Tx Data Buffer and Command Register; this is the register the CPU writes to when filling the TX FIFO and the CPU reads from when retrieving bytes from RX FIFO.

The size of the register changes as follows:

Write:
 - 11 bits when IC_EMPTYFIFO_HOLD_MASTER_EN=1
 - 9 bits when IC_EMPTYFIFO_HOLD_MASTER_EN=0
Read:
 - 12 bits when IC_FIRST_DATA_BYTE_STATUS = 1
 - 8 bits when IC_FIRST_DATA_BYTE_STATUS = 0
Note: In order for the DW_apb_i2c to continue acknowledging reads, a read command should be
written for every byte that is to be received; otherwise the DW_apb_i2c will stop
acknowledging. */
`define IC_DATA_CMD (`DW_apb_i2c_addr_block1_BaseAddress + 'h10)
`define IC_DATA_CMD_RegisterSize 32
`define IC_DATA_CMD_RegisterResetValue 32'h0
`define IC_DATA_CMD_RegisterResetMask 32'hffffffff

/* Register Field information for IC_DATA_CMD */

/* Register IC_DATA_CMD field DAT */
/* This register contains the data to be transmitted or received on the I2C bus.
If you are writing to this register and want to perform a read,
bits 7:0 (DAT) are ignored by the DW_apb_i2c. However, when you read
this register, these bits return the value of data received on the
DW_apb_i2c interface.

 */
`define IC_DATA_CMD_DAT_BitAddressOffset 0
`define IC_DATA_CMD_DAT_RegisterSize 8

/* Register IC_DATA_CMD field CMD */
/* This bit controls whether a read or a write is performed.
This bit does not control the direction when the DW_apb_i2c
acts as a slave. It controls only the direction
when it acts as a master.

When a command is entered in the TX FIFO, this bit distinguishes the write
and read commands. In slave-receiver mode, this bit is a "don't care"
because writes to this register are not required. In slave-transmitter mode, a
"0" indicates that the data in IC_DATA_CMD is to be transmitted.

When programming this bit, you should remember the following: attempting
to perform a read operation after a General Call command has been sent
results in a TX_ABRT interrupt (bit 6 of the IC_RAW_INTR_STAT register),
unless bit 11 (SPECIAL) in the IC_TAR register has been cleared.
If a "1" is written to this bit after receiving a RD_REQ interrupt, then a
TX_ABRT interrupt occurs.

 */
`define IC_DATA_CMD_CMD_BitAddressOffset 8
`define IC_DATA_CMD_CMD_RegisterSize 1

/* Register IC_DATA_CMD field RSVD_STOP */
/* STOP Reserved bits - Read Only */
`define IC_DATA_CMD_RSVD_STOP_BitAddressOffset 9
`define IC_DATA_CMD_RSVD_STOP_RegisterSize 1

/* Register IC_DATA_CMD field RSVD_RESTART */
/* RESTART Reserved bits - Read Only */
`define IC_DATA_CMD_RSVD_RESTART_BitAddressOffset 10
`define IC_DATA_CMD_RSVD_RESTART_RegisterSize 1

/* Register IC_DATA_CMD field RSVD_FIRST_DATA_BYTE */
/* FIRST_DATA_BYTE Reserved bits - Read Only */
`define IC_DATA_CMD_RSVD_FIRST_DATA_BYTE_BitAddressOffset 11
`define IC_DATA_CMD_RSVD_FIRST_DATA_BYTE_RegisterSize 1

/* Register IC_DATA_CMD field RSVD_IC_DATA_CMD */
/* IC_DATA_CMD Reserved bits - Read Only */
`define IC_DATA_CMD_RSVD_IC_DATA_CMD_BitAddressOffset 12
`define IC_DATA_CMD_RSVD_IC_DATA_CMD_RegisterSize 20

/* End of Register Definition for IC_DATA_CMD */

/* Register IC_SS_SCL_HCNT */
/* Standard Speed I2C Clock SCL High Count Register */
`define IC_SS_SCL_HCNT (`DW_apb_i2c_addr_block1_BaseAddress + 'h14)
`define IC_SS_SCL_HCNT_RegisterSize 32
`define IC_SS_SCL_HCNT_RegisterResetValue 32'h190
`define IC_SS_SCL_HCNT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_SS_SCL_HCNT */

/* Register IC_SS_SCL_HCNT field IC_SS_SCL_HCNT */
/* This register must be set before any I2C bus transaction can take place to
ensure proper I/O timing. This register sets the SCL clock high-period
count for standard speed. For more information, refer to "IC_CLK Frequency Configuration".
  
This register can be written only when the I2C interface is disabled which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other
times have no effect.

The minimum valid value is 6; hardware prevents values less than this
being written, and if attempted results in 6 being set. For designs with
APB_DATA_WIDTH = 8, the order of programming is important to ensure
the correct operation of the DW_apb_i2c. The lower byte must be
programmed first. Then the upper byte is programmed.

When the configuration parameter IC_HC_COUNT_VALUES is set to 1,
this register is read only.

NOTE: This register must not be programmed to a value higher than
65525, because DW_apb_i2c uses a 16-bit counter to flag an I2C bus idle
condition when this counter reaches a value of IC_SS_SCL_HCNT + 10.

 */
`define IC_SS_SCL_HCNT_IC_SS_SCL_HCNT_BitAddressOffset 0
`define IC_SS_SCL_HCNT_IC_SS_SCL_HCNT_RegisterSize 16

/* Register IC_SS_SCL_HCNT field RSVD_IC_SS_SCL_HIGH_COUNT */
/* IC_SS_SCL_HCNT Reserved bits - Read Only */
`define IC_SS_SCL_HCNT_RSVD_IC_SS_SCL_HIGH_COUNT_BitAddressOffset 16
`define IC_SS_SCL_HCNT_RSVD_IC_SS_SCL_HIGH_COUNT_RegisterSize 16

/* End of Register Definition for IC_SS_SCL_HCNT */

/* Register IC_SS_SCL_LCNT */
/* Standard Speed I2C Clock SCL Low Count Register */
`define IC_SS_SCL_LCNT (`DW_apb_i2c_addr_block1_BaseAddress + 'h18)
`define IC_SS_SCL_LCNT_RegisterSize 32
`define IC_SS_SCL_LCNT_RegisterResetValue 32'h1d6
`define IC_SS_SCL_LCNT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_SS_SCL_LCNT */

/* Register IC_SS_SCL_LCNT field IC_SS_SCL_LCNT */
/* This register must be set before any I2C bus transaction can take place to
ensure proper I/O timing. This register sets the SCL clock low period
count for standard speed. For more information, refer to "IC_CLK Frequency Configuration"

This register can be written only when the I2C interface is disabled which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other
times have no effect.

The minimum valid value is 8; hardware prevents values less than this
being written, and if attempted, results in 8 being set. For designs with
APB_DATA_WIDTH = 8, the order of programming is important to
ensure the correct operation of DW_apb_i2c. The lower byte must be
programmed first, and then the upper byte is programmed.

When the configuration parameter IC_HC_COUNT_VALUES is set to 1,
this register is read only.

 */
`define IC_SS_SCL_LCNT_IC_SS_SCL_LCNT_BitAddressOffset 0
`define IC_SS_SCL_LCNT_IC_SS_SCL_LCNT_RegisterSize 16

/* Register IC_SS_SCL_LCNT field RSVD_IC_SS_SCL_LOW_COUNT */
/* RSVD_IC_SS_SCL_LOW_COUNT Reserved bits - Read Only */
`define IC_SS_SCL_LCNT_RSVD_IC_SS_SCL_LOW_COUNT_BitAddressOffset 16
`define IC_SS_SCL_LCNT_RSVD_IC_SS_SCL_LOW_COUNT_RegisterSize 16

/* End of Register Definition for IC_SS_SCL_LCNT */

/* Register IC_FS_SCL_HCNT */
/* Fast Mode or Fast Mode Plus I2C Clock SCL High Count Register */
`define IC_FS_SCL_HCNT (`DW_apb_i2c_addr_block1_BaseAddress + 'h1c)
`define IC_FS_SCL_HCNT_RegisterSize 32
`define IC_FS_SCL_HCNT_RegisterResetValue 32'h3c
`define IC_FS_SCL_HCNT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_FS_SCL_HCNT */

/* Register IC_FS_SCL_HCNT field IC_FS_SCL_HCNT */
/* This register must be set before any I2C bus transaction can take place to
ensure proper I/O timing. This register sets the SCL clock high-period
count for fast mode or fast mode plus. It is used in high-speed mode to send the Master Code
and START BYTE or General CALL. For more information, refer
to "IC_CLK Frequency Configuration".

This register goes away and becomes read-only returning 0s if
IC_MAX_SPEED_MODE = standard. 
This register can be written only
when the I2C interface is disabled, which corresponds to the IC_ENABLE[0]
register being set to 0. Writes at other times have no effect.

The minimum valid value is 6; hardware prevents values less than this
being written, and if attempted results in 6 being set. For designs with
APB_DATA_WIDTH == 8 the order of programming is important to
ensure the correct operation of the DW_apb_i2c. The lower byte must be
programmed first. Then the upper byte is programmed.
 */
`define IC_FS_SCL_HCNT_IC_FS_SCL_HCNT_BitAddressOffset 0
`define IC_FS_SCL_HCNT_IC_FS_SCL_HCNT_RegisterSize 16

/* Register IC_FS_SCL_HCNT field RSVD_IC_FS_SCL_HCNT */
/* IC_FS_SCL_HCNT Reserved bits - Read Only */
`define IC_FS_SCL_HCNT_RSVD_IC_FS_SCL_HCNT_BitAddressOffset 16
`define IC_FS_SCL_HCNT_RSVD_IC_FS_SCL_HCNT_RegisterSize 16

/* End of Register Definition for IC_FS_SCL_HCNT */

/* Register IC_FS_SCL_LCNT */
/* Fast Mode or Fast Mode Plus I2C Clock SCL Low Count Register */
`define IC_FS_SCL_LCNT (`DW_apb_i2c_addr_block1_BaseAddress + 'h20)
`define IC_FS_SCL_LCNT_RegisterSize 32
`define IC_FS_SCL_LCNT_RegisterResetValue 32'h82
`define IC_FS_SCL_LCNT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_FS_SCL_LCNT */

/* Register IC_FS_SCL_LCNT field IC_FS_SCL_LCNT */
/* This register must be set before any I2C bus transaction can take place to
ensure proper I/O timing. This register sets the SCL clock low period count
for fast speed. It is used in high-speed mode to send the Master Code and
START BYTE or General CALL. For more information, refer
to "IC_CLK Frequency Configuration".

This register goes away and becomes read-only returning 0s if
IC_MAX_SPEED_MODE = standard.

This register can be written only when the I2C interface is disabled, which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other times
have no effect.

The minimum valid value is 8; hardware prevents values less than this
being written, and if attempted results in 8 being set. For designs with
APB_DATA_WIDTH = 8 the order of programming is important to ensure
the correct operation of the DW_apb_i2c. The lower byte must be
programmed first. Then the upper byte is programmed. If the value is less
than 8 then the count value gets changed to 8.

When the configuration parameter IC_HC_COUNT_VALUES is set to 1,
this register is read only.
 */
`define IC_FS_SCL_LCNT_IC_FS_SCL_LCNT_BitAddressOffset 0
`define IC_FS_SCL_LCNT_IC_FS_SCL_LCNT_RegisterSize 16

/* Register IC_FS_SCL_LCNT field RSVD_IC_FS_SCL_LCNT */
/* IC_FS_SCL_LCNT Reserved bits - Read Only */
`define IC_FS_SCL_LCNT_RSVD_IC_FS_SCL_LCNT_BitAddressOffset 16
`define IC_FS_SCL_LCNT_RSVD_IC_FS_SCL_LCNT_RegisterSize 16

/* End of Register Definition for IC_FS_SCL_LCNT */

/* Register IC_HS_SCL_HCNT */
/* High Speed I2C Clock SCL High Count Register */
`define IC_HS_SCL_HCNT (`DW_apb_i2c_addr_block1_BaseAddress + 'h24)
`define IC_HS_SCL_HCNT_RegisterSize 32
`define IC_HS_SCL_HCNT_RegisterResetValue 32'h6
`define IC_HS_SCL_HCNT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_HS_SCL_HCNT */

/* Register IC_HS_SCL_HCNT field IC_HS_SCL_HCNT */
/* This register must be set before any I2C bus transaction can take place to
ensure proper I/O timing. This register sets the SCL clock high period
count for high speed.refer to "IC_CLK Frequency Configuration". 

The SCL High time depends on the loading of the bus. For 100pF loading,
the SCL High time is 60ns; for 400pF loading, the SCL High time is
120ns.
This register goes away and becomes read-only returning 0s if
IC_MAX_SPEED_MODE != high.

This register can be written only when the I2C interface is disabled, which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other
times have no effect.

The minimum valid value is 6; hardware prevents values less than this
being written, and if attempted results in 6 being set. For designs with
APB_DATA_WIDTH = 8 the order of programming is important to
ensure the correct operation of the DW_apb_i2c. The lower byte must be
programmed first. Then the upper byte is programmed.
 */
`define IC_HS_SCL_HCNT_IC_HS_SCL_HCNT_BitAddressOffset 0
`define IC_HS_SCL_HCNT_IC_HS_SCL_HCNT_RegisterSize 16

/* Register IC_HS_SCL_HCNT field RSVD_IC_HS_SCL_HCNT */
/* IC_HS_SCL_HCNT Reserved bits - Read Only */
`define IC_HS_SCL_HCNT_RSVD_IC_HS_SCL_HCNT_BitAddressOffset 16
`define IC_HS_SCL_HCNT_RSVD_IC_HS_SCL_HCNT_RegisterSize 16

/* End of Register Definition for IC_HS_SCL_HCNT */

/* Register IC_HS_SCL_LCNT */
/* High Speed I2C Clock SCL Low Count Register */
`define IC_HS_SCL_LCNT (`DW_apb_i2c_addr_block1_BaseAddress + 'h28)
`define IC_HS_SCL_LCNT_RegisterSize 32
`define IC_HS_SCL_LCNT_RegisterResetValue 32'h10
`define IC_HS_SCL_LCNT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_HS_SCL_LCNT */

/* Register IC_HS_SCL_LCNT field IC_HS_SCL_LCNT */
/* This register must be set before any I2C bus transaction can take place to
ensure proper I/O timing. This register sets the SCL clock low period count
for high speed. For more information, refer to "IC_CLK Frequency Configuration". 
 
The SCL low time depends on the loading of the bus. For 100pF loading,
the SCL low time is 160ns; for 400pF loading, the SCL low time is 320ns.
This register goes away and becomes read-only returning 0s if
IC_MAX_SPEED_MODE != high.

This register can be written only when the I2C interface is disabled, which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other
times have no effect.

The minimum valid value is 8; hardware prevents values less than this
being written, and if attempted results in 8 being set. For designs with
APB_DATA_WIDTH == 8 the order of programming is important to
ensure the correct operation of the DW_apb_i2c. The lower byte must be
programmed first. Then the upper byte is programmed. If the value is less
than 8 then the count value gets changed to 8.
 */
`define IC_HS_SCL_LCNT_IC_HS_SCL_LCNT_BitAddressOffset 0
`define IC_HS_SCL_LCNT_IC_HS_SCL_LCNT_RegisterSize 16

/* Register IC_HS_SCL_LCNT field RSVD_IC_HS_SCL_LOW_CNT */
/* IC_HS_SCL_LCNT Reserved bits - Read Only */
`define IC_HS_SCL_LCNT_RSVD_IC_HS_SCL_LOW_CNT_BitAddressOffset 16
`define IC_HS_SCL_LCNT_RSVD_IC_HS_SCL_LOW_CNT_RegisterSize 16

/* End of Register Definition for IC_HS_SCL_LCNT */

/* Register IC_INTR_STAT */
/* I2C Interrupt Status Register

Each bit in this register has a corresponding mask bit
in the IC_INTR_MASK register. These bits are cleared by reading the matching
interrupt clear register. The unmasked raw versions of these bits are
available in the IC_RAW_INTR_STAT register. */
`define IC_INTR_STAT (`DW_apb_i2c_addr_block1_BaseAddress + 'h2c)
`define IC_INTR_STAT_RegisterSize 32
`define IC_INTR_STAT_RegisterResetValue 32'h0
`define IC_INTR_STAT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_INTR_STAT */

/* Register IC_INTR_STAT field R_RX_UNDER */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_RX_UNDER bit.
 */
`define IC_INTR_STAT_R_RX_UNDER_BitAddressOffset 0
`define IC_INTR_STAT_R_RX_UNDER_RegisterSize 1

/* Register IC_INTR_STAT field R_RX_OVER */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_RX_OVER bit.
 */
`define IC_INTR_STAT_R_RX_OVER_BitAddressOffset 1
`define IC_INTR_STAT_R_RX_OVER_RegisterSize 1

/* Register IC_INTR_STAT field R_RX_FULL */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_RX_FULL bit.
 */
`define IC_INTR_STAT_R_RX_FULL_BitAddressOffset 2
`define IC_INTR_STAT_R_RX_FULL_RegisterSize 1

/* Register IC_INTR_STAT field R_TX_OVER */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_TX_OVER bit.
 */
`define IC_INTR_STAT_R_TX_OVER_BitAddressOffset 3
`define IC_INTR_STAT_R_TX_OVER_RegisterSize 1

/* Register IC_INTR_STAT field R_TX_EMPTY */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_TX_EMPTY bit.
 */
`define IC_INTR_STAT_R_TX_EMPTY_BitAddressOffset 4
`define IC_INTR_STAT_R_TX_EMPTY_RegisterSize 1

/* Register IC_INTR_STAT field R_RD_REQ */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_RD_REQ bit.
 */
`define IC_INTR_STAT_R_RD_REQ_BitAddressOffset 5
`define IC_INTR_STAT_R_RD_REQ_RegisterSize 1

/* Register IC_INTR_STAT field R_TX_ABRT */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_TX_ABRT bit.
 */
`define IC_INTR_STAT_R_TX_ABRT_BitAddressOffset 6
`define IC_INTR_STAT_R_TX_ABRT_RegisterSize 1

/* Register IC_INTR_STAT field R_RX_DONE */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_RX_DONE bit.
 */
`define IC_INTR_STAT_R_RX_DONE_BitAddressOffset 7
`define IC_INTR_STAT_R_RX_DONE_RegisterSize 1

/* Register IC_INTR_STAT field R_ACTIVITY */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_ACTIVITY bit.
 */
`define IC_INTR_STAT_R_ACTIVITY_BitAddressOffset 8
`define IC_INTR_STAT_R_ACTIVITY_RegisterSize 1

/* Register IC_INTR_STAT field R_STOP_DET */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_STOP_DET bit.
 */
`define IC_INTR_STAT_R_STOP_DET_BitAddressOffset 9
`define IC_INTR_STAT_R_STOP_DET_RegisterSize 1

/* Register IC_INTR_STAT field R_START_DET */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_START_DET bit.
 */
`define IC_INTR_STAT_R_START_DET_BitAddressOffset 10
`define IC_INTR_STAT_R_START_DET_RegisterSize 1

/* Register IC_INTR_STAT field R_GEN_CALL */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_GEN_CALL bit.
 */
`define IC_INTR_STAT_R_GEN_CALL_BitAddressOffset 11
`define IC_INTR_STAT_R_GEN_CALL_RegisterSize 1

/* Register IC_INTR_STAT field R_RESTART_DET */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_RESTART_DET bit.
 */
`define IC_INTR_STAT_R_RESTART_DET_BitAddressOffset 12
`define IC_INTR_STAT_R_RESTART_DET_RegisterSize 1

/* Register IC_INTR_STAT field R_MASTER_ON_HOLD */
/* 
See IC_RAW_INTR_STAT for a detailed description of R_MASTER_ON_HOLD bit.
 */
`define IC_INTR_STAT_R_MASTER_ON_HOLD_BitAddressOffset 13
`define IC_INTR_STAT_R_MASTER_ON_HOLD_RegisterSize 1

/* Register IC_INTR_STAT field RSVD_R_SCL_STUCK_AT_LOW */
/* R_SCL_STUCK_AT_LOW Register field Reserved bits - Read Only
 */
`define IC_INTR_STAT_RSVD_R_SCL_STUCK_AT_LOW_BitAddressOffset 14
`define IC_INTR_STAT_RSVD_R_SCL_STUCK_AT_LOW_RegisterSize 1

/* Register IC_INTR_STAT field RSVD_IC_INTR_STAT */
/* IC_INTR_STAT Reserved bits - Read Only */
`define IC_INTR_STAT_RSVD_IC_INTR_STAT_BitAddressOffset 15
`define IC_INTR_STAT_RSVD_IC_INTR_STAT_RegisterSize 17

/* End of Register Definition for IC_INTR_STAT */

/* Register IC_INTR_MASK */
/* I2C Interrupt Mask Register.

These bits mask their corresponding interrupt status bits. This register is active low; 
a value of 0 masks the interrupt, whereas a value of 1 unmasks the interrupt.
 */
`define IC_INTR_MASK (`DW_apb_i2c_addr_block1_BaseAddress + 'h30)
`define IC_INTR_MASK_RegisterSize 32
`define IC_INTR_MASK_RegisterResetValue 32'h8ff
`define IC_INTR_MASK_RegisterResetMask 32'hffffffff

/* Register Field information for IC_INTR_MASK */

/* Register IC_INTR_MASK field M_RX_UNDER */
/* This bit masks the R_RX_UNDER interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_RX_UNDER_BitAddressOffset 0
`define IC_INTR_MASK_M_RX_UNDER_RegisterSize 1

/* Register IC_INTR_MASK field M_RX_OVER */
/* This bit masks the R_RX_OVER interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_RX_OVER_BitAddressOffset 1
`define IC_INTR_MASK_M_RX_OVER_RegisterSize 1

/* Register IC_INTR_MASK field M_RX_FULL */
/* This bit masks the R_RX_FULL interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_RX_FULL_BitAddressOffset 2
`define IC_INTR_MASK_M_RX_FULL_RegisterSize 1

/* Register IC_INTR_MASK field M_TX_OVER */
/* This bit masks the R_TX_OVER interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_TX_OVER_BitAddressOffset 3
`define IC_INTR_MASK_M_TX_OVER_RegisterSize 1

/* Register IC_INTR_MASK field M_TX_EMPTY */
/* This bit masks the R_TX_EMPTY interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_TX_EMPTY_BitAddressOffset 4
`define IC_INTR_MASK_M_TX_EMPTY_RegisterSize 1

/* Register IC_INTR_MASK field M_RD_REQ */
/* This bit masks the R_RD_REQ interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_RD_REQ_BitAddressOffset 5
`define IC_INTR_MASK_M_RD_REQ_RegisterSize 1

/* Register IC_INTR_MASK field M_TX_ABRT */
/* This bit masks the R_TX_ABRT interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_TX_ABRT_BitAddressOffset 6
`define IC_INTR_MASK_M_TX_ABRT_RegisterSize 1

/* Register IC_INTR_MASK field M_RX_DONE */
/* This bit masks the R_RX_DONE interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_RX_DONE_BitAddressOffset 7
`define IC_INTR_MASK_M_RX_DONE_RegisterSize 1

/* Register IC_INTR_MASK field M_ACTIVITY */
/* This bit masks the R_ACTIVITY interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_ACTIVITY_BitAddressOffset 8
`define IC_INTR_MASK_M_ACTIVITY_RegisterSize 1

/* Register IC_INTR_MASK field M_STOP_DET */
/* This bit masks the R_STOP_DET interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_STOP_DET_BitAddressOffset 9
`define IC_INTR_MASK_M_STOP_DET_RegisterSize 1

/* Register IC_INTR_MASK field M_START_DET */
/* This bit masks the R_START_DET interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_START_DET_BitAddressOffset 10
`define IC_INTR_MASK_M_START_DET_RegisterSize 1

/* Register IC_INTR_MASK field M_GEN_CALL */
/* This bit masks the R_GEN_CALL interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_GEN_CALL_BitAddressOffset 11
`define IC_INTR_MASK_M_GEN_CALL_RegisterSize 1

/* Register IC_INTR_MASK field M_RESTART_DET_read_only */
/* This M_RESTART_DET_read_only bit masks the R_RESTART_DET interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_RESTART_DET_read_only_BitAddressOffset 12
`define IC_INTR_MASK_M_RESTART_DET_read_only_RegisterSize 1

/* Register IC_INTR_MASK field M_MASTER_ON_HOLD_read_only */
/* This M_MASTER_ON_HOLD_read_only bit masks the R_MASTER_ON_HOLD interrupt in IC_INTR_STAT register.
 */
`define IC_INTR_MASK_M_MASTER_ON_HOLD_read_only_BitAddressOffset 13
`define IC_INTR_MASK_M_MASTER_ON_HOLD_read_only_RegisterSize 1

/* Register IC_INTR_MASK field RSVD_M_SCL_STUCK_AT_LOW */
/* M_SCL_STUCK_AT_LOW Register field Reserved bits - Read Only */
`define IC_INTR_MASK_RSVD_M_SCL_STUCK_AT_LOW_BitAddressOffset 14
`define IC_INTR_MASK_RSVD_M_SCL_STUCK_AT_LOW_RegisterSize 1

/* Register IC_INTR_MASK field RSVD_IC_INTR_STAT */
/* IC_INTR_STAT Reserved bits - Read Only */
`define IC_INTR_MASK_RSVD_IC_INTR_STAT_BitAddressOffset 15
`define IC_INTR_MASK_RSVD_IC_INTR_STAT_RegisterSize 17

/* End of Register Definition for IC_INTR_MASK */

/* Register IC_RAW_INTR_STAT */
/* I2C Raw Interrupt Status Register

Unlike the IC_INTR_STAT register, these bits are not masked so they
always show the true status of the DW_apb_i2c. */
`define IC_RAW_INTR_STAT (`DW_apb_i2c_addr_block1_BaseAddress + 'h34)
`define IC_RAW_INTR_STAT_RegisterSize 32
`define IC_RAW_INTR_STAT_RegisterResetValue 32'h0
`define IC_RAW_INTR_STAT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_RAW_INTR_STAT */

/* Register IC_RAW_INTR_STAT field RX_UNDER */
/* Set if the processor attempts to read the receive buffer when it is empty by
reading from the IC_DATA_CMD register. If the module is disabled
(IC_ENABLE[0]=0), this bit keeps its level until the master or slave state
machines go into idle, and when ic_en goes to 0, this interrupt is cleared.
 */
`define IC_RAW_INTR_STAT_RX_UNDER_BitAddressOffset 0
`define IC_RAW_INTR_STAT_RX_UNDER_RegisterSize 1

/* Register IC_RAW_INTR_STAT field RX_OVER */
/* Set if the receive buffer is completely filled to IC_RX_BUFFER_DEPTH and
an additional byte is received from an external I2C device. The DW_apb_i2c
acknowledges this, but any data bytes received after the FIFO is full are lost. If
the module is disabled (IC_ENABLE[0]=0), this bit keeps its level until the
master or slave state machines go into idle, and when ic_en goes to 0, this
interrupt is cleared.

Note:  If the configuration parameter IC_RX_FULL_HLD_BUS_EN is enabled
and bit 9 of the IC_CON register (RX_FIFO_FULL_HLD_CTRL) is
programmed to HIGH, then the RX_OVER interrupt never occurs, because the
Rx FIFO never overflows.
 */
`define IC_RAW_INTR_STAT_RX_OVER_BitAddressOffset 1
`define IC_RAW_INTR_STAT_RX_OVER_RegisterSize 1

/* Register IC_RAW_INTR_STAT field RX_FULL */
/* Set when the receive buffer reaches or goes above the RX_TL threshold in the
IC_RX_TL register. It is automatically cleared by hardware when buffer level
goes below the threshold. If the module is disabled (IC_ENABLE[0]=0), the
RX FIFO is flushed and held in reset; therefore the RX FIFO is not full. So this
bit is cleared once the IC_ENABLE bit 0 is programmed with a 0, regardless of
the activity that continues.
 */
`define IC_RAW_INTR_STAT_RX_FULL_BitAddressOffset 2
`define IC_RAW_INTR_STAT_RX_FULL_RegisterSize 1

/* Register IC_RAW_INTR_STAT field TX_OVER */
/* Set during transmit if the transmit buffer is filled to IC_TX_BUFFER_DEPTH
and the processor attempts to issue another I2C command by writing to the
IC_DATA_CMD register. When the module is disabled, this bit keeps its level
until the master or slave state machines go into idle, and when ic_en goes to 0,
this interrupt is cleared.
 */
`define IC_RAW_INTR_STAT_TX_OVER_BitAddressOffset 3
`define IC_RAW_INTR_STAT_TX_OVER_RegisterSize 1

/* Register IC_RAW_INTR_STAT field TX_EMPTY */
/* The behavior of the TX_EMPTY interrupt status 
differs based on the TX_EMPTY_CTRL selection in the IC_CON register.
 - When TX_EMPTY_CTRL = 0:
This bit is set to 1 when the transmit buffer is at or below the threshold value set in the IC_TX_TL register.
 - When TX_EMPTY_CTRL = 1:
This bit is set to 1 when the transmit buffer is at or below the threshold value set in the IC_TX_TL register and the transmission of the address/data from the internal shift register for the most recently popped command is completed.
It is automatically cleared by hardware when the buffer level goes above the
threshold. When IC_ENABLE[0] is set to 0, the TX FIFO is flushed and held in
reset. There the TX FIFO looks like it has no data within it, so this bit is set to 1,
provided there is activity in the master or slave state machines. When there is no
longer any activity, then with ic_en=0, this bit is set to 0.
 */
`define IC_RAW_INTR_STAT_TX_EMPTY_BitAddressOffset 4
`define IC_RAW_INTR_STAT_TX_EMPTY_RegisterSize 1

/* Register IC_RAW_INTR_STAT field RD_REQ */
/* This bit is set to 1 when DW_apb_i2c is acting as a slave and another I2C
master is attempting to read data from DW_apb_i2c. The DW_apb_i2c holds
the I2C bus in a wait state (SCL=0) until this interrupt is serviced, which means
that the slave has been addressed by a remote master that is asking for data to
be transferred. The processor must respond to this interrupt and then write the
requested data to the IC_DATA_CMD register. This bit is set to 0 just after the
processor reads the IC_CLR_RD_REQ register. */
`define IC_RAW_INTR_STAT_RD_REQ_BitAddressOffset 5
`define IC_RAW_INTR_STAT_RD_REQ_RegisterSize 1

/* Register IC_RAW_INTR_STAT field TX_ABRT */
/* This bit indicates if DW_apb_i2c, as an I2C transmitter,
is unable to complete the intended actions on the
contents of the transmit FIFO. This situation can
occur both as an I2C master or an I2C slave, and is
referred to as a 'transmit abort'.
When this bit is set to 1, the IC_TX_ABRT_SOURCE register
indicates the reason why the transmit abort takes places.

Note:  The DW_apb_i2c flushes/resets/empties only the TX_FIFO whenever
there is a transmit abort caused by any of the events tracked by the
IC_TX_ABRT_SOURCE register. The Tx FIFO remains in this flushed state
until the register IC_CLR_TX_ABRT is read. Once this read is performed, the
Tx FIFO is then ready to accept more data bytes from the APB interface. RX
FIFO flush because of TX_ABRT is controlled by the coreConsultant parameter IC_AVOID_RX_FIFO_FLUSH_ON_TX_ABRT.
 */
`define IC_RAW_INTR_STAT_TX_ABRT_BitAddressOffset 6
`define IC_RAW_INTR_STAT_TX_ABRT_RegisterSize 1

/* Register IC_RAW_INTR_STAT field RX_DONE */
/* When the DW_apb_i2c is acting as a slave-transmitter,
this bit is set to 1 if the master does not acknowledge
a transmitted byte. This occurs on the last byte of
the transmission, indicating that the transmission is done.
 */
`define IC_RAW_INTR_STAT_RX_DONE_BitAddressOffset 7
`define IC_RAW_INTR_STAT_RX_DONE_RegisterSize 1

/* Register IC_RAW_INTR_STAT field ACTIVITY */
/* This bit captures DW_apb_i2c activity and stays set until it is cleared. There
are four ways to clear it:
 - Disabling the DW_apb_i2c
 - Reading the IC_CLR_ACTIVITY register
 - Reading the IC_CLR_INTR register
 - System reset
Once this bit is set, it stays set unless one of the four methods is used to clear it. Even if the DW_apb_i2c module is idle, this bit remains set until cleared, indicating that there was activity on the bus.
 */
`define IC_RAW_INTR_STAT_ACTIVITY_BitAddressOffset 8
`define IC_RAW_INTR_STAT_ACTIVITY_RegisterSize 1

/* Register IC_RAW_INTR_STAT field STOP_DET */
/* Indicates whether a STOP condition has occurred on the I2C interface regardless of whether DW_apb_i2c is operating in slave or master mode.

In Slave Mode:
 - If IC_CON[7]=1'b1  (STOP_DET_IFADDRESSED), the STOP_DET interrupt will be issued only if slave is addressed.
Note: During a general call address, this slave does not issue a STOP_DET interrupt if STOP_DET_IF_ADDRESSED=1'b1, even if the slave responds to the general call address by generating ACK. The STOP_DET interrupt is generated only when the transmitted address matches the slave address (SAR).
 - If IC_CON[7]=1'b0 (STOP_DET_IFADDRESSED), the STOP_DET interrupt is issued irrespective of whether it is being addressed.
In Master Mode:
 - If IC_CON[10]=1'b1  (STOP_DET_IF_MASTER_ACTIVE),the STOP_DET interrupt will be issued only if Master is active.
 - If IC_CON[10]=1'b0  (STOP_DET_IFADDRESSED),the STOP_DET interrupt will be issued irrespective of whether master is active or not.
 */
`define IC_RAW_INTR_STAT_STOP_DET_BitAddressOffset 9
`define IC_RAW_INTR_STAT_STOP_DET_RegisterSize 1

/* Register IC_RAW_INTR_STAT field START_DET */
/* Indicates whether a START or RESTART condition has occurred on the I2C
interface regardless of whether DW_apb_i2c is operating in slave or master
mode.
 */
`define IC_RAW_INTR_STAT_START_DET_BitAddressOffset 10
`define IC_RAW_INTR_STAT_START_DET_RegisterSize 1

/* Register IC_RAW_INTR_STAT field GEN_CALL */
/* Set only when a General Call address is received and it is acknowledged. It
stays set until it is cleared either by disabling DW_apb_i2c or when the CPU
reads bit 0 of the IC_CLR_GEN_CALL register. DW_apb_i2c stores the
received data in the Rx buffer.
 */
`define IC_RAW_INTR_STAT_GEN_CALL_BitAddressOffset 11
`define IC_RAW_INTR_STAT_GEN_CALL_RegisterSize 1

/* Register IC_RAW_INTR_STAT field RESTART_DET */
/* Indicates whether a RESTART condition has occurred on the I2C interface 
when DW_apb_i2c is operating in Slave mode and the slave is being addressed.
 Enabled only when IC_SLV_RESTART_DET_EN=1.

Note: However, in high-speed mode or during a START BYTE transfer, the RESTART comes before the address field as 
per the I2C protocol. In this case, the slave is not the addressed slave when the RESTART is issued, therefore DW_apb_i2c 
does not generate the RESTART_DET interrupt.
 */
`define IC_RAW_INTR_STAT_RESTART_DET_BitAddressOffset 12
`define IC_RAW_INTR_STAT_RESTART_DET_RegisterSize 1

/* Register IC_RAW_INTR_STAT field MASTER_ON_HOLD */
/* Indicates whether master is holding the bus and TX FIFO is empty.
Enabled only when I2C_DYNAMIC_TAR_UPDATE=1 and IC_EMPTYFIFO_HOLD_MASTER_EN=1.
 */
`define IC_RAW_INTR_STAT_MASTER_ON_HOLD_BitAddressOffset 13
`define IC_RAW_INTR_STAT_MASTER_ON_HOLD_RegisterSize 1

/* Register IC_RAW_INTR_STAT field RSVD_SCL_STUCK_AT_LOW */
/* SCL_STUCK_AT_LOW Register field Reserved bits - Read Only */
`define IC_RAW_INTR_STAT_RSVD_SCL_STUCK_AT_LOW_BitAddressOffset 14
`define IC_RAW_INTR_STAT_RSVD_SCL_STUCK_AT_LOW_RegisterSize 1

/* Register IC_RAW_INTR_STAT field RSVD_IC_RAW_INTR_STAT */
/* IC_RAW_INTR_STAT Reserved bits - Read Only */
`define IC_RAW_INTR_STAT_RSVD_IC_RAW_INTR_STAT_BitAddressOffset 15
`define IC_RAW_INTR_STAT_RSVD_IC_RAW_INTR_STAT_RegisterSize 17

/* End of Register Definition for IC_RAW_INTR_STAT */

/* Register IC_RX_TL */
/* I2C Receive FIFO Threshold Register */
`define IC_RX_TL (`DW_apb_i2c_addr_block1_BaseAddress + 'h38)
`define IC_RX_TL_RegisterSize 32
`define IC_RX_TL_RegisterResetValue 32'h0
`define IC_RX_TL_RegisterResetMask 32'hffffffff

/* Register Field information for IC_RX_TL */

/* Register IC_RX_TL field RX_TL */
/* Receive FIFO Threshold Level.

Controls the level of entries (or above) that triggers
the RX_FULL interrupt (bit 2 in IC_RAW_INTR_STAT register).
The valid range is 0-255, with the additional restriction that
hardware does not allow this value to be set to a value larger
than the depth of the buffer. If an attempt is made to do that,
the actual value set will be the maximum depth of the buffer.
A value of 0 sets the threshold for 1 entry, and a value of 255
sets the threshold for 256 entries.
 */
`define IC_RX_TL_RX_TL_BitAddressOffset 0
`define IC_RX_TL_RX_TL_RegisterSize 8

/* Register IC_RX_TL field RSVD_IC_RX_TL */
/* IC_RX_TL Reserved bits - Read Only */
`define IC_RX_TL_RSVD_IC_RX_TL_BitAddressOffset 8
`define IC_RX_TL_RSVD_IC_RX_TL_RegisterSize 24

/* End of Register Definition for IC_RX_TL */

/* Register IC_TX_TL */
/* I2C Transmit FIFO Threshold Register */
`define IC_TX_TL (`DW_apb_i2c_addr_block1_BaseAddress + 'h3c)
`define IC_TX_TL_RegisterSize 32
`define IC_TX_TL_RegisterResetValue 32'h0
`define IC_TX_TL_RegisterResetMask 32'hffffffff

/* Register Field information for IC_TX_TL */

/* Register IC_TX_TL field TX_TL */
/* Transmit FIFO Threshold Level.

Controls the level of entries (or below) that trigger
the TX_EMPTY interrupt (bit 4 in IC_RAW_INTR_STAT register).
The valid range is 0-255, with the additional restriction that
it may not be set to value larger than the depth of the buffer.
If an attempt is made to do that, the actual value set will be
the maximum depth of the buffer.
A value of 0 sets the threshold for 0 entries, and a value of 255
sets the threshold for 255 entries.
 */
`define IC_TX_TL_TX_TL_BitAddressOffset 0
`define IC_TX_TL_TX_TL_RegisterSize 8

/* Register IC_TX_TL field RSVD_IC_TX_TL */
/* IC_TX_TL Reserved bits - Read Only */
`define IC_TX_TL_RSVD_IC_TX_TL_BitAddressOffset 8
`define IC_TX_TL_RSVD_IC_TX_TL_RegisterSize 24

/* End of Register Definition for IC_TX_TL */

/* Register IC_CLR_INTR */
/* Clear Combined and Individual Interrupt Register */
`define IC_CLR_INTR (`DW_apb_i2c_addr_block1_BaseAddress + 'h40)
`define IC_CLR_INTR_RegisterSize 32
`define IC_CLR_INTR_RegisterResetValue 32'h0
`define IC_CLR_INTR_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_INTR */

/* Register IC_CLR_INTR field CLR_INTR */
/* Read this register to clear the combined interrupt,
all individual interrupts, and the IC_TX_ABRT_SOURCE register.
This bit does not clear hardware clearable interrupts but software
clearable interrupts. Refer to Bit 9 of the IC_TX_ABRT_SOURCE register
for an exception to clearing IC_TX_ABRT_SOURCE.
 */
`define IC_CLR_INTR_CLR_INTR_BitAddressOffset 0
`define IC_CLR_INTR_CLR_INTR_RegisterSize 1

/* Register IC_CLR_INTR field RSVD_IC_CLR_INTR */
/* CLR_INTR Reserved bits - Read Only */
`define IC_CLR_INTR_RSVD_IC_CLR_INTR_BitAddressOffset 1
`define IC_CLR_INTR_RSVD_IC_CLR_INTR_RegisterSize 31

/* End of Register Definition for IC_CLR_INTR */

/* Register IC_CLR_RX_UNDER */
/* Clear RX_UNDER Interrupt Register */
`define IC_CLR_RX_UNDER (`DW_apb_i2c_addr_block1_BaseAddress + 'h44)
`define IC_CLR_RX_UNDER_RegisterSize 32
`define IC_CLR_RX_UNDER_RegisterResetValue 32'h0
`define IC_CLR_RX_UNDER_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_RX_UNDER */

/* Register IC_CLR_RX_UNDER field CLR_RX_UNDER */
/* Read this register to clear the RX_UNDER
interrupt (bit 0) of the IC_RAW_INTR_STAT register.
 */
`define IC_CLR_RX_UNDER_CLR_RX_UNDER_BitAddressOffset 0
`define IC_CLR_RX_UNDER_CLR_RX_UNDER_RegisterSize 1

/* Register IC_CLR_RX_UNDER field RSVD_IC_CLR_RX_UNDER */
/* IC_CLR_RX_UNDER Reserved bits - Read Only */
`define IC_CLR_RX_UNDER_RSVD_IC_CLR_RX_UNDER_BitAddressOffset 1
`define IC_CLR_RX_UNDER_RSVD_IC_CLR_RX_UNDER_RegisterSize 31

/* End of Register Definition for IC_CLR_RX_UNDER */

/* Register IC_CLR_RX_OVER */
/* Clear RX_OVER Interrupt Register */
`define IC_CLR_RX_OVER (`DW_apb_i2c_addr_block1_BaseAddress + 'h48)
`define IC_CLR_RX_OVER_RegisterSize 32
`define IC_CLR_RX_OVER_RegisterResetValue 32'h0
`define IC_CLR_RX_OVER_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_RX_OVER */

/* Register IC_CLR_RX_OVER field CLR_RX_OVER */
/* Read this register to clear the RX_OVER
interrupt (bit 1) of the IC_RAW_INTR_STAT register.
 */
`define IC_CLR_RX_OVER_CLR_RX_OVER_BitAddressOffset 0
`define IC_CLR_RX_OVER_CLR_RX_OVER_RegisterSize 1

/* Register IC_CLR_RX_OVER field RSVD_IC_CLR_RX_OVER */
/* IC_CLR_RX_OVER Reserved bits - Read Only */
`define IC_CLR_RX_OVER_RSVD_IC_CLR_RX_OVER_BitAddressOffset 1
`define IC_CLR_RX_OVER_RSVD_IC_CLR_RX_OVER_RegisterSize 31

/* End of Register Definition for IC_CLR_RX_OVER */

/* Register IC_CLR_TX_OVER */
/* Clear TX_OVER Interrupt Register */
`define IC_CLR_TX_OVER (`DW_apb_i2c_addr_block1_BaseAddress + 'h4c)
`define IC_CLR_TX_OVER_RegisterSize 32
`define IC_CLR_TX_OVER_RegisterResetValue 32'h0
`define IC_CLR_TX_OVER_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_TX_OVER */

/* Register IC_CLR_TX_OVER field CLR_TX_OVER */
/* Read this register to clear the TX_OVER
interrupt (bit 3) of the IC_RAW_INTR_STAT register. */
`define IC_CLR_TX_OVER_CLR_TX_OVER_BitAddressOffset 0
`define IC_CLR_TX_OVER_CLR_TX_OVER_RegisterSize 1

/* Register IC_CLR_TX_OVER field RSVD_IC_CLR_TX_OVER */
/* IC_CLR_TX_OVER Reserved bits - Read Only */
`define IC_CLR_TX_OVER_RSVD_IC_CLR_TX_OVER_BitAddressOffset 1
`define IC_CLR_TX_OVER_RSVD_IC_CLR_TX_OVER_RegisterSize 31

/* End of Register Definition for IC_CLR_TX_OVER */

/* Register IC_CLR_RD_REQ */
/* Clear RD_REQ Interrupt Register */
`define IC_CLR_RD_REQ (`DW_apb_i2c_addr_block1_BaseAddress + 'h50)
`define IC_CLR_RD_REQ_RegisterSize 32
`define IC_CLR_RD_REQ_RegisterResetValue 32'h0
`define IC_CLR_RD_REQ_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_RD_REQ */

/* Register IC_CLR_RD_REQ field CLR_RD_REQ */
/* Read this register to clear the RD_REQ
interrupt (bit 5) of the IC_RAW_INTR_STAT register.
 */
`define IC_CLR_RD_REQ_CLR_RD_REQ_BitAddressOffset 0
`define IC_CLR_RD_REQ_CLR_RD_REQ_RegisterSize 1

/* Register IC_CLR_RD_REQ field RSVD_IC_CLR_RD_REQ */
/* IC_CLR_RD_REQ Reserved bits - Read Only */
`define IC_CLR_RD_REQ_RSVD_IC_CLR_RD_REQ_BitAddressOffset 1
`define IC_CLR_RD_REQ_RSVD_IC_CLR_RD_REQ_RegisterSize 31

/* End of Register Definition for IC_CLR_RD_REQ */

/* Register IC_CLR_TX_ABRT */
/* Clear TX_ABRT Interrupt Register */
`define IC_CLR_TX_ABRT (`DW_apb_i2c_addr_block1_BaseAddress + 'h54)
`define IC_CLR_TX_ABRT_RegisterSize 32
`define IC_CLR_TX_ABRT_RegisterResetValue 32'h0
`define IC_CLR_TX_ABRT_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_TX_ABRT */

/* Register IC_CLR_TX_ABRT field CLR_TX_ABRT */
/* Read this register to clear the TX_ABRT
interrupt (bit 6) of the IC_RAW_INTR_STAT register,
and the IC_TX_ABRT_SOURCE register.
This also releases the TX FIFO from the flushed/reset
state, allowing more writes to the TX FIFO.
Refer to Bit 9 of the IC_TX_ABRT_SOURCE register for
an exception to clearing IC_TX_ABRT_SOURCE.
 */
`define IC_CLR_TX_ABRT_CLR_TX_ABRT_BitAddressOffset 0
`define IC_CLR_TX_ABRT_CLR_TX_ABRT_RegisterSize 1

/* Register IC_CLR_TX_ABRT field RSVD_IC_CLR_TX_ABRT */
/* IC_CLR_TX_ABRT Reserved bits - Read Only */
`define IC_CLR_TX_ABRT_RSVD_IC_CLR_TX_ABRT_BitAddressOffset 1
`define IC_CLR_TX_ABRT_RSVD_IC_CLR_TX_ABRT_RegisterSize 31

/* End of Register Definition for IC_CLR_TX_ABRT */

/* Register IC_CLR_RX_DONE */
/* Clear RX_DONE Interrupt Register */
`define IC_CLR_RX_DONE (`DW_apb_i2c_addr_block1_BaseAddress + 'h58)
`define IC_CLR_RX_DONE_RegisterSize 32
`define IC_CLR_RX_DONE_RegisterResetValue 32'h0
`define IC_CLR_RX_DONE_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_RX_DONE */

/* Register IC_CLR_RX_DONE field CLR_RX_DONE */
/* Read this register to clear the RX_DONE
interrupt (bit 7) of the IC_RAW_INTR_STAT register.
 */
`define IC_CLR_RX_DONE_CLR_RX_DONE_BitAddressOffset 0
`define IC_CLR_RX_DONE_CLR_RX_DONE_RegisterSize 1

/* Register IC_CLR_RX_DONE field RSVD_IC_CLR_RX_DONE */
/* IC_CLR_RX_DONE Reserved bits - Read Only */
`define IC_CLR_RX_DONE_RSVD_IC_CLR_RX_DONE_BitAddressOffset 1
`define IC_CLR_RX_DONE_RSVD_IC_CLR_RX_DONE_RegisterSize 31

/* End of Register Definition for IC_CLR_RX_DONE */

/* Register IC_CLR_ACTIVITY */
/* Clear ACTIVITY Interrupt Register */
`define IC_CLR_ACTIVITY (`DW_apb_i2c_addr_block1_BaseAddress + 'h5c)
`define IC_CLR_ACTIVITY_RegisterSize 32
`define IC_CLR_ACTIVITY_RegisterResetValue 32'h0
`define IC_CLR_ACTIVITY_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_ACTIVITY */

/* Register IC_CLR_ACTIVITY field CLR_ACTIVITY */
/* Reading this register clears the ACTIVITY
interrupt if the I2C is not active anymore. If the
I2C module is still active on the bus, the ACTIVITY
interrupt bit continues to be set. It is automatically
cleared by hardware if the module is disabled and if
there is no further activity on the bus. The value read
from this register to get status of the ACTIVITY interrupt
(bit 8) of the IC_RAW_INTR_STAT register.
 */
`define IC_CLR_ACTIVITY_CLR_ACTIVITY_BitAddressOffset 0
`define IC_CLR_ACTIVITY_CLR_ACTIVITY_RegisterSize 1

/* Register IC_CLR_ACTIVITY field RSVD_IC_CLR_ACTIVITY */
/* IC_CLR_ACTIVITY Reserved bits - Read Only */
`define IC_CLR_ACTIVITY_RSVD_IC_CLR_ACTIVITY_BitAddressOffset 1
`define IC_CLR_ACTIVITY_RSVD_IC_CLR_ACTIVITY_RegisterSize 31

/* End of Register Definition for IC_CLR_ACTIVITY */

/* Register IC_CLR_STOP_DET */
/* Clear STOP_DET Interrupt Register */
`define IC_CLR_STOP_DET (`DW_apb_i2c_addr_block1_BaseAddress + 'h60)
`define IC_CLR_STOP_DET_RegisterSize 32
`define IC_CLR_STOP_DET_RegisterResetValue 32'h0
`define IC_CLR_STOP_DET_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_STOP_DET */

/* Register IC_CLR_STOP_DET field CLR_STOP_DET */
/* Read this register to clear the STOP_DET
interrupt (bit 9) of the IC_RAW_INTR_STAT register. */
`define IC_CLR_STOP_DET_CLR_STOP_DET_BitAddressOffset 0
`define IC_CLR_STOP_DET_CLR_STOP_DET_RegisterSize 1

/* Register IC_CLR_STOP_DET field RSVD_IC_CLR_STOP_DET */
/* IC_CLR_STOP_DET Reserved bits - Read Only */
`define IC_CLR_STOP_DET_RSVD_IC_CLR_STOP_DET_BitAddressOffset 1
`define IC_CLR_STOP_DET_RSVD_IC_CLR_STOP_DET_RegisterSize 31

/* End of Register Definition for IC_CLR_STOP_DET */

/* Register IC_CLR_START_DET */
/* Clear START_DET Interrupt Register */
`define IC_CLR_START_DET (`DW_apb_i2c_addr_block1_BaseAddress + 'h64)
`define IC_CLR_START_DET_RegisterSize 32
`define IC_CLR_START_DET_RegisterResetValue 32'h0
`define IC_CLR_START_DET_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_START_DET */

/* Register IC_CLR_START_DET field CLR_START_DET */
/* Read this register to clear the START_DET
interrupt (bit 10) of the IC_RAW_INTR_STAT register.
 */
`define IC_CLR_START_DET_CLR_START_DET_BitAddressOffset 0
`define IC_CLR_START_DET_CLR_START_DET_RegisterSize 1

/* Register IC_CLR_START_DET field RSVD_IC_CLR_START_DET */
/* IC_CLR_START_DET Reserved bits - Read Only */
`define IC_CLR_START_DET_RSVD_IC_CLR_START_DET_BitAddressOffset 1
`define IC_CLR_START_DET_RSVD_IC_CLR_START_DET_RegisterSize 31

/* End of Register Definition for IC_CLR_START_DET */

/* Register IC_CLR_GEN_CALL */
/* Clear GEN_CALL Interrupt Register */
`define IC_CLR_GEN_CALL (`DW_apb_i2c_addr_block1_BaseAddress + 'h68)
`define IC_CLR_GEN_CALL_RegisterSize 32
`define IC_CLR_GEN_CALL_RegisterResetValue 32'h0
`define IC_CLR_GEN_CALL_RegisterResetMask 32'hffffffff

/* Register Field information for IC_CLR_GEN_CALL */

/* Register IC_CLR_GEN_CALL field CLR_GEN_CALL */
/* Read this register to clear the GEN_CALL
interrupt (bit 11) of IC_RAW_INTR_STAT register.
 */
`define IC_CLR_GEN_CALL_CLR_GEN_CALL_BitAddressOffset 0
`define IC_CLR_GEN_CALL_CLR_GEN_CALL_RegisterSize 1

/* Register IC_CLR_GEN_CALL field RSVD_IC_CLR_GEN_CALL */
/* IC_CLR_GEN_CALL Reserved bits - Read Only */
`define IC_CLR_GEN_CALL_RSVD_IC_CLR_GEN_CALL_BitAddressOffset 1
`define IC_CLR_GEN_CALL_RSVD_IC_CLR_GEN_CALL_RegisterSize 31

/* End of Register Definition for IC_CLR_GEN_CALL */

/* Register IC_ENABLE */
/* I2C Enable Register */
`define IC_ENABLE (`DW_apb_i2c_addr_block1_BaseAddress + 'h6c)
`define IC_ENABLE_RegisterSize 32
`define IC_ENABLE_RegisterResetValue 32'h0
`define IC_ENABLE_RegisterResetMask 32'hffffffff

/* Register Field information for IC_ENABLE */

/* Register IC_ENABLE field ENABLE */
/* Controls whether the DW_apb_i2c is enabled.
 - 0: Disables DW_apb_i2c (TX and RX FIFOs are held in an erased state)
 - 1: Enables DW_apb_i2c
Software can disable DW_apb_i2c while it is active.
However, it is important that care be taken to ensure
that DW_apb_i2c is disabled properly. A recommended procedure is 
described in "Disabling DW_apb_i2c".

When DW_apb_i2c is disabled, the following occurs:
 - The TX FIFO and RX FIFO get flushed.
 - Status bits in the IC_INTR_STAT register are still active until DW_apb_i2c goes into IDLE state.
If the module is transmitting, it stops as well as deletes
the contents of the transmit buffer after the current transfer
is complete. If the module is receiving, the DW_apb_i2c stops
the current transfer at the end of the current byte and does not
acknowledge the transfer.

In systems with asynchronous pclk and ic_clk when IC_CLK_TYPE
parameter set to asynchronous (1), there is a two ic_clk delay
when enabling or disabling the DW_apb_i2c.
For a detailed description on how to disable DW_apb_i2c, refer to "Disabling
DW_apb_i2c"
 */
`define IC_ENABLE_ENABLE_BitAddressOffset 0
`define IC_ENABLE_ENABLE_RegisterSize 1

/* Register IC_ENABLE field ABORT */
/* 
When set, the controller initiates the transfer abort.
 - 0: ABORT not initiated or ABORT done
 - 1: ABORT operation in progress
The software can abort the I2C transfer in master mode by setting this bit. The software 
can set this bit only when ENABLE is already set; otherwise, the controller ignores any 
write to ABORT bit. The software cannot clear the ABORT bit once set. In response to 
an ABORT, the controller issues a STOP and flushes the Tx FIFO after completing the 
current transfer, then sets the TX_ABORT interrupt after the abort operation. The 
ABORT bit is cleared automatically after the abort operation. 

For a detailed description on how to abort I2C transfers, refer to "Aborting I2C Transfers".
 */
`define IC_ENABLE_ABORT_BitAddressOffset 1
`define IC_ENABLE_ABORT_RegisterSize 1

/* Register IC_ENABLE field TX_CMD_BLOCK */
/* In Master mode:
 - 1'b1: Blocks the transmission of data on I2C bus even if Tx FIFO has data to transmit.
 - 1'b0: The transmission of data starts on I2C bus automatically, as soon as the first data is available in the Tx FIFO.
Note: To block the execution of Master commands,
set the TX_CMD_BLOCK bit only when  Tx FIFO is empty (IC_STATUS[2]==1) and Master is in Idle state (IC_STATUS[5] == 0). 
Any further commands put in the Tx FIFO are not executed until TX_CMD_BLOCK bit is unset.
 */
`define IC_ENABLE_TX_CMD_BLOCK_BitAddressOffset 2
`define IC_ENABLE_TX_CMD_BLOCK_RegisterSize 1

/* Register IC_ENABLE field RSVD_SDA_STUCK_RECOVERY_ENABLE */
/* SDA_STUCK_RECOVERY_ENABLE Register field Reserved bits - Read Only */
`define IC_ENABLE_RSVD_SDA_STUCK_RECOVERY_ENABLE_BitAddressOffset 3
`define IC_ENABLE_RSVD_SDA_STUCK_RECOVERY_ENABLE_RegisterSize 1

/* Register IC_ENABLE field RSVD_IC_ENABLE_1 */
/* RSVD_IC_ENABLE_1 Reserved bits - Read Only */
`define IC_ENABLE_RSVD_IC_ENABLE_1_BitAddressOffset 4
`define IC_ENABLE_RSVD_IC_ENABLE_1_RegisterSize 12

/* Register IC_ENABLE field RSVD_SMBUS_CLK_RESET */
/* SMBUS_CLK_RESET Register field Reserved bits - Read Only */
`define IC_ENABLE_RSVD_SMBUS_CLK_RESET_BitAddressOffset 16
`define IC_ENABLE_RSVD_SMBUS_CLK_RESET_RegisterSize 1

/* Register IC_ENABLE field RSVD_SMBUS_SUSPEND_EN */
/* SMBUS_SUSPEND_EN Register field Reserved bits - Read Only */
`define IC_ENABLE_RSVD_SMBUS_SUSPEND_EN_BitAddressOffset 17
`define IC_ENABLE_RSVD_SMBUS_SUSPEND_EN_RegisterSize 1

/* Register IC_ENABLE field RSVD_SMBUS_ALERT_EN */
/* SMBUS_ALERT_EN Register field Reserved bits - Read Only */
`define IC_ENABLE_RSVD_SMBUS_ALERT_EN_BitAddressOffset 18
`define IC_ENABLE_RSVD_SMBUS_ALERT_EN_RegisterSize 1

/* Register IC_ENABLE field RSVD_IC_ENABLE_2 */
/* IC_ENABLE Reserved bits - Read Only */
`define IC_ENABLE_RSVD_IC_ENABLE_2_BitAddressOffset 19
`define IC_ENABLE_RSVD_IC_ENABLE_2_RegisterSize 13

/* End of Register Definition for IC_ENABLE */

/* Register IC_STATUS */
/* I2C Status Register 

This is a read-only register used to indicate the current
transfer status and FIFO status. The status register may be
read at any time. None of the bits in this register request
an interrupt.

When the I2C is disabled by writing 0 in bit 0 of the IC_ENABLE register:
 - Bits 1 and 2 are set to 1
 - Bits 3 and 10 are set to 0
When the master or slave state machines goes to idle and ic_en=0:
 - Bits 5 and 6 are set to 0 */
`define IC_STATUS (`DW_apb_i2c_addr_block1_BaseAddress + 'h70)
`define IC_STATUS_RegisterSize 32
`define IC_STATUS_RegisterResetValue 32'h6
`define IC_STATUS_RegisterResetMask 32'hffffffff

/* Register Field information for IC_STATUS */

/* Register IC_STATUS field ACTIVITY */
/* I2C Activity Status.
 */
`define IC_STATUS_ACTIVITY_BitAddressOffset 0
`define IC_STATUS_ACTIVITY_RegisterSize 1

/* Register IC_STATUS field TFNF */
/* Transmit FIFO Not Full.
Set when the transmit FIFO contains one or more
empty locations, and is cleared when the FIFO is full.
 - 0: Transmit FIFO is full
 - 1: Transmit FIFO is not full
 */
`define IC_STATUS_TFNF_BitAddressOffset 1
`define IC_STATUS_TFNF_RegisterSize 1

/* Register IC_STATUS field TFE */
/* Transmit FIFO Completely Empty.
When the transmit FIFO is completely empty, this bit is set.
When it contains one or more valid entries, this bit is
cleared. This bit field does not request an interrupt.
 - 0: Transmit FIFO is not empty
 - 1: Transmit FIFO is empty
 */
`define IC_STATUS_TFE_BitAddressOffset 2
`define IC_STATUS_TFE_RegisterSize 1

/* Register IC_STATUS field RFNE */
/* Receive FIFO Not Empty.
This bit is set when the receive FIFO contains one or
more entries; it is cleared when the receive FIFO is empty.
 - 0: Receive FIFO is empty
 - 1: Receive FIFO is not empty
 */
`define IC_STATUS_RFNE_BitAddressOffset 3
`define IC_STATUS_RFNE_RegisterSize 1

/* Register IC_STATUS field RFF */
/* Receive FIFO Completely Full.
When the receive FIFO is completely full, this
bit is set. When the receive FIFO contains one
or more empty location, this bit is cleared.
 - 0: Receive FIFO is not full
 - 1: Receive FIFO is full
 */
`define IC_STATUS_RFF_BitAddressOffset 4
`define IC_STATUS_RFF_RegisterSize 1

/* Register IC_STATUS field MST_ACTIVITY */
/* Master FSM Activity Status.
When the Master Finite State Machine (FSM) is
not in the IDLE state, this bit is set.
 - 0: Master FSM is in IDLE state so the Master part of DW_apb_i2c is not Active
 - 1: Master FSM is not in IDLE state so the Master part of DW_apb_i2c is Active
Note: 
IC_STATUS[0]-that is, ACTIVITY bit-is the OR of
SLV_ACTIVITY and MST_ACTIVITY bits.
 */
`define IC_STATUS_MST_ACTIVITY_BitAddressOffset 5
`define IC_STATUS_MST_ACTIVITY_RegisterSize 1

/* Register IC_STATUS field SLV_ACTIVITY */
/* Slave FSM Activity Status.
When the Slave Finite State Machine (FSM) is not
in the IDLE state, this bit is set.
 - 0: Slave FSM is in IDLE state so the Slave part of DW_apb_i2c is not Active
 - 1: Slave FSM is not in IDLE state so the Slave part of DW_apb_i2c is Active
 */
`define IC_STATUS_SLV_ACTIVITY_BitAddressOffset 6
`define IC_STATUS_SLV_ACTIVITY_RegisterSize 1

/* Register IC_STATUS field RSVD_MST_HOLD_TX_FIFO_EMPTY */
/* MST_HOLD_TX_FIFO_EMPTY Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_MST_HOLD_TX_FIFO_EMPTY_BitAddressOffset 7
`define IC_STATUS_RSVD_MST_HOLD_TX_FIFO_EMPTY_RegisterSize 1

/* Register IC_STATUS field RSVD_MST_HOLD_RX_FIFO_FULL */
/* MST_HOLD_RX_FIFO_FULL Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_MST_HOLD_RX_FIFO_FULL_BitAddressOffset 8
`define IC_STATUS_RSVD_MST_HOLD_RX_FIFO_FULL_RegisterSize 1

/* Register IC_STATUS field RSVD_SLV_HOLD_TX_FIFO_EMPTY */
/* SLV_HOLD_TX_FIFO_EMPTY Regsiter field Reserved bits - Read Only */
`define IC_STATUS_RSVD_SLV_HOLD_TX_FIFO_EMPTY_BitAddressOffset 9
`define IC_STATUS_RSVD_SLV_HOLD_TX_FIFO_EMPTY_RegisterSize 1

/* Register IC_STATUS field RSVD_SLV_HOLD_RX_FIFO_FULL */
/* SLV_HOLD_RX_FIFO_FULL Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_SLV_HOLD_RX_FIFO_FULL_BitAddressOffset 10
`define IC_STATUS_RSVD_SLV_HOLD_RX_FIFO_FULL_RegisterSize 1

/* Register IC_STATUS field RSVD_SDA_STUCK_NOT_RECOVERED */
/* SDA_STUCK_NOT_RECOVERED Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_SDA_STUCK_NOT_RECOVERED_BitAddressOffset 11
`define IC_STATUS_RSVD_SDA_STUCK_NOT_RECOVERED_RegisterSize 1

/* Register IC_STATUS field RSVD_IC_STATUS_1 */
/* RSVD_IC_STATUS_1 Reserved bits - Read Only */
`define IC_STATUS_RSVD_IC_STATUS_1_BitAddressOffset 12
`define IC_STATUS_RSVD_IC_STATUS_1_RegisterSize 4

/* Register IC_STATUS field RSVD_SMBUS_QUICK_CMD_BIT */
/* SMBUS_QUICK_CMD_BIT Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_SMBUS_QUICK_CMD_BIT_BitAddressOffset 16
`define IC_STATUS_RSVD_SMBUS_QUICK_CMD_BIT_RegisterSize 1

/* Register IC_STATUS field RSVD_SMBUS_SLAVE_ADDR_VALID */
/* SMBUS_SLAVE_ADDR_VALID Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_SMBUS_SLAVE_ADDR_VALID_BitAddressOffset 17
`define IC_STATUS_RSVD_SMBUS_SLAVE_ADDR_VALID_RegisterSize 1

/* Register IC_STATUS field RSVD_SMBUS_SLAVE_ADDR_RESOLVED */
/* SMBUS_SLAVE_ADDR_RESOLVED Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_SMBUS_SLAVE_ADDR_RESOLVED_BitAddressOffset 18
`define IC_STATUS_RSVD_SMBUS_SLAVE_ADDR_RESOLVED_RegisterSize 1

/* Register IC_STATUS field RSVD_SMBUS_SUSPEND_STATUS */
/* SMBUS_SUSPEND_STATUS Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_SMBUS_SUSPEND_STATUS_BitAddressOffset 19
`define IC_STATUS_RSVD_SMBUS_SUSPEND_STATUS_RegisterSize 1

/* Register IC_STATUS field RSVD_SMBUS_ALERT_STATUS */
/* SMBUS_ALERT_STATUS Register field Reserved bits - Read Only */
`define IC_STATUS_RSVD_SMBUS_ALERT_STATUS_BitAddressOffset 20
`define IC_STATUS_RSVD_SMBUS_ALERT_STATUS_RegisterSize 1

/* Register IC_STATUS field RSVD_IC_STATUS_2 */
/* IC_STATUS Reserved bits - Read Only */
`define IC_STATUS_RSVD_IC_STATUS_2_BitAddressOffset 21
`define IC_STATUS_RSVD_IC_STATUS_2_RegisterSize 11

/* End of Register Definition for IC_STATUS */

/* Register IC_TXFLR */
/* I2C Transmit FIFO Level Register
This register contains the number of valid data entries in the transmit FIFO buffer. It is cleared whenever:
 - The I2C is disabled
 - There is a transmit abort - that is, TX_ABRT bit is set in the IC_RAW_INTR_STAT register
 - The slave bulk transmit mode is aborted
The register increments whenever data is placed into the transmit FIFO and decrements when data is taken from the transmit FIFO. */
`define IC_TXFLR (`DW_apb_i2c_addr_block1_BaseAddress + 'h74)
`define IC_TXFLR_RegisterSize 32
`define IC_TXFLR_RegisterResetValue 32'h0
`define IC_TXFLR_RegisterResetMask 32'hffffffff

/* Register Field information for IC_TXFLR */

/* Register IC_TXFLR field TXFLR */
/* Transmit FIFO Level.
Contains the number of valid data entries in the
transmit FIFO.
 */
`define IC_TXFLR_TXFLR_BitAddressOffset 0
`define IC_TXFLR_TXFLR_RegisterSize 4

/* Register IC_TXFLR field RSVD_TXFLR */
/* TXFLR Register field Reserved bits - Read Only */
`define IC_TXFLR_RSVD_TXFLR_BitAddressOffset 4
`define IC_TXFLR_RSVD_TXFLR_RegisterSize 28

/* End of Register Definition for IC_TXFLR */

/* Register IC_RXFLR */
/* I2C Receive FIFO Level Register
This register contains the number of valid data entries in the receive FIFO buffer. It is cleared whenever:
 - The I2C is disabled
 - Whenever there is a transmit abort caused by any of the events tracked in IC_TX_ABRT_SOURCE
The register increments whenever data is placed into the receive FIFO and decrements when data is taken from the receive FIFO. */
`define IC_RXFLR (`DW_apb_i2c_addr_block1_BaseAddress + 'h78)
`define IC_RXFLR_RegisterSize 32
`define IC_RXFLR_RegisterResetValue 32'h0
`define IC_RXFLR_RegisterResetMask 32'hffffffff

/* Register Field information for IC_RXFLR */

/* Register IC_RXFLR field RXFLR */
/* Receive FIFO Level.
Contains the number of valid data entries in the
receive FIFO.
 */
`define IC_RXFLR_RXFLR_BitAddressOffset 0
`define IC_RXFLR_RXFLR_RegisterSize 4

/* Register IC_RXFLR field RSVD_RXFLR */
/* RXFLR Reserved bits - Read Only */
`define IC_RXFLR_RSVD_RXFLR_BitAddressOffset 4
`define IC_RXFLR_RSVD_RXFLR_RegisterSize 28

/* End of Register Definition for IC_RXFLR */

/* Register IC_SDA_HOLD */
/* I2C SDA Hold Time Length Register

The bits [15:0] of this register are used to control the hold time of SDA during
transmit in both slave and master mode (after SCL goes from HIGH to LOW).

The bits [23:16] of this register are used to extend the SDA transition (if any) 
whenever SCL is HIGH in the receiver in either master or slave mode.

Writes to this register succeed only when IC_ENABLE[0]=0.

The values in this register are in units of ic_clk period. The value programmed 
in IC_SDA_TX_HOLD must be greater than the minimum hold time in each mode one 
cycle in master mode, seven cycles in slave mode for the value to be implemented.

The programmed SDA hold time during transmit (IC_SDA_TX_HOLD) cannot exceed at any 
time the duration of the low part of scl. Therefore the programmed value cannot be 
larger than N_SCL_LOW-2, where N_SCL_LOW is the duration of the low part of the scl 
period measured in ic_clk cycles.

 */
`define IC_SDA_HOLD (`DW_apb_i2c_addr_block1_BaseAddress + 'h7c)
`define IC_SDA_HOLD_RegisterSize 32
`define IC_SDA_HOLD_RegisterResetValue 32'h1
`define IC_SDA_HOLD_RegisterResetMask 32'hffffffff

/* Register Field information for IC_SDA_HOLD */

/* Register IC_SDA_HOLD field IC_SDA_TX_HOLD */
/* Sets the required SDA hold time 
in units of ic_clk period, when DW_apb_i2c acts as a transmitter.
 */
`define IC_SDA_HOLD_IC_SDA_TX_HOLD_BitAddressOffset 0
`define IC_SDA_HOLD_IC_SDA_TX_HOLD_RegisterSize 16

/* Register IC_SDA_HOLD field IC_SDA_RX_HOLD */
/* Sets the required SDA hold time 
in units of ic_clk period, when DW_apb_i2c acts as a receiver.
 */
`define IC_SDA_HOLD_IC_SDA_RX_HOLD_BitAddressOffset 16
`define IC_SDA_HOLD_IC_SDA_RX_HOLD_RegisterSize 8

/* Register IC_SDA_HOLD field RSVD_IC_SDA_HOLD */
/* IC_SDA_HOLD Reserved bits - Read Only */
`define IC_SDA_HOLD_RSVD_IC_SDA_HOLD_BitAddressOffset 24
`define IC_SDA_HOLD_RSVD_IC_SDA_HOLD_RegisterSize 8

/* End of Register Definition for IC_SDA_HOLD */

/* Register IC_TX_ABRT_SOURCE */
/* I2C Transmit Abort Source Register

This register has 32 bits that indicate the source
of the TX_ABRT bit. Except for Bit 9, this register is
cleared whenever the IC_CLR_TX_ABRT register or the
IC_CLR_INTR register is read. To clear Bit 9, the source
of the ABRT_SBYTE_NORSTRT must be fixed first; RESTART must
be enabled (IC_CON[5]=1), the SPECIAL bit must be cleared
(IC_TAR[11]), or the GC_OR_START bit must be cleared (IC_TAR[10]).

Once the source of the ABRT_SBYTE_NORSTRT is fixed, then this
bit can be cleared in the same manner as other bits in this
register. If the source of the ABRT_SBYTE_NORSTRT is not fixed
before attempting to clear this bit, Bit 9 clears for one cycle
and is then re-asserted. */
`define IC_TX_ABRT_SOURCE (`DW_apb_i2c_addr_block1_BaseAddress + 'h80)
`define IC_TX_ABRT_SOURCE_RegisterSize 32
`define IC_TX_ABRT_SOURCE_RegisterResetValue 32'h0
`define IC_TX_ABRT_SOURCE_RegisterResetMask 32'hffffffff

/* Register Field information for IC_TX_ABRT_SOURCE */

/* Register IC_TX_ABRT_SOURCE field ABRT_7B_ADDR_NOACK */
/* This field indicates that the Master is in 7-bit addressing mode and the address sent was not acknowledged by any slave.

Role of DW_apb_i2c:  Master-Transmitter or Master-Receiver */
`define IC_TX_ABRT_SOURCE_ABRT_7B_ADDR_NOACK_BitAddressOffset 0
`define IC_TX_ABRT_SOURCE_ABRT_7B_ADDR_NOACK_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_10ADDR1_NOACK */
/* This field indicates that the Master is in 10-bit address mode and the first 10-bit address byte was not acknowledged by any slave.

Reset value: 0x0

Role of DW_apb_i2c:  Master-Transmitter or Master-Receiver */
`define IC_TX_ABRT_SOURCE_ABRT_10ADDR1_NOACK_BitAddressOffset 1
`define IC_TX_ABRT_SOURCE_ABRT_10ADDR1_NOACK_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_10ADDR2_NOACK */
/* This field indicates that the Master is in 10-bit address mode and that the second address byte of the 10-bit address was not acknowledged by any slave.

Role of DW_apb_i2c:  Master-Transmitter or Master-Receiver */
`define IC_TX_ABRT_SOURCE_ABRT_10ADDR2_NOACK_BitAddressOffset 2
`define IC_TX_ABRT_SOURCE_ABRT_10ADDR2_NOACK_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_TXDATA_NOACK */
/* This field indicates the master-mode only bit. When the master receives an acknowledgement for the address, but when it sends data byte(s) following the address, it did not receive an acknowledge from the remote slave(s).


Role of DW_apb_i2c:  Master-Transmitter */
`define IC_TX_ABRT_SOURCE_ABRT_TXDATA_NOACK_BitAddressOffset 3
`define IC_TX_ABRT_SOURCE_ABRT_TXDATA_NOACK_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_GCALL_NOACK */
/* This field indicates that DW_apb_i2c in master mode has sent a General Call and no slave on the bus acknowledged the General Call.


Role of DW_apb_i2c:  Master-Transmitter */
`define IC_TX_ABRT_SOURCE_ABRT_GCALL_NOACK_BitAddressOffset 4
`define IC_TX_ABRT_SOURCE_ABRT_GCALL_NOACK_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_GCALL_READ */
/* This field indicates that DW_apb_i2c in the master mode has sent a General Call but the user programmed the byte following the General Call to be a read from the bus (IC_DATA_CMD[9] is set to 1).


Role of DW_apb_i2c:  Master-Transmitter */
`define IC_TX_ABRT_SOURCE_ABRT_GCALL_READ_BitAddressOffset 5
`define IC_TX_ABRT_SOURCE_ABRT_GCALL_READ_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_HS_ACKDET */
/* This field indicates that the Master is in High Speed mode and the High Speed Master code was acknowledged (wrong behavior).


Role of DW_apb_i2c:  Master */
`define IC_TX_ABRT_SOURCE_ABRT_HS_ACKDET_BitAddressOffset 6
`define IC_TX_ABRT_SOURCE_ABRT_HS_ACKDET_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_SBYTE_ACKDET */
/* This field indicates that the Master has sent a START Byte and the START Byte was acknowledged (wrong behavior).

Role of DW_apb_i2c:  Master */
`define IC_TX_ABRT_SOURCE_ABRT_SBYTE_ACKDET_BitAddressOffset 7
`define IC_TX_ABRT_SOURCE_ABRT_SBYTE_ACKDET_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_HS_NORSTRT */
/* This field indicates that the restart is disabled (IC_RESTART_EN bit (IC_CON[5]) =0) and the user is trying to use the master to transfer data in High Speed mode.

Role of DW_apb_i2c:  Master-Transmitter or Master-Receiver */
`define IC_TX_ABRT_SOURCE_ABRT_HS_NORSTRT_BitAddressOffset 8
`define IC_TX_ABRT_SOURCE_ABRT_HS_NORSTRT_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_SBYTE_NORSTRT */
/* To clear Bit 9, the source of the
ABRT_SBYTE_NORSTRT must be fixed first;
restart must be enabled (IC_CON[5]=1),
the SPECIAL bit must be cleared (IC_TAR[11]),
or the GC_OR_START bit must be cleared
(IC_TAR[10]). Once the source of the
ABRT_SBYTE_NORSTRT is fixed,
then this bit can be cleared in the same
manner as other bits in this register. If
the source of the ABRT_SBYTE_NORSTRT is not fixed
before attempting to clear this bit, bit 9
clears for one cycle and then gets reasserted. When this field is set to 1, the restart is disabled (IC_RESTART_EN bit (IC_CON[5]) =0) and the user is trying to send a START Byte.

Role of DW_apb_i2c:  Master */
`define IC_TX_ABRT_SOURCE_ABRT_SBYTE_NORSTRT_BitAddressOffset 9
`define IC_TX_ABRT_SOURCE_ABRT_SBYTE_NORSTRT_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_10B_RD_NORSTRT */
/* This field indicates that the restart is disabled (IC_RESTART_EN bit (IC_CON[5]) =0) and the master sends a read command in 10-bit addressing mode.

Role of DW_apb_i2c:  Master-Receiver */
`define IC_TX_ABRT_SOURCE_ABRT_10B_RD_NORSTRT_BitAddressOffset 10
`define IC_TX_ABRT_SOURCE_ABRT_10B_RD_NORSTRT_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_MASTER_DIS */
/* This field indicates that the User tries to initiate a Master operation with the Master mode disabled.

Role of DW_apb_i2c:  Master-Transmitter or Master-Receiver */
`define IC_TX_ABRT_SOURCE_ABRT_MASTER_DIS_BitAddressOffset 11
`define IC_TX_ABRT_SOURCE_ABRT_MASTER_DIS_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ARB_LOST */
/* This field specifies that the Master has lost arbitration, or if IC_TX_ABRT_SOURCE[14] is also set, then the slave transmitter has lost arbitration.

Role of DW_apb_i2c:  Master-Transmitter or Slave-Transmitter */
`define IC_TX_ABRT_SOURCE_ARB_LOST_BitAddressOffset 12
`define IC_TX_ABRT_SOURCE_ARB_LOST_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_SLVFLUSH_TXFIFO */
/* This field specifies that the Slave has received a read command and some data exists in the TX FIFO, so the slave issues a TX_ABRT interrupt to flush old data in TX FIFO.

Role of DW_apb_i2c:  Slave-Transmitter */
`define IC_TX_ABRT_SOURCE_ABRT_SLVFLUSH_TXFIFO_BitAddressOffset 13
`define IC_TX_ABRT_SOURCE_ABRT_SLVFLUSH_TXFIFO_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_SLV_ARBLOST */
/* This field indicates that a Slave has lost the bus while transmitting data to a remote master. IC_TX_ABRT_SOURCE[12] is set at the same time.
Note:  Even though the slave never
'owns' the bus, something could go
wrong on the bus. This is a fail safe
check. For instance, during a data
transmission at the low-to-high
transition of SCL, if what is on the data
bus is not what is supposed to be
transmitted, then DW_apb_i2c no
longer own the bus.

Role of DW_apb_i2c:  Slave-Transmitter */
`define IC_TX_ABRT_SOURCE_ABRT_SLV_ARBLOST_BitAddressOffset 14
`define IC_TX_ABRT_SOURCE_ABRT_SLV_ARBLOST_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_SLVRD_INTX */
/* 1: When the processor side responds to
a slave mode request for data to be
transmitted to a remote master and user
writes a 1 in CMD (bit 8) of
IC_DATA_CMD register.

Role of DW_apb_i2c:  Slave-Transmitter */
`define IC_TX_ABRT_SOURCE_ABRT_SLVRD_INTX_BitAddressOffset 15
`define IC_TX_ABRT_SOURCE_ABRT_SLVRD_INTX_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field ABRT_USER_ABRT */
/* This is a master-mode-only bit. Master has 
detected the transfer abort (IC_ENABLE[1])

Role of DW_apb_i2c:  Master-Transmitter */
`define IC_TX_ABRT_SOURCE_ABRT_USER_ABRT_BitAddressOffset 16
`define IC_TX_ABRT_SOURCE_ABRT_USER_ABRT_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field RSVD_ABRT_SDA_STUCK_AT_LOW */
/* ABRT_SDA_STUCK_AT_LOW Register field Reserved bits - Read Only */
`define IC_TX_ABRT_SOURCE_RSVD_ABRT_SDA_STUCK_AT_LOW_BitAddressOffset 17
`define IC_TX_ABRT_SOURCE_RSVD_ABRT_SDA_STUCK_AT_LOW_RegisterSize 1

/* Register IC_TX_ABRT_SOURCE field RSVD_ABRT_DEVICE_WRITE */
/* ABRT_DEVICE_WRITE Register field Reserved bits - Read Only */
`define IC_TX_ABRT_SOURCE_RSVD_ABRT_DEVICE_WRITE_BitAddressOffset 18
`define IC_TX_ABRT_SOURCE_RSVD_ABRT_DEVICE_WRITE_RegisterSize 3

/* Register IC_TX_ABRT_SOURCE field RSVD_IC_TX_ABRT_SOURCE */
/* IC_TX_ABRT_SOURCE Reserved bits - Read Only */
`define IC_TX_ABRT_SOURCE_RSVD_IC_TX_ABRT_SOURCE_BitAddressOffset 21
`define IC_TX_ABRT_SOURCE_RSVD_IC_TX_ABRT_SOURCE_RegisterSize 2

/* Register IC_TX_ABRT_SOURCE field TX_FLUSH_CNT */
/* This field indicates the 
number of Tx FIFO Data Commands which are flushed due to TX_ABRT interrupt. 
It is cleared whenever I2C is disabled.

Role of DW_apb_i2c:  Master-Transmitter or Slave-Transmitter */
`define IC_TX_ABRT_SOURCE_TX_FLUSH_CNT_BitAddressOffset 23
`define IC_TX_ABRT_SOURCE_TX_FLUSH_CNT_RegisterSize 9

/* End of Register Definition for IC_TX_ABRT_SOURCE */

/* Register IC_SDA_SETUP */
/* I2C SDA Setup Register

This register controls the amount of time delay
(in terms of number of ic_clk clock periods) introduced
in the rising edge of SCL - relative to SDA changing - when
DW_apb_i2c services a read request in a slave-transmitter operation.
The relevant I2C requirement is tSU:DAT (note 4) as detailed in the
I2C Bus Specification.
This register must be programmed with a value equal to or greater than 2. 

Writes to this register succeed only when IC_ENABLE[0] = 0.

Note: The length of setup time is calculated using [(IC_SDA_SETUP - 1) * (ic_clk_period)], so if the
user requires 10 ic_clk periods of setup time, they should program a value of 11.
The IC_SDA_SETUP register is only used by the DW_apb_i2c when operating as a slave
transmitter.
 */
`define IC_SDA_SETUP (`DW_apb_i2c_addr_block1_BaseAddress + 'h94)
`define IC_SDA_SETUP_RegisterSize 32
`define IC_SDA_SETUP_RegisterResetValue 32'h64
`define IC_SDA_SETUP_RegisterResetMask 32'hffffffff

/* Register Field information for IC_SDA_SETUP */

/* Register IC_SDA_SETUP field SDA_SETUP */
/* SDA Setup.
It is recommended that if the required delay is 1000ns,
then for an ic_clk frequency of 10 MHz, IC_SDA_SETUP
should be programmed to a value of 11. IC_SDA_SETUP must be programmed with a minimum value of 2. */
`define IC_SDA_SETUP_SDA_SETUP_BitAddressOffset 0
`define IC_SDA_SETUP_SDA_SETUP_RegisterSize 8

/* Register IC_SDA_SETUP field RSVD_IC_SDA_SETUP */
/* IC_SDA_SETUP Reserved bits - Read Only */
`define IC_SDA_SETUP_RSVD_IC_SDA_SETUP_BitAddressOffset 8
`define IC_SDA_SETUP_RSVD_IC_SDA_SETUP_RegisterSize 24

/* End of Register Definition for IC_SDA_SETUP */

/* Register IC_ACK_GENERAL_CALL */
/* I2C ACK General Call Register

The register controls whether DW_apb_i2c responds
with a ACK or NACK when it receives an I2C
General Call address.

This register is applicable only when the DW_apb_i2c is in slave mode.
 */
`define IC_ACK_GENERAL_CALL (`DW_apb_i2c_addr_block1_BaseAddress + 'h98)
`define IC_ACK_GENERAL_CALL_RegisterSize 32
`define IC_ACK_GENERAL_CALL_RegisterResetValue 32'h1
`define IC_ACK_GENERAL_CALL_RegisterResetMask 32'hffffffff

/* Register Field information for IC_ACK_GENERAL_CALL */

/* Register IC_ACK_GENERAL_CALL field ACK_GEN_CALL */
/* ACK General Call.
When set to 1, DW_apb_i2c responds with a ACK
(by asserting ic_data_oe) when it receives a General Call.
Otherwise, DW_apb_i2c responds with a NACK
(by negating ic_data_oe). */
`define IC_ACK_GENERAL_CALL_ACK_GEN_CALL_BitAddressOffset 0
`define IC_ACK_GENERAL_CALL_ACK_GEN_CALL_RegisterSize 1

/* Register IC_ACK_GENERAL_CALL field RSVD_IC_ACK_GEN_1_31 */
/* RSVD_IC_ACK_GEN_1_31 Reserved bits - Read Only */
`define IC_ACK_GENERAL_CALL_RSVD_IC_ACK_GEN_1_31_BitAddressOffset 1
`define IC_ACK_GENERAL_CALL_RSVD_IC_ACK_GEN_1_31_RegisterSize 31

/* End of Register Definition for IC_ACK_GENERAL_CALL */

/* Register IC_ENABLE_STATUS */
/* I2C Enable Status Register

The register is used to report the DW_apb_i2c hardware
status when the IC_ENABLE[0] register is set from 1 to 0;
that is, when DW_apb_i2c is disabled.

If IC_ENABLE[0] has been set to 1, bits 2:1 are forced to 0,
and bit 0 is forced to 1.

If IC_ENABLE[0] has been set to 0, bits 2:1 is only be valid
as soon as bit 0 is read as '0'.

Note: 
When IC_ENABLE[0] has been set to 0, a delay occurs for bit 0 to be read as 0 because
disabling the DW_apb_i2c depends on I2C bus activities.
 */
`define IC_ENABLE_STATUS (`DW_apb_i2c_addr_block1_BaseAddress + 'h9c)
`define IC_ENABLE_STATUS_RegisterSize 32
`define IC_ENABLE_STATUS_RegisterResetValue 32'h0
`define IC_ENABLE_STATUS_RegisterResetMask 32'hffffffff

/* Register Field information for IC_ENABLE_STATUS */

/* Register IC_ENABLE_STATUS field IC_EN */
/* ic_en Status.
This bit always reflects the value driven
on the output port ic_en.
 - When read as 1, DW_apb_i2c is deemed to be in an enabled state.
 - When read as 0, DW_apb_i2c is deemed completely inactive.
Note:  The CPU can safely read this bit anytime.
When this bit is read as 0, the CPU can safely
read SLV_RX_DATA_LOST (bit 2) and
SLV_DISABLED_WHILE_BUSY (bit 1).
 */
`define IC_ENABLE_STATUS_IC_EN_BitAddressOffset 0
`define IC_ENABLE_STATUS_IC_EN_RegisterSize 1

/* Register IC_ENABLE_STATUS field SLV_DISABLED_WHILE_BUSY */
/* Slave Disabled While Busy (Transmit, Receive).
This bit indicates if a potential or active Slave
operation has been aborted due to the setting bit 0 of
the IC_ENABLE register from 1 to 0. This bit is set
when the CPU writes a 0 to the IC_ENABLE register
while:
 
(a) DW_apb_i2c is receiving the address byte
of the Slave-Transmitter operation from a remote master;

OR, 

(b) address and data bytes of the Slave-Receiver
operation from a remote master.

When read as 1, DW_apb_i2c is deemed to have forced a
NACK during any part of an I2C transfer, irrespective
of whether the I2C address matches the slave address set
in DW_apb_i2c (IC_SAR register) OR if the transfer is
completed before IC_ENABLE is set to 0 but has not
taken effect.

Note:  If the remote I2C master terminates the transfer
with a STOP condition before the DW_apb_i2c has a chance
to NACK a transfer, and IC_ENABLE[0] has been set to 0, then
this bit will also be set to 1.

When read as 0, DW_apb_i2c is deemed to have been disabled
when there is master activity, or when the I2C bus is idle.

Note:  The CPU can safely read this bit when IC_EN (bit 0)
is read as 0.
 */
`define IC_ENABLE_STATUS_SLV_DISABLED_WHILE_BUSY_BitAddressOffset 1
`define IC_ENABLE_STATUS_SLV_DISABLED_WHILE_BUSY_RegisterSize 1

/* Register IC_ENABLE_STATUS field SLV_RX_DATA_LOST */
/* Slave Received Data Lost.
This bit indicates if a Slave-Receiver operation has been
aborted with at least one data byte received from an
I2C transfer due to the setting bit 0 of IC_ENABLE from 1 to 0.
When read as 1, DW_apb_i2c is deemed to have been actively engaged
in an aborted I2C transfer (with matching address) and the
data phase of the I2C transfer has been entered, even though
a data byte has been responded with a NACK.

Note:  If the remote I2C master terminates the transfer with a
STOP condition before the DW_apb_i2c has a chance to NACK a
transfer, and IC_ENABLE[0] has been set to 0, then this bit is
also set to 1.

When read as 0, DW_apb_i2c is deemed to have been disabled without
being actively involved in the data phase of a Slave-Receiver transfer.

Note:  The CPU can safely read this bit when IC_EN (bit 0) is
read as 0.
 */
`define IC_ENABLE_STATUS_SLV_RX_DATA_LOST_BitAddressOffset 2
`define IC_ENABLE_STATUS_SLV_RX_DATA_LOST_RegisterSize 1

/* Register IC_ENABLE_STATUS field RSVD_IC_ENABLE_STATUS */
/* IC_ENABLE_STATUS Reserved bits - Read Only */
`define IC_ENABLE_STATUS_RSVD_IC_ENABLE_STATUS_BitAddressOffset 3
`define IC_ENABLE_STATUS_RSVD_IC_ENABLE_STATUS_RegisterSize 29

/* End of Register Definition for IC_ENABLE_STATUS */

/* Register IC_FS_SPKLEN */
/* I2C SS, FS or FM+  spike suppression limit

This register is used to store the duration, measured in ic_clk cycles,
of the longest spike that is filtered out by the spike suppression logic w
hen the component is operating in SS, FS or FM+ modes. 
The relevant I2C requirement is tSP (table 4) as detailed in the 
I2C Bus Specification. This register must be programmed with a minimum value of 1.
 */
`define IC_FS_SPKLEN (`DW_apb_i2c_addr_block1_BaseAddress + 'ha0)
`define IC_FS_SPKLEN_RegisterSize 32
`define IC_FS_SPKLEN_RegisterResetValue 32'h5
`define IC_FS_SPKLEN_RegisterResetMask 32'hffffffff

/* Register Field information for IC_FS_SPKLEN */

/* Register IC_FS_SPKLEN field IC_FS_SPKLEN */
/* This register must be set before any I2C bus transaction can take place to
ensure stable operation. This register sets the duration, measured in ic_clk cycles,
of the longest spike in the SCL or SDA lines that will be filtered out by the spike 
suppression logic.
This register can be written only when the I2C interface is disabled which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other times
have no effect.
The minimum valid value is 1; hardware prevents values less than this being
written, and if attempted results in 1 being set. or more information, refer to "Spike Suppression".
 */
`define IC_FS_SPKLEN_IC_FS_SPKLEN_BitAddressOffset 0
`define IC_FS_SPKLEN_IC_FS_SPKLEN_RegisterSize 8

/* Register IC_FS_SPKLEN field RSVD_IC_FS_SPKLEN */
/* IC_FS_SPKLEN Reserved bits - Read Only */
`define IC_FS_SPKLEN_RSVD_IC_FS_SPKLEN_BitAddressOffset 8
`define IC_FS_SPKLEN_RSVD_IC_FS_SPKLEN_RegisterSize 24

/* End of Register Definition for IC_FS_SPKLEN */

/* Register IC_HS_SPKLEN */
/* I2C HS spike suppression limit register

This register is used to store the duration, measured in ic_clk cycles,
of the longest spike that is filtered out by the spike suppression logic when the component is operating in HS modes. 
The relevant I2C requirement is tSP (table 6) as detailed in the 
I2C Bus Specification. This register must be programmed with a minimum value of 1 and is implemented only
if the component is configured to support HS mode; that is, if the IC_MAX_SPEED_MODE parameter is set to 3.
 */
`define IC_HS_SPKLEN (`DW_apb_i2c_addr_block1_BaseAddress + 'ha4)
`define IC_HS_SPKLEN_RegisterSize 32
`define IC_HS_SPKLEN_RegisterResetValue 32'h1
`define IC_HS_SPKLEN_RegisterResetMask 32'hffffffff

/* Register Field information for IC_HS_SPKLEN */

/* Register IC_HS_SPKLEN field IC_HS_SPKLEN */
/* This register must be set before any I2C bus transaction can take place to
ensure stable operation. This register sets the duration, measured in ic_clk cycles,
of the longest spike in the SCL or SDA lines that will be filtered out by the spike 
suppression logic; for more information, refer to "Spike Suppression"

This register can be written only when the I2C interface is disabled which
corresponds to the IC_ENABLE[0] register being set to 0. Writes at other times
have no effect.

The minimum valid value is 1; hardware prevents values less than this being
written, and if attempted results in 1 being set. 
 */
`define IC_HS_SPKLEN_IC_HS_SPKLEN_BitAddressOffset 0
`define IC_HS_SPKLEN_IC_HS_SPKLEN_RegisterSize 8

/* Register IC_HS_SPKLEN field RSVD_IC_HS_SPKLEN */
/* IC_HS_SPKLEN Reserved bits - Read Only */
`define IC_HS_SPKLEN_RSVD_IC_HS_SPKLEN_BitAddressOffset 8
`define IC_HS_SPKLEN_RSVD_IC_HS_SPKLEN_RegisterSize 24

/* End of Register Definition for IC_HS_SPKLEN */

/* Register REG_TIMEOUT_RST */
/* Name: Register timeout counter reset register
Size: REG_TIMEOUT_WIDTH bits
Address: 0xF0
Read/Write Access: Read/Write
This register keeps the timeout value of register timer counter. The reset value of the register is REG_TIMEOUT_VALUE. The default reset value can be further modified if HC_REG_TIMEOUT_VALUE = 0. The
final programmed value (or the default reset value if not programmed) determines from what value the register timeout counter starts counting down. A zero on this counter will break the waited
transaction with PSLVERR as high. */
`define REG_TIMEOUT_RST (`DW_apb_i2c_addr_block1_BaseAddress + 'hf0)
`define REG_TIMEOUT_RST_RegisterSize 32
`define REG_TIMEOUT_RST_RegisterResetValue 32'h8
`define REG_TIMEOUT_RST_RegisterResetMask 32'hffffffff

/* Register Field information for REG_TIMEOUT_RST */

/* Register REG_TIMEOUT_RST field REG_TIMEOUT_RST_rw */
/* This field holds reset value of REG_TIMEOUT counter register.
 */
`define REG_TIMEOUT_RST_REG_TIMEOUT_RST_rw_BitAddressOffset 0
`define REG_TIMEOUT_RST_REG_TIMEOUT_RST_rw_RegisterSize 4

/* Register REG_TIMEOUT_RST field RSVD_REG_TIMEOUT_RST */
/* Reserved bits - Read Only */
`define REG_TIMEOUT_RST_RSVD_REG_TIMEOUT_RST_BitAddressOffset 4
`define REG_TIMEOUT_RST_RSVD_REG_TIMEOUT_RST_RegisterSize 28

/* End of Register Definition for REG_TIMEOUT_RST */

/* Register IC_COMP_PARAM_1 */
/* Component Parameter Register 1

Note
This is a constant read-only register that contains
encoded information about the component's parameter settings.
The reset value depends on coreConsultant parameter(s). */
`define IC_COMP_PARAM_1 (`DW_apb_i2c_addr_block1_BaseAddress + 'hf4)
`define IC_COMP_PARAM_1_RegisterSize 32
`define IC_COMP_PARAM_1_RegisterResetValue 32'h7078e
`define IC_COMP_PARAM_1_RegisterResetMask 32'hffffffff

/* Register Field information for IC_COMP_PARAM_1 */

/* Register IC_COMP_PARAM_1 field APB_DATA_WIDTH */
/* The value of this register is
derived from the APB_DATA_WIDTH coreConsultant
parameter. */
`define IC_COMP_PARAM_1_APB_DATA_WIDTH_BitAddressOffset 0
`define IC_COMP_PARAM_1_APB_DATA_WIDTH_RegisterSize 2

/* Register IC_COMP_PARAM_1 field MAX_SPEED_MODE */
/* The value of this register is
derived from the IC_MAX_SPEED_MODE coreConsultant
parameter.
 - 0x0: Reserved
 - 0x1: Standard
 - 0x2: Fast
 - 0x3: High
 */
`define IC_COMP_PARAM_1_MAX_SPEED_MODE_BitAddressOffset 2
`define IC_COMP_PARAM_1_MAX_SPEED_MODE_RegisterSize 2

/* Register IC_COMP_PARAM_1 field HC_COUNT_VALUES */
/* The value of this register is
derived from the IC_HC_COUNT VALUES coreConsultant
parameter.
 */
`define IC_COMP_PARAM_1_HC_COUNT_VALUES_BitAddressOffset 4
`define IC_COMP_PARAM_1_HC_COUNT_VALUES_RegisterSize 1

/* Register IC_COMP_PARAM_1 field INTR_IO */
/* The value of this register is
derived from the IC_INTR_IO coreConsultant
parameter.
 */
`define IC_COMP_PARAM_1_INTR_IO_BitAddressOffset 5
`define IC_COMP_PARAM_1_INTR_IO_RegisterSize 1

/* Register IC_COMP_PARAM_1 field HAS_DMA */
/* The value of this register is
derived from the IC_HAS_DMA coreConsultant
parameter.
 */
`define IC_COMP_PARAM_1_HAS_DMA_BitAddressOffset 6
`define IC_COMP_PARAM_1_HAS_DMA_RegisterSize 1

/* Register IC_COMP_PARAM_1 field ADD_ENCODED_PARAMS */
/* The value of this register is derived
from the IC_ADD_ENCODED_PARAMS coreConsultant
parameter.
Reading 1 in this bit means that the capability
of reading these encoded parameters via software has been
included. Otherwise, the entire register is 0 regardless of
the setting of any other parameters that are encoded in the
bits.
 */
`define IC_COMP_PARAM_1_ADD_ENCODED_PARAMS_BitAddressOffset 7
`define IC_COMP_PARAM_1_ADD_ENCODED_PARAMS_RegisterSize 1

/* Register IC_COMP_PARAM_1 field RX_BUFFER_DEPTH */
/* The value of this register is
derived from the IC_RX_BUFFER_DEPTH coreConsultant
parameter.
 - 0x00: Reserved
 - 0x01: 2
 - 0x02: 3
 - ...
 - 0xFF: 256 */
`define IC_COMP_PARAM_1_RX_BUFFER_DEPTH_BitAddressOffset 8
`define IC_COMP_PARAM_1_RX_BUFFER_DEPTH_RegisterSize 8

/* Register IC_COMP_PARAM_1 field TX_BUFFER_DEPTH */
/* The value of this register is derived
from the IC_TX_BUFFER_DEPTH coreConsultant
parameter.
 - 0x00 = Reserved
 - 0x01 = 2
 - 0x02 = 3
 - ...
 - 0xFF = 256 */
`define IC_COMP_PARAM_1_TX_BUFFER_DEPTH_BitAddressOffset 16
`define IC_COMP_PARAM_1_TX_BUFFER_DEPTH_RegisterSize 8

/* Register IC_COMP_PARAM_1 field RSVD_IC_COMP_PARAM_1 */
/* IC_COMP_PARAM_1 Reserved bits - Read Only */
`define IC_COMP_PARAM_1_RSVD_IC_COMP_PARAM_1_BitAddressOffset 24
`define IC_COMP_PARAM_1_RSVD_IC_COMP_PARAM_1_RegisterSize 8

/* End of Register Definition for IC_COMP_PARAM_1 */

/* Register IC_COMP_VERSION */
/* I2C Component Version Register */
`define IC_COMP_VERSION (`DW_apb_i2c_addr_block1_BaseAddress + 'hf8)
`define IC_COMP_VERSION_RegisterSize 32
`define IC_COMP_VERSION_RegisterResetValue 32'h3230322a
`define IC_COMP_VERSION_RegisterResetMask 32'hffffffff

/* Register Field information for IC_COMP_VERSION */

/* Register IC_COMP_VERSION field IC_COMP_VERSION */
/* Specific values for this register are
described in the Releases Table in the
DW_apb_i2c Release Notes */
`define IC_COMP_VERSION_IC_COMP_VERSION_BitAddressOffset 0
`define IC_COMP_VERSION_IC_COMP_VERSION_RegisterSize 32

/* End of Register Definition for IC_COMP_VERSION */

/* Register IC_COMP_TYPE */
/* I2C Component Type Register */
`define IC_COMP_TYPE (`DW_apb_i2c_addr_block1_BaseAddress + 'hfc)
`define IC_COMP_TYPE_RegisterSize 32
`define IC_COMP_TYPE_RegisterResetValue 32'h44570140
`define IC_COMP_TYPE_RegisterResetMask 32'hffffffff

/* Register Field information for IC_COMP_TYPE */

/* Register IC_COMP_TYPE field IC_COMP_TYPE */
/* Designware Component Type number
= 0x44_57_01_40. This assigned unique
hex value is constant and is derived
from the two ASCII letters 'DW' followed
by a 16-bit unsigned number. */
`define IC_COMP_TYPE_IC_COMP_TYPE_BitAddressOffset 0
`define IC_COMP_TYPE_IC_COMP_TYPE_RegisterSize 32

/* End of Register Definition for IC_COMP_TYPE */



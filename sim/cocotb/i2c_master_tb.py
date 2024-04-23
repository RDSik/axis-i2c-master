import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles

@cocotb.test()
async def test_i2c_master(dut):
    dut_clk = dut.clk
    dut_rst = dut.arst
    dut_wr_en = dut.fifo_wr_en
    dut_rd_en = dut.fifo_rd_en
    dut_data = dut.data
    dut_addr = dut.addr

    cocotb.start_soon(Clock(dut_clk, 2, units = 'sec').start())
    # cocotb.start_soon(Clock(dut.i2c_clk, 20, units = 'sec').start())

    dut_rst.value = 1
    await Timer(2, units="sec")
    dut_rst.value = 0
    await RisingEdge(dut_clk)

    dut_rd_en.value = 0

    for i in range(4):    
        dut_wr_en.value = 1
        await Timer(2, units="sec")
        dut_data.value = random.randint(0, 255)
        dut_addr.value = random.randint(0, 127)
        dut_wr_en.value = 0
        await Timer(2, units="sec")
        
    for i in range(4):
        dut_rd_en.value = 1
        await Timer(2, units="sec")
        dut_rd_en.value = 0
        await Timer(2, units="sec")
        await Timer(40, units="sec")
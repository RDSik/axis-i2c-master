import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles

@cocotb.test()
async def test_i2c_master(dut):
    
    clk_per = 2

    cocotb.start_soon(Clock(dut.clk, clk_per, units = 'sec').start())
    # cocotb.start_soon(Clock(dut.i2c_clk, 20, units = 'sec').start())

    async def rst(dut, cycles):
        dut.arst.value = 1
        await ClockCycles(dut.clk, cycles)
        dut.arst.value = 0

    async def data_gen():
        for i in range(4):    
            dut.fifo_wr_en.value = 1
            dut.data.value = random.randint(0, 255)
            dut.addr.value = random.randint(0, 127)
            await RisingEdge(dut.clk)
            dut_wr_en.value = 0
            await RisingEdge(dut.clk)
    
    #------------------Order of test execution -------------------
    await rst(dut, 1)
    dut.fifo_wr_en.value = 0
    await data_gen()
    for i in range(4):
        dut_rd_en.value = 1
        await Timer(clk_per, units="sec")
        dut_rd_en.value = 0
        await Timer(clk_per, units="sec")
        await Timer(40, units="sec")
    
    

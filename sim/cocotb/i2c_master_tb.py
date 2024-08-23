import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
from cocotb.utils import get_sim_time

@cocotb.test()
async def test_i2c_master(dut):
    
    clk_per    = 2
    fifo_depth = 4

    cocotb.start_soon(Clock(dut.clk, clk_per, units = 'sec').start())
    # cocotb.start_soon(Clock(dut.i2c_clk, 20, units = 'sec').start())

    async def reset(cycles):
        dut.arst.value = 1
        await ClockCycles(dut.clk, cycles)
        dut.arst.value = 0

    async def write(n):
        for i in range(n):
            dut.fifo_wr_en.value = 1
            dut.data.value = random.randint(0, 255)
            dut.addr.value = random.randint(0, 127)
            await RisingEdge(dut.clk)
            dut.fifo_wr_en.value = 0
            await RisingEdge(dut.clk)
        print(f'Write ended at {get_sim_time('sec')} sec.')

    async def read(n):
        for i in range(n):
            dut.fifo_rd_en.value = 1
            await Timer(clk_per, units="sec")
            dut.fifo_rd_en.value = 0
            await Timer(clk_per, units="sec")
            await Timer(clk_per*20, units="sec")
        print(f'Read ended at {get_sim_time('sec')} sec.')
    
    #------------------Order of test execution -------------------
    dut.fifo_wr_en.value = 0
    dut.fifo_rd_en.value = 0
    await reset(1)
    await write(fifo_depth)
    await read(fifo_depth)

import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
from cocotb.utils import get_sim_time

clk_per    = 2
fifo_depth = 4

async def reset(dut, cycles):
    dut.arst.value = 1
    await ClockCycles(dut.clk, cycles)
    dut.arst.value = 0

async def write(dut, n):
    for i in range(n):
        dut.fifo_wr_en.value = 1
        dut.data.value = random.randint(0, 255)
        dut.addr.value = random.randint(0, 127)
        await RisingEdge(dut.clk)
        dut.fifo_wr_en.value = 0
        await RisingEdge(dut.clk)
    print(f'Write ended at {get_sim_time('ns')} ns.')

async def read(dut, n):
    for i in range(n):
        dut.fifo_rd_en.value = 1
        await Timer(clk_per, units="sec")
        dut.fifo_rd_en.value = 0
        await Timer(clk_per, units="sec")
        await Timer(clk_per*20, units="sec")
    print(f'Read ended at {get_sim_time('ns')} ns.')

async def init(dut, n):
    
    cocotb.start_soon(Clock(dut.clk, clk_per, units = 'sec').start())
    # cocotb.start_soon(Clock(dut.i2c_clk, 20, units = 'sec').start(
    
    dut.fifo_wr_en.value = 0
    dut.fifo_rd_en.value = 0
    await reset(dut, clk_per)
    assert dut.fifo_empty.value == 1, f'Fifo is not empty at {get_sim_time('ns')} ns.'
    await write(dut, n)
    assert dut.fifo_full.value == 1, f'Fifo is not full at {get_sim_time('ns')} ns.'
    await read(dut, n)

@cocotb.test()
async def test_i2c_master(dut):
    
    #------------------Order of test execution -------------------
    await init(dut, fifo_depth)

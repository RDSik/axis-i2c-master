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

async def write(dut):
    dut.fifo_wr_en.value = 1
    dut.data.value = random.randint(0, 255)
    dut.addr.value = random.randint(0, 127)
    await Timer(clk_per, units="ns")
    dut.fifo_wr_en.value = 0

async def read(dut):
    dut.fifo_rd_en.value = 1
    await Timer(clk_per, units="ns")
    dut.fifo_rd_en.value = 0

async def init(dut, n):

    cocotb.start_soon(Clock(dut.clk, clk_per, units = 'ns').start())
    # cocotb.start_soon(Clock(dut.i2c_clk, 20, units = 'sec').start())
    
    dut.fifo_wr_en.value = 0
    dut.fifo_rd_en.value = 0
    await reset(dut, clk_per)
    assert dut.fifo_empty.value == 1, f'Error fifo is not empty at {get_sim_time('ns')} ns.'
    for i in range(n):
        await Timer(clk_per, units="ns")
        await write(dut)
    assert dut.fifo_full.value == 1, f'Error fifo is not full at {get_sim_time('ns')} ns.'
    for i in range(n):
        await Timer(clk_per, units="ns")
        await read(dut)
    assert dut.fifo_empty.value == 1, f'Error fifo is not empty at {get_sim_time('ns')} ns.'

@cocotb.test()
async def test_i2c_master(dut):
    
    #------------------Order of test execution -------------------
    await init(dut, fifo_depth)

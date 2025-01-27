import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
from cocotb.utils import get_sim_time

clk_per = 2

class Test:
    def __init__(self, dut):
        self.dut = dut
        dut.arst.setimmediatevalue(0)
        dut.i2c_sda.setimmediatevalue(0)
        dut.i2c_scl.setimmediatevalue(0)
        cocotb.start_soon(Clock(self.dut.clk, clk_per, units = 'ns').start())
        
        async def init(self):
            await self.reset(clk_per)

        async def reset(self, cycles):
            self.dut.arst.value = 1
            await ClockCycles(self.dut.clk_i, cycles)
            self.dut.arst.value = 0

@cocotb.test()
async def test(dut):
    
    #------------------Order of test execution -------------------
    tb = Test(dut)
    await tb.init()

import os
import shutil
from pathlib import Path

import cocotb
from cocotb.runner import get_runner

def test_runner():
    src = Path("../../hdl/")
    
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    
    build_dir = Path('sim_build_i2c_master')
    build_dir.mkdir(exist_ok=True)

    # xilinx_simlibs_path = Path(r'modelsim')

    # shutil.copyfile(xilinx_simlibs_path / 'modelsim.ini', build_dir / 'modelsim.ini')

    verilog_sources = [
        src / "i2c_master.v",
        src / "i2c_fsm.v",
        src / "sync_fifo.v",
    ]
    hdl_toplevel = 'i2c_master' # HDL module name
    test_module = 'i2c_master_tb' # Python module name

    runner = get_runner(sim)
    
    runner.build(
        verilog_sources=verilog_sources,
        hdl_toplevel=hdl_toplevel,
        build_dir=build_dir,
        always=True, # Always rebuild project
    )

    runner.test(
        hdl_toplevel=hdl_toplevel,
        test_module=test_module,
        waves=True,
        gui=True,
    )

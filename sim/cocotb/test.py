import os
import random
import shutil
from pathlib import Path

import cocotb
from cocotb.runner import get_runner

def test_runner():
    src = Path("../../src")
    
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    
    build_dir = Path('sim_build_i2c_master')
    build_dir.mkdir(exist_ok=True)

    # xilinx_simlibs_path = Path(r'xilinx-simulation-libraries')

    # shutil.copyfile(xilinx_simlibs_path / 'modelsim.ini', build_dir / 'modelsim.ini')

    verilog_sources = []
    
    def files(path):
        sources = []
        for (dirpath, dirnames, filenames) in os.walk(path):
            for file in filenames:
                if file != 'Manifest.py':
                    sources.append(dirpath.replace("\\", '/') +'/' + file)
            return sources

    verilog_sources.extend(files(src))
    
    hdl_toplevel = 'axis_i2c_top' # HDL module name
    test_module = 'axis_i2c_top_tb' # Python module name
    # pre_cmd = ['do ../../modelsim/wave.do'] # Macro file
    # seed = random.randint(0, 255)

    runner = get_runner(sim)
    
    runner.build(
        verilog_sources=verilog_sources,
        hdl_toplevel=hdl_toplevel,
        build_dir=build_dir,
        always=True, # Always rebuild project
    )

    runner.test(
        hdl_toplevel=hdl_toplevel,
        # hdl_toplevel_library = 'axis_data_fifo',
        test_module=test_module,
        waves=True,
        gui=True,
        # pre_cmd=pre_cmd,
        # seed=seed,
    )

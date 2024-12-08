import os
import random
import shutil
from pathlib import Path

import cocotb
from cocotb.runner import get_runner

def test_runner():
    src = Path("../../src")
    
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "questa")
    
    build_dir = Path('sim_build_axis_i2c_top')
    build_dir.mkdir(exist_ok=True)

    xilinx_simlibs_path = Path(r'../../../../sim_libs')

    shutil.copyfile(src / 'axis_data.mem', build_dir / 'axis_data.mem')
    shutil.copyfile(xilinx_simlibs_path / 'modelsim.ini', build_dir / 'modelsim.ini')

    verilog_sources = []
    
    def files(path):
        sources = []
        for child in path.iterdir():
            if child.is_file() and str(child).endswith('.sv'):
                sources.append(child)
        return sources

    verilog_sources.extend(files(src))
    
    hdl_toplevel = 'axis_i2c_top' # HDL module name
    test_module = 'axis_i2c_top_tb' # Python module name
    pre_cmd = ['do ../wave.do'] # Macro file
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
        hdl_toplevel_library = 'axis_data_fifo_v2_0_1',
        test_module=test_module,
        waves=True,
        gui=True,
        pre_cmd=pre_cmd,
        # seed=seed,
    )

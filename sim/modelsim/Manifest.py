import shutil
from pathlib import Path

action = "simulation"
sim_tool = "modelsim"
sim_top = "axis_i2c_top_tb"

sim_post_cmd = "vsim -do wave.do -i axis_i2c_top_tb"

modules = {
    "local" : [ 
        "../../src/tb/",
    ],
}

mem_file_path = Path("../../src")
ini_file_path = Path("../cocotb")

shutil.copyfile(mem_file_path / 'axis_data.mem', 'axis_data.mem')
shutil.copyfile(ini_file_path / 'modelsim.ini', 'modelsim.ini')
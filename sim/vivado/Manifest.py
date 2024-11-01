import shutil
from pathlib import Path

action = "simulation"
sim_tool = "vivado_sim"
sim_top = "axis_i2c_top_tb"

sim_post_cmd = "xsim %s -gui" % sim_top

modules = {
    "local" : [ 
        "../../src/tb/",
    ],
}

mem_file_path = Path("../../src")

shutil.copyfile(mem_file_path / 'axis_data.mem', 'axis_data.mem')
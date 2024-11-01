action = "simulation"
sim_tool = "modelsim"
sim_top = "axis_i2c_top_tb"

sim_post_cmd = "vsim -do wave.do -i axis_i2c_top_tb"

modules = {
    "local" : [ 
        "../../src/tb/",
    ],
}
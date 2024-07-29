action = "simulation"
sim_tool = "modelsim"
sim_top = "i2c_master_tb"

sim_post_cmd = "vsim -do wave.do -i i2c_master_tb"

modules = {
    "local" : [ 
        "../../src/tb/",
    ],
}
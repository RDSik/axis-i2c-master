action = "simulation"
sim_tool = "modelsim"
sim_top = "i2c_master_tb"

sim_post_cmd = "vsim -do vsim.do -i i2c_master_tb"

modules = {
    "local" : [ 
        "../../hdl/tb/",
    ],
}
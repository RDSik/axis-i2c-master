action = "simulation"
sim_tool = "iverilog"
sim_top = "i2c_master_tb"

sim_post_cmd = "vvp i2c_master_tb.vvp; gtkwave i2c_master_tb.vcd"

modules = {
    "local" : [ 
        "../../src/tb/",
    ],
}

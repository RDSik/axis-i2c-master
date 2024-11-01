action = "simulation"
sim_tool = "vivado_sim"
sim_top = "axis_i2c_top_tb"

sim_post_cmd = "xsim %s -gui" % sim_top

modules = {
    "local" : [ 
        "../../src/tb/",
    ],
}
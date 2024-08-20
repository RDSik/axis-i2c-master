target = "altera"
action = "synthesis"

syn_family  = "Cyclone 10 GX"
syn_device  = "10cx220Y"
syn_grade   = "I5G"
syn_package = "F780"

syn_top     = "i2c_master"
syn_project = "i2c_master"

syn_tool = "quartus"

quartus_preflow = "quartus.tcl"

files = [
    "quartus.tcl",
    "i2c_master.sdc",
]

modules = {
    "local" : [
        "../../",
    ]
}

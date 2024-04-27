target = "xilinx"

action = "synthesis"

syn_device = "xc7z020clg484"
syn_grade = "-1"
syn_package = ""
syn_top = "i2c_master"
syn_project = "i2c_master"
syn_tool = "vivado"

syn_post_project_cmd = "vivado -mode tcl -source add_ip.tcl"

files = [
    "i2c_master.xdc",
]

modules = {
    "local" : [
        "../../",
    ],
}
target = "xilinx"
action = "synthesis"

syn_device = "xc7z020clg484"
syn_grade = "-1"
syn_package = ""

syn_top = "axis_i2c_top"
syn_project = "axis_i2c_slave"

syn_tool = "vivado"

syn_post_project_cmd = "vivado -mode tcl -source add_files.tcl"

files = [
    "axis_i2c_top.xdc",
]

modules = {
    "local" : [
        "../",
    ],
}

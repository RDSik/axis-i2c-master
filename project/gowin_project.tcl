create_project -name axis_i2c_top -dir project -pn GW2A-LV18PG256C8/I7 -device_version C -force
add_file ../../src/axis_if.sv
add_file ../../src/axis_i2c_top.sv
add_file ../../src/axis_i2c_master.sv
add_file ../../src/axis_data_gen.sv
add_file ../../src/clk_div.sv
add_file ../../src/config.mem
add_file ../axis_i2c_top.sdc
add_file ../axis_i2c_top.cst
set_option -top_module axis_i2c_top
set_option -verilog_std sysv2017
run all
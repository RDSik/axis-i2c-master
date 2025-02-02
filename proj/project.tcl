set part     "xc7z020clg484-1"
set top      "axis_i2c_top"
set language "Verilog"

set proj_dir [file normalize "./proj"]
set src_dir  [file normalize "./src"]
set tb_dir   [file normalize "./tb"]
set ip_dir   [file normalize "./ip"]

create_project -force $top $proj_dir -part $part
set_property target_language $language [current_project]
set_property top $top [current_fileset]

read_verilog -sv $src_dir/axis_i2c_slave.sv
read_verilog -sv $src_dir/axis_i2c_top.sv
read_verilog -sv $src_dir/axis_if.sv
read_verilog -sv $src_dir/axis_i2c_pkg.svh
read_verilog -sv $src_dir/clk_div.sv

read_verilog -sv $tb_dir/axis_i2c_top_if.sv
read_verilog -sv $tb_dir/axis_i2c_top_tb.sv
read_verilog -sv $tb_dir/environment.sv

read_xdc $proj_dir/$top.xdc

read_ip $ip_dir/axis_data_fifo/axis_data_fifo.xci
generate_target all [get_files *axis_data_fifo.xci]

# read_mem

set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]

# synth_design
# opt_design
# place_design
# route_design
# write_bitstream -force "${top}.bit"

launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

exit
set part     "xc7z020clg484-1"
set syn_top  "axis_i2c_top"
set sim_top  "axis_i2c_top_tb"
set language "Verilog"

set project_dir [file normalize "project"]
set rtl_dir     [file normalize "rtl"]
set tb_dir      [file normalize "tb"]
set ip_dir      [file normalize "ip"]

create_project -force $top $project_dir -part $part

set_property target_language $language [current_project]
set_property top $syn_top [current_fileset]
set_property top $sim_top [get_filesets sim1]

add_files -norecurse $rtl_dir/axis_i2c_master.sv
add_files -norecurse $rtl_dir/axis_data_gen.sv
add_files -norecurse $rtl_dir/axis_i2c_top.sv
add_files -norecurse $rtl_dir/axis_if.sv
add_files -norecurse $rtl_dir/clk_div.sv
add_files -norecurse $rtl_dir/config.mem

add_files -norecurse $tb_dir/axis_i2c_top_if.sv
add_files -norecurse $tb_dir/axis_i2c_top_tb.sv
add_files -norecurse $tb_dir/environment.sv

add_files -fileset constrs_1 -norecurse $project_dir/$top.xdc

add_files -norecurse $ip_dir/axis_data_fifo/axis_data_fifo.xci
export_ip_user_files -of_objects [get_files *axis_data_fifo.xci] -force -quiet

# read verilog -sv
# read_xdc
# read_mem
# read_ip $ip_dir/axis_data_fifo/axis_data_fifo.xci
# generate_target all [get_files *axis_data_fifo.xci]

# synth_design
# opt_design
# place_design
# route_design
# write_bitstream -force "${top}.bit"

set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]

launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

exit
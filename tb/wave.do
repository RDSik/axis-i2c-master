vlib work
vmap work

vlog tb/axis_i2c_top_tb.sv
vlog tb/axis_i2c_top_if.sv
vlog tb/environment.sv
vlog src/axis_if.sv
vlog src/axis_i2c_top.sv
vlog src/axis_i2c_master.sv
vlog src/axis_data_gen.sv
vlog src/clk_div.sv

vsim -voptargs="+acc" axis_i2c_top_tb
add log -r /*

add wave -expand -group I2C     /axis_i2c_top_tb/dut/i_axis_i2c_master/*
add wave -expand -group M_AXIS  /axis_i2c_top_tb/dut/m_axis/*
add wave -expand -group S_AXIS  /axis_i2c_top_tb/dut/s_axis/*
add wave -expand -group CLK_DIV /axis_i2c_top_tb/dut/i_clk_div/*

run -all
wave zoom full
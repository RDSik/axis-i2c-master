vlib work
vmap work

vlog tb/axis_i2c_top_tb.sv
vlog tb/axis_i2c_top_if.sv
vlog tb/environment.sv
vlog src/axis_if.sv
vlog src/axis_i2c_top.sv
vlog src/axis_i2c_master.sv
vlog src/axis_fifo.sv
vlog src/clk_div.sv

vsim -voptargs="+acc" axis_i2c_top_tb
add log -r /*

add wave -expand -group I2C  /axis_i2c_top_tb/dut/i_axis_i2c_master/*
add wave -expand -group AXIS /axis_i2c_top_tb/dut/axis/*
add wave -expand -group FIFO /axis_i2c_top_tb/dut/genblk1/i_axis_data_fifo/*

run -all
wave zoom full
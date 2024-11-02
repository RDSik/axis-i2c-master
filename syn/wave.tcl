add_wave {{/axis_i2c_top_tb/dut/cnt}} {{/axis_i2c_top_tb/dut/axis_mem}}
add_wave {{/axis_i2c_top_tb/dut/i2c_inst/clk}} {{/axis_i2c_top_tb/dut/i2c_inst/arstn}} {{/axis_i2c_top_tb/dut/i2c_inst/scl}} {{/axis_i2c_top_tb/dut/i2c_inst/sda}} {{/axis_i2c_top_tb/dut/i2c_inst/saved_data}} {{/axis_i2c_top_tb/dut/i2c_inst/cnt}} {{/axis_i2c_top_tb/dut/i2c_inst/scl_en}} {{/axis_i2c_top_tb/dut/i2c_inst/state}}
add_wave {{/axis_i2c_top_tb/dut/fifo_inst}}
run 1000ns
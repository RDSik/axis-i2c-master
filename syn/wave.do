onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /glbl/GSR
add wave -noupdate /glbl/GSR
add wave -noupdate /axis_i2c_top_tb/dut/clk
add wave -noupdate /axis_i2c_top_tb/dut/arstn
add wave -noupdate /axis_i2c_top_tb/dut/i2c_sda
add wave -noupdate /axis_i2c_top_tb/dut/i2c_scl
add wave -noupdate /axis_i2c_top_tb/dut/cnt
add wave -noupdate /axis_i2c_top_tb/dut/fifo_inst/s_axis_aresetn
add wave -noupdate /axis_i2c_top_tb/dut/fifo_inst/s_axis_aclk
add wave -noupdate /axis_i2c_top_tb/dut/fifo_inst/s_axis_tvalid
add wave -noupdate /axis_i2c_top_tb/dut/fifo_inst/s_axis_tready
add wave -noupdate /axis_i2c_top_tb/dut/fifo_inst/s_axis_tdata
add wave -noupdate /axis_i2c_top_tb/dut/fifo_inst/m_axis_tvalid
add wave -noupdate /axis_i2c_top_tb/dut/fifo_inst/m_axis_tready
add wave -noupdate /axis_i2c_top_tb/dut/fifo_inst/m_axis_tdata
add wave -noupdate /axis_i2c_top_tb/dut/i2c_inst/clk
add wave -noupdate /axis_i2c_top_tb/dut/i2c_inst/arstn
add wave -noupdate /axis_i2c_top_tb/dut/i2c_inst/scl
add wave -noupdate /axis_i2c_top_tb/dut/i2c_inst/sda
add wave -noupdate /axis_i2c_top_tb/dut/i2c_inst/saved_data
add wave -noupdate /axis_i2c_top_tb/dut/i2c_inst/cnt
add wave -noupdate /axis_i2c_top_tb/dut/i2c_inst/scl_en
add wave -noupdate /axis_i2c_top_tb/dut/i2c_inst/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37746133 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 272
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {32688973 ps} {33472884 ps}
run 1000 ns
wave zoom full
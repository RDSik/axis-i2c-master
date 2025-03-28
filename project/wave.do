onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -expand -group I2C  /axis_i2c_top_tb/dut/i_axis_i2c_master/*
add wave -expand -group FIFO /axis_i2c_top_tb/dut/genblk1/i_axis_data_fifo/*
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
restart
run 1000ns
wave zoom full
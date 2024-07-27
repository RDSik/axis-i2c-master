onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /i2c_master_tb/dut/clk
add wave -noupdate -radix binary /i2c_master_tb/dut/arst
add wave -noupdate /i2c_master_tb/dut/data
add wave -noupdate /i2c_master_tb/dut/addr
add wave -noupdate -radix binary /i2c_master_tb/dut/fifo_wr_en
add wave -noupdate -radix binary /i2c_master_tb/dut/fifo_rd_en
add wave -noupdate -radix binary /i2c_master_tb/dut/fifo_full
add wave -noupdate -radix binary /i2c_master_tb/dut/fifo_empty
add wave -noupdate -radix binary /i2c_master_tb/dut/fsm_ready
add wave -noupdate -radix binary /i2c_master_tb/dut/i2c_sda
add wave -noupdate -radix binary /i2c_master_tb/dut/i2c_scl
add wave -noupdate -radix binary /i2c_master_tb/dut/fifo_data_i
add wave -noupdate /i2c_master_tb/dut/fifo_data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
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
WaveRestoreZoom {0 ps} {252 ps}
run -all
wave zoom full

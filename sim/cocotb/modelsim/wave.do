onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_master/clk
add wave -noupdate /i2c_master/arst
add wave -noupdate /i2c_master/data
add wave -noupdate /i2c_master/addr
add wave -noupdate /i2c_master/fifo_wr_en
add wave -noupdate /i2c_master/fifo_rd_en
add wave -noupdate /i2c_master/fifo_full
add wave -noupdate /i2c_master/fifo_empty
add wave -noupdate /i2c_master/fsm_ready
add wave -noupdate /i2c_master/i2c_sda
add wave -noupdate /i2c_master/i2c_scl
add wave -noupdate /i2c_master/fifo_data_i
add wave -noupdate /i2c_master/fifo_data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2010218978 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 173
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
WaveRestoreZoom {0 ns} {18900000001 ns}
run -all
wave zoom fifo_full

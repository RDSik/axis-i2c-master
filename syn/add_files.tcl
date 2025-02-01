open_project axis_i2c_slave.xpr

read_ip ../axis_data_fifo/axis_data_fifo.xci
generate_target all [get_files *axis_data_fifo.xci]

# read_mem ../src/axis_data.mem

close_project
exit
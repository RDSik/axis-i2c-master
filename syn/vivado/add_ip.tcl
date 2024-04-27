open_project i2c_master.xpr

read_ip ../../platform/xilinx/fifo/fifo.xci
generate_target all [get_files *fifo.xci]

close_project
exit
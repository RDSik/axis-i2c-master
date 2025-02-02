####################
# Clocks
####################

create_clock -period 10.000 -name clk_i -waveform {0.000 5.000} [get_ports clk_i]
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33} [get_ports clk_i]

####################
# I/O constraints
####################



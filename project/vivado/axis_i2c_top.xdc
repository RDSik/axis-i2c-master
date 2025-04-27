####################
# Clocks
####################

create_clock -period 20.000 -name clk_i -waveform {0.000 5.000} [get_ports clk_i]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports clk_i]

####################
# I/O constraints
####################

set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports arstn_i]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports i2c_sda_io]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports i2c_scl_o]
vcd file i2c_master_tb.vcd;
add log -r /*
add wave sim:/dut/*
run -all
wave zoom full
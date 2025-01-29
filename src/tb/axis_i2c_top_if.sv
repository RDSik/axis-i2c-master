interface axis_i2c_top_if;

    bit clk_i;
    bit arstn_i;

    // wire i2c_sda_io;
    logic i2c_scl_o;
    logic rvalid_o;

    logic [7:0] i2c_data_o;

endinterface

interface axis_i2c_top_if;

    bit clk;
    bit arst;

    logic i2c_sda;
    logic i2c_scl;

    axis_if axis();

endinterface

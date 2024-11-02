interface axis_i2c_top_if;

    (* keep = "true" *) bit clk;
    (* keep = "true" *) bit arstn;

    (* keep = "true" *) logic i2c_sda;
    (* keep = "true" *) logic i2c_scl;

endinterface

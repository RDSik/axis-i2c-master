`timescale 1ns/1ps

`include "environment.sv"

module axis_i2c_top_tb ();

    localparam CLK_PER = 2;

    axis_if s_axis();
    axis_i2c_top_if dut_if();
    environment env;

    axis_i2c_top dut (
        .clk_i         (dut_if.clk_i     ),
        .arstn_i       (dut_if.arstn_i   ),
        .i2c_sda_io    (                 ),
        .i2c_scl_o     (dut_if.i2c_scl_o ),
        .i2c_data_o    (dut_if.i2c_data_o),
        .rvalid_o      (dut_if.rvalid_o  ),
        .s_axis_tdata  (s_axis.tdata     ),
        .s_axis_tvalid (s_axis.tvalid    ),
        .s_axis_tready (s_axis.tready    )
    );

    axis_data_gen data_gen (
        .clk_i   (dut_if.clk_i  ),
        .arstn_i (dut_if.arstn_i),
        .m_axis  (s_axis        )
    );

    always #(CLK_PER/2) dut_if.clk_i = ~dut_if.clk_i;

    initial begin
        fork
            env = new(dut_if);
            env.init();
        join
        $stop;
    end

    initial begin
        $dumpfile("axis_i2c_top_tb.vcd");
        $dumpvars(0, axis_i2c_top_tb);
    end

endmodule

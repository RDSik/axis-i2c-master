`timescale 1ns/1ps

`include "environment.sv"

module axis_i2c_top_tb ();

    localparam MAIN_CLK = 100_000_000;
    localparam I2C_CLK  = 200_000;
    localparam BYPASS   = 1;

    axis_if         s_axis();
    axis_i2c_top_if dut_if();

    environment env;

    axis_i2c_top #(
        .MAIN_CLK (MAIN_CLK),
        .I2C_CLK  (I2C_CLK ),
        .BYPASS   (BYPASS  )
    ) dut (
        .clk_i         (dut_if.clk_i      ),
        .arstn_i       (dut_if.arstn_i    ),
        .i2c_sda_io    (dut_if.i2c_sda_io ),
        .i2c_scl_o     (dut_if.i2c_scl_o  ),
        .i2c_rdata_o   (dut_if.i2c_rdata_o),
        .rvalid_o      (dut_if.rvalid_o   ),
        .s_axis_tdata  (s_axis.tdata      ),
        .s_axis_tvalid (s_axis.tvalid     ),
        .s_axis_tready (s_axis.tready     )
    );

    initial begin
        env = new(dut_if, s_axis);
        fork
            env.clk_gen();
            env.run();
        join_any
        $stop();
    end

    initial begin
        $dumpfile("axis_i2c_top_tb.vcd");
        $dumpvars(0, axis_i2c_top_tb);
    end

endmodule

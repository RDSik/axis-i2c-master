`timescale 1ns/1ps

`include "environment.sv"

module axis_i2c_top_tb ();

localparam DATA_WIDTH     = 16;
localparam I2C_DATA_WIDTH = 8;
localparam MAIN_CLK       = 100_000_000;
localparam I2C_CLK        = 50_000_000;
localparam BYPASS         = 0;
localparam CONFIG_MEM     = "rtl/config.mem";
localparam MEM_DEPTH      = 24;

localparam CLK_PER_NS     = 10**9/MAIN_CLK;
localparam SIM_TIME       = 3000;

axis_i2c_top_if dut_if();
axis_if         s_axis();

environment env;

initial begin
    env = new(dut_if, s_axis, CLK_PER_NS, SIM_TIME);
    env.run();
end

initial begin
    $dumpfile("axis_i2c_top_tb.vcd");
    $dumpvars(0, axis_i2c_top_tb);
end

axis_i2c_top #(
    .DATA_WIDTH     (DATA_WIDTH    ),
    .I2C_DATA_WIDTH (I2C_DATA_WIDTH),
    .MAIN_CLK       (MAIN_CLK      ),
    .I2C_CLK        (I2C_CLK       ),
    .BYPASS         (BYPASS        ),
    .CONFIG_MEM     (CONFIG_MEM    ),
    .MEM_DEPTH      (MEM_DEPTH     )
) dut (
    .clk_i         (dut_if.clk_i     ),
    .arstn_i       (dut_if.arstn_i   ),
    .i2c_sda_io    (dut_if.i2c_sda_io),
    .i2c_scl_o     (dut_if.i2c_scl_o )
);

endmodule

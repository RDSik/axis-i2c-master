// `timescale 1ns/1ps
`include "environment.sv"

module axis_i2c_top_tb ();

    localparam SIM_TIME   = 300;
    localparam CLK_PERIOD = 2;

    logic [3:0] cnt;

    logic [15:0] axis_mem [15:0];

    axis_i2c_top_if dut_if();
    environment env;

    axis_i2c_top dut (
        .clk     (dut_if.clk),
        .arst    (dut_if.arst),
        .i2c_sda (dut_if.i2c_sda),
        .i2c_scl (dut_if.i2c_scl) 
    );

    assign dut.cnt = cnt;
    assign dut.axis_mem = axis_mem;

    always #(CLK_PERIOD/2) dut_if.clk = ~dut_if.clk;

    initial begin
        env = new(dut_if);
        env.init();
        #SIM_TIME $stop;
    end

    initial begin
        $dumpfile("axis_i2c_top_tb.vcd");
        $dumpvars(0, axis_i2c_top_tb);
        $monitor("time=%g, i2c_sda=%b, i2c_slc=%b, ", $time, dut_if.i2c_sda, dut_if.i2c_scl);
    end

endmodule

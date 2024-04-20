`include "timescale.vh"

module i2c_master_tb ();

localparam SIM_TIME   = 100;
localparam CLK_PERIOD = 2;
localparam FIFO_DEPTH = 4;
// localparam I2C_CLK_PERIOD = 20;

reg [7:0] data;
reg [6:0] addr;
// reg       i2c_clk;
reg       clk;
reg       arst;
reg       fifo_wr_en;

wire fifo_full;
wire i2c_sda;
wire i2c_scl;

wire [14:0] fifo_data_i;
wire [14:0] fifo_data_o;
wire        fsm_start;
wire        fifo_empty;
wire        fsm_ready;

i2c_master dut (
    .clk        (clk),
    // .i2c_clk    (i2c_clk),
    .arst       (arst),
    .data       (data),
    .addr       (addr),
    .fifo_wr_en (fifo_wr_en),
    .fifo_full  (fifo_full),
    .i2c_sda    (i2c_sda),
    .i2c_scl    (i2c_scl)
);

assign fifo_data_i = dut.fifo_data_i;
assign fifo_data_o = dut.fifo_data_o;
assign fifo_empty  = dut.fifo_empty;
assign fsm_ready   = dut.fsm_ready;
assign fsm_start   = dut.fsm_start;

task rst_set(input zero, one);
    begin
        #CLK_PERIOD;
        arst = one;
        #CLK_PERIOD;
        arst = zero;
        $display("\n-----------------------------");
        $display("Reset done");
        $display("-----------------------------\n");
    end
endtask

task data_addr_gen();
    begin
        fifo_wr_en = 1;
        repeat (FIFO_DEPTH*2) begin
            #CLK_PERIOD; data = $urandom_range(0, 255); addr = $urandom_range(0, 127);
        end
        fifo_wr_en = 0;
    end
endtask

// always #(I2C_CLK_PERIOD/2) i2c_clk = ~i2c_clk;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    clk = 0;
    // i2c_clk = 0;
    rst_set(0, 1);
    data_addr_gen();
end

initial begin
    $dumpfile("i2c_master_tb.vcd");
    $dumpvars(0, i2c_master_tb);
    $monitor("time=%g, data=0x%h, addr=0x%h, i2c_sda=%b, i2c_slc=%b, fifo_full=%b, fifo_emply=%b", $time, data, addr, i2c_sda, i2c_scl, fifo_full, fifo_empty);
end

initial #SIM_TIME $stop;

endmodule
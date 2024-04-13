// `include "timescale.svh"

module i2c_master_tb ();

localparam SIM_TIME       = 100; // simulation time 10000 ns
localparam CLK_PERIOID    = 2;
localparam I2C_CLK_PERIOD = 20;

logic [7:0] data;
logic [6:0] addr;
logic       clk;
logic       i2c_clk;
logic       arst;
logic       fifo_wr_en;
logic       fifo_full;

wire i2c_sda;
wire i2c_scl;

logic [14:0] fifo_data_i;
logic [14:0] fifo_data_o;
logic        start;
logic        fifo_empty;
logic        fsm_ready;

assign fifo_data_i = dut.fifo_data_i;
assign fifo_data_o = dut.fifo_data_o;
assign fifo_empty  = dut.fifo_empty;
assign fsm_ready   = dut.fsm_ready;
assign start       = dut.start;

i2c_master dut (
    .clk        (clk),
    .i2c_clk    (i2c_clk),
    .arst       (arst),
    .data       (data),
    .addr       (addr),
    .fifo_wr_en (fifo_wr_en),
    .fifo_full  (fifo_full),
    .i2c_sda    (i2c_sda),
    .i2c_scl    (i2c_scl)
);

task rst_en_set(input zero, one);
    #CLK_PERIOID;
    fifo_wr_en = zero;
    arst       = one;
    #CLK_PERIOID;
    fifo_wr_en = one;
    arst       = zero;
    $display("\n-----------------------------");
    $display("Reset done and enable high");
    $display("-----------------------------\n");
endtask

task data_addr_gen(); 
    data = $urandom_range(0, 255);
    addr = $urandom_range(0, 127);
endtask

always #(I2C_CLK_PERIOD/2) i2c_clk = ~i2c_clk;
always #(CLK_PERIOID/2) clk = ~clk;

initial begin
    clk = 0;
    i2c_clk = 0;
    rst_en_set(0, 1);
    data_addr_gen();
end

initial begin
    $dumpfile("i2c_master_tb.vcd");
    $dumpvars(0, i2c_master_tb);
    $monitor("time=%g, data=0x%h, addr=0x%h, i2c_sda=%b, i2c_slc=%b, fifo_full=%b, fifo_emply=%b", $time, data, addr, i2c_sda, i2c_scl, fifo_full, fifo_empty);
end

initial #SIM_TIME $stop;

endmodule
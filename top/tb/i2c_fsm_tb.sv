`include "timescale.svh"

module i2c_fsm_tb();

localparam DATA_WIDTH = 8;
localparam ADDR_WIDTH = 7;
localparam CLK_PERIOID = 2;
localparam SIM_TIME    = 100;

logic [ADDR_WIDTH-1:0] addr;
logic [DATA_WIDTH-1:0] data;

logic clk;
logic arst;    
logic start;
logic ready;
logic sda;
logic scl;
logic scl_en;

logic [$clog2(DATA_WIDTH)-1:0] cnt;
logic [ADDR_WIDTH-1:0]         saved_addr;
logic [DATA_WIDTH-1:0]         saved_data;

logic [2:0] state;

assign saved_addr = dut.saved_addr;
assign saved_data = dut.saved_data;
assign cnt        = dut.cnt;
assign scl_en     = dut.scl_en;
assign state      = dut.state;

i2c_fsm dut(
    .clk   (clk),
    .arst  (arst),    
    .start (start),
    .addr  (addr),
    .data  (data),
    .ready (ready),
    .sda   (sda),
    .scl   (scl)
);

always #(CLK_PERIOID/2) clk = ~clk;

task rst_gen(input zero, one);
    arst = one;
    #CLK_PERIOID;
    arst = zero;
    $display("\n-----------------------------");
    $display("Reset done");
    $display("-----------------------------\n");
endtask

task start_gen(input zero, one);
    #CLK_PERIOID;
    start = one;
    #CLK_PERIOID;
    start = zero;
    $display("\n-----------------------------");
    $display("Start fsm");
    $display("-----------------------------\n");
endtask

task data_addr_gen(); 
    data = $urandom_range(0, 255);
    addr = $urandom_range(0, 127);
endtask

initial begin
    clk = 0;
    rst_gen(0, 1);
    data_addr_gen();
    start_gen(0 , 1);
end

initial begin
    $dumpfile("i2c_fsm_tb.vcd");
    $dumpvars(0, i2c_fsm_tb);
    $monitor("time=%g, data=0x%h, addr=0x%h, sda=%b, slc=%b, ready=%b, start=%b", $time, data, addr, sda, scl, ready, start);
end

initial #SIM_TIME $stop;

endmodule
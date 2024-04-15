`include "timescale.vh"

module i2c_fsm_tb();

localparam DATA_WIDTH  = 8;
localparam ADDR_WIDTH  = 7;
localparam CLK_PERIOID = 2;
localparam SIM_TIME    = 100;

reg [ADDR_WIDTH-1:0] addr;
reg [DATA_WIDTH-1:0] data;
reg                  clk;
reg                  arst;    
reg                  start;

wire ready;
wire sda;
wire scl;

wire [$clog2(DATA_WIDTH)-1:0] cnt;
wire [ADDR_WIDTH-1:0]         saved_addr;
wire [DATA_WIDTH-1:0]         saved_data;
wire [2:0]                    state;
wire                          scl_en;

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

assign saved_addr = dut.saved_addr;
assign saved_data = dut.saved_data;
assign cnt        = dut.cnt;
assign scl_en     = dut.scl_en;
assign state      = dut.state;

always #(CLK_PERIOID/2) clk = ~clk;

task rst_gen(input zero, one);
    begin
        arst = one;
        #CLK_PERIOID;
        arst = zero;
        $display("\n-----------------------------");
        $display("Reset done");
        $display("-----------------------------\n");
    end
endtask

task start_gen(input zero, one);
    begin
        #CLK_PERIOID;
        start = one;
        #CLK_PERIOID;
        start = zero;
        $display("\n-----------------------------");
        $display("Start fsm");
        $display("-----------------------------\n");
    end
endtask

task data_addr_gen();
    begin
        data = $urandom_range(0, 255);
        addr = $urandom_range(0, 127);
    end
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
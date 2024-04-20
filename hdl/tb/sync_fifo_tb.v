`include "timescale.vh"

module sync_fifo_tb();

localparam SIM_TIME   = 50; // simulation time 10000 ns
localparam CLK_PERIOD = 2;
localparam FIFO_DEPTH = 4;
localparam DATA_WIDTH = 15;

reg                  clk;
reg                  arst;
reg                  wr_en;
reg                  rd_en;
reg [DATA_WIDTH-1:0] data_in;

wire [DATA_WIDTH-1:0] data_out;
wire                  full;
wire                  empty;

wire [$clog2(FIFO_DEPTH):0] rd_pointer;
wire [$clog2(FIFO_DEPTH):0] wr_pointer;
wire [$clog2(FIFO_DEPTH):0] status_cnt;

sync_fifo dut(
    .clk      (clk),
    .arst     (arst),
    .rd_en    (rd_en),
    .wr_en    (wr_en),
    .data_in  (data_in),
    .data_out (data_out),
    .empty    (empty),
    .full     (full)
 );

 assign rd_pointer = dut.rd_pointer;
 assign wr_pointer = dut.wr_pointer;
 assign status_cnt = dut.status_cnt;

 task rst_en_set(input zero, one);
    begin
        #CLK_PERIOD;
        arst       = one;
        #CLK_PERIOD;        
        arst       = zero;
        $display("\n-----------------------------");
        $display("Reset done");
        $display("-----------------------------\n");
    end
endtask

task data_addr_gen();
    begin
        rd_en = 0;
        wr_en = 1;
        repeat (FIFO_DEPTH + 1) begin
            #CLK_PERIOD; data_in = $urandom_range(0, 32768);
        end
        wr_en = 0;
        #CLK_PERIOD;
        rd_en = 1;
        #8;
        rd_en = 0;
    end
endtask

always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    clk = 0;
    rst_en_set(0, 1);
    data_addr_gen();
end

initial begin
    $dumpfile("sync_fifo_tb.vcd");
    $dumpvars(0, sync_fifo_tb);
    $monitor("time=%g, data_out=0x%h, data_in=0x%h, full=%b, emply=%b", $time, data_in, data_out, full, empty);
end

initial #SIM_TIME $stop;

endmodule
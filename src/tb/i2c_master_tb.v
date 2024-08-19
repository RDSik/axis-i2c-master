`include "timescale.vh" // comment this for vivado simulation with hdlmake

module i2c_master_tb ();

localparam SIM_TIME   = 240;
localparam CLK_PERIOD = 2;
// localparam I2C_CLK_PERIOD = 20;

reg [7:0] data;
reg [6:0] addr;
// reg       i2c_clk;
reg       clk;
reg       arst;
reg       fifo_wr_en;
reg       fifo_rd_en;

wire fsm_ready;
wire fifo_empty;
wire fifo_full;
wire i2c_sda;
wire i2c_scl;

wire [14:0] fifo_data_i;
wire [14:0] fifo_data_o;

i2c_master dut (
    .clk        (clk       ),
    // .i2c_clk    (i2c_clk),
    .arst       (arst      ),
    .data       (data      ),
    .addr       (addr      ),
    .fifo_wr_en (fifo_wr_en),
    .fifo_rd_en (fifo_rd_en),
    .fifo_empty (fifo_empty),
    .fifo_full  (fifo_full ),
    .fsm_ready  (fsm_ready ),
    .i2c_sda    (i2c_sda   ),
    .i2c_scl    (i2c_scl   )
);

assign fifo_data_i = dut.fifo_data_i;
assign fifo_data_o = dut.fifo_data_o;

task rst_set(input zero, one);
    begin
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
        data = $urandom_range(0, 255); 
        addr = $urandom_range(0, 127);
    end
endtask

task rd_en_gen();
    begin
        fifo_rd_en = 1;
        #CLK_PERIOD;
        fifo_rd_en = 0;
        #CLK_PERIOD;
    end
endtask

task wr_en_gen();
    begin
        fifo_wr_en = 1;      
        #CLK_PERIOD;
        fifo_wr_en = 0;
        #CLK_PERIOD;
    end
endtask

task flow();
    begin
        rst_set(0, 1);
        fifo_rd_en = 0;
        repeat (4) begin        
            wr_en_gen();
            data_addr_gen();
            #40;
            rd_en_gen();
        end
    end
endtask

// always #(I2C_CLK_PERIOD/2) i2c_clk = ~i2c_clk;
initial begin
    clk = 0;
    forever begin
        #(CLK_PERIOD/2) clk = ~clk;
    end
end

initial begin
    // i2c_clk = 0;
    flow();
end

initial begin
    $dumpfile("i2c_master_tb.vcd");
    $dumpvars(0, i2c_master_tb);
    $monitor("time=%g, data=0x%h, addr=0x%h, i2c_sda=%b, i2c_slc=%b, fifo_full=%b, fifo_empty=%b", $time, data, addr, i2c_sda, i2c_scl, fifo_full, fifo_empty);
end

initial begin
    #SIM_TIME $stop;
end

endmodule

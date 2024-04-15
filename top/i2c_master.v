module i2c_master #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 7
) (
    input  wire                  clk,
    input  wire                  i2c_clk,
    input  wire                  arst,
    input  wire [DATA_WIDTH-1:0] data,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire                  fifo_wr_en,
    output wire                  fifo_full,
    inout  wire                  i2c_sda,
    inout  wire                  i2c_scl 
);

wire [14:0] fifo_data_i;
wire [14:0] fifo_data_o;

wire fifo_empty;
wire fsm_ready;
wire start;

assign fifo_data_i = {data, addr};

assign start = ~fifo_empty && fsm_ready;

i2c_fsm #(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
) i2c_inst (
    .clk   (clk),
    .arst  (arst),
    .start (start),
    .addr  (fifo_data_o[6:0]),
    .data  (fifo_data_o[14:7]),
    .ready (fsm_ready),
    .sda   (i2c_sda),
    .scl   (i2c_scl)
);

fifo fifo_inst (
    .wr_clk (clk),
    .rd_clk (i2c_clk),
    .rst    (arst),
    .din    (fifo_data_i),
    .dout   (fifo_data_o),
    .full   (fifo_full),
    .empty  (fifo_empty),
    .wr_en  (fifo_wr_en),
    .rd_en  (start)
);

endmodule
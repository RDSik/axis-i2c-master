`default_nettype none

module i2c_master #(
    parameter DATA_WIDTH      = 8,
    parameter ADDR_WIDTH      = 7,
    parameter FIFO_DATA_WIDTH = 15,
    parameter FIFO_DEPTH      = 4
) (
    // input  wire                  i2c_clk,
    input  wire                  clk,
    input  wire                  arst,
    input  wire [DATA_WIDTH-1:0] data,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire                  fifo_wr_en,
    input  wire                  fifo_rd_en,
    output wire                  fifo_full,
    output wire                  fifo_empty,
    output wire                  fsm_ready,
    inout  wire                  i2c_sda,
    inout  wire                  i2c_scl 
);

    wire [14:0] fifo_data_i;
    wire [14:0] fifo_data_o;

    assign fifo_data_i = {data, addr};

    i2c_fsm #(
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) i2c_inst (
        .clk   (clk),
        .arst  (arst),
        .start (fifo_rd_en),
        .addr  (fifo_data_o[6:0]),
        .data  (fifo_data_o[14:7]),
        .ready (fsm_ready),
        .sda   (i2c_sda),
        .scl   (i2c_scl)
    );
    
    sync_fifo #(
        .DATA_WIDTH (FIFO_DATA_WIDTH),
        .FIFO_DEPTH (FIFO_DEPTH)
    ) fifo_inst (
        .clk      (clk),
        .arst     (arst),
        .rd_en    (fifo_rd_en),
        .wr_en    (fifo_wr_en),
        .data_in  (fifo_data_i),
        .data_out (fifo_data_o),
        .empty    (fifo_empty),
        .full     (fifo_full)
    );

    `ifdef COCOTB_SIM
        initial begin
            $dumpfile ("i2c_master.vcd");
            $dumpvars (0, i2c_master);
            #1;
        end
    `endif

    // fifo fifo_inst (
        // .wr_clk (clk),
        // .rd_clk (i2c_clk),
        // .clk    (clk),
        // .rst    (arst),
        // .din    (fifo_data_i),
        // .dout   (fifo_data_o),
        // .full   (fifo_full),
        // .empty  (fifo_empty),
        // .wr_en  (fifo_wr_en),
        // .rd_en  (fifo_rd_en)
    // );

endmodule

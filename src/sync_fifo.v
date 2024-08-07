module sync_fifo #(
    parameter DATA_WIDTH = 15,
    parameter FIFO_DEPTH = 4
) (    
    input  wire                  clk,
    input  wire                  arst,
    input  wire                  rd_en,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire                  empty,
    output wire                  full
);

    reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];

    reg [$clog2(FIFO_DEPTH)-1:0] rd_pointer;
    reg [$clog2(FIFO_DEPTH)-1:0] wr_pointer;
    reg [$clog2(FIFO_DEPTH):0  ] status_cnt;

    //! Read logic
    always @(posedge clk or posedge arst) begin
        if (arst) begin
            rd_pointer <= 0;
        end else if (rd_en) begin
            rd_pointer <= rd_pointer + 1;
        end
    end

    //! Write logic
    always @(posedge clk or posedge arst) begin
        if (arst) begin
            wr_pointer <= 0;
        end else if (wr_en) begin
            fifo[wr_pointer] <= data_in;
            wr_pointer       <= wr_pointer + 1;
        end
    end

    //! Status counter for full and empty
    always @(posedge clk or posedge arst) begin
        if (arst) begin
            status_cnt <= 0;
        end else begin
            if (wr_en && !rd_en && (status_cnt != FIFO_DEPTH)) begin
                status_cnt <= status_cnt + 1;
            end else if (rd_en && !wr_en && (status_cnt != 0)) begin
                status_cnt <= status_cnt - 1;
            end
        end
    end

    // assign full     = (status_cnt >= FIFO_DEPTH);
    // assign empty    = (status_cnt <= 0);
    
    assign full     = wr_en ? (status_cnt >= FIFO_DEPTH - 1) : (status_cnt == FIFO_DEPTH);
    assign empty    = rd_en ? (status_cnt <= 1) : (status_cnt == 0);
    assign data_out = fifo[rd_pointer];

endmodule

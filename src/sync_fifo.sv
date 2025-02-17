module sync_fifo #(
    parameter DATA_WIDTH = 16,
    parameter FIFO_DEPTH = 4
) (
    input  logic                  clk,
    input  logic                  arstn,
    input  logic                  pop,
    input  logic                  push,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  empty,
    output logic                  full
);

localparam POINTER_WIDTH = $clog2(FIFO_DEPTH);
localparam MAX_POINTER   = POINTER_WIDTH'(FIFO_DEPTH-1);

logic [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];

logic [POINTER_WIDTH-1:0] rd_pointer;
logic [POINTER_WIDTH-1:0] wr_pointer;
logic [POINTER_WIDTH:0  ] status_cnt;

// Read logic
always_ff @(posedge clk or negedge arstn) begin
    if (~arstn) begin
        rd_pointer <= '0;
    end else if (pop) begin
        rd_pointer <= (rd_pointer == MAX_POINTER) ? '0 : rd_pointer + 1;
    end
end

// Write logic
always_ff @(posedge clk or negedge arstn) begin
    if (~arstn) begin
        wr_pointer <= '0;
    end else if (push) begin
        wr_pointer <= (wr_pointer == MAX_POINTER) ? '0 : wr_pointer + 1;
    end
end

// Status counter for full and empty
always_ff @(posedge clk or negedge arstn) begin
    if (~arstn) begin
        status_cnt <= '0;
    end else if (push && !pop && (status_cnt != FIFO_DEPTH)) begin
        status_cnt <= status_cnt + 1;
    end else if (pop && !push && (status_cnt != 0)) begin
        status_cnt <= status_cnt - 1;
    end
end

always_ff @(posedge clk) begin
    if (push) begin
        fifo[wr_pointer] <= data_in;
    end
end

assign data_out = fifo[rd_pointer];

// assign full  = (status_cnt >= FIFO_DEPTH);
// assign empty = (status_cnt <= 0);

assign full  = push ? (status_cnt >= FIFO_DEPTH - 1) : (status_cnt == FIFO_DEPTH);
assign empty = pop ? (status_cnt <= 1) : (status_cnt == 0);

endmodule

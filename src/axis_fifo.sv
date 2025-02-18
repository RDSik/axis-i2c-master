module axis_fifo #(
    parameter DATA_WIDTH = 16,
    parameter FIFO_DEPTH = 4
) (
    input  logic clk,
    input  logic arstn,

    axis_if.slave s_axis,
    axis_if.master m_axis
);

localparam POINTER_WIDTH = $clog2(FIFO_DEPTH);
localparam MAX_POINTER   = POINTER_WIDTH'(FIFO_DEPTH-1);

logic [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];

logic [POINTER_WIDTH-1:0] rd_ptr;
logic [POINTER_WIDTH-1:0] wr_ptr;
logic [POINTER_WIDTH:0  ] status_cnt;

logic pop;
logic push;
logic empty;
logic full;

// Read logic
always_ff @(posedge clk or negedge arstn) begin
    if (~arstn) begin
        rd_ptr <= '0;
    end else if (pop) begin
        rd_ptr <= (rd_ptr == MAX_POINTER) ? '0 : rd_ptr + 1;
    end
end

// Write logic
always_ff @(posedge clk or negedge arstn) begin
    if (~arstn) begin
        wr_ptr <= '0;
    end else if (push) begin
        wr_ptr <= (wr_ptr == MAX_POINTER) ? '0 : wr_ptr + 1;
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
        fifo[wr_ptr] <= s_axis.tdata;
    end
end

// assign full  = (status_cnt >= FIFO_DEPTH);
// assign empty = (status_cnt <= 0);

always_comb begin
    s_axis.tready = ~full;
    m_axis.tvalid = ~empty;
    m_axis.tdata  = fifo[rd_ptr];
    push  = s_axis.tvalid & s_axis.tready;
    pop   = m_axis.tvalid & m_axis.tready;
    full  = push ? (status_cnt >= FIFO_DEPTH - 1) : (status_cnt == FIFO_DEPTH);
    empty = pop ? (status_cnt <= 1) : (status_cnt == 0);
end

endmodule

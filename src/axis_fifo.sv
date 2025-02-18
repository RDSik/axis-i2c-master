module axis_fifo #(
    parameter DATA_WIDTH = 16,
    parameter FIFO_DEPTH = 4
) (
    input logic clk_i,
    input logic arstn_i,

    axis_if.slave s_axis,
    axis_if.master m_axis
);

localparam POINTER_WIDTH = $clog2(FIFO_DEPTH);
localparam MAX_POINTER   = POINTER_WIDTH'(FIFO_DEPTH-1);

logic [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];

logic [POINTER_WIDTH-1:0] rd_pointer;
logic [POINTER_WIDTH-1:0] wr_pointer;
logic [POINTER_WIDTH:0  ] status_cnt;

logic pop;
logic push;
logic empty;
logic full;

// Read logic
always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        rd_pointer <= '0;
    end else if (pop) begin
        rd_pointer <= (rd_pointer == MAX_POINTER) ? '0 : rd_pointer + 1;
    end
end

// Write logic
always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        wr_pointer <= '0;
    end else if (push) begin
        wr_pointer <= (wr_pointer == MAX_POINTER) ? '0 : wr_pointer + 1;
    end
end

// Status counter for full and empty
always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        status_cnt <= '0;
    end else if (push && !pop && (status_cnt != FIFO_DEPTH)) begin
        status_cnt <= status_cnt + 1;
    end else if (pop && !push && (status_cnt != 0)) begin
        status_cnt <= status_cnt - 1;
    end
end

always_ff @(posedge clk_i) begin
    if (push) begin
        fifo[wr_pointer] <= s_axis.tdata;
    end
end

always_comb begin
    m_axis.tdata  = fifo[rd_pointer];
    s_axis.tready = ~full;
    m_axis.tvalid = ~empty;
    push  = s_axis.tvalid & s_axis.tready;
    pop   = m_axis.tvalid & m_axis.tready;
    full  = push ? (status_cnt >= FIFO_DEPTH - 1) : (status_cnt == FIFO_DEPTH);
    empty = pop ? (status_cnt <= 1) : (status_cnt == 0);
end

// assign full  = (status_cnt >= FIFO_DEPTH);
// assign empty = (status_cnt <= 0);

endmodule

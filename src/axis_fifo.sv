module axis_fifo #(
    parameter DATA_WIDTH = 16,
    parameter FIFO_DEPTH = 32
) (
    input logic clk_i,
    input logic arstn_i,

    axis_if.master m_axis,
    axis_if.slave  s_axis
);

localparam POINTER_WIDTH = $clog2(FIFO_DEPTH);
localparam MAX_POINTER   = POINTER_WIDTH'(FIFO_DEPTH-1);

logic [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];

logic [POINTER_WIDTH-1:0] rd_pointer;
logic [POINTER_WIDTH-1:0] wr_pointer;
logic                     wr_odd_circle;
logic                     rd_odd_circle;
// logic [POINTER_WIDTH:0  ] status_cnt;

logic pop;
logic push;
logic empty;
logic full;

// Read logic
always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        rd_odd_circle <= 1'b0;
        rd_pointer    <= '0;
    end else if (pop) begin
        if (rd_pointer == MAX_POINTER) begin
            rd_odd_circle <= ~rd_odd_circle;
            rd_pointer    <= '0;
        end else begin
            rd_pointer <= rd_pointer + 1;
        end
    end
end

// Write logic
always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        wr_odd_circle <= 1'b0;
        wr_pointer    <= '0;
    end else if (push) begin
        if (wr_pointer == MAX_POINTER) begin
            wr_odd_circle <= ~wr_odd_circle;
            wr_pointer    <= '0;
        end else begin
            wr_pointer <= wr_pointer + 1;
        end
    end
end

always_ff @(posedge clk_i) begin
    if (push) begin
        fifo[wr_pointer] <= s_axis.tdata;
    end
end

assign m_axis.tdata  = fifo[rd_pointer];
assign m_axis.tvalid = ~empty;
assign s_axis.tready = ~full;

assign push  = s_axis.tvalid & s_axis.tready;
assign pop   = m_axis.tvalid & m_axis.tready;
assign full  = (wr_pointer == rd_pointer) && (wr_odd_circle != rd_odd_circle);
assign empty = (wr_pointer == rd_pointer) && (wr_odd_circle == rd_odd_circle);

// Status counter for full and empty
// always_ff @(posedge clk_i or negedge arstn_i) begin
    // if (~arstn_i) begin
        // status_cnt <= '0;
    // end else if (push && !pop && (status_cnt != FIFO_DEPTH)) begin
        // status_cnt <= status_cnt + 1;
    // end else if (pop && !push && (status_cnt != 0)) begin
        // status_cnt <= status_cnt - 1;
    // end
// end

// assign full  = push ? (status_cnt >= FIFO_DEPTH - 1) : (status_cnt == FIFO_DEPTH);
// assign empty = pop ? (status_cnt <= 1) : (status_cnt == 0);

endmodule

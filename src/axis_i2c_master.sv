module axis_i2c_master #(
    parameter DATA_WIDTH = 8
) (
    input  logic clk_i,
    input  logic arstn_i,
    inout        i2c_sda_io,
    output logic i2c_scl_o,

    axis_if s_axis,
    axis_if m_axis
);

enum logic [2:0] {
    IDLE      = 3'b000,
    START     = 3'b001,
    ADDR      = 3'b010,
    WACK_ADDR = 3'b011,
    WR_DATA   = 3'b100,
    RD_DATA   = 3'b101,
    WACK_DATA = 3'b110,
    STOP      = 3'b111
} state;

localparam WRITE = 1'b0;
localparam READ  = 1'b1;

logic [$clog2(DATA_WIDTH)-1:0] bit_cnt;
logic [DATA_WIDTH-1:0]         rd_data;
logic [DATA_WIDTH-1:0]         wr_data;
logic [DATA_WIDTH-1:0]         addr;
logic                          cnt_done;
logic                          rw;
logic                          i2c_scl_en;

logic i2c_sda_en;
logic i2c_sda_o;
logic i2c_sda_i;

assign i2c_sda_io = (i2c_sda_en) ? 1'bz : i2c_sda_o;
assign i2c_sda_i  = i2c_sda_io;

// IOBUF iobuf_inst (
    // .O  (i2c_sda_i ), // Buffer output
    // .IO (i2c_sda_io), // Buffer inout port
    // .I  (i2c_sda_o ), // Buffer input
    // .T  (i2c_sda_en)  // 3-state enable input, high=input, low=output
// );

always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        state   <= IDLE;
        rd_data <= '0;
    end else begin
        case (state)
            IDLE: begin
                if (s_axis.tvalid) begin
                    state <= START;
                end
            end
            START: begin
                state      <= ADDR;
                i2c_sda_en <= WRITE;
                i2c_sda_o  <= 1'b0;
            end
            ADDR: begin
                i2c_sda_o  <= addr[bit_cnt];
                i2c_sda_en <= WRITE;
                if (cnt_done) begin
                    state <= WACK_ADDR;
                end
            end
            WACK_ADDR: begin
                state      <= (rw) ? RD_DATA : WR_DATA;
                i2c_sda_en <= READ;
            end
            WR_DATA: begin
                i2c_sda_o  <= wr_data[bit_cnt];
                i2c_sda_en <= WRITE;
                if (cnt_done) begin
                    state <= WACK_DATA;
                end
            end
            RD_DATA: begin
                rd_data[bit_cnt] <= i2c_sda_i;
                i2c_sda_en <= READ;
                if (cnt_done) begin
                    state <= WACK_DATA;
                end
            end
            WACK_DATA: begin
                state      <= STOP;
                i2c_sda_en <= READ;
            end
            STOP: begin
                state      <= IDLE;
                i2c_sda_en <= WRITE;
                i2c_sda_o  <= 1'b1;
            end
            default: state <= IDLE;
        endcase
    end
end

always_ff @(negedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        i2c_scl_en <= 1'b0;
    end else begin
        if ((state == IDLE) || (state == START) || (state == STOP)) begin
            i2c_scl_en <= 1'b0;
        end else begin
            i2c_scl_en <= 1'b1;
        end
    end
end

always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        bit_cnt <= '0;
    end else if ((state == WACK_ADDR) || (state == START)) begin
        bit_cnt <= DATA_WIDTH - 1;
    end else if ((state == ADDR) || (state == WR_DATA) || (state == RD_DATA)) begin
        bit_cnt <= bit_cnt - 1'b1;
    end
end

always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        m_axis.tdata <= '0;
    end else if (m_axis.tvalid & m_axis.tready) begin
        m_axis.tdata <= rd_data;
    end
end

always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        wr_data <= '0;
        addr    <= '0;
    end else if (s_axis.tvalid & s_axis.tready) begin
        wr_data <= s_axis.tdata[(DATA_WIDTH*2)-1:DATA_WIDTH];
        addr    <= s_axis.tdata[DATA_WIDTH-1:0];
    end
end

assign s_axis.tready = (state == IDLE) ? 1'b1 : 1'b0;
assign i2c_scl_o     = i2c_scl_en ? ~clk_i : 1'b1;
assign cnt_done      = ~(|bit_cnt);
assign rw            = addr[DATA_WIDTH-1];
assign m_axis.tvalid = ((state == STOP) && (rw)) ? 1'b1 : 1'b0;

endmodule

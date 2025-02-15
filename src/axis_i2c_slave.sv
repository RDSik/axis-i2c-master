`include "axis_i2c_pkg.svh"

module axis_i2c_slave
    import axis_i2c_pkg::*;
(
    input  logic                      clk_i,
    input  logic                      arstn_i,
    inout                             i2c_sda_io,
    output logic                      i2c_scl_o,

    output logic [I2C_DATA_WIDTH-1:0] m_axis_tdata,
    output logic                      m_axis_tvalid,

    axis_if.slave s_axis
);

    enum logic [2:0] {
        IDLE      = 3'b000,
        START     = 3'b001,
        ADDR      = 3'b010,
        WACK_ADDR = 3'b011,
        DATA      = 3'b100,
        WACK_DATA = 3'b101,
        STOP      = 3'b110
    } state;

    logic [I2C_DATA_WIDTH-1:0] rd_data;
    logic [I2C_DATA_WIDTH-1:0] wr_data;
    logic [I2C_DATA_WIDTH-1:0] addr;
    logic [BIT_CNT_WIDTH-1:0 ] bit_cnt;
    logic                      cnt_done;
    logic                      i2c_scl_en;
    logic                      i2c_sda_en;
    logic                      rd_bit;
    logic                      wr_bit;

    assign i2c_sda_io = (i2c_sda_en) ? 1'bz : wr_bit;
    assign rd_bit     = i2c_sda_io;

    // IOBUF iobuf_inst (
        // .O  (rd_bit    ), // Buffer output
        // .IO (i2c_sda_io), // Buffer inout port
        // .I  (wr_bit    ), // Buffer input
        // .T  (i2c_sda_en)  // 3-state enable input, high=input, low=output
    // );

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            state   <= IDLE;
            addr    <= '0;
            wr_data <= '0;
            rd_data <= '0;
        end else begin
            case (state)
                IDLE: begin
                    if (s_axis.tvalid) begin
                        state   <= START;
                        wr_data <= s_axis.tdata[AXIS_DATA_WIDTH-1:I2C_DATA_WIDTH];
                        addr    <= s_axis.tdata[I2C_DATA_WIDTH-1:0];
                    end
                end
                START: begin
                    state      <= ADDR;
                    i2c_sda_en <= WRITE;
                    wr_bit     <= 1'b0;
                end
                ADDR: begin
                    wr_bit <= addr[bit_cnt];
                    if (cnt_done) state <= WACK_ADDR;
                end
                WACK_ADDR: begin
                    state <= DATA;
                end
                DATA: begin
                    i2c_sda_en <= (addr[RW_BIT]) ? READ : WRITE;
                    if (addr[RW_BIT] == WRITE) begin
                        wr_bit <= wr_data[bit_cnt];
                        if (cnt_done) state <= WACK_DATA;
                    end else if (addr[RW_BIT] == READ) begin
                        rd_data[bit_cnt] <= rd_bit;
                        if (cnt_done) state <= WACK_DATA;
                    end
                end
                WACK_DATA: begin
                    state <= STOP;
                end
                STOP: begin
                    state      <= IDLE;
                    i2c_sda_en <= WRITE;
                    wr_bit     <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            bit_cnt <= '0;
        end else if ((state == DATA) || (state == ADDR)) begin
            bit_cnt <= bit_cnt - 1;
        end else if ((state == WACK_ADDR) || (state == START)) begin
            bit_cnt <= I2C_DATA_WIDTH - 1;
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

    always_comb begin
        s_axis.tready = ((arstn_i == 1'b1) && (state == IDLE)) ? 1'b1 : 1'b0;
        i2c_scl_o     = i2c_scl_en ? ~clk_i : 1'b1;
        cnt_done      = ~(|bit_cnt);
        m_axis_tvalid = (state == WACK_DATA) && (addr[RW_BIT] == READ);
        m_axis_tdata  = rd_data;
    end

endmodule

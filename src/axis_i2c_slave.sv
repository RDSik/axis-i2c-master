`include "axis_i2c_pkg.svh"

module axis_i2c_slave
    import axis_i2c_pkg::*;
(
    input  logic                      clk_i,
    input  logic                      arstn_i,
    input  logic                      rd_bit,
    output logic                      wr_bit,
    output logic                      i2c_scl,
    output logic                      i2c_sda_en,
    output logic [I2C_DATA_WIDTH-1:0] i2c_data_o,

    axis_if.slave s_axis
);

    localparam WRITE = 1'b0;
    localparam READ  = 1'b1;

    logic [I2C_DATA_WIDTH-1:0] data_o;
    logic [I2C_DATA_WIDTH-1:0] saved_data;
    logic [I2C_ADDR_WIDTH-1:0] saved_addr;
    logic [CNT_WIDTH-1:0     ] cnt;
    logic                      rw;
    logic                      i2c_scl_en;

    enum logic [2:0] {
        IDLE      = 3'b000,
        START     = 3'b001,
        ADDR      = 3'b010,
        RW        = 3'b011,
        WACK_ADDR = 3'b100,
        DATA      = 3'b101,
        WACK_DATA = 3'b110,
        STOP      = 3'b111
    } state;

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            state <= IDLE;
            cnt   <= '0;
        end else begin
            case (state)
                IDLE: begin
                    if (s_axis.tvalid) begin
                        state      <= START;
                        saved_data <= s_axis.tdata[AXIS_DATA_WIDTH-1:I2C_DATA_WIDTH];
                        saved_addr <= s_axis.tdata[I2C_ADDR_WIDTH-1:0];
                        rw         <= s_axis.tdata[I2C_ADDR_WIDTH];
                        i2c_sda_en <= WRITE;
                    end
                end
                START: begin
                    state  <= ADDR;
                    wr_bit <= 1'b0;
                end
                ADDR: begin
                    wr_bit <= saved_addr[cnt];
                    cnt    <= cnt + 1'b1;
                    if (cnt == I2C_ADDR_WIDTH - 1) begin
                        state <= RW;
                        cnt   <= '0;
                    end
                end
                RW: begin
                    state  <= WACK_ADDR;
                    wr_bit <= rw;
                end
                WACK_ADDR: begin
                    state      <= DATA;
                    i2c_sda_en <= (rw) ? READ : WRITE;
                end
                DATA: begin
                    if (rw == WRITE) begin
                        wr_bit <= saved_data[cnt];
                        cnt    <= cnt + 1'b1;
                        if (cnt == I2C_DATA_WIDTH - 1) begin
                            state <= WACK_DATA;
                            cnt   <= '0;
                        end
                    end else if (rw == READ) begin
                        data_o[cnt] <= rd_bit;
                        cnt         <= cnt + 1'b1;
                        if (cnt == I2C_DATA_WIDTH - 1) begin
                            state <= WACK_DATA;
                            cnt   <= '0;
                        end
                    end
                end
                WACK_DATA: begin
                    state      <= STOP;
                    i2c_sda_en <= WRITE;
                end
                STOP: begin
                    state  <= IDLE;
                    wr_bit <= 1'b1;
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

    always_comb begin
        s_axis.tready = (state == START);
        i2c_scl       = i2c_scl_en ? ~clk_i : 1'b1;
    end

endmodule

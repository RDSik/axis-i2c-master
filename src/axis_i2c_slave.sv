`include "axis_i2c_pkg.svh"

module axis_i2c_slave
    import axis_i2c_pkg::*;
(
    input  logic                      clk_i,
    input  logic                      arstn_i,
    // input  logic                      rd_bit,
    // output logic                      wr_bit,
    // output logic                      i2c_sda_en,
    inout                             i2c_sda_io,
    output logic                      i2c_scl_o,
    output logic [I2C_DATA_WIDTH-1:0] i2c_rdata_o,
    output logic                      rvalid_o,

    axis_if.slave s_axis
);

    localparam WRITE = 1'b0;
    localparam READ  = 1'b1;

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
    logic [I2C_DATA_WIDTH-1:0] data_reg;
    logic [I2C_DATA_WIDTH-1:0] addr_reg;
    logic [CNT_WIDTH-1:0     ] cnt;
    logic                      cnt_done;
    logic                      i2c_scl_en;

    logic rd_bit;
    logic wr_bit;
    logic i2c_sda_en;

    IOBUF iobuf_inst (
        .O  (rd_bit    ),  // Buffer output
        .IO (i2c_sda_io),  // Buffer inout port
        .I  (wr_bit    ),  // Buffer input
        .T  (i2c_sda_en)   // 3-state enable input, high=input, low=output
     );

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (s_axis.tvalid) begin
                        state      <= START;
                        data_reg   <= s_axis.tdata[AXIS_DATA_WIDTH-1:I2C_DATA_WIDTH];
                        addr_reg   <= s_axis.tdata[I2C_DATA_WIDTH-1:0];
                        i2c_sda_en <= WRITE;
                    end
                end
                START: begin
                    state  <= ADDR;
                    wr_bit <= 1'b0;
                end
                ADDR: begin
                    wr_bit <= addr_reg[cnt];
                    if (cnt_done) state <= WACK_ADDR;
                end
                WACK_ADDR: begin
                    state      <= DATA;
                    i2c_sda_en <= (s_axis.tdata[I2C_RW_BIT]) ? READ : WRITE;
                end
                DATA: begin
                    if (s_axis.tdata[I2C_RW_BIT] == WRITE) begin
                        wr_bit <= data_reg[cnt];
                        if (cnt_done) state <= WACK_DATA;
                    end else if (s_axis.tdata[I2C_RW_BIT] == READ) begin
                        rd_data[cnt] <= rd_bit;
                        if (cnt_done) begin
                            state       <= WACK_DATA;
                            i2c_rdata_o <= rd_data;
                        end
                    end
                end
                WACK_DATA: begin
                    state       <= STOP;
                    i2c_sda_en  <= WRITE;
                end
                STOP: begin
                    state  <= IDLE;
                    wr_bit <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            cnt <= '0;
        end else if ((state == DATA) || (state == ADDR)) begin
            cnt <= cnt - 1'b1;
        end else if ((state == WACK_ADDR) || (state == START)) begin
            cnt <= I2C_DATA_WIDTH - 1;
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
        rvalid_o      = (state == WACK_ADDR) && (s_axis.tdata[I2C_RW_BIT] == READ);
        cnt_done      = ~(|cnt);
    end

endmodule

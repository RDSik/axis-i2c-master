`include "axis_i2c_pkg.svh"

import axis_i2c_pkg::*;

module axis_i2c_slave (
    input  logic clk,
    input  logic arstn,
    output logic scl,
    output logic sda,

    axis_if.slave s_axis
);

    logic [AXIS_DATA_WIDTH-1:0] saved_data;
    logic [CNT_WIDTH-1:0      ] cnt;
    logic                       scl_en;

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

    always_ff @(posedge clk or negedge arstn) begin
        if (~arstn) state <= IDLE;
        else begin
            case (state)
                IDLE: if (s_axis.tvalid) begin
                    state      <= START;
                    saved_data <= s_axis.tdata;
                end
                START: state <= ADDR;
                ADDR: if (cnt == I2C_ADDR_WIDTH) state <= RW;
                RW: state <= WACK_ADDR;
                WACK_ADDR: state <= DATA;
                DATA: if (cnt == I2C_DATA_WIDTH) state <= WACK_DATA;
                WACK_DATA: state <= STOP;
                STOP: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    always_ff @(posedge clk or negedge arstn) begin
        if (~arstn) cnt <= 0;
        else begin
            if ((s_axis.tready & s_axis.tvalid) && (state == ADDR || state == RW || state == DATA)) cnt <= cnt + 1;
            if (state == DATA && cnt == AXIS_DATA_WIDTH) cnt <= 0;
        end
    end

    always_ff @(negedge clk) begin
        if (~arstn) begin
            scl_en <= 0;
        end else begin
            if ((state == IDLE) || (state == START) || (state == STOP)) begin
                scl_en <= 0;
            end else begin
                scl_en <= 1;
            end
        end
    end

    always_comb begin
        s_axis.tready = (arstn == 1) && (state == START) ? 1 : 0;
        scl           = scl_en ? ~clk : 1;
        case (state)
            IDLE:      sda = 1;
            START:     sda = 0;
            ADDR:      sda = saved_data[cnt];
            RW:        sda = saved_data[cnt];
            WACK_ADDR: sda = 0;
            DATA:      sda = saved_data[cnt];
            WACK_DATA: sda = 0;
            STOP:      sda = 1;
            default:   sda = 1;
        endcase
    end

endmodule

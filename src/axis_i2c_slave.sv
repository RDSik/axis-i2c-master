module axis_i2c_slave #(
    parameter I2C_ADDR_WIDTH  = 7,
    parameter I2C_DATA_WIDTH  = 8,
    parameter AXIS_DATA_WIDTH = I2C_DATA_WIDTH * 2
) (
    input  logic clk,
    input  logic arstn,
    output logic scl,
    output logic sda,

    axis_if.slave s_axis
);

    localparam CNT_WIDTH = $clog2(AXIS_DATA_WIDTH);

    (* keep = "true" *) logic [AXIS_DATA_WIDTH-1:0] saved_data;
    (* keep = "true" *) logic [CNT_WIDTH-1:0      ] cnt;
    (* keep = "true" *) logic                       scl_en;

    (* keep = "true" *) enum logic [2:0] {
        IDLE      = 3'b000,
        READY     = 3'b001,
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
                    state      <= READY;
                    saved_data <= s_axis.tdata;
                end
                READY: if (s_axis.tvalid) state <= ADDR;
                ADDR: if (s_axis.tvalid) begin
                    if (cnt == I2C_ADDR_WIDTH - 1) state <= RW;
                end
                RW: if (s_axis.tvalid) state <= WACK_ADDR;
                WACK_ADDR: if (s_axis.tvalid) state <= DATA;
                DATA: if (s_axis.tvalid) begin
                    if (cnt == AXIS_DATA_WIDTH - 1) state <= WACK_DATA;
                end
                WACK_DATA: if (s_axis.tvalid) state <= STOP;
                STOP: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    always_ff @(posedge clk or negedge arstn) begin
        if (~arstn) cnt <= 0;
        else begin
            if (state == ADDR || state == RW || state == DATA) cnt <= cnt + 1;
            if (state == STOP) cnt <= 0;
        end
    end

    always_ff @(negedge clk or negedge arstn) begin
        if (~arstn) begin
            scl_en <= 0;
        end else begin
            if ((state == IDLE) || (state == READY) || (state == STOP)) begin
                scl_en <= 0;
            end else begin
                scl_en <= 1;
            end
        end
    end

    always_comb begin
        s_axis.tready = (state == READY);
        scl           = scl_en ? ~clk : 1;
        case (state)
            IDLE:      sda = 1;
            READY:     sda = 0;
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

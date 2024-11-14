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

    (* keep = "true" *) logic [AXIS_DATA_WIDTH-1:0        ] saved_data;
    (* keep = "true" *) logic [$clog2(AXIS_DATA_WIDTH)-1:0] cnt;
    (* keep = "true" *) logic                               scl_en;

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
        if (~arstn) begin
            state <= IDLE;
            cnt   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    sda <= 1;
                    if (s_axis.tvalid) begin
                        state      <= READY;
                        saved_data <= s_axis.tdata;
                    end
                end
                READY: begin
                    state <= ADDR;
                    sda   <= 0;
                end
                ADDR: begin
                    sda <= saved_data[cnt];
                    cnt <= cnt + 1;
                    if (cnt == I2C_ADDR_WIDTH - 1) state <= RW;
                end
                RW: begin
                    state <= WACK_ADDR;
                    sda   <= saved_data[cnt];
                    cnt   <= cnt + 1;
                end
                WACK_ADDR: begin
                    state <= DATA;
                    sda   <= 0;
                end
                DATA: begin
                    sda <= saved_data[cnt];
                    if (cnt == AXIS_DATA_WIDTH - 1) state <= WACK_DATA;
                    else cnt <= cnt + 1;
                end
                WACK_DATA: begin
                    state <= STOP;
                    sda   <= 0;
                end
                STOP: begin
                    state <= IDLE;
                    sda   <= 1;
                    cnt   <= 0;
                end
                default: state <= IDLE;
            endcase
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
    end

endmodule

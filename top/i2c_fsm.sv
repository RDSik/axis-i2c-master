module i2c_fsm #(
    parameter DATA_WIDTH = 8,    
    parameter ADDR_WIDTH = 7
) (
    input  logic                  clk,
    input  logic                  arst,    
    input  logic                  start,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] data,
    output logic                  ready,
    output logic                  sda,
    output logic                  scl
);

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

logic [ADDR_WIDTH-1:0]         saved_addr;
logic [DATA_WIDTH-1:0]         saved_data;
logic [$clog2(DATA_WIDTH)-1:0] cnt;
logic                          scl_en;

always_ff @(posedge clk or posedge arst) begin
    if (arst) begin
        state      <= IDLE;
        cnt        <= 0;
        saved_addr <= 0;
        saved_data <= 0;        
    end 
    else begin
        case (state)
            IDLE: begin
                sda <= 1;
                if (start) begin
                    state      <= START;
                    saved_addr <= addr;
                    saved_data <= data;
                end
                else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= ADDR;
                sda   <= 0;
                cnt   <= ADDR_WIDTH - 1;
            end
            ADDR: begin
                sda <= saved_addr[cnt];
                if (cnt == 0) begin
                    state <= RW;
                end
                else begin
                    cnt <= cnt - 1;
                end
            end
            RW: begin
                state <= WACK_ADDR;
                sda   <= 1;                
            end
            WACK_ADDR: begin
                state <= DATA;
                cnt   <= DATA_WIDTH - 1;
            end
            DATA: begin
                sda <= saved_data[cnt];
                if (cnt == 0) begin
                    state <= WACK_DATA;
                end
                else begin
                    cnt <= cnt - 1;
                end
            end
            WACK_DATA: begin
                state <= STOP;
            end
            STOP: begin
                state <= IDLE;
                sda   <= 1;
            end
            default: state <= IDLE;
        endcase
    end
end

always_ff @(negedge clk) begin
    if (arst) begin
        scl_en <= 0;
    end
    else begin
        if ((state == IDLE) || (state == START) || (state == STOP)) begin
            scl_en <= 0;
        end
        else begin
            scl_en <= 1;
        end
    end
end

assign ready = ((arst == 0) && (state == IDLE)) ? 1 : 0;

assign scl = scl_en ? ~clk : 1;

endmodule
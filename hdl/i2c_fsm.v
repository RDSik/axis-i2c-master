module i2c_fsm #(
    parameter DATA_WIDTH = 8,    
    parameter ADDR_WIDTH = 7
) (
    input  wire                  clk,
    input  wire                  arst,    
    input  wire                  start,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] data,
    output wire                  ready,
    output wire                  scl,
    output reg                   sda
);

localparam [2:0] IDLE      = 3'b000,
                 START     = 3'b001,
                 ADDR      = 3'b010,
                 RW        = 3'b011,
                 WACK_ADDR = 3'b100,
                 DATA      = 3'b101,
                 WACK_DATA = 3'b110,
                 STOP      = 3'b111;

reg [ADDR_WIDTH-1:0]         saved_addr;
reg [DATA_WIDTH-1:0]         saved_data;
reg [$clog2(DATA_WIDTH)-1:0] cnt;
reg                          scl_en;
reg [2:0]                    state;

always @(posedge clk or posedge arst) begin
    if (arst) begin
        state      <= IDLE;
        sda        <= 1;
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

always @(negedge clk) begin
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
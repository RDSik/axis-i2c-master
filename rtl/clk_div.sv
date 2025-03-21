module clk_div #(
    parameter CLK_IN  = 100_000_000,
    parameter CLK_OUT = 200_000
) (
    input  logic clk_i,
    input  logic arstn_i,
    input  logic bypass_i,
    input  logic en_i,
    output logic clk_o
);

localparam DIVIDER   = CLK_IN/CLK_OUT;
localparam CNT_WIDTH = $clog2(DIVIDER);

logic [CNT_WIDTH-1:0] cnt;

always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        cnt <= '0;
    end else if (en_i) begin
        cnt <= (cnt == DIVIDER - 1) ? '0 : cnt + 1'b1;
    end
end

assign clk_o = (bypass_i) ? clk_i : cnt[CNT_WIDTH-1];

endmodule

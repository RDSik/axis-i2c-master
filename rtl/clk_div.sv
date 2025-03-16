module clk_div #(
    parameter CLK_IN  = 100_000_000,
    parameter CLK_OUT = 200_000
) (
    input  logic clk_i,
    input  logic arstn_i,
    input  logic en_i,
    output logic clk_o
);

localparam RATIO     = CLK_IN/CLK_OUT;
localparam CNT_WIDTH = $clog2(RATIO);

logic [CNT_WIDTH-1:0] cnt;

always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        cnt <= '0;
    end else begin
        cnt <= (cnt == RATIO - 1) ? '0 : cnt + 1'b1;
    end
end

assign clk_o = (en_i) ? cnt[CNT_WIDTH-1] : clk_i;

endmodule

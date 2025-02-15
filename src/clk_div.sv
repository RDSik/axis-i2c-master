module clk_div #(
    parameter CLK_IN  = 100_000_000,
    parameter CLK_OUT = 200_000
) (
    input  logic clk_i,
    input  logic arstn_i,
    input  logic en_i,
    output logic clk_o
);

localparam RATIO = CLK_IN/CLK_OUT;

logic [$clog2(RATIO)-1:0] cnt;
logic                     clk;

always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        cnt <= '0;
    end else if (cnt == RATIO - 1) begin
        cnt <= '0;
    end else begin
        cnt <= cnt + 1;
    end
end

always_ff @(posedge clk_i or negedge arstn_i) begin
    if (~arstn_i) begin
        clk <= 1'b0;
    end else if (cnt == RATIO - 1) begin
        clk <= 1'b0;
    end else if (cnt == (RATIO/2) - 1) begin
        clk <= 1'b1;
    end
end

assign clk_o = (en_i) ? clk : clk_i;

endmodule

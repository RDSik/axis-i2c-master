module clk_div #(
    parameter CLK_IN  = 100_000_000,
    parameter CLK_OUT = 200_000,
    parameter BYPASS  = 0,
    parameter XILINX  = 0
) (
    input  logic clk_i,
    input  logic arstn_i,
    input  logic en_i,
    output logic clk_o
);


generate;
    if (BYPASS == 1) begin
        assign clk_o = clk_i;
    end else begin
        localparam DIVIDER   = CLK_IN/CLK_OUT;
        localparam CNT_WIDTH = $clog2(DIVIDER);

        logic [CNT_WIDTH-1:0] cnt;
        logic                 clk;

        always_ff @(posedge clk_i or negedge arstn_i) begin
            if (~arstn_i) begin
                cnt <= '0;
                clk <= '0;
            end else if (en_i) begin
                if (cnt == CNT_WIDTH'(DIVIDER-1)) begin
                    cnt <= '0;
                    clk <= ~clk;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end

        if (XILINX == 1) begin
            BUFG i_BUFG (.I (clk), .O (clk_o));
        end else begin
            assign clk_o = clk;
        end
    end
endgenerate

endmodule

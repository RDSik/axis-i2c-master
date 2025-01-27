`include "axis_i2c_pkg.svh"

module axis_data_gen
    import axis_i2c_pkg::*;
#(
    parameter AXIS_MEM = "axis_data.mem"
) (
    input  logic clk_i,
    input  logic arstn_i,

    axis_if.master m_axis
);

    logic [CNT_WIDTH-1:0] cnt;

    logic [AXIS_DATA_WIDTH-1:0] axis_mem [CNT_WIDTH-1:0];

    initial $readmemh(AXIS_MEM, axis_mem);

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            m_axis.tvalid <= 1'b0;
            m_axis.tdata  <= '0;
            cnt           <= '0;
        end else begin
            m_axis.tvalid <= 1'b1;
            m_axis.tdata  <= axis_mem[cnt];
            if (m_axis.tvalid & m_axis.tready) cnt <= cnt + 1'b1;
        end
    end

endmodule

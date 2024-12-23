`include "axis_i2c_pkg.svh"

module axis_data_gen 
    import axis_i2c_pkg::*;
#(
    parameter AXIS_MEM = "axis_data.mem"
) (
    input  logic clk,
    input  logic arstn,

    axis_if.master m_axis
);

    logic [CNT_WIDTH-1:0] cnt;

    logic [CNT_WIDTH-1:0] axis_mem [AXIS_DATA_WIDTH-1:0];

    initial $readmemh(AXIS_MEM, axis_mem);

    always_ff @(posedge clk or negedge arstn) begin
        if (~arstn) begin
            m_axis.tvalid <= 0;
            m_axis.tdata  <= 0;
            cnt           <= 0;
        end else begin
            m_axis.tvalid <= 1;
            m_axis.tdata  <= axis_mem[cnt];
            if (m_axis.tvalid & m_axis.tready) cnt <= cnt + 1;
        end
    end

endmodule

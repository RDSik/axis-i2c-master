`include "axis_i2c_pkg.svh"

module axis_i2c_top
    import axis_i2c_pkg::*;
#(
    parameter MAIN_CLK = axis_i2c_pkg::MAIN_CLK,
    parameter I2C_CLK  = axis_i2c_pkg::I2C_CLK,
    parameter BYPASS   = 0
) (
    input  logic                       clk_i,
    input  logic                       arstn_i,
    inout                              i2c_sda_io,
    output logic                       i2c_scl_o,
    output logic [I2C_DATA_WIDTH-1:0]  i2c_rdata_o,
    output logic                       rvalid_o,

    input  logic [AXIS_DATA_WIDTH-1:0] s_axis_tdata,
    input  logic                       s_axis_tvalid,
    output logic                       s_axis_tready
);

    axis_if m_axis();

    logic i2c_clk;

    axis_i2c_slave i2c_inst (
        .clk_i       (i2c_clk    ),
        .arstn_i     (arstn_i    ),
        .i2c_scl_o   (i2c_scl_o  ),
        .i2c_sda_io  (i2c_sda_io ),
        .i2c_rdata_o (i2c_rdata_o),
        .rvalid_o    (rvalid_o   ),
        .s_axis      (m_axis     )
    );

    clk_div #(
        .CLK_IN  (MAIN_CLK),
        .CLK_OUT (I2C_CLK ),
        .BYPASS  (BYPASS  )
    ) clk_div_inst (
        .clk_i   (clk_i  ),
        .arstn_i (arstn_i),
        .clk_o   (i2c_clk)
    );

    axis_data_fifo fifo_inst (
        .s_axis_aresetn (arstn_i      ),
        .s_axis_aclk    (clk_i        ),
        .s_axis_tvalid  (s_axis_tvalid),
        .s_axis_tready  (s_axis_tready),
        .s_axis_tdata   (s_axis_tdata ),
        .m_axis_tvalid  (m_axis.tvalid),
        .m_axis_tready  (m_axis.tready),
        .m_axis_tdata   (m_axis.tdata )
    );

    `ifdef COCOTB_SIM
        initial begin
            $dumpfile ("axis_i2c_top.vcd");
            $dumpvars (0, axis_i2c_top);
            #1;
        end
    `endif

endmodule

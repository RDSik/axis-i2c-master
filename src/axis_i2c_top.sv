module axis_i2c_top #(
    `ifdef VERILATOR
    parameter FIFO_DEPTH     = 4,
    `endif
    parameter DATA_WIDTH     = 16,
    parameter I2C_DATA_WIDTH = 8,
    parameter MAIN_CLK       = 100_000_000,
    parameter I2C_CLK        = 200_000
) (
    input  logic                       clk_i,
    input  logic                       arstn_i,
    input  logic                       en_i,
    inout                              i2c_sda_io,
    output logic                       i2c_scl_o,

    output logic [I2C_DATA_WIDTH-1:0]  m_axis_tdata,
    output logic                       m_axis_tvalid,
    input  logic                       m_axis_tready,

    `ifdef VERILATOR
    axis_if.slave s_axis
    `else
    input  logic [DATA_WIDTH-1:0]      s_axis_tdata,
    input  logic                       s_axis_tvalid,
    output logic                       s_axis_tready
    `endif
);

axis_if axis();

logic i2c_clk;

axis_i2c_master #(
    .DATA_WIDTH (I2C_DATA_WIDTH)
) i_axis_i2c_master (
    .clk_i         (i2c_clk      ),
    .arstn_i       (arstn_i      ),
    .i2c_scl_o     (i2c_scl_o    ),
    .i2c_sda_io    (i2c_sda_io   ),
    .m_axis_tdata  (m_axis_tdata ),
    .m_axis_tvalid (m_axis_tvalid),
    .m_axis_tready (m_axis_tready),
    .s_axis        (axis         )
);

clk_div #(
    .CLK_IN  (MAIN_CLK),
    .CLK_OUT (I2C_CLK )
) i_clk_div (
    .clk_i   (clk_i  ),
    .arstn_i (arstn_i),
    .en_i    (en_i   ),
    .clk_o   (i2c_clk)
);

`ifdef VERILATOR
axis_fifo #(
    .DATA_WIDTH (DATA_WIDTH),
    .FIFO_DEPTH (FIFO_DEPTH)
) i_axis_fifo (
    .clk_i   (clk_i  ),
    .arstn_i (arstn_i),
    .s_axis  (s_axis ),
    .m_axis  (axis   )
);
`else
axis_data_fifo i_axis_data_fifo (
    .s_axis_aresetn (arstn_i      ),
    .s_axis_aclk    (clk_i        ),
    .s_axis_tvalid  (s_axis_tvalid),
    .s_axis_tready  (s_axis_tready),
    .s_axis_tdata   (s_axis_tdata ),
    .m_axis_tvalid  (axis.tvalid  ),
    .m_axis_tready  (axis.tready  ),
    .m_axis_tdata   (axis.tdata   )
);
`endif

`ifdef COCOTB_SIM
    initial begin
        $dumpfile ("axis_i2c_top.vcd");
        $dumpvars (0, axis_i2c_top);
        #1;
    end
`endif

endmodule

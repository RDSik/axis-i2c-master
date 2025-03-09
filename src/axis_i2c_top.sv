module axis_i2c_top #(
    parameter DATA_WIDTH     = 16,
    parameter I2C_DATA_WIDTH = 8,
    parameter MAIN_CLK       = 27_000_000,
    parameter I2C_CLK        = 400_000,
    parameter CONFIG_MEM     = "../../src/config.mem",
    parameter MEM_DEPTH      = 24
) (
    input  logic clk_i,
    input  logic arstn_i,
    inout        i2c_sda_io,
    output logic i2c_scl_o
);

axis_if #(.DATA_WIDTH (DATA_WIDTH))     s_axis();
axis_if #(.DATA_WIDTH (I2C_DATA_WIDTH)) m_axis();

logic i2c_clk;

axis_i2c_master #(
    .DATA_WIDTH (I2C_DATA_WIDTH)
) i_axis_i2c_master (
    .clk_i         (i2c_clk      ),
    .arstn_i       (arstn_i      ),
    .i2c_scl_o     (i2c_scl_o    ),
    .i2c_sda_io    (i2c_sda_io   ),
    .s_axis        (s_axis.slave ),
    .m_axis        (m_axis.master)
);

axis_data_gen #(
    .CONFIG_MEM (CONFIG_MEM),
    .MEM_DEPTH  (MEM_DEPTH ),
    .MEM_WIDTH  (DATA_WIDTH)
) i_axis_data_gen (
    .clk_i   (i2c_clk      ),
    .arstn_i (arstn_i      ),
    .m_axis  (s_axis.master)
);

clk_div #(
    .CLK_IN  (MAIN_CLK),
    .CLK_OUT (I2C_CLK )
) i_clk_div (
    .clk_i   (clk_i  ),
    .arstn_i (arstn_i),
    .en_i    (1'b1   ),
    .clk_o   (i2c_clk)
);

`ifdef COCOTB_SIM
    initial begin
        $dumpfile ("axis_i2c_top.vcd");
        $dumpvars (0, axis_i2c_top);
        #1;
    end
`endif

endmodule

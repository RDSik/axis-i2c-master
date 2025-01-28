`include "axis_i2c_pkg.svh"

module axis_i2c_top
    import axis_i2c_pkg::*;
(
    input  logic                      clk_i,
    input  logic                      arstn_i,
    inout                             i2c_sda_io,
    output logic                      i2c_scl_o,
    output logic [I2C_DATA_WIDTH-1:0] i2c_rdata_o,
    output logic                      rvalid_o,

    axis_if.slave s_axis
);

    axis_if m_axis();

    // logic rd_bit;
    // logic wr_bit;
    // logic i2c_sda_en;

    // IOBUF iobuf_inst (
    //     .O  (rd_bit    ),  // Buffer output
    //     .IO (i2c_sda   ),  // Buffer inout port
    //     .I  (wr_bit    ),  // Buffer input
    //     .T  (i2c_sda_en)   // 3-state enable input, high=input, low=output
    //  );

    axis_i2c_slave i2c_inst (
        .clk_i       (clk_i      ),
        .arstn_i     (arstn_i    ),
        .i2c_scl_o   (i2c_scl_o  ),
        .i2c_sda_io  (i2c_sda_io ),
        // .i2c_sda_en  (i2c_sda_en ),
        // .rd_bit      (rd_bit     ),
        // .wr_bit      (wr_bit     ),
        .i2c_rdata_o (i2c_rdata_o),
        .rvalid_o    (rvalid_o   ),
        .s_axis      (m_axis     )
    );

    axis_data_fifo fifo_inst (
        .s_axis_aresetn (arstn_i      ),
        .s_axis_aclk    (clk_i        ),
        .s_axis_tvalid  (s_axis.tvalid),
        .s_axis_tready  (s_axis.tready),
        .s_axis_tdata   (s_axis.tdata ),
        .m_axis_tvalid  (m_axis.tvalid),
        .m_axis_tready  (m_axis.tready),
        .m_axis_tdata   (m_axis.tdata )
    );

    // sync_fifo #(
        // .DATA_WIDTH (FIFO_DATA_WIDTH),
        // .FIFO_DEPTH (FIFO_DEPTH     )
    // ) fifo_inst (
        // .clk      (clk        ),
        // .arst     (arst       ),
        // .rd_en    (fifo_rd_en ),
        // .wr_en    (fifo_wr_en ),
        // .data_in  (fifo_data_i),
        // .data_out (fifo_data_o),
        // .empty    (fifo_empty ),
        // .full     (fifo_full  )
    // );

    `ifdef COCOTB_SIM
        initial begin
            $dumpfile ("axis_i2c_top.vcd");
            $dumpvars (0, axis_i2c_top);
            #1;
        end
    `endif

endmodule

module axis_i2c_top #(
    parameter AXIS_DATA_WIDTH = 16,
    parameter AXIS_MEM        = "axis_data.mem"
) (
    input  logic clk,
    input  logic arstn,
    output logic i2c_sda,
    output logic i2c_scl 
);

    axis_if s_axis();
    axis_if m_axis();

    (* keep = "true" *) logic [$clog2(AXIS_DATA_WIDTH)-1:0] cnt;

    (* keep = "true" *) logic [AXIS_DATA_WIDTH-1:0] axis_mem [AXIS_DATA_WIDTH-1:0];

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

    axis_i2c_slave #(
        .AXIS_DATA_WIDTH (AXIS_DATA_WIDTH)
    ) i2c_inst (
        .clk    (clk    ),
        .arstn  (arstn  ),
        .sda    (i2c_sda),
        .scl    (i2c_scl),
        .s_axis (s_axis )
    );
    
    axis_data_fifo fifo_inst (
        .s_axis_aresetn (arstn        ),
        .s_axis_aclk    (clk          ),
        .s_axis_tvalid  (m_axis.tvalid),
        .s_axis_tready  (m_axis.tready),
        .s_axis_tdata   (m_axis.tdata ),
        .m_axis_tvalid  (s_axis.tvalid),
        .m_axis_tready  (s_axis.tready),
        .m_axis_tdata   (s_axis.tdata )
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

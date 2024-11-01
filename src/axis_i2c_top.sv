`include "axis_i2c_pkg.svh"

import axis_i2c_pkg::*;

module axis_i2c_top (
    input  logic clk,
    input  logic arst,
    input  logic fifo_wr_en,
    input  logic fifo_rd_en,
    output logic fifo_full,
    output logic fifo_empty,
    output logic fsm_ready,
    output logic i2c_sda,
    output logic i2c_scl 
);

    axis_if axis();

    i2c_fsm i2c_inst (
        .clk   (clk              ),
        .arst  (arst             ),
        .start (fifo_rd_en       ),
        .addr  (fifo_data_o[6:0 ]),
        .data  (fifo_data_o[14:7]),
        .ready (fsm_ready        ),
        .sda   (i2c_sda          ),
        .scl   (i2c_scl          )
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
            $dumpfile ("i2c_top.vcd");
            $dumpvars (0, i2c_master);
            #1;
        end
    `endif

endmodule

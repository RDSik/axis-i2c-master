`ifndef AXIS_I2C_PKG
`define AXIS_I2C_PKG

package axis_i2c_pkg;

    localparam WRITE           = 0;
    localparam READ            = 1;
    localparam I2C_RW_BIT      = 7;
    localparam I2C_DATA_WIDTH  = 8;
    localparam AXIS_DATA_WIDTH = 16;
    localparam CNT_WIDTH       = $clog2(I2C_DATA_WIDTH);

endpackage

`endif

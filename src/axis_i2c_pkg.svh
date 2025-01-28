`ifndef AXIS_I2C_PKG
`define AXIS_I2C_PKG

package axis_i2c_pkg;

    parameter I2C_RW_BIT      = 7;
    parameter I2C_DATA_WIDTH  = 8;
    parameter AXIS_DATA_WIDTH = 16;
    parameter CNT_WIDTH       = $clog2(I2C_DATA_WIDTH);

endpackage

`endif

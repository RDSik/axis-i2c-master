`ifndef I2C_PKG
`define I2C_PKG

package axis_i2c_pkg;

    parameter I2C_DATA_WIDTH  = 8;
    parameter I2C_ADDR_WIDTH  = 7;
    parameter AXIS_DATA_WIDTH = I2C_DATA_WIDTH * 2;
    parameter CNT_WIDTH       = $clog2(AXIS_DATA_WIDTH);
    
endpackage

`endif
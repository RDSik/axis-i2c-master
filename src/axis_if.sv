`include "i2c_pkg.svh"

import i2c_pkg::AXIS_DATA_WIDTH;

interface axis_if;

    logic [AXIS_DATA_WIDTH-1:0] tdata;
    logic                       tvalid;
    logic                       tready;
    logic                       tlast;

    modport master (
        input  tready,
        output tdata,
        output tvalid,
        output tlast
    );

    modport slave (
        input  tdata,
        input  tvalid,
        input  tlast,
        output tready
    );

endinterface

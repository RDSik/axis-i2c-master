`include "axis_i2c_pkg.svh"

import axis_i2c_pkg::AXIS_DATA_WIDTH;

interface axis_if;
    
    logic [AXIS_DATA_WIDTH-1:0] tdata;
    logic                       tvalid;
    logic                       tready;

    modport master (
        input  tready,
        output tdata,
        output tvalid
    );

    modport slave (
        input  tdata,
        input  tvalid,
        output tready
    );

endinterface

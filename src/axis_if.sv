`include "axis_i2c_pkg.svh"

interface axis_if #(
    parameter DATA_WIDTH = axis_i2c_pkg::AXIS_DATA_WIDTH
);

    logic [DATA_WIDTH-1:0] tdata;
    logic                  tvalid;
    logic                  tready;

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

interface axis_if #(
    parameter DATA_WIDTH = 16
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

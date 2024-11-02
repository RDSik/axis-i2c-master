interface axis_if #(
    parameter AXIS_DATA_WIDTH = 16
);
    
    (* keep = "true" *) logic [AXIS_DATA_WIDTH-1:0] tdata;
    (* keep = "true" *) logic                       tvalid;
    (* keep = "true" *) logic                       tready;

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

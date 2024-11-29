`ifndef ENV_SV
`define ENV_SV

class environment;

    localparam CLK_PER = 2;

    local virtual axis_i2c_top_if dut_if;

    function new(virtual axis_i2c_top_if dut_if);
        this.dut_if = dut_if;
    endfunction

    task init();
        begin
            clock();
            repeat (10) begin
                reset();
                #(CLK_PER*100);
            end
        end
    endtask

    task clock();
        begin
            dut_if.clk = 0;
            forever begin
                #(CLK_PER/2) dut_if.clk = ~dut_if.clk;
            end
        end
    endtask
    
    task reset();
        begin
            dut_if.arstn = 0;
            $display("Reset at %g ns.", $time);
            #CLK_PER;
            dut_if.arstn = 1;
        end
    endtask

endclass

`endif

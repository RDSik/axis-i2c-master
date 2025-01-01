`ifndef ENV_SV
`define ENV_SV

class environment;

    local virtual axis_i2c_top_if dut_if;

    function new(virtual axis_i2c_top_if dut_if);
        this.dut_if = dut_if;
    endfunction

    task init();
        begin
            dut_if.clk = 0;
            repeat (10) begin
                reset();
                repeat (100) @(posedge dut_if.clk);
            end
        end
    endtask
    
    task reset();
        begin
            dut_if.arstn = 0;
            $display("Reset at %g ns.", $time);
            @(posedge dut_if.clk);
            dut_if.arstn = 1;
        end
    endtask

endclass

`endif

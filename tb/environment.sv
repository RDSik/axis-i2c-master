`ifndef ENV_SV
`define ENV_SV

class environment;

    local virtual axis_i2c_top_if dut_if;
    local virtual axis_if         s_axis;

    int clk_per;

    function new(virtual axis_i2c_top_if dut_if, virtual axis_if s_axis, int clk_per);
        this.dut_if  = dut_if;
        this.s_axis  = s_axis;
        this.clk_per = clk_per;
    endfunction

    task data_gen(int n);
        begin
            for (int i = 0; i < n; i++) begin
                wait(s_axis.tready);
                s_axis.tvalid = 1'b1;
                s_axis.tdata  = $urandom_range(0, (2**16)-1);
                $display("AXIS tansaction %0d done at: %g ns\n", i, $time);
                @(posedge dut_if.clk_i);
                s_axis.tvalid = 1'b0;
                s_axis.tdata  = '0;
            end
        end
    endtask

    task run();
        begin
            dut_if.en_i   = 1'b0;
            s_axis.tvalid = 1'b0;
            s_axis.tdata  = '0;
            rst_gen();
            data_gen(50);
            $display("Stop simulation at: %g ns\n", $time);
        end
    endtask

    task rst_gen();
        begin
            dut_if.arstn_i = 1'b0;
            $display("Reset at %g ns\n.", $time);
            @(posedge dut_if.clk_i);
            dut_if.arstn_i = 1'b1;
        end
    endtask

    task clk_gen();
        begin
            dut_if.clk_i = 1'b0;
            forever begin
                #(clk_per/2) dut_if.clk_i = ~dut_if.clk_i;
            end
        end
    endtask

endclass

`endif

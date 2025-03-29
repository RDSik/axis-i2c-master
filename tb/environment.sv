`ifndef ENV_SV
`define ENV_SV

class environment;

    local virtual axis_i2c_top_if dut_if;
    local virtual axis_if         s_axis;

    int clk_per;
    int sim_time;

    function new(virtual axis_i2c_top_if dut_if, virtual axis_if s_axis, int clk_per, int sim_time);
        this.dut_if   = dut_if;
        this.s_axis   = s_axis;
        this.clk_per  = clk_per;
        this.sim_time = sim_time;
    endfunction

    // task data_gen(int n);
    //     begin
    //         for (int i = 0; i < n; i++) begin
    //             @(posedge dut_if.clk_i);
    //             s_axis.tvalid = 1'b1;
    //             s_axis.tdata  = $urandom_range(0, (2**16)-1);
    //             $display("AXIS tansaction %0d done at: %g ns\n", i, $time);
    //             do begin
    //                 @(posedge dut_if.clk_i);
    //             end
    //             while (~s_axis.tready);
    //             s_axis.tvalid = 1'b0;
    //         end
    //     end
    // endtask

    task run();
        fork
            reset_gen();
            clock_gen(clk_per);
            // data_gen(50);
        join_none
        time_out(sim_time);
    endtask

    task reset_gen();
        begin
            dut_if.arstn_i = 1'b0;
            repeat ($urandom_range(1, 10)) @(posedge dut_if.clk_i);
            dut_if.arstn_i = 1'b1;
            $display("Reset done at %g ns\n", $time);
        end
    endtask

    task clock_gen(int clk_per);
        begin
            dut_if.clk_i = 1'b0;
            forever begin
                #(clk_per/2) dut_if.clk_i = ~dut_if.clk_i;
            end
        end
    endtask

    task time_out(int sim_time);
        begin
            repeat (sim_time) @(posedge dut_if.clk_i);
            $display("Stop simulation at: %g ns\n", $time);
            $stop();
        end
    endtask

endclass

`endif

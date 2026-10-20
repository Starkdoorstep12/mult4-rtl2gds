// Exhaustive self-checking testbench for mult_array (latency = 2 cycles)
`timescale 1ns/1ps
module tb_mult;
    reg        clk = 1'b0;
    reg        rst_n = 1'b0;
    reg  [3:0] a = 4'd0;
    reg  [3:0] b = 4'd0;
    wire [7:0] p;

    integer i, j;
    integer errors = 0;
    integer count  = 0;

    mult_array dut (.clk(clk), .rst_n(rst_n), .a(a), .b(b), .p(p));

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("mult.vcd");
        $dumpvars(0, tb_mult);

        // hold reset low for the first 2 cycles
        rst_n = 1'b0;
        repeat (2) @(posedge clk);
        #2 rst_n = 1'b1;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // drive shortly after a rising edge
                a = i;
                b = j;
                // edge 1: inputs registered, edge 2: product registered
                @(posedge clk);
                @(posedge clk);
                // compare a little after edge 2 (netlist flops have #1 clk-to-q)
                #2;
                count = count + 1;
                if (p !== i * j) begin
                    errors = errors + 1;
                    $display("MISMATCH: a=%0d b=%0d expected=%0d got=%0d", i, j, i * j, p);
                end
            end
        end

        if (errors == 0)
            $display("PASS: %0d vectors checked, 0 errors", count);
        else
            $display("FAIL: %0d vectors checked, %0d errors", count, errors);
        $finish;
    end
endmodule

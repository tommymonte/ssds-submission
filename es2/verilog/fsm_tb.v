`timescale 1ns / 1ps
`include "fsm.v"

module recognizer_tb;

    // Inputs
    reg x;
    reg clk;
    reg rst;

    // Outputs
    wire [1:0] z;

    // Instantiate the Unit Under Test (UUT)
    detector uut (
        .x(x), 
        .clk(clk), 
        .rst(rst)
        .z(z), 
    );

    `define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end


    initial begin

        $dumpfile("fsm_tb.vcd");
        $dumpvars(0, fsm_tb);

        // Initialize Inputs
        x = 0;
        clk = 0;
        rst = 0;

        // Reset the design
        rst = 1;
        #10;
        rst = 0;
        
        // Inizio della sequenza di test
        // I valori di 'x' vengono cambiati al fronte di discesa del clock
        // per evitare race condition.
        @(negedge clk) x = 1;
        @(negedge clk) x = 0;
        @(negedge clk) x = 1;
        @(negedge clk) x = 1;
        @(negedge clk) x = 0;
        @(negedge clk) x = 0;
        @(negedge clk) x = 1;
        @(negedge clk) x = 0;

        // Finish simulation
        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule
module detector (x, clk, rst, z);
    input x;
    input clk; 
    input rst;
    output reg z;
    reg [2:0] state;
    reg [2:0] next_state;
    
    parameter IDLE = 3'b000, S0 = 3'b001, S1 = 3'b010, S01 = 3'b011, S10 = 3'b100, S11 = 3'b100;
    
    reg [1:0] c_state, n_state;
    
    always @(posedge clk) begin 
        if (rst == 1) 
            c_state <= IDLE;
            z <= 0;
        else
            c_state <= n_state;
    end

    always @(state, x) begin
        case (c_state)
            IDLE: begin
                z = 0;
                if (x == 1) begin
                    n_state = S1;
                end else begin
                    n_state = IDLE;
                end
            end
            S1: begin
                z = 0;
                if (x == 1) begin
                    n_state = S11;
                end else begin 
                    n_state = IDLE;
                end
            end
            S10: begin
                z = 1;
                if (x == 1) begin
                    n_state = S01;
                end else begin 
                    n_state = S0;
                end
            end
            S01: begin
                z = 0;
                if (x == 1) begin
                    n_state = S1;
                end else begin 
                    n_state = S10;
                end
            end
            default: begin
                n_state = IDLE;
                z = 0;
            end
        endcase
    end
endmodule
`timescale 1ns / 1ps

module FlipFlop(clk, reset, d, q);
    input [7:0] d;
    input clk, reset;
    output reg [7:0] q;
    
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else
            q <= d;  
    end
    
endmodule
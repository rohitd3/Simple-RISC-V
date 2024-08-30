`timescale 1ns / 1ps

module mux21 (
    input S ,
    input[31:0] D1 ,
    input[31:0] D2 ,
    output reg [31:0] Y
    );
    
    always @(*)
    begin
    if (S==0)
        Y <= D1;
    else if (S==1) 
        Y <= D2;
    end
endmodule
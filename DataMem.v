`timescale 1ns / 1ps

module DataMem(
MemRead, MemWrite, addr, write_data, read_data
);

    //input output definitions
    input [8:0] addr;
    input [31:0] write_data;
    input MemWrite, MemRead;
    output reg [31:0] read_data;
    
    reg [31:0] memory [127:0];
    
    //initializations
    integer i;
    initial
    begin
        read_data = 0;
        for(i = 0; i < 128; i = i + 1)
            memory[i] = 0;
    end
    
    //behavior
    always @ (*)
    begin
        if (MemRead)
            read_data = memory[addr[7:2]];
        else
            read_data = 32'b0;     
        if (MemWrite)
            memory[addr[7:2]] = write_data;
    end
    
endmodule
`timescale 1ns / 1ps

module Controller (
    input [6:0] Opcode,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] ALUOp
);

// logic
always @(*) begin
    case (Opcode)
        7'b0110011: begin // R-type
            MemtoReg = 0;
            MemWrite = 0;
            MemRead = 0;
            ALUSrc = 0;
            RegWrite = 1;
            ALUOp = 2'b10;
        end
        7'b0010011: begin // I-type (addi)
            MemtoReg = 0;
            MemWrite = 0;
            MemRead = 0;
            ALUSrc = 1;
            RegWrite = 1;
            ALUOp = 2'b00;
        end
        7'b0000011: begin // Load
            MemtoReg = 1;
            MemWrite = 0;
            MemRead = 1;
            ALUSrc = 1;
            RegWrite = 1;
            ALUOp = 2'b01;
        end
        7'b0100011: begin // Store
            MemtoReg = 0;
            MemWrite = 1;
            MemRead = 0;
            ALUSrc = 1;
            RegWrite = 0;
            ALUOp = 2'b01;
        end
        default: begin
            ALUSrc = 0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            ALUOp = 2'b00;
        end
    endcase
end

endmodule

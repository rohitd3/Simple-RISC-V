`timescale 1ns / 1ps

module processor (
    input clk,
    input reset,
    output [31:0] Result
);

// interconnecting sub-modules
wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;
wire [1:0] ALUOp;
wire [3:0] ALUcc;
wire ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite;

// Instantiate Datapath
data_path datapath_inst (
    .clk(clk),
    .reset(reset),
    .reg_write(RegWrite),
    .mem2reg(MemtoReg),
    .alu_src(ALUSrc),
    .mem_write(MemWrite),
    .mem_read(MemRead),
    .alu_cc(ALUcc),
    .opcode(opcode),
    .funct7(funct7),
    .funct3(funct3),
    .alu_result(Result)
);

// Instantiate Controller
Controller controller_inst (
    .Opcode(opcode),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUOp(ALUOp)
);

// Instantiate ALUController
ALUController alucontroller_inst (
    .ALUOp(ALUOp),
    .Funct7(funct7),
    .Funct3(funct3),
    .Operation(ALUcc)
);

endmodule

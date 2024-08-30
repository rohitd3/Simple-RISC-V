`timescale 1ns / 1ps

module data_path #(
    parameter PC_W = 8,
    parameter INS_W = 32,
    parameter RF_ADDRESS = 5,
    parameter DATA_W = 32,
    parameter DM_ADDRESS = 9,
    parameter ALU_CC_W = 4
)(
    input clk,
    input reset,
    input reg_write,
    input mem2reg,
    input alu_src,
    input mem_write,
    input mem_read,
    input [ALU_CC_W-1:0] alu_cc,
    output [6:0] opcode,
    output [6:0] funct7,
    output [2:0] funct3,
    output [DATA_W-1:0] alu_result
);

    wire [INS_W-1:0] instruction;
    wire [DATA_W-1:0] reg_data1;
    wire [DATA_W-1:0] reg_data2;
    wire [DATA_W-1:0] imm_data;
    wire [DATA_W-1:0] alu_input2;
    wire [DATA_W-1:0] alu_out;
    wire [DATA_W-1:0] mem_data;
    wire [DATA_W-1:0] write_data;
    wire [PC_W-1:0] pc;
    wire [PC_W-1:0] next_pc;
    
    FlipFlop pc_ff (
        .clk(clk),
        .reset(reset),
        .d(next_pc),
        .q(pc)
    );

    InstMem instr_mem (
        .addr(pc),
        .instruction(instruction)
    );

     assign next_pc = pc + 4;
     
    wire [RF_ADDRESS-1:0] rd_rg_wrt_wire;
    wire [RF_ADDRESS-1:0] rd_rg_addr_wire1;
    wire [RF_ADDRESS-1:0] rd_rg_addr_wire2;
    assign rd_rg_wrt_wire = instruction[11:7];
    assign rd_rg_addr_wire1 = instruction[19:15];
    assign rd_rg_addr_wire2 = instruction[24:20];
    
    RegFile reg_file (
        .clk(clk),
        .reset(reset),
        .rg_wrt_en(reg_write),
        .rg_wrt_addr(rd_rg_wrt_wire),
        .rg_rd_addr1(rd_rg_addr_wire1),
        .rg_rd_addr2(rd_rg_addr_wire2),
        .rg_wrt_data(write_data),
        .rg_rd_data1(reg_data1),
        .rg_rd_data2(reg_data2)
    );

    ImmGen imm_gen (
        .InstCode(instruction),
        .ImmOut(imm_data)
    );

    ALU_32 alu (
        .A_in(reg_data1),
        .B_in(alu_input2),
        .ALU_Sel(alu_cc),
        .ALU_Out(alu_out),
        .Carry_Out(),
        .Zero(),
        .Overflow()
    );

    DataMem data_mem (
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .addr(alu_out[8:0]),
        .write_data(reg_data2),
        .read_data(mem_data)
    );

    wire [DATA_W-1:0] alu_src_mux_out;
    mux21 alu_src_mux (
        .S(alu_src),
        .D1(reg_data2),
        .D2(imm_data),
        .Y(alu_src_mux_out)
    );

    wire [DATA_W-1:0] mem_to_reg_mux_out;
    mux21 mem_to_reg_mux (
        .S(mem2reg),
        .D1(alu_out),
        .D2(mem_data),
        .Y(write_data)
    );

    assign alu_input2 = alu_src_mux_out;
    assign alu_result = alu_out;
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    
endmodule
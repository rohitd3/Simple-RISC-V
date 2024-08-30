
`timescale 1ns / 1ps

module RegFile(
    clk, reset, rg_wrt_en,
    rg_wrt_addr,
    rg_rd_addr1,
    rg_rd_addr2,
    rg_wrt_data,
    rg_rd_data1,
    rg_rd_data2
    );
    
//input output
    input clk, reset, rg_wrt_en;
    input [4:0] rg_wrt_addr, rg_rd_addr1, rg_rd_addr2;
    input [31:0] rg_wrt_data;
    output reg [31:0] rg_rd_data1, rg_rd_data2;
    
// memory
    reg [31:0] registers [31:0];
    integer i;
initial
begin
    for (i = 0; i < 32; i = i + 1)
    begin
      registers[i] = 32'b0;
    end
end
    
// module behavior
always @ (posedge clk or posedge reset)
begin
    if (reset == 1'b1)
    begin
      for (i = 0; i < 32; i = i + 1)
      begin
        registers[i] = 32'b0;
      end
    end
    else if (rg_wrt_en == 1'b1)
    begin
      registers[rg_wrt_addr] <= rg_wrt_data;
    end
end

always @ (*)
begin
    rg_rd_data1 = registers[rg_rd_addr1];
    rg_rd_data2 = registers[rg_rd_addr2];
end

endmodule
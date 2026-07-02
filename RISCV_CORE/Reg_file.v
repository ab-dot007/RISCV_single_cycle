`timescale 1ns / 1ps

`timescale 1ns / 1ps

module Reg_File(
    input clk,
    input RegWrite,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,

    input [31:0] WD3,

    output [31:0] RD1,
    output [31:0] RD2
);

reg [31:0] RegFile [31:0];


assign RD1 = (rs1 == 5'b00000) ? 32'b0 : RegFile[rs1];
assign RD2 = (rs2 == 5'b00000) ? 32'b0 : RegFile[rs2];

always @(posedge clk) begin

    if (RegWrite && rd != 0)
        RegFile[rd] <= WD3;
end

endmodule

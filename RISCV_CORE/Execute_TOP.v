`timescale 1ns / 1ps

module Execute_Top(
    input [31:0] RD1,
    input [31:0] RD2,
    input [31:0] ImmExt,
    input [31:0] PC,

    input A_sel,
    input ALUSrc,

    input [2:0] ALUControl,
    input Compare_Unsigned,
    input Shift_Arithmetic,

    output [31:0] SrcA,
    output [31:0] SrcB,
    output [31:0] ALUResult,
    output zero,
    output Less,
    output wire C,  // dummy carry wire
    output wire V,   // dummy overflow wire
    output wire N   // dummy negative wire

);



assign SrcA = (A_sel) ? PC : RD1;       // Operand A MUX

assign SrcB = (ALUSrc) ? ImmExt : RD2;      // Operand B MUX


ALU_allfn ALU_CORE (
    .A(SrcA),
    .B(SrcB),
    .ALU_Control(ALUControl),
    .Compare_Unsigned(Compare_Unsigned),
    .Shift_Arithmetic(Shift_Arithmetic),
    .Result(ALUResult),
    .Z(zero),
    .Less(Less),
    .C(C),
    .V(V),
    .N(N)
);

endmodule
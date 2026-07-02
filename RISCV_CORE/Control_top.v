`timescale 1ns / 1ps


module Control_Unit(
    input Z,
    input Less,
    input [6:0] Op,
    input [2:0] funct3,
    input [6:0] funct7,

    output RegWrite,
    output [2:0] ImmSrc,
    output ALUSrc,
    output A_sel,
    output MemWrite,
    output [1:0] ResultSrc,
    output Jump,
    output JumpReg,
    output BranchTaken,
    //output PCscr,
    output [2:0] ALUControl,
    output Compare_Unsigned,
    output Shift_Arithmetic
);

    // internal connection between Main Decoder and ALU Decoder
    wire [1:0] ALUOp;
    wire Branch;
    wire [2:0] Branchtype;


    Main_Decoder MD(
        //.zero(zero),
        .Op(Op),
        .funct3(funct3),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .A_sel(A_sel),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Branchtype(Branchtype),
        .Jump(Jump),
        .JumpReg(JumpReg),
        .ALUOp(ALUOp)
        //.PCscr(PCscr)
    );

    ALU_decoder AD(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(Op),
        .ALUControl(ALUControl),
        .Compare_Unsigned(Compare_Unsigned),
        .Shift_Arithmetic(Shift_Arithmetic)
    );

    Branch_Unit BU(
        .Branch(Branch),
        .Branchtype(Branchtype),
        .Z(Z),
        .Less(Less),
        .BranchTaken(BranchTaken)

    );

endmodule


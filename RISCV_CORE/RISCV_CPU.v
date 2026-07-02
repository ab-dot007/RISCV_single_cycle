`timescale 1ns / 1ps

module RISCV_CPU_CORE(
    input clk,
    input reset
);

// Internal Wires

// PC / Instruction
wire [31:0] PC;
wire [31:0] Instr;
wire [31:0] PCPlus4;

// Register File
wire [31:0] RD1;
wire [31:0] RD2;

// Immediate Generator
wire [31:0] ImmExt;

// Control Unit
wire RegWrite;
wire [2:0] ImmSrc;
wire ALUSrc;
wire A_sel;
wire MemWrite;
wire [1:0] ResultSrc;
wire Jump;
wire JumpReg;
wire BranchTaken;
wire [2:0] ALUControl;
wire Compare_Unsigned;
wire Shift_Arithmetic;

// Execute Stage
wire [31:0] SrcA;
wire [31:0] SrcB;
wire [31:0] ALUResult;
wire zero;
wire Less;
wire C;
wire V;
wire N;

// Memory / Writeback
wire [31:0] ReadData;
wire [31:0] WriteBackData;


assign PCPlus4 = PC + 32'd4;

// PC Control

PC_Control PC_UNIT(
    .clk(clk),
    .reset(reset),

    .Jump(Jump),
    .JumpReg(JumpReg),
    .Branch(BranchTaken),   // BranchTaken from Control Unit
    .Branchtype(Instr[14:12]),

    .Z(zero),
    .Less(Less),
    .ALUResult(ALUResult),

    .ImmExt(ImmExt),

    .PC(PC)
);

// Instruction Memory

Instr_Memory IMEM(
    .PC(PC),
    .Instr(Instr)
);

// Control Unit

Control_Unit CONTROL(
    .Z(zero),
    .Less(Less),
    .Op(Instr[6:0]),
    .funct3(Instr[14:12]),
    .funct7(Instr[31:25]),

    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .A_sel(A_sel),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Jump(Jump),
    .JumpReg(JumpReg),
    .BranchTaken(BranchTaken),
    .ALUControl(ALUControl),
    .Compare_Unsigned(Compare_Unsigned),
    .Shift_Arithmetic(Shift_Arithmetic)
);

// Immediate Generator

Imm_Gen IMMGEN(
    .Instr(Instr[31:7]),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
);

// Register File

Reg_File REGFILE(
    .clk(clk),
    .RegWrite(RegWrite),

    .rs1(Instr[19:15]),
    .rs2(Instr[24:20]),
    .rd(Instr[11:7]),

    .WD3(WriteBackData),

    .RD1(RD1),
    .RD2(RD2)
);

// Execute Stage

Execute_Top EXECUTE(
    .RD1(RD1),
    .RD2(RD2),
    .ImmExt(ImmExt),
    .PC(PC),

    .A_sel(A_sel),
    .ALUSrc(ALUSrc),

    .ALUControl(ALUControl),
    .Compare_Unsigned(Compare_Unsigned),
    .Shift_Arithmetic(Shift_Arithmetic),

    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUResult(ALUResult),
    .zero(zero),
    .Less(Less),
    .C(C),
    .V(V),
    .N(N)
);

// Memory + Writeback

MemWB_Top MEMWB(
    .clk(clk),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .funct3(Instr[14:12]),

    .ALUResult(ALUResult),
    .WriteDataMem(RD2),
    .PCPlus4(PCPlus4),

    .ReadData(ReadData),
    .WriteBackData(WriteBackData)
);

endmodule
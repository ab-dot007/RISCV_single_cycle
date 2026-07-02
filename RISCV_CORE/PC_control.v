`timescale 1ns / 1ps


module PC_Control(
    input clk,
    input reset,

    // From Control Unit
    input Jump,
    input JumpReg,
    input Branch,
    input [2:0] Branchtype,

    // From ALU
    input Z,
    input Less,
    input [31:0] ALUResult,

    // From Immediate Generator
    input [31:0] ImmExt,
    output  [31:0] PCPlus4,
    output reg [31:0] PC
    
);

//wire [31:0] PCPlus4;
wire [31:0] PCTarget;
wire [31:0] PCNext;

wire BranchTaken;
wire PCscr;

assign PCPlus4 = PC + 32'd4;

Branch_Unit BU(
    .Branch(Branch),
    .Branchtype(Branchtype),
    .Z(Z),
    .Less(Less),
    .BranchTaken(BranchTaken)
);

assign PCscr = Jump || BranchTaken;

assign PCTarget = (JumpReg) ? ALUResult : (PC + ImmExt);

assign PCNext = (PCscr) ? PCTarget : PCPlus4;

always @(posedge clk or posedge reset) begin
    if(reset)
        PC <= 32'b0;
    else
        PC <= PCNext;
end

endmodule
`timescale 1ns / 1ps


module Branch_Unit(
    input Branch,
    input [2:0] Branchtype,
    input Z,
    input Less,

    output reg BranchTaken
);

always @(*) begin

    // default no branch
    BranchTaken = 1'b0;

    if (Branch) begin
        case (Branchtype)

            3'b000: BranchTaken = Z;       // BEQ
            3'b001: BranchTaken = ~Z;      // BNE
            3'b100: BranchTaken = Less;    // BLT
            3'b101: BranchTaken = ~Less;   // BGE
            3'b110: BranchTaken = Less;    // BLTU
            3'b111: BranchTaken = ~Less;   // BGEU

            default: BranchTaken = 1'b0;

        endcase
    end

end

endmodule

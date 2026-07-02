`timescale 1ns / 1ps

module Main_Decoder(
    //input zero,   
    input [2:0] funct3,
    input [6:0] Op,

    output reg RegWrite,       //reg_write ON/OFF 
    output reg [2:0] ImmSrc,
    output reg ALUSrc,
    output reg A_sel,           // selects A or PC in ALUin(AUIPC)
    output reg MemWrite,
    output reg [1:0] ResultSrc,  //reg_write_data_selct
    output reg Branch,
    output reg [2:0] Branchtype,
    output reg Jump,
    output reg JumpReg,
    output reg [1:0] ALUOp
 
);
            ///////// CHECK BRANCH AND JUMP LOGIC #INCORRECT///////

always @(*) begin
//default: begin
            RegWrite   = 0;
            ImmSrc     = 3'b000;
            ALUSrc     = 0;
            A_sel      = 0;
            MemWrite   = 0;
            ResultSrc  = 2'b00;
            Branch     = 0;
            Branchtype = 3'b000;
            Jump       = 0;
            JumpReg    = 0;
            ALUOp      = 2'b00;
           // PCscr     = 0;
           //end

    case(Op)

        7'b0110011: begin
            RegWrite  = 1;
            ALUSrc    = 0;
            ResultSrc = 2'b00;
            ALUOp     = 2'b10;
        end

        7'b0010011: begin
            RegWrite  = 1;
            ImmSrc    = 3'b000;
            ALUSrc    = 1;
            ResultSrc = 2'b00;
            ALUOp     = 2'b10;
        end

        7'b0000011: begin
            RegWrite  = 1;
            ImmSrc    = 3'b000;
            ALUSrc    = 1;
            ResultSrc = 2'b01;
            ALUOp     = 2'b00;
        end

        7'b1100111: begin
            RegWrite  = 1;
            ImmSrc    = 3'b000;
            ALUSrc    = 1;
            ResultSrc = 2'b10;
            Jump      = 1;
            JumpReg  = 1'b1;   // use ALUResul
            ALUOp     = 2'b00;
           // PCscr     = 1;
        end

        7'b0100011: begin
            ImmSrc    = 3'b001;
            ALUSrc    = 1;
            MemWrite  = 1;
            ALUOp     = 2'b00;
        end

        7'b1100011: begin
            ImmSrc    = 3'b010;
            Branch    = 1;
            Branchtype = funct3;
            ALUOp     = 2'b01;
           // PCscr     = zero;
        end
        
        7'b0110111: begin
            RegWrite  = 1;
            ImmSrc    = 3'b011;
            ALUSrc    = 1;
            ResultSrc = 2'b00;
            ALUOp     = 2'b11;   // "NOT"excluded come back if breaks...
        end

        7'b0010111: begin
            RegWrite  = 1;
            ImmSrc    = 3'b011;
            ALUSrc    = 1;
            A_sel     = 1;
            ResultSrc = 2'b00;
            ALUOp     = 2'b00;
        end

        7'b1101111: begin
            RegWrite  = 1;
            ImmSrc    = 3'b100;
            ResultSrc = 2'b10;
            Jump      = 1;
            JumpReg  = 1'b0;    // use PC + ImmExt
            //PCscr     = 1;
        end

        

    endcase
end

endmodule




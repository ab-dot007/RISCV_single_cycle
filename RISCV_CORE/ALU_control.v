`timescale 1ns / 1ps
module ALU_decoder(

   
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] op,

    output [2:0] ALUControl,
    output Compare_Unsigned,
    output Shift_Arithmetic
);



wire [1:0] concatenation;

assign concatenation = {op[5], funct7[5]};


assign Compare_Unsigned =
        (funct3 == 3'b011) ||   // SLTU
        (funct3 == 3'b110) ||   // BLTU
        (funct3 == 3'b111);     // BGEU


assign Shift_Arithmetic =
        (funct3 == 3'b101) && funct7[5];



reg [2:0] ALUControl_reg;
assign ALUControl = ALUControl_reg;

always @(*) begin

    // default
    ALUControl_reg = 3'b000;

    case (ALUOp)
        default: ALUControl_reg = 3'b000;
        2'b00: begin
            // ADD (Load/Store/JALR/AUIPC)
            ALUControl_reg = 3'b000;
        end

        2'b01: begin
            // SUB / Branch compare
            ALUControl_reg = 3'b001;
        end

        2'b10: begin
         ALUControl_reg = 3'b000;
            case (funct3)
                default: ALUControl_reg = 3'b000;
                3'b000: begin
                    // ADD / SUB
                    if (concatenation == 2'b11)
                        ALUControl_reg = 3'b001; // SUB
                    else
                        ALUControl_reg = 3'b000; // ADD
                end

                3'b111: ALUControl_reg = 3'b010; // AND
                3'b110: ALUControl_reg = 3'b011; // OR
                3'b100: ALUControl_reg = 3'b100; // XOR
                3'b010,
                3'b011: ALUControl_reg = 3'b101; // SLT / SLTU
                3'b001: ALUControl_reg = 3'b110; // SLL
                3'b101: ALUControl_reg = 3'b111; // SRL / SRA

                

            endcase
          end

        2'b11: begin
            // LUI
            // Pass immediate directly (B operand)
            ALUControl_reg = 3'b000;
        end


    endcase

end

endmodule

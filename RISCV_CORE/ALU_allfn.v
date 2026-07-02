`timescale 1ns / 1ps

module ALU_allfn (A,B,Result,ALU_Control,Compare_Unsigned,Shift_Arithmetic,V,C,Z,N,Less);

    input  [31:0]A,B;
    input [2:0]ALU_Control;
    input Compare_Unsigned;  //mapped to ALU_controler out related to function3'bxxx
    input Shift_Arithmetic;  //mapped to ALU_controler out related to function7[5]
    output C,V,Z,N;
    output Less;            // NEW OUTPUT
    output reg [31:0]Result;

    wire Cout;
    wire [31:0]Sum;
    wire [31:0] Shift_A;

// adder 
assign {Cout,Sum} = (ALU_Control[0] == 1'b0) ? A + B :
                                          (A + ((~B)+1)) ;

//compare logic(fro signed and unsigned)
assign Less = (Compare_Unsigned) ? (~Cout) :(Sum[31] ^ V);
 

assign Shift_A = (Shift_Arithmetic) ? ($signed(A) >>> B[4:0]) : (A >> B[4:0]);



//always block for result sel (insted of ternary)

always @(*) begin
        case(ALU_Control)

            3'b000: Result = Sum;                      // ADD, ADDI, AUIPC, JALR, LW, LH, LB, LHU, LBU, SW, SH, SB
            3'b001: Result = Sum;                      // SUB, BEQ, BNE
            3'b010: Result = A & B;                   // AND, ANDI
            3'b011: Result = A | B;                   // OR, ORI
            3'b100: Result = A ^ B;                   //XOR, XORI
            3'b101: Result = {31'b0, Less};    // SLT, SLTI, SLTU, SLTIU, BLT, BGE, BLTU, BGEU
            3'b110: Result = (A << B[4:0]) ;    //SLL,SLLI
            3'b111: Result = Shift_A;
            default: Result = 32'b0;

        endcase

end 

    assign V = ((Sum[31] ^ A[31]) & 
                      (~(ALU_Control[0] ^ B[31] ^ A[31])) & (~ALU_Control[1]));
    assign C = ((~ALU_Control[1]) & Cout);
    assign Z = &(~Result);
    assign N = Result[31];


 endmodule

`timescale 1ns / 1ps

module Instr_Memory(
    input [31:0] PC,
    output [31:0] Instr
);


reg [31:0] Mem [0:63];


assign Instr = Mem[PC[31:2]];


initial begin
    $readmemh("programe.mem", Mem);
end
endmodule

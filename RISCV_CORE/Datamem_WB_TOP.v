`timescale 1ns / 1ps

module MemWB_Top(
    input clk,
    input MemWrite,
    input [1:0] ResultSrc,
    input [2:0] funct3,

    input [31:0] ALUResult,     // Address/ALUResult for WB
    input [31:0] WriteDataMem,  // RD2 for store       
    input [31:0] PCPlus4,       // for JAL/JALR

    output reg [31:0] ReadData,
    output reg [31:0] WriteBackData
);

// Data memory (256 x 32)

reg [31:0] DataMem [0:255];

wire [7:0] byte_offset;
assign byte_offset = ALUResult[1:0];

wire [31:0] MemWord;
assign MemWord = DataMem[ALUResult[9:2]];

// STORE logic

always @(posedge clk) begin
    if (MemWrite) begin
        case (funct3)

            3'b000: begin // SB
                case(byte_offset)
                    2'b00: DataMem[ALUResult[9:2]][7:0]   <= WriteDataMem[7:0];
                    2'b01: DataMem[ALUResult[9:2]][15:8]  <= WriteDataMem[7:0];
                    2'b10: DataMem[ALUResult[9:2]][23:16] <= WriteDataMem[7:0];
                    2'b11: DataMem[ALUResult[9:2]][31:24] <= WriteDataMem[7:0];
                endcase
            end

            3'b001: begin // SH
                if(byte_offset[1] == 1'b0)
                    DataMem[ALUResult[9:2]][15:0] <= WriteDataMem[15:0];
                else
                    DataMem[ALUResult[9:2]][31:16] <= WriteDataMem[15:0];
            end

            3'b010: begin // SW
                DataMem[ALUResult[9:2]] <= WriteDataMem;
            end

        endcase
    end
end

// LOAD formatter

always @(*) begin
ReadData = 32'b0;
    case (funct3)

        3'b000: begin // LB
            case(byte_offset)
                2'b00: ReadData = {{24{MemWord[7]}}, MemWord[7:0]};
                2'b01: ReadData = {{24{MemWord[15]}}, MemWord[15:8]};
                2'b10: ReadData = {{24{MemWord[23]}}, MemWord[23:16]};
                2'b11: ReadData = {{24{MemWord[31]}}, MemWord[31:24]};
            endcase
        end

        3'b001: begin // LH
            if(byte_offset[1] == 1'b0)
                ReadData = {{16{MemWord[15]}}, MemWord[15:0]};
            else
                ReadData = {{16{MemWord[31]}}, MemWord[31:16]};
        end

        3'b010: begin // LW
            ReadData = MemWord;
        end

        3'b100: begin // LBU
            case(byte_offset)
                2'b00: ReadData = {24'b0, MemWord[7:0]};
                2'b01: ReadData = {24'b0, MemWord[15:8]};
                2'b10: ReadData = {24'b0, MemWord[23:16]};
                2'b11: ReadData = {24'b0, MemWord[31:24]};
            endcase
        end

        3'b101: begin // LHU
            if(byte_offset[1] == 1'b0)
                ReadData = {16'b0, MemWord[15:0]};
            else
                ReadData = {16'b0, MemWord[31:16]};
        end

       
            

    endcase
end

// Writeback MUX

always @(*) begin
    case(ResultSrc)

        2'b00: WriteBackData = ALUResult;
        2'b01: WriteBackData = ReadData;
        2'b10: WriteBackData = PCPlus4;

        default: WriteBackData = 32'b0;

    endcase
end

endmodule
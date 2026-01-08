`timescale 1ns / 1ps

module MUX_DataMemory(
    input MemtoReg, // nhan tu control 
    input [15:0]read_data, // nhan tu data_memory
    input [15:0] ALU_result, // nhan tu ALU
    
    output [15:0] out
);
    assign out = (MemtoReg) ? read_data : ALU_result ;
endmodule
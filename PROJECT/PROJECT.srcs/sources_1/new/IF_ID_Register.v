`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:40:44 PM
// Design Name: 
// Module Name: IF_ID_Register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IF_ID_Register(
    input wire clk,
    input wire rst,
    input wire IF_ID_Write,           // Tu hazard detection unit
    
    // them cai nay
    input wire IF_ID_Flush,
    
    input wire [15:0] IF_pc,
    input wire [15:0] IF_pc_plus,     // PC+2 tu ADD_PC
    input wire [15:0] IF_instruction, // Instruction tu IM
    
    output reg [15:0] ID_pc,
    output reg [15:0] ID_pc_plus,
    output reg [15:0] ID_instruction
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_pc <= 16'h0000;
            ID_pc_plus <= 16'h0000;
            ID_instruction <= 16'hc000;
        end
        else if (IF_ID_Flush) begin
            ID_pc <= 16'h0000;
            ID_pc_plus <= 16'h0000;
            ID_instruction <= 16'hc000;
        end
        else if (IF_ID_Write) begin
            ID_pc <= IF_pc;
            ID_pc_plus <= IF_pc_plus;
            ID_instruction <= IF_instruction;
        end
        else begin
            ID_pc <= ID_pc;
            ID_pc_plus <= ID_pc_plus;
            ID_instruction <= ID_instruction;
        end
    end
  
endmodule

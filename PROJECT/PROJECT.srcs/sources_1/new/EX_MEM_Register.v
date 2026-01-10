`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:42:28 PM
// Design Name: 
// Module Name: EX_MEM_Register
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


module EX_MEM_Register(
    input wire clk,
    input wire rst,
    
    // tu ex stage
//    input wire [1:0] EX_PCSrc,
    input wire EX_memWrite,
    input wire EX_memRead,
    input wire EX_regWrite,
    input wire EX_memtoReg,
    input wire [1:0] EX_w_spec_regs,
//    input wire EX_hi_write,
//    input wire EX_lo_write,
    input wire EX_halt,
    
    input wire [15:0] EX_pc, // danh cho move from pc
    input wire [15:0] EX_pc_plus, //
    input wire [15:0] EX_alu_result, // ket qua alu
    input wire [15:0] EX_rd2, // data tu rt cho sw
//    input wire [15:0] EX_br_target, 
    input wire [2:0] EX_write_reg, // destination ne
    
    
    output reg MEM_memWrite,
    output reg MEM_memRead,
    output reg MEM_regWrite,
    output reg MEM_memtoReg,
    output reg [1:0] MEM_w_spec_regs,
//    output reg MEM_hi_write,
//    output reg MEM_lo_write,
    output reg MEM_halt,
    
    output reg [15:0] MEM_pc,
    output reg [15:0] MEM_pc_plus,
    output reg [15:0] MEM_alu_result,
    output reg [15:0] MEM_rd2,
//    output reg [15:0] MEM_br_target,
    output reg [2:0] MEM_write_reg
//    output reg [1:0] MEM_PCSrc    
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
//            MEM_PCSrc <= 2'b00;
            MEM_memWrite <= 1'b0;
            MEM_memRead <= 1'b0;
            MEM_regWrite <= 1'b0;
            MEM_memtoReg <= 1'b0;
            MEM_w_spec_regs <= 2'b10;
//            MEM_hi_write <= 1'b0;
//            MEM_lo_write <= 1'b0;
            MEM_halt <= 1'b0;
            
            MEM_pc <= 16'h0000;
            MEM_pc_plus <= 16'h0000;
            MEM_alu_result <= 16'h0000;
            MEM_rd2 <= 16'h0000;
//            MEM_br_target <= 16'h0000;
            MEM_write_reg <= 3'b000;
        end
        
        else begin
//            MEM_PCSrc <= EX_PCSrc;
            MEM_memWrite <= EX_memWrite;
            MEM_memRead <= EX_memRead;
            MEM_regWrite <= EX_regWrite;
            MEM_memtoReg <= EX_memtoReg;
            MEM_w_spec_regs <= EX_w_spec_regs;
//            MEM_hi_write <= EX_hi_write;
//            MEM_lo_write <= EX_lo_write;
            MEM_halt <= EX_halt;
            
            MEM_pc <= EX_pc;
            MEM_pc_plus <= EX_pc_plus;
            MEM_alu_result <= EX_alu_result;
            MEM_rd2 <= EX_rd2;
//            MEM_br_target <= EX_br_target;
            MEM_write_reg <= EX_write_reg;
        end
    end
endmodule 

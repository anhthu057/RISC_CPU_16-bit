`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:41:49 PM
// Design Name: 
// Module Name: ID_EX_Register
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
module ID_EX_Register(
    input wire clk,
    input wire rst,
    
    // May cai nay tu mux hazard
    input wire [5:0] ID_ALU_cnt, 
    input wire [1:0] ID_PCSrc,
    input wire [1:0] ID_r_spec_regs,
    input wire [1:0] ID_w_spec_regs,
    input wire ID_regDst,
    input wire ID_ALUSrc,
    input wire ID_memWrite,
    input wire ID_memRead,
    input wire ID_regWrite,
    input wire ID_memToReg,
    input wire ID_hi_write,
    input wire ID_lo_write,
    input wire ID_halt,
    
    // du lieu tu id stage ne
    input wire [15:0] ID_pc, // cho lenh move from pc
    input wire [15:0] ID_pc_plus,
    
    // du lieu tu doc doc register
    input wire [15:0] ID_rd1,
    input wire [15:0] ID_rd2,
    
    // du lieu tu khoi sign extend
    input wire [15:0] ID_sign_ext,
    input wire [15:0] ID_br_target, // tu khoi address target
    
    // cai nay la cai day truyen thang qua
    input wire [2:0] ID_rs,
    input wire [2:0] ID_rt,
    input wire [2:0] ID_rd,
//    input wire [2:0] ID_func,

    // them
    input wire ID_EX_Flush,
    
    // output nek 
    output reg [5:0] EX_ALU_cnt,
    output reg [1:0] EX_PCSrc,
    output reg [1:0] EX_r_spec_regs,
    output reg [1:0] EX_w_spec_regs,
    output reg EX_regDst,
    output reg EX_ALUSrc,
    output reg EX_memWrite,
    output reg EX_memRead,
    output reg EX_regWrite,
    output reg EX_memToReg,
    output reg EX_hi_write,
    output reg EX_lo_write,
    output reg EX_halt,
    
    output reg [15:0] EX_pc,
    output reg [15:0] EX_pc_plus,
    output reg [15:0] EX_rd1,
    output reg [15:0] EX_rd2,
    output reg [15:0] EX_sign_ext,
    output reg [15:0] EX_br_target,
    output reg [2:0] EX_rs,
    output reg [2:0] EX_rt,
    output reg [2:0] EX_rd
    );
    
    
    wire [2:0] destination_reg = ID_regDst ? ID_rd : ID_rt;
    always @(posedge clk or posedge rst) begin
        if (rst || ID_EX_Flush) begin
            EX_ALU_cnt <= 6'b111111;
            EX_PCSrc <= 2'b00;
            EX_r_spec_regs <= 2'b11;
            EX_w_spec_regs <= 2'b10;
            EX_regDst <= 1'b0;
            EX_ALUSrc <= 1'b0;
            EX_memWrite <= 1'b0;
            EX_memRead <= 1'b0;
            EX_regWrite <= 1'b0;
            EX_memToReg <= 1'b0;
            EX_hi_write <= 1'b0;
            EX_lo_write <= 1'b0;
            EX_halt <= 1'b0;
            
            EX_pc <= 16'h0000;
            EX_pc_plus <= 16'h0000;
            EX_rd1 <= 16'h0000;
            EX_rd2 <= 16'h0000;
            EX_sign_ext <= 16'h0000;
            EX_br_target <= 16'h0000;
            EX_rs <= 3'b000;
            EX_rt <= 3'b000;
            EX_rd <= 3'b000;
        end

        else begin
            EX_ALU_cnt <= ID_ALU_cnt;
            EX_PCSrc <= ID_PCSrc;
            EX_r_spec_regs <= ID_r_spec_regs;
            EX_w_spec_regs <= ID_w_spec_regs;
            EX_regDst <= ID_regDst;
            EX_ALUSrc <= ID_ALUSrc;
            EX_memWrite <= ID_memWrite;
            EX_memRead <= ID_memRead;
            EX_regWrite <= ID_regWrite;
            EX_memToReg <= ID_memToReg;
            EX_hi_write <= ID_hi_write;
            EX_lo_write <= ID_lo_write;
            EX_halt <= ID_halt;
            
            EX_pc <= ID_pc;
            EX_pc_plus <= ID_pc_plus;
            EX_rd1 <= ID_rd1;
            EX_rd2 <= ID_rd2;
            EX_sign_ext <= ID_sign_ext;
            EX_br_target <= ID_br_target;
            EX_rs <= ID_rs;
            EX_rt <= ID_rt;
            EX_rd <= destination_reg;  // Chon Rt hoac Rd
      end
    end
    
endmodule
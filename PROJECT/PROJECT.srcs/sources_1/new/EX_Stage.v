`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:57:38 PM
// Design Name: 
// Module Name: EX_Stage
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


module EX_Stage(
    input  wire clk,
    input  wire rst,
    
    input  wire [2:0]  ID_EX_Rs,
    input  wire [2:0]  ID_EX_Rt,
    input  wire [15:0] ID_EX_rd1,
    input  wire [15:0] ID_EX_rd2,
    input  wire [15:0] ID_EX_sign_extend,
    input  wire [15:0] ID_EX_PC,
    input  wire [1:0]  ID_EX_r_spec_regs,
    
    input  wire [5:0]  ALU_cnt,
    input  wire        ALUSrc,
    
    input  wire [2:0]  EX_MEM_Rd,
    input  wire        EX_MEM_RegWrite,
    input  wire [15:0] EX_MEM_alu_result,
    input  wire [1:0]  EX_MEM_w_spec_regs,
    
    input  wire [2:0]  MEM_WB_Rd,
    input  wire        MEM_WB_RegWrite,
    input  wire [15:0] MEM_WB_write_data,
    input  wire [1:0]  MEM_WB_w_spec_regs,
    
    input  wire [1:0]  PCSrc,
    
    output wire branch_taken,
    output wire [15:0] alu_result,
    output wire [15:0] forward_rd2,      // For SW instruction
    output wire        zero,
    output wire [1:0]  ForwardA_out,     // Debug output
    output wire [1:0]  ForwardB_out,    // Debug output
    
    //them
    output wire [15:0] forward_rd1
    );
    
    wire [1:0] ForwardA_internal;
    wire [1:0] ForwardB_internal;
    
    Forwarding_Unit forwarding_unit (
    .ID_EX_Rs(ID_EX_Rs),
    .ID_EX_Rt(ID_EX_Rt),
    .ID_EX_r_spec_regs(ID_EX_r_spec_regs),
    .EX_MEM_Rd(EX_MEM_Rd),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    .EX_MEM_w_spec_regs(EX_MEM_w_spec_regs),
    .MEM_WB_Rd(MEM_WB_Rd),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .MEM_WB_w_spec_regs(MEM_WB_w_spec_regs),
    .ForwardA(ForwardA_internal),
    .ForwardB(ForwardB_internal)
    );
    
    ALU_System alu_system (
    .clk(clk),
    .rst(rst),
    .ALU_cnt(ALU_cnt),
    .ALUSrc(ALUSrc),
    .ID_EX_rd1(ID_EX_rd1),
    .ID_EX_rd2(ID_EX_rd2),
    .sign_extend(ID_EX_sign_extend),
    .PC_in(ID_EX_PC),
    .ForwardA(ForwardA_internal),
    .ForwardB(ForwardB_internal),
    .EX_MEM_alu_result(EX_MEM_alu_result),
    .MEM_WB_write_data(MEM_WB_write_data),
    .alu_result(alu_result),
    .forward_rd2(forward_rd2),
    .zero(zero),
    //them
    .forward_rd1(forward_rd1)
    );
    
    assign ForwardA_out = ForwardA_internal;
    assign ForwardB_out = ForwardB_internal;
    
    assign branch_taken = (PCSrc == 2'b10) && zero;
    
endmodule

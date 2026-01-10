`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:54:21 PM
// Design Name: 
// Module Name: ID_Stage
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


module ID_Stage(
    input wire clk,
    input wire rst,
    input wire [15:0] pc,
    input wire [15:0] inst,
    
    //input registers file
    input wire regWrite_wb,
    input wire [2:0] write_reg,
    input wire [15:0] write_data,
    input wire [1:0] w_spec_regs_wb,
    
    //input hazard
    input wire [2:0] if_rs, //
    input wire [2:0] if_rt, //
    input wire [2:0] ex_rt,
    input wire ex_memRead,
    
    // FULL Control Unit outputs
    output wire regDst,
    output wire ALUSrc,
    output wire memRead,
    output wire memWrite,
    output wire regWrite,
    output wire memToReg,
    output wire [1:0] PCSrc,
    output wire [5:0] ALU_cnt,
//    output wire hi_write,
//    output wire lo_write,
    output wire [1:0] r_spec_regs,
    output wire [1:0] w_spec_regs,
    output wire halt,
    
    //ID outputs
    output wire [15:0] rd1,
    output wire [15:0] rd2,
    
    output wire [15:0] j_address,
    output wire [15:0] branch_target,  
    
    output wire [15:0] extended_int,
    output wire [15:0] pc_out,
    output wire [2:0] id_rs,
    output wire [2:0] id_rt,
    output wire [2:0] id_rd,
    
    //HAZARD OUTPUTS
    output wire Write,
    
    // them 
    output wire is_jump
    );
    
    // them cai nay
    wire controlunit_is_jump;
    
    wire [15:0] rf_rd1, rf_rd2;
    wire HazardControl;
    
    wire [3:0] opcode   = inst[15:12];
    wire [2:0] rs       = inst[11:9];
    wire [2:0] rt       = inst[8:6];
    wire [2:0] rd       = inst[5:3];
    wire [2:0] funct    = inst[2:0];
    wire [5:0] imm      = inst[5:0];
    wire [11:0] address  = inst[11:0];
    
    wire [5:0] ALU_cnt_ctrl;
    wire [1:0] PCSrc_ctrl, r_spec_regs_ctrl, w_spec_regs_ctrl;
    wire regDst_ctrl, ALUSrc_ctrl, memWrite_ctrl, memRead_ctrl, regWrite_ctrl, 
         memToReg_ctrl, halt_ctrl;
//    hi_write_ctrl, lo_write_ctrl
    //==================================================
    // CONTROL UNIT
    //==================================================
    control_unit CU (
        .opcode(opcode),
        .funct(funct),
        
        .ALU_cnt(ALU_cnt_ctrl),
        .PCSrc(PCSrc_ctrl),
        .regDst(regDst_ctrl),
        .ALUSrc(ALUSrc_ctrl),
        .memWrite(memWrite_ctrl),
        .memRead(memRead_ctrl),
        .regWrite(regWrite_ctrl),
        .memToReg(memToReg_ctrl),
//        .hi_write(hi_write_ctrl),
//        .lo_write(lo_write_ctrl),
        .r_spec_regs(r_spec_regs_ctrl),
        .w_spec_regs(w_spec_regs_ctrl),
        .halt(halt_ctrl),
        
        // them ne
        .is_jump(controlunit_is_jump)
    );
    
    //==================================================
    // HAZARD DETECTION
    //==================================================
    hazard_detection_unit HAZARD_UNIT (
        .IF_ID_RegisterRs(rs),
        .IF_ID_RegisterRt(rt),
        .ID_EX_RegisterRt(ex_rt),
        .ID_EX_MemRead(ex_memRead),
        .Write(Write),
        .HazardMuxControl(HazardControl)
    );

    //==================================================
    // MUX HAZARD - Ch?n t?n hi?u khi c? Stall
    //==================================================
    MUX_Hazard MUX_UNIT (
        .HazardMuxControl(HazardControl),
        .ALU_cnt(ALU_cnt_ctrl),       // ??m b?o module MUX nh?n 6-bit
        .PCSrc(PCSrc_ctrl),
        .regDst(regDst_ctrl),
        .ALUSrc(ALUSrc_ctrl),
        .memWrite(memWrite_ctrl),
        .memRead(memRead_ctrl),
        .regWrite(regWrite_ctrl),
        .memToReg(memToReg_ctrl),
//        .hi_write(hi_write_ctrl),
//        .lo_write(lo_write_ctrl),
        .r_spec_regs(r_spec_regs_ctrl),
        .w_spec_regs(w_spec_regs_ctrl),
        .halt(halt_ctrl),
        
        // Output ??y ra c?c c?ng Output c?a id_stage
        .ALU_cnt_out(ALU_cnt),
        .PCSrc_out(PCSrc),
        .regDst_out(regDst),
        .ALUSrc_out(ALUSrc),
        .memWrite_out(memWrite),
        .memRead_out(memRead),
        .regWrite_out(regWrite),
        .memToReg_out(memToReg),
//        .hi_write_out(hi_write),
//        .lo_write_out(lo_write),
        .r_spec_regs_out(r_spec_regs),
        .w_spec_regs_out(w_spec_regs),
        .halt_out(halt)
    );

    //==================================================
    // SIGN EXTEND
    //==================================================
    sign_extend sign_extender (
        .immediate(imm),
        .sign_extend(extended_int)
    );

    //==================================================
    // REGISTER FILE
    //==================================================
    registers_file regFile (
        .clk(clk),
        .rst(rst),
        .reg_write(regWrite_wb),     
        .write_reg(write_reg),
        .write_data(write_data),
        .r_spec_regs(r_spec_regs),
        .w_spec_regs(w_spec_regs_wb),
        .rs(rs),
        .rt(rt),
        .rd1(rf_rd1),
        .rd2(rf_rd2)
    );

    //==================================================
    // ADDRESS TARGET
    //==================================================
//    address_target addr_target (
//        .rd1(rf_rd1),          
//        .address(address),
//        .pc(pc),
//        .opcode(opcode),
//        .funct(funct),
//        .immediate(imm),
//        .br_target(branch_target)
//    );

    assign    rd1     = rf_rd1;
    assign    rd2     = rf_rd2;
    assign    pc_out  = pc;
    assign    id_rs   = rs;
    assign    id_rt   = rt;
    assign    id_rd   = rd;
    
    // them ne
    assign is_jump = controlunit_is_jump && !HazardControl;
    assign j_address = {pc[15:13], address[11:0], 1'b0};
    assign branch_target = pc + (extended_int << 1);
    
endmodule

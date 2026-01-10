`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:36:29 PM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    input [2:0] IF_ID_RegisterRs,
    input [2:0] IF_ID_RegisterRt,
    input [2:0] ID_EX_RegisterRt,
    input ID_EX_MemRead,
    output reg Write,
    output reg HazardMuxControl
    );
    
    always @(*) begin
        if (ID_EX_MemRead &&
            ((ID_EX_RegisterRt == IF_ID_RegisterRs)
             || (ID_EX_RegisterRt == IF_ID_RegisterRt))) begin       
            Write = 1'b0;      
            HazardMuxControl = 1'b1; 
        end
        else begin
            Write = 1'b1;
            HazardMuxControl = 1'b0;
        end
    end
endmodule

module MUX_Hazard(
    input HazardMuxControl,
    input [5:0] ALU_cnt,
    input [1:0] PCSrc, r_spec_regs, w_spec_regs,
    input regDst, ALUSrc, memWrite, memRead, regWrite, memToReg, halt,
    output reg [5:0] ALU_cnt_out,
    output reg [1:0] PCSrc_out, r_spec_regs_out, w_spec_regs_out,
    output reg regDst_out, ALUSrc_out, memWrite_out, memRead_out, regWrite_out, memToReg_out, halt_out
);
//    assign regDst_out = regDst & !HazardMuxControl;
//    assign ALUSrc_out = ALUSrc & !HazardMuxControl;
//    assign memWrite_out = memRead & !HazardMuxControl;
//    assign regWrite_out = regWrite & !HazardMuxControl;
//    assign memToReg_out = memToReg & !HazardMuxControl;
//    assign hi_write_out = hi_write & !HazardMuxControl;
//    assign lo_write_out = lo_write & !HazardMuxControl;
//    assign halt_out = halt & !HazardMuxControl;
//    assign PCSrc_out = PCSrc & !HazardMuxControl;
//    assign r_spec_regs_out = HazardMuxControl? 2'b11 : r_spec_regs;
//    assign w_spec_regs_out = HazardMuxControl? 2'b10 : w_spec_regs;
//    assign ALU_cnt_out = HazardMuxControl? 6'b111_111 : ALU_cnt;
    
    always @(*) begin
        if (HazardMuxControl) begin
            regDst_out = 1'b0;
            ALU_cnt_out = 6'b111111;
            ALUSrc_out = 1'b0;
            memRead_out = 1'b0;
            memWrite_out = 1'b0;
            regWrite_out = 1'b0;
            memToReg_out = 1'b0;
            PCSrc_out = 2'b00;
//            hi_write_out = 1'b0;
//            lo_write_out = 1'b0;
            r_spec_regs_out = 2'b11;
            w_spec_regs_out = 2'b10;
            halt_out = 1'b0;
        end
        else begin
            regDst_out = regDst;
            ALU_cnt_out = ALU_cnt;
            ALUSrc_out = ALUSrc;
            memRead_out = memRead;
            memWrite_out = memWrite;
            regWrite_out = regWrite;
            memToReg_out = memToReg;
            PCSrc_out = PCSrc;
//            hi_write_out = hi_write;
//            lo_write_out = lo_write;
            r_spec_regs_out = r_spec_regs;
            w_spec_regs_out = w_spec_regs;
            halt_out = halt;
        end
    end
endmodule 

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:21:28 PM
// Design Name: 
// Module Name: control_unit
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
module control_unit(
input [3:0] opcode,
input [2:0] funct,

output reg [1:0] PCSrc, r_spec_regs, w_spec_regs,
output reg regDst, ALUSrc, memWrite, memRead, regWrite, memToReg, halt,

output reg[5:0] ALU_cnt,

// them cai nay
output reg is_jump
);

always @(*) begin
        regDst = 1'b0;
        ALUSrc = 1'b0;
        memWrite = 1'b0;
        memRead = 1'b0;
        regWrite = 1'b0;
        memToReg = 1'b0;
        PCSrc = 2'b00;
//        hi_write = 1'b0;
//        lo_write = 1'b0;
        r_spec_regs = 2'b11;
        w_spec_regs = 2'b10;
        halt = 1'b0;
        ALU_cnt = 6'b111111;
        
        // them cai nay
        is_jump = 1'b0;
        
        case (opcode) 
        4'b0000: 
        begin
            regDst = 1'b1;
            ALUSrc = 1'b0;
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = (funct == 3'b010 || funct == 3'b011)? 1'b0 : 1'b1;
            memToReg = 1'b0;
            PCSrc = 2'b00;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            is_jump = 1'b0;
            halt = 1'b0;
            case (funct) 
                3'b000: ALU_cnt = 6'b000000; //addu
                3'b001: ALU_cnt = 6'b000001; //subu
                3'b010: ALU_cnt = 6'b000010; //multu
                3'b011: ALU_cnt = 6'b000011; //divu
                3'b100: ALU_cnt = 6'b000100; //and
                3'b101: ALU_cnt = 6'b000101; //or
                3'b110: ALU_cnt = 6'b000110; //nor
                3'b111: ALU_cnt = 6'b000111; //xor
                default:ALU_cnt = 6'b000000;
            endcase
        end
        4'b0001:
        begin
            regDst = 1'b1;
            ALUSrc = 1'b0;
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = (funct == 3'b111 || funct == 3'b010 || funct == 3'b011)? 1'b0 : 1'b1;
            memToReg = 1'b0;
            PCSrc = (funct == 3'b111) ? 2'b01 : 1'b00;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            case (funct)
                3'b000:begin
                    ALU_cnt = 6'b001000; // add
                    is_jump = 1'b0;
                    end
                3'b001:begin
                    ALU_cnt = 6'b001001; // sub
                    is_jump = 1'b0;
                    end
                3'b010:begin
                    ALU_cnt = 6'b001010; // mult
                    is_jump = 1'b0;
                    end
                3'b011: begin
                    ALU_cnt = 6'b001011; // div
                    is_jump = 1'b0;
                    end
                3'b100: begin
                    ALU_cnt = 6'b001100; // slt
                    is_jump = 1'b0;
                    end 
                3'b101:begin
                    ALU_cnt = 6'b001101; // seq
                    is_jump = 1'b0;
                    end
                3'b110: begin
                    ALU_cnt = 6'b001110; // sltu
                    is_jump = 1'b0;
                    end
                3'b111: begin
                    ALU_cnt = 6'b001111; // jr
                    is_jump = 1'b0;
                end
                default: begin
                    ALU_cnt = 6'b111111;   
                    is_jump = 1'b0;    
                    end
            endcase
        end
        4'b0010:
        begin
            regDst = 1'b1;
            ALUSrc = 1'b0;
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = (funct == 3'b000 || funct == 3'b001 || funct == 3'b010 || funct == 3'b011)? 1'b1 : 1'b0;
            memToReg = 1'b0;
            PCSrc = 2'b00;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            is_jump = 1'b0;
            case (funct)
                3'b000: ALU_cnt = 6'b010000; // shr
                3'b001: ALU_cnt = 6'b010001; // shl
                3'b010: ALU_cnt = 6'b010010; // ror
                3'b011: ALU_cnt = 6'b010011; // rol
                default: ALU_cnt = 6'b111111;
            endcase
        end
        4'b0011: //addi
        begin
            regDst = 1'b0;
            ALUSrc = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b0;
            PCSrc = 2'b00;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            ALU_cnt = 6'b101000;
            is_jump = 1'b0;
        end
        4'b0100: //slti $rt, $rs, i
        begin
            regDst = 1'b0;
            ALUSrc = 1'b1; 
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b0;
            PCSrc = 2'b00;
//                mult_div <= 1'b0;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            ALU_cnt = 6'b101001;
            is_jump = 1'b0;
        end
        4'b0101: //bneq
        begin
            regDst = 1'b0; //regDst = x
            ALUSrc = 1'b0;
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = 1'b0;
            memToReg = 1'b0; 
            PCSrc = 2'b10;
//                mult_div <= 1'b0;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            ALU_cnt = 6'b101010;
            is_jump = 1'b0;
        end
        4'b0110: //bgtz $rs, i [$rs] > 0?
        begin
            regDst = 1'b0;
            ALUSrc = 1'b1; // so sanh voi $zero
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = 1'b0;
            memToReg = 1'b0; // = x
            PCSrc = 2'b10;
//                mult_div <= 1'b0;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            ALU_cnt = 6'b101011;
            is_jump = 1'b0;
        end
        4'b0111: // j i
        begin
            regDst = 1'b0;
            ALUSrc = 1'b0; // x
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = 1'b0;
            memToReg = 1'b0; //x
            PCSrc = 2'b11;
//                mult_div <= 1'b0;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            ALU_cnt = 6'b101110;
            is_jump = 1'b1;
        end
        4'b1000:
        begin //lh $rt, i($rs)
            regDst = 1'b0;
            ALUSrc = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b1;
            regWrite = 1'b1;
            memToReg = 1'b1;
            PCSrc = 2'b00;
//                mult_div <= 1'b0;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            ALU_cnt = 6'b101100;
            is_jump = 1'b0;
        end
        4'b1001:
        begin
            regDst = 1'b0; // x
            ALUSrc = 1'b1;
            memWrite = 1'b1;
            memRead = 1'b0;
            regWrite = 1'b0;
            memToReg = 1'b0; 
            PCSrc = 2'b00;
//                mult_div <= 1'b0;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            r_spec_regs = 2'b11;
            w_spec_regs = 2'b10;
            halt = 1'b0;
            ALU_cnt = 6'b101101;
            is_jump = 1'b0;
        end    
        4'b1010: // MFSR Move from special registers kieu R 
        begin
            regDst = 1'b1; //rd
            ALUSrc = 1'b0;
            memWrite = 1'b0;
            memRead = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b0;
            PCSrc = 1'b00;  
//                mult_div <= 1'b0; 
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            halt = 1'b0;
            is_jump = 1'b0;
            case (funct)
                3'b000: begin
                    r_spec_regs = 2'b00;
                    ALU_cnt = 6'b011000; // mfz
                end
                3'b001: begin
                    r_spec_regs = 2'b11;
                    ALU_cnt = 6'b011001; // mfpc
                end
                3'b010: begin
                    r_spec_regs = 2'b01;
                    ALU_cnt = 6'b011010; // mfra
                end
                3'b011: begin
                    r_spec_regs = 2'b10;
                    ALU_cnt = 6'b011011; // mfat
                end
                3'b100: begin
                    r_spec_regs = 2'b11;
                    ALU_cnt = 6'b011100; // mfhi
                end
                3'b101: begin
                    r_spec_regs = 2'b11;
                    ALU_cnt = 6'b011101; // mflo
                end
                default: begin
                    r_spec_regs = 2'b11;
                    ALU_cnt = 6'b111111;
                end
            endcase
            w_spec_regs = 2'b10;
        end
        4'b1011: // MTSR Move to 
        begin
            regDst = 1'b1; //rd
            ALUSrc = 1'b0;
            memWrite = 1'b0;
            regWrite = (funct == 3'b010 || funct == 3'b011)? 1'b1 : 1'b0;
            memToReg = 1'b0;
            PCSrc = 2'b00;
            halt = 1'b0;
//                mult_div <= 1'b0; 
            memRead = 1'b0;
            is_jump = 1'b0;
            case (funct)
                3'b010: begin
                    w_spec_regs = 2'b00;
                    ALU_cnt = 6'b100010; // mtra
                end
                3'b011: begin
                    w_spec_regs = 2'b01;
                    ALU_cnt = 6'b100011; // mtat
                end
                3'b100: begin
                    w_spec_regs = 2'b10;
//                    hi_write = 1'b1;
                    ALU_cnt = 6'b100100; // mthi
                end
                3'b101: begin
                    w_spec_regs = 2'b10;
//                    lo_write = 1'b1;
                    ALU_cnt = 6'b100101; // mtlo
                end
                default: begin
                    w_spec_regs = 2'b10;
                    ALU_cnt = 6'b111111;
                end
            endcase
            r_spec_regs = 2'b11;
        end
        4'b1111: //HLT signal = 0
        begin
            regDst = 1'b0;
            ALUSrc = 1'b0;
            memWrite = 1'b0;
            regWrite = 1'b0;
            memToReg = 1'b0;
            PCSrc = 2'b00;
            memRead = 1'b0;
//                mult_div <= 1'b0;
//            hi_write = 1'b0;
//            lo_write = 1'b0;
            w_spec_regs = 2'b10;
            r_spec_regs = 2'b11; 
            halt = 1'b1;
            ALU_cnt = 6'b101111;
        end
        default: ;
    endcase
end

endmodule

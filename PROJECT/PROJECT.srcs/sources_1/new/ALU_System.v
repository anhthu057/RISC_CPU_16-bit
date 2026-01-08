`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:32:36 PM
// Design Name: 
// Module Name: ALU_System
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
module MUX_ALU (
    input ALUSrc,
    input [15:0] rs2,
    input [15:0] sign_extend,
    output [15:0] out
);
    assign out = ALUSrc ? sign_extend : rs2;
    
endmodule

module MUX_3_to_1(
    input [15:0] in0, in1, in2,
    input [1:0] select, // from forward
    output reg [15:0] out
    );
    
    always @(*) begin
        case (select)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            default: out = in0;
        endcase    
    end
endmodule

module ALU(
    input [15:0] rs1,
    input [15:0] out,
    input [5:0] ALU_cnt,
    input [15:0] PC_in, // MODULE PC
    
    output reg [15:0] result,
    output wire zero
);
        reg[31:0] mul_result;
        reg[15:0] div_hi;
        reg[15:0] div_lo;
        reg zero_t;
        
    initial begin
        div_hi = 0;
        div_lo = 0;
    end
        
    always @(*) begin
        // Default values
        result = 16'b0;
        mul_result = 32'b0;
        case (ALU_cnt)
            // Unsigned arithmetic
            6'b000000: result = $unsigned(rs1) + $unsigned(out);  // addu
            6'b000001: result = $unsigned(rs1) - $unsigned(out);  // subu
            6'b000010: begin  // multu
                mul_result = $unsigned(rs1) * $unsigned(out);
                result = mul_result[15:0];
                div_hi = mul_result[31:16];
                div_lo = mul_result[15:0];
            end
            6'b000011: begin  // divu
                if (out != 0) begin
                    div_hi = $unsigned(rs1) % $unsigned(out);
                    div_lo = $unsigned(rs1) / $unsigned(out);
                    result = div_lo;
                end
            end
            
            // Logical operations
            6'b000100: result = rs1 & out;   // and
            6'b000101: result = rs1 | out;   // or
            6'b000110: result = ~(rs1 | out); // nor
            6'b000111: result = rs1 ^ out;   // xor
            
            // Signed arithmetic
            6'b001000: result = $signed(rs1) + $signed(out);  // add
            6'b001001: result = $signed(rs1) - $signed(out);  // sub
            6'b001010: begin  // mult
                mul_result = $signed(rs1) * $signed(out);
                div_hi = mul_result[31:16];
                div_lo = mul_result[15:0];
                result = mul_result[15:0];
            end
            6'b001011: begin  // div
                if (out != 0) begin
                    div_hi = $signed(rs1) / $signed(out);
                    div_lo = $signed(rs1) % $signed(out);
                    result = div_lo;
                end
            end
            6'b001100: result = ($signed(rs1) < $signed(out)) ? 16'h0001 : 16'h0000;  // slt
            6'b001101: result = ($signed(rs1) == $signed(out)) ? 16'h0001 : 16'h0000; // seq
            6'b001110: result = ($unsigned(rs1) < $unsigned(out)) ? 16'h0001 : 16'h0000; // sltu
            6'b001111: result = rs1;  // jr
            
            // Shift operations
            6'b010000: result = out >> rs1[3:0];  // shr
            6'b010001: result = out << rs1[3:0];  // shl
            6'b010010: result = (out >> rs1[3:0]) | (out << (16 - rs1[3:0]));  // ror
            6'b010011: result = (out << rs1[3:0]) | (out >> (16 - rs1[3:0]));       // rol
            
            // Move from special registers
            6'b011000: result = rs1;  // mfz
            6'b011001: result = PC_in;             // mfpc
            6'b011010: result = rs1;             // mfra
            6'b011011: result = rs1;             // mfat
            6'b011100: result = div_hi;             // mfhi
            6'b011101: result = div_lo;             // mflo
            
            // I-type instructions
            6'b101000: result = $signed(rs1) + $signed(out);  // addi
            6'b101001: result = ($signed(rs1) < $signed(out)) ? 16'h0001 : 16'h0000;  // slti
            6'b101010: zero_t = (rs1 != out) ? 1'b1 : 1'b0;     // bneq
            6'b101011: zero_t = ($signed(rs1) > $signed(0)) ? 1'b1 : 1'b0;  // bgtz
            6'b101100: result = ((rs1[15:1] + out[15:1]) << 1);  // lh
            6'b101101: result = ((rs1[15:1] + out[15:1]) << 1);  // sh
            6'b101110: result = {PC_in[15:13], (out[12:0] << 1)};  // ji
            6'b101111: result = 16'b0;  // HALT
            
             6'b100010: result = out;// mtra
             6'b100011: result = out;// mtat
             6'b100100: div_hi = out;// mthi
             6'b100101: div_lo = out;// mtlo
            default: result = 16'hxxxx;
        endcase
    end
    
    assign zero = (ALU_cnt == 6'b101010 || ALU_cnt == 6'b101011)? zero_t : 1'b0;
    
endmodule


module ALU_System(
    input wire clk,
    input wire rst,
    
    input wire [5:0] ALU_cnt,
    input wire ALUSrc,
    
    input wire [15:0] ID_EX_rd1,
    input wire [15:0] ID_EX_rd2,
    input wire [15:0] sign_extend,
    input wire [15:0] PC_in,
    
    input wire [1:0] ForwardA,
    input wire [1:0] ForwardB,
    input wire [15:0] EX_MEM_alu_result,
    input wire [15:0] MEM_WB_write_data,
    
    output wire [15:0] alu_result,
    output wire [15:0] forward_rd2,
    output wire [15:0] forward_rd1,
    output wire zero
);


    wire [15:0] forward_rs1; // rs1 sau khi forward
    wire [15:0] alu_operand2;
    assign forward_rd1 = forward_rs1;
    
    MUX_3_to_1 mux_forward_a (
        .in0(ID_EX_rd1),           // 2'b00: Không forward
        .in1(MEM_WB_write_data),   // 2'b01: Forward t? WB
        .in2(EX_MEM_alu_result),   // 2'b10: Forward t? MEM
        .select(ForwardA),
        .out(forward_rs1)
    );
    
    MUX_3_to_1 mux_forward_b (
        .in0(ID_EX_rd2),           // 2'b00: Không forward
        .in1(MEM_WB_write_data),   // 2'b01: Forward t? WB
        .in2(EX_MEM_alu_result),   // 2'b10: Forward t? MEM
        .select(ForwardB),
        .out(forward_rd2)          // Output ra ngoài cho SW instruction
    );
    // Instantiate MUX
    MUX_ALU mux_alu (
        .ALUSrc(ALUSrc),
        .rs2(forward_rd2),
        .sign_extend(sign_extend),
        .out(alu_operand2)
    );
    
    // Instantiate ALU
    ALU alu (
        .rs1(forward_rs1),
        .out(alu_operand2),
        .ALU_cnt(ALU_cnt),
        .PC_in(PC_in),
        .result(alu_result),
        .zero(zero)
    );

endmodule

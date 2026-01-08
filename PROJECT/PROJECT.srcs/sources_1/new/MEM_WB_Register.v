`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:44:06 PM
// Design Name: 
// Module Name: MEM_WB_Register
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


module MEM_WB_Register(
    input wire clk,
    input wire rst,

//    // --- CONTROL SIGNALS INPUT (T? MEM) ---
    input wire regWrite_in,
    input wire memToReg_in,
    input wire [1:0] w_spec_regs_in,
    input wire halt_in,

//    // --- DATA INPUT (T? MEM) ---
    input wire [15:0] read_data_in,   // D? li?u t? RAM
    input wire [15:0] alu_result_in,  // D? li?u t? ALU (bypass)
    input wire [2:0]  write_reg_addr_in,

//    // --- OUTPUT SANG WB ---
    output reg regWrite_out, 
    output reg memToReg_out,
    output reg halt_out,
    output reg [1:0] w_spec_regs_out,

    
    output reg [15:0] read_data_out,
    output reg [15:0] alu_result_out,
    output reg [2:0]  write_reg_addr_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            regWrite_out <= 0; 
            memToReg_out <= 0; 
            halt_out <= 0;
            read_data_out <= 0; 
            alu_result_out <= 0; 
            write_reg_addr_out <= 0;
            w_spec_regs_out <= 2'b10;
        end else begin
            regWrite_out <= regWrite_in;
            memToReg_out <= memToReg_in; 
            halt_out <= halt_in;
            
            read_data_out <= read_data_in;
            alu_result_out <= alu_result_in;
            write_reg_addr_out <= write_reg_addr_in;
            w_spec_regs_out <= w_spec_regs_in;
        end
    end
endmodule


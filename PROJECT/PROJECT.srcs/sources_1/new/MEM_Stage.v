`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:57:51 PM
// Design Name: 
// Module Name: MEM_Stage
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


module MEM_Stage(
    input wire clk,
    
    input wire memRead,
    input wire memWrite,
    input wire memToReg_in,
    input wire regWrite_in,
    input wire [1:0] w_spec_regs_in,
    input wire halt_in,
    
    input wire [15:0] alu_result,
    input wire [15:0] write_data_mem,
    input wire [2:0]  write_reg_addr_in,
    
    output wire [15:0] read_data_out,
    output wire [15:0] alu_result_out,
    output wire [2:0]  write_reg_addr_out,
    
    output wire memToReg_out,
    output wire regWrite_out,
    output wire [1:0] w_spec_regs_out,
    output wire halt_out
    );
   
    data_memory dmem (
        .clk(clk),
        .MemRead(memRead),
        .MemWrite(memWrite),
        .address(alu_result),       // N?i k?t qu? ALU vào c?ng ??a ch?
        .write_data(write_data_mem),// N?i d? li?u rt vào c?ng ghi
        .read_data(read_data_out)   // L?y d? li?u ??c ra
    );
    
    assign alu_result_out = alu_result;
    
    assign write_reg_addr_out = write_reg_addr_in;
    assign memToReg_out = memToReg_in;
    assign regWrite_out = regWrite_in;
    assign halt_out = halt_in;
    assign w_spec_regs_out = w_spec_regs_in;
    
endmodule

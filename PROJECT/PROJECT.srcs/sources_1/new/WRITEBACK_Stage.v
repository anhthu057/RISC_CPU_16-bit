`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2025 08:46:23 PM
// Design Name: 
// Module Name: WRITEBACK_Stage
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


module WRITEBACK_Stage(
//    // --- CONTROL SIGNALS (Input t? MEM/WB Register) ---
    input wire memToReg_in,
    input wire halt_in,

    input wire [15:0] read_data_in,  // D? li?u ??c t? RAM
    input wire [15:0] alu_result_in, // K?t qu? tính toán t? ALU

    output wire [15:0] wb_final_data,   // D? li?u cu?i cùng ?? ghi vào RegFile
    output wire        halt_out         // Tín hi?u d?ng CPU
);

    
    MUX_DataMemory wb_mux (
        .MemtoReg(memToReg_in),
        .read_data(read_data_in),
        .ALU_result(alu_result_in),
        .out(wb_final_data) // Output này s? n?i v? ID_Stage
    );

    assign halt_out      = halt_in;

endmodule
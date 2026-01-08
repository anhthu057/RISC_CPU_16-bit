`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:16:42 PM
// Design Name: 
// Module Name: IM
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
module IM #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 16,
    parameter MEM_SIZE = 256,
    parameter INIT_FILE = "program.mem"
)(
    input  wire [ADDR_WIDTH-1:0]   addr,
    output reg  [DATA_WIDTH-1:0]   instr  // ??i t? wire ? reg
);
    reg [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];
    
    // Word address (16-bit aligned)
    wire [ADDR_WIDTH-2:0] word_addr = addr[ADDR_WIDTH-1:1];
    
    always @(*) begin
        if (word_addr >= 0 && word_addr < MEM_SIZE)
            instr = memory[word_addr];
        else
        instr = 16'hc000; // NOP
    end
        
    integer i;
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, memory);
            $display("[IM] Loaded %s into instruction memory", INIT_FILE);
        end else begin
            // Initialize v?i NOP n?u không có file
            for (i = 0; i < MEM_SIZE; i = i + 1)
                memory[i] = 16'h0000;
        end
    end
endmodule

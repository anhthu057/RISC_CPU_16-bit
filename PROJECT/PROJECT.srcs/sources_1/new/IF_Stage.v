`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:49:58 PM
// Design Name: 
// Module Name: IF_Stage
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


module IF_Stage(
    // Clock and Reset
    input  wire        clk,
    input  wire        rst,
    input  wire        is_jump,
    
    // Control signals
    input  wire        halt,
    input  wire        pc_write,        // From hazard detection unit
//    input  wire [1:0]  PCSrc_id,           // From control unit
    input  wire [1:0]  EX_PCSrc,
//    input  wire        zero,            // From ALU (for branch decision)
    input  wire [15:0] address_target_id,      // T? ID
    input  wire [15:0] address_target_ex,     // T? EX
    input  wire [15:0] jr_address,
    input wire branch_taken,
    // Outputs
    output wire [15:0] pc_current,      // Current PC value
    output wire [15:0] pc_plus_2,       // PC + 2
    output wire [15:0] instruction    
    );
    
    wire [15:0] pc_next_internal;
    
    PC_System pc_system (
    .clk(clk),
    .rst(rst),
    .halt(halt),
    .write(pc_write),
    .address_target_id(address_target_id),
    .address_target_ex(address_target_ex),
    .jr_address(jr_address),
//    .PCSrc_id(PCSrc_id),
    .PCSrc_ex(EX_PCSrc),
    .is_jump(is_jump),
//    .zero(zero),
    .pc(pc_current),
    .pc_plus(pc_plus_2),
    .pc_next(pc_next_internal),
    .branch_taken(branch_taken)
    );
    
    IM #(
        .ADDR_WIDTH(16),
        .DATA_WIDTH(16),
        .MEM_SIZE(256),
        .INIT_FILE("program.mem")
    ) instruction_memory (
        .addr(pc_current),
        .instr(instruction)
    );
    
endmodule

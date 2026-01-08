`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:15:35 PM
// Design Name: 
// Module Name: PC_System
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


module PC(
    input  wire        clk,      // Clock signal
    input  wire        rst,      // Reset signal (active high)
    input  wire        halt,     // Halt signal (active high)
    input  wire        write,     // pc_enable signal (active high)
    input  wire [15:0] pc_next,  // Next PC value from MUX
    output reg  [15:0] pc        // Current PC value
);
    initial begin
        pc = 16'h0000;
    end
    always @(posedge clk or posedge rst) begin 
        if (rst) begin
            pc <= 16'h0000;
        end
        else if (!halt && write) begin
            pc <= pc_next;
        end
    end

endmodule

module ADD_PC (
    input [15:0] pc,
    output [15: 0] pc_plus
);

    assign pc_plus = pc + 16'd2;
endmodule

module MUX_PC(
    input wire rst,
    input wire [15:0] pc_plus,
    input wire [15:0] address_target_id,
    input wire [15:0] address_target_ex,
    input wire [15:0] jr_address,
//    input wire [1:0] PCSrc_id,
    input wire [1:0] PCSrc_ex,
    input wire is_jump,
//    input wire zero,
    input wire branch_taken,
    output reg [15:0] pc_next
);  
    always @(*) begin        
        if (is_jump === 1'b1) begin
            if (^address_target_id !== 1'bx && ^address_target_id !== 1'bz) begin
                pc_next = address_target_id;
            end
            else begin
                $display("[MUX_PC] WARNING: address_target_id=0x%04h is X/Z!", 
                         address_target_id);
            end
        end
        else if (PCSrc_ex == 2'b01) begin
            if (^jr_address !== 1'bx && ^jr_address !== 1'bz) begin
                pc_next = jr_address;
                $display(" address = %h", jr_address);
            end
            else $display(" ERROR ADDRESS %h", jr_address);
        end
        else if (branch_taken == 1'b1) begin
            if (^address_target_ex !== 1'bx && ^address_target_ex !== 1'bz) begin
                pc_next = address_target_ex;
            end
            if (branch_taken) begin
            $display("[MUX_PC] Time=%0t BRANCH! address_target_ex=0x%04h pc_next=0x%04h", 
                     $time, address_target_ex, pc_next);
            end
        end else if (^pc_plus === 1'bx || ^pc_plus === 1'bz) begin
            pc_next = 16'h0002;  
            $display("[MUX_PC] WARNING: pc_plus is X/Z!");
        end
        else begin
            pc_next = pc_plus;
        end
    end
endmodule

module PC_System(
    input  wire        clk,
    input  wire        rst,
    input  wire        halt,
    input  wire        write,                  // pc_enable from hazard
    input  wire [15:0] address_target_id,      // T? ID (jump)
    input  wire [15:0] address_target_ex,     // T? MEM (branch)
    input  wire [15:0] jr_address,
//    input  wire [1:0]  PCSrc_id,               // T? ID
    input  wire [1:0]  PCSrc_ex,              // T? MEM
    input  wire        is_jump,                // Jump signal t? ID
//    input  wire        zero,
    input  wire branch_taken,                   // Zero t? MEM
    output wire [15:0] pc,
    output wire [15:0] pc_plus,
    output wire [15:0] pc_next
);
    ADD_PC add_pc_inst (
        .pc(pc),
        .pc_plus(pc_plus)
    );
    
    MUX_PC mux_pc_inst (
        .rst(rst),
        .pc_plus(pc_plus),
        .address_target_id(address_target_id),
        .address_target_ex(address_target_ex),
        .jr_address(jr_address),
//        .PCSrc_id(PCSrc_id),
        .PCSrc_ex(PCSrc_ex),
        .is_jump(is_jump),
//        .zero(zero),
        .pc_next(pc_next),
        .branch_taken(branch_taken)
    );
    
    PC pc_inst (
        .clk(clk),
        .rst(rst),
        .halt(halt),
        .write(write),
        .pc_next(pc_next),
        .pc(pc)
    );
    
endmodule
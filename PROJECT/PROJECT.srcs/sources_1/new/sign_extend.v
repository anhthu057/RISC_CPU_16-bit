`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:21:16 PM
// Design Name: 
// Module Name: sign_extend
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

module sign_extend(
    input wire [5:0] immediate,
    output reg [15:0] sign_extend 
);
    always @(*) begin
        sign_extend = {{10{immediate[5]}}, immediate};
    end
endmodule


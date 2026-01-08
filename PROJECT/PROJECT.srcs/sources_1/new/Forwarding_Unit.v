module Forwarding_Unit(
    input [2:0] ID_EX_Rs,
    input [2:0] ID_EX_Rt,
    input [1:0] ID_EX_r_spec_regs,
    
    input [2:0] EX_MEM_Rd,
    input [1:0] EX_MEM_w_spec_regs,
    input EX_MEM_RegWrite,
    
    input [2:0] MEM_WB_Rd,
    input [1:0] MEM_WB_w_spec_regs,
    input MEM_WB_RegWrite,
    
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);
    
    always @(*) begin
        
        if (EX_MEM_RegWrite && (EX_MEM_Rd == ID_EX_Rs))begin
            ForwardA = 2'b10;
        end
    
        else if (MEM_WB_RegWrite && (MEM_WB_Rd == ID_EX_Rs)) begin
            ForwardA = 2'b01;
        end
    
        else begin
            ForwardA = 2'b00;
         end 
    end
    
    always @(*) begin
        if (EX_MEM_RegWrite && ((EX_MEM_Rd == ID_EX_Rt) || 
            (EX_MEM_w_spec_regs == 2'b00 && ID_EX_r_spec_regs == 2'b00) ||
            (EX_MEM_w_spec_regs == 2'b01 && ID_EX_r_spec_regs == 2'b10))) begin
            ForwardB = 2'b10;
        end
        
        else if (MEM_WB_RegWrite && ((MEM_WB_Rd == ID_EX_Rt) ||
            (MEM_WB_w_spec_regs == 2'b00 && ID_EX_r_spec_regs == 2'b00) ||
            (MEM_WB_w_spec_regs == 2'b01 && ID_EX_r_spec_regs == 2'b10)))begin
            ForwardB = 2'b01;
        end
        
        else begin
            ForwardB = 2'b00;
        end
    end    
endmodule
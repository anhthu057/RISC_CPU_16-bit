module registers_file(
    input wire clk,
    input wire rst,
    input wire reg_write,
    input wire [2:0] write_reg,      // Register address to write (0-7)
    input wire [15:0] write_data,
    input wire [2:0] rs,             // Source register 1 (0-7)
    input wire [2:0] rt,             // Source register 2 (0-7)
    input wire [1:0] r_spec_regs,    // Read special register selector
    input wire [1:0] w_spec_regs,    // Write special register selector
    output wire [15:0] rd1,          // Data from rs or special reg
    output wire [15:0] rd2           // Data from rt
);
    
    // Register mapping:
    // $0-$7   : General purpose registers
    // $8=$zero: Always 0
    // $9=$at  : Assembler temporary
    // $10=$ra : Return address
    
    reg [15:0] regs [0:10];  // 11 registers total
    reg [3:0] actual_write_reg;  // 4-bit to support up to reg 12
    
    integer i;
    
    // Determine actual write register based on w_spec_regs
    always @(*) begin
        case (w_spec_regs)
            2'b00: actual_write_reg = 4'd10; //ra
            2'b01: actual_write_reg = 4'd9; //at
            default: actual_write_reg = {1'b0, write_reg};
        endcase
    end
    
//    initial begin
//        for (i = 0; i <= 12; i = i + 1) begin
//            regs[i] = 16'd0;
//        end
//    end
    integer i;
    // WRITE: Sequential logic (on clock edge)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize all registers to 0
            for (i = 0; i <= 10; i = i + 1) begin
                regs[i] <= 16'd0;
//                  regs[i] = i;
            end
        end 
        else begin
            // Write to register (but $0 and $8=$zero are hardwired to 0)
            if (reg_write && actual_write_reg != 4'd8) begin
                regs[actual_write_reg] <= write_data;
            end
        end
    end
    
    // ? READ: Combinatorial logic for rd1 (with special register support)
    reg [15:0] rd1_data;
    always @(*) begin
        case (r_spec_regs)
            2'b00: rd1_data = (actual_write_reg == 4'd8 && reg_write)? write_data : regs[4'd8];      // $zero
            2'b10: rd1_data = (actual_write_reg == 4'd9 && reg_write)? write_data : regs[4'd9];        // $at
            2'b01: rd1_data = (actual_write_reg == 4'd10 && reg_write)? write_data : regs[4'd10];        // $ra
            default: begin
               rd1_data = (actual_write_reg == rs && reg_write) ? write_data : regs[{1'b0, rs}];
            end
        endcase
    end
    
    assign rd1 = rd1_data;
    assign rd2 = (actual_write_reg == rt && reg_write) ? write_data : regs[{1'b0, rt}];
endmodule
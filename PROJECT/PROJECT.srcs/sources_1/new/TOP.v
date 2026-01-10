`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 09:31:44 PM
// Design Name: 
// Module Name: TOP
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
module TOP(
    input wire clk,
    input wire rst,
    
    output wire [15:0] pc_current,
    output wire [15:0] result_final,
    output wire [3:0] write_reg,
    output wire [1:0] spec_reg_id
);
    wire [15:0] IF_pc_current;
    wire [15:0] IF_pc_plus_2;
    wire [15:0] IF_instruction;
    
    wire [15:0] ID_pc;
    wire [15:0] ID_pc_plus;
    wire [15:0] ID_instruction;
    wire IF_ID_Write;
    
    wire ID_regDst, ID_ALUSrc, ID_memRead, ID_memWrite;
    wire ID_regWrite, ID_memToReg, ID_halt;
    wire [1:0] ID_PCSrc;
    wire [5:0] ID_ALU_cnt;
    wire [1:0] ID_r_spec_regs, ID_w_spec_regs;
    
    // them dong nay
    wire ID_is_jump;
    reg halt_detected;
    wire halt_signal;
    
    wire [15:0] jr_address;
    wire [15:0] j_address;
    
    wire [15:0] ID_rd1, ID_rd2;
    wire [15:0] ID_br_target;
    wire [15:0] ID_extended_int; //
    wire [15:0] ID_pc_out;
    wire [2:0] ID_rs, ID_rt, ID_rd;
    
    wire [5:0] EX_ALU_cnt;
    wire [1:0] EX_PCSrc;
    wire [1:0] EX_r_spec_regs, EX_w_spec_regs;
    wire EX_regDst, EX_ALUSrc, EX_memWrite, EX_memRead;
    wire EX_regWrite, EX_memToReg, EX_halt;
    wire branch_taken;

    wire [15:0] EX_pc, EX_pc_plus;
    wire [15:0] EX_rd1, EX_rd2;
    wire [15:0] EX_sign_ext, EX_br_target; // tu ID
    wire [2:0] EX_rs, EX_rt, EX_rd;
//    wire [2:0] EX_funct;
    
    wire [15:0] EX_alu_result;
    wire [15:0] EX_forward_rd2;
    wire EX_zero;
    wire [1:0] EX_ForwardA, EX_ForwardB;
    
    
    wire MEM_memWrite, MEM_memRead, MEM_regWrite, MEM_memToReg;
    wire [1:0] MEM_PCSrc;
    wire [1:0] MEM_w_spec_regs;
    wire MEM_halt;
    
    wire [15:0] MEM_pc, MEM_pc_plus;
    wire [15:0] MEM_alu_result;
    wire [15:0] MEM_rd2;
    wire [15:0] MEM_br_target;
    wire [2:0] MEM_write_reg;
    wire MEM_zero;
    
    wire [2:0] EX_MEM_Rd;
    wire EX_MEM_RegWrite;
    
    wire [15:0] MEM_read_data_out;
    wire [15:0] MEM_alu_result_out;
    wire [2:0] MEM_write_reg_addr_out;
    wire MEM_memToReg_out;
    wire MEM_regWrite_out;
    wire [1:0] MEM_w_spec_regs_out;
    wire MEM_halt_out;
    
    wire WB_regWrite;
    wire WB_memToReg;
    wire WB_halt;
    wire [1:0] WB_w_spec_regs;
    wire [15:0] WB_read_data;
    wire [15:0] WB_alu_result;
    wire [2:0] WB_write_reg_addr;
    
    wire [15:0] WB_write_data;
    wire WB_halt_out;
    
    wire pc_write;
    
    assign pc_write = IF_ID_Write;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            halt_detected <= 1'b0;
        end 
        else if (ID_halt) begin
            halt_detected <= 1'b1;
        end
    end
    assign halt_signal = ID_halt | halt_detected;
    
    //==========================================================================
    // IF STAGE
    //==========================================================================
    IF_Stage if_stage (
        .clk(clk),
        .rst(rst),
        .halt(halt_signal),           // Halt t? MEM stage
        .pc_write(IF_ID_Write),           // T? hazard detection
        .address_target_id(j_address), // T? ID stage
        .address_target_ex(EX_br_target),
        .pc_current(IF_pc_current),
        .pc_plus_2(IF_pc_plus_2),
        .instruction(IF_instruction),
        .is_jump(ID_is_jump),
        .branch_taken(branch_taken),
        //them
        .jr_address(jr_address),
        .EX_PCSrc(EX_PCSrc)
    );
    
    //==========================================================================
    // IF/ID REGISTER
    //==========================================================================
    IF_ID_Register if_id_reg (
        .clk(clk),
        .rst(rst),
        .IF_ID_Write(IF_ID_Write && !halt_signal),     // T? hazard detection
        .IF_pc(IF_pc_current),
        .IF_pc_plus(IF_pc_plus_2),
        .IF_instruction(IF_instruction),
        .ID_pc(ID_pc),
        .ID_pc_plus(ID_pc_plus),
        .ID_instruction(ID_instruction),
        
        // them
        .IF_ID_Flush(ID_is_jump || branch_taken || ID_PCSrc == 2'b01)
    );
    
    //==========================================================================
    // ID STAGE
    //==========================================================================
    ID_Stage id_stage (
        .clk(clk),
        .rst(rst),
        .pc(ID_pc),
        .inst(ID_instruction),
        
        // Write back signals t? WB stage
        .regWrite_wb(WB_regWrite),
        .write_reg(WB_write_reg_addr),
        .write_data(WB_write_data),
        .w_spec_regs_wb(WB_w_spec_regs),
        
        // Hazard detection inputs
        .ex_rt(EX_rt),
        .ex_memRead(EX_memRead),

        // Control outputs
        .regDst(ID_regDst),
        .ALUSrc(ID_ALUSrc),
        .memRead(ID_memRead),
        .memWrite(ID_memWrite),
        .regWrite(ID_regWrite),
        .memToReg(ID_memToReg),
        .PCSrc(ID_PCSrc),
        .ALU_cnt(ID_ALU_cnt),
//        .hi_write(ID_hi_write),
//        .lo_write(ID_lo_write),
        .r_spec_regs(ID_r_spec_regs),
        .w_spec_regs(ID_w_spec_regs),
        .halt(ID_halt),
        
        // Data outputs
        .rd1(ID_rd1),
        .rd2(ID_rd2),
        .branch_target(ID_br_target),
        .extended_int(ID_extended_int),
        .pc_out(ID_pc_out),
        .id_rs(ID_rs),
        .id_rt(ID_rt),
        .id_rd(ID_rd),
        
        // Hazard output
        .Write(IF_ID_Write),
        
        // them
        .is_jump(ID_is_jump),
        .j_address(j_address)
    );
    
    //==========================================================================
    // ID/EX REGISTER
    //==========================================================================
    ID_EX_Register id_ex_reg (
        .clk(clk),
        .rst(rst),
        
        // Control signals
        .ID_ALU_cnt(ID_ALU_cnt),
        .ID_PCSrc(ID_PCSrc),
        .ID_r_spec_regs(ID_r_spec_regs),
        .ID_w_spec_regs(ID_w_spec_regs),
        .ID_regDst(ID_regDst),
        .ID_ALUSrc(ID_ALUSrc),
        .ID_memWrite(ID_memWrite),
        .ID_memRead(ID_memRead),
        .ID_regWrite(ID_regWrite),
        .ID_memToReg(ID_memToReg),
//        .ID_hi_write(ID_hi_write),
//        .ID_lo_write(ID_lo_write),
        .ID_halt(ID_halt),
        
        // Data signals
        .ID_pc(ID_pc_out),
        .ID_pc_plus(ID_pc_plus),
        .ID_rd1(ID_rd1),
        .ID_rd2(ID_rd2),
        .ID_sign_ext(ID_extended_int),
        .ID_br_target(ID_br_target),
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_rd(ID_rd),
        
        // Outputs
        .EX_ALU_cnt(EX_ALU_cnt),
        .EX_PCSrc(EX_PCSrc),
        .EX_r_spec_regs(EX_r_spec_regs),
        .EX_w_spec_regs(EX_w_spec_regs),
        .EX_regDst(EX_regDst),
        .EX_ALUSrc(EX_ALUSrc),
        .EX_memWrite(EX_memWrite),
        .EX_memRead(EX_memRead),
        .EX_regWrite(EX_regWrite),
        .EX_memToReg(EX_memToReg),
//        .EX_hi_write(EX_hi_write),
//        .EX_lo_write(EX_lo_write),
        .EX_halt(EX_halt),
        .EX_pc(EX_pc),
        .EX_pc_plus(EX_pc_plus),
        .EX_rd1(EX_rd1),
        .EX_rd2(EX_rd2),
        .EX_sign_ext(EX_sign_ext),
        .EX_br_target(EX_br_target),
        .EX_rs(EX_rs),
        .EX_rt(EX_rt),
        .EX_rd(EX_rd),
//        .EX_funct(EX_funct)
        // them ne
        .ID_EX_Flush(ID_is_jump || branch_taken)
    );
    
    //==========================================================================
    // EX STAGE
    //==========================================================================
    EX_Stage ex_stage (
        .clk(clk),
        .rst(rst),
        
        // ID/EX inputs
        .ID_EX_Rs(EX_rs),
        .ID_EX_Rt(EX_rt),
        .ID_EX_rd1(EX_rd1),
        .ID_EX_rd2(EX_rd2),
        .ID_EX_sign_extend(EX_sign_ext),
        .ID_EX_PC(EX_pc),
        .ID_EX_r_spec_regs(EX_r_spec_regs),
        
        // Control
        .ALU_cnt(EX_ALU_cnt),
        .ALUSrc(EX_ALUSrc),
        
        // Forwarding t? EX/MEM
        .EX_MEM_Rd(MEM_write_reg),
        .EX_MEM_RegWrite(MEM_regWrite),
        .EX_MEM_alu_result(MEM_alu_result),
        .EX_MEM_w_spec_regs(EX_w_spec_regs),
        
        // Forwarding t? MEM/WB
        .MEM_WB_Rd(WB_write_reg_addr),
        .MEM_WB_RegWrite(WB_regWrite),
        .MEM_WB_write_data(WB_write_data),
        .MEM_WB_w_spec_regs(MEM_w_spec_regs_out),
        
        // Outputs
        .alu_result(EX_alu_result),
        .forward_rd2(EX_forward_rd2),
        .zero(EX_zero),
        .ForwardA_out(EX_ForwardA),
        .ForwardB_out(EX_ForwardB),
        .PCSrc(EX_PCSrc),
        .branch_taken(branch_taken),
        //them
        .forward_rd1(jr_address)
    );
    
    //==========================================================================
    // EX/MEM REGISTER
    //==========================================================================
    EX_MEM_Register ex_mem_reg (
        .clk(clk),
        .rst(rst),
        
        // Control signals
        .EX_memWrite(EX_memWrite),
        .EX_memRead(EX_memRead),
        .EX_regWrite(EX_regWrite),
        .EX_memtoReg(EX_memToReg),
        .EX_w_spec_regs(EX_w_spec_regs),
//        .EX_hi_write(EX_hi_write),
//        .EX_lo_write(EX_lo_write),
        .EX_halt(EX_halt),
        
//        .EX_PCSrc(EX_PCSrc),
        
        // Data signals
        .EX_pc(EX_pc),
        .EX_pc_plus(EX_pc_plus),
        .EX_alu_result(EX_alu_result),
        .EX_rd2(EX_forward_rd2),       // Forwarded data cho SW
//        .EX_br_target(EX_br_target),
        .EX_write_reg(EX_rd),          // Destination register
        
        // Outputs
        .MEM_memWrite(MEM_memWrite),
        .MEM_memRead(MEM_memRead),
        .MEM_regWrite(MEM_regWrite),
        .MEM_memtoReg(MEM_memToReg),
        .MEM_w_spec_regs(MEM_w_spec_regs),
//        .MEM_hi_write(MEM_hi_write),
//        .MEM_lo_write(MEM_lo_write),
        .MEM_halt(MEM_halt),
        .MEM_pc(MEM_pc),
        .MEM_pc_plus(MEM_pc_plus),
        .MEM_alu_result(MEM_alu_result),
        .MEM_rd2(MEM_rd2),
//        .MEM_br_target(MEM_br_target),
        .MEM_write_reg(MEM_write_reg)
        
//        .MEM_PCSrc(MEM_PCSrc)
    );
    
    //==========================================================================
    // MEM STAGE
    //==========================================================================
    MEM_Stage mem_stage (
        .clk(clk),
        
        // Control inputs
        .memRead(MEM_memRead),
        .memWrite(MEM_memWrite),
        .memToReg_in(MEM_memToReg),
        .regWrite_in(MEM_regWrite),
        .w_spec_regs_in(MEM_w_spec_regs),
        .halt_in(MEM_halt),
        
        // Data inputs
        .alu_result(MEM_alu_result),
        .write_data_mem(MEM_rd2),
        .write_reg_addr_in(MEM_write_reg),
        
        // Outputs
        .read_data_out(MEM_read_data_out),
        .alu_result_out(MEM_alu_result_out),
        .write_reg_addr_out(MEM_write_reg_addr_out),
        .memToReg_out(MEM_memToReg_out),
        .regWrite_out(MEM_regWrite_out),
        .w_spec_regs_out(MEM_w_spec_regs_out),
        .halt_out(MEM_halt_out)
    );
    
    //==========================================================================
    // MEM/WB REGISTER
    //==========================================================================
    MEM_WB_Register mem_wb_reg (
        .clk(clk),
        .rst(rst),
        
        // Control signals
        .regWrite_in(MEM_regWrite_out),
        .memToReg_in(MEM_memToReg_out),
        .w_spec_regs_in(MEM_w_spec_regs_out),
        .halt_in(MEM_halt_out),
        
        // Data signals
        .read_data_in(MEM_read_data_out),
        .alu_result_in(MEM_alu_result_out),
        .write_reg_addr_in(MEM_write_reg_addr_out),
        
        // Outputs
        .regWrite_out(WB_regWrite),
        .memToReg_out(WB_memToReg),
        .halt_out(WB_halt),
        .w_spec_regs_out(WB_w_spec_regs),
        .read_data_out(WB_read_data),
        .alu_result_out(WB_alu_result),
        .write_reg_addr_out(WB_write_reg_addr)
    );   
    
    WRITEBACK_Stage wb_stage (
        .memToReg_in(WB_memToReg),
        .halt_in(WB_halt),
        .read_data_in(WB_read_data),
        .alu_result_in(WB_alu_result),
        .wb_final_data(WB_write_data),
        .halt_out(WB_halt_out)
    );
    
    assign pc_current = IF_pc_current;
    assign result_final = WB_write_data;
    assign write_reg = id_stage.regFile.actual_write_reg;
    assign spec_reg_id = WB_w_spec_regs;
endmodule

module TOP_tb;
    reg clk;
    reg rst;
    wire [15:0] pc_current;
    wire [15:0] result_final;
    wire [3:0] write_reg;
    wire [1:0] spec_reg_id;
    
    wire [15:0] R_zero = uut.id_stage.regFile.regs[8];
    wire [15:0] hi = uut.ex_stage.alu_system.alu.div_hi;
    wire [15:0] lo = uut.ex_stage.alu_system.alu.div_lo;
    wire [15:0] r0 = uut.id_stage.regFile.regs[0];
    
    TOP uut(
        .clk(clk),
        .rst(rst),
        .pc_current(pc_current),
        .result_final(result_final),
        .write_reg(write_reg),
        .spec_reg_id(spec_reg_id)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Reset và simulation control
    initial begin
        rst = 1;
        #20;
        rst = 0;
        
        #150;  // T?ng th?i gian ?? test nhi?u l?nh h?n
        $display("\n========== SIMULATION FINISHED ==========");
        $finish;
    end
    
    // Cycle counter
    integer cycle;
    initial cycle = 0;
    
    // Monitor chi ti?t t?ng stage
    always @(posedge clk) begin
        if (!rst) begin
            cycle = cycle + 1;
            
            $display("\n===============================================================");
            $display("               CYCLE %0d (Time=%0t)", cycle, $time);
            $display("===============================================================");
            
            // IF Stage
            $display("IF STAGE:");
            $display("  PC = 0x%h | Instruction = 0x%h", 
                     pc_current, uut.IF_instruction);
            $display("  pc next = 0x%h | branch taken = %0b | jump = %b | PCSrc = %b", 
                        uut.if_stage.pc_system.pc_next, uut.branch_taken, uut.ID_is_jump, uut.if_stage.pc_system.mux_pc_inst.PCSrc_ex);         
            
            // ID Stage
            $display("ID STAGE:");
            $display("  PC = 0x%h | Instruction = 0x%h", 
                     uut.ID_pc, uut.ID_instruction);
            $display("  RS = R%0d | RT = R%0d | RD = R%0d", 
                     uut.ID_rs, uut.ID_rt, uut.ID_rd);
            $display("  RD1 = 0x%h | RD2 = 0x%h", 
                     uut.ID_rd1, uut.ID_rd2);
            $display("  Control: RegWrite=%b MemRead=%b MemWrite=%b ALUSrc=%b ALUCount=%b w_spec_regs=%b",
                     uut.ID_regWrite, uut.ID_memRead, uut.ID_memWrite, uut.ID_ALUSrc, uut.ID_ALU_cnt, uut.ID_w_spec_regs);
            $display("  Address = %h", uut.ID_br_target);             
            $display(" regFile %h", uut.id_stage.regFile.regs[8]); 
            
            // EX Stage
            $display("EX STAGE:");
            $display("  PC = 0x%h", uut.EX_pc);
            $display("  RS = R%0d | RT = R%0d | RD = R%0d", 
                     uut.EX_rs, uut.EX_rt, uut.EX_rd);
            $display("  Operand1 = 0x%h | Operand2 = 0x%h", 
                     uut.EX_rd1, uut.EX_rd2);      
            $display("  signed_op1 = 0x%h | signed_op2 = 0x%h", 
                     $signed(uut.ex_stage.alu_system.alu.rs1), $signed(uut.ex_stage.alu_system.alu.out));  
            $display("  ALU Result = 0x%h | Zero = %b", 
                     uut.EX_alu_result, uut.EX_zero);
            $display("  Forward: A=%b B=%b", 
                     uut.EX_ForwardA, uut.EX_ForwardB);
            $display("  w_spec_regs=%b", uut.EX_w_spec_regs);
            $display("  hi = %0d | lo = %0d", 
                      uut.ex_stage.alu_system.alu.div_hi,uut.ex_stage.alu_system.alu.div_lo);
            $display("  branch_target = %h | PCSrc = %b", uut.EX_br_target, uut.EX_PCSrc);
            
            // MEM Stage
            $display("MEM STAGE:");
            $display("  PC = 0x%h", uut.MEM_pc);
            $display("  ALU Result = 0x%h | Write Reg = R%0d", 
                     uut.MEM_alu_result, uut.MEM_write_reg);
            $display("  Memory: Read=%b Write=%b | Data = 0x%h",
                     uut.MEM_memRead, uut.MEM_memWrite, uut.MEM_rd2);
            $display("  Read Data = 0x%h", uut.MEM_read_data_out);
            $display("  Reg_write = %b | w_spec_regs=%b", 
                    uut.MEM_regWrite, uut.MEM_w_spec_regs);
            $display("  branch_target = %h | PCSrc = %b", uut.if_stage.pc_system.jr_address, uut.MEM_PCSrc);
            
            // WB Stage
            $display("WB STAGE:");
            $display("  Write Reg = R%0d | Write Data = 0x%h", 
                     uut.WB_write_reg_addr, uut.WB_write_data);
            $display("  RegWrite = %b | MemToReg = %b",
                     uut.WB_regWrite, uut.WB_memToReg);
            $display("  Halt = %b", uut.WB_halt);
            $display("  w_spec_regs=%b", uut.WB_w_spec_regs);
            
            // Final Result
            $display("FINAL RESULT = 0x%h (%0d)", result_final, result_final);
            $display("===============================================================");
            
            // Hazard detection
            if (!uut.IF_ID_Write)
                $display("*** PIPELINE STALL DETECTED! ***");
        end
    end
    
    // Monitor khi có register write
    always @(posedge clk) begin
        if (!rst && uut.WB_regWrite && uut.WB_w_spec_regs == 2'b10) begin
            $display(">>> Register Write: R%0d <= 0x%h", 
                     uut.WB_write_reg_addr, uut.WB_write_data);
        end
        if (!rst && uut.WB_regWrite && uut.WB_w_spec_regs != 2'b10) begin
            $display(">>> Special Register Write: R%0d <= 0x%h", 
                     uut.id_stage.regFile.actual_write_reg, uut.WB_write_data);
        end
    end
    
    // Monitor khi có memory access
    always @(posedge clk) begin
        if (!rst) begin
            if (uut.MEM_memWrite)
                $display(">>> Memory Write: MEM[0x%h] <= 0x%h", 
                         uut.MEM_alu_result, uut.MEM_rd2);
            if (uut.MEM_memRead)
                $display(">>> Memory Read: MEM[0x%h] => 0x%h", 
                         uut.MEM_alu_result, uut.MEM_read_data_out);
        end
    end
    
    // Dump waveform
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, TOP_tb);
        
        // Dump thêm register file n?u mu?n xem chi ti?t
        // $dumpvars(0, uut.id_stage.register_file);
    end
    
    // In ra register file cu?i cùng (optional)
    initial begin
        #25;  // ??i reset xong
        @(posedge uut.WB_halt);  // ??i halt signal
        #50;
        $display("\n?????????????????????????????????????????????");
        $display("?         FINAL REGISTER FILE STATE         ?");
        $display("?????????????????????????????????????????????");
        // Uncomment n?u b?n có th? access register file
        // for (int i = 0; i < 8; i = i + 1) begin
        //     $display("? R%0d = 0x%h", i, uut.id_stage.register_file.registers[i]);
        // end
        $display("?????????????????????????????????????????????");
    end
    
endmodule
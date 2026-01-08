`timescale 1ns / 1ps
module data_memory(
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
    input wire [15:0] address,     // tu thanh ghi rs
    input wire [15:0] write_data,    // du lieu tu rt 

    output reg [15:0] read_data      // du lieu doc ra (rt)
);
    // Bo nho du lieu
    reg [15:0] memory [0:1023];
    
    // Bi?n tính ch? s? th?c t? (Word Index)
    wire [15:0] word_index;
    integer i;

    // Chuy?n ??i t? Byte Address sang Word Index (Chia 2)
    assign word_index = address >> 1; // T??ng ???ng address[15:1]

    // 2. KH?I T?O (Xóa s?ch b? nh? khi b?t ??u)
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 16'd0;
        end
    end

    // 3. ??C D? LI?U (CÓ X? LÝ TRÀN)
    always @(*) begin
        if (MemRead) begin
            // Ki?m tra: N?u ch? s? n?m trong dung l??ng cho phép
            if (word_index < 1024) 
                read_data = memory[word_index];
            else 
                // X? LÝ TRÀN: Tr? v? 0 n?u CPU ?òi ??c vùng nh? quá xa ho?c s? âm
                read_data = 16'd0; 
        end else begin
            read_data = 16'b0;
        end
    end

    // 4. GHI D? LI?U (CÓ X? LÝ TRÀN)
    always @(posedge clk) begin
        if (MemWrite) begin
            // Ki?m tra: Ch? cho phép ghi n?u ??a ch? h?p l?
            if (word_index < 1024) 
                memory[word_index] <= write_data;
            // N?u tràn (else), t? ??ng l? ?i, không làm h?ng RAM.
        end
    end
endmodule
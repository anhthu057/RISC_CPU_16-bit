# 16-bit RISC CPU Design based on MIPS Architecture (Pipeline)

## 📝 Giới thiệu
Dự án tập trung vào việc thiết kế và hiện thực một bộ xử lý **RISC CPU 16-bit** dựa trên kiến trúc MIPS thu gọn, sử dụng ngôn ngữ mô tả phần cứng **Verilog HDL**. CPU được thiết kế theo cấu trúc **Pipeline 5 giai đoạn** tiêu chuẩn, tích hợp các cơ chế xử lý xung đột dữ liệu và điều khiển nâng cao để tối ưu hóa hiệu suất thực thi lệnh.

## 🚀 Đặc điểm kỹ thuật
* **Kiến trúc:** RISC 16-bit, dựa trên tập lệnh MIPS thu gọn.
* **Pipeline Stage:** 5 giai đoạn (IF, ID, EX, MEM, WB).
* **Định dạng lệnh:** Hỗ trợ đầy đủ 3 loại định dạng R-type, I-type và J-type.
* **Cơ chế xử lý Hazard:**
    * **Forwarding Unit:** Giải quyết Data Hazard (RAW) bằng cách chuyển tiếp dữ liệu trực tiếp từ các giai đoạn sau về EX.
    * **Hazard Detection Unit:** Tự động phát hiện load-use hazard, thực hiện stall pipeline và chèn bubble (NOP).
    * **Flush Mechanism:** Xử lý Control Hazard khi thực hiện các lệnh Jump/Branch.
* **Hệ thống thanh ghi:** Register File gồm 8 thanh ghi đa dụng và các thanh ghi chức năng đặc biệt ($HI, $LO, $RA, $AT, $PC).

## 🛠 Công cụ sử dụng
* **Ngôn ngữ:** Verilog HDL.
* **Phần mềm:** Xilinx Vivado (Synthesis, Simulation, Implementation).
* **Thiết bị mục tiêu:** FPGA Arty-Z7.

## 📊 Sơ đồ khối hệ thống (Datapath)
<p align="center">
  <img src="https://raw.githubusercontent.com/anhthu057/RISC_CPU_16-bit/main/SODOKHOI.png" width="850" title="Sơ đồ khối CPU">
  <br>
  <em>Kiến trúc chi tiết của bộ vi xử lý</em>
</p>

## 📈 Kết quả thực thi
Dựa trên kết quả mô phỏng và tổng hợp trên Vivado:
* **CPI (Cycles Per Instruction):** ~1.21 (đạt hiệu suất cao nhờ cấu trúc Pipeline).
* **Tần số hoạt động tối đa:** ~421.58 MHz.
* **Công suất tiêu thụ:** 0.119 W (Thiết kế tối ưu năng lượng).

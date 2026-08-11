# SerDes-PHY

Dự án **SerDes-PHY** mô phỏng và kiểm thử giao tiếp Serializer/Deserializer (SerDes) ở mức RTL, sử dụng **SystemVerilog + UVM** để xây dựng testbench và regression.

## 🚀 Cách chạy regression

1. **Compile UVM package và project**
   ```tcl
   vlog -sv +define+UVM_NO_DPI +incdir+$uvm_path $uvm_path/uvm_pkg.sv
   vlog -sv -svinputport=relaxed +incdir+$uvm_path -f ./TB/tb/serdes_run.f

vsim -c -coverage work.tb_top "+UVM_TESTNAME=serdes_random_test" -do "run -all; coverage save random.ucdb; quit -sim;"
vsim -c -coverage work.tb_top "+UVM_TESTNAME=serdes_zero_test"   -do "run -all; coverage save zero.ucdb; quit -sim;"
vsim -c -coverage work.tb_top "+UVM_TESTNAME=serdes_one_test"    -do "run -all; coverage save one.ucdb; quit -sim;"
vsim -c -coverage work.tb_top "+UVM_TESTNAME=serdes_5_packet_test" -do "run -all; coverage save five.ucdb; quit -sim;"

vcover merge serdes_all.ucdb random.ucdb zero.ucdb one.ucdb five.ucdb
vcover report -html -htmldir covhtmlreport serdes_all.ucdb

🧪 Các testcase
serdes_random_test: sinh payload ngẫu nhiên.

serdes_zero_test: kiểm thử payload bằng 0.

serdes_one_test: kiểm thử payload bằng 0xFF.

serdes_5_packet_test: gửi 5 packet liên tục.

📊 Coverage
Dự án sử dụng covergroup để đo lường:

Payload_A / Payload_B: bins zero, random, one.

Dir: src_A, src_B.

Cross coverage: kết hợp payload và hướng truyền.

## SerDes High Level Block
![SerDes Architecture](Image/Quad-lane Full duplex Serializer_Deserializer(SerDes)-SerDes Block Diagram.drawio.png)

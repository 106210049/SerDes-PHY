# SerDes-PHY

The ***SerDes-PHY*** project simulates and verifies ***Serializer/Deserializer (SerDes) communication*** at the RTL level, ***using SystemVerilog and UVM*** to build the testbench and regression.

## 🚀 Cách chạy regression

1. **Compile UVM package and project**
Step 1: Open QuestaSim on Terminal: vsim
Step 2: Run regression test: do run.do

🧪 Các testcase
serdes_random_test: Generage random payload.

serdes_zero_test: Verify test with payload = 0.

serdes_one_test: Verify test with payload = 0xFF.

serdes_5_packet_test: Generage and send 5 packet continuosly.

📊 Coverage
Project is using coverage report to evaluate the functional verification results
Payload_A / Payload_B: bins zero, random, one.

Dir: src_A, src_B.

Cross coverage: Combine payload and source direction.

## SerDes High Level Block
 <img src="Image/Quad-lane Full duplex Serializer_Deserializer(SerDes)-SerDes Block Diagram.drawio.png" width="700" >  
 
### Serializer Block
 <img src="Image/Quad-lane Full duplex Serializer_Deserializer(SerDes)-Serializer.drawio.png" width="700" >  

### Deserializer Block
<img src="Image/Quad-lane Full duplex Serializer_Deserializer(SerDes)-Deserializer.drawio.png" width="700" >  

### Serializer CTL Block
<img src="Image/Quad-lane Full duplex Serializer_Deserializer(SerDes)-Serializer CTL.drawio.png" width="700" >  

### Deserializer CTL Block
<img src="Image/Quad-lane Full duplex Serializer_Deserializer(SerDes)-Deserializer CTL.drawio.png" width="700" >  


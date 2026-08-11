# SerDes-PHY

The ***SerDes-PHY*** project simulates and verifies ***Serializer/Deserializer (SerDes) communication*** at the RTL level, ***using SystemVerilog and UVM*** to build the testbench and regression.
This project is oriented towards the RTL design, verification using UVM of a Quad-lane Full duplex Serializer/Deserializer (SerDes).
## 🚀 How to run regression

1. **Compile UVM package and project**

Step 1: Open QuestaSim on Terminal: vsim

Step 2: Run regression test: do run.do

🧪 Testcases
serdes_random_test: Generage random payload.

serdes_zero_test: Verify test with payload = 0.

serdes_one_test: Verify test with payload = 0xFF.

serdes_5_packet_test: Generage and send 5 packet continuosly.

## 📊 Coverage
Project is using coverage report to evaluate the functional verification results
Payload_A / Payload_B: bins zero, random, one.

Dir: src_A, src_B.

Cross coverage: Combine payload and source direction.

All the system verilog design files of various sub components, encoder(8b/10b) , PISO(10b), SIPO, decoder(10b/8b), and the TOP module along with a basic randomized testbenh are provided in the RTL folder. The SerDes.sv is the main SerDes design file, the Duplex_Top.sv file instantiaties this and connects the serializer with deserializer for verification purposes.

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


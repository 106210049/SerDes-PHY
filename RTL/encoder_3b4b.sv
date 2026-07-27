module encoder_3b4b (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [2:0]  data_3b_in,
  input  logic        enc_en,
  output logic [3:0]  data_4b_out
);

  logic [3:0] temp_4b;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      temp_4b <= '0;
    end else begin
      if(enc_en) begin
        // Ánh xạ 3b -> 4b
        case(data_3b_in)
          3'b000: temp_4b <= 4'b0100;
          3'b001: temp_4b <= 4'b1001;
          3'b010: temp_4b <= 4'b0101;
          3'b011: temp_4b <= 4'b0011;
          3'b100: temp_4b <= 4'b0010;
          3'b101: temp_4b <= 4'b1010;
          3'b110: temp_4b <= 4'b0110;
          3'b111: temp_4b <= 4'b0001; // alt7 sẽ xử lý riêng
          default: temp_4b <= 4'b0000; 
        endcase
        
      end
    end
  end
  assign data_4b_out = temp_4b;
endmodule

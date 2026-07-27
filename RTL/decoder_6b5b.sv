module decoder_6b5b (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        dec_en,
    input  logic [5:0]  data_6b_in,
    output logic [4:0]  data_5b_out
);

  logic [4:0] temp_5b;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      temp_5b <= '0;
    end else begin
      if (dec_en) begin
        case (data_6b_in)
          6'b011000: temp_5b <= 5'b00000;
          6'b011101: temp_5b <= 5'b00001;
          6'b010010: temp_5b <= 5'b00010;     
          6'b110001: temp_5b <= 5'b00011;
          6'b110101: temp_5b <= 5'b00100;
          6'b101001: temp_5b <= 5'b00101;
          6'b011001: temp_5b <= 5'b00110;
          6'b111000: temp_5b <= 5'b00111;
          6'b111001: temp_5b <= 5'b01000;
          6'b100101: temp_5b <= 5'b01001;
          6'b010101: temp_5b <= 5'b01010;
          6'b110100: temp_5b <= 5'b01011;
          6'b001101: temp_5b <= 5'b01100;
          6'b101100: temp_5b <= 5'b01101;
          6'b011100: temp_5b <= 5'b01110;
          6'b010111: temp_5b <= 5'b01111;
          6'b011011: temp_5b <= 5'b10000;
          6'b100011: temp_5b <= 5'b10001;
          6'b010011: temp_5b <= 5'b10010;
          6'b110010: temp_5b <= 5'b10011;
          6'b001011: temp_5b <= 5'b10100;
          6'b101010: temp_5b <= 5'b10101;
          6'b011010: temp_5b <= 5'b10110;
          6'b111010: temp_5b <= 5'b10111;
          6'b110011: temp_5b <= 5'b11000;
          6'b100110: temp_5b <= 5'b11001;
          6'b010110: temp_5b <= 5'b11010;
          6'b110110: temp_5b <= 5'b11011;
          6'b001110: temp_5b <= 5'b11100;
          6'b101110: temp_5b <= 5'b11101;
          6'b011110: temp_5b <= 5'b11110;
          6'b101011: temp_5b <= 5'b11111;
          default:   temp_5b <= 5'b00000;
        endcase

      end
    end
  end
  assign data_5b_out = temp_5b;
endmodule

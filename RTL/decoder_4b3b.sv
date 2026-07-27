module decoder_4b3b(
  input  logic        clk,
  input  logic        rst_n,
  input  logic        dec_en,
  input  logic [3:0]  data_4b_in,
  output logic [2:0]  data_3b_out
);

  logic [2:0] temp_3b;

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      temp_3b <= '0;
    end else begin
      if(dec_en) begin
        case(data_4b_in)
          4'b0100: temp_3b <= 3'b000;
          4'b1001: temp_3b <= 3'b001;
          4'b0101: temp_3b <= 3'b010;
          4'b0011: temp_3b <= 3'b011;
          4'b0010: temp_3b <= 3'b100;
          4'b1010: temp_3b <= 3'b101;
          4'b0110: temp_3b <= 3'b110;
          4'b0001: temp_3b <= 3'b111;
          default: temp_3b <= 3'b000; 
        endcase

      end
    end
  end
  assign data_3b_out = temp_3b;
endmodule

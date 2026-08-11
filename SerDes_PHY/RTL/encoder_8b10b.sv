module encoder_8b10b (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [7:0]  data_8b_in,   
  input  logic        enc_en,
  output logic [9:0]  data_10b_out  
);

  logic [4:0] data_5b; 
  assign data_5b = data_8b_in[4:0];
  logic [2:0] data_3b; 
  assign data_3b = data_8b_in[7:5];

  logic [5:0] data_6b;
  logic [3:0] data_4b;

  encoder_5b6b u_5b6b (
    .clk(clk),
    .rst_n(rst_n),
    .data_5b_in(data_5b),
    .enc_en(enc_en),
    .data_6b_out(data_6b)
  );

  encoder_3b4b u_3b4b (
    .clk(clk),
    .rst_n(rst_n),
    .data_3b_in(data_3b),
    .enc_en(enc_en),
    .data_4b_out(data_4b)
  );

  assign data_10b_out = {data_4b, data_6b};

endmodule

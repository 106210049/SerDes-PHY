module Serializer (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] data_in,        // 32-bit input
    input  logic        enc_en,
    input  logic        load,
    output logic        serial_o_1,
    output logic        serial_o_2,
    output logic        serial_o_3,
    output logic        serial_o_4
);

    // Tách dữ liệu thành 4 byte
  	logic [7:0] data_byte1; 
  	assign data_byte1 = data_in[31:24];
  	logic [7:0] data_byte2; 
  	assign data_byte2 = data_in[23:16];
  	logic [7:0] data_byte3; 
  	assign data_byte3 = data_in[15:8];
  	logic [7:0] data_byte4; 
  	assign data_byte4 = data_in[7:0];

    // Kết quả từ encoder
    logic [9:0] data_10b_1, data_10b_2, data_10b_3, data_10b_4;

    // 4 khối encoder 8b/10b độc lập (không disparity)
    encoder_8b10b u_enc1 (
        .clk(clk), .rst_n(rst_n),
        .data_8b_in(data_byte1),
        .enc_en(enc_en),
        .data_10b_out(data_10b_1)
    );

    encoder_8b10b u_enc2 (
        .clk(clk), .rst_n(rst_n),
        .data_8b_in(data_byte2),
        .enc_en(enc_en),
        .data_10b_out(data_10b_2)
    );

    encoder_8b10b u_enc3 (
        .clk(clk), .rst_n(rst_n),
        .data_8b_in(data_byte3),
        .enc_en(enc_en),
        .data_10b_out(data_10b_3)
    );

    encoder_8b10b u_enc4 (
        .clk(clk), .rst_n(rst_n),
        .data_8b_in(data_byte4),
        .enc_en(enc_en),
        .data_10b_out(data_10b_4)
    );

    // 4 khối PISO: song song → nối tiếp
    PISO u_piso1 (.clk(clk), .rst_n(rst_n), .par_in(data_10b_1), .load(load), .ser_out(serial_o_1));
    PISO u_piso2 (.clk(clk), .rst_n(rst_n), .par_in(data_10b_2), .load(load), .ser_out(serial_o_2));
    PISO u_piso3 (.clk(clk), .rst_n(rst_n), .par_in(data_10b_3), .load(load), .ser_out(serial_o_3));
    PISO u_piso4 (.clk(clk), .rst_n(rst_n), .par_in(data_10b_4), .load(load), .ser_out(serial_o_4));

endmodule

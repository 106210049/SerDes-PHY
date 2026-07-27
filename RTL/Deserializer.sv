`include "SIPO.sv"
`include "decoder_10b8b.sv"

module Deserializer (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        serial_in_1,   // 4 kênh dữ liệu nối tiếp
    input  logic        serial_in_2,
    input  logic        serial_in_3,
    input  logic        serial_in_4,
    input  logic        dec_en,
    input  logic        shift_en,
    output logic [7:0]  data_out1,
    output logic [7:0]  data_out2,
    output logic [7:0]  data_out3,
    output logic [7:0]  data_out4
);

    // Song song 10 bit từ SIPO
    logic [9:0] par_out1, par_out2, par_out3, par_out4;

    // 4 khối SIPO
    SIPO u_sipo1 (
        .clk      (clk),
        .rst_n    (rst_n),
        .ser_in   (serial_in_1),
        .shift_en (shift_en),
        .par_out  (par_out1)
    );

    SIPO u_sipo2 (
        .clk      (clk),
        .rst_n    (rst_n),
        .ser_in   (serial_in_2),
        .shift_en (shift_en),
        .par_out  (par_out2)
    );

    SIPO u_sipo3 (
        .clk      (clk),
        .rst_n    (rst_n),
        .ser_in   (serial_in_3),
        .shift_en (shift_en),
        .par_out  (par_out3)
    );

    SIPO u_sipo4 (
        .clk      (clk),
        .rst_n    (rst_n),
        .ser_in   (serial_in_4),
        .shift_en (shift_en),
        .par_out  (par_out4)
    );

    decoder_10b8b u_dec1 (
        .clk(clk), .rst_n(rst_n),
        .dec_en(dec_en),
        .data_10b_in(par_out1),
        .data_8b_out(data_out1)
    );

    decoder_10b8b u_dec2 (
        .clk(clk), .rst_n(rst_n),
        .dec_en(dec_en),
        .data_10b_in(par_out2),
        .data_8b_out(data_out2)
    );

    decoder_10b8b u_dec3 (
        .clk(clk), .rst_n(rst_n),
        .dec_en(dec_en),
        .data_10b_in(par_out3),
        .data_8b_out(data_out3)
    );

    decoder_10b8b u_dec4 (
        .clk(clk), .rst_n(rst_n),
        .dec_en(dec_en),
        .data_10b_in(par_out4),
        .data_8b_out(data_out4)
    );

endmodule

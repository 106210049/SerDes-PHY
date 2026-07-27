`include "SerDes.sv"
module Duplex_Top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] data_in_A,
    input  logic [31:0] data_in_B,
    input  logic        i_enc_A,
    input  logic        i_dec_A,
    input  logic        i_enc_B,
    input  logic        i_dec_B,
    output logic [31:0] data_out_A,
    output logic [31:0] data_out_B,
    output logic 		count_pre_last_A,
  	output logic 		count_pre_last_B
);

    // Serial links
    logic [3:0] serial_A;
    logic [3:0] serial_B;

    // Instance A
    SerDes serdes_A (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in_A),
        .i_enc(i_enc_A),
        .i_dec(i_dec_A),
        .data_out(data_out_A),
        .count_pre_last(count_pre_last_A),
        .deser_finish(),
        // nối serial output của A sang input của B
        .serial_o_1(serial_A[0]),
        .serial_o_2(serial_A[1]),
        .serial_o_3(serial_A[2]),
        .serial_o_4(serial_A[3]),
        .serial_in_1(serial_B[0]),
        .serial_in_2(serial_B[1]),
        .serial_in_3(serial_B[2]),
        .serial_in_4(serial_B[3])
    );

    // Instance B
    SerDes serdes_B (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in_B),
        .i_enc(i_enc_B),
        .i_dec(i_dec_B),
        .data_out(data_out_B),
        .count_pre_last(count_pre_last_B),
        .deser_finish(),
        // nối serial output của B sang input của A
        .serial_o_1(serial_B[0]),
        .serial_o_2(serial_B[1]),
        .serial_o_3(serial_B[2]),
        .serial_o_4(serial_B[3]),
        .serial_in_1(serial_A[0]),
        .serial_in_2(serial_A[1]),
        .serial_in_3(serial_A[2]),
        .serial_in_4(serial_A[3])
    );

endmodule

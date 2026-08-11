
module SerDes (
    input  logic        clk,
    input  logic        rst_n,

    // song song vào
    input  logic [31:0] data_in,
    input  logic        i_enc,

    // song song ra
    output logic [31:0] data_out,
    input  logic        i_dec,

    // serial TX ra
    output logic serial_o_1,
    output logic serial_o_2,
    output logic serial_o_3,
    output logic serial_o_4,

    // serial RX vào
    input  logic serial_in_1,
    input  logic serial_in_2,
    input  logic serial_in_3,
    input  logic serial_in_4,

    // cờ trạng thái
    output logic count_pre_last,
    output logic deser_finish
);

    // Tín hiệu nội bộ
    logic enc_en, load, start_o, ser_shift;
    logic deser_shift, dec_en;
    logic [7:0] data_out1, data_out2, data_out3, data_out4;

    // Serializer (TX)
    Serializer u_serializer (
        .clk       (clk),
        .rst_n     (rst_n),
        .data_in   (data_in),
        .enc_en    (enc_en),
        .load      (load),
        .serial_o_1(serial_o_1),
        .serial_o_2(serial_o_2),
        .serial_o_3(serial_o_3),
        .serial_o_4(serial_o_4)
    );

    // Deserializer (RX)
    Deserializer u_deserializer (
        .clk        (clk),
        .rst_n      (rst_n),
        .serial_in_1(serial_in_1),
        .serial_in_2(serial_in_2),
        .serial_in_3(serial_in_3),
        .serial_in_4(serial_in_4),
        .dec_en     (dec_en),
        .shift_en   (deser_shift),
        .data_out1  (data_out1),
        .data_out2  (data_out2),
        .data_out3  (data_out3),
        .data_out4  (data_out4)
    );

    // Control
    CTL u_ctl (
        .clk        (clk),
        .rst_n      (rst_n),
        .i_enc      (i_enc),
        .i_dec      (i_dec),
        .enc_en     (enc_en),
        .load       (load),
        .start_o    (start_o),
        .ser_shift  (ser_shift),
        .count_pre_last(count_pre_last),
        .deser_shift(deser_shift),
        .dec_en     (dec_en),
        .deser_finish(deser_finish)
    );

    // Ghép 4 byte thành 32-bit
    assign data_out = (deser_finish) ? {data_out1, data_out2, data_out3, data_out4} : '0;

endmodule

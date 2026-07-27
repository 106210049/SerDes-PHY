`include "Serializer_CTL.sv"
`include "Deserializer_CTL.sv"

module CTL (
    input  logic clk,
    input  logic rst_n,
    input  logic i_enc,
    input  logic i_dec,
    // Outputs từ Serializer
    output logic enc_en,
    output logic load,
    output logic start_o,
    output logic ser_shift,
    output logic count_pre_last,
    // Outputs từ Deserializer
    output logic deser_shift,
    output logic dec_en,
  	output logic deser_finish
);

    // Khối Serializer Control
    Serializer_CTL u_serializer_ctl (
        .clk       (clk),
        .rst_n     (rst_n),
        .i_enc     (i_enc),
        .enc_en    (enc_en),
        .load      (load),
        .start_o   (start_o),
        .ser_shift (ser_shift),
        .count_pre_last(count_pre_last)
    );

    // Khối Deserializer Control
    Deserializer_CTL u_deserializer_ctl (
        .clk        (clk),
        .rst_n      (rst_n),
        .i_dec      (i_dec),
        .deser_shift(deser_shift),
        .dec_en     (dec_en),
        .deser_finish(deser_finish)
    );

endmodule

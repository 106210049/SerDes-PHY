
module Deserializer_CTL(
    input  logic clk,
    input  logic rst_n,
    input  logic i_dec,
    output logic deser_shift,
    output logic dec_en,
  	output logic deser_finish
);


    // Instance FSM
    deserializer_fsm u_fsm (
        .clk        (clk),
        .rst_n      (rst_n),
        .i_dec      (i_dec),
        .count_done (count_done),
        .deser_shift(deser_shift),
        .dec_en     (dec_en),
        .deser_finish(deser_finish)
    );

    // Instance Counter
    deserializer_counter u_counter (
        .clk        (clk),
        .rst_n      (rst_n),
        .count_en   (deser_shift), // enable đếm khi đang shift
        .count_done (count_done)
    );

endmodule

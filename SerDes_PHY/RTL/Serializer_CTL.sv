module Serializer_CTL (
    input  logic clk,
    input  logic rst_n,
    input  logic i_enc,
    output logic enc_en,
    output logic load,
    output logic start_o,
    output logic ser_shift,
  	output logic count_pre_last
);

    // Tín hiệu nội bộ
    logic count_done;

    // FSM điều khiển
    serializer_fsm u_fsm (
        .clk       (clk),
        .rst_n     (rst_n),
        .i_enc     (i_enc),
        .count_done(count_done),
        .enc_en    (enc_en),
        .load      (load),
        .start_o   (start_o),
        .ser_shift (ser_shift)
    );

    // Counter đếm bit khi SHIFT
    serializer_counter u_counter (
        .clk       (clk),
        .rst_n     (rst_n),
        .count_en  (ser_shift),   // enable đếm khi FSM đang SHIFT
      	.count_pre_last(count_pre_last),
        .count_done(count_done)
    );

endmodule

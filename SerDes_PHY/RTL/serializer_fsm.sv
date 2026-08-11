module serializer_fsm (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        i_enc,
  	input  logic   		count_done,
    output logic        enc_en,
    output logic        load,
    output logic        start_o,
    output logic        ser_shift
);

    typedef enum logic [2:0] {
        IDLE    = 3'b000,
        ENCODER = 3'b001,
        LOAD    = 3'b010,
        SHIFT   = 3'b011
//         FINISH  = 3'b100
    } state_t;

    state_t current_state, next_state;

    // Thanh ghi trạng thái
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Gộp logic chuyển trạng thái và đầu ra
    always_comb begin
        // Mặc định
        next_state = current_state;
        enc_en     = 1'b0;
        load       = 1'b0;
        start_o    = 1'b0;
        ser_shift  = 1'b0;
        case (current_state)
            IDLE: begin
                if (i_enc)
                    next_state = ENCODER;
                else 
                    next_state = IDLE;
            end

            ENCODER: begin
                enc_en     = 1'b1;
              	start_o    = 1'b0;
                ser_shift  = 1'b0;
                next_state = LOAD;   // hoặc FINISH tùy điều kiện thực tế
            end

            LOAD: begin
                load       = 1'b1;
              	enc_en	   = 1'b0;
                start_o    = 1'b1;
                next_state = SHIFT;
            end

            SHIFT: begin
                ser_shift  = 1'b1;
                if (count_done)
                    next_state = ENCODER;
                else
                    next_state = SHIFT;
            end

//             FINISH: begin
//                 start_o    = 1'b0;
//                 ser_shift  = 1'b0;
//               	ser_finish = 1'b1;
//                 next_state = ENCODER;
//             end
        endcase
    end

endmodule

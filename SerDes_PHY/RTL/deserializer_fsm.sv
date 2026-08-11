module deserializer_fsm (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        i_dec,
    input  logic 		count_done,   // giả sử bộ đếm bit 4-bit
    output logic        deser_shift,
    output logic        dec_en,
  	output logic		deser_finish
);

    // Khai báo trạng thái
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        SHIFT   = 2'b01,
        DECODER = 2'b10,
      	FINISH	= 2'b11
    } state_t;

    state_t current_state, next_state;

    // Thanh ghi trạng thái
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Logic chuyển trạng thái
    always_comb begin
        // Mặc định
        next_state   = current_state;
        deser_shift  = 1'b0;
        dec_en       = 1'b0;
        deser_finish = 1'b0;

        case (current_state)
            IDLE: begin
                if (i_dec)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end

            SHIFT: begin
                deser_shift = 1'b1;
                if (count_done)
                    next_state = DECODER;
                else
                    next_state = SHIFT;
            end

            DECODER: begin
                dec_en     = 1'b1;
                next_state = FINISH;
            end

            FINISH: begin
                deser_finish = 1'b1;
                next_state  = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule

module serializer_counter (
    input  logic clk,
    input  logic rst_n,
    input  logic count_en,
  	output logic count_pre_last,
    output logic count_done
);

    logic [3:0] bit_count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_count <= 4'd0;
        else if (count_en) begin
            if (bit_count == 4'd10)
                bit_count <= 4'd0;   // reset về 0 khi đạt 10
            else
                bit_count <= bit_count + 1'b1;
        end
    end

    // Tín hiệu báo hoàn thành
    assign count_done = (bit_count == 4'd10);
  	assign count_pre_last = (bit_count == 4'd9);
endmodule

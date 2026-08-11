
module decoder_10b8b (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        dec_en,
    input  logic [9:0]  data_10b_in,   
    output logic [7:0]  data_8b_out   
);

    logic [5:0] data_6b; 
    assign data_6b = data_10b_in[5:0];
    logic [3:0] data_4b; 
    assign data_4b = data_10b_in[9:6];

    logic [4:0] data_5b;
    logic [2:0] data_3b;

    // Khối 6b/5b
    decoder_6b5b u_6b5b (
        .clk(clk),
        .rst_n(rst_n),
        .dec_en(dec_en),
        .data_6b_in(data_6b),
        .data_5b_out(data_5b)
    );

    // Khối 4b/3b
    decoder_4b3b u_4b3b (
        .clk(clk),
        .rst_n(rst_n),
        .dec_en(dec_en),
        .data_4b_in(data_4b),
        .data_3b_out(data_3b)
    );

    assign data_8b_out = {data_3b, data_5b};
endmodule

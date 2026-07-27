module SIPO(
    input 	logic 		clk,
    input 	logic 		rst_n,
    input 	logic 		ser_in,
    input 	logic 		shift_en,
    output 	logic [9:0] par_out
);

    logic [9:0]       shift_reg;

  always @ (posedge clk or negedge rst_n)begin
    	if (!rst_n) begin
            shift_reg <= 0;
            par_out <=0;
        end
        else begin
            if (shift_en) begin
               shift_reg <= {ser_in,shift_reg[9:1] }; 
            end
        	par_out <= shift_reg;
        end
    end
endmodule 
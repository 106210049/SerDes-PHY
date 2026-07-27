module PISO(
    input logic clk,
    input logic rst_n,
    input logic [9:0] par_in,
    input logic load,
    output logic ser_out
);

    logic [9:0] shift_reg;

  always @ (posedge clk or negedge rst_n)begin
    	if (!rst_n) begin
            shift_reg <= 0;
        end 
        else begin 
          if (load) begin
                shift_reg <= par_in;
            end
            else begin
                ser_out <= shift_reg[0];
                shift_reg <= {1'b0, shift_reg[9:1]};  
                end
        end
    end

endmodule
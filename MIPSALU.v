
module MIPSALU(
	input [3:0]ALUctl,
	input [31:0]A,
	input [31:0]B,
	output reg [31:0]ALUOut,
	output Zero	
);

assign Zero = (ALUOut==0);
always @*
	begin
		case(ALUctl)
			4'd0: ALUOut <= A & B;
			4'd1: ALUOut <= A | B;
			4'd2: ALUOut <= A + B;
			4'd6: ALUOut <= A - B;
			4'd7: ALUOut <= A<B?1:0;
			4'd12: ALUOut <= ~(A | B);
			default: ALUOut <= 0;
		endcase
	end

endmodule  
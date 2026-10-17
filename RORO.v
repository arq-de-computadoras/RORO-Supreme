module RORO(
	input [11:0] instruccion,
	output [31:0] resultado,
	output ZF
);

wire [31:0] c1, c2;

ROM Roma(
	.DirL({2'b00, instruccion[7:4]}), // <-- Extensión a 6 bits
	.Data(c1)
);

ROM Romina(
	.DirL({2'b00, instruccion[3:0]}), // <-- Extensión a 6 bits
	.Data(c2)
);

MIPSALU Pablo(
	.ALUctl(instruccion[11:8]),
	.A(c1),
	.B(c2),
	.ALUOut(resultado),
	.Zero(ZF)
);

endmodule
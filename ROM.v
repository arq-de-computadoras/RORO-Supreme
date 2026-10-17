//1. declaracion de modulo y I/O
module ROM #(parameter DATA_FILE = "initData.txt") (
	input [5:0] DirL,       // CAMBIO 1: 6 bits (para 64 posiciones)
	output [31:0] Data
);

//componente interno Memoria
reg [31:0] srom [0:63];    // CAMBIO 2: 64 posiciones (0 a 63)

assign Data = srom[DirL];

initial 
begin
	// CAMBIO 3: Carga desde archivo.
	$readmemb(DATA_FILE, srom); 
	
	$display("Cargando archivo %s en ROM. Posición 0 = %h", DATA_FILE, srom[0]);
end

endmodule
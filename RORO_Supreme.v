// RORO_Supreme: modulo superior de la actividad
//
//   DirInstr[3:0] -> ROM_Instrucciones (16 x 12) -> instruccion[11:0]
//   instruccion   -> RORO (ROMa + ROMina + MIPSALU) -> DD[31:0], ZF
//
// Formato de la instruccion: OP[11:8] | R1[7:4] | R2[3:0]
// No hay contador de programa: la direccion la controla el testbench.
module RORO_Supreme(
	input  [3:0]  DirInstr,     // direccion de la instruccion (0 a 15)
	output [11:0] Instruccion,  // instruccion leida (se saca para verla en simulacion)
	output [31:0] DD,           // resultado de la ALU
	output        ZF            // bandera de cero
);

// ROM de instrucciones (ROM_instrucciones.v), se carga con instrucciones.txt
ROM_Instrucciones RomInstr(
	.addr(DirInstr),
	.instruccion(Instruccion)
);

// Bloque RORO: dos ROM de datos + ALU
RORO Roro(
	.instruccion(Instruccion),
	.resultado(DD),
	.ZF(ZF)
);

// RORO.v instancia sus dos ROM sin indicar archivo, por lo que ambas
// cargarian el archivo por defecto de ROM.v (initData.txt). Para no
// modificar RORO.v, desde aqui se le indica a cada ROM interna que
// archivo debe cargar, usando defparam sobre el parametro DATA_FILE.
defparam Roro.Roma.DATA_FILE   = "ROMa_init.txt";
defparam Roro.Romina.DATA_FILE = "ROMina_init.txt";

endmodule

`timescale 1ns / 1ps

// Testbench de RORO_Supreme: recorre las 16 direcciones de la ROM de
// instrucciones y compara OP, DD y ZF contra los valores esperados.
// Los esperados corresponden a los datos actuales de ROMa_init.txt y
// ROMina_init.txt (misma tabla que usa RORO_tb.v).
// Carga las tres memorias desde la carpeta P (ruta relativa).
// Se usa cuando el simulador corre en otra carpeta (por ejemplo
// simulation/questa en Quartus) y no encuentra los .txt.
`define CARGAR_MEMORIAS(P) \
    begin \
        $readmemb({P, "instrucciones.txt"}, DUT.RomInstr.memoria); \
        $readmemb({P, "ROMa_init.txt"},     DUT.Roro.Roma.srom);   \
        $readmemb({P, "ROMina_init.txt"},   DUT.Roro.Romina.srom); \
        $display("Archivos .txt cargados desde: %s", P); \
    end

module RORO_Supreme_tb;

    // Entrada que controla el testbench
    reg  [3:0]  DirInstr;

    // Salidas del sistema
    wire [11:0] Instruccion;
    wire [31:0] DD;
    wire        ZF;

    // Sistema completo bajo prueba
    RORO_Supreme DUT (
        .DirInstr(DirInstr),
        .Instruccion(Instruccion),
        .DD(DD),
        .ZF(ZF)
    );

    // Tabla de valores esperados (una posicion por instruccion)
    reg [3:0]  op_esp [0:15];
    reg [31:0] dd_esp [0:15];

    integer i;
    integer fd;   // para comprobar si existe un archivo
    integer pass_count;
    integer fail_count;
    reg     zf_esp;
    reg [8*5-1:0] nombre_op;

    initial begin
        // Sumas (OP = 0010)
        op_esp[0]  = 4'b0010; dd_esp[0]  = 32'd17;         // 12 + 5
        op_esp[1]  = 4'b0010; dd_esp[1]  = 32'd21;         // 7 + 14
        op_esp[2]  = 4'b0010; dd_esp[2]  = 32'd15;         // 5 + 10
        op_esp[3]  = 4'b0010; dd_esp[3]  = 32'd42;         // 12 + 30
        op_esp[4]  = 4'b0010; dd_esp[4]  = 32'd60;         // 40 + 20
        op_esp[5]  = 4'b0010; dd_esp[5]  = 32'd48;         // 18 + 30
        // Restas (OP = 0110)
        op_esp[6]  = 4'b0110; dd_esp[6]  = 32'd0;          // 0 - 0   -> ZF = 1
        op_esp[7]  = 4'b0110; dd_esp[7]  = 32'd9;          // 15 - 6
        op_esp[8]  = 4'b0110; dd_esp[8]  = 32'd3;          // 6 - 3
        op_esp[9]  = 4'b0110; dd_esp[9]  = 32'd7;          // 10 - 3
        op_esp[10] = 4'b0110; dd_esp[10] = 32'hFFFFFFFC;   // 7 - 11  = -4 (complemento a dos)
        op_esp[11] = 4'b0110; dd_esp[11] = 32'hFFFFFFFB;   // 5 - 10  = -5 (complemento a dos)
        // SLT (OP = 0111)
        op_esp[12] = 4'b0111; dd_esp[12] = 32'd1;          // 3 < 4   verdadero
        op_esp[13] = 4'b0111; dd_esp[13] = 32'd0;          // 5 < 5   falso -> ZF = 1
        op_esp[14] = 4'b0111; dd_esp[14] = 32'd1;          // 7 < 8   verdadero
        op_esp[15] = 4'b0111; dd_esp[15] = 32'd0;          // 6 < 1   falso -> ZF = 1

        pass_count = 0;
        fail_count = 0;

        $dumpfile("RORO_Supreme_tb.vcd");
        $dumpvars(0, RORO_Supreme_tb);

        // Ubicacion de los archivos .txt: si el simulador no corre en la
        // carpeta del proyecto, las ROM no los encuentran y todo sale en x.
        #1;
        fd = $fopen("instrucciones.txt", "r");
        if (fd != 0) begin
            $fclose(fd);
            $display("Archivos .txt encontrados en la carpeta de simulacion.");
        end else begin
            fd = $fopen("../../instrucciones.txt", "r");
            if (fd != 0) begin
                $fclose(fd);
                `CARGAR_MEMORIAS("../../")
            end else begin
                fd = $fopen("../instrucciones.txt", "r");
                if (fd != 0) begin
                    $fclose(fd);
                    `CARGAR_MEMORIAS("../")
                end else begin
                    fd = $fopen("../../../instrucciones.txt", "r");
                    if (fd != 0) begin
                        $fclose(fd);
                        `CARGAR_MEMORIAS("../../../")
                    end else begin
                        $display("ERROR: no se encontro instrucciones.txt. Copia instrucciones.txt,");
                        $display("       ROMa_init.txt y ROMina_init.txt a la carpeta donde corre la simulacion.");
                    end
                end
            end
        end

        $display("=== INICIANDO TESTBENCH DE RORO_Supreme: 16 instrucciones ===");
        $display("Dir | OP   R1   R2   | Oper  |   A     B   |     DD (hex)   con signo | ZF | Estado");

        for (i = 0; i < 16; i = i + 1) begin
            DirInstr = i;      // se selecciona la instruccion i
            #10;               // se espera a que el circuito responda
            zf_esp = (dd_esp[i] == 32'd0);

            case (Instruccion[11:8])
                4'b0010: nombre_op = "SUMA ";
                4'b0110: nombre_op = "RESTA";
                4'b0111: nombre_op = "SLT  ";
                default: nombre_op = "OTRA ";
            endcase

            if (Instruccion[11:8] === op_esp[i] && DD === dd_esp[i] && ZF === zf_esp) begin
                pass_count = pass_count + 1;
                $display("%2d  | %b %b %b | %s | %5d %5d | %h %10d | %b  | PASS",
                         i, Instruccion[11:8], Instruccion[7:4], Instruccion[3:0], nombre_op,
                         DUT.Roro.c1, DUT.Roro.c2, DD, $signed(DD), ZF);
            end else begin
                fail_count = fail_count + 1;
                $display("%2d  | %b %b %b | %s | %5d %5d | %h %10d | %b  | FAIL (esperado OP=%b DD=%h ZF=%b)",
                         i, Instruccion[11:8], Instruccion[7:4], Instruccion[3:0], nombre_op,
                         DUT.Roro.c1, DUT.Roro.c2, DD, $signed(DD), ZF,
                         op_esp[i], dd_esp[i], zf_esp);
            end
        end

        $display("=== RESULTADO: %0d PASS, %0d FAIL ===", pass_count, fail_count);
        $finish;
    end

endmodule

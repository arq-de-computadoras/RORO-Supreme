`timescale 1ns / 1ps

module RORO_tb;

    // 1. Declaración de señales de entrada (Registros para poder asignarles valores)
    reg [3:0] R1;
    reg [3:0] R2;
    reg [3:0] OP;

    // 2. Declaración de señales de salida (Cables para conectar a los módulos)
    wire [31:0] data_a;
    wire [31:0] data_b;
    wire [31:0] DD;
    wire ZF;

    // 3. Instanciar ROMa
    ROM #(.DATA_FILE("ROMa_init.txt")) rom_a (
        .DirL({2'b00, R1}), // Extensión a 6 bits
        .Data(data_a)
    );

    // 4. Instanciar ROMina
    ROM #(.DATA_FILE("ROMina_init.txt")) rom_ina (
        .DirL({2'b00, R2}),
        .Data(data_b)
    );

    // 5. Instanciar la ALU 
    MIPSALU alu (
        .A(data_a),
        .B(data_b),
        .ALUctl(OP),
        .ALUout(DD),      // Si tu ALU usa otro nombre como "Result", cámbialo aquí
        .Zero(ZF)
    );

    // 6. Tarea para verificar y reportar automáticamente PASS/FAIL
    task check_result;
        input [31:0] esperado_dd;
        input esperado_zf;
        input [8*10-1:0] nombre_caso; // Para imprimir el nombre del caso
        begin
            if (DD === esperado_dd && ZF === esperado_zf) begin
                $display("PASS: Caso %s | DD = %h, ZF = %b", nombre_caso, DD, ZF);
            end else begin
                $display("FAIL: Caso %s | Esperado: DD = %h, ZF = %b | Obtenido: DD = %h, ZF = %b", 
                         nombre_caso, esperado_dd, esperado_zf, DD, ZF);
            end
        end
    endtask

    // 7. Bloque inicial con los 16 casos de prueba
    initial begin
        $display("=== INICIANDO TESTBENCH DE BLOQUE: ROM + ROM + ALU ===");

        // --- CASO 0: Suma normal (12 + 5 = 17) ---
        OP = 4'b0010; R1 = 4'b0000; R2 = 4'b0000;
        #10; check_result(32'd17, 1'b0, "Suma 0");

        // --- CASO 1: Suma normal (7 + 14 = 21) ---
        OP = 4'b0010; R1 = 4'b0001; R2 = 4'b0001;
        #10; check_result(32'd21, 1'b0, "Suma 1");

        // --- CASO 2: Suma normal (5 + 10 = 15) ---
        OP = 4'b0010; R1 = 4'b0010; R2 = 4'b0010;
        #10; check_result(32'd15, 1'b0, "Suma 2");

        // --- CASO 3: Suma normal (12 + 30 = 42) ---
        OP = 4'b0010; R1 = 4'b0011; R2 = 4'b0011;
        #10; check_result(32'd42, 1'b0, "Suma 3");

        // --- CASO 4: Suma normal (40 + 20 = 60) ---
        OP = 4'b0010; R1 = 4'b0100; R2 = 4'b0100;
        #10; check_result(32'd60, 1'b0, "Suma 4");

        // --- CASO 5: Suma normal (18 + 30 = 48) ---
        OP = 4'b0010; R1 = 4'b0101; R2 = 4'b0101;
        #10; check_result(32'd48, 1'b0, "Suma 5");

        // --- CASO 6: Resta con cero (0 - 0 = 0) -> ZF=1 ---
        OP = 4'b0110; R1 = 4'b0110; R2 = 4'b0110;
        #10; check_result(32'd0, 1'b1, "Resta 0");

        // --- CASO 7: Resta positiva (15 - 6 = 9) ---
        OP = 4'b0110; R1 = 4'b0111; R2 = 4'b0111;
        #10; check_result(32'd9, 1'b0, "Resta 1");

        // --- CASO 8: Resta positiva (6 - 3 = 3) ---
        OP = 4'b0110; R1 = 4'b1000; R2 = 4'b1000;
        #10; check_result(32'd3, 1'b0, "Resta 2");

        // --- CASO 9: Resta positiva (10 - 3 = 7) ---
        OP = 4'b0110; R1 = 4'b1001; R2 = 4'b1001;
        #10; check_result(32'd7, 1'b0, "Resta 3");

        // --- CASO 10: Resta negativa (7 - 11 = -4) -> Hex FFFFFFFC ---
        OP = 4'b0110; R1 = 4'b1010; R2 = 4'b1010;
        #10; check_result(32'hFFFFFFFC, 1'b0, "Resta Neg");

        // --- CASO 11: Resta negativa (5 - 10 = -5) -> Hex FFFFFFFB ---
        OP = 4'b0110; R1 = 4'b1011; R2 = 4'b1011;
        #10; check_result(32'hFFFFFFFB, 1'b0, "Resta Neg2");

        // --- CASO 12: SLT Verdadero (3 < 4 = 1) ---
        OP = 4'b0111; R1 = 4'b1100; R2 = 4'b1100;
        #10; check_result(32'd1, 1'b0, "SLT True");

        // --- CASO 13: SLT Falso (5 < 5 = 0) -> ZF=1 ---
        OP = 4'b0111; R1 = 4'b1101; R2 = 4'b1101;
        #10; check_result(32'd0, 1'b1, "SLT False");

        // --- CASO 14: SLT Verdadero (7 < 8 = 1) ---
        OP = 4'b0111; R1 = 4'b1110; R2 = 4'b1110;
        #10; check_result(32'd1, 1'b0, "SLT True2");

        // --- CASO 15: SLT Falso (6 < 1 = 0) -> ZF=1 ---
        OP = 4'b0111; R1 = 4'b1111; R2 = 4'b1111;
        #10; check_result(32'd0, 1'b1, "SLT False2");

        $display("=== FIN DEL TESTBENCH ===");
        $finish;
    end

endmodule
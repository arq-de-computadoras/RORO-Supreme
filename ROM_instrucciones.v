module ROM_Instrucciones (
    input [3:0] addr,          // Dirección de 4 bits (16 posiciones)
    output reg [11:0] instruccion // Instrucción de 12 bits
);

    reg [11:0] memoria [0:15]; // 16 posiciones de 12 bits

    initial begin
        $readmemb("instrucciones.txt", memoria);
    end

    always @(*) begin
        instruccion = memoria[addr];
    end

endmodule
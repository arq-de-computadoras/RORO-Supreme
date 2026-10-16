# Actividad - RORO Supreme
**Materia:** Arquitectura de Computadoras - Informática

## 👥 Integrantes del Equipo
*   Adriel Bigvai Andrade Borrayo
*   Daniel Atilano ...
*(Todos los integrantes deben pertenecer a la organización y tener acceso al repositorio)*

## 🎯 Objetivo
Diseñar el módulo superior RORO Supreme para ejecutar una secuencia de 16 instrucciones de 12 bits. Reutilizar los módulos ROM, ALUMIPS y RORO proporcionados, crear la ROM de instrucciones y desarrollar los testbenches de RORO y del sistema completo.

## ⚙️ Funcionamiento
La ROM de instrucciones entrega una palabra de 12 bits. 
*   **OP [11:8]:** Selecciona la operación de la ALU.
*   **R1 [7:4]:** Selecciona posición de ROMa.
*   **R2 [3:0]:** Selecciona posición de ROMina.

Ambas memorias entregan operandos de 32 bits a la ALUMIPS. Las salidas son `DD[31:0]` y `ZF`. La selección de la siguiente instrucción se realiza mediante una dirección de 4 bits controlada por el testbench; no es necesario implementar un contador de programa.

*Nota:* Si se reutiliza la ROM entregada de 6 bits de dirección, se debe extender la dirección con dos ceros.

### Diagrama Lógico
```text
Dirección de instrucción [3:0] → ROM de instrucciones (16 x 12) → OP, R1, R2
R1 → ROMa (32 bits) ┐
                    ├→ ALUMIPS → DD[31:0], ZF
R2 → ROMina (32 bits) ┘
OP ─────────────────────→ ALUMIPS
```

## TODOs
*   Editar readme para hacerlo el reporte de actividad como se pide en el PDF.
*   Modificar ROM.v para hacerlo modular.
*   Modificar archivo RORO.v.
*   Modificar MIPSALU.v.
    Al modificar los archivos debe haber una justificacion para ello segun el PDF.
*   Realizar el modulo de RORO Supreme
*   Codificar testbench para archivos base modificados
*   Realizar el testbench para RORO Supreme

*Nota:* Si utilizas un software diferente a Quartus, puedes ignorar los archivos .qpf y .qsf
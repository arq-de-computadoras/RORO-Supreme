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

## 📋 Tabla de Instrucciones y Resultados Esperados

A continuación se documentan las 16 instrucciones diseñadas para el sistema, cumpliendo con la distribución de 6 sumas (`OP=0010`), 6 restas (`OP=0110`) y 4 comparaciones SLT (`OP=0111`). 

*Nota: El valor de `ZF` es 1 únicamente cuando el resultado `DD` es cero.*

| Dir. | Instrucción (Binario) | OP (Dec) | Operación | R1 | R2 | ROMa (Val A) | ROMina (Val B) | DD Esperado (Dec) | DD Esperado (Hex) | ZF Esperado | Caso de Prueba |
| :---: | :--- | :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| **0** | `0010 0000 0000` | 2 | Suma | 0 | 0 | 12 | 5 | **17** | `0x00000011` | 0 | Suma normal |
| **1** | `0010 0001 0001` | 2 | Suma | 1 | 1 | 7 | 14 | **21** | `0x00000015` | 0 | Suma normal |
| **2** | `0010 0010 0010` | 2 | Suma | 2 | 2 | 5 | 10 | **15** | `0x0000000F` | 0 | Suma normal |
| **3** | `0010 0011 0011` | 2 | Suma | 3 | 3 | 12 | 30 | **42** | `0x0000002A` | 0 | Suma normal |
| **4** | `0010 0100 0100` | 2 | Suma | 4 | 4 | 40 | 20 | **60** | `0x0000003C` | 0 | Suma normal |
| **5** | `0010 0101 0101` | 2 | Suma | 5 | 5 | 18 | 30 | **48** | `0x00000030` | 0 | Suma normal |
| **6** | `0110 0110 0110` | 6 | Resta | 6 | 6 | 0 | 0 | **0** | `0x00000000` | **1** | Resta con cero |
| **7** | `0110 0111 0111` | 6 | Resta | 7 | 7 | 15 | 6 | **9** | `0x00000009` | 0 | Resta positiva |
| **8** | `0110 1000 1000` | 6 | Resta | 8 | 8 | 6 | 3 | **3** | `0x00000003` | 0 | Resta positiva |
| **9** | `0110 1001 1001` | 6 | Resta | 9 | 9 | 10 | 3 | **7** | `0x00000007` | 0 | Resta positiva |
| **10** | `0110 1010 1010` | 6 | Resta | 10 | 10 | 7 | 11 | **-4** | `0xFFFFFFFC` | 0 | Resta negativa (Comp. a 2) |
| **11** | `0110 1011 1011` | 6 | Resta | 11 | 11 | 5 | 10 | **-5** | `0xFFFFFFFB` | 0 | Resta negativa (Comp. a 2) |
| **12** | `0111 1100 1100` | 7 | SLT | 12 | 12 | 3 | 4 | **1** | `0x00000001` | 0 | SLT Verdadero (3 < 4) |
| **13** | `0111 1101 1101` | 7 | SLT | 13 | 13 | 5 | 5 | **0** | `0x00000000` | **1** | SLT Falso (5 < 5) |
| **14** | `0111 1110 1110` | 7 | SLT | 14 | 14 | 7 | 8 | **1** | `0x00000001` | 0 | SLT Verdadero (7 < 8) |
| **15** | `0111 1111 1111` | 7 | SLT | 15 | 15 | 6 | 1 | **0** | `0x00000000` | **1** | SLT Falso (6 < 1) |

## TODOs
*   Editar readme para hacerlo el reporte de actividad como se pide en el PDF.
*   ~Modificar ROM.v para hacerlo modular.~
*   Modificar archivo RORO.v.
*   Modificar MIPSALU.v.
    Al modificar los archivos debe haber una justificacion para ello segun el PDF.
*   Realizar el modulo de RORO Supreme
*   Codificar testbench para archivos base modificados
*   Realizar el testbench para RORO Supreme

*Nota:* Si utilizas un software diferente a Quartus, puedes ignorar los archivos .qpf y .qsf

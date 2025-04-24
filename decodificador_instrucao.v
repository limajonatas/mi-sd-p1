module decodificador_instrucao (
    input  wire [31:0] instrucao,
    output wire [3:0]  opcode,
    output wire [2:0]  linha,
    output wire [2:0]  coluna,
    output wire [15:0] dado,
    output wire [1:0]  id_matriz
);

    assign opcode    = instrucao[31:28];
    assign linha     = instrucao[27:25];
    assign coluna    = instrucao[24:22];
    assign dado      = instrucao[21:6];
    assign id_matriz = instrucao[5:4];

endmodule

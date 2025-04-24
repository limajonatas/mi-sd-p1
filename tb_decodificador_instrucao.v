`timescale 1ns/1ps

module tb_decodificador_instrucao;

    // Entradas
    reg [31:0] instrucao;

    // Saídas
    wire [3:0] opcode;
    wire [2:0] linha;
    wire [2:0] coluna;
    wire [15:0] dado;
    wire [1:0] id_matriz;

    // Instanciar o módulo a ser testado
    decodificador_instrucao uut (
        .instrucao(instrucao),
        .opcode(opcode),
        .linha(linha),
        .coluna(coluna),
        .dado(dado),
        .id_matriz(id_matriz)
    );

    initial begin
        $display("Iniciando o teste...");

        // Teste 1: opcode = 4'b0010, linha = 3'b001, coluna = 3'b100, dado = 16'h1234, id_matriz = 2'b01
        instrucao = 32'b0010_001_100_0001001000110100_01_00; // ajustado com zeros no final

        #10; // esperar 10 ns

        $display("Instrucao   = %b", instrucao);
        $display("Opcode      = %b (esperado: 0010)", opcode);
        $display("Linha       = %b (esperado: 001)", linha);
        $display("Coluna      = %b (esperado: 100)", coluna);
        $display("Dado        = %h (esperado: 1234)", dado);
        $display("ID Matriz   = %b (esperado: 01)", id_matriz);

        $finish;
    end

endmodule

// Módulo principal: conecta todos os blocos e executa a lógica do coprocessador de matrizes
module coprocessador_matriz (
    input clk,
    input reset,
    input [27:0] instrucao,      // formato: [opcode(4), linha(3), coluna(3), dado(16), id(2)]
    input start_instr            // sinal para indicar início de uma instrução
);

    // Sinais internos decodificados da instrução
    wire [3:0] opcode;
    wire [2:0] linha, coluna;
    wire [1:0] id_matriz;
    wire [15:0] dado;

    // Conexões entre memória, ALU e controle
    wire [15:0] dado_lido, dado_b, resultado;  // Renomeado dado_a para dado_lido
    wire we, re, start_calc;
    wire [1:0] sel_operacao;

    // -----------------------------------------
    // Decodificador de instrução
    decodificador_instrucao decoder (
        .instrucao(instrucao),
        .opcode(opcode),
        .linha(linha),
        .coluna(coluna),
        .dado(dado),
        .id_matriz(id_matriz)
    );

    // -----------------------------------------
    // Máquina de estados (FSM) de controle
    fsm_coprocessador fsm (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .start_instr(start_instr),
        .we(we),                    // write enable
        .re(re),                    // read enable
        .start_calc(start_calc),    // ativa ALU
        .sel_operacao(sel_operacao) // define operação da ALU
    );

    // -----------------------------------------
    // Memória para matrizes A, B e C
    memoria_matrizes memoria (
        .clk(clk),
        .we(we),
        .re(re),
        .id_matriz(id_matriz),
        .linha(linha),
        .coluna(coluna),
        .dado_in(dado),             // valor vindo da instrução
        .dado_out(dado_lido)        // dado lido da memória (pode ser A, B ou C)
    );

    // -----------------------------------------
    // ALU de operação de elementos das matrizes
    alu_matriz alu (
        .clk(clk),
        .reset(reset),
        .start(start_calc),
        .sel_operacao(sel_operacao),
        .mat_a(dado_lido),          // dado lido da memória
        .mat_b(dado_b),             // dado lido de outra matriz (B ou C)
        .resultado(resultado),
        .done()                     // pode ser conectado futuramente para controle mais fino
    );

endmodule

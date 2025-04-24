// Módulo de controle FSM para o coprocessador de matrizes
module fsm_coprocessador (
    input clk,                   // clock do sistema
    input reset,                 // sinal de reset síncrono
    input [3:0] opcode,          // código da operação a ser realizada
    input start_instr,           // sinal que indica o início de uma instrução

    output reg we,               // write enable para memória
    output reg re,               // read enable para memória
    output reg start_calc,       // inicia a operação na ALU
    output reg [1:0] sel_operacao, // seleciona a operação da ALU (ex: soma, sub)
    
    output reg [2:0] estado      // estado atual (opcional: útil para debug)
);

    // Definição dos estados possíveis da FSM
    parameter IDLE      = 3'b000; // estado ocioso
    parameter WRITE_MEM = 3'b001; // escreve um valor na memória
    parameter READ_MEM  = 3'b010; // lê valores das matrizes
    parameter EXEC_CALC = 3'b011; // inicia operação da ALU
    parameter WAIT_CALC = 3'b100; // aguarda fim da operação da ALU
    parameter WRITE_RES = 3'b101; // escreve resultado na memória
    parameter FIM       = 3'b110; // finaliza e volta para IDLE

    // Próximo estado
    reg [2:0] prox_estado;

    // Atualiza o estado atual no clock ou reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            estado <= IDLE;
        else
            estado <= prox_estado;
    end

    // Lógica combinacional: define saídas e próximo estado
    always @(*) begin
        // valores padrão para evitar latch
        we = 0;
        re = 0;
        start_calc = 0;
        sel_operacao = 2'b00;
        prox_estado = estado;

        case (estado)
            IDLE: begin
                // espera início da instrução
                if (start_instr) begin
                    case (opcode)
                        4'b0001: prox_estado = WRITE_MEM;                     // escrever dado na memória
                        4'b0010: begin sel_operacao = 2'b00; prox_estado = READ_MEM; end // soma
                        4'b0011: begin sel_operacao = 2'b01; prox_estado = READ_MEM; end // subtração
                        4'b0100: begin sel_operacao = 2'b10; prox_estado = READ_MEM; end // oposto
                        default: prox_estado = IDLE; // operação inválida
                    endcase
                end
            end

            WRITE_MEM: begin
                // ativa escrita na memória
                we = 1;
                prox_estado = FIM;
            end

            READ_MEM: begin
                // ativa leitura da memória (matrizes A e B)
                re = 1;
                prox_estado = EXEC_CALC;
            end

            EXEC_CALC: begin
                // inicia cálculo na ALU
                start_calc = 1;
                prox_estado = WAIT_CALC;
            end

            WAIT_CALC: begin
                // simula espera da ALU (futuramente pode verificar sinal 'done')
                prox_estado = WRITE_RES;
            end

            WRITE_RES: begin
                // escreve resultado da ALU na memória C
                we = 1;
                prox_estado = FIM;
            end

            FIM: begin
                // encerra a instrução e volta para IDLE
                prox_estado = IDLE;
            end
        endcase
    end
endmodule

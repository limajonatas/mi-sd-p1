// ALU de matrizes: realiza operações aritméticas entre dois elementos (mat_a e mat_b)
module alu_matriz (
    input clk,
    input reset,
    input start,                           // sinal para iniciar a operação
    input [1:0] sel_operacao,             // seletor da operação (soma, subtração, etc.)
    input signed [15:0] mat_a,            // entrada A
    input signed [15:0] mat_b,            // entrada B
    output reg signed [15:0] resultado,   // resultado da operação
    output reg done                       // sinaliza fim da operação
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            resultado <= 0;
            done <= 0;
        end else if (start) begin
            case (sel_operacao)
                2'b00: resultado <= mat_a + mat_b;       // operação de soma
                2'b01: resultado <= mat_a - mat_b;       // operação de subtração
                2'b10: resultado <= -mat_a;              // matriz oposta
                default: resultado <= 0;
            endcase
            done <= 1; // sinaliza que a operação foi concluída
        end else begin
            done <= 0;
        end
    end

endmodule

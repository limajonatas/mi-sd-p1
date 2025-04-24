module memoria_matrizes (
    input wire clk,
    input wire we,             // write enable
    input wire re,             // read enable
    input wire [1:0] id_matriz,  // 00 = A, 01 = B, 10 = C
    input wire [2:0] linha,
    input wire [2:0] coluna,
    input wire [15:0] dado_in,
    output reg [15:0] dado_out
);

    // Memória interna para 3 matrizes 5x5 (25 posições cada)
    reg [15:0] matriz_A [0:24];
    reg [15:0] matriz_B [0:24];
    reg [15:0] matriz_C [0:24];

    wire [4:0] addr; // 5 bits para indexar 25 posições (0–24)
    assign addr = linha * 5 + coluna;

    always @(posedge clk) begin
        if (we) begin
            case (id_matriz)
                2'b00: matriz_A[addr] <= dado_in;
                2'b01: matriz_B[addr] <= dado_in;
                2'b10: matriz_C[addr] <= dado_in;
            endcase
        end

        if (re) begin
            case (id_matriz)
                2'b00: dado_out <= matriz_A[addr];
                2'b01: dado_out <= matriz_B[addr];
                2'b10: dado_out <= matriz_C[addr];
                default: dado_out <= 16'h0000;
            endcase
        end
    end

endmodule

## 💻Coprocessador Aritmético de Matrizes – DE1-SoC

Projeto desenvolvido em Verilog para a plataforma DE1-SoC, com o objetivo de criar um coprocessador dedicado a operações com matrizes quadradas de até 5x5. A proposta visa acelerar operações como soma, subtração, multiplicação por escalar, entre outras, utilizando paralelismo e arquitetura em pipeline.

### 🔧Funcionalidades Implementadas

- Decodificação de instruções
- Controle por FSM
- Estrutura modular com integração via `coprocessador_matriz`

### 🧠FSM (Finite State Machine)

A máquina de estados `fsm_coprocessador` controla o fluxo das operações conforme o `opcode` recebido, passando pelos estados de leitura, execução e escrita.

```verilog
case (opcode)
    4'b0001: prox_estado = WRITE_MEM;// escrever dado na memória
    4'b0010: begin sel_operacao = 2'b00; prox_estado = READ_MEM; end // soma
    4'b0011: begin sel_operacao = 2'b01; prox_estado = READ_MEM; end // subtração
    4'b0100: begin sel_operacao = 2'b10; prox_estado = READ_MEM; end // oposto
    default: prox_estado = IDLE; // operação inválida
endcase
```

### 🧾Formato da Instrução

As instruções enviadas ao coprocessador são codificadas em 32 bits e seguem o seguinte formato:

| Campo       | Bits       | Descrição                          |
|-------------|------------|------------------------------------|
| `opcode`    | [31:28]    | Código da operação a ser executada |
| `linha`     | [27:25]    | Índice da linha da matriz (0 a 4)  |
| `coluna`    | [24:22]    | Índice da coluna da matriz (0 a 4) |
| `dado`      | [21:6]     | Valor inteiro de 16 bits           |
| `id_matriz` | [5:4]      | Identificador da matriz: 00=A, 01=B, 10=C |


### Caminho de Instrução

O caminho de instrução envolve a decodificação e execução das operações solicitadas pelo processador ARM (HPS). A instrução é decodificada pelo módulo `decodificador_instrucao`, e o módulo de controle `fsm_coprocessador` coordena as etapas de leitura das matrizes, execução e armazenamento dos resultados.

### Caminho de Dados

O caminho de dados gerencia a transferência de informações entre os módulos de memória (`memoria_matrizes`) e a ALU. Dados das matrizes são lidos e passados para a ALU, que executa a operação aritmética (como soma ou subtração). O resultado final é então armazenado de volta na memória para ser utilizado em operações subsequentes.


### ✅ Conclusão

O projeto avançou na implementação da estrutura principal do coprocessador, incluindo controle por FSM, memória dedicada e decodificação de instruções. No entanto, não foi possível concluir todas as operações exigidas, como a implementação completa da ALU e a realização de testes práticos com a FPGA. 

Devido à falta de testes práticos, não foi possível verificar a funcionalidade do sistema, o que impede afirmar que a solução está completamente funcional. Além disso, operações como multiplicação de matrizes, transposição e cálculo do determinante ainda precisam ser implementadas. A integração com o código em C para comunicação com o HPS e a validação na FPGA também não foram realizadas, o que significa que o projeto não atendeu a todos os requisitos definidos inicialmente.

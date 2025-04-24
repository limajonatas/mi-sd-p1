<table>
  <tr>
    <td colspan="2"><h1>Problema 1</h1></td>
  </tr>
  <tr>
    <td><img src="https://creche.uefs.br/wp-content/uploads/2022/10/cropped-favico-brasao-uefs.png" alt="Logo da UEFS" width="50"/></td>
    <td><h2>UNIVERSIDADE ESTADUAL DE FEIRA DE SANTANA - UEFS</h2></td>
  </tr>
  <tr>
    <td colspan="2">
      <h3 style="margin:0; padding:0;">TEC499 - MI - SISTEMAS DIGITAIS</h3>
      <h4 style="margin:0; padding:0;">Jonatas de Jesus Lima - 18111214</h4>
    </td>

  </tr>
</table>

## 💻Coprocessador Aritmético de Matrizes – DE1-SoC

Projeto desenvolvido em Verilog para a plataforma DE1-SoC, com o objetivo de criar um coprocessador dedicado a operações com matrizes quadradas de até 5x5. A proposta visa acelerar operações como soma, subtração, multiplicação por escalar, entre outras, utilizando paralelismo e arquitetura em pipeline.

### 🧩 Definição do Problema

Processadores genéricos nem sempre oferecem desempenho ideal para operações matriciais intensivas. O objetivo deste projeto é criar um coprocessador dedicado, capaz de acelerar operações básicas com matrizes, aliviando o processador principal (HPS) de tais tarefas.

### 🔍 Descrição da Solução

A solução consiste em um coprocessador modular implementado em Verilog, desenvolvido especificamente para operar com matrizes quadradas de até 5x5 na plataforma DE1-SoC. Ele foi projetado para trabalhar em conjunto com o processador ARM (HPS), recebendo instruções codificadas em 32 bits que especificam a operação, a matriz de origem, posição e o dado a ser manipulado.

A arquitetura é composta por:

- **Módulo de decodificação de instruções** (`decodificador_instrucao`): responsável por interpretar o opcode, identificando a operação solicitada e extraindo os campos como linha, coluna, id da matriz e valor.
- **Máquina de estados (FSM)** (`fsm_coprocessador`): controla o fluxo do sistema, sequenciando os estados de leitura da memória, execução da operação e escrita do resultado.
- **Memória dedicada** (`memoria_matrizes`): armazena até três matrizes (A, B e C) utilizando identificadores binários (00, 01, 10) para seleção. A memória é acessada com base na linha, coluna e id da matriz extraídos da instrução.
- **ALU personalizada** (`alu_matriz`): a Unidade Lógica e Aritmética (ALU) foi iniciada, com a implementação de operações básicas como soma, subtração e inversão de sinal (oposto). No entanto, ela ainda não está completamente implementada, faltando funcionalidades para operações mais complexas, como multiplicação de matrizes e transposição.
- **Módulo principal de integração** (`coprocessador_matriz`): faz a orquestração entre os módulos internos, encaminhando os sinais e dados conforme definidos pela FSM.

A comunicação com o HPS ocorre via barramento de controle e dados, possibilitando que as instruções sejam enviadas dinamicamente durante a execução. Embora a ALU tenha sido iniciada, ela ainda precisa de aprimoramentos para suportar operações mais avançadas.


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

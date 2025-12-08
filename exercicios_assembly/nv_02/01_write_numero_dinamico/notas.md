# Notas - write_numero_dinamico

Este documento explica o conteúdo de `application.s` (conversão de um número 64-bit para string decimal e escrita na saída padrão).

## Descrição geral

O programa pega um valor em `RAX`, converte-o dígito a dígito para ASCII (base 10) preenchendo um buffer de trás para frente e, em seguida, escreve o buffer na saída padrão usando uma syscall.

## Buffer

- `buffer` está em `.bss` com `32` bytes alocados (`.skip 32`).
  - Comentário: 32 é uma potência de 2 (2^5), facilita alinhamento e manipulação. É suficiente para armazenar até 20 dígitos de um inteiro 64-bit + `\n`.

## Registradores usados (resumo)

- `RAX`: contém o valor original (dividendo). Após cada divisão, passa a conter o quociente; ao fim, RAX pode ficar 0.
- `RDX`: usado para receber o resto da divisão (low byte `DL` contém o dígito em ASCII depois de somar `'0'`).
- `RBX`: divisor (valor `0x0a` = 10).
- `RCX`: ponteiro para o buffer — inicializado para `buffer + 31` e movido para trás conforme os dígitos são escritos.
- `RDI`: contador de dígitos (número de bytes escritos no buffer), usado também para indicar o tamanho ao escrever (syscall `write`).
- `RSI`: parâmetro para a syscall `write` — aponta para o início da string a ser escrita.
- `RDX` (na syscall): contém o tamanho (número de bytes) a escrever.
- `RAX` (na syscall): número da syscall (1 = write, 60 = exit).
- Ao final, exit usa `RAX=60` e `RDI=0` para retornar com código 0.

## Fluxo / Algoritmo

1. `MOV rax, 0x1A2B3C4D5E6F7890` — valor de exemplo (poderia ser qualquer inteiro 64-bit).
2. `LEA rcx, [buffer + 31]` — posiciona o cursor no fim do buffer (vamos preencher de trás para frente).
3. `MOV rdi, 0` — zera o contador de dígitos.
4. `CALL convert_loop` — rotina que converte `RAX` em dígitos ASCII:
   - `XOR rdx, rdx` — zera `RDX` (parte alta do dividendo quando se divide 64-bit por 32/64-bit).
   - `MOV rbx, 0x0a` — divisor `10`.
   - `DIV rbx` — divide `RDX:RAX` por `RBX`. Resultado: quociente em `RAX`, resto em `RDX`.
   - `ADD dl, '0'` — converte o resto (0..9) para ASCII.
   - `MOV byte ptr [rcx], dl` — armazena o caractere no buffer na posição apontada por `RCX`.
   - `DEC rcx` — recua o cursor (preparando para o próximo dígito).
   - `INC rdi` — incrementa o contador de dígitos.
   - `CMP rax, 0` / `JNE convert_loop` — repete enquanto `RAX != 0`.
   - Ao sair do loop, `INC rcx` (voltamos uma posição, porque o último DEC movimentou além do início real da string) e ajusta-se o buffer para adicionar `\n`:
     - `ADD rdi, 0x01` — incrementa o contador para incluir o `\n`.
     - `MOV byte ptr [rcx + rdi - 1], 0x0a` — escreve o byte `0x0a` (`\n`) na última posição.
   - `RET` — retorna ao chamador.

5. `CALL print_buffer` — rotina que prepara argumentos da syscall `write` e chama `SYSCALL`:
   - `MOV rsi, rcx` — endereço do início da string (ponteiro para primeiro caractere válido).
   - `MOV rdx, rdi` — tamanho (número de bytes a escrever).
   - `MOV rax, 0x01` — syscall `write`.
   - `MOV rdi, 0x01` — file descriptor 1 = stdout.
   - `SYSCALL` — chama o kernel para escrever.
   - `RET`.

6. `JMP exit` — após escrever, sai do programa com a syscall `exit`:
   - `MOV rax, 0x3c` — syscall `exit` (60 decimal).
   - `XOR rdi, rdi` — exit code 0.
   - `SYSCALL`.

## Observações importantes e boas práticas

- Antes de executar `DIV`, é essencial que `RDX` seja definido corretamente (tipicamente zerado com `xor rdx, rdx`) para evitar resultados incorretos quando o valor em `RAX` cabe em 64 bits.
- O algoritmo preenche o buffer de trás para frente porque a conversão por divisão gera dígitos do menos significativo para o mais significativo.
- Ao usar `MOV eax, ...` em códigos similares, lembre-se que escrever em `EAX` zera os 32 bits superiores de `RAX`.
- O buffer foi alocado com tamanho fixo (32 bytes) e o código pressupõe que o valor cabe nele; para usos mais gerais, valide o tamanho e trate overflow.

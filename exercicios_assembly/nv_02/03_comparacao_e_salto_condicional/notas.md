# Notas — Comparação de entrada (exercício)

Este documento explica como funciona a comparação usada no arquivo `application.s` e por que algumas formas tentadas não funcionaram.

## Conceitos importantes

- `buffer` (sem colchetes) refere-se ao _endereço_ do rótulo/label na memória — ou seja, ao endereço.
- `[buffer]` ou `byte ptr [buffer]` refere-se ao _conteúdo_ em memória no endereço `buffer` (no caso, 1 byte).
- `LEA rcx, [buffer]` carrega o **endereço** do label `buffer` em `rcx` (útil para passar ponteiros a syscalls).
- `MOV al, byte ptr [buffer]` carrega o **conteúdo** (um byte) localizado em `buffer` para o registrador `AL`.

## Por que `CMP buffer, 'a'` não funciona

Quando você escreve `CMP buffer, 'a'` está comparando o endereço do `buffer` com o valor ASCII de `'a'` (0x61). Como o endereço é algo como `0x55f...` e não `0x61`, a comparação sempre falha.

Exemplo incorreto:
```asm
CMP buffer, 'a'    ; compara o endereço com 0x61 -> sempre falso
```

## Por que `MOV rcx, buffer` + `CMP rcx, 'a'` não funciona

`MOV rcx, buffer` coloca o endereço (ponteiro) em `rcx`. Depois `CMP rcx, 'a'` compara esse ponteiro com 0x61 — também sempre falso.

Se sua intenção era usar `rcx` como ponteiro, a forma correta é:
```asm
LEA rcx, [buffer]           # rcx = endereço de buffer
CMP byte ptr [rcx], 'a'     # compara o byte em memória com 'a'
```

## Formas corretas de comparar o byte lido com 'a'

1) Comparar diretamente na memória:
```asm
CMP byte ptr [buffer], 'a'
```

2) Usar um registrador como ponteiro e comparar o byte apontado:
```asm
LEA rsi, [buffer]
CMP byte ptr [rsi], 'a'
```

3) Carregar o byte em um registrador de 8 bits e comparar:
```asm
MOV al, byte ptr [buffer]
CMP al, 'a'
```

Todas as opções acima comparam o conteúdo (o caractere lido) com `'a'`.

## Por que ocorre segmentation fault (explicação prática)

Se você usou `MOV rsi, buffer` e o assembler interpretou como uma tentativa de carregar o conteúdo de `buffer` para `rsi` (em vez de carregar o endereço), `rsi` poderia ficar com um valor inválido. Em seguida, a `SYSCALL` (read) tentou escrever no endereço guardado em `rsi` e o processo recebeu SIGSEGV.

Solução segura: use `LEA rsi, [buffer]` para garantir que `rsi` contém o endereço válido do buffer antes de chamar `SYSCALL`.

## Observações sobre `CMP` e flags

- `CMP` subtrai implicitamente o segundo operando do primeiro e atualiza as flags da CPU (ZF, SF, OF, CF), sem alterar os registradores.
- `JE` (Jump if Equal) verifica se `ZF == 1` (resultado da comparação igual) e salta quando igual.
- `JNE` salta se `ZF == 0` (não igual).
- Usar `JE` seguido imediatamente de `JNE` é redundante — basta um `JE` e então seguir com o código do caso "diferente".

## Flags do processador (ZF, SF, CF, OF)

- **ZF (Zero Flag)**: fica `1` se o resultado da operação for zero. Em `CMP a, b` ZF=1 significa `a == b`.
- **SF (Sign Flag)**: indica o sinal do resultado (bit mais significativo). Em operações com sinal, SF mostra se o resultado é negativo.
- **CF (Carry Flag)**: usado principalmente em operações aritméticas sem sinal; em subtrações/`CMP` CF=1 indica que houve *borrow* (isto é, `a < b` quando tratados como valores sem sinal).
- **OF (Overflow Flag)**: indica overflow aritmético em operações com sinal (quando o resultado não cabe no tamanho representado).

Como `CMP` funciona por baixo dos panos:
- `CMP a, b` é equivalente a executar `SUB tmp, a, b` (subtrair `b` de `a`), atualizar as flags, e descartar o resultado. Assim:
	- Se `a - b == 0` então `ZF = 1` (equal).
	- Se `a - b` tem bit de sinal igual a 1 então `SF = 1` (resultado negativo em representação com sinal).
	- `CF` e `OF` são atualizados de acordo com a operação de subtração, e são usados por saltos unsigned (`JA`, `JB`) e signed (`JG`, `JL`) respectivamente.

Exemplos práticos (8-bit simplificados):
```asm
; comparar 5 e 5
CMP 5, 5    ; ZF = 1, SF = 0, CF = 0, OF = 0
JE equal

; comparar 3 e 5 (unsigned)
CMP 3, 5    ; ZF = 0, CF = 1  -> 3 < 5 (unsigned)
JB less_unsigned

; comparar -2 e 1 (signed)
CMP -2, 1   ; ZF = 0, SF = 1, OF = 0 -> -2 < 1 (signed)
JL less_signed
```

Observações rápidas sobre saltos condicionais:
- `JE` / `JZ`: salto quando `ZF == 1` (igualdade)
- `JNE` / `JNZ`: salto quando `ZF == 0` (diferença)
- `JB` / `JC` / `JNAE`: salto quando `CF == 1` (unsigned less - menor sem sinal)
- `JA` / `JNC` / `JNBE`: salto quando `CF == 0` e `ZF == 0` (unsigned greater - maior sem sinal)
- `JL` / `JNGE`: salto quando `SF != OF` (signed less - menor com sinal)
- `JG` / `JNLE`: salto quando `ZF == 0` e `SF == OF` (signed greater = maior com sinal)

## Exemplo aplicado (trecho do `application.s` corrigido)

```asm
; preparar read
MOV rax, 0        ; syscall read
MOV rdi, 0        ; stdin
LEA rsi, [buffer] ; endereço do buffer
MOV rdx, 1        ; ler 1 byte
SYSCALL

; comparar o byte lido com 'a'
CMP byte ptr [rsi], 'a'
JE entrada_igual
; caso diferente -> continue aqui
```

## Recomendações / próximas melhorias

- Se quiser ler até newline, ajuste `read` para ler mais bytes e procurar `0x0a`.
- Considere normalizar entrada (e.g., aceitar 'A' ou 'a') aplicando comparação com ambas formas ou convertendo para minúsculo.
- Remova redundâncias (`JE` + `JNE`) deixando apenas `JE` seguido do bloco "else".

---

Se quiser, eu aplico pequenas mudanças no arquivo `application.s`:
- remover `JNE` extra e reorganizar os rótulos, ou
- adaptar para ler até o newline e comparar o primeiro caractere.
Diga qual opção prefere e eu faço o patch.
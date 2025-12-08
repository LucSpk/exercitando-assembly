# Notas

## Fazendo divisão em Assembly

Em x86-64, a divisão é feita utilizando a instrução **DIV** (para inteiros sem sinal) ou **IDIV** (para inteiros com sinal). O processo envolve:

1. **Preparação do dividendo**: colocar o valor a ser dividido em **rdx:rax** (RDX contém os 64 bits superiores, RAX os 64 bits inferiores)
2. **Instrução DIV/IDIV**: executar `div registrador` ou `div memoria`, onde o operando é o divisor
3. O divisor pode e ficar em qualquer outro registrador
4. **Resultado**:
   - **rax** recebe o quociente (Resposta)
   - **rdx** recebe o resto

### Exemplo simples

```asm
mov rax, 20        ; dividendo = 20
xor rdx, rdx       ; limpar RDX (parte alta do dividendo)
mov rcx, 3         ; divisor = 3
div rcx            ; 20 ÷ 3
; Resultado: RAX = 6 (quociente), RDX = 2 (resto)
```

### Pontos importantes

- Sempre zere **rdx** antes de dividir números de 64 bits, caso contrário o resultado será incorreto
- A instrução **DIV** trabalha sempre com dividendo em **rdx:rax**
- Use **IDIV** para divisões com números negativos (complemento de dois)
- Se o divisor for zero, a divisão causa uma exceção (divisão por zero)


## Divisão do Registrador 'rax'

O registrador rax em x86-64 é dividido em partes menores, cada uma acessível por nome específico:

- **rax** (64 bits) – registrador completo
- **eax** (32 bits) – metade inferior; zera automaticamente os 32 bits superiores quando escrito
- **ax** (16 bits) – quarta parte inferior
- **ah** (8 bits) – byte superior de ax
- **al** (8 bits) – byte inferior de ax

### Exemplo prático

```asm
mov rax, 0x1234567890ABCDEF  ; RAX = 0x1234567890ABCDEF
mov eax, 0x11223344          ; RAX = 0x0000000011223344 (32 bits superiores zerados)
mov ax, 0x5566               ; RAX = 0x0000000000005566
mov al, 0x77                 ; RAX = 0x0000000000000077
mov ah, 0x88                 ; RAX = 0x0000000000008877
```

As outras partes (ah, al) permitem manipular dados de tamanho menor sem perder o resto do registrador. Isso economiza espaço e é eficiente para operações com bytes e words.

### Registrador x acumulador
![alt text](image.png)

## Gravando nos espaços de memória
```asm
 MOV [rcx], al
```
Copia o conteúdo do registrador **al** para o endereço de memória apontado por **rcx**.

---

### Por que "no buffer" assim?
Em Assembly não existe conceito de variável de alto nível.  
Não existe `buffer[i] = valor`.

Tudo é feito com **endereços de memória**:

- **rcx** contém um endereço (um ponteiro).  
- **[rcx]** significa acessar a memória naquele endereço.  
- **al** é um byte que queremos salvar.  

Portanto:
```asm
MOV [rcx], al
```

## Movendo o Cursor usando 'INC'
No começo o endereço de memória do **bufer** foi colocado em **'rcx'**, com a instrução:
```asm
LEA rcx, [buffer]
```

O buffer foi definido com 4 posições, cada posição 1 byte.
```asm
buffer: .skip 4 
```

Então temos algo como: 
```asm
buffer:
+---+---+---+---+
| ? | ? | ? | ? |
  ^
 RCX
```
Com um cursor apontando para a primeira posição.

Quando uso a instrução
```asm
MOV [rcx], al
```

O valor de al = '1', é gravado na primeia posição do buffer, onde o cursor esta apontado.
```asm
buffer:
+---+---+---+---+
| ? | ? | ? | ? |
  ^
 RCX
```

Quando executamos o comando a **INC** estamos dizendo para o assembly movimentar a posição do cursor. Dessa forma.
```asm
INC rcx
```
Movimenta o cursor para o proximo espaço de memória.
```asm
buffer:
+---+---+---+---+
| 1 | ? | ? | ? |
      ^
     RCX
```

## Usando o 'byte ptr' para informar o tamanho da escrita

A **'byte ptr'** diz ao assembler que a escrita deve ocupar exatamente 1 byte de memória.
Sem isso, o assembler pode não saber o tamanho do dado que você quer mover para **[rcx]**.

Porque **0x0A** é só um número — não tem tamanho embutido.
Então pode ser de 8bits, 16bits, 32bits ou 64bits, o assembly não sabe.

Então é preciso especificar o tamanho.
```
"Eu quero escrever UM BYTE neste endereço!"
```
É isso o que **'byte ptr'** faz.

### Exemplo: ###
Se passarmos:
```am
mov [rcx], 0x0A
```
O Assembly pode assumir que esta sendo passado um inteiro de 32bits (DWORD), porque 0x0A é um literal imediato sem tamanho definido.
Então escreveria:
```
0x0A 00 00 00
```
Ou seja:
```
10, 0, 0, 0
```
4 bytes!
Isso corrompe seu buffer, estraga a string e causa bugs.

Ou seja, sem byte ptr:
```asm
[rcx] = 0x0A
[rcx+1] = 0x00
[rcx+2] = 0x00
[rcx+3] = 0x00
```
Com byte ptr:
```
[rcx] = 0x0A
```
#### Por que não precisamos disso em? ####
```asm
mov [rcx], al
mov [rcx], dl
```
'al' é um registrador de 8 bits (1 byte) \
'dl' é um registrador de 8 bits (1 byte)

Os registradores 'al' e 'dl' são as partes menores (8 bits) dos registradores 'rax' e 'rdx' (64 bits).

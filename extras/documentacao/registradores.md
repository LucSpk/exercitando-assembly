# Registradores x86-64 (Linux) #
Arquitetura: x86-64 (AMD64) <br>
Tamanho base: 64 bits

## Registradores de uso geral (General Purpose) ##
| 64 bits | 32 bits | 16 bits | 8 bits | Uso típico                       |
| ------- | ------- | ------- | ------ | -------------------------------- |
| RAX     | EAX     | AX      | AL     | Acumulador, retorno de função    |
| RBX     | EBX     | BX      | BL     | Registrador geral (callee-saved) |
| RCX     | ECX     | CX      | CL     | Contador, `loop`, shifts         |
| RDX     | EDX     | DX      | DL     | Multiplicação / divisão          |
| RSI     | ESI     | SI      | SIL    | Fonte de dados                   |
| RDI     | EDI     | DI      | DIL    | Destino / 1º argumento           |
| RBP     | EBP     | BP      | BPL    | Base do stack frame              |
| RSP     | ESP     | SP      | SPL    | Ponteiro da stack                |
| R8      | R8D     | R8W     | R8B    | Argumentos extras                |
| R9      | R9D     | R9W     | R9B    | Argumentos extras                |
| R10     | R10D    | R10W    | R10B   | Temporário                       |
| R11     | R11D    | R11W    | R11B   | Temporário                       |
| R12     | R12D    | R12W    | R12B   | Geral (callee-saved)             |
| R13     | R13D    | R13W    | R13B   | Geral (callee-saved)             |
| R14     | R14D    | R14W    | R14B   | Geral (callee-saved)             |
| R15     | R15D    | R15W    | R15B   | Geral (callee-saved)             |

## Registradores de argumentos (System V ABI) ##
| Ordem | Registrador |
| ----- | ----------- |
| 1º    | RDI         |
| 2º    | RSI         |
| 3º    | RDX         |
| 4º    | RCX         |
| 5º    | R8          |
| 6º    | R9          |

## Registradores preservados (callee-saved) ##
- RBX
- RBP
- R12
- R13
- R14
- R15

## Registradores temporários (caller-saved) ##
- RAX
- RCX
- RDX
- RSI
- RDI
- R8–R11

## 🔹 Registradores especiais ##
### 📌 RSP — Stack Pointer ###
- Aponta para o topo da stack
- Controlado por push, pop, call, ret

### 📌 RBP — Base Pointer ###
- Referência fixa do stack frame
- Facilita acesso a variáveis locais

## Registrador de flags — RFLAGS ## 

Armazena estado da CPU após operações.

|Flag |	  Nome      |Uso                |
|---- | ------------ | ------------------|
|ZF	 |Zero Flag	    |Resultado = 0      |
|SF	 |Sign Flag	    |Resultado negativo |
|CF	 |Carry Flag	|Overflow unsigned  |
|OF	 |Overflow Flag	|Overflow signed    |
|PF	 |Parity Flag	|Paridade           |
|AF	 |Adjust Flag	|BCD                |

Usado por:
```asm
cmp
test
je
jne
jg
jl
```


## 🔹 Registradores de instrução ##
| Registrador | Função                        |
| ----------- | ----------------------------- |
| RIP         | Ponteiro da próxima instrução |

🔸 Não pode ser escrito diretamente
🔸 Alterado por jmp, call, ret

## 🔹 Registradores SIMD (visão geral) ##
| Tipo       | Tamanho  |
| ---------- | -------- |
| XMM0–XMM15 | 128 bits |
| YMM0–YMM15 | 256 bits |
| ZMM0–ZMM31 | 512 bits |


Usados para:
- ponto flutuante
- vetorização
- SIMD

## 🔹 Relação com syscalls (Linux) ##
| Uso        | Registrador |
| ---------- | ----------- |
| syscall nº | RAX         |
| arg1       | RDI         |
| arg2       | RSI         |
| arg3       | RDX         |
| arg4       | R10         |
| arg5       | R8          |
| arg6       | R9          |
| retorno    | RAX         |

## 🔹 Tamanhos de dados ##
| Tipo  | Tamanho |
| ----- | ------- |
| byte  | 1       |
| word  | 2       |
| dword | 4       |
| qword | 8       |

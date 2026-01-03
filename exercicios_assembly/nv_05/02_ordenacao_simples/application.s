.global _start
.intel_syntax noprefix

.section .bss
    lista_leitura:      .skip 32
    lista:              .skip 64
    outbuf:             .skip 32
    
.section .text
_start:
    CALL    .read_loop
    JMP     .exit

.exit:
    MOV     rax, 0x3c
    XOR     rdi, rdi
    SYSCALL

.read_loop:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    MOV     qword ptr [rbp - 8], 0

.loop:
    MOV     r10, [rbp - 8]
    CMP     r10, 5
    JE      .fim_leitura

    # rdi recebe o local onde sera guardado a entrada 
    # rdx o tamanho da entrada 
    LEA     rdi, [lista_leitura]
    MOV     rdx, 32
    CALL    .read_inteiro

    # rdi entrada da funcao 
    LEA     rdi, [lista_leitura]
    CALL    .remove_newline

    # rdi entrada da funcao 
    # rax saida
    LEA     rdi, [lista_leitura]
    CALL    .converte_para_inteiro

    MOV     r10, [rbp - 8]
    MOV     [lista + r10 * 8], rax

    INC     qword ptr [rbp - 8]
    JMP     .loop

.fim_leitura:
    LEAVE
    RET

.read_inteiro:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    MOV     rsi, rdi
    # MOV     rdx, r13
    MOV     rax, 0
    MOV     rdi, 0
    SYSCALL

    MOV byte ptr [rsi + rax], 0

    LEAVE
    RET

.remove_newline:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    MOV     rcx, 0

.loop_remove_newline:
    # Vai percorrer a entrada até encontrar o '\n'
    MOV     al, byte ptr [rdi + rcx]        # Move um byte para 'al' usando a contagem em rcx como cursor
    CMP     al, 0x0a                        # Verifica se é igual a '\n'
    JE      .replace_newline

    CMP     al, 0x00                        # Verifica se chegou ao fim (evitar o loop infinito caso não haja um '\n')
    JE      .fim_remove_newline

    INC     rcx
    JMP     .loop_remove_newline

.replace_newline:
    MOV     byte ptr [rdi + rcx], 0x00      # Subistitui o '\n' por um caracter null

.fim_remove_newline:
    LEAVE
    RET

# Converte de ascii para inteiro
#   Entrada -> rdi
#   Saida   -> rax
.converte_para_inteiro:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    XOR     rcx, rcx                        # Zero o contador
    XOR     rax, rax                        # Zera o registrador para receber o resultado

.converte_para_inteiro_loop:
    XOR     rdx, rdx
    MOV     dl, byte ptr [rdi + rcx]
    CMP     dl, 0x00
    JE      .fim_conversao_inteiro

    SUB     dl, '0'
    IMUL    rax, rax, 10                    # rax = rax * 10
    ADD     rax, rdx

    INC     rcx
    JMP     .converte_para_inteiro_loop

.fim_conversao_inteiro:
    LEAVE
    RET

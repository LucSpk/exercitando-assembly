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
    MOV     r12, [rbp - 8]
    CMP     r12, 5
    JE      .fim_leitura

    # rsi recebe o local onde sera guardado a entrada 
    # r13 o tamanho da entrada 
    LEA     rdi, [lista_leitura]
    MOV     r13, 2
    CALL    .read_inteiro

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
    MOV     rdx, r13
    MOV     rax, 0
    MOV     rdi, 0
    SYSCALL

    LEAVE
    RET

.remove_newline:
    PUSH    rbp
    MOV     rbp, rsi
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

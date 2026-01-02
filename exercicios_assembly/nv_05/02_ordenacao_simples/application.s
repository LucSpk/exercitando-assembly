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

    LEA     rsi, [lista_leitura]
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

    MOV     rax, 0
    MOV     rdi, 0
    # rsi deve ser atribuido na chamada da função
    MOV     rdx, r13
    SYSCALL

    LEAVE
    RET

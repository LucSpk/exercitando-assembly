.global _start
.intel_syntax noprefix

.section .bss
    lista_leitura:      .skip 32
    lista:              .skip 64
    outbuf:             .skip 32
    
.section .text
_start:
    CALL .read_loop
    JMP .exit

.exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

.read_loop:
    MOV rcx, 0

.loop:
    CMP rcx, 5
    JE .fim_leitura


    INC rcx
    JMP .loop

.fim_leitura:
    RET

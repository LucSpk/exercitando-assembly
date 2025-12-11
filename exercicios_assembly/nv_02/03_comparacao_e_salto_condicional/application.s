.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 2

.section .text
_start:



    JMP exit

exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

.section .data
    eh_a: .asciz "é a\n"
    nao_eh_a: .asciz "não é a\n"

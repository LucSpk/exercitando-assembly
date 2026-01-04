# Sistema de menu com loop
#   Menu textual:
#   1 – Soma
#   2 – Subtração
#   3 – Sair
#   Implementar com jmp, labels, loops.
.global _start
.intel_syntax noprefix

_start:

.exit:
    MOV     rax, 0x3c
    XOR     rdi, rdi
    SYSCALL
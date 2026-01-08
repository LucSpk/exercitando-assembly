.global _start
.intel_syntax noprefix

_start: 

.exit:
    MOV     rax, 0x3c
    XOR     rdi, rdi
    SYSCALL
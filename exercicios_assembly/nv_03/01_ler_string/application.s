.global _start
.intel_syntax noprefix


_start: 
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

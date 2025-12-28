.global _start
.extern print_int

.intel_syntax noprefix

.section .text 
_start:

    MOV rdi, 12345
    CALL print_int

    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

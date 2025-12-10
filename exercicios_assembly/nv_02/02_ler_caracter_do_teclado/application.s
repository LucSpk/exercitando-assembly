.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 2

.section .text
_start:
    # Syscall para read()
    MOV rax, 0 
    MOV rdi, 0
    MOV rsi, buffer
    MOV rdx, 1
    SYSCALL

    MOV rax, 1
    MOV rdi, 1
    MOV rsi, buffer
    MOV rdx, 2
    SYSCALL

    JMP exit
exit: 
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 2

.section .text
_start:
    # Syscall para read()
    MOV rax, 0 
    MOV rdi, 0
    LEA rsi, [buffer]
    MOV rdx, 2
    SYSCALL

    MOV rax, 1
    MOV rdi, 1
    LEA rsi, [buffer]
    MOV rdx, 2
    SYSCALL

    JMP exit
exit: 
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

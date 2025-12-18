# 01. Ler uma string
#   Ler até 32 bytes do teclado para um buffer em .bss.
#   Imprimir de volta.
.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 32

.section .text
_start: 

    MOV rax, 0x00
    MOV rdi, 0x00
    LEA rsi, [buffer]
    MOV rdx, 0x20
    SYSCALL

    MOV rax, 0x01
    MOV rdi, 0x01
    LEA rsi, [buffer]
    MOV rdx, 0x20
    SYSCALL

    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

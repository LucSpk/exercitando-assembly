# Dado um número entre 0 e 9 armazenado em registrador (ex: rax = 5),
# converta para ASCII (somar 48: '0' = 48)
# imprima.

.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 2

.section .text
_start:
    MOV rax, 5

    ADD al, '0'
    MOV byte ptr [buffer], al 
    MOV byte ptr [buffer + 1], 0x0a

    MOV rax, 1
    MOV rdi, 1
    LEA rsi, [buffer]
    MOV rdx, 2
    SYSCALL

    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

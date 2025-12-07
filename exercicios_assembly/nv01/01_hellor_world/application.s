.global _start
.intel_syntax noprefix

_start:
    # syscall write
    MOV rax, 0x01
    MOV rdi, 0x01
    LEA rsi, [hello_str]
    MOV rdx, 15
    SYSCALL

    # syscall exit
    MOV rax, 0x3c
    MOV rdi, 0
    SYSCALL

.section .data          # Esse section é para dados estáticos e deve ficar no fim do codigo
    hello_str: .asciz "Hellow, world!\n"

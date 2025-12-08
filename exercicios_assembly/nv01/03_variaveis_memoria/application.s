.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 4

.section .text
_start: 

    MOV rax, 12
    SUB rax, 5

    # Usa mesmo metodo de impressão do exercicio 02
    CALL print_buffer

    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

print_buffer:
    LEA rcx, [buffer]

    MOV rbx, 0x0a
    XOR rdx, rdx
    DIV rbx

    ADD al, '0'
    MOV [rcx], al
    INC rcx

    ADD dl, '0'
    MOV [rcx], dl 
    INC rcx

    MOV byte ptr [rcx], 0x0a

    MOV rax, 0x01
    MOV rdi, 0x01
    LEA rsi, [buffer]
    MOV rdx, 0x03
    SYSCALL

    RET

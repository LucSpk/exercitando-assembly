# 2. Função que conta caracteres (strlen)
#   Percorrer buffer char a char até encontrar 0x0A (ENTER).
#   Retornar tamanho em rax.

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

    LEA rcx, [buffer]
    XOR rdx, rdx
loop: 

    INC rdx
    INC rcx

    CMP byte ptr [rcx], 0x0A
    JNE loop

    MOV rsi, rdx
    MOV rdx, 0x02
    MOV rax, 0x01
    MOV rdi, 0x01
    SYSCALL

exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

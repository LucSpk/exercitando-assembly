.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 1

.section .text
_start:
    MOV rax, 0 
    MOV rdi, 0
    MOV rsi, buffer
    MOV rdx, 1
    SYSCALL

    # debug: print primeiro byte em HEX
    MOV al, byte ptr [buffer]
    
    CMP al, 'a' 
    JNE entrada_diferente

entrada_igual:
    MOV rax, 1
    MOV rdi, 1
    LEA rsi, [eh_a]
    MOV rdx, 0x06
    SYSCALL

    JMP exit
entrada_diferente:
    MOV rax, 1
    MOV rdi, 1
    LEA rsi, [nao_eh_a]
    MOV rdx, 0x0a
    SYSCALL

exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

.section .data
    eh_a: .asciz "é a\n"
    nao_eh_a: .asciz "não é a\n"

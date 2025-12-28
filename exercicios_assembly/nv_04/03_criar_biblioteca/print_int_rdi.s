.global print_int
.intel_syntax noprefix

.section .bss
    outbuf: .skip 32

.section .text

print_int:
    MOV rax, rdi
    LEA rsi, [outbuf + 31]

    MOV byte ptr [rsi], 0x0a

.convert_loop: 
    XOR rdx, rdx
    MOV rbx, 0x0a

    DIV rbx

    ADD dl, '0'

    DEC rsi 

    MOV byte ptr [rsi], dl

    CMP rax, 0
    JNE .convert_loop

.print:

    MOV rax, 0x01
    MOV rdi, 0x01
    MOV rdx, 0x06
    SYSCALL 

    RET

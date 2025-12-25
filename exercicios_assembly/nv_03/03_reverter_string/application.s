.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 32
    outbuf: .skip 32


.section .text
_start: 

.ler_do_teclado: 
    MOV rax, 0
    MOV rdi, 0
    LEA rsi, [buffer]
    MOV rdx, 0x20
    SYSCALL

.verifica_erro:
    CMP rax, 0
    JLE .exit

#    MOV r9, rax
#
#    LEA rcx, [buffer]
#    MOV al, byte ptr [rcx]
#
#    CMP al, 0x0a
#    JNE .invert_loop
#
#    LEA rdi, [outbuf]
#    MOV byte ptr [rdi], 0x0a
#
#    MOV rsi, rdi
#    MOV rax, 0x01
#    MOV rdi, 0x01
#    MOV rdx, 0x01
#    SYSCALL

.invert_loop_start:
    LEA rdi, [outbuf + 31]
    XOR r8, r8

.invert_loop:
    
    DEC rdi
    mov al, [rcx]
    mov [rdi], al

    INC rcx
    INC r8

    DEC r9
    CMP r9, 0
    JNE .invert_loop

.print_string:
    LEA rsi, [rdi] 
    MOV byte ptr [rdi + r8], 0x0a 
    
    MOV rdx, r8
    INC r8 

    MOV rax, 0x01
    MOV rdi, 0x01
    SYSCALL

.exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

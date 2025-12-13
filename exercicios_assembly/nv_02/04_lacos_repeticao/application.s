.global _start
.intel_syntax noprefix

.section .data
    buffer: .byte 0x30, 0x0a

.section .bss
    tmp: .byte 0

.section .text
_start: 
    LEA rcx, [buffer]
    CALL loop

    mov cl, '0'
    CALL loop_2

    JMP exit

loop:
    MOV rax, 0x01
    MOV rdi, 0x01
    LEA rsi, [msg_text]
    MOV rdx, 0x0b
    SYSCALL

    MOV rax, 0x01
    MOV rdi, 0x01
    LEA rsi, [buffer]
    MOV rdx, 0x02
    SYSCALL

    # ADD byte ptr [rcx], 1
    INC byte ptr [buffer]
    
    cmp byte ptr [buffer], 0x39
    JL loop

    RET

loop_2:
    mov [tmp], cl

    MOV rax, 1
    MOV rdi, 1
    LEA rsi, [tmp]
    MOV rdx, 1
    SYSCALL

    MOV byte ptr [tmp], 0x0A
    MOV rax, 1
    MOV rdi, 1
    LEA rsi, [tmp]
    MOV rdx, 1
    SYSCALL

    INC cl
    CMP cl, '9'
    JLE loop_2

    RET

exit: 
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

.section .text
    msg_text: .asciz "Contágem: "

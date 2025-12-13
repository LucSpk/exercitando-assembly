.global _start
.intel_syntax noprefix

.section .data
    buffer: .byte 0x30, 0x0a

.section .text
_start: 
    LEA rcx, [buffer]

    CALL loop
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

exit: 
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

.section .text
    msg_text: .asciz "Contágem: "

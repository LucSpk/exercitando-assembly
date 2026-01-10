.global _start
.intel_syntax noprefix

.section .data
    enderenco: .asciz "arquivo.txt"

.section .bss
    buffer: .skip 256        # espaço para leitura

.section .text
_start: 
    MOV     rax, 0x02
    LEA     rdi, [rip + enderenco]
    MOV     rsi, 0x00
    MOV     rdx, 0x00
    SYSCALL

    # retorno:
    # rax >= 0 → file descriptor
    # rax < 0  → erro (-errno)

    TEST    rax, rax
    JS      .exit

    MOV     r12, rax            # guarda fd (exemplo)

    MOV     rax, 0               # syscall read
    MOV     rdi, r12
    LEA     rsi, [buffer]
    MOV     rdx, 256
    SYSCALL

    TEST    rax, rax
    JS      .exit

    MOV     r13, rax

    MOV     rax, 1               # syscall write
    MOV     rdi, 1               # stdout
    LEA     rsi, [buffer]
    MOV     rdx, r13
    SYSCALL

.close_file:
    # close(fd)
    MOV rax, 3
    MOV rdi, r12
    SYSCALL

.exit:
    MOV     rax, 0x3c
    XOR     rdi, rdi
    SYSCALL

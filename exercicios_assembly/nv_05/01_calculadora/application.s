.global _start
.intel_syntax noprefix

.section .bss
    num_01: .skip 32
    num_02: .skip 32

.section .data
    calculadora_msg: .asciz "### CALCULADORA ###\n"
    calculadora_end: calculadora_msg_len = calculadora_end - calculadora_msg

    num_01_msg: .asciz "Digite o primeiro numero: "
    num_01_msg_len = . - num_01_msg - 1

    num_02_msg: .asciz "Digite o segundo numero: \0"
    num_02_msg_len = . - num_02_msg - 1

.section .text
_start:
    
    CALL .recebe_valores
    CALL .exit

.recebe_valores:
    # ---------- Prologo ----------
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 16

    # ---------- Corpo ----------
    LEA rdi, [calculadora_msg]
    MOV rsi, calculadora_msg_len 
    CALL .print_string

    LEA rdi, [num_01_msg]
    MOV rsi, num_01_msg_len 
    CALL .print_string

    LEA rdi, [num_01]     # buffer do primeiro número
    MOV rsi, 32
    CALL .read_numero

    LEA rdi, [num_02_msg]
    MOV rsi, num_02_msg_len 
    CALL .print_string

    LEA rdi, [num_02]     # buffer do primeiro número
    MOV rsi, 32
    CALL .read_numero

    # ---------- Epilogo ----------
    LEAVE
    RET

.read_numero:
    # ---------- Prologo ----------
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 16

    # ---------- Corpo ----------
    MOV rax, 0      # read
    MOV rdx, rsi    # tamanho
    MOV rsi, rdi    # buffer
    MOV rdi, 0      # stdin
    SYSCALL

    # ---------- Epilogo ----------
    LEAVE
    RET

# ==================================================
# void print_string(char *str, size_t len)
# RDI = ponteiro da string
# RSI = tamanho
# ==================================================
.print_string: 
    # ---------- Prologo ----------
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 16

    # ---------- Corpo ----------
    MOV rax, 1
    MOV rdx, rsi
    MOV rsi, rdi
    MOV rdi, 1
    SYSCALL

    # ---------- Epilogo ----------
    LEAVE
    RET

.exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

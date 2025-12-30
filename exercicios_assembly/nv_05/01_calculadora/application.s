.global _start
.intel_syntax noprefix

.section .bss
    num_01: .skip 32
    num_02: .skip 32
    operador: .skip 4
    outbuf: .skip 32

.section .data
    calculadora_msg: .asciz "### CALCULADORA ###\n"
    calculadora_end: calculadora_msg_len = calculadora_end - calculadora_msg

    num_01_msg: .asciz "Digite o primeiro numero: "
    num_01_msg_len = . - num_01_msg - 1

    num_02_msg: .asciz "Digite o segundo numero: \0"
    num_02_msg_len = . - num_02_msg - 1

    op_msg: .asciz "Digite a operacao (+ - * /): "
    op_msg_len = . - op_msg - 1

.section .text
_start:
    
    CALL .recebe_valores
    CALL .executa_operacao

    MOV rdi, rax        # passa resultado
    CALL .print_int

    CALL .exit

# ==================================================
# void print_int(long value)
# RDI = valor inteiro
# ==================================================
.print_int:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 32

    MOV rax, rdi              # número a imprimir
    LEA rsi, [outbuf + 31]    # ponteiro no fim do buffer
    MOV byte ptr [rsi], 0x0A  # '\n'

.convert_loop_print_int:
    XOR rdx, rdx
    MOV rcx, 10
    DIV rcx                   # rax = rax / 10 | rdx = resto

    ADD dl, '0'
    DEC rsi
    MOV byte ptr [rsi], dl

    TEST rax, rax
    JNZ .convert_loop_print_int

    # calcular tamanho
    LEA rdx, [outbuf + 32]
    SUB rdx, rsi

    # write(1, rsi, rdx)
    MOV rax, 1
    MOV rdi, 1
    SYSCALL

    LEAVE
    RET

.executa_operacao:
    # ---------- Prologo ----------
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 16
    
    # ---------- Corpo ----------
    MOV al, byte ptr [operador]

    CMP al, '+'
    JE .op_soma

    CMP al, '-'
    JE .op_sub

    CMP al, '*'
    JE .op_mul

    CMP al, '/'
    JE .op_div

    JMP .fim_operacao

.op_soma:
    MOV rax, rbx
    ADD rax, r12
    JMP .fim_operacao

.op_sub:
    MOV rax, rbx
    SUB rax, r12
    JMP .fim_operacao

.op_mul:
    MOV rax, rbx
    IMUL rax, r12
    JMP .fim_operacao

.op_div:
    MOV rax, rbx
    XOR rdx, rdx
    DIV r12
    JMP .fim_operacao

.fim_operacao:
    # resultado está em RAX
    
    # ---------- Epilogo ----------
    LEAVE
    RET

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

    LEA rdi, [num_01]
    CALL .strip_newline

    LEA rdi, [num_01]
    CALL .ascii_to_int
    MOV rbx, rax

    LEA rdi, [num_02_msg]
    MOV rsi, num_02_msg_len 
    CALL .print_string

    LEA rdi, [num_02]     # buffer do primeiro número
    MOV rsi, 32
    CALL .read_numero

    LEA rdi, [num_02]
    CALL .strip_newline

    LEA rdi, [num_02]
    CALL .ascii_to_int
    MOV r12, rax

    LEA rdi, [op_msg]
    MOV rsi, op_msg_len
    CALL .print_string

    LEA rdi, [operador]
    MOV rsi, 4
    CALL .read_numero

    LEA rdi, [operador]
    CALL .strip_newline

    # ---------- Epilogo ----------
    LEAVE
    RET

# ==================================================
# long ascii_to_int(char *buffer)
# RDI = buffer
# return RAX = valor inteiro
# ==================================================
.ascii_to_int:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 16

    XOR rax, rax        # resultado = 0
    XOR rcx, rcx        # índice = 0

.convert_loop:
    MOV dl, byte ptr [rdi + rcx]
    CMP dl, 0x00        # fim da string?
    JE .done_ascii_to_int

    SUB dl, '0'         # char -> número
    IMUL rax, rax, 10
    ADD rax, rdx

    INC rcx
    JMP .convert_loop

.done_ascii_to_int:
    LEAVE
    RET

# ==================================================
# void strip_newline(char *buffer)
# RDI = buffer
# ==================================================
.strip_newline:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 16

    MOV rcx, 0              # índice = 0

.strip_loop:
    MOV al, byte ptr [rdi + rcx]
    CMP al, 0x0A            # '\n'?
    JE .replace_zero
    CMP al, 0x00            # fim da string?
    JE .done_strip_newline
    INC rcx
    JMP .strip_loop

.replace_zero:
    MOV byte ptr [rdi + rcx], 0x00

.done_strip_newline:
    LEAVE
    RET

# ==================================================
# void read_numero(char *buffer)
# RDI = buffer
# ==================================================
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

# Sistema de menu com loop
#   Menu textual:
#   1 – Soma
#   2 – Subtração
#   3 – Sair
#   Implementar com jmp, labels, loops.
.global _start
.intel_syntax noprefix

.section .bss
    operacao: .skip 32
    num_01: .skip 32
    num_02: .skip 32
    outbuf: .skip 32

.section .data
    calculadora_msg: .asciz "|### CALCULADORA ###|\n"
    calculadora_msg_len = . - calculadora_msg - 1

    base_line: .asciz "|-------------------|\n"
    base_line_len = . - base_line - 1

    num_01_msg: .asciz "Digite o primeiro numero: \0"
    num_01_msg_len = . - num_01_msg - 1

    num_02_msg: .asciz "Digite o segundo numero: \0"
    num_02_msg_len = . - num_02_msg - 1

    opc_01: .asciz "| 1 - Soma          |\n"
    ocp_01_len = . - opc_01 - 1

    opc_02: .asciz "| 2 - Subtração     |\n"
    opc_02_end = . - opc_02 - 1

    opc_03: .asciz "| 3 - Sair          |\n"
    opc_03_end = . - opc_03 - 1

    resltado_msg_01: .asciz "Resultado da operação = "
    resltado_msg_01_len = . - resltado_msg_01 - 1

.section .text
_start:

    CALL    .escreve_opcoes_tela
    CALL    .recebe_entrada

.exit:
    MOV     rax, 0x3c
    XOR     rdi, rdi
    SYSCALL

.imprime_saida:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    MOV     rdi, r13
    CALL    .print_int

    JMP .done

.recebe_entrada:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

.loop_recebe_entrada:
    LEA     rdi, [operacao]
    MOV     rsi, 4
    CALL    .read_teclado

    LEA     rdi, [operacao]
    CALL    .strip_newline
    
    MOV     al, byte ptr [operacao]
    
    CMP     al, '1'
    JE      .op_soma

    CMP     al, '2'
    JE      .op_subtracao

    CMP     al, '3'
    JE      .done

    JMP     .loop_recebe_entrada

.op_soma:
    CALL    .ler_valores_entrada

    MOV     rax, rbx
    ADD     rax, r12

    MOV     r13, rax
    CALL    .imprime_saida

    JMP     .done

.op_subtracao:
    CALL    .ler_valores_entrada

    MOV     rax, rbx
    SUB     rax, r12

    MOV     r13, rax
    CALL    .imprime_saida
    
    JMP     .done


.ler_valores_entrada:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32
    
    LEA     rdi, [num_01_msg]
    MOV     rsi, num_01_msg_len 
    CALL    .print_string

    LEA     rdi, [num_01]
    MOV     rsi, 32
    CALL    .read_teclado

    LEA     rdi, [num_01]
    CALL    .strip_newline

    LEA     rdi, [num_01]
    CALL    .ascii_to_int
    MOV     rbx, rax


    LEA     rdi, [num_02_msg]
    MOV     rsi, num_02_msg_len 
    CALL    .print_string

    LEA     rdi, [num_02]
    MOV     rsi, 32
    CALL    .read_teclado

    LEA     rdi, [num_02]
    CALL    .strip_newline

    LEA     rdi, [num_02]
    CALL    .ascii_to_int
    MOV     r12, rax

    JMP     .done


.escreve_opcoes_tela:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    LEA     rdi, [calculadora_msg]
    MOV     rsi, calculadora_msg_len 
    CALL    .print_string

    LEA     rdi, [opc_01]
    MOV     rsi, ocp_01_len 
    CALL    .print_string

    LEA     rdi, [opc_02]
    MOV     rsi, opc_02_end 
    CALL    .print_string

    LEA     rdi, [opc_03]
    MOV     rsi, opc_03_end 
    CALL    .print_string

    LEA     rdi, [base_line]
    MOV     rsi, base_line_len 
    CALL    .print_string

    JMP     .done

.print_string: 
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    MOV     rax, 1
    MOV     rdx, rsi
    MOV     rsi, rdi
    MOV     rdi, 1
    SYSCALL

    JMP     .done


.strip_newline:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    MOV     rcx, 0              # índice = 0

.strip_loop:
    MOV     al, byte ptr [rdi + rcx]
    CMP     al, 0x0A            # '\n'?
    JE      .replace_zero
    CMP     al, 0x00            # fim da string?
    JE     .done
    INC     rcx
    JMP     .strip_loop

.replace_zero:
    MOV     byte ptr [rdi + rcx], 0x00

    JMP     .done


.read_teclado:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    MOV     rax, 0      # read
    MOV     rdx, rsi    # tamanho
    MOV     rsi, rdi    # buffer
    MOV     rdi, 0      # stdin
    SYSCALL

    JMP     .done


.ascii_to_int:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    XOR     rax, rax        # resultado = 0
    XOR     rcx, rcx        # índice = 0

.convert_loop:
    MOV     dl, byte ptr [rdi + rcx]
    CMP     dl, 0x00        # fim da string?
    JE      .done

    SUB     dl, '0'         # char -> número
    IMUL    rax, rax, 10
    ADD     rax, rdx

    INC     rcx
    JMP     .convert_loop

    JMP     .done

.print_int:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    MOV     rax, rdi              # número a imprimir
    LEA     rsi, [outbuf + 31]    # ponteiro no fim do buffer
    MOV     byte ptr [rsi], 0x0A  # '\n'

.convert_loop_print_int:
    XOR     rdx, rdx
    MOV     rcx, 10
    DIV     rcx                   # rax = rax / 10 | rdx = resto

    ADD     dl, '0'
    DEC     rsi
    MOV     byte ptr [rsi], dl

    TEST    rax, rax
    JNZ     .convert_loop_print_int

    LEA     rdx, [outbuf + 32]
    SUB     rdx, rsi

    MOV     rax, 1
    MOV     rdi, 1
    SYSCALL

    JMP     .done

.done:
    LEAVE
    RET

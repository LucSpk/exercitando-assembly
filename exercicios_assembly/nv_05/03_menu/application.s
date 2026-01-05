# Sistema de menu com loop
#   Menu textual:
#   1 – Soma
#   2 – Subtração
#   3 – Sair
#   Implementar com jmp, labels, loops.
.global _start
.intel_syntax noprefix

.section .bss
    num_01: .skip 32
    num_02: .skip 32
    outbuf: .skip 32

.section .data
    calculadora_msg: .asciz "### CALCULADORA ###\n"
    calculadora_end: calculadora_msg_len = calculadora_end - calculadora_msg

    num_01_msg: .asciz "Digite o primeiro numero: "
    num_01_msg_len = . - num_01_msg - 1

    num_02_msg: .asciz "Digite o segundo numero: \0"
    num_02_msg_len = . - num_02_msg - 1
    opc_01: .asciz "1 - Soma\n"
    opc_01_end: ocp_01_len = opc_01_end - opc_01

    opc_02: .asciz "2 - Subtração\n"
    opc_02_end: opc_02_len = opc_02_end - opc_02

    opc_03: .asciz "3 - Sair\n"
    opc_03_end: opc_03_len = opc_03_end - opc_03

    resltado_msg_01: .asciz "Resultado da operação = "
    resltado_msg_01_len = . - resltado_msg_01 - 1

_start:

    CALL    .escreve_opcoes_tela

.exit:
    MOV     rax, 0x3c
    XOR     rdi, rdi
    SYSCALL

.escreve_opcoes_tela:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    LEA     rdi, [calculadora_msg]
    MOV     rsi, calculadora_msg_len 
    CALL    .print_string

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

.done
    LEAVE
    RET

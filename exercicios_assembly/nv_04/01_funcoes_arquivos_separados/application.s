# 1. Criar duas funções em arquivos separados
#   print_int.s
#   application.s

.global _start
.extern print_int

.intel_syntax noprefix

.section .text 
_start:

    CALL print_int      # - Chama função externa

    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

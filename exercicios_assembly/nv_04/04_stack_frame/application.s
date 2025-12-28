# 04. Implementar stack frame manual
# - O stack frame é uma estrutura usada por cada função para guardar seu próprio estado de execução, incluindo:
#       para onde ela deve retornar
#       os dados locais da função
#       e o estado necessário para continuar corretamente após chamadas a outras funções

.global _start
.intel_syntax noprefix

.section .bss
    outbuf: .skip 32

.section .text

# ==================================================
# Entry point
# ==================================================
_start:
    MOV rdi, 0x0a
    MOV rsi, 0x14
    CALL soma                   # A Instrução CALL empilha o enderenço de retorno na stack e pula para função soma

    MOV rdi, rax                # passa resultado
    CALL print_int

    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

# ==================================================
# Função: long soma(long a, long b)
# a -> RDI
# b -> RSI
# return -> RAX
# ==================================================
soma:
    PUSH rbp                    # Guarda o rbp da função anterior | preserva o estado do chamador
    MOV rbp, rsp                # Define uma base fixa | agora rbp marca o início do frame
    SUB rsp, 0x10               # Reserva espaço para variáveis locais | mantém alinhamento de 16 bytes (regra da ABI)

    MOV rax, rdi
    ADD rax, rsi

    LEAVE                       # LEAVE faz: mov rsp, rbp depois pop rbp
    RET                         # Desempilha o endereço de retorno | volta para _start

# ==================================================
# void print_int(long value)
# value -> RDI
# ==================================================
print_int:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 0x20

    MOV rax, rdi
    LEA rsi, [outbuf + 31]
    MOV byte ptr [rsi], 0x0A

.convert_loop:
    XOR rdx, rdx
    MOV rcx, 0x0a
    DIV rcx

    ADD dl, '0'
    DEC rsi
    MOV byte ptr [rsi], dl

    TEST rax, rax               # a instrução 'TEST' pode subistituir CMP rax, 0
    JNZ .convert_loop

    LEA rdx, [outbuf + 32]
    SUB rdx, rsi

    MOV rax, 0x01
    MOV rdi, 0x01
    SYSCALL

    LEAVE
    RET

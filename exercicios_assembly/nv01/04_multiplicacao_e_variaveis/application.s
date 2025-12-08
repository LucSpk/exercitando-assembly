.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 4

.section .text
_start:
    MOV al, [num_01]            # Atribui o valor da variavel 'num_01' para a menor parte do 'rax' (64bits) 'al' (8bits)
    MOV rbx, 0x05               
    MUL rbx                     # Faz a multiplicacao do 'rax' pelo valor de 'rbx' | 'rax': 3 * 'rbx': 5 => Resultado em 'rax': 15
    # IMPORTANTE - O Resultado pode ser de até 128bits gravados n0 'rax' (parte baixa) e no 'rdx' (parte alta) na configuração 'rdx:rax'

    CALL print_buffer

    JMP exit
print_buffer:
    LEA rcx, [buffer]

    MOV rbx, 0x0a
    XOR rdx, rdx
    DIV rbx

    ADD al, '0'
    MOV [rcx], al
    INC rcx

    ADD dl, '0'
    MOV [rcx], dl 
    INC rcx

    MOV byte ptr [rcx], 0x0a

    MOV rax, 0x01
    MOV rdi, 0x01
    LEA rsi, [buffer]
    MOV rdx, 0x03
    SYSCALL

    RET

exit: 
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

.section .data
    num_01: .byte 0x03              # Cria uma variável de 1 byte com valor 0x03

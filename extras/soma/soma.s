.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 4          # Reserva 4 bytes para a variável 'buffer' 2 digitos + '\n' + '\0'

.section .text
_start:
    lea rcx, [buffer]       # Carrega o endereço do buffer em RCX

    MOV rax, 0x05
    ADD rax, 0x08           # Resultado 0x0D (13 em decimal)

    # Agora, importante, converter o valor em rax para Decimal ASCII
    MOV rbx, 10             # Divisor para conversão decimal
    XOR rdx, rdx            # Limpa rdx antes da divisão
    DIV rbx                 # Divide rax por 10, quociente em rax, resto em rdx

    # Primeiro dígito (dezenas)
    ADD al, '0'             # Converte para ASCII
    MOV [rcx], al           # Armazena no buffer
    INC rcx                 # Avança para a próxima posição no buffer

    # Segundo dígito (unidades)
    ADD dl, '0'             # Converte para ASCII
    MOV [rcx], dl           # Armazena no buffer
    INC rcx                 # Avança para a próxima posição no buffer

    # Adiciona o caractere de nova linha
    MOV byte ptr [rcx], 0x0A    # Adiciona '\n' - 0x0A corresponde a 10 em hexadecimal

    # - Imprime o resultado armazenado em 'buffer' usando SYSCALL 'write'
    MOV rax, 0x01           # SYSCALL 'write'
    MOV rdi, 0x01           # File descriptor 1 (stdout)
    lea rsi, [buffer]       # Endereço do buffer com o resultado
    MOV rdx, 0x03           # Tamanho: 2 dígitos + '\n'
    SYSCALL
    
    # - Executa ação de saida do programa
    MOV rax, 0x3c 
    XOR rdi, rdi      # código de saída 0
    SYSCALL

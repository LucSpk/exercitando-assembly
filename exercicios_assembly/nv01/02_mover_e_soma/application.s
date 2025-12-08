.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 4                 # Reserva 4 bytes para a variável 'buffer' 2 digitos + '\n' + '\0'

.section .text
_start:
    LEA rcx, [buffer]               # Carrega o endereço do buffer em 'rcx'

    MOV rax, 0x05
    ADD rax, 0x0a                   # Faz a soma do 0x05 carregado no rax + 0x0a(10), rax fica carregado com o resultado

    # Converte valor rax, para ASCII para ser imprimido (A divisão usa registradores fixos). 
    MOV rbx, 10                     # Move divisor para conversão decimal (Pode estar em qualquer registrador)
    #   A divisão pode ser feita com valores de 128bits (Parte mais alta, 64 bits, no rdx. Parte mais baixa no, 64 bits, rax)
    XOR rdx, rdx                    # Limpa registrador rdx deixando a parte mais alta = 0 - Também receber o resto da divisão 'rdx:rax' por 'rbx' (Recebe o resto por padrão)
    DIV rbx                         # Faz a divisão do 'rdx:rax' (dividendo) pelo 'rbx' (divisor)

    # Converte digito a digito do valor
    # O resultado inteiro da divisão está em 'rax' = 0x01 | 15 / 10 Resultado => 1, Com 5 de resto
    # 'al' é a menor parte de 'rax' - 'rax' (64bits), 'al' (8bits)  *Ver nota da atividade
    ADD al, '0'                     # Converte o byte baixo de 'rax' (AL) para ASCII | '0' é 0x30 em ASCII 0x01 + 0x30 = 0x31 → ASCII '1'.
    MOV [rcx], al                   # Grava '1' na váriável buffer usando o ponteiro [rcx] que tem o enderenço de buffer
    INC rcx                         


    # Imprime valor do buffer
    MOV rax, 0x01
    MOV rdi, 0x01
    LEA rsi, [buffer]
    MOV rdx, 0x02
    SYSCALL

    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

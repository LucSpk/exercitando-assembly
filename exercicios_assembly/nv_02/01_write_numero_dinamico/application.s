.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 32        #   O Buffer para até 20 digitos + '\n' | Tem 32 bytes porque é uma potencia de 2(2^5), o que 
                            # facilita a manipulação do espaço e evita erros (pesquisar sobre misalignment), é mais rápido 
                            # de acessar, tamanhos fora da base 2 pode ser até ilegal. Em relação ao tamanho de 20 digitos
                            # + '\n', é porque um inteiro 64-bit tem no máximo 20 dígitos.

.section .text
_start:
    MOV rax, 0x1A2B3C4D5E6F7890     # Pode ser qualquer valor 64-bit | 0x1A2B3C4D5E6F7890 => 1885667171979196560

    LEA rcx, [buffer + 31]          # Posiciona o cursor no fim do buffer, será preenchido de trás para frente
    
    MOV rdi, 0                      # Contador de digitos
    
    CALL convert_loop
    CALL print_buffer
    JMP exit

# Usa os registradores 'rdx' 'rbx' 'rcx' 'rdi'
convert_loop:
    XOR rdx, rdx
    MOV rbx, 0x0a
    DIV rbx

    ADD dl, '0'

    MOV byte ptr [rcx], dl          # Grava em ASCII

    DEC rcx                         # Movimenta o cursor para trás
    INC rdi                         # Incrementa o contador de digitos

    CMP rax, 0                      #   A divisão será feita até 'rax' está vaiza e o ultimo valor ir para o resto ou a divisão 
    JNE convert_loop                # ser iagua a 0 CMP atualiza flags ZF (Zero Flag), SF (Sign Flag), CF (Carry Flag) e OF 
                                    # (Overflow Flag) JNE – Jump if Not Equal | Se comparação de CMP for verdadeira a ZF vira 1 
                                    # e JNE que observa a flag ZF e caso a comparacao der 'diferente', ela direciona para o destino

    INC rcx                         # volta 1 posição (estamos 1 byte antes)
    ADD rdi, 0x01                      # Soma +1 no contador de caracteres para considerar o '\n'
    MOV byte ptr [rcx + rdi - 1], 0x0a  # Adiciona o '0x0a' que corresponde a '\n' na tabela ASCII na ultima posição do contador
    
    RET

print_buffer:
    MOV rsi, rcx
    MOV rdx, rdi
    MOV rax, 0x01 
    MOV rdi, 0x01 
    SYSCALL

    RET

exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

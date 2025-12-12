.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 1

.section .text
_start:
    MOV rax, 0                # syscall: número 0 = read (quando usado com SYSCALL em x86-64? NA VERDADE: usamos rax=0 para read em 64-bit via syscall)
    MOV rdi, 0                # fd = 0 (stdin)
    LEA rsi, [buffer]         # endereco do buffer onde o byte lido será armazenado
    MOV rdx, 1                # ler 1 byte
    SYSCALL                   # chamada de sistema: read(0, buffer, 1)

    # Comparar o byte lido com o caractere 'a'
    # Explicação da instrução abaixo:
    #   CMP byte ptr [rsi], 'a'
    # - Acessa 1 byte na memória apontada por RSI (o buffer que acabou de ser preenchido)
    # - Compara esse byte com o valor imediato ASCII de 'a' (0x61)
    # - Atualiza as flags do processador (ZF, SF, OF, CF) conforme o resultado
    # - Não altera registradores, apenas flags
    # Depois da comparação, `JE` (Jump if Equal) salta para `entrada_igual` se ZF=1
    # e `JNE` (Jump if Not Equal) salta para `entrada_diferente` se ZF=0.
    # Observação: usar tanto JE quanto JNE em sequência é redundante — um `JE` seguido
    # por código para o caso diferente seria suficiente.
    CMP byte ptr [rsi], 'a'
    JE entrada_igual
    JNE entrada_diferente
entrada_diferente:
    MOV rax, 1
    MOV rdi, 1
    LEA rsi, [nao_eh_a]
    MOV rdx, 0x0a
    SYSCALL

entrada_igual:
    MOV rax, 1
    MOV rdi, 1
    LEA rsi, [eh_a]
    MOV rdx, 0x06
    SYSCALL

    JMP exit
    
exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

.section .data
    eh_a: .asciz "é a\n"
    nao_eh_a: .asciz "não é a\n"

# 2. Função que conta caracteres (strlen)
#   Percorrer buffer char a char até encontrar 0x0A (ENTER).
#   Retornar tamanho em rax.

# Essa versão usa numero de bytes gravados no rax na entrada e imprime o numero total de byte (escrito + enter)

.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 32
    outbuf: .skip 16

.section .text
_start: 

le_do_teclado:
    # read up to 32 bytes from stdin into buffer
    MOV rax, 0          # syscall: read
    MOV rdi, 0          # fd = stdin
    LEA rsi, [buffer]
    MOV rdx, 32
    SYSCALL             # rax = bytes_read

verificar_erro:
    # if rax <= 0 -> exit
    # Caso haja algum erro ou EOF na hora de ler do teclado rax fica menor que 0
    # EOF = End of File - rax = 0 -> EOF -- Em arquivos é quando não há mais bytes para ler | No teclado Ctrl + D (Linux / macOS) ou Ctrl + Z + Enter (Windows)
    CMP rax, 0
    # Vai para o fim caso haja erro JLE -> Jump Low ou Equal (<=)
    # JLE .exit

    JL .exit

imprime_valor_guardado_em_rax:
    # --- imprimir o valor retornado em rax (bytes lidos) ---
    # rax guarda o numero de bytes inseridos na syscall read
    MOV r10, rax            # salvar bytes_read em r10 como backup 

    # Logo será feita uma divisao, o que destroi o valor que existe em rax, por isso é salvo o valor em r10
    
    # Caso especial de rax diferente de 0, então pula para a impressao
    CMP rax, 0
    JNE .print_conv_start
    
    # Esse caso especial é somente didático, ja que se o rax for igual a 0 o código pula para o fim
    
    LEA rsi, [outbuf]               # Salva o endereço da memória do outbuf para rsi
    MOV byte ptr [rsi], '0'         # Move '0' em ascii para o endereço de memória de outbuf
    MOV byte ptr [rsi+1], 0x0A      # Adiciona a quebra de linha no segundo espaço de memória do outbuf
    
    MOV rdx, 2
    MOV rdi, 1
    MOV rax, 1
    SYSCALL

    JMP .exit_print
    
.print_conv_start:
    MOV rcx, 0
    LEA rdi, [outbuf+15]

.print_conv_loop:
    XOR rdx, rdx
    MOV rbx, 10
    DIV rbx
    ADD dl, '0'
    DEC rdi
    MOV byte ptr [rdi], dl
    INC rcx
    CMP rax, 0
    JNE .print_conv_loop
    LEA rsi, [rdi]
    MOV byte ptr [rdi+rcx], 0x0A
    MOV rdx, rcx
    INC rdx
    MOV rax, 1
    MOV rdi, 1
    SYSCALL
    MOV rax, r10 

.exit_print:
    MOV rax, r10

.exit:
    MOV rax, 0x3C
    XOR rdi, rdi
    SYSCALL

# 2. Função que conta caracteres (strlen)
#   Percorrer buffer char a char até encontrar 0x0A (ENTER).
#   Retornar tamanho em rax.

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
    # Caso haja algum erro na hora de ler do teclado rax fica menor que 0
    CMP rax, 0
    # Vai para o fim caso haja erro
    JLE .exit

    LEA rcx, [buffer]
    MOV r9, rax         # Salva quantidade de bytes inseridos na entrada
    XOR r8, r8          # zera o registrador para servir de contador

.scan_loop:
    MOV al, byte ptr [rcx]
    CMP al, 0x0a        # Verifica se é um newline ("\n" ?)
    JE .count_done      # Caso sim pula para o fim da contagem
    
    INC r8              # Incrementa o contador
    INC rcx             # Movimenta o ponteiro para o proximo espaço de memória do buffer (rcx contem o endereço de memória do buffer)
    
    DEC r9              # r9 possui a quatidade de bytes inserida, então decrementa
    CMP r9, 0           # Verifica se r9 ja chegou a zero (fim da contagem)
    JNE .scan_loop      # Caso não volta para o inicio do scan

.count_done:
    # r8 Contem o numero de caracteres (0..32)
    # Converte o valor de r8 (number) para ASCII decimal e guarda em outbuf
    MOV rax, r8         # Grava o valor da contagem em rax (Será usado na divisão)
    CMP rax, 0          # Caso seja diferente de zero pula para etapa de imprimir
    JNE .conv_loop_start
    
    # Se for igual a zero, avança para esse trecho a seguir
    LEA rdi, [outbuf]
    MOV byte ptr [rdi], '0'         # Move '0' ja em ascii para o inicio do outbuffer
    MOV byte ptr [rdi + 1], 0x0a    # Adiciona quebra de linha
    MOV rsi, rdi                    # Move o o endereço do buffer em rdi para rsi (registrador usado no SYSCALL write)
    MOV rdx, 2                      # Tamanno da da saida

    JMP .do_write                   # Pula para o SYSCALL write

.conv_loop_start:
    LEA rdi, [outbuf + 15]          # Grava o endereço do penultimo espaço de memória do outbuf
    MOV rcx, 0                      # Contador de digitos

.conv_loop:
    XOR rdx, rdx
    MOV rbx, 10
    DIV rbx                         # Lembrando que a divisão é rax pelo rbx e rax = quociente, rdx = resto
    
    ADD dl, '0'                     # Converte o valor do menor byte do rdx em ascii
    DEC rdi                         # Volta um espaço de memória do outbuf
    MOV byte ptr [rdi], dl          # Grava o valor convertido no espaço
    INC rcx                         # Adiciona o numero de digitos
    
    CMP rax, 0
    JNE .conv_loop                  # Caso rax ainda nao tenha chegado a zero ainda há valores a vonverter então retornar para o inicio do loop

    LEA rsi, [rdi]                  # Move o que vai ser imprimido para o rsi
    MOV byte ptr [rdi + rcx], 0x0a  # Adiciona a nova linha no final da string
    MOV rdx, rcx                    # move o tamanho da saida rcx possui essa contagem
    INC rdx                         # Considera a nova linha ("\n") no tamanho da saida

.do_write:
    # write(1, rsi, rdx)
    MOV rax, 1
    MOV rdi, 1
    SYSCALL

.exit:
    MOV rax, 0x3C
    XOR rdi, rdi
    SYSCALL

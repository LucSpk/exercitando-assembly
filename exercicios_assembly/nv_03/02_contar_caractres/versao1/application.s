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
    # Caso haja algum erro na hora de ler do teclado rax fica menor que 0
    CMP rax, 0
    # Vai para o fim caso haja erro
    JLE .exit


imprime_valor_guardado_em_rax:
    # --- imprimir o valor retornado em rax (bytes lidos) ---
    # rax guarda o numero de bytes inseridos na syscall read
    MOV r10, rax            #; salvar bytes_read em r10
    MOV rax, r10            #; preparar para conversão
    CMP rax, 0
    jne .print_conv_start
    #; caso especial 0
    lea rsi, [outbuf]
    mov byte ptr [rsi], '0'
    mov byte ptr [rsi+1], 0x0A
    mov rdx, 2
    mov rdi, 1
    mov rax, 1
    syscall
    mov rax, r10            #; restaurar bytes_read
    #; fim impressão
    
.print_conv_start:
    mov rcx, 0
    lea rdi, [outbuf+15]
.print_conv_loop:
    xor rdx, rdx
    mov rbx, 10
    div rbx                 #; rax = quotient, rdx = remainder
    add dl, '0'
    dec rdi
    mov byte ptr [rdi], dl
    inc rcx
    cmp rax, 0
    jne .print_conv_loop
    lea rsi, [rdi]
    mov byte ptr [rdi+rcx], 0x0A
    mov rdx, rcx
    inc rdx
    #; write the decimal string
    mov rax, 1
    mov rdi, 1
    syscall
    mov rax, r10            # ; restaurar bytes_read
    #; --- fim imprimir valor em rax ---

.exit:
    MOV rax, 0x3C
    XOR rdi, rdi
    SYSCALL

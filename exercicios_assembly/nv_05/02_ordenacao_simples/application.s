.global _start
.intel_syntax noprefix

.section .bss
    lista_leitura:      .skip 32
    lista:              .skip 64
    outbuf:             .skip 32
    
.section .text
_start:
    CALL    .read_loop
    CALL    .sort_lista
    CALL    .print_lista
    JMP     .exit

.exit:
    MOV     rax, 0x3c
    XOR     rdi, rdi
    SYSCALL

#################################################################
# Imprime a lista ordenada
#################################################################
.print_lista:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    MOV     rdx, rax
    MOV     byte ptr [rsi], 0x0A   # '\n'
    MOV     rax, 1
    MOV     rdi, 1
    SYSCALL

    XOR     r8, r8 

.print_loop:
    CMP     r8, 5
    JGE     .done

    MOV     rdi, [lista + r8 * 8]       # rax = lista[i]
    CALL    .int_para_ascii             # retorna tamanho em rax

    # write(tamanho, outbuf, stdout)
    MOV     rdx, rax
    LEA     rsi, [outbuf]
    MOV     rax, 1
    MOV     rdi, 1
    SYSCALL

    INC     r8
    JMP     .print_loop

#################################################################
# Converte inteiro em ASCII e Imprime
#   - Recebe o enderenço da entrada em rdi
#################################################################
.int_para_ascii:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    MOV     rax, rdi
    LEA     rsi, [outbuf + 31]
    MOV     byte ptr [rsi], 0x0A

.convert_loop_print_int:
    XOR     rdx, rdx
    MOV     rcx, 10
    DIV     rcx

    ADD     dl, '0'
    DEC     rsi
    MOV     byte ptr [rsi], dl

    TEST    rax, rax
    JNZ     .convert_loop_print_int

    LEA     rdx, [outbuf + 32]
    SUB     rdx, rsi

    MOV rax, 1
    MOV rdi, 1
    SYSCALL

    JMP .done

#################################################################
# Ordena lista 
#################################################################
.sort_lista:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    XOR     r8, r8                          # - Zera variável para o loop externo (i = 0)

.loop_externo: 
    CMP     r8, 4
    JGE     .done

    XOR     r9, r9                          # - Zera variável para o loop interno (j = 0)

.loop_interno: 
    MOV     r10, 4
    SUB     r10, r8                         # - Cada vez que o loop externo roda o maior elemento já foi “empurrado” para o final então não precisa mais comparar ele.
    CMP     r9, r10
    JGE     .proximo_i

    # Indice sempre x8 para considerar o espaço dado na lista
    MOV     rax, [lista + r9 * 8]           # - rax <= lista[j]
    MOV     rdx, [lista + r9 * 8 + 8]       # - rdx <= lista[j + 1]

    CMP     rax, rdx                        # - Se rax < rdx então mantem ordem e retorna para o inicio
    JLE     .incrementa_e_retorna

    # Faz operação de troca 
    MOV     [lista + r9 * 8], rdx           # - lista[j]        <= rdx
    MOV     [lista + r9 * 8 + 8], rax       # - lista[j + 1]    <= rax

.incrementa_e_retorna:
    INC     r9
    JMP     .loop_interno

.proximo_i:
    INC     r8
    JMP     .loop_externo

#################################################################
# Faz leitura do teclado e converte para inteiro
#################################################################
.read_loop:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    MOV     qword ptr [rbp - 8], 0

.loop:
    MOV     r10, [rbp - 8]
    CMP     r10, 5
    JE      .done

    # rdi recebe o local onde sera guardado a entrada 
    # rdx o tamanho da entrada 
    LEA     rdi, [lista_leitura]
    MOV     rdx, 32
    CALL    .read_inteiro

    # rdi entrada da funcao 
    LEA     rdi, [lista_leitura]
    CALL    .remove_newline

    # rdi entrada da funcao 
    # rax saida
    LEA     rdi, [lista_leitura]
    CALL    .converte_para_inteiro

    MOV     r10, [rbp - 8]
    MOV     [lista + r10 * 8], rax          # - Da um espaço de 8 entre o inicio de cada numero

    INC     qword ptr [rbp - 8]
    JMP     .loop


#################################################################
# Faz leitura do teclado
#   - Recebe o enderenço da entrada em rdi
#   - Tamanho da entrada em rdx
#################################################################
.read_inteiro:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 32

    MOV     rsi, rdi
    # MOV     rdx, r13
    MOV     rax, 0
    MOV     rdi, 0
    SYSCALL

    MOV byte ptr [rsi + rax], 0

    JMP .done


#################################################################
# Remove o '\n' da entrada caso exista
#   - Recebe o enderenço da entrada em rdi
#################################################################
.remove_newline:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    MOV     rcx, 0

.loop_remove_newline:
    # Vai percorrer a entrada até encontrar o '\n'
    MOV     al, byte ptr [rdi + rcx]        # Move um byte para 'al' usando a contagem em rcx como cursor
    CMP     al, 0x0a                        # Verifica se é igual a '\n'
    JE      .replace_newline

    CMP     al, 0x00                        # Verifica se chegou ao fim (evitar o loop infinito caso não haja um '\n')
    JE      .fim_remove_newline

    INC     rcx
    JMP     .loop_remove_newline

.replace_newline:
    MOV     byte ptr [rdi + rcx], 0x00      # Subistitui o '\n' por um caracter null

.fim_remove_newline:
    JMP .done


#################################################################
# Converte valor em ascii para inteiro
#   - Entrada:  rdi
#   - Saida:    rax
#################################################################
.converte_para_inteiro:
    PUSH    rbp
    MOV     rbp, rsp
    SUB     rsp, 16

    XOR     rcx, rcx                        # Zero o contador
    XOR     rax, rax                        # Zera o registrador para receber o resultado

.converte_para_inteiro_loop:
    XOR     rdx, rdx
    MOV     dl, byte ptr [rdi + rcx]
    CMP     dl, 0x00
    JE      .done

    SUB     dl, '0'
    IMUL    rax, rax, 10                    # rax = rax * 10
    ADD     rax, rdx

    INC     rcx
    JMP     .converte_para_inteiro_loop


#################################################################
# Finaliza função com stack frame
#################################################################
.done:
    LEAVE
    RET

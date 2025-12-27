.global _start
.intel_syntax noprefix

.section .bss
    buffer: .skip 32
    outbuf: .skip 32


.section .text
_start: 

.ler_do_teclado: 
    MOV rax, 0
    MOV rdi, 0
    LEA rsi, [buffer]
    MOV rdx, 0x20
    SYSCALL

.verifica_erro:
    CMP rax, 0
    JLE .exit

    LEA rsi, [buffer]
    xor rcx, rcx        # contador = 0

.find_len:
    MOV al, byte ptr [rsi + rcx]
    CMP al, 0x0A
    JE .len_found
    INC rcx
    JMP .find_len

.len_found:
    MOV r8, rcx

.invert_loop_start:
    LEA rsi, [buffer + r8 - 1]
    LEA rdi, [outbuf]
    MOV rcx, r8                  

.invert_loop:
     
    MOV al, byte ptr [rsi]
    MOV byte ptr [rdi], al

    DEC rsi
    INC rdi
    
    # - Veja as notas para entender melhor
    LOOP .invert_loop

    MOV byte ptr [rdi], 0x0A
    INC rdi

.print_string:
    LEA rsi, [outbuf] 
    MOV rdx, r8
    INC rdx 

    MOV rax, 0x01
    MOV rdi, 0x01
    SYSCALL

.exit:
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

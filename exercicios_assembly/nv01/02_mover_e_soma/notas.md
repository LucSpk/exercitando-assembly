# Notas


## Divisão do Registrador 'RAX'

O registrador RAX em x86-64 é dividido em partes menores, cada uma acessível por nome específico:

- **RAX** (64 bits) – registrador completo
- **EAX** (32 bits) – metade inferior; zera automaticamente os 32 bits superiores quando escrito
- **AX** (16 bits) – quarta parte inferior
- **AH** (8 bits) – byte superior de AX
- **AL** (8 bits) – byte inferior de AX

### Exemplo prático

```asm
mov rax, 0x1234567890ABCDEF  ; RAX = 0x1234567890ABCDEF
mov eax, 0x11223344          ; RAX = 0x0000000011223344 (32 bits superiores zerados)
mov ax, 0x5566               ; RAX = 0x0000000000005566
mov al, 0x77                 ; RAX = 0x0000000000000077
mov ah, 0x88                 ; RAX = 0x0000000000008877
```

As outras partes (AH, AL) permitem manipular dados de tamanho menor sem perder o resto do registrador. Isso economiza espaço e é eficiente para operações com bytes e words.

### Registrador x acumulador
![alt text](image.png)

# Instrução `loop` (x86 / x86-64)

## O que ela faz
A instrução `loop` executa **duas ações automáticas**:

1. **Decrementa o registrador `RCX`**
2. **Salta para um rótulo se `RCX` ≠ 0**

Sintaxe:
```asm
LOOP label
``` 
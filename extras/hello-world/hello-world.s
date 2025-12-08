.global _start              # .global torna algo publico, nesse caso a funcao _start
.intel_syntax noprefix      # Informa para o assembler que esse código esta usando a versão humana do assembly, sem eles teriamos um erro como 'Error: operand type mismatch for `mov''

_start: 
    CALL print
    JMP exit        # Existem duas formas de chamar uma função CALL e JMP - CALL chama e retorna e JMP nao retorna para o chamador

print:
    # Usar a SYSCALL 'write' para imprimir
    MOV rax, 0x01
    MOV rdi, 0x01           # File descriptor que quer mandar o valor 0 standard in, 1 standard out, 2 standard error
    LEA rsi, [hello_str]    # Usa a isntruca LEA Load Efective Address. LEA e um simbolo dentro dos colchetes é um pontero, estou dizendo para gravar no registrador rsi o endereco de memória da variavel 'hello_str' 
    MOV rdx, 14             # Tamanho da string hardcode
    SYSCALL
    RET                     # Retorna da funcao

exit: 
    # Proximo passo é retornar um código para finalizar assim como o return 0; na Linguagem 'C' 
    # Para fazer isso é preciso fazer uma Syscall (Chamada no sistema) nesse caso uma 'exit'

    # IMPORTANTE - Sem a flag 'noprefix' s registradores precisam de um '%' antes para sinalizar que são registradores, para evitar o erro 'Error: ambiguous operand size for `mov''

    MOV rax, 0x3c   # Primeiro passomos 60 para o registrador rax
    MOV rdi, 0      # Depois retornamos o codigo que quisermos
    SYSCALL         # Por Ultimo fazemos uma SYSCALL que é uma instrução de máquina

.section .data
    hello_str: .asciz "Hello, World!\n"

# Para rodar o codigo
# Monte o arquivo de saida usando o assembler com o comando 'as' -> as <nome-arquivo-assembly>.s -o <nome-arquivo-saida>.o | O .o é criado na execução do comando
# Pode usar o linker do gcc para criar o executavel usando -> gcc -o <nome-arquivo-executavel> <nome-arquivo>.o -nostdlib -no-pie
# -nostdlib - Diz ao compilador/linker para não usar as bibliotecas padrão do C (como libc) nem o código de inicialização (crt0.o)
# -no-pie - Gera um executável não-PIE (Position Independent Executable). PIE significa que o código pode ser carregado em qualquer endereço de memória, usando relocação dinâmica (importante para segurança, como ASLR)
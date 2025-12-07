# Exercícios de Assembly

Este repositório contém exercícios simples em Assembly para aprendizado e experimentação em Linux (arquitetura x86-64). Cada pasta agrupa um exemplo com código-fonte (`.s`) e o binário compilado.

**Pré-requisitos**
- Linux x86-64
- `gcc`, `as`, `ld` e/ou `nasm` conforme o estilo da sua fonte

**Como montar e rodar**
Convertendo o Assembly (*.s) em arquivo Objeto (*.o)
```
as <nome_arquivo_assembly>.s -o <nome_arquivo_saida>.o 
```

Linkando o arquivo objeto (Para Linux x86-64)
```
ld -o <nome_executavel_saida> <nome_arquivo_saida>.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
```

Rodando executavel
```
./<nome_executavel>
```

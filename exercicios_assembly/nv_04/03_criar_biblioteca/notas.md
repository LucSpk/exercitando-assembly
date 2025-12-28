# Criando uma biblioteca estática `.a` a partir de `print_int_rdi.o`

Este guia explica como transformar um arquivo objeto (`print_int_rdi.o`) em uma **biblioteca estática** (`libmeuprint.a`) e como utilizá-la no processo de linkedição.

---

## 📦 O que é uma biblioteca `.a`

Uma biblioteca `.a` é um **arquivo que empacota um ou mais arquivos `.o`**.

- Não é executável
- Usada na etapa de linkedição (`ld`)
- O linker extrai **somente os símbolos que forem utilizados**
- Muito comum em C, C++ e Assembly

Exemplo:
print_int_rdi.o → libmeuprint.a

## 🛠️ Passo 1 — Gerar o arquivo objeto

A partir do código assembly `print_int_rdi.s`:

```bash
as -g -o print_int_rdi.o print_int_rdi.s
```
Resultado:
- print_int_rdi.o contém a função print_int
- Ainda não é executável

## 🛠️ Passo 2 — Criar a biblioteca estática
Utilize o comando `ar` (archiver) para criar a biblioteca estática:

```bash
ar rcs libmeuprint.a print_int_rdi.o
```
| Opção | Função                                              |
| ----- | --------------------------------------------------- |
| `r`   | adiciona ou substitui arquivos na biblioteca        |
| `c`   | cria a biblioteca caso ela não exista               |
| `s`   | cria o índice de símbolos (essencial para o linker) |

📌 A opção `s` é importante para evitar erros de símbolo indefinido durante o link.

### 🔍 Verificando a biblioteca criada ### 
#### Listar os arquivos internos ####
```bash
ar t libmeuprint.a
```

Saída esperada:

```bash
print_int_rdi.o
```

Ver os símbolos exportados: 
```bash
nm libmeuprint.a
```

Você deve ver algo como:
```bash
print_int_rdi.o:
000000000000000e t .convert_loop
0000000000000000 b outbuf
0000000000000029 t .print
0000000000000000 T print_int
```

#### 🧩 Estrutura da saída ####
Formato geral:
```
ENDEREÇO (OFFSET)  TIPO  NOME_DO_SÍMBOLO
```
Tipos comuns:
- `T` (text) — função global (definida)
- `t` (text) — função local (definida)
- `B` (bss) — variável global não inicializada (definida)
- `b` (bss) — variável local não inicializada (definida)
- `U` (undefined) — símbolo não definido (usado)

Isso indica que a função `print_int` está disponível para uso.

## 🔗 Passo 3 — Usando a biblioteca no linker ##
Agora não passe mais `print_int_rdi.o` diretamente, passe a biblioteca.

```bash
ld -o application application.o libmeuprint.a
```
✔ O linker vai extrair print_int automaticamente.

## 🧠 Regra de ouro (ordem importa!) ## 

Sempre:
```
objeto que USA  → biblioteca que DEFINE
```

✔ Correto:
```bash
ld application.o libmeuprint.a
```

❌ Errado:
```bash
ld libmeuprint.a application.o
```

### 🧩 Estrutura típica ###
```
application.s
print_int.s
print_int.o
libmeuprint.a
application.o
application
```

### 🧠 Modelo mental definitivo ###

`.o` → código <br>
`.a` → caixa de ferramentas <br>
`ld` → pega só o que precisa da caixa
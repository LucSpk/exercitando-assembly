.global _start
.intel_syntax noprefix

_start:
    

    JMP exit
exit: 
    MOV rax, 0x3c
    XOR rdi, rdi
    SYSCALL

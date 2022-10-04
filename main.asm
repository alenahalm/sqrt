%macro print 2
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
%endmacro

section .text

global _start

_start:

    mov eax, 144
    mov edx, 0
    mov ecx, 2
    
    div ecx
    
    mov [x1], eax

    mov eax, 144
    mov ecx, [x1]
    div ecx
    add eax, [x1]
    mov ecx, 2
    div ecx
    mov [x2], eax
    
    
loop:
    mov ebx, [x1]
    mov [con], ebx
    mov ebx, [con]
    mov ecx, [x2]
    sub ebx, ecx
    mov [con], ebx
    mov ebx, con
    cmp ebx, 1
    ; print 1, x1
    ; print 1, x2
    ; print nlen, newline
    jl endloop
    
    mov ebx, [x2]
    mov [x1], ebx
    
    
    mov eax, [x1]
    mov eax, 144
    mov ecx, [x1]
    cmp ecx, 0
    je endloop
    div ecx
    
    add eax, [x1]
    mov ecx, 2
    div ecx
    mov [x2], eax
    jmp loop


endloop:

    print 1, [x2]
    
    mov eax, 1
    int 0x80

section .data
    number dd 3214
    message db "Done"
    len equ $ - message
    newline db 0xA, 0xD
    nlen equ $ - newline
    
section .bss
    x1 resw 1
    x2 resw 1
    con resw 1

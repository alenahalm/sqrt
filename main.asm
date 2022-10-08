%macro EXIT 1
    mov eax, 1
    mov ebx, %1
    int 0x80
%endmacro

%macro putchar 1
    pushd
    jmp %%work
    %%char db %1
%%work:
    mov eax, 4
    mov ebx, 1
    mov ecx, %%char
    mov edx, 1
    int 0x80
    popd
%endmacro

%macro const_print 1
    pushd
    jmp %%print 
    %%str db %1, 0xA
    %%len equ $ - %%str
%%print:  
    mov eax, 4
    mov ebx, 1
    mov ecx, %%str
    mov edx, %%len
    int 0x80
    popd
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

%macro printd 0
    pushd
    mov bx, 0
    mov ecx, 10
    %%_divide:
    mov edx, 0
    div ecx
    push dx
    inc bx
    test eax, eax
    jnz %%_divide
    %%_digit:
    pop ax
    add ax, '0'
    mov [result], ax
    print 1, result
    dec bx
    cmp bx, 0
    jg %%_digit
    popd
%endmacro

%macro pushd 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro popd 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

%macro new_line 0
    putchar 0xA
    putchar 0xD
%endmacro

%macro decimal 2
    pushd
    mov eax, %1
    mov ebx, 10
    mul ebx
    mov ecx, %2
    div ecx
    pop edx
    pop ecx
    pop ebx
%endmacro

%macro someshit 0
    ;num / x1
    pushd
    mov eax, [number]
    mov ebx, [x1]
    mov edx, 0
    div ebx
    add eax, ebx
    mov ebx, 2
    mov edx, 0
    div ebx
    mov [x2], eax
    popd
%endmacro

section .text
global _start
_start:
    mov eax, [number]
    mov ecx, 2
    div ecx
    mov [x1], eax
    mov eax, edx
    mov eax, [x1]

    mov eax, [x1]
    add eax, 2
    mov ebx, 2
    mov edx, 0
    div ebx
    mov [x2], eax

_condition:
    xor eax, eax
    xor ebx, ebx
    mov eax, [x1]
    mov ebx, [x2]
    sub eax, ebx

    mov ebx, 1
    cmp eax, ebx

    jg _loop
    je _result 
    jl _result

_loop:
    mov eax, [x2]
    mov [x1], eax
    someshit
    jmp _condition

_result:
    mov eax, [x2]
    printd
    new_line
    EXIT 0

section .data
    number dd 40

section .bss
    result resb 1
    x1 resb 10
    x1_decimal resb 1
    x2 resb 10

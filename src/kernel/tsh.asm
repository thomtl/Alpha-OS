[bits 16]

tsh_start:
    cli
    clc
    cld

    call tsh_loop



tsh_loop:
    call read_string
    mov bx, ax
    mov al, byte [bx]
    cmp al, 'S'
    jne tsh_loop
    mov si, STR_BUF
    call printf
    jmp tsh_loop





STR_BUF: times 64 db 0;

read_string:
    xor ax, ax
    mov bx, 0
    add bx, STR_BUF
    read_loop:
        xor ax, ax
        int 0x16
        call putch
        mov byte [bx], al
        inc bx
        cmp al, 0x13
        je read_done
        jmp read_loop
    read_done:
    mov ax, STR_BUF
    ret
        


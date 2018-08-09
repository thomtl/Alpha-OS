[bits 16]
[global start]

start:
    mov si, USERMODE_MSG
    call printf
    xor ax, ax
    int 0x16
    jmp ret_to_kern

printf:
    mov ah, 0x0e
    print_loop:
        lodsb
        cmp al, 0x0
        je print_done
        int 0x10
        jmp print_loop
    print_done:
    ret


ret_to_kern:
    mov ax, word [0x510]
    jmp ax

 USERMODE_MSG: db 'Landed in userspace', 0x0
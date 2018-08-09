[bits 16]

init_user:
    lea ax, [ret_prg]
    mov word [0x510], ax
    ret



call_program:
    mov ax, 0x0
    mov es, ax
    mov bx, 0x1000
    mov ax, 3
    mov cx, 1
    call read_disk

    lea ax, [0x1000]
    jmp ax
ret_prg:

    ret
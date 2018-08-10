[bits 16]

tsh_start: 
    call clear_screen
    mov si, TSH_WELCOME_MSG
    call printf
    call print_nl

    call tsh_loop
    ret


tsh_loop:
    mov al, '>'
    call putch
    call read_string
    
    push ax

    mov si, ax
    mov di, TSH_SHUTDOWN_CMD
    call strcmp
    cmp ax, 0
    je tsh_loop_shutdown

    mov di, TSH_START_CMD
    call strcmp
    cmp ax, 0
    je tsh_loop_start_prg

    mov di, TSH_REBOOT_CMD
    call strcmp
    cmp ax, 0
    je tsh_loop_reboot

    jmp tsh_loop_unknown_command
tsh_loop_ret:
    jmp tsh_loop

tsh_loop_shutdown:
    pop ax
    call shutdown_apm
    ; ?
    jmp tsh_loop_ret

tsh_loop_reboot:
    pop ax
    call reboot_apm
    ; ?
    jmp tsh_loop_ret

tsh_loop_unknown_command:
    pop ax
    mov si, TSH_UNRECONIZED_COMMAND
    call printf
    mov si, ax
    call printf
    call print_nl
    jmp tsh_loop

tsh_loop_start_prg:
    pop ax
    call call_program
    jmp tsh_loop_ret

read_string:
    mov dx, 64
    mov bx, STR_BUF + 64

    read_clear:
        mov byte [bx], 0x0
        dec dx
        dec bx
        cmp dx, 0
        je read_clear_done
        jmp read_clear
    read_clear_done:

    mov dx, 0
    read_loop:
        xor ax, ax
        int 0x16

        cmp al, 0x0D
        je read_done

        mov bx, STR_BUF
        add bx, dx
        inc dx
        mov byte[bx], al
        call putch
        jmp read_loop
    read_done:
    call print_nl
    mov dx, 64
    mov bx, STR_BUF
    add bx, dx
    mov byte [bx], 0x0
    mov ax, STR_BUF
    ret


STR_BUF: times 65 db 0;

TSH_WELCOME_MSG: db 'Welcome to TSH v0', 0x0
TSH_UNRECONIZED_COMMAND: db 'Unreconized command: ', 0x0
TSH_SHUTDOWN_CMD: db 'shutdown', 0x0
TSH_START_CMD: db 'start', 0x0
TSH_REBOOT_CMD: db 'reboot', 0x0
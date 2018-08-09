[bits 16]

init_apm:
    ; Check for APM
    xor ax, ax
    mov ah, 0x53
    mov al, 0x00
    xor bx, bx
    int 0x15
    jc APM_error

    ; Connect to REAL MODE interface
    mov ah, 0x53
    mov al, 0x01
    xor bx, bx
    int 0x15
    jc APM_error

    ; Enable Power managment for all devices
    mov ah, 0x53
    mov al, 0x08
    mov bx, 0x0001
    mov cx, 0x0001
    int 0x15
    jc APM_error

    ret

deinit_apm:
    mov ah, 0x53
    mov al, 0x04
    xor bx, bx
    int 0x15
    jc .deinit_error
    jmp no_deinit_error

.deinit_error:
    cmp ah, 0x03
    jne APM_error

no_deinit_error:
    ret

shutdown_apm:   
    call print_nl
    mov si, APM_SHUTDOWN_MSG
    call printf
    xor ax, ax
    int 0x16
    mov ah, 0x53
    mov al, 0x07
    mov bx, 0x0001
    mov cx, 0x03
    int 0x15
    jc APM_error
    ; Never should we get here never
    cli
    hlt

; Not really APM but should be here
reboot_apm:
    mov dx, 0x64
    mov ax, 0xFE
    out dx, ax
    cli
    hlt


APM_error:
    mov si, APM_ERROR_MSG
    call printf
    call print_nl
    ret


APM_SHUTDOWN_MSG: db 'Stopping PC, press any key for shutdown' , 0x0
APM_ERROR_MSG: db 'APM error', 0x0
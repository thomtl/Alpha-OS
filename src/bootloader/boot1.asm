[bits 16]
[org 0x7c00]

BOOT_DRIVE_LOC equ 0x500

jmp boot

boot:
    cli
    mov bp, 0x8000
    mov sp, bp
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov byte [BOOT_DRIVE], dl
    mov byte [BOOT_DRIVE_LOC], dl
    mov si, BOOT_WELCOME_MSG
    call print_string
    call print_nl
    mov si, BOOT_LOADING
.read:
    xor ax, ax
    int 0x13

    mov ax, 0x0
    mov es, ax
    mov bx, 0x9000
    mov ah, 0x02
    mov al, 3
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, byte [BOOT_DRIVE]
    int 0x13
    jc .read

    lea ax, [0x9000]
    jmp ax



print_string:
    pusha
    mov ah, 0x0e
    .print_string_loop:
        lodsb
        cmp al, 0x0
        je .print_string_done
        int 0x10
        jmp .print_string_loop
    .print_string_done:
    popa
    ret

print_nl:
    pusha

    mov ah, 0x0e
    mov al, 0x0a
    int 0x10
    mov al, 0x0d
    int 0x10

    popa
    ret

BOOT_WELCOME_MSG: db 'Booting Alpha OS', 0x0
BOOT_LOADING: db 'Loading Kernel', 0x0
BOOT_PROGRESS_MSG: db '.', 0x0
BOOT_DRIVE: db 0
absoluteHead: db 0
absoluteSector: db 0
absoluteTrack: db 0
times 510 - ($-$$)db 0
dw 0xaa55
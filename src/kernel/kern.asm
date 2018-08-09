[bits 16]
[global kern_main]
BOOT_DRIVE_LOC equ 0x500
RET_ADDR equ 0x510
DEBUG equ 1

kern_boot:
    cli
    xor ax, ax
    mov al, [BOOT_DRIVE_LOC]
    mov [BOOT_DRIVE], al


    call reset_disk


    ; Set 80x50 text mode
	mov ax, 0x1112
	xor bl,bl
	int 0x10

    call clear_screen

    mov si, BOOTING_MSG
    call printf
    call print_nl

%if DEBUG == 1
    mov si, BOOTED_FROM_MSG
    call printf
    mov dx, 0x0
    mov dl, byte[BOOT_DRIVE_LOC]
    call hex_print
    call print_nl
%endif


    xor ax, ax
    int 0x12
    inc ax
    mov word [RAM_S], ax

%if DEBUG == 1
    mov si, RAM_MSG
    call printf
    mov dx, ax
    call hex_print
    call print_nl
%endif

    call init_apm

    call detect_hw
    
    call init_user

    mov si, CONT_MSG
    call printf
    xor ax, ax
    int 0x16
    

    
    call tsh_start

    



%include "stdio.asm"
%include "apm.asm"
%include "disk.asm"
%include "hw.asm"
%include "tsh.asm"
%include "user.asm"

BOOT_DRIVE: db 0
RAM_S: dw 0
BOOTING_MSG: db 'Booting TDOS', 0x0
BOOTED_FROM_MSG: db 'Booted from device: ', 0x0
RAM_MSG: db 'Detected Memory: ', 0x0
CONT_MSG: db 'Press any key to continue boot', 0x0

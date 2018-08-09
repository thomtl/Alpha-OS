[bits 16]

reset_disk:
    xor ax, ax
    int 0x13
    ret


; READ DISK
; INPUT:
; ES:BX = buffer to place data
; ax = starting sector
; cx = nsectors
read_disk:
    .main:
        mov di, 0x0005
    .sectorloop:
        push ax
        push bx
        push cx
        call lbachs
        mov ah, 0x02
        mov al, 0x01
        mov ch, byte [absoluteTrack]
        mov cl, byte [absoluteSector]
        mov dh, byte [absoluteHead]
        mov dl, byte [BOOT_DRIVE]
        int 0x13
        jnc .success
        xor ax, ax
        int 0x13
        dec di
        pop cx
        pop bx
        pop ax
        jnz .sectorloop
        int 0x18 ; DISKLESS BOOT HOOK
    .success
        pop cx
        pop bx
        pop ax
        add bx, 512
        inc ax
        loop .main
        ret

lbachs:
    xor dx, dx
    mov di, 18
    div di
    inc dl
    mov byte [absoluteSector], dl
    xor dx, dx
    mov di, 2
    div di
    mov byte [absoluteHead], dl
    mov byte [absoluteTrack], al
    ret

absoluteHead: db 0
absoluteSector: db 0
absoluteTrack: db 0
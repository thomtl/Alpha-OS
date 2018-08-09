[bits 16]

; INPUT: al = char
putch:
    pusha
    mov ah, 0x0e
    int 0x10
    popa
    ret

; INPUT: si = ptr to string
printf:
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


; INPUT: dx = decimal number
hex_print:
    pusha
    mov cx, 0 ; our index variable

; Strategy: get the last char of 'dx', then convert to ASCII
; Numeric ASCII values: '0' (ASCII 0x30) to '9' (0x39), so just add 0x30 to byte N.
; For alphabetic characters A-F: 'A' (ASCII 0x41) to 'F' (0x46) we'll add 0x40
; Then, move the ASCII byte to the correct position on the resulting string
hex_loop:
    cmp cx, 4 ; loop 4 times
    je end
    
    ; 1. convert last char of 'dx' to ascii
    mov ax, dx ; we will use 'ax' as our working register
    and ax, 0x000f ; 0x1234 -> 0x0004 by masking first three to zeros
    add al, 0x30 ; add 0x30 to N to convert it to ASCII "N"
    cmp al, 0x39 ; if > 9, add extra 8 to represent 'A' to 'F'
    jle step2
    add al, 7 ; 'A' is ASCII 65 instead of 58, so 65-58=7

step2:
    ; 2. get the correct position of the string to place our ASCII char
    ; bx <- base address + string length - index of char
    mov bx, HEX_OUT + 5 ; base + length
    sub bx, cx  ; our index variable
    mov [bx], al ; copy the ASCII char on 'al' to the position pointed by 'bx'
    ror dx, 4 ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234
    ;call putch
    ; increment index and loop
    add cx, 1
    jmp hex_loop

end:
    ; prepare the parameter and call the function
    ; remember that print receives parameters in 'bx'
    mov si, HEX_OUT
    call printf
    popa
    ret

HEX_OUT:
    db '0x0000',0 ; reserve memory for our new string

; Clear Screen
; Assumes Text Page 0 and 80x50 text mode, if this is not the case edit the annoteded lines
clear_screen:
    pusha
    mov ah, 0x07
    mov al, 50
    mov bh, 0x0F
    mov ch, 0
    mov cl, 0

    ; VIDEO MODE FORMAT: AAxBB, example mode 0x03 is 80x25, and we use 80x50
    mov dh, 50 ; BB
    mov dl, 80 ; AA
    int 0x10

    mov ah, 0x02
    mov bh, 0 ; TEXT PAGE NUMBER
    mov dh, 0x00
    mov dl, 0x00
    int 0x10
    popa
    ret
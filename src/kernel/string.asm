[bits 16]
; RET 0 if false 1 if true
; SI str1
; DI str2
strcmp:
    pusha
    
    .loop:
        mov ax, [si]
        cmp [di], ax
        jne .stop
        cmp byte [di], 0
        je .stop
        cmp byte [si], 0
        je .stop
        add di, 1
        add si, 1
        jmp .loop
    .stop:
    popa
    mov ax, [di]
    sub ax, [si]
    ret

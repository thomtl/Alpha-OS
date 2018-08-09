[bits 16]

detect_hw:
    xor eax, eax
    int 0x11
    clc

    bt eax, 0
    jc detect_flp
detect_flp_ret:

    bt eax, 1
    jc coproc_detected

coproc_ret:

    bt eax, 2
    jc pointing_dev_detected

pointing_dev_detected_ret:
    clc
    xor eax, eax
    ret


detect_flp:
%if DEBUG == 1
    mov si, FLP_MSG
    call printf
    call print_nl
%endif
    jmp detect_flp_ret

coproc_detected:
%if DEBUG == 1
    mov si, COPROC_MSG
    call printf
    call print_nl
%endif
    jmp coproc_ret

pointing_dev_detected:
%if DEBUG == 1
    mov si, PS_MSG
    call printf
    call print_nl
%endif
    jmp pointing_dev_detected_ret


detect_fpu_cpuid:
    mov eax, 1
    cpuid
    clc
    bt edx, 0
    jnc cpuid_ret
    mov si, COPROC_MSG
    call printf

cpuid_ret:
    ret

COPROC_MSG: db 'Detected 80x87 Floating-Point Coprocessor', 0x0
FLP_MSG: db 'Detected Floppy disks', 0x0
PS_MSG: db 'Detected a Pointing Device (Mouse)', 0x0
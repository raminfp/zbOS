[org 0x7c00]
    KERNEL_OFFSET equ 0x1000        ; address where kernel is to be loaded

    mov [BOOT_DISK], dl             ; remember the boot disk

    mov bp, 0x9000                  ; initialise stack
    mov sp, bp

    mov bx, HELLO_MSG
    call print_str

    mov bx, REAL_MODE_MSG
    call print_str

    mov bx, LOAD_KERNEL_MSG
    call print_str
    call load_kernel

    mov bx, PROT_MODE_MSG
    call print_str
    call pm_switch

    jmp $                           ; hang. this shouldn't happen

load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 1
    mov dl, [BOOT_DISK]
    call disk_read

    ret

[bits 32]

pm_begin:
   mov ebx, PM_SUCCESS_MSG
   call print_pm_str

   jmp KERNEL_OFFSET


BOOT_DISK:
    db 0

HELLO_MSG:
    db 'Welcome to zbOS!', 13, 10, 0

REAL_MODE_MSG:
    db 'Starting in 16-bit real mode...', 13, 10, 0

PROT_MODE_MSG:
    db 'Attempting to switch to 32-bit protected mode...', 13, 10, 0

LOAD_KERNEL_MSG:
    db 'Loading kernel...', 13, 10, 0

PM_SUCCESS_MSG:
    db 'ZB!!!', 0

%include "print.asm"
%include "disk.asm"
%include "gdt.asm"
%include "pm.asm"
 
times 510-($-$$) db 0
dw 0xaa55


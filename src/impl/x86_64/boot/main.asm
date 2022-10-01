global start

section .text
bits 32
start:
    mov esp, stack_stop

    call check_multiboot
    call check_cpuid
    call check_long_mode

    ; print `OK`
    mov dword [0xb8000], 0x2f4b2f4f
    hlt 

check_multiboot:
    cmp eax, 0x36d76289
    jne .no_multiboot
    ret
.no_multiboot:
    mov al, "M"
    jmp error

check_cpuid:
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax
    push exc 
    popfd
    cmp eax, ecx

error:
    ; print "ERR, :X " where X is the error code
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov byte [0xb800a], al
    hlt
section .bss
stack_bottom:
    resb 4096 * 4
stack_stop:
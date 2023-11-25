atoi:
    push ebp
    mov  ebp, esp
    push eax
    push ebx
    push ecx
    push esi

    mov esi, [ebp+8]
    xor eax, eax
    mov ecx, 10

.atoi_next_int:
    movzx ebx, byte [esi]
    cmp   bl,  '0'
    jl    .atoi_done
    cmp   bl,  '9'
    jg    .atoi_done
    sub   bl,  48
    mul   ecx
    add   eax, ebx
    inc   esi
    jmp   .atoi_next_int

.atoi_done:
    mov [ebp+8], eax
    pop esi
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret

itoa:
    push ebp
    mov  ebp, esp
    push eax
    push ebx
    push ecx
    push edx

    mov eax, [ebp+8]
    mov eax, [eax]
    mov ebx, 10
    xor ecx, ecx

.itoa_next_int:
    xor  edx, edx
    cmp  eax, 0
    je   .itoa_reverse
    idiv ebx
    add  dl,  48
    push edx
    inc  ecx
    jmp  .itoa_next_int

.itoa_reverse:
    mov eax,              dword [ebp+8]
    mov byte [eax],       48
    mov byte [eax+ecx+1], 0
    cmp ecx,              0
    je  .itoa_done

.itoa_reverse_loop:
    pop  ebx
    mov  byte [eax+edx], bl
    inc  edx
    loop .itoa_reverse_loop

.itoa_done:
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret

slen:
    push ebp
    mov  ebp, esp
    push esi
    mov  esi, [ebp+8]

.slen_next_char:
    cmp byte [esi], 0
    je  .slen_done
    inc esi
    jmp .slen_next_char

.slen_done:
    sub esi,           [ebp+8]
    mov dword [ebp+8], esi
    pop esi
    pop ebp
    ret

write:
    push ebp
    mov  ebp, esp
    push eax
    push ebx
    push ecx
    push edx
    push dword [ebp+8]
    call slen
    pop  edx
    mov  eax, 4
    mov  ebx, 1
    mov  ecx, dword [ebp+8]
    int  80h
    pop  edx
    pop  ecx
    pop  ebx
    pop  eax
    pop  ebp
    ret  4

read:
    push ebp
    mov  ebp, esp
    push eax
    push ebx
    push ecx
    push edx
    mov  eax, 3
    mov  ebx, 0
    mov  ecx, dword [ebp+12]
    mov  edx, dword [ebp+8]
    int  80h
    pop  edx
    pop  ecx
    pop  ebx
    pop  eax
    pop  ebp
    ret  8
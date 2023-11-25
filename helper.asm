
; helper functions / procedures
; reference: https://asmtutor.com/
; copy and paste at the end of text section or include the file itself
; eax, ebx, ecx, edx - parameter holder

;------------------------------------------
; int getLgSm(Integer number, Integer number)
; Determine the largest (stored in eax) and smallest (stored in ebx)
getLgSm:
    cmp eax, ebx
    jl  swap
    ret
swap:
    push ecx
    mov  ecx, eax
    mov  eax, ebx
    mov  ebx, ecx
    pop  ecx
    ret

;------------------------------------------
; void scan(Pointer address)
; Input reading function
scan:
    mov edx, 255
    mov ecx, eax
    mov eax, 3
    mov ebx, 0
    int 0x80
    ret

;------------------------------------------
; void cprint(Character ascii)
; Character printing function
cprint:
    push eax      ; push our character to stack
    mov  eax, esp ; move the address of the current stack pointer into eax for sprint
    call sprint   ; call our sprint function
    pop  eax      ; remove our character from the stack
    ret

;------------------------------------------
; int atoi(Integer number)
; Ascii to integer function (atoi)
atoi:
    push ebx      ; preserve ebx on the stack to be restored after function runs
    push ecx      ; preserve ecx on the stack to be restored after function runs
    push edx      ; preserve edx on the stack to be restored after function runs
    push esi      ; preserve esi on the stack to be restored after function runs
    mov  esi, eax ; move pointer in eax into esi (our number to convert)
    mov  eax, 0   ; initialise eax with decimal value 0
    mov  ecx, 0   ; initialise ecx with decimal value 0
 
.multiplyLoop:
    xor ebx, ebx         ; resets both lower and uppper bytes of ebx to be 0
    mov bl,  [esi + ecx] ; move a single byte into ebx register's lower half
    cmp bl,  48          ; compare ebx register's lower half value against ascii value 48 (char value 0)
    jl  .finished        ; jump if less than to label finished
    cmp bl,  57          ; compare ebx register's lower half value against ascii value 57 (char value 9)
    jg  .finished        ; jump if greater than to label finished
 
    sub bl,  48       ; convert ebx register's lower half to decimal representation of ascii value
    add eax, ebx      ; add ebx to our interger value in eax
    mov ebx, 10       ; move decimal value 10 into ebx
    mul ebx           ; multiply eax by ebx to get place value
    inc ecx           ; increment ecx (our counter register)
    jmp .multiplyLoop ; continue multiply loop
 
.finished:
    cmp ecx, 0   ; compare ecx register's value against decimal 0 (our counter register)
    je  .restore ; jump if equal to 0 (no integer arguments were passed to atoi)
    mov ebx, 10  ; move decimal value 10 into ebx
    div ebx      ; divide eax by value in ebx (in this case 10)
 
.restore:
    pop esi ; restore esi from the value we pushed onto the stack at the start
    pop edx ; restore edx from the value we pushed onto the stack at the start
    pop ecx ; restore ecx from the value we pushed onto the stack at the start
    pop ebx ; restore ebx from the value we pushed onto the stack at the start
    ret
    
;------------------------------------------
; void iprint(Integer number)
; Integer printing function (itoa)
iprint:
    push eax    ; preserve eax on the stack to be restored after function runs
    push ecx    ; preserve ecx on the stack to be restored after function runs
    push edx    ; preserve edx on the stack to be restored after function runs
    push esi    ; preserve esi on the stack to be restored after function runs
    mov  ecx, 0 ; counter of how many bytes we need to print in the end
 
divideLoop:
    inc  ecx        ; count each byte to print - number of characters
    mov  edx, 0     ; empty edx
    mov  esi, 10    ; mov 10 into esi
    idiv esi        ; divide eax by esi
    add  edx, 48    ; convert edx to it's ascii representation - edx holds the remainder after a divide instruction
    push edx        ; push edx (string representation of an intger) onto the stack
    cmp  eax, 0     ; can the integer be divided anymore?
    jnz  divideLoop ; jump if not zero to the label divideLoop
 
printLoop:
    dec  ecx       ; count down each byte that we put on the stack
    mov  eax, esp  ; mov the stack pointer into eax for printing
    call sprint    ; call our string print function
    pop  eax       ; remove last character from the stack to move esp forward
    cmp  ecx, 0    ; have we printed all bytes we pushed onto the stack?
    jnz  printLoop ; jump is not zero to the label printLoop
 
    pop esi ; restore esi from the value we pushed onto the stack at the start
    pop edx ; restore edx from the value we pushed onto the stack at the start
    pop ecx ; restore ecx from the value we pushed onto the stack at the start
    pop eax ; restore eax from the value we pushed onto the stack at the start
    ret
 
 
;------------------------------------------
; void iprintLF(Integer number)
; Integer printing function with linefeed (itoa)
iprintLF:
    call iprint   ; call our integer printing function
    push eax
    mov  eax, 0Ah
    call cprint
    pop  eax
    ret
 
 
;------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push ebx
    mov  ebx, eax
 
nextchar:
    cmp byte [eax], 0
    jz  finished
    inc eax
    jmp nextchar
 
finished:
    sub eax, ebx
    pop ebx
    ret
 
 
;------------------------------------------
; void sprint(String message)
; String printing function
sprint:
    push edx
    push ecx
    push ebx
    push eax
    call slen
 
    mov edx, eax
    pop eax
 
    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 80h
 
    pop ebx
    pop ecx
    pop edx
    ret

 
;------------------------------------------
; void sprintLF(String message)
; String printing with line feed function
sprintLF:
    call sprint
    push eax
    mov  eax, 0Ah
    call cprint
    pop  eax
    ret
 
 
;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov ebx, 0
    mov eax, 1
    int 80h
    ret
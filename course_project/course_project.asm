.MODEL SMALL

.DATA   

sign db 0  ;here will be stored the sign of resulting mantissa
mx db ?    
my db ?    
modulated_mx db ?   ;storinghere the modulo of mx 
modulated_my db ?   ;and my
mz dw ?
ex db ?             ;exponents
ey db ?
ez db ?
msg1 db 10, 13, 'Enter mx: $'  ;text messages
msg2 db 10, 13, 'Enter my: $'
msg3 db 10, 13, 'Enter ex: $'
msg4 db 10, 13, 'Enter ey: $'
msg5 db 10, 13, 'Resulting mantissa before normalizing: $'
msg6 db 10, 13, 'Resulting exponent before normalizing: $'
msg7 db 10, 13, 'Resulting mantissa after normalizing: $'
msg8 db 10, 13, 'Resulting exponent fater normalizing: $'
empty_space db 10, 13, '$'
real_result dw ?    ;here will be stored the real calculated result, as i need it in the algorithm

.CODE

begin:
    mov ax, @data
    mov ds, ax

    
    add_exp MACRO e1, e2, e_result   ;macro which adds 2 exponents
        xor ax, ax                   ;parameters are ex, ey, ez
        mov al, e1
        add al, e2
        mov e_result, al             ;after being calculated in ax, the result goes in memory

    add_exp ENDM
    
 
    modulate MACRO operand           ;macro which computes the modulo of mantissa, the operand is a register
        local negate1, exit_modulate ;local labels to avoid ambiguity
        
        test operand, 10000000b      ;use the mask to see if the first bit of mantissa is 1
        jnz negate1                  ;if so, negate the mantissa and get the 2's complement
        jmp exit_modulate
        
        negate1:
            neg operand              ;here we obtain the modulo
        
        exit_modulate:
            nop
            
    modulate ENDM
    
    
    
    add_mantissa MACRO m1, m2, m_result   ;parameters: mx, my, mz
        xor ax, ax                        ;clear the registers
        xor bx, bx
        xor dx, dx
        mov al, m1                        ;store the multiplicant in al
        mov bl, m2                        ;store the multiplier in bl
        modulate al
        mov modulated_mx, al              ;compute store the modulos of mantissas in memory
        xor al, al
        modulate bl
        mov modulated_my, bl
        
        mov al, modulated_mx
        
        mov cx, 8h                        ;as our mantissa has 8 bits, loops count only to 8
        start:
            rcl bl, 1                     ;rotate left with carry the multiplier
            jnc only_shift                ;if the first bit, gone to carry flag, is not 1, only shift the result
            add dx, ax                    ;if not, add to result the multiplicant
            cmp dx, real_result           ;check if result coincides with the real one
            je exit_add_mantissa
            
            
            shl dx, 1                     ;and shift the result left
            jmp loopback1                 ;loop back
            
            only_shift:            
                shl dx, 1
            
            loopback1:
                loop start
            exit_add_mantissa:            ;if the loop is over or the results coincide, exit the macro
        
        mov m_result, dx                  ;and store the resultant mantissa in memory
                
    add_mantissa ENDM
    
    MACRO print_16bit numba               ;macro to print a 16 bit number
        local print_bits, loopback, put_1 ;takes the 16 bit number as parameter
        xor bx, bx
        xor dx, dx
        xor cx, cx
        mov bx, numba                     ;move the numer into bx
        mov cx, 16d
        mov ah, 02h                       ;specify the functionality of future interrupt
    
        print_bits:                       ;loop to print the bits
            rcl bx, 1                     ;rotate the number through carry flag
            jc put_1                      ;if the current bit is 1
            mov dl, '0'
            int 21h                       ;output 1
            jmp loopback
            put_1:                        ;else output 0
                mov dl, '1'
                int 21h
            
        loopback:
            loop print_bits               ;loop back
    
    print_16bit ENDM
    
    MACRO print_8bit numba                  ;the same macro as the one for printing 16 bit number
        local print_bits2, loopback2, put_11;as a parameter takes a 8 bit number 
        xor bx, bx
        xor dx, dx
        xor cx, cx
        mov bl, numba
        mov cx, 08d
        mov ah, 02h
        
        shl bx, 08d                         ;excepting that if shifts firstly the register 8 times left
                                            ;to move the low part in high part
        print_bits2:                        ;and loops only 8 times
            rcl bx, 1
            jc put_11
            mov dl, '0'
            int 21h
            jmp loopback2
            put_11:
                mov dl, '1'
                int 21h
            
        loopback2:
            loop print_bits2
    
    print_8bit ENDM
        
    
    MACRO display_message msg              ;macro to display a message on the screen, takes as parameter a string
        xor dx, dx                         ;with its attributes
        xor ax, ax
        mov dx, offset msg                 ;move the offset in dx
        mov ah, 09h                        ;specity the type of output
        int 21h                            ;print
    display_message ENDM
   
 
    display_message msg1                   ;ask for mx input
    CALL input_proc                        ;call input from keyboard
    mov mx, bl                             ;move the result to memory
                                           
    display_message msg2                   ;ask for my input
    CALL input_proc
    mov my, bl 
    
    display_message msg3                   ;ask for ex input
    CALL input_proc
    mov ex, bl
    
    display_message msg4                   ;ask for ey input
    CALL input_proc
    mov ey, bl
    
    CALL find_true_result                  ;compute the real result of multiplying the mantissas
    CALL checksign                         ;check the sign of the future mz
    add_exp ex, ey, ez                     ;call the macro for adding the exponents
    add_mantissa mx, my, mz                ;call the macro for adding the mantissas
    
    cmp sign, 1                            ;if sign if 1, means that the mantissa has to be negative
    je inverse_mantissa                    ;so jump to negating it
    jmp continue_flow                      ;otherwise continue excution
    
    inverse_mantissa:
        neg mz                             ;obtain the 2's complement of mz
    
    display_message empty_space
        
    continue_flow:
    display_message msg5                   ;print the resulting mantissa before normalization
    print_16bit mz
    display_message msg6
    print_8bit ez                          ;print the resulting exponent before normalization
    
    CALL normalization                     ;normalize the mantissa, if needed
    
    
    display_message empty_space
    display_message msg7                   ;print the mantissa and exponent after normalizing
    print_16bit mz
    display_message msg8
    print_8bit ez

mov ax, 4c00h
int 21h
                                           
normalization PROC                         ;procedure for normalizing the mantissa
    xor ax, ax                             ;clear the registers
    xor bx, bx
    xor cx, cx
    xor dx, dx
                                           ;move to ax the binary 1000000000000000b   these two are masks
    mov ax, 8000h                          ;move to bx the binary 0100000000000000b
    mov bx, 4000h                          ;move the mantissa to cx
    mov cx, mz                             ;move the exponent to dl
    mov dl, ez
    
    start_comparing:                       ;start by comparing the first 2 bits of mantissa
        test mz, ax                        ;by using the operation test you will see if first bit is 1
        jnz test_one                       ;if so, jump to test_one to test the second bit
        jmp test_two                       ;if it is 0, then jump to test_two
        test_one:
            test mz, bx                    ;test the second bit of mantissa
            jnz need_shift                 ;if it is 1, then go to shifting label
            jmp exit_normalization         ;else exit the loop
        
        test_two:                          ;test the second bit
            test mz, bx                    ;if it is 0, then shift
            jz need_shift                  ;exit otherwise
            jmp exit_normalization
        
        need_shift:
            shl cx, 1                      ;shift the mantissa one time left
            sub dl, 1                      ;subtract 1 from exponent 
            shr ax, 1                      ;shift the masks one time left
            shr bx, 1
            
            jmp start_comparing            ;continue looping
    exit_normalization:
   
    mov mz, cx                             ;store the new values in memory
    mov ez, dl
    
    RET
normalization ENDP
    

input_proc PROC                            ;procedure for user input
    xor ax, ax                             ;clear the registers
    xor bx, bx
    xor cx, cx
    mov cx, 8                              ;loop 8 times, as we input 8 bit registers
    input1:
        mov ah, 01h
        int 21h                            ;input the character
        sub al, 30h                        ;al contains the ascii code of the character, it is 30 for 0 and 31 for 1
        add bl, al                         ;so we subtract 30 to obtain 0 or 1
        shl bx, 1                          ;add the respective bit to the result
        loop input1                        ;and shift the result left
    shr bx, 1                              ;afer looping, the result will be shifted 1 more time than we need, so shift it back
    
    RET
input_proc ENDP
                                           
checksign PROC                             ;procedure for checking the sign of mantissa
    xor ax, ax                             ;store in al mx
    mov al, mx                             ;perfom the xor as sais the algorithm
    xor al, my                             ;test the result with a mask of 10000000b
    test al, 10000000b                     ;to see if the first bit is 1
    jnz sign_neg                           ;if so, means that the resulting mantissa must be negative
    jmp exit_checksign
    
    sign_neg:
        mov sign, 1                        ;so just store for now the sign in a variable
               
    exit_checksign:
    RET 
checksign ENDP

find_true_result PROC                      ;procedure for computing the real result
    
    xor ax, ax
    xor bx, bx
    mov bl, my                             ;sore in mx and my the mantissas
    mov al, mx
    modulate al                            ;find their module
    modulate bl
    mul bl                                 ;multiply
    mov real_result, ax                    ;move the result to memory
    
    RET
find_true_result ENDP

end begin

    





        
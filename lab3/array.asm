;var 7
 
 DIM EQU 10
 
.MODEL SMALL
.DATA   

;X DW 10h, 11h, 12h, 13h, 14h, 15h, 16h, 17h, 18h, 19h ; variables which will be stored in initial array
X DW -10h, -11h, -12h, -13h, -14h, -15h, -16h, -17h, -18h, -19h
DIM DW 0ah
SUM DD 0h
SUBSTR DW 10 dup(?)
; add your code here

.CODE

begin:
    mov ax, @DATA   ; these 2 rows
    mov ds, ax      ; are mandatory
    
    call sumarray   ; call the sum procedure
    
    cmp SUM, 0      ;if sum is greater pr equal than zero
    jge even        ;jump to even label
    jmp odd         ;else jump to odd label
    
    
    even:
         call evensubstr  ;call procedure for substring of even numbers
         jmp exit         ;jump to exit
    odd:
         call oddsubstr   ;call proc for odd numbers
         jmp exit         ;jump to exit
    
    exit: 
         mov ax, 4c00h    ;return control to operating system
         int 21h

sumarray PROC        ; define a procedure to compute the sum of elements
               mov ax, 0       ; initially store in ax 0
               mov di, 0       ; store the array index in DI
               mov cx, 0ah     ; store the dimension of array in CX
        loop1: 
               add ax, X[di]   ; store the sum of elements in ax
               inc di          ; increment array index by 2 as we have DW
               inc di
               loop loop1      ; loop until cx == 0
               
               mov SUM, ax     ;move the result to SUM variable
    RET                        ;return 
    sumarray ENDP

evensubstr PROC
               mov cx, 0ah
               xor di, di      ;di is index
               xor bx, bx
               mov bx, 2       ;we will divided by 2(bx)
               
               loop2:
                     xor ax, ax     ;clear ax
                     mov ax, X[di]  ;move temporarily current element from array to ax for division
                     mov si, X[di]  ;move the current element to si, to store it then in the substr
                     
                 
                     test si, 1
                     jp put_even    ;jump to put_even label
                     jmp loopback   ;else increment and do the loop
               
               put_even:
                        mov SUBSTR[di], si   ;insert the even number in substr
                     
                     loopback:
                            inc di           ;increment index
                            inc di
                            loop loop2       ;loop
                     
               
    RET
    evensubstr ENDP

oddsubstr PROC
               mov cx, 0ah
               xor di, di
               xor bx, bx
               mov bx, 2
               
               loop3:
                     xor ax, ax
                     mov ax, X[di]
                     mov si, X[di] 
                     
                     test si, 1
                     jp loopback2
                     jmp put_odd
               
               put_odd:
                        mov SUBSTR[di], si
                     
                     loopback2:
                            inc di
                            inc di
                            loop loop3
                     
               
    RET
    oddsubstr ENDP

END begin


           
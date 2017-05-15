
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt


;x i =x i-1 + 5a*b
;var 7
.MODEL SMALL
.DATA   

X DD 5 dup(0)
A DW 1234h
B DW 5678h

; add your code here

.CODE

begin:
    mov ax, @DATA   ;these 2 rows
    mov ds, ax      ;are mandatory
                                    
                                    
    mov dx, A ;move A variable to dx
    mov bx, B ;move B variable to bx
    
    shl dx, 2 ;multiply A 4 times
    add dx, A ;add A one more time to have 5 * A
    
    mov ax, dx ; move dx to ax to multiply then with bx
    mul bx ; now we have in ax 5 * A * B
    
    mov si, ax      ;store lower part of multiplication result in si
    mov di, dx      ;store greater part of multiplication result in di
    
    mov cx, 5 ;counter
    
    ;clear the variables
    xor bx, bx ;this will be the offset
    xor ax, ax
    xor dx, dx
    
    loop1:
         add dx, di ;the high part of value to be added will be stored in dx
         add ax, si ;the lower part of value to be added will be stored in ax
         
         mov [x+bx], dx ;moving the higher part to X string
         inc bx      ;incrementing the offset
         inc bx
         mov [x+bx], ax ;moving the lower part to X string
         inc bx
         inc bx
                  
         loop loop1
        
       
mov ax, 4c00h
int 21h

END begin
  
    
    
    
    
    
    
    
 comment *   
begin:
    
    mov bx, A       ;move variable A to bx
    mov dx, B       ;move variable B to dx
                    
    shl bx, 2       ;multiply A by 4 by shifting left 2 times
    add bx, A       ;add once again A to have 5 * A
    
    mov ax, bx      ;move bx to ax for multiplication
    
    mul dx          ;do the 5 * a * b
    
    mov si, ax      ;store first part of multiplication in si
    mov di, dx      ;store the second part of multiplication in di
    
    mov cx, 5       ;counter will be 5
    xor bx, bx      ;clear bx register
    mov bx, 0       ;incrementable offset
    
    label:
        mov [X+bx], dx
        inc bx
        inc bx
        mov [X+bx], ax  
        
       *
    
    
comment *   
    mov ax, Y
    mov dx, [Y+2]
    
    mov cx, 5
    
    xor bx, bx
    mov bx, 0
    
    label:
        inc bx
        inc bx
        mov X, ax
        mov [X+bx], dx
        
        loop label
         
             *









;x i =x i-1 + 5a*b
;var 7
.MODEL SMALL
.DATA   

X DD 5 dup(0)
A DW 1234h
B DW 5678h
SUM DD 0

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
    
    xor ax, ax
    xor bx, bx
    mov bx, 0
    mov cx, 5
    
    loop2:
         mov ax, X[bx] ;move the current element from array to ax
         add SUM, ax   ;add to sum the current element
         inc bx        ;increment the array index
         inc bx
         
         loop loop2    ;loop
        
       
mov ax, 4c00h
int 21h

END begin
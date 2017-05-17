;var 7
; y = x / 2 + z - 65    if z / 2 > x
; y = 2 * z - 32        if z / 2 <= x


.MODEL SMALL
.DATA   
 
 X DW 5678h
 Z DW 1234h
;X DW 1234h
;Z DW 5678h
Y DD ?

; add your code here

.CODE

begin:
    mov ax, @DATA   ;these 2 rows
    mov ds, ax      ;are mandatory
   
    
    mov ax, Z ;store z in ax for division
    shr ax, 1 ;shift right z 1 time (divide by 2)
    cmp ax, X ;compare Z/2 with x
    jg label1
    jmp label2
   
exit:   ;exit label

    mov ax, 4c00h
    int 21h


    label1:
        xor ax, ax ;clear ax
        mov ax, X  ;store X in ax
        shr ax, 1  ;divides ax by 2 by shifting 1 time right
        add ax, Z  ;add Z to ax. now have X / 2 + Z
        sub ax, 65d;subtract 65 from ax. Now have X / 2 + Z - 65
        mov Y, ax  ;store the result in Y
        jmp exit
        
    label2:
        xor ax, ax ;clear ax
        mov ax, z  ;move z to ax
        shl ax, 1  ;multiply ax by 2 by shifting 1 time left
        sub ax, 32d;subtract 32 from ax. Now have 2 * x - 32
        mov Y, ax  ;store result in Y
        jmp exit   ;exit
        
END begin



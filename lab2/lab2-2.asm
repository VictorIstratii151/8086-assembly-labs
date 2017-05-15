
.MODEL SMALL
.DATA   

X DW 1234h
Z DW 5678h
Y DD ?

; add your code here

.CODE

begin:
    mov ax, @DATA   ;these 2 rows
    mov ds, ax      ;are mandatory
   
    
    mov bx, Z  ;store Z variable in bx
    add bx, 2  ;add to bx 2. Now have z + 2
    cmp X, bx  ;if x <= z + 2
    jle label1 ;jump to label1
    
    mov ax, Z  ;move z variable in ax
    shr ax, 1 ;shift right ax one time, i.e. divide by 2                  
    ;xor cx, cx ;clear cx
    ;mov cx, 2  ;put 2 in cx
    ;div cx     ;divide ax by cx. Now in ax have Z / 2
    cmp ax, x  ;if z / 2 <= x
    jle label2 ;jump to label2
    
   
exit:   ;exit label

    mov ax, 4c00h
    int 21h


    label1:
        mov ax, X  ;move X variable to ax
        xor cx, cx ;clear cx
        mov cx, 5  ;move 5 to cx
        div cx     ;divide ax by cx. Now have X / 5
        sub ax, 25 ;subtract 25. Now have x / 5 - 25
        add ax, Z  ;now have x / 5 - 25 + z
        mov Y, ax  ;move result to Y
        jmp exit   ;exit
    
    label2:
        mov ax, Z  ;move Z to ax
        xor cx, cx ;clear cx
        mov cx, 2
        mul cx     ;multiply ax by cx (2)
        sub ax, 32d;now have 2 * Z - 32
        mov Y, ax  ;move result to Y
        jmp exit

END begin



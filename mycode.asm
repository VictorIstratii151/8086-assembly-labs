.model small 
    .stack 10h
    .data
        x dw 8
        z dw 21
        f dd ?
        .code
            begin: mov ax, @data
            mov ds, ax
            
            mov ax, x
            add ax, z
            mov cx, 2
            div cx
            mov dx, 0
            cmp ax, 2
            
            jg greater
            jle smaller
            
        greater: mov ax, x
                 mov cx, 8
                 div cx
                 
                 add ax, 52
                 
                 mov bx, z
                 sub ax, bx
                 
        smaller: mov ax, z
                 mov bx, 2
                 mul bx
                 sub ax, 61
            end begin
.MODEL SMALL
.STACK 100h
.DATA
 
X DB 12H, 39H
Y DW 1043H, 7120H
Z DD 89261932H, 10293847H

.CODE

begin:           
    mov ax, @DATA   ;these 2 rows
    mov ds, ax      ;are mandatory

;-----------------------
;FIRST TASK

    mov bl, X
    mov bh, [X+1]
    
    mov cx, [Y]
    mov dx, [Y+2]

    mov si, [Z]
    mov di, [Z+4]

;-----------------------
;SECOND TASK
    push bx    ;push the data from registers onto the stack
    push cx
    push dx
    push si
    push di
    
    XOR bx, bx  ;free the registers
    XOR cx, cx
    XOR dx, dx
    XOR si, si
    XOR di, di
    
    pop [Z+4]   ;re-establish the data in the variables
    pop Z
    pop [Y+2]
    pop [Y]
    pop cx
    mov [X+1], ch
    mov [X], cl
    
    mov ax, 3A06h
    mov ds, ax
    
    XOR ax, ax 
    XOR cx, cx

;-----------------------
;THIRD TASK

   mov al, 56h         ;immediate addrressing mode
   mov ah, al
   mov cx, ax          ;register addressing mode
   mov bx, [1526h]     ;direct addressing mode
   
   mov dx, [bx]        ;register indirect addressing mode
   XOR dx, dx
   mov dx, cs:[bx]
   XOR dx, dx
   mov dx, ds:[bp]
   XOR dx, dx
   
   XOR cx, cx
   mov cx, [si+16]     ;indexed addressing mode
   
   mov bx, [bx+di]     ;based-indexed addressing mode
   XOR al, al
   mov al, [bx][si]
   XOR al, al
   mov al, [bp][di]
   
   XOR ax, ax
   mov ax, [bx+di+08h] ;based-indexed with displacement addressing mode

      
    
    

        
mov ax, 4c00h
int 21h

END begin

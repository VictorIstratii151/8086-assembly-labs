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

mov bl, X
mov bh, [X+1]     

mov cx, [Y]
mov dx, [Y+2]

mov si, [Z]
mov di, [Z+4]
   
PUSH bx
PUSH cx
PUSH dx
PUSH si
PUSH di       


XOR bx, bx
AND cx, 0
mov dx, 0     
XOR si, si
XOR di, di

XOR ax, ax

mov ax, 3A06H
mov ds, ax     


POP [Z+4]
POP [Z+2]
POP [Y+2]
POP [Y]
POP cx
mov [X+1], ch
mov [X], cl

XOR bx, bx
AND cx, 0
mov dx, 0     
XOR si, si
XOR di, di 

mov bl, 12H; immediate 
mov bh, 39H; addressing mode 

;mov dx, [3] ;direct addressing mode
mov dx, y

mov cx, bx; register addressing mode 

;mov ax, [bx] ; indirect addressing mode




        
mov ax, 4c00h
int 21h

END begin

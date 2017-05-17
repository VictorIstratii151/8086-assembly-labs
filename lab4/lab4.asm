.model SMALL


.DATA


String1 db 'fdksjlfhkdsavdlkfsidsakjfclkjdshtkljdsoil;jrjislkjtk;ljrashlkjtii$'
String2 db 'victoristratii$'
error db 10,13,'not possible to write the name',10,13,'missing characters->$' ;10 stands for newline, 13 puts the cursor at the start of the row
its_ok db 10,13,'The word was found$'

.CODE


begin: 

mov ax, DATA
mov ds, ax


lea di, string2 ; move in di the effective address of string2
lea si, string1 ; move in si the effective address of string1
mov bh,0 ; count for missing characters

mov ah, 02 ; set cursor position
mov dh, 5 ; set the row
mov dl, 10 ; set the column


int 10h  ; interrupt for printing 



L1: cmp [di],'$' ; check if the end is not reached for string2
    je the_end


L2: cmp [si],'$' ; check if the end is not reached for string1
    je not_found


mov bl,[di] ; mov in bl the current character from string2
cmp bl,[si] ; compare with the current character from string1
jne jump

; prepare for printing if the characters coincide
 

 mov al, [di]
 xor bx, bx
 mov bl, 10b ;color
 mov bh, 0h
 mov ah, 09h
 mov cx, 01h
 int 10h
 mov ah, 02h
 inc dl
 int 10h

    
 
;mov al,[di]
;mov ah, 09h
;mov cx, 1
;mov bh, 0
;mov bl, 01
;mov ah,0Eh

;int 10h ; print the character from al

jmp continue


jump: inc si ; go to the next character of message
      jmp L2 ; loop


not_found: mov al, '*'
           mov ah, 0Eh
           int 10h
           push [di] ; remember in stack the character that was not found
           inc bh ; increase the number of missing characters

continue: inc di ; go to the next character of string2
          xor si, si
          jmp L1 ; repeat the search
          


the_end: cmp bh,0 ; check the number of not found characters
         je tend ; if all characters were found go to the OK message
 

         mov dx,offset error ; if not, print the corresponding message
         mov ah,09
         int 21h
         
         xor cx,cx ;clear cx
         mov cl,bh ; prepare the count to pop all missing characters from stack


loop1: pop dx ; and print them. In dl will be the necessary character.
       mov ah,06
       int 21h
       loop loop1


jmp end1 ; end the program when finish


tend: mov dx, offset its_ok
      mov ah,09
      int 21h


end1: nop


END begin
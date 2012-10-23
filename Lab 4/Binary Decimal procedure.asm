     ;multi-segment executable file template.



data segment

    num_hex db 0 h,096h,02h,0d2h
    num_dec db 11 dup(0)
    

ends



stack segment

    dw   128  dup(0)

ends



code segment

start:

; set segment registers:

    mov ax, data
    mov ds, ax
    mov es, ax
;begin code:

main proc near
    mov si,offset num_hex
    mov di,offset num_dec+10d
                           
;byte 8                   
mov bx,[si] 
and bx, 0F0H
shr bx,4 
;multiply by 2
mov ax,02h
mul bl
push ax
;multiply by 6
mov ax,06h
mul bl
push ax
;multiply by 8
mov ax,08h
mul bl
push ax   
;multiply by 4
mov ax,04h
mul bl
push ax
;multiply by 3
mov ax,03h
mul bl
push ax
;multiply by 5
mov ax,05h
mul bl
push ax
;multiply by 4
mov ax,04h
mul bl
push ax
;multiply by 5
mov ax,05h
mul bl
push ax
;multiply by 6
mov ax,06h
mul bl
push ax

;byte 7 
mov bx,[si] 
and bx, 0FH
;multiply by 1
mov ax,01h
mul bl
push ax
;multiply by 6
mov ax,06h
mul bl
push ax   
;multiply by 7
mov ax,07h
mul bl
push ax
;multiply by 7
mov ax,07h
mul bl
push ax
;multiply by 7
mov ax,07h
mul bl
push ax
;multiply by 2
mov ax,02h
mul bl
push ax
;multiply by 1
mov ax,01h
mul bl
push ax
;multiply by 6
mov ax,06h
mul bl
push ax


; byte  6
inc si 
mov bx,[si] 
and bx, 0F0H
shr bx,4 
;multiply by 1
mov ax,01h
mul bl
push ax
;multiply by 0
mov ax,00h
mul bl
push ax   
;multiply by 4
mov ax,04h
mul bl
push ax
;multiply by 8
mov ax,08h
mul bl
push ax
;multiply by 5
mov ax,05h
mul bl
push ax
;multiply by 7
mov ax,07h
mul bl
push ax
;multiply by 6
mov ax,06h
mul bl
push ax  


;byte 5 
mov bx,[si] 
and bx, 0FH
;multiply by 6
mov ax,06h
mul bl
push ax
;multiply by 5
mov ax,05h
mul bl
push ax   
;multiply by 5
mov ax,05h
mul bl
push ax
;multiply by 3
mov ax,03h
mul bl
push ax
;multiply by 6
mov ax,06h
mul bl
push ax


;byte 4
inc si 
mov bx,[si] 
and bx, 0F0H
shr bx,4
;multiply by 4
mov ax,04h
mul bl
push ax
;multiply by 0
mov ax,00h
mul bl
push ax   
;multiply by 9
mov ax,09h
mul bl
push ax
;multiply by 6
mov ax,06h
mul bl
push ax 


;byte 3
 
mov bx,[si] 
and bx, 0FH

;multiply by 2
mov ax,02h
mul bl
push ax
;multiply by 5
mov ax,05h
mul bl
push ax   
;multiply by 6
mov ax,06h
mul bl
push ax

;byte 2
inc si 
mov bx,[si] 
and bx, 0F0H
shr bx,4
;multiply by 1
mov ax,01h
mul bl
push ax
;multiply by 6
mov ax,06h
mul bl
push ax   

;byte 1
 
mov bx,[si] 
and bx, 0FH

;multiply by 1
mov ax,01h
mul bl
push ax

;end load stack




;back1 
pop ax 
add [di],al   
call ajust

;back2
pop ax
add [di],al   
call ajust
pop ax 
add [di-1],al   
call ajust 

;back3
pop ax
add [di],al   
call ajust
pop ax 
add [di-1],al  
call ajust
pop ax 
add [di-2],al  
call ajust

;back4
pop ax
add [di],al   
call ajust
pop ax 
add [di-1],al   
call ajust
pop ax 
add [di-2],al   
call ajust  
pop ax 
add [di-3],al   
call ajust

;back5
pop ax
add [di],al   
call ajust
pop ax 
add [di-1],al  
call ajust
pop ax 
add [di-2],al   
call ajust  
pop ax 
add [di-3],al   
call ajust
pop ax 
add [di-4],al   
call ajust



;back6
mov bx,0
mov cx,7
back6:
pop ax
add [di-bx],al   
call ajust
dec bx
loop back6   



;back7
mov bx,0
mov cx,8
back7:
pop ax
add [di-bx],al   
call ajust
dec bx
loop back7
 

;back8
mov bx,0
mov cx,9
back8:
pop ax
add [di-bx],al   
call ajust
dec bx 
loop back8 


CALL EXIT   
ret   
main endp 
;ajust method
ajust proc near
push di   
push cx
mov cx,10d
here:

mov ax,[di] 
aam
mov [di],al
add [di-1],ah
dec di
loop here
pop cx
pop di






     
       
ret    
ajust endp     
   
EXIT PROC NEAR
MOV AH,4CH
INT 21H
RET     
    
ends



end start ; set entry point and stop the assembler.


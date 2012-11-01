;final version
#start=led_display.exe# #make_bin#
name "led"

org 100h




jmp start


    option1 db 10d,13d,"1 - Select count to be upwards (0) or downwards (1)$" 
    option2 db 10d,13d,"2 - Select start to be at 0 (0) or at Keyboard input (1)$"
    option3 db 10d.13d,"3 - Select end to be at 255 (0) or at keyboard input (1)$"
    option4 db 10d.13d,"4 - Count$"
    optionq db 10d.13d,10d.13d, "Q - QUIT$"
    optionc db 10d.13d,"ENTER CHOICE:$"
    result1u db 10d.13d,10d.13d,"Counting UP"
    result1d
start:


lea bx, target_dec
lea di, target
lea dx, pKey
mov ah, 9
int 21h 
restart:
;clean registers and off burning
mov dx,127d
mov al,0
out dx,al

mov [di],030h
mov [di+1],030h
mov [di+2],030h
mov [di+3],030h
mov [bx],030H



;get user input
MOV CX,3 
mov AL, 00h
INPUT:
MOV AH, 01H
INT 21H 

cmp al,'-'
jnz input_sign
mov [di],'-'
jmp INPUT

;move the input to the target reg
input_sign:

cmp al,0dH
jz afterinput

mov ah,[di+2]
mov [di+1],ah

mov ah,[di+3]
mov [di+2],ah


mov [di+3],al

loop INPUT

afterinput:

;**************
;converting to decimal to hex
mov al,[di+3]
sub al,30h
mov [bx],ax

mov al,[di+2] 
sub al,30h
mov cx,0AH
mul cl
add [bx],al 

mov al,[di+1]
sub al,30h 
mov cx,064H
mul cl 
add [bx],al
;converting to 2nd complement
cmp [di],'-'
jnz comparing
not [bx]
add [bx],1 



;comparing temperature
comparing:
lea dx, pKey
mov ah, 9
int 21h

here:
mov AH, 01h
int 16h
jnz restart

mov dx,125d
in al,dx
  
  
cmp [bx],al  
jle donothing

mov dx,127d
mov al,1
out dx,al
jmp here

donothing:
mov dx,127d
mov al,0
out dx,al
jmp here


ret  ; return to the operating system.



print proc near



ret  ; return to the main program.
print endp



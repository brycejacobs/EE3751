;final version
#start=led_display.exe# #make_bin#
name "led"

org 100h




jmp start

    optionmenu db 9,9,9,"MENU"
    option1 db 10d,13d,10d,13d,"1 - Select count to be upwards (0) or downwards (1)" 
    option2 db 10d,13d,"2 - Select start to be at 0 (0) or at Keyboard input (1)"
    option3 db 10d,13d,"3 - Select end to be at 255 (0) or at keyboard input (1)"
    option4 db 10d,13d,"4 - Count"
    optionquit db 10d,13d,10d,13d, "Q - QUIT"
    optionchoice db 10d,13d,10d,13d,9,9,"    ENTER CHOICE:",10d,13d,10d,13d,'$'  
    
    option1_select db "Counting$"
    resultup db " UP",10d,13d,10d,13d,'$'
    resultdw db " Down",10d,13d,10d,13d,'$' 
    starting db "Starting at $"
    ending   db 10d,13d,10d,13d,"Ending at $"
    DBDIRECTION DB 00H
    DBSTARTING  DB 00H
    DBENDING    DB 0FFH
    
    target db 4  DUP(030h) 
    

start:

mov AH, 00h
mov AL, 03h
int 10h  



lea DX, optionmenu
mov AH, 09h
int 21h

    restart:
    mov al,0
    mov AH, 00h
    int 16h
    cmp al,0 
    jnz outputoption
    jmp restart

outputoption:
cmp al,'Q'
jz stop
cmp al,'q'
jz stop

cmp al,31h
jz cmp_option1

cmp al,32h
jz cmp_option2

cmp al,33h
jz cmp_option3

cmp al,34h
jz cmp_option4
jmp restart:



cmp_option1:

lea DX, option1_select
mov AH, 09h
int 21h

restart_1:
mov al,0
mov AH, 00h
int 16h 

cmp al,30h
jz up
cmp al,31H
jz down 
cmp al,'Q'
jz stop
jmp restart_1 
up:
lea DX, resultup
mov AH, 09h
int 21h
mov [DBDIRECTION],0
jmp restart
down:
lea DX, resultdw
mov AH, 09h
int 21h
mov [DBDIRECTION],1
jmp restart





;************************************************
cmp_option2: 
;************************************************
lea di, target
lea bx, DBSTARTING


mov [di],030h
mov [di+1],030h
mov [di+2],030h
mov [di+3],030h


lea DX, starting
mov AH, 09h
int 21h

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

mov dx,199d
mov ah,00h
mov al,[DBSTARTING]
out dx,al

jmp restart 


;************************************************
cmp_option3: 
;************************************************

lea di, target
lea bx, DBENDING


mov [di],030h
mov [di+1],030h
mov [di+2],030h
mov [di+3],030h



lea DX, ending
mov AH, 09h
int 21h

;get user input
MOV CX,3 
mov AL, 00h
INPUT3:
MOV AH, 01H
INT 21H 

cmp al,'-'
jnz input_sign3
mov [di],'-'
jmp INPUT3

;move the input to the target reg
input_sign3:

cmp al,0dH
jz afterinput3

mov ah,[di+2]
mov [di+1],ah

mov ah,[di+3]
mov [di+2],ah


mov [di+3],al

loop INPUT3

afterinput3:

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

mov dx,199d
mov ah,00h
mov al,[DBENDING]
out dx,al

jmp restart



cmp_option4:
;counting routine
;###################################
mov dx,199d
mov ah,00h
mov al,[DBSTARTING]
out dx,al

cmp [DBDIRECTION],1
jz downward
upward:
inc al
out dx,al
cmp [DBENDING],al
jz stop
cmp al,0FFh
jz stop
jmp upward

downward:
dec al
out dx,al
cmp [DBENDING],al
jz stop
cmp al,0h
jz stop
jmp downward:

stop:
RET






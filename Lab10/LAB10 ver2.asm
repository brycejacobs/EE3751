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
    option5 db 10d,13d,"5 - Count by x" 
    option6 db 10d,13d,"6 - One way (1)/two way (2)"
     
    optionquit db 10d,13d,10d,13d, "Q - QUIT"
    optionchoice db 10d,13d,10d,13d,9,9,"    ENTER CHOICE:",10d,13d,10d,13d,'$'  
    
    option1_select db "Counting$"
    resultup db " UP$"
    resultdw db " Down$" 
    starting db "Starting at $"
    ending   db "Ending at $"
    countby  db "Counting By $"
    oneway   db "One Way$"
    twoway   db "two way"
    
    
    DBDIRECTION DB 00H
    DBSTARTING  DB 00H
    DBENDING    DB 0FFH
    DBCOUNTBYX  DB 01H
    DBWAY       DB 00H
    dbwayswi    db 00h
    
    number db "225$" 
    nextline db  10d,13d,'$'
    target db 4  DUP(030h) 
    

start:

mov AH, 00h ;set up video mode
mov AL, 03h
int 10h 


mov AH, 09h ;color and backgrond
mov AL, ' '
mov BH, 0
mov BL, 00011110b
mov CX, 10000d
int 10h 



lea DX, optionmenu ;print menu
mov AH, 09h
int 21h 


;clear register
mov [DBDIRECTION],0
mov [DBSTARTING],0
mov [DBENDING],0ffH
mov [DBCOUNTBYX],1
mov [DBWAY],0


restart:
lea DX, nextline
mov AH, 09h
int 21h
    
        
    mov al,0
    mov AH, 00h
    int 16h
    cmp al,0 
    jnz outputoption
    jmp restart

outputoption: ;test options
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


cmp al,35h
jz cmp_option5


cmp al,36h
jz cmp_option6
jmp restart:


;******************
cmp_option1:
;***********************
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

mov AL, 00h
MOV AH, 01H
INT 21H
cmp al,030h
jz default2
MOV CX,3 

jmp here2

;get user input
MOV CX,3 
mov AL, 00h
INPUT:
MOV AH, 01H
INT 21H 
here2:
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
;***************
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

default2:
mov [DBSTARTING],0 

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


mov al,0
mov AH, 00h
int 16h 
cmp al,030h
jz default3

mov ah, 2
mov dl, al
int 21h

MOV CX,3 


jmp here3



;get user input
MOV CX,3 
mov AL, 00h
INPUT3:
MOV AH, 01H
INT 21H 
here3:
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

default3:
mov [DBENDING],0FFh
lea DX, number
mov AH, 09h
int 21h
jmp restart

 
;*******************
cmp_option4:        
;********************
;counting routine
;
mov dx,199d
mov ah,00h
mov al,[DBSTARTING]
out dx,al

cmp [DBDIRECTION],1
jz downward

upward:
add al,[DBCOUNTBYX]
out dx,al


mov bl,[DBENDING]
sub bl,al
cmp bl, [DBCOUNTBYX]
mov [dbwayswi],0
jb  repeat
jmp upward


;cmp al,[DBENDING]
;jz repeat
;cmp al,0
;jae repeat
;jmp upward

downward:
sub al,[DBCOUNTBYX]
out dx,al 
 
 
mov cl,al 
mov bl,[DBENDING]
sub cl,bl
cmp cl, [DBCOUNTBYX] 
mov [dbwayswi],1
jl  repeat
jmp downward


;cmp [DBENDING],al
;jae repeat
;cmp al,0h
;jz repeat
;jmp downward:


repeat: 

cmp [DBWAY],01h
jz bf

jmp start
 
 
bf:
mov bl,al
mov al,[dbstarting]

mov [dbstarting],bl
mov [dbending],al
mov al, [dbstarting]

mov [DBWAY],00h

cmp [dbwayswi],00h
jz downward
jmp upward


;*******************
cmp_option5:        
;********************
;cOUNTING BY
;

lea di, target
lea bx, DBCOUNTBYX


mov [di],030h
mov [di+1],030h
mov [di+2],030h
mov [di+3],030h


lea DX, countby
mov AH, 09h
int 21h 

mov AL, 00h
MOV AH, 01H
INT 21H
cmp al,030h
jz default2_5
MOV CX,3 

jmp here2_5

;get user input
MOV CX,3 
mov AL, 00h
INPUT_5:
MOV AH, 01H
INT 21H 
here2_5:
cmp al,'-'
jnz input_sign_5
mov [di],'-'
jmp INPUT_5

;move the input to the target reg
input_sign_5:

cmp al,0dH
jz afterinput_5

mov ah,[di+2]
mov [di+1],ah

mov ah,[di+3]
mov [di+2],ah


mov [di+3],al

loop INPUT_5

afterinput_5:

;**************
;converting to decimal to hex
;***************
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
mov al,[DBCOUNTBYX]
out dx,al




jmp restart 

default2_5:
mov [DBSTARTING],0 

jmp restart

;*******************
cmp_option6:        
;********************
;way
;

lea di, target
lea bx, DBCOUNTBYX

restart_6:
mov al,0
mov AH, 00h
int 16h 

cmp al,31h
jz one_way
cmp al,32H
jz two_way 
cmp al,'Q'
jz stop
jmp restart_6 

one_way:
mov [dbway],0
lea DX, oneway
mov AH, 09h
int 21h 


jmp restart 

two_way:

mov [dbway],1
lea DX, twoway
mov AH, 09h
int 21h 
jmp restart


stop:


RET






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
    optionchoice db 10d,13d,10d,13d,9,9,"    ENTER CHOICE:$"  
    
    result1u db 10d,13d,10d,13d,"Counting UP$"
    result1d db 10d,13d,10d,13d,"Counting Down$" 
    starting db 10d,13d,10d,13d,"Starting at$"
    ending   db 10d,13d,10d,13d,"Ending at$"
    DBDIRECTION DB 00H
    DBSTARTING  DB 00H
    DBENDING    DB 0FFH

start:

mov AH, 00h
mov AL, 03h
int 10h  

lea DX, optionmenu
mov AH, 09h
int 21h

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






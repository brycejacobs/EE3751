

data segment      

MENU db 0Ah, 0Ah, 09h, 09h, 09h, 'MENU$', 
OPTION1 db 0Ah, 0Dh, 0Ah,09h, 09h,'1-Enter values$' 
OPTION2 db 0Dh, 0Ah, 09h,09h,'2-Add$'
OPTION3 db 0Dh, 0Ah, 09h,09h,'3-Subtract$'
OPTION4 db 0Dh, 0Ah, 09h,09h,'4-Multiply$'
QUIT db 0Dh, 0Ah, 0Ah, 09h,09h,'Q-QUIT$'
CHOICEPROMPT db 0Ah, 0Ah, 0Dh,09h,'Enter choice of operation:$' 
SHOWADD db 0Ah, 0Ah, 0Dh, 09h,'X+Y=$'
SHOWSUB db 0Ah, 0Ah, 0Dh, 09h,'X-Y=$'
SHOWMULT db 0Ah, 0Ah, 0Dh, 09h,'X*Y=$' 
INPUTA db 0Ah, 0Ah, 0Dh, 09h,'X:$'
INPUTB db 0Ah, 0Dh, 09h,'Y:$'
SIGN DB '-$'

    
A           db  4  DUP(?)
B           db  4  DUP(?)
PRODUCT     db  4  DUP(?)
COUNT       db  4  DUP(?) 
SUM         db  4  DUP(?)          
NUMBER      db  11 DUP(?),'$'

DIFFERENCE  db  4  DUP(?)
ends   

stack segment
    dw 128 dup(0)
ends

code segment 
    
    main proc far 
        
        mov ax, data
        mov ds, ax
        mov es, ax
        
        mov AH, 00h
        mov AL, 03h
        int 10h 
        
        mov AH, 09h
        mov AL, ' '
        mov BH, 0
        mov BL, 00011110b
        mov CX, 10000d
        int 10h
        
        call Display_Menu 
        
        Keep_Menu:
        call Reactive_Display    
        jmp Keep_Menu
        
        ret
       
    main endp
    
    Display_Menu proc near 
        
        
        lea DX, MENU
        call Display_String
       
        lea DX, OPTION1
        call Display_String
        
        lea DX, OPTION2
        call Display_String
        
        lea DX, OPTION3
        call Display_String
        
        lea DX, OPTION4
        call Display_String 
        
        lea DX, QUIT
        call Display_String
        
        lea DX, CHOICEPROMPT
        call Display_String  
           
        ret
        
    Display_Menu endp
    

    Display_String proc near
        mov AH, 09h
        int 21h
        
        ret
    Display_String endp
    
    Retrieve_Action proc near 
        
        mov AX, 0
        int 33h 
        cmp AX, 0
        jz setkeyboard
        
        ;mov AX, 1h
        ;int 33h 
        
        ;getstatus:
        ;    mov AH, 01h
        ;    int 16h 
        ;    jnz outputoption
        ;    
        ;    mov AH, 00h
        ;    mov AX, 3h 
        ;    int 33h
        ;    cmp BX, 1 
        ;    jz leftclick
        ;jmp getstatus
            
            

        outputoption:
        mov AH, 07h
        int 21h
        jmp keyboardread   

            
            
        setkeyboard:     
        mov AH, 01h
        int 21h    
        
        keyboardread:
            

        cmp AL, 51h
        jz EXIT
        
        cmp AL, 71h
        jz EXIT 
        
        cmp AL, 31h
        jz numbers 
        
        cmp AL, 32h
        jz calladd
        
        cmp AL, 33h
        jz callsub
        
        cmp AL, 34h
        jz callmult
        
        jmp END 
        
        numbers:
        call Retrieve_Numbers
        jmp END 
        
        calladd:
        call ADD_A_B
        jmp END
        
        callsub:
        call XminuY
        jmp END
        
        callmult:
        call PRODUCT_A_B
        jmp END
        
        leftclick:
        ;get position
        
        mov AX, DX
        mov DL, 0
        mov DL, 8
        div DL
        ;

        
        
        cmp AL, 04h
        jz numbers
        
        cmp AL, 05h
        jz calladd
        
        cmp AL, 06h
        jz callsub
        
        cmp AL, 07h
        jz callmult 
        
        cmp AL, 09h
        jz EXIT 
        
        
        
        jmp END
        
        
         
        END: 
        
        ret
    Retrieve_Action endp
    
    Reactive_Display proc near
       
        call Retrieve_Action
        
        ret 
        
        
    Reactive_Display endp
    
    Retrieve_Numbers proc near 
        
        call Retrieve_A
        call Retrieve_B
        
        ret
        
    Retrieve_Numbers endp
    
   
    Retrieve_A proc near:
               
        lea DX, INPUTA 
        call Display_String
        
        call INPUT_NUMBER
        
         
        lea DI, A
        
        call CONV_ASC2BIN 
        cmp [NUMBER+9],'-'
        jnz Ret_a_cont
        call SECOND_COMPLEMENT
        
        
        Ret_a_cont:
        call Erase_Variables 
        
        ret
        
    Retrieve_A endp 
    
    
   
    Retrieve_B proc near:

        
        lea DX, INPUTB    
        call Display_String
        
        call INPUT_NUMBER 
        
        lea DI, B
        
        call CONV_ASC2BIN
        cmp [NUMBER+9],'-'
        jnz Ret_b_cont
        call SECOND_COMPLEMENT
        
        
        Ret_b_cont:  
        call Erase_Variables
        ret    
        
    
    
    Retrieve_B endp

    ;Grab the number from the user;
    INPUT_NUMBER proc near
    MOV DI, offset NUMBER
    
    MOV CX,9 
    mov AL, 00h
    INPUT:
    MOV AH, 01H
    INT 21H 
    
    
    
    CMP AL,'Q'
    JZ  EXIT
    CMP AL,'q'
    JZ  EXIT  
    CMP AL,0Dh
    JZ  NEXT
    CMP AL,'-'
    JNZ NOCOMPLEMENT
    mov [di+9],'-'
    jmp INPUT
    
    NOCOMPLEMENT: 
    MOV [DI],AL
    INC DI 
    LOOP  INPUT 
   
    CMP CX,0h
    JZ RETURN
    NEXT:
    ;CX HAVE A VALUE IF CX=1 MOVE NUMBER RIGHT 1
    ;REARRENGE THE NUMBERS
    
    
    MOV BX,CX
    
    FILLING_ZERO:
    MOV AX,30h
    PUSH AX
    LOOP FILLING_ZERO  
    
    MOV DI, offset NUMBER
    
    NOT BX
    ADD BX,10d
    
    MOV CX,BX
    LOAD_NUMBER:
    PUSH [DI]
    INC DI
    LOOP LOAD_NUMBER 
    
    MOV CX,9
    MOV DI, offset NUMBER+8  
    SET_NUMBER:
    POP AX
    MOV [DI],AL
    DEC DI
    LOOP SET_NUMBER
     
    RETURN:

        ret
        
    INPUT_NUMBER endp
     
    ; Convert from ASCII to Binary ;             
    CONV_ASC2BIN proc near
        
   
    
    lea SI, NUMBER
    
    mov CX, 9
    ;MOVING ALL NUMBER TO DECIMAL
    HERE:
        SUB [SI],30H
        INC SI
        LOOP HERE ;END CONVERSION TO BINARY
        
         
        
        ; CREATE TABLE FROM 10^0 TO 10^9
        MOV CX,8
        
        MOV BX,10d
        MOV AX,01 
        MOV DX,0 
        PUSH DX
        PUSH AX
    
    TABLE:
        MUL BX
        PUSH DX
        PUSH AX
        LOOP TABLE 
        
        ;FIXING THE MSB FROM TABLE
        MOV CX,8 
        ADD SP,34d
        FIX_MSB:
        
        POP AX
        MUL BL
        SUB SP,6
        POP DX
        ADD AX,DX
        PUSH AX
        
        
        LOOP FIX_MSB ;END CREATE TABLE/FIXING
        SUB SP,2
        
        ;BEGINING MULTIPLICATION AND MOVING DESTINATION
        MOV SI,offset NUMBER
        CLC
        PUSHF
    HERE2:
    
        MOV AX,[SI]
        AND AX,0Fh
        POPF
        POP BX
        PUSHF
        MUL BX
        MOV CX,DX
        POPF
        ADC [DI+3],AL 
        ADC [DI+2],AH 
        PUSHF
        
        
        MOV AX,[SI]
        AND AX,0Fh  
        
        POPF
        POP BX
        PUSHF
        
        MUL BX
        ADD CX,DX
        ADD AX,CX
        POPF
        ADC [DI+1],AL 
        ADC [DI],AH
        PUSHF 
        INC SI
        MOV AX,offset number+9
        CMP SI,AX
        
        JNZ HERE2
        POPF

    ret

    CONV_ASC2BIN endp 
    
    SECOND_COMPLEMENT proc near
    MOV BX,3
    MOV CX,3 
    CLC
    NOT [DI+BX] 
    ADD [DI+BX],1 
    DEC BX
    CONVERTNUMBER:
    NOT [DI+BX]
    DEC BX
    LOOP CONVERTNUMBER

    ;ENDCONVERT 2COMPLEMENT
    
    
    
        
    ret
    SECOND_COMPLEMENT endp 
    
    
    ADD_A_B proc near 
        lea DX, SHOWADD
        call Display_String
        mov DI,offset SUM+3
        mov SI,offset A+3
        mov BX,Offset B+3
        clc
        mov CX,4
        
        Addition:
         
            mov AL,[SI]
            adc AL,[BX]
            mov [DI],AL 
            
            dec DI
            dec SI
            dec BX     
        loop Addition
         
        mov si,offset SUM
        mov al,[si]
        and al,80H;check is it negative
        cmp al,80H
        jnz bin_dec
        mov DI,offset SUM
        call SECOND_COMPLEMENT
        mov dx,offset sign
        call Display_String
        bin_dec:
        call Bin_Dec_ASCII
        
        
        mov dx,offset Number
        re_add:
        mov di,dx
        inc dx
        mov al,[di+1]
        cmp al,30h
        jz re_add 

  
         
        call Display_String
        call Erase_Variables   
    ret
    
    ADD_A_B endp 

    XminuY proc near 
        lea DX, SHOWSUB
        call Display_String
        mov DI,offset DIFFERENCE+3
        mov SI,offset A+3
        mov BX,Offset B+3
        
        clc
        mov CX,4
    
        Subtract:
     
            mov AL,[SI]
            sbb AL,[BX]
            mov [DI],AL 
            dec DI
            dec SI
            dec BX
        loop Subtract
        
        mov si,offset DIFFERENCE
        mov al,[si]
        and al,80H;check is it negative
        cmp al,80H
        jnz bin_dec2
        mov DI,offset DIFFERENCE
        call SECOND_COMPLEMENT
        mov dx,offset sign
        call Display_String
        bin_dec2:
        call Bin_Dec_ASCII
        
        
        mov dx,offset Number
        re_add2:
        mov di,dx
        inc dx
        mov al,[di+1]
        cmp al,30h
        jz re_add2  
         
        call Display_String
        call Erase_Variables   
   
        ;****** 
        
        
    ret
    
    XminuY endp
    
    PRODUCT_A_B proc near
        lea DX, SHOWMULT
        call Display_String
        MOV NUMBER,0
        MOV BX,OFFSET A
        MOV SI,OFFSET B
        mov di,offset PRODUCT 
        PUSH [BX]
        PUSH [BX+1]
        PUSH [BX+2]
        PUSH [BX+3]
        PUSH [SI]
        PUSH [SI+1]
        PUSH [SI+2]
        PUSH [SI+3]
        
        ;*************
        
        
        mov al,[BX]
        and al,80H;check is it negative
        cmp al,80H
        jnz REG_B
        mov DI,offset A
        call SECOND_COMPLEMENT
        
        ADD NUMBER,1
        
        REG_B: 
        
        mov al,[SI]
        and al,80H;check is it negative
        cmp al,80H
        jnz REG_C
        mov DI,offset B
        call SECOND_COMPLEMENT
        
        ADD NUMBER,1
        
        REG_C:  
        CMP NUMBER,1
        JNZ NOT_SIGN
        
        mov dx,offset sign
        call Display_String
        call Erase_Variables
        
        
        NOT_SIGN:
        
        
        ;*************
        MOV BX,OFFSET A
        MOV SI,OFFSET B
        mov di,offset PRODUCT
        
        
        
        
        ;FIRST DIGIT
        mov AH, [BX+2]
        mov AL, [BX+3] 
        mov cx,0
        mov cl,[si+3]
        mul cx
        
        MOV [DI],DH
        MOV [DI+1],DL
        MOV [DI+2],AH
        MOV [DI+3],AL
        
        mov AH, [BX]
        mov AL, [BX+1] 
        mov cx,0
        mov cl,[si+3]
        mul cx
        
        ADD [DI+1],AL
        ADC [DI],AH
        ;SECOND  DIGIT
        mov AH, [BX+2]
        mov AL, [BX+3] 
        mov cx,0
        mov cl,[si+2]
        mul cx 

        ADD [DI+2],AL
        ADC [DI+1],AH
        ADC [DI],DL 
        
        mov AH, [BX]
        mov AL, [BX+1] 
        mov cx,0
        mov cl,[si+2]
        mul cx
      
        ADC [DI],AL
        
        ;THRID DIGIT
         
        mov AH, [BX+2]
        mov AL, [BX+3] 
        mov cx,0
        mov cl,[si+1]
        mul cx 

        ADD [DI+1],AL
        ADC [DI],AH
            
         
         
        ;FOURTH DIGIT
        mov AH, [BX+2]
        mov AL, [BX+3] 
        mov cx,0
        mov cl,[si]
        mul cx 

        ADD [DI],AL
        
        
        
        
        
        ;*****
        
        mov SI,offset PRODUCT
        
        call Bin_Dec_ASCII
        
        
        mov dx,offset Number
        re_add3:
        mov di,dx
        inc dx
        mov al,[di+1]
        cmp al,30h
        jz re_add3  
         
        call Display_String
        call Erase_Variables
        
        MOV BX,OFFSET A
        MOV SI,OFFSET B
        POP [SI+3]
        POP [SI+2]
        POP [SI+1]
        POP [SI]
        POP [BX+3]
        POP [BX+2]
        POP [BX+1]
        POP [BX]
        
        
        
        
        
        
        
        
        
        ret
        
    PRODUCT_A_B endp 
    
    

    ; Erase all the variables ;
    Erase_Variables proc near
          
         mov CX, 11
         lea DI, Number
         clearNumber:
            mov [DI], 00h
            inc DI   
         loop clearNumber
         
         mov DX, 0000h
         mov AH, 00h
    
    
        ret
    Erase_Variables endp
    
    
    Bin_Dec_ASCII proc near


    ;begin code:

    
    mov di,offset NUMBER+10d
                           
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
    
    ;Decimal to ASCII
    mov bx,1 
    mov cx,10 
    lea di,number
    decconver:
    add [DI+bx],030H
    inc bx
    loop decconver
     
    ret   
    Bin_Dec_ASCII endp 
    
    ;ajust method
    ajust proc near
    push di   
    push cx
    mov cx,10d
    hereadjust:
    
    mov ax,[di] 
    aam
    mov [di],al
    add [di-1],ah
    dec di
    loop hereadjust
    pop cx
    pop di
            
    ret    
    ajust endp 
    
    
    
    
    
    
    
       
    EXIT proc near
        ; Exit the program  
        mov AH, 00h
        mov AL, 03h
        int 10h
        
        mov AH, 4Ch
        int 21h    
        ret
    EXIT endp
    
    

        
        
        
        
        
        
        
    
    
    
    
    
ends

    
end main



        




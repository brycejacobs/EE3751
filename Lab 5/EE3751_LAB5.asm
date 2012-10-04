

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
INPUTX db 0Ah, 0Ah, 0Dh, 09h,'X:$'
INPUTY db 0Ah, 0Dh, 09h,'Y:$'
    
X           db  4  DUP(?)
Y           db  4  DUP(?)
COUNT       db  4  DUP(?) 
SUM         db  4  DUP(?)          
NUMBER      db  11 DUP(?)
DIFFERENCE  dw  4  DUP(?)
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
        
        mov AH, 01h
        int 21h
        
        cmp AL, 51h
        jz EXIT
        
        cmp AL, 71h
        jz EXIT 
        
        cmp AL, 31h
        call Retrieve_Numbers
        jmp END 
        
        cmp AL, 32h
        call ADD_X_Y
        jmp END
        
        cmp AL, 33h
        call XminuY
        jmp END
        
        cmp AL, 34h
        call PRODUCT_A_B
         
        END: 
        
        ret
    Retrieve_Action endp
    
    Reactive_Display proc near
       
        call Retrieve_Action
        
        ret 
        
        
    Reactive_Display endp
    
    Retrieve_Numbers proc near 
        
        call Retrieve_X
        call Retrieve_Y
        
        ret
        
    Retrieve_Numbers endp
    
   
    Retrieve_X proc near:
               
        lea DX, INPUTX 
        call Display_String
        
        call INPUT_NUMBER
         
        lea DI, X
        
        call CONV_ASC2BIN
        call Erase_Variables 
        
        ret
        
    Retrieve_X endp 
    
    
   
    Retrieve_Y proc near:

        
        lea DX, INPUTY    
        call Display_String
        
        call INPUT_NUMBER 
        
        lea DI, Y
        
        call CONV_ASC2BIN  
        call Erase_Variables
        ret    
        
    
    
    Retrieve_Y endp

    ;Grab the number from the user;
    INPUT_NUMBER proc near
         MOV DI, offset NUMBER
    
    MOV CX,9
    INPUT:
    MOV AH, 01H
    INT 21H 
    
    CMP AL,'Q'
    JZ  EXIT
    CMP AL,'q'
    JZ  EXIT  
    CMP AL,0Dh
    JZ  NEXT
   
    
     
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
    
    ADD_X_Y proc near 
        
        mov DI,offset SUM+3
        mov SI,offset X+3
        mov BX,Offset Y+3
        
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
    
    ret
    
    ADD_X_Y endp 

    XminuY proc near
        mov DI,offset DIFFERENCE+3
        mov SI,offset X+3
        mov BX,Offset Y+3
        
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
    
    ret
    
    XminuY endp
    
    PRODUCT_A_B proc near
        lea SI, X
        lea BX, Y
         
        
        
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
    
       
    EXIT proc near
        ; Exit the program
        mov AH, 4Ch
        int 21h    
        ret
    EXIT endp
    
    

        
        
        
        
        
        
        
    
    
    
    
    
ends

    
end main



        




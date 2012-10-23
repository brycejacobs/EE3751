

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
    
A           db  4  DUP(?)
B           db  4  DUP(?)
PRODUCT     dw 4 DUP(?)
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
        
        mov AX, 0
        int 33h 
        cmp AX, 0
        jz setkeyboard
        
        mov AX, 1h
        int 33h 
        
        getstatus:
            mov AH, 01h
            int 16h 
            jnz outputoption
            
            mov AH, 00h
            mov AX, 3h 
            int 33h
            cmp BX, 1 
            jz leftclick
        jmp getstatus
            
            

        outputoption:
        mov AH, 01h
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
        call Erase_Variables 
        
        ret
        
    Retrieve_A endp 
    
    
   
    Retrieve_B proc near:

        
        lea DX, INPUTB    
        call Display_String
        
        call INPUT_NUMBER 
        
        lea DI, B
        
        call CONV_ASC2BIN  
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
        
        call bin_Dec_acii
        
    
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
    
    ret
    
    XminuY endp
    
    PRODUCT_A_B proc near
        MOV BX,OFFSET A
        MOV SI,OFFSET B 
        mov AH, [BX]
        mov AL, [BX+1] 
        
        MOV CH, [SI]
        MOV CL, [SI+1]
        MUL CX  
        MOV PRODUCT,AX
        MOV PRODUCT+2,DX 
        
        MOV AH,[BX]
        MOV AL,[BX+1] 
        mov CH, [SI+2]
        mov CL, [SI+3]
        MUL CX
        ADD PRODUCT+2,AX
        ADC PRODUCT+4,DX
        JNC L3
        INC PRODUCT+6
        
        L3: MOV AH,[BX+2]
            MOV AL,[BX+3]
            MOV CH, [SI]
            MOV CL, [SI+1]
            MUL CX 
            ADD PRODUCT+2,AX
            ADC PRODUCT+4,DX
            JNC L4
            INC PRODUCT+6
        
        L4: MOV AH,[BX+2]
            MOV AL,[BX+3] 
            mov CH, [SI+2]
            mov CL, [SI+3]
            MUL CX
            ADD PRODUCT+4,AX
            ADC PRODUCT+6,DX
            
            MOV PRODUCT+8, 2400h ;Insert '$' so we can display String later
            MOV AH, 09h
            MOV DX, OFFSET PRODUCT
            INT 21h

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



        




; multi-segment executable file template.

data segment
    
    SUM DB 4 DUP(?)
    DIFFERENCE DB 4 DUP(?)
    A  DB 4 DUP(0)
    B  DB 4 DUP(0)
    NUMBER DB 11 DUP('0')
    MSSG1 DB "ENTER A:$"
    MSSG2 DB 0AH,0DH, "ENTER B:$"
    
ends

stack segment
    dw   128  dup(0)
ends


code segment


start:

    mov ax, data
    mov ds, ax
    mov es, ax
    
    MOV AX,03h
    INT 10h
    

;SHOW ENTER A:
    MOV DX,offset MSSG1 
    MOV AH,09
    INT 21H
    CALL INPUT_NUMBER
    MOV DI,offset A
    CALL CONV_ASC2BIN 
    

;SHOW ENTER B:
     
    
    MOV DX,offset MSSG2 
    MOV AH,09
    INT 21H
    CALL INPUT_NUMBER
    MOV DI,offset B
    CALL CONV_ASC2BIN  
                   

;ADD A+B
    
    CALL ADD_A_B
                     

;DIFFERENCE

    CALL AminuB 
    
    
;Afte input A&b clean Screen and restart program; 
    
    MOV AH, 01h
    INT 21h
    
    MOV AH,02H
    MOV BH,0
    MOV DH,0
    MOV DL,0
    INT 10h
      
    MOV CX,10000d
    MOV AH,09h
    MOV AL,20h 
    MOV BH,00h 
    MOV BL,04h
    INT 10h
    
    lea DI, NUMBER
    call CLEAR 
    
    lea DI, A
    call CLEAR
    
    lea DI, B
    call CLEAR
    
    lea DI, DIFFERENCE
    call CLEAR
    
    lea DI, SUM
    
    
                                             
    JMP   START                   
                      

;READ KEYBOARD INPUT


INPUT_NUMBER proc near:

    
    MOV DI, offset NUMBER
    
    MOV CX,9
    INPUT:
    MOV AH, 01H
    INT 21H 
    
    CMP AL,'Q'
    JZ  CALLEXIT
    CMP AL,'q'
    JZ  CALLEXIT  
    CMP AL,0Dh
    JZ  NEXT
   
    
     
    MOV [DI],AL
    INC DI 
    LOOP  INPUT 
   
    CMP CX,0h
    JZ  END
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
    jmp END
    
    CALLEXIT:
    call ENDPROGRAM
     
    END:

    RET
INPUT_NUMBER ENDP


CONV_ASC2BIN proc near:

    
    MOV SI,offset NUMBER
    
    MOV CX,9
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
    RET
    
CONV_ASC2BIN ENDP


 
ADD_A_B proc near
    MOV DI,offset SUM+3
    MOV SI,offset A+3
    MOV BX,Offset B+3
    
    CLC
    MOV CX,4
    
    ADDITION:
 
    MOV AL,[SI]
    ADC AL,[BX]
    MOV [DI],AL 
    
    DEC DI
    DEC SI
    DEC BX
    
    LOOP ADDITION
    
    RET
    
    ADD_A_B ENDP 

AminuB proc near
    MOV DI,offset DIFFERENCE+3
    MOV SI,offset A+3
    MOV BX,Offset B+3
    
    CLC
    MOV CX,4
    
    SUBSTRAC:
 
    MOV AL,[SI]
    SBB AL,[BX]
    MOV [DI],AL 
    DEC DI
    DEC SI
    DEC BX
    LOOP SUBSTRAC
    
    RET
    
    AminuB ENDP
    
     
CLEAR proc near:

mov CX, 4
clearvalue:
    mov [DI], 0
    inc DI
loop clearvalue

ret    

CLEAR endp   
   
  

ENDPROGRAM proc near:    
    
    MOV AH,4Ch
    MOV AL,0 
    INT 21h
    ret
ENDPROGRAM endp
    
    
       
    


end start ; set entry point and stop the assembler.
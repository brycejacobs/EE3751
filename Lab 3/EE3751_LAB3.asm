

data segment      
    
AGREETING db 'Enter A:$'
BGREETING db 0Ah , 'Enter B:$'
A           db  4  DUP(?)
B           db  4  DUP(?) 
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
    
        call Retrieve_A 
         
        call Retrieve_B 
        
        call ADD_A_B
        
        call AminuB
        
        
        call EXIT
        
        
        
        
    main endp
    
    ;Special call for retrieving A, converting it then returning it;
    Retrieve_A proc near:
               
        mov DX, offset AGREETING ;set DX to the address of A
        mov AH, 9h
           
        int 21h
        call INPUT_NUMBER 
        lea DI, A
        call CONV_ASC2BIN
        call Erase_Variables
        ret
        
    Retrieve_A endp 
    
    
    ;Special call for retrieving A, converting it then returning it;
    Retrieve_B proc near:

        
        mov DX, offset BGREETING ; set DX to the address of B    
        mov AH, 9h
        int 21h
        call INPUT_NUMBER
        lea DI, B
        call CONV_ASC2BIN  
        ;call Erase_Variables
        ret    
        
    
    
    Retrieve_B endp

    ;Grab the number from the user;
    INPUT_NUMBER proc near
        mov CX, 00h
        mov DI, offset NUMBER
        
        
        mov BX, 0
        getNumber:
        mov AH, 01h ;Grabs the number storing count in BX, DI pointing to number
        int 21h      
        
        cmp AL, 0Dh    ; see if the user hits Enter or 'q'/ 'Q'
        jz returnNumber
        cmp AL, 'Q'
        jz EXIT     
        cmp AL, 'q'  
        jz EXIT
        
        mov [DI], AL
        inc DI
        inc BX 
        jmp getNumber
        
        returnNumber:
        ret
        
    INPUT_NUMBER endp
     
    ; Convert from ASCII to Binary ;             
    CONV_ASC2BIN proc near
        
    mov SI,offset NUMBER
    
    mov CX,9
    ;MOVING ALL NUMBER TO DECIMAL
    Here:
        sub [SI],30H
        inc SI
    loop Here ;END CONVERSION TO BINARY
    
     
    
    ; CREATE TABLE FROM 10^0 TO 10^9
    mov CX,8
    
    mov BX,10d
    mov AX,01 
    mov DX,0 
    push DX
    push AX
    
    Table:
        mul BX
        push DX
        push AX
    loop table 
    
    ;FIXING THE MSB FROM TABLE
    mov CX,8 
    add SP,34d
    
    FIX_MSB:
    
        pop AX
        mul BL
        sub SP,6
        pop DX
        add AX,DX
        push AX
    
    
    loop FIX_MSB ;END CREATE TABLE/FIXING
    sub SP,2
    
    ;BEGINING MULTIPLICATION AND MOVING DESTINATION
    mov SI,offset NUMBER
    clc
    pushf
    
    Here2:
    
        mov AX,[SI]
        and AX,0Fh
        popf
        pop BX
        pushf
        mul BX
        mov CX,DX
        popf
        adc [DI+3],AL 
        adc [DI+2],AH 
        pushf
        
        
        mov AX,[SI]
        and AX,0Fh  
        
        popf
        pop BX
        pushf
        
        mul BX
        add CX,DX
        add AX,CX
        popf
        adc [DI+1],AL 
        adc [DI],AH
        pushf 
        inc SI
        mov AX,offset number+9
        cmp SI,AX
    
    jnz HERE2
    popf
    ret

    CONV_ASC2BIN endp
  
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
    
    ADD_A_B proc near 
        
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
    
    ret
    
    ADD_A_B endp 

    AminuB proc near
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
    
    AminuB endp

    
       
    EXIT proc near
        ; Exit the program
        mov AH, 4Ch
        int 21h    
        ret
    EXIT endp
    
    

        
        
        
        
        
        
        
    
    
    
    
    
ends

    
end main



        




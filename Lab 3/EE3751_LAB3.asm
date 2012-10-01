data segment      
    
AGREETING db 0Dh, 'Enter A:$'
BGREETING db 0Ah, 'Enter B:$'
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
        
        mov AX, data
        mov DS, ax
        mov ES, ax    
        
        call Retrieve_A 
        call Retrieve_B
        
        
        call EXIT
        
        
        
        
    main endp
    
    ;Special call for retrieving A, converting it then returning it;
    Retrieve_A proc near:
        
                      
        mov AH, 9h              
        mov DX, offset AGREETING ;set DX to the address of A Messae
        int 21h       
        
        call INPUT_NUMBER 
        call CONV_ASC2BIN 
         
        lea SI, A
        call TRANSFER_TO_NUM
        call Erase_Variables
        ret
        
    Retrieve_A endp 
    
    
    ;Special call for retrieving B, converting it then returning it;
    Retrieve_B proc near:
        
        
        mov AH, 09h
        mov DX, offset BGREETING ; set DX to the address of B Message
            
        
        int 21h
        call INPUT_NUMBER
        call CONV_ASC2BIN 
        
        lea SI, B 
        call TRANSFER_TO_NUM
        ;call Erase_Variables
        ret    
        
    
    
    Retrieve_B endp

    ;Grab the number from the user;
    INPUT_NUMBER proc near
        mov CX, 00h
        lea DI, NUMBER
        
        
        mov BX, 0
        getNumber:
        mov AH, 01h ;Grabs the number storing count in BX, SI pointing to number
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
        
        sub DI, BX
        
        mov CX, BX
        subtraction:
            sub [DI], 30h
            inc DI  
            
        loop subtraction
        
        sub DI, BX
        
        mov CX, BX 
        mov AX, 1h
        push AX
        timesTen:
            mul 10
        
        
        
        
        
        ;Multiply it by its scientific notation
        
        ret

    CONV_ASC2BIN endp
    
    ;Transfer the Number to its proper place already converted;
    TRANSFER_TO_NUM proc near
        
        sub DI, BX
        
        
        mov CX, BX
        
        transferral: 
            mov AX, [DI]
            mov [SI], AX 
            inc SI
            inc DI 
        loop transferral    
        
        
        
        
    TRANSFER_TO_NUM endp
    
    ; Erase all the variables ;
    Erase_Variables proc near
          
         mov CX, 11
         lea SI, Number
         clearNumber:
            mov [SI], 00h
            inc SI   
         loop clearNumber
         
        
    
    
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
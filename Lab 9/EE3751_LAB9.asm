
;start the robot program
#start=robot.exe#
#make_bin#
name "robot"

data segment 
    
    

ends

stack segment
    dw 128 dup(0)        
ends

code segment
    
    main proc far
    
        call MOVE_FORWARD
        call WAIT_TASK 
        call DO_NOTHING
        call WAIT_TASK
        
        call TURN_RIGHT
        call WAIT_TASK 
        call DO_NOTHING
        
        mov CX, 02h
        steptwo:
            call MOVE_FORWARD
            call WAIT_TASK
            call DO_NOTHING
            call WAIT_TASK
        loop steptwo 

        
        call TURN_RIGHT
        call WAIT_TASK
        call DO_NOTHING
        call WAIT_TASK
        
        call MOVE_FORWARD
        call WAIT_TASK
        call DO_NOTHING
        call WAIT_TASK
        
        call TURN_LEFT
        call WAIT_TASK
        call DO_NOTHING
        call WAIT_TASK
        
        call SWITCH_ON_LAMP
        call WAIT_TASK
        call DO_NOTHING
        call WAIT_TASK
        
        call TURN_RIGHT
        call WAIT_TASK
        call DO_NOTHING
        call WAIT_TASK
                
        mov CX,05h
        stepfive:
            call MOVE_FORWARD
            call WAIT_TASK
            call DO_NOTHING
            call WAIT_TASK
        loop stepfive
        
        call TURN_RIGHT
        call WAIT_TASK
        call DO_NOTHING
        call WAIT_TASK
        
        mov CX,03h
        stepthree:    
            call MOVE_FORWARD
            call WAIT_TASK
            call DO_NOTHING
            call WAIT_TASK
        loop stepthree
        
        call SWITCH_ON_LAMP
        call DO_NOTHING
        call WAIT_TASK        
            
            
            
            
        
        jmp EXIT
        ret
        
    main endp
    
    ;Data register reading goes here.
    READ_SENSOR proc near 
        call CLEAR
        mov DX, 0Ah
        IN AX, DX 
        ret   
    READ_SENSOR endp
        
    ;Read the status of the robot
    READ_STATUS proc near
        call CLEAR    
        mov DX,0Bh
        IN AX, DX
        ret    
    READ_STATUS endp
    
    ;Command Functions go here. 
    DO_NOTHING proc near
        call CLEAR
        mov DX,09h
        mov AX,00h
        OUT DX,AX
        ret
    DO_NOTHING endp
    
    MOVE_FORWARD proc near
        call CLEAR
        mov DX,09h 
        mov AX,01h
        OUT DX, AX
        ret       
    MOVE_FORWARD endp
    
    TURN_LEFT proc near 
        call CLEAR
        mov DX,09h
        mov AX,02h
        OUT DX, AX
        ret    
    TURN_LEFT endp
    
    TURN_RIGHT proc near
        call CLEAR
        mov DX,09h
        mov AX,03h
        OUT DX,AX
        ret    
    TURN_RIGHT endp
    
    GET_SENSOR proc near
        call CLEAR
        mov DX,09h
        mov AX,04h
        OUT DX,AX  ;Will set bit#0 of status register to 1 when done.
        ret     
    GET_SENSOR endp
    
    SWITCH_ON_LAMP proc near
        call CLEAR
        mov DX,09h
        mov AX,05h
        OUT DX,AX
        ret              
    SWITCH_ON_LAMP endp
    
    SWITCH_OFF_LAMP proc near
        call CLEAR
        mov DX,09h
        mov AX,06h
        OUT DX,AX
        ret    
    SWITCH_OFF_LAMP endp
    
    WAIT_TASK proc near
        
        robot_not_ready:
            call READ_STATUS  
            AND AX,02h 
            cmp AX,00h
            jz returnWait
            jnz robot_not_ready
        returnWait:
        ret    
        
    WAIT_TASK endp 
    
    DATA_WAITING_TASK proc near
        call READ_STATUS
        AND AX, 01h
        cmp AX,00h
        ret
    DATA_WAITING_TASK endp
    
    CLEAR proc near
        mov AX,00h
        mov DX,00h
        ret
    CLEAR endp
        
     
    EXIT proc near ; Exit the program
        mov AH, 4Ch
        int 21h    
        ret
    EXIT endp
        
ends


end main

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
    
      call GET_OBJECT_TASK

      ret
    main endp
    
    ;Data register reading goes here.
    READ_SENSOR proc near
        call DO_NOTHING 
        call COMMAND_WAIT   
        mov DX,09h   ;;;;;;;;;Use the examime command
        mov AX,04h
        OUT DX, AX
        
        call COMMAND_WAIT
        call GET_DATA_WAIT
        
        mov DX, 0Ah  
        mov AX, 00h
        IN AX, DX 
        ret   
    READ_SENSOR endp
        
    COMMAND_WAIT proc near 
        mov DX, 0Bh 
        mov AL, 00h
        commandPortBusy:
            IN AL, DX
            and AL, 02h
            cmp AL, 00h 
            jnz commandPortBusy 
        ret
    COMMAND_WAIT endp 
    
    DO_NOTHING proc near 
        call COMMAND_WAIT
        mov DX,09h
        mov AX,00h
        OUT DX,AX
        ret
    DO_NOTHING endp
    
    GET_DATA_WAIT proc near
        mov DX, 0Bh   
        datanotready:
            IN AX, DX
            and AX, 01h ; This will mask the other bits. 0 means no new data, 1 means new data waiting.   
            cmp AL, 00h
            jz datanotready 
        ret
    GET_DATA_WAIT endp
    
    MOVE_FORWARD proc near  
        startMove:
        
            call DO_NOTHING 
            call COMMAND_WAIT
            mov DX,09h 
            mov AX,01h
            OUT DX, AX 
            
            call ERROR_CHECK 
            cmp AX, 00h
            
            jz moveCompleted
            jnz startMove 
            
        moveCompleted:     
        
        ret       
    MOVE_FORWARD endp
    
    TURN_LEFT proc near 
        startLeftTurn: 
        
            call DO_NOTHING
            call COMMAND_WAIT 
            mov DX,09h
            mov AX,02h
            OUT DX, AX
            
            call ERROR_CHECK
            cmp AX, 00h
            
            jz leftTurnCompleted
            jnz startLeftTurn  
        
        leftTurnCompleted:
            ret    
    TURN_LEFT endp
    
    TURN_RIGHT proc near 
        startRightTurn: 
        
            call DO_NOTHING
            call COMMAND_WAIT
            mov DX,09h
            mov AX,03h
            OUT DX,AX 
            
            call ERROR_CHECK
            cmp AX, 00h
            
            jz rightTurnCompleted 
            jnz startRightTurn  
            
        rightTurnCompleted:
             ret    
    TURN_RIGHT endp
    
    SWITCH_ON_LAMP proc near
        startSwitchOnLamp:
        
            call DO_NOTHING
            call COMMAND_WAIT
            mov DX,09h
            mov AX,05h
            OUT DX,AX         
            
            call ERROR_CHECK
            cmp AX, 00h
            
            jz switchOnLampCompleted  
            jnz startSwitchOnLamp 
            
        switchOnLampCompleted:
            ret              
    SWITCH_ON_LAMP endp
    
    SWITCH_OFF_LAMP proc near
        startSwitchOffLamp:
            call DO_NOTHING
            call COMMAND_WAIT
            mov DX,09h
            mov AX,06h
            OUT DX,AX 
            
            call ERROR_CHECK
            cmp AX, 00h
            
            jz switchOffLampCompleted 
            jnz startSwitchOffLamp 
            
        switchOffLampCompleted:
            ret    
    SWITCH_OFF_LAMP endp 
    
    ERROR_CHECK proc near 
        mov DX, 0Bh  
        IN AL, DX
        and AL, 04h    
        cmp AL, 00h
        
        jz noerror
        jnz error
        
        noerror:
            mov AX, 00h 
            ret
        
        error:
            mov AX, 01h 
            ret    
        
    ERROR_CHECK endp
    
    GET_OBJECT_TASK proc near
        
        restart:
            
        
        ;We first scan in every direction to check for out lamp, then move if we cant find it.
        scan:  
            ;;;;;;;;;;;;;;;;;;;;;Scan from LEFT to RIGHT  
            ;;;;START FROM LEFT
            call TURN_LEFT  
            
            call READ_SENSOR 
            
            call IS_LAMP     
            
            ;;This will make us look at middle
            call TURN_RIGHT
                               
            call READ_SENSOR
            
            call IS_LAMP
            
            ;;;This will make us look at very right
            call TURN_RIGHT
            
            call READ_SENSOR
            
            call IS_LAMP
            
            cmp AL, 00h
            jz proceed 
        
        action:
            ;;;;;;;;;;;;;;We will now make priority going forward right, then middle, then left.
            ;;;This will turn us back to middle.
            call TURN_LEFT      
            
            call READ_SENSOR
            
            cmp AL, 00h
            jz proceed
            jnz action
            
            ;;;;;;;;;;;;;;WE SHOULD NEVER MAKE IT TO THIS INBETWEEN POINT
            jmp EXIT

        proceed:  
            call MOVE_FORWARD
            jmp restart  
        
    GET_OBJECT_TASK endp 
    
    IS_LAMP proc near
        cmp AL, 08h
        
        jz islamp    ;Is it the lamp we want
        jnz notlamp
        
        islamp: 
            call SWITCH_ON_LAMP
            jmp EXIT
        
        notlamp:
        ret
    IS_LAMP endp      

    EXIT proc near ; Exit the program
        mov AH, 4Ch
        int 21h    
        ret
    EXIT endp
        
ends


end main
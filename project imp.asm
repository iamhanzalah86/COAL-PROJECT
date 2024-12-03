
.model large

.stack 100h

.data

hp db 100

ophp dw 50

str db 12

end db 12

opstr db 9

opend db 8

choice db ? 

att db ?

opatt db ? 

half db 2

min db ? 

attk db 'WHAT WOULD YOU LIKE TO DO?',10,13, '1. FOR ATTACK',10,13,'2. FOR SKILL',10,13, '$'

helaeddd db 'YOURE FULL HEALED !! ',10,13,'$'

poisoneed db 'YOU HAVE  POISONED THE ENEMY!!!$' 

pois db ?  

cond db 'CHOOSE YOUR SKILSS ',10,13,'1. FOR HEAL ',10,13,'2. FOR POISON',10,13,'$'

turncount db 0  

enemyy db 'THE ENEMEY ATTACKED ',10,13,'$' 

ois db 'THE ENEMY WAS POISONED FOR 10 HP ',10, 13,'$' 

nexxtt db 'NEXT TURN',10,13,'$'

wolfff db 'YOU KILLED THE ENEMY ',10,13,'$'

readyy db  'WOLF SPOTTED',10,13,'$'

knighttt db 'YOU ENCOUNTERED THE KNIGHT ',10,13, '$'

wonnn db 'YOU WERE VICTORIOUS ',10,13,'$'

losstttt db 'YOU WERE SLAIN  ',10,13,'$'   

mianscreen db '                    *************************************',10,13, '                    *                                   *' ,10,13, '                    *           WELCOME TO THE          *'  ,10,13,  '                    *                GAME!              *'  ,10,13,                  '                    *                                   *'  ,10,13,                  '                    *************************************',10,13,'',10,13,'PRESS ANY NUMBER TO TO CONTINUE.....$'   
      
invalid db 'INVALID INPUT PLEASE PRESS 1 OR 2 :)', 10, 13, '$' 

SWORDD DB '             |> ',10,13,'            //_____________________',10,13,'<((((((((((|_/_/____//________/____/',10,13,'            \\    ',10,13,'             |>  $'

.code



main proc    

  mov ax, @data

  mov ds, ax
  

     
  
  LEA DX , mianscreen
  mov ah, 9
  int 21h 
  call nextline

  
  mov ah, 1
  int 21h
  
  
  mov dl,13
  mov ah, 2
  int 21h
   
turn:   ;next turn

  LEA DX, attk

  mov ah,9

  int 21h

 ; mov ah,1

  ;int 21h 
  ;mov choice,al
  
  ;call nextline

  

  ;cmp choice,'1'

  ;je attack

 

  ;cmp choice,'2'

 ;je skill 
 
 ; added thuis to check valid inputtt
 validate_choice:
    mov ah, 1           ; Read user input
    int 21h 
    mov choice, al      ; Store user choice
    
    call nextline
    
    cmp choice, '1'     ; Compare input with valid options
    je attack           ; Jump to "attack" if choice is '1'
    
    cmp choice, '2'
    je skill            ; Jump to "skill" if choice is '2'

    ; If input is invalid, prompt again
    LEA DX, invalid
    mov ah, 9
    int 21h
    call nextline
jmp validate_choice ; Loop back to prompt for input

  attack:
  
  LEA DX, SWORDD 
  mov ah, 9
  int 21h 
  
  call nextline

  call attack1  

  cmp ophp,1    

jl next

 jmp skip

  skill:

  call skillch 

  skip:

  cmp ophp,1      

jl next

lea dx , enemyy
mov ah, 9
int 21h

call nextline

call attack2 ;the enemy attacked you   

    

  cmp pois,0  

  jle nopois

  dec pois

  mov bx,10

  sub ophp,bx

    lea dx , ois
    mov ah, 9
    int 21h 
    call nextline
    ;idr likha aaye the enemy was poisoned for 5 hp

  nopois: 

cmp hp,1

jl lost


lea dx, nexxtt
mov ah, 9
int 21h

call nextline

;idr ke new turn

jmp turn

next:   

lea dx, wolfff
mov ah, 9
int 21h 

call nextline

;you killed the enemy now ready for the wolf

inc str

inc end

inc str

inc end

inc str

inc end

inc turncount 

cmp turncount,3

je boss

cmp turncount,3

jg won


call wolf

lea dx , readyy
mov ah, 9
int 21h
 
 call nextline

jmp turn:

boss:
    

call knight ;you encountered the knight
LEA DX, knighttt 
MOV AH, 9
INT 21H

call nextline

jmp turn

lost:

LEA DX, losstttt
MOV AH, 9
INT 21H  

call nextline

;idr ke you lost

jmp exitgame

won:;win screen ya you won
 
LEA DX, wonnn
MOV AH, 9
INT 21H 

call nextline
  

exitgame:    

 mov ah,4ch

 int 21h   

main endp


wolf proc

    mov bl,15

    mov opstr,bl

    mov bl,17                                            

    mov opend,bl

    mov bl,150

    mov al,bl                            

    mov ah,0

    mov ophp,ax   

    ret

    wolf endp

attack1 proc

    mov bl,1

    add bl,str
               mov ah,0
    mov al,opend

    div half

    mov al,min

    sub bl,min

    mov att,bl

    sub ophp,bx

    

    ret

    attack1 endp

skillch proc

  


    LEA DX,cond

    mov ah,9

    int 21h
    
    call nextline
    

    ;mov ah, 1

   ;int 21h
    
    

    ;cmp al, '2'

   ;je poiison  
   
   ; added thuis to check valid inputtt

     validate_skill_choice:
    mov ah, 1
    int 21h
    mov choice, al

    cmp choice, '1'
    je heall

    cmp choice, '2'
    je poiison

    LEA DX, invalid
    mov ah, 9
    int 21h
    call nextline
    jmp validate_skill_choice
    
    heall:
    call heal

    jmp return

    poiison: 

    call poison

      return:
     call nextline      
              
    ret

    skillch endp 

attack2 proc

    mov bl,1

    add bl,opstr

    mov al,0

    mov ah,0   

    mov al,end

    div half

    mov al,min

    sub bl,min

    sub hp,bl

    mov opatt,bl


    ret
    attack2 endp    

heal proc
   

    cmp hp,100 

    je healed  
    

    mov bl,30

    add bl,end


    add hp, bl
    

       cmp hp,100

       jge overhealed 

    healed:

    LEA DX, helaeddd


    mov ah, 9

    int 21h 
    
    call nextline

    jmp return1 

    overhealed:

    mov bl,100


    mov hp,bl 


    jmp healed 

    return1:

    ret 

    heal endp

poison proc
       LEA DX,poisoneed
       mov ah, 9
       int 21h
       
       call nextline
       
       mov pois, 3
        ret
    poison endp
knight proc
    mov bl,25
    mov opstr,bl
    mov bl,30
    mov opend,bl
    mov bl,255
    mov ophp,bx
    
    ret
    knight endp 

nextline proc
    mov dl, 10
    mov ah, 2
    int 21h  
    
         
    mov dl, 10
    mov ah, 2
    int 21h 
    
    ret
    
    nextline endp 

    
       
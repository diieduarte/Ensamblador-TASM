;****************Macro que imprime una cadena**********
impCad macro arg1
    mov ah,09
    lea dx,arg1
    int 21h
endm 

;*****************Imprime un enter*********************
enter macro 
    mov ah,02
    mov dl,13
    int 21h
    mov dl,10
    int 21h
endm

.model small
.stack 64
.data
;******** DECLARAMOS VARIABLES ************************************************
                    
    msj db 13,10,9,7,"Ingresa una cadena y la pongo alreves MAX[100]",13,10,"$"  
    errorMsj db 13,10,9,7,"Error: La cadena que ingresaste, esta vacia!",13,10,"$"
    cad db 100,?,102 dup("$")
    cadNew db 100,?,102 dup("$")
.code

    mov ax,data
    mov ds,ax
    mov es,ax 
    ;********* SOLO POR ESTETICA CAMBIAMOS EL COLOR DE LAS LETRAS A VERDE ****************
    mov ah,06 
    mov al,0
    mov bh,0ah
    mov cx,0
    mov dx,184ch
    int 10h 
    

    
    inicio: 
        impCad msj              ;Imprimimos el mensaje principal
        enter                   ;Hacemos enter para separar las lineas
        
        mov ah,0ah              ;Pedimos una cadena al usuario con la funcion 0ah
        lea dx,cad              ;Y la guardamos en la variable cad 
        int 21h                                                    
         
;************ COMPROBAMOS QUE LA CADENA NO ESTE VACIA ******************* 
          
        mov al,byte ptr[cad+1] ;movemos el total de caracteres a al
        cmp al,0               ;comparamos si al es igual a cero
        je error               ;llamamos al error y repetimos el procedimiento
        
;*************** PROCEDIMIENTO PARA INVERTIR LA CADENA ***************************
        
        lea di,cadNew           ;Cargamos La cadena vacia a DI para trabajarla con STOSB
        mov ch,0                ;Formateamos ch a cero para no tener problemas con el contador
        mov cl,byte ptr[cad+1]  ;Movemos al contador el total de caracteres de la cadena que ingreso el usuario(1Byte = tamano de cadena,2Byte = Total de caracteres) 
                                ;Se suman 2 bytes ya que los primeros 2 bytes (0 y 1) estan ocupados con informacion de la cadena
        invertir:               ;Empieza el bucle que invertira la cadena
            mov si,cx           ;Movemos el valor del contador a SI para usarlo de indice y acceder al ultimo valor de la cadena
            mov al,cad[si+1]    ;Copiamos el ultimo valor de la cadena(sumamos 1 por los 2 bytes de informacion de la cadena que estan ocupados)
            stosb               ;Movemos lo que hay en AL a DI, incrementando el DI en 1
        loop invertir           ;Repetimos el procedimiento
                                
        enter                   ;Hacemos 2 enters para separar el resultado
        enter
        
        impCad cadNew           ;Imprimimos la nueva cadena  
        jmp fin
        
        error:    
            impCad errorMsj      ;Imprimimos un error cuando la cadena 
            mov ah,0             ;Esta vacia
            int 16h 
        jmp inicio
        
        fin:
            mov ah,0
            int 16h                 ;Equivalente a un SYSTEM PAUSE
.exit    
end                                 ;fin del programa



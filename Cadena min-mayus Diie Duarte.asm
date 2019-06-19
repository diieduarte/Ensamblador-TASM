;Macro que imprime una cadena con la funcion 09h de la int 21h
impCadena macro arg1
    mov ah,09
    lea dx,arg1
    int 21h
endm
;MACRO QUE IMPRIME UN CARACTER
impChar macro arg1
    mov ah,02
    mov dl,arg1
    int 21h
endm
.model small
.stack
.data    
;Variables usadas en el programa

msj       db 13,10,7,"Ingresa una cadena en minusculas y la pongo en mayusculas MAX[100]",13,10,"$"
cadInput  db 100,?,102 dup("$")     
cadOutput db 100,?,102 dup("$")

.code                    

    mov ax,data
    mov ds,ax   
    mov es,ax
                 
    impCadena msj
    
    mov ah,0ah                  ;funcion que pide una cadena al usuario
    lea dx,cadInput             ;y la almacena en una variable (cadinput
    int 21h

    mov cl,byte ptr[cadInput+1]      ;Con un puntero apuntamos a la posicion 2 de la variable
    mov ch,0                    ;que ahi se encuentra el total de caracteres ingresados
                                ;Ponemos  en ch,0 para que exista solo el numero de caracteres
                                ;que existen en la cadena
                            
                            
    lea si,cadInput+2                ;Cargamos a SI la cadena omitiendo los primero 2 bytes(tamano de cadena y total de caracteres bytes 1 y 2)
    lea di,cadOutput                 ;Cargamos la nueva cadena en blanco para rellenarla
    
    convierteMayus:             ;Operacion que convertira a mayusculas
        lodsb                   ;Cargamos el primer caracter(byte) a AL con la instruccion LODSB
        and al,11011111b        ;Hacemos un AND para convertirla a mayusculas
        stosb                   ;Guardamos en DI lo que hay en AL con la instruccion STOSB 
    loop convierteMayus         ;repetimos hasta que CX=0
    
    ;LAS INSTRUCCIONES LODSB INCREMENTA EL SI EN 1 Y STOSB INCREMENTA EL DI EN 1, POR LO QUE NO
    ;ES NECESARIO INCREMENTARLO NOSOTROS PARA QUE GUARDE LOS CARACTERES EN LA POSICION QUE CORRESPONDE
    
    ;Imprimos la nueva cadena
    
    impChar 13
    impChar 10
    impChar 13                  ;Imprimimos 2 enters
    impChar 10  
    
                                
    impCadena cadOutput         ;Imprimimos la cadena ya en mayusculas
    mov ah,0
    int 16h


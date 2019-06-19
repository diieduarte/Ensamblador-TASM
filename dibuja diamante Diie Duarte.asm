enter macro
    mov ah,02
    mov dl,13
    int 21h  
    mov dl,10
    int 21h
endm       
imprimec macro arg1
    mov ah,02
    mov dl,arg1
    int 21h
endm
imprimeVol macro arg1,arg2
    mov ah,0ah
    mov al,arg1
    mov bh,0
    mov cl,arg2
    int 10h
endm  

guarda macro arg1,arg2  
    mov al,arg1
    add al,arg2
    mov arg2,al
endm 

formateo macro arg1,arg2,arg3 

;Guarda a la mitad1 (arg1) el Total de las filas(arg3) menos2
;ya que este es la primera mitad de la mitad inferior
;y como esta va de forma inversa, escribiendo de mayor a menor
;sumada con la mitad2 (arg2) el total de las filas(arg3) menos1
;nos da el total de caracteres de la fila en donde se encuentra
;ejemplo el triangulo es de 10 filas, la primera fila de la mitad
;inferior corresponde a 10 - 2 = 8 (1 mitad de la mitad inferior) + 10 - 1 = 9
;el total seria 17 caracteres e iria decrementando hasta llegar a 1 formando la sig forma
;*****
; ***
;  *   ;se le resta 1 a la primera mitad ya que el mismo concepto que la mitad superior
       ;la siguiente fila seria en este caso de 9 ya que en teoria la fila 10 ya esta impresa
       ;estamos tomando el ejemplo de arriba,entonces debemos imprimir la 8 y por eso restamos 1
       ;para que los caracteres (9) formen la primera cara y a la segunda mitad le restamos 2 por lo siguiente:
       ;como siempre la segunda mitad es la primera mitad -1 si aplicamos este concepto para
       ;la segunda mitad obtenemos 9 pero 9 ya lo tenemos es la primera cara y no aplica la segunda mitad es la primera mitad -1 
       ;entonces tenemos que restarlo otravez 1 para que nos de 8 y vemos que ahora si aplica la segunda mitad = a la primer -1
       ;osea en este caso tenemos que la primera es 9 - 1 = 8 si se cumple 
       
    mov ax,arg3
    sub al,2
    mov arg1,al
    
    mov ax,arg3
    sub al,1
    mov arg2,al 
endm  

mensaje macro arg1
    mov ah,09
    lea dx,arg1
    int 21h
endm         

recibec macro
    mov ah,01
    int 21h   
    mov ah,0
    sub al,30h
endm 

limpant macro    
    ;Se puede sustituir po la funciion de posicion de abajo
    ;que posiciona el cursor
    comment *
    mov ah,0   
    mov al,03h
    int 10h 
    mov ah,0fh
    int 10h *
    ;****** ESTE BORRA LA PANTALLA**************** 
    ;Todas son indispensables para el borrado de pantalla sin errores
    
    ;Paso 1 Posiciona el cero para que inicie otra vez el programa en la posicion inicial
    mov ah,02
    mov bh,0
    mov dx,0
    int 10h
    
    ;Rellena todo el CMD con 0 (Nulo) para que no haya caracteres basura
    mov ah,09
    mov al,0
    mov bh,0
    mov cx,0720h
    int 10h  
    
    ;Hace un borrado de las lineas con efecto de arriba hacia abajo con un color de atributo
    ;y en todo el cmd unicamente borrando con el color mas no caracteres como la funcion de arriba
    mov ah,06
    mov bh,0ah
    mov cx,0000h
    mov dx,184ch
    int 10h
endm    

org 100h
jmp inicio short
.model small  
.stack 64
.data  

    filaparte2      dw 0    
    mitad1          db 0  
    mitad2          db 0 
    mitadCompleta   db 0 
    filasTotales    dw 0
    msjPrincipal    db 13,10,9,9,176,176,177,177,178,178," Bienvenidos al dibujador de Diamante ",178,178,177,177,176,176,13,10,"$"
    opcion          db 9,9,7,"   Escribe un n",163,"mero mayor a 2 y menor a 38: $"
    menumsj         db 13,10,9,9,7,"     Deseas Salir del programa? SI(1),NO(0) $" 
    errormsj        db 13,10,7,"Existe un error! No estas dentro del rango o no es un caracter v",160,"lido",13,10,"$"        
    despedidaMsj    db 13,10,"¡¡¡¡Gracias por utilizar el programa, hasta pronto!!!!",13,10,"$"
    instruccion     db 7,"Presione cualquier tecla para continuar.......",13,10,"$" 

.code 

    inicio: 
    
        limpant            
        mov ax,@data
        mov ds,ax
        
        mensaje msjPrincipal
        mensaje opcion 

;****************** FORMATEAMOS A 2 NUMEROS
    
        recibec      
        mov filasTotales,ax
        
        recibec  
        cmp al,0ddh
        je validarPrimero
        
 
        continuar:
            
            push ax
            mov ax,filasTotales
            mov bl,0ah
            mul bl
            pop bx
            add al,bl
            mov ah,0
            cbw
            mov filasTotales,ax
            cmp al,26h
            ja error 
            jmp procedimiento
            
        validarPrimero: 
            mov ax,filasTotales
            cmp al,2 ;si pusieramos 1 no causaria error, ya que la comparacion entre la fila y la columna de la mitad 2 no coinciden y como es 1 el contador el bucle de diamante 2 no se repite
            jb error ;pero si lograra imprimirlo causaria error, ya que la resta de las mitades da negativo, porque el limite es 2 
             
    procedimiento: 
  
;**************************** MITAD ARRIBA 1 ******************************* 
        enter
        enter               ;Algunos enters  para saltar los mensajes principales
        mov cx,filasTotales ;El total de filas que tendra el diamante * 2 (Esta corresponde a la mitad 1)  
        mov mitad1,1 ;variable que sirve para calcular la primera mitad superior del Diamante   
        mov mitad2,0 ;variable que sirve para calcular la segunda mitad superior del Diamante
        
        diamanteParte1:
            push cx  ;guardamos nuestro contador Primario (Filas)
            part1:  
                mov mitadCompleta,0 ;Movemos el total de Caracteres de la fila del Diamante 
                push cx             ;Guardamos nuestro contador secundario (columnas) 
                mov al,cl           ;Comparamos con 1 para que escriba en la ultima posicion
                cmp al,1            ;esta se ira recorriendo hacia la izquierda conforme se valla
                jbe imprimir1       ;decrementando el contador y formado el efecto de escalera
                jmp hueco1    
                imprimir1: 
                    guarda mitad1,mitadCompleta ;Sumamos el total de caracteres de la primera mitad
                    guarda mitad2,mitadCompleta ;Sumamos la mitad1 mas la mitad1-1(ya que esta cantidad siempre es la que falta para hacer el espejo
                    imprimeVol '*', mitadCompleta ;Imprimimos el total de caracteres de la mitad superios del diamante y haria la siguiente forma
                    ;  *
                    ; ***
                    ;*****
                    enter 
                    jmp final1
                hueco1: 
                    imprimec ' ' ;En caso de que no se encuentre en la primera posicion imprimimos un espacio para dar la forma 
                final1:
                    pop cx       ;Recuperamos nuestro contador secundario de las columnas
            loop part1           ;Repetimos hasta llenar todas las columnas de la mitad superior del diamante
            pop cx               ;Recuperamos nuestro contador principal de las filas
            inc mitad1           ;Incrementamos nuestra primera mitad del diamante para pasar a la siguiente fila
            inc mitad2           ;Incrementamos nuestra segunda mitad del diamante para pasar a la siguiente fila
        loop diamanteParte1      ;Y repetimos hasta llenar todas las filas de la mitad superior del diamante
        
;********************************* MITAD 2 ******************************************** 
        
        mov cx,filasTotales      ;El total de filas que tendra el diamante * 2 (Esta corresponde a la mitad 1)   
        mov si,0                 ;Haremos uso del si para incrementar la posicion de la columna(espacios que debera Recorrer hasta imprimir el caracter Tipo Escalera)
        mov filaparte2,1         ;La posicion de la fila esta debe coincidir con la columna para hacer efecto escalera o la forma del borde del diamante
        formateo mitad1,mitad2,filasTotales
        
        diamanteParte2:
            push cx    
            mov cx,filasTotales   ;Movemos el total de las filas, ya que aqui si necesitamos la misma cantidad, ya que esas mismas que comparamos en cada fila
            part2: 
                mov mitadCompleta,0 ;formateamos la variable del total de caracteres en cada fila   
                push cx             ;guardamos contador secundario (columnas)
                cmp si,filaparte2   ;Comparamos si fila es igual a columna(asi se forma el efecto escalera o borde de diamante
                je imprimir2
                jmp hueco2    
                imprimir2:
                    guarda mitad1,mitadCompleta ;sumamos la mitad1
                    guarda mitad2,mitadCompleta ;Sumamos la mitad2
                    imprimeVol '*', mitadCompleta ;imprimos el total de caracteres correspondiente a esa fila
                    pop cx                        ;Sacamos nuestro coontador secundario para no perder el orden en la pila, ya que no lo necesitamos y lo estableceremos en cero para romper el bucle
                    mov cx,1                      ;Ponemo en 1 el contador para romper el ciclo, en la primera mitad no hicimos esto porque la impresion se realizaba al final del bucle cuando cx=1
                    jmp final2   
                hueco2:         
                    imprimec ' '                  ;ponemos espacio cada vez que no sea correcta
                    pop cx                        ;la comparacion de fila y columna
                    inc si    
                final2:        
            loop part2 
            enter                                 ;Incrementamos las Filas ya que este sera la referencia para compararlo con las columnas y escriba en la posicion correcta(De esta forma formamos las diagonal o efecto escalera)
            inc filaparte2                        ;Decrementamos la mitad1
            dec mitad1                            ;decrementamos la mitad2 para que al sumarlas sea menor la cantidad de caracteres(Recordemos que esta mitad esta en forma descendente
            dec mitad2                            ;Por lo tanto terminara imprimiendo un caracter
            mov si,0                              ;Recuperamos nuesto contador principal(filas)
            pop cx                                ;Repetimos el procedimiento de filas
        loop diamanteParte2  
        
;************************************* RETORNO AL INICO **************************
        
         mensaje menumsj
         recibec
         cmp al,1
         je salida
         cmp al,0
         je inicio
         jmp error
    

;***************************** SALIDA Y CONTROL DE ERRORES ****************************    

    error:
        limpant
        mensaje errormsj 
        mensaje instruccion
        mov ah,0
        int 16h
        jmp inicio
    
                 
    salida: 
        limpant
        mensaje despedidaMsj 
        mensaje instruccion               
        mov ah,0
        int 16h                
end

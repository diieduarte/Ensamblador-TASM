;MACRO QUE GUARDA EL NUMERO SEGUN SU POSICION EN LA TABLA
guardaenvariable macro arg1,arg2 
    
    local extraerdatos,guardadatos
    mov cx,arg1    ;contador recibido de la variable arg1
    xor dx,dx      ;Limpiamos registros DX para evitar problemas a la division
    
    extraerdatos:
    div diez       ;Dividimos entre 10 para extraer el primer numero que se almacena el DX(Residuo)
    mov dh,0       ;Formateamos dh con 0 para despues guardar DX
    push dx        ;Guardamos DX en la pila 
    xor dx,dx      ;nuevamente limpiamos el registro para evitar problemas en la division
    loop extraerdatos ;Repetimos el proceso hasta N veces (Valor dado por el contador)
    
    mov si,0       ;Usamos SI como indice y acceder a cada posicion de la variable arg2
    mov cx,arg1    ;contador recibido de la variable arg1
    guardadatos:   ;Loop que sacara los datos de la pila y los almacenara en una variable
    pop dx         ;Sacamos el ultimo dato de la pila
    mov arg2[si],dl;Guardamos en la variable el valor de Dl
    xor dx,dx      ;Limpiamos el registro DX para nuevamente copiar el nuevo valor extraido de la pila
    inc si         ;Incrementamos SI (Indice) para seguir guardando en la misma variable
    loop guardadatos 
      
endm 
;MACRO QUE GUARDA LA SUMA DIGITO A DIGITO EN LA POSICION CORRECTA DESPUES DE LA OPERACION
sumaresultadomulti macro arg1
   local suma,etvar1,etvar2,etvar3,etvar4
    mov cx,arg1 ;Contador recibido en la macro en arg1 
    mov ax,0    ;Formateamos AX
    mov si,7    ;Movemos 7 al si que es el numero de ceros que hay en una mutiplicacion de 16 bits (2numeros + 2 decimas)
    suma:       ;Iniciamos la suma posicion a posicion como en una multiplicacion comun 
    xor ax,ax   ;Limpiamos el registro AX
    etvar1:     ;Etiqueta que hace referencia a los digitos que recorrera
                ;Como son 4 operaciones se estara recorriendo 4 posicion a la izquierda 00000000
                ;por cada suma realizada ejemplo ----------------------->>>            00000000
                                                                                     ;00000000
                ;12.12                                                               0000000
                ;12.12
                ;-----
               ;02424 -etvar1
              ;012120  -etvar2
             ;0242400 -etvar3
            ;01212000 -etvar4
           ;----------  
           ;000000000  
           ;--   ----
           ;^      ^
      ;Acarreos  Posiciones recorridas
      ; 
    cmp cl,3    
    jbe etvar2
    push si   ;Decrementamos hasta que quede en 4 que es donde se encuentra el primero numero (4)
    dec si    ;de la var1 y sumarlo a AL que ahi se guardara el resultado
    dec si    ;para guardarlo despues en la variable final
    dec si
    add al,var1[si] ;Aca hacemos la suma cuando si corresponda a la primera posicion
    pop si          ;del primer resultado de etvar 1 y asi sucesivamente
    etvar2:
    cmp cl,2        ;Cuando valga menos de 3 ya no se decrementa si
    jbe etvar3      ;porque ya no se tiene que recorrer ninguna posicion
    push si         ;para realizar las sumas sino que ya se hacen directas
    dec si          ;para las 2 ultimas filas de la operacion de multiplicacion
    dec si
    add al,var2[si] 
    pop si
    etvar3:
    cmp cl,1
    jbe etvar4
    push si
    dec si
    add al,var3[si] 
    pop si
    etvar4:
    add al,var4[si]
    add al,acarreo
    aam  
    mov varr[si],al
    mov acarreo,ah 
    dec si
    loop suma 
    sub punto,30h
    
    ;Aca solo movemos a cada variable el numero que 
    ;le corresponde de la variable VARR del resultado final de las 
    ;sumas
    mov al,varr[0]
    mov acarreo2,al
    mov al,varr[1]
    mov acarreo,al
    mov al,varr[2]
    mov decena,al
    mov al,varr[3]
    mov unidad,al
    mov al,varr[4]
    mov decima1,al
    mov al,varr[5]
    mov decima2,al
    mov al,varr[6]
    mov decima4,al
    mov al,varr[7]
    mov decima4,al
 
endm
;MACRO PARA IMPRIMIR UN CARACTER
imprimec macro arg1
    mov ah,02
    mov dl,arg1
    add dl,30h
    int 21h
endm

.model small
.stack 64
.data  

;VARIABLES A UTILIZAR
mensaje  db 13,10,'El resultado'
         db 13,10,'                  12.12  '
         db 13,10,'del siguiente   x        '
         db 13,10,'                  12.12  '
         db 13,10,'producto es:    _________'
         db 13,10,'                         '
         db 13,10,'               $'
var1     db       0,0,0,0,0
var2     db     0,0,0,0,0,0
var3     db   0,0,0,0,0,0,0
var4     db 0,0,0,0,0,0,0,0
varr     db 0,0,0,0,0,0,0,0 
punto    db '.'
decena   db 0
unidad   db 0
decima1  db 0
decima2  db 0
decima3  db 0
decima4  db 0
acarreo  db 0
acarreo2 db 0
diez     dw 10
contador dw ?
.code

inicio:
mov ax,data
mov ds,ax 
mov ax,1212
mov bx,2 
push ax
mul bx
mov contador,5
guardaenvariable contador,var1
pop ax
push ax 
mov bx,1
mul bx
guardaenvariable contador,var2
pop ax
push ax 
mov bx,2
mul bx
guardaenvariable contador,var3
pop ax
mov bx,1
mul bx
guardaenvariable contador,var4
mov contador,8 
sumaresultadomulti contador

mov ah,09
lea dx,mensaje
int 21h
;Imprimimos Acarreo2 que corresponde a un numero de 4 digitos mas 4 decimales
;Esto es cuando la operacion es mayor a 999.999
;imprimec acarreo2
imprimec acarreo
imprimec decena
imprimec unidad 
imprimec punto
imprimec decima1
imprimec decima2
imprimec decima3
imprimec decima4

salir:
mov ah,4ch
int 21h    

end inicio

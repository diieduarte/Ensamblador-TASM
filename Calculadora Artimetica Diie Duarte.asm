;************************ DECLARAMOS LAS MACROS DEL PROGRAMA *********************************
;MACRO QUE NOS AYUDARA A IMPRIMIR CADENAS
imprime macro arg1                                                         ;Se declara la macro imprime que imprime cadenas
    mov ax,data                                                            ;Asigna la direccion de datos a AX 
    mov ds,ax                                                              ;y atraves de AX asigna la direccion de datos al DS
    mov es,ax                                                              ;y atraves de AX asigna la direccion de datos al ES
    lea dx, arg1                                                           ;Carga la direccion efectiva de la localidad de memoria representada por arg1(Cadena de caracteres) al DX
    mov ah,09                                                              ;Asigna la funcion 09(Visualizacion de una cadena de caracteres) a AH y
    int 21h                                                                ;con la interrupcion 21h aparace el mensaje en pantalla
endm                                                                       ;Fin de la macro
;MACRO QUE NOS AYUDARA A IMPRIMIR LOS CARACTERES
imprimecaracter macro arg1                                                 ;Se declara la macro imprimecaracter que imprime un caracter
    mov ah,02                                                              ;Asigna la funcion 02(Salida de caracter) a AH 
    mov dl,arg1                                                            ;Transfiere una copia del contenido almacenado en la localidad arg1 de la memoria y la pone en el registo DL
    int 21h                                                                ;y con int 21h manda imprime a pantalla un caracter
endm                                                                       ;Fin de la macro
;MACRO PARA RECIBIR UN CARACTER
recibecaracter macro                                                       ;Se declara la macro recibecaracter que leera un caracter por teclado
    mov ah,1                                                               ;Asigna la funcion 01(Entrada de caracter con salida a pantalla) a AH y
    int 21h                                                                ;con la int 21h que lee un caracter atraves del teclado
endm                                                                       ;Fin de la macro
;MACRO QUE NOS PREGUNTARA SI QUEREMOS CONTINUAR CON EL PROGRAMA    
regresamenu macro                                                          ;Se declara la macro regresa menu
    imprime continuar                                                      ;Llama a la macro imprime con el argumento continuar(Imprime la cadena continuar)
    recibecaracter                                                         ;Llama a la macro recibecaracter(lee un caracter del teclado con salida a pantalla)
    cmp al,'2'                                                             ;Compara el contenido de AL con '2' o 32h
    jz salir                                                               ;Salta si el contenido de AL es igual a '2' o 32h a la etiqueta salir
    cmp al,'1'                                                             ;Compara el contenido de AL con '1' o 31h
    jz inicio                                                              ;Salta si el contenido de AL es igual a '1' o 31h a la etiqueta inicio
    jmp error                                                              ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta error
endm                                                                       ;Fin de la macro
;MACRO QUE NOS AYUDARA A LIMPIAR LA PANTALLA
limpantalla macro                                                          ;Se declara la macro limppantalla
    mov ah,0fh                                                             ;Se mueve a ah la funcion 0F(Obtener modo de video)
    int 10h                                                                ;De la int 10h
    mov ah,0                                                               ;Se mueve a ah la funcion 0(Cambia el modo de video)
    int 10h                                                                ;De la int 10h y limpia la pantalla
endm                                                                       ;Fin de la macro
;MACRO QUE NOS CONVERTIRA LOS NUMEROS INGRESADOS A BCD PARA TRABAJARLOS EN LAS OPERACIONES
convertirbcd macro arg1,arg2,arg3,arg4                                     ;Declaramos la macro convertirbcd
    sub arg1,30h                                                           ;Restamos 30h al contenido almacenado en la localidad arg1 de la memoria
    sub arg2,30h                                                           ;Restamos 30h al contenido almacenado en la localidad arg2 de la memoria
    sub arg3,30h                                                           ;Restamos 30h al contenido almacenado en la localidad arg3 de la memoria
    sub arg4,30h                                                           ;Restamos 30h al contenido almacenado en la localidad arg4 de la memoria
endm                                                                       ;Fin de la macro
;MACRO QUE NOS CONVERTIRA LOS NUMEROS INGRESADOS A ASCII PARA SU FUTURA IMPRESION
convertirascii macro arg1,arg2,arg3,arg4                                   ;Declaramos la macro convertirascii
    add arg1,30h                                                           ;Sumamos 30h al contenido almacenado en la localidad arg1 de la memoria
    add arg2,30h                                                           ;Sumamos 30h al contenido almacenado en la localidad arg2 de la memoria
    add arg3,30h                                                           ;Sumamos 30h al contenido almacenado en la localidad arg3 de la memoria
    add arg4,30h                                                           ;Sumamos 30h al contenido almacenado en la localidad arg4 de la memoria
endm                                                                       ;Fin de la macro
;MACRO QUE NOS LIMPIARA LOS REGISTROS PARA EVITAR POSIBLE BASURA EN LAS OPERACIONES
limpiarregistros macro                                                     ;Declaramos la macro limpiarregistros
    xor ax,ax                                                              ;Realiza un XOR logico de los operandos AX y almacena el resultado en el operando destino
    xor bx,bx                                                              ;Realiza un XOR logico de los operandos BX almacena el resultado en el operando destino
    xor cx,cx                                                              ;Realiza un XOR logico de los operandos CX almacena el resultado en el operando destino
    xor dx,dx                                                              ;Realiza un XOR logico de los operandos DX almacena el resultado en el operando destino
endm                                                                       ;Fin de la macro
;MACRO QUE CAMBIA EL CONTENIDO ENTRE 2 VARIABLES EJ. DE VAR1 A VAR2 Y VICEVERSA
cambiarnumeros macro arg1, arg2                                            ;Declaramos la macro cambiar numeros
    mov al,arg1								                               ;Copia el contenido o byte de la localidad de memoria representado por arg1 al registro AL
    mov bl,arg2								                               ;Copia el contenido o byte de la localidad de memoria representado por arg2 al registro AL								   ;Copia el contenidp
    mov arg1,bl								                               ;Copia el contenido del registro BL a la localidad de memoria representada por arg1
    mov arg2,al								                               ;Copia el contenido del registro BL a la localidad de memoria representada por arg2       
endm									                                   ;Fin de la macro
;MACRO QUE FORMATEA EN 16BITS EL CONTENIDO DE LAS VARIABLES GUARDA RESULTADO EN BX SIEMPRE
formatea16bits macro arg1,arg2,arg3,arg4				                   ;Declaramos la macro formatea16bits con 4 argumentos
    mov al,arg1								                               ;Copiaamos el byte o contenido de la localidad arg1 de la memoria del ds al registro AL
    cbw									                                   ;Convierte el registro AL en palabra, y rellena la parte mas significativa con ceros
    mul multidiez							                               ;Multiplica el contenido de la localidad de memoria representado por multidiez por AX y el resultado se guarda en el registro AX
    mul multidiez                                                          ;Multiplica el contenido de la localidad de memoria representado por multidiez por AX y el resultado se guarda en el registro AX
    mul multidiez                                                          ;Multiplica el contenido de la localidad de memoria representado por multidiez por AX y el resultado se guarda en el registro AX
    mov bx,ax                                                              ;Copia el contenido del registro AX a BX
    mov al,arg2                                                            ;Copia el contenido o byte de la localidad arg2 de la memoria del DS al registro AL
    cbw                                                                    ;Convierte el registro AL en palabra, y rellena la parte mas significativa con ceros
    mul multidiez                                                          ;Multiplica el contenido de la localidad de memoria representado por multidiez por AX y el resultado se guarda en el registro AX
    mul multidiez                                                          ;Multiplica el contenido de la localidad de memoria representado por multidiez por AX y el resultado se guarda en el registro AX
    add bx,ax                                                              ;Suma el contenido del registro AX a BX 
    mov al,arg3                                                            ;Copia el contenido o byte de la localidad arg3 de la memoria del DS al registro AL
    cbw                                                                    ;Convierte el registro AL en palabra, y rellena la parte mas significativa con ceros
    mul multidiez                                                          ;Multiplica el contenido o palabra de la localidad de memoria representado por multidiez por AX y el resultado se guarda en el registro AX
    add al,arg4                                                            ;Suma el contenido o byte de la direccion de memoria representada por arg4 al registro BX 
    add bx,ax                                                              ;Suma el contenido o palabra del registro AX al registro BX
endm                                                                       ;Fin de la macro
;MACRO QUE GUARDA EL RESULTADO POR SEPARADO EN LA POSICION CORRECTA DEL VECTOR QUE SE LE INDIQUE
guardaenvariablemul macro arg1,arg2                                        ;Declaramos la macro guardavariablemul con 2 argumentos      
    local extraerdatos,guardadatos                                         ;Directiva local sirve para evitar duplicados en las etiquetas al invocar la macro dos veces el ensamblador no generara la etiqueta extraerdatos: sino las etiquetas ??0000, ??0001, ... y asi sucesivamente. 
    mov cx,arg1                                                            ;Copia el contenido o palabra de la localidad arg1 de la memoria del DS al registro CX
    xor dx,dx                                                              ;Realiza un XOR logico de los operandos DX,DX y almacena el resultado en el operando destino 
    
    extraerdatos:                                                          ;Etiqueta extraerdatos
    div multidiez                                                          ;Divide el contenido de la localidad de memoria representado por multidiez entre AX y el resultado se guarda en el registro AX y el residuo en DX
    mov dh,0                                                               ;Copia 0000h al registro DL
    push dx                                                                ;Guarda(Empuja) el contenido o palabra del registro DX en la pila y disminuye el SP en 2(bytes)
    xor dx,dx                                                              ;Realiza un XOR logico de los operandos DX,DX y almacena el resultado en el operando destino
    loop extraerdatos                                                      ;Repite el ciclo si CX es mayor que 0 y salta a la etiqueta extraerdatos y decrementa el registro CX(Contador)
    mov si,0                                                               ;Copia 0000h al registro SI
    mov cx,arg1                                                            ;Copia el contenido o palabra de la localidad de memoria representado por arg1 al registro CX 
                                                                
    guardadatos:                                                           ;Etiqueta guardadatos
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov arg2[si],dl                                                        ;Copia el contenido del registro DL a la direccion de memoria del DS representada por la suma de arg2 + SI
    xor dx,dx                                                              ;Realiza un XOR logico de los operandos DX,DX y almacena el resultado en el operando destino
    inc si                                                                 ;Incrementa el registro SI en 1
    loop guardadatos                                                       ;Repite el ciclo si CX es mayor que 0 y salta a la etiqueta guardadatos y decrementa el registro CX(Contador)
endm                                                                       ;Fin de la macro
;GUARDA LA SUMA DIGITO A DIGITO DE CADA VECTOR EN LA POSICION CORRECTA DEL VECTOR DE RESULTADO(VARR)
sumaresultadomulti macro arg1                                              ;Declaramos la macro sumaresultadomu con sus respectivos 4 argumentos
    local suma,etvar1,etvar2,etvar3,etvar4                                 ;Directiva local sirve para evitar duplicados en las etiquetas al invocar la macro dos veces el ensamblador no generara la etiqueta etvar1: sino las etiquetas ??0000, ??0001, ... y asi sucesivamente. 
    mov cx,arg1                                                            ;Copia el contenido o palabra de la direccion de memoria del DS representado por arg1 al registro CX
    mov ax,0                                                               ;Copia 0000h al registro AX
    mov si,7                                                               ;Copia 00007h al registro SI
                                                                  
    suma:                                                                  ;Etiqueta suma
    xor ax,ax                                                              ;Realiza un XOR logico de los operandos AX,AX y almacena el resultado en el operando destino
    etvar1:                                                                ;Etiqueta etvar1
    cmp cl,3                                                               ;Compara el registro CL con '3' o 33h
    jbe etvar2                                                             ;Salta si al no es igual a '3' o 33h a la etiqueta etvar2
    push si                                                                ;Guarda(Empuja) el contenido o palabra del registro SI en la pila y disminuye el SP en 2(bytes)
    dec si                                                                 ;Decrementa o disminuye el SI en 1
    dec si                                                                 ;Decrementa o disminuye el SI en 1
    dec si                                                                 ;Decrementa o disminuye el SI en 1
    add al,var1[si]                                                        ;Suma el contenido o byte de la localidad de memoria del DS representado por la suma de var1 + SI al registro AL
    pop si                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro SI e incrementa el SP en 2(bytes)
    etvar2:                                                                ;Etiqueta etvar2
    cmp cl,2                                                               ;Compara el registro CL con '2' o 32h
    jbe etvar3                                                             ;Salta si al no es igual a '2' o 32h a la etiqueta etvar3
    push si                                                                ;Guarda(Empuja) el contenido o palabra del registro SI en la pila y disminuye el SP en 2(bytes)
    dec si                                                                 ;Decrementa o disminuye el SI en 1
    dec si                                                                 ;Decrementa o disminuye el SI en 1
    add al,var2[si]                                                        ;Suma el contenido o byte de la localidad de memoria del DS representado por la suma de var2 + SI al registro AL
    pop si                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro SI e incrementa el SP en 2(bytes)
    etvar3:                                                                ;Etiqueta etvar4
    cmp cl,1                                                               ;Compara el registro CL con '1' o 31h
    jbe etvar4                                                             ;Salta si al no es igual a '1' o 31h a la etiqueta etvar4
    push si                                                                ;Guarda(Empuja) el contenido o palabra del registro SI en la pila y disminuye el SP en 2(bytes)
    dec si                                                                 ;Decrementa o disminuye el SI en 1
    add al,var3[si]                                                        ;Suma el contenido o byte de la localidad de memoria del DS representado por la suma de var3 + SI al registro AL
    pop si                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro SI e incrementa el SP en 2(bytes)
    etvar4:                                                                ;Etiqueta etvar4
    add al,var4[si]                                                        ;Suma el contenido o byte de la localidad de memoria del DS representado por la suma de varr + SI al registro AL
    add al,acarreo                                                         ;Suma el contenido o byte de la localidad de memoria del DS representado por acarreo al registro AL
    aam                                                                    ;Realiza un ajuste ascii de multiplicacion al registro AL
    mov varr[si],al                                                        ;Copia el contenido del registro AL a la direccion de memoria del DS representada por la suma de varr + SI
    mov acarreo,ah                                                         ;Copia el contenido del registro AH a la direccion de memoria del DS representada por acarreo
    dec si                                                                 ;Decrementa o disminuye el SI en 1
    loop suma                                                              ;Repite el ciclo si CX es mayor que 0 y salta a la etiqueta suma y decrementa el registro CX(Contador)
    mov acarreo,0                                                          ;Copia 0000h a la direccion de memoria del DS representada por acarreo 
endm                                                                       ;Fin de la macro
;******************SE DECLARA LA PILA Y LOS DATOS *************************
.model small                                                               ;Define modelo de memoria
.stack                                                                     ;Define el area de la pila
.data                                                                      ;Define el area de datos
;DECLARAMOS NUESTRAS VARIABLES QUE UTILIZAREMOS EN EL PROGRAMA
menu        db 13,10,' Calculadora que +,-,x y ',246,13,10                 ;Declaramos la variable(Cadena) que mostrara el menu
            db 13,10,9,'MENU',13,10                                        ;que se le mostrara al usuario con las opciones 
            db 13,10,' 1.- Suma'                                           ;correspondientes para que el usuario pueda elegir
            db 13,10,' 2.- Resta'                                          ;de manera clara y correcta
            db 13,10,' 3.- Multiplicaci',162,'n'   
            db 13,10,' 4.- Divisi',162,'n'
            db 13,10,' 0.- Salir',13,10                            
            db 13,10,' ',168,'Qu',130,' operaci',162,'n desea hacer? ','$' 
msjnum1     db 13,10,' Dame la primera cantidad: $'                        ;Declaramos la variable msj1(Cadena) tipo byte que mostrara el mensaje de la primera cantidad
msjnum2     db 13,10,' Dame la segunda cantidad: $'                        ;Declaramos la variable msj2(Cadena) tipo byte que mostrara el mensaje de la segunda cantidad
msjresul    db 13,10,13,10,' El resultado es: $'                           ;Declaramos la variable msjresul(Cadena) tipo byte que mostrara el mensaje de resultado
continuar   db 13,10,13,10,' Desea continuar?'                             ;Declaramos la variable continuar(Cadena) tipo byte que mostrara 
            db 13,10,' 1.- SI    2.-NO $'                                  ;el mensaje si queremos continuar
nodivide    db 13,10,13,10,7,' No se puede dividir entre cero$'            ;Declaramos la variable nodivide(Cadena) tipo byte que muestra el mensaje de que una division en cero no se puede realizar
msjerror    db 13,10,7,13,10,7,' Hubo un error, intentelo nuevamente..$'   ;Declaramos la variable msjerror(Cadena) tipo byte que muestra el mensaje de error               
msjsum      db 13,10,9,'Suma',13,10,'$'                                    ;Declaramos la variable msjsum(Cadena) tipo byte que miestra el mensaje de la operacion suma
msjres      db 13,10,9,'Resta',13,10,'$'                                   ;Declaramos la variable msjres(Cadena) tipo byte que miestra el mensaje de la operacion resta
msjmul      db 13,10,9,'Multiplicaci',162,'n',13,10,'$'                    ;Declaramos la variable msjmul(Cadena) tipo byte que miestra el mensaje de la operacion multiplicacion
msjdiv      db 13,10,9,'Divisi',162,'n',13,10,'$'                          ;Declaramos la variable msjdiv(Cadena) tipo byte que miestra el mensaje de la operacion division
despedida   db 13,10,9,'Alumno: Eddie Roldan Duarte Ineira',13,10          ;Declaramos la variable despedida(Cadena) tipo byte
            db 13,10,9,'Profesor: Luis Valles Monta',164,'es',13,10        ;Que muestra los datos del creador y profesor 
            db 13,10,9,'Materia: Lenguajes de bajo nivel',13,10            ;del programa calculadora
            db 13,10,9,'Proyecto: Calculadora que +,-,x y ',246,13,10
            db 13,10,9,'Grupo: 3cv14$'
multidiez   dw 10                                                          ;Declaramos la variable multidiez tipo palabra inicializada en 10
var1        db       0,0,0,0,0                                             ;Declaramos la variable var1(Vector tipo byte) inicializados en 0(Cero)
var2        db     0,0,0,0,0,0                                             ;Declaramos la variable var2(Vector tipo byte) inicializados en 0(Cero)
var3        db   0,0,0,0,0,0,0                                             ;Declaramos la variable var3(Vector tipo byte) inicializados en 0(Cero)
var4        db 0,0,0,0,0,0,0,0                                             ;Declaramos la variable var4(Vector tipo byte) inicializados en 0(Cero)
varr        db 0,0,0,0,0,0,0,0                                             ;Declaramos la variable varr(Vector tipo byte) inicializados en 0(Cero)
acarreo     db 0                                                           ;Declaramos la variable acarreo(tipo byte) inicializada en cero
acarreo2    db 0                                                           ;Declaramos la variable acarreo2(tipo byte) inicializada en cero
auxiliar    db 0                                                           ;Declaramos la variable auxiliar(tipo byte) inicializada en cero
contador    dw 0                                                           ;Declaramos la variable contador(tipo palabra) inicializada en cero
punto       db '.'                                                         ;Declaramos la variable punto(tipo byte) inicializada en '.' o 2Eh
signo1      db 0                                                           ;Declaramos la variable signo1(tipo byte) inicializada en cero
signo2      db 0                                                           ;Declaramos la variable signo2(tipo byte) inicializada en cero
signor      db 0                                                           ;Declaramos la variable signor(tipo byte) inicializada en cero
decena1     db 0                                                           ;Declaramos la variable decena1(tipo byte) inicializada en cero
unidad1     db 0                                                           ;Declaramos la variable unidad1(tipo byte) inicializada en cero
decima11    db 0                                                           ;Declaramos la variable decima11(tipo byte) inicializada en cero
decima12    db 0                                                           ;Declaramos la variable decima12(tipo byte) inicializada en cero
decena2     db 0                                                           ;Declaramos la variable decena2(tipo byte) inicializada en cero
unidad2     db 0                                                           ;Declaramos la variable unidad2(tipo byte) inicializada en cero
decima21    db 0                                                           ;Declaramos la variable decima21(tipo byte) inicializada en cero
decima22    db 0                                                           ;Declaramos la variable decima22(tipo byte) inicializada en cero
decenar     db 0                                                           ;Declaramos la variable decenar(tipo byte) inicializada en cero
unidadr     db 0                                                           ;Declaramos la variable unidadr(tipo byte) inicializada en cero
decimar1    db 0                                                           ;Declaramos la variable decimar1(tipo byte) inicializada en cero
decimar2    db 0                                                           ;Declaramos la variable decimar2(tipo byte) inicializada en cero
;******************************* AREA DE CODIGO ***************************
.code                                                                      ;Define el area de codigo
;******* DECLARAMOS LOS PROCEDIMIENTOS QUE SE USARAN EN EL PROGRAMA *******
;PROCEDIMIENTO QUE GUARDARA LOS RESULTADOS EN LAS VARIABLES CORRESPONDIENTES
guardaresultado proc                                                       ;Declaramos el procedimiento guardaresultado
    mov cx,contador                                                        ;Copia el contenido o palabra de la direccion contador de la memoria del DS al registro CX
    mov dx,0                                                               ;Copia 0000h al registro AX
    imprimeresfinal: 	                                                   ;Etiqueta imprimeresfinal:
	div multidiez                                                          ;Divide el contenido de la localidad de memoria representado por multidiez entre AX y el resultado se guarda en el registro AX y el residuo en DX
	mov dh,0                                                               ;Copia 00h al registro DL
	push dx                                                                ;Guarda(Empuja) el contenido o palabra del registro DX en la pila y disminuye el SP en 2(bytes)
	mov dx,0                                                               ;Copia 0000h al registro AX
	loop imprimeresfinal                                                   ;Repite el ciclo si CX es mayor que 0 y salta a la etiqueta imprimeresfinal y decrementa el registro CX(Contador)
	cmp contador,5                                                         ;Compara el contenido o palabra de la direccion de memoria representada por contador con '5' o 35h
	je rescacarreo                                                         ;Salta si el contenido o palabra de la direccion de memoria representada por contador es igual a '5' o 35h a la etiqueta inicio
	mov acarreo,0                                                          ;Copia 0000h a la direccion de memoria representada por acarreo
	jmp ressacarreo                                                        ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta ressacarreo
	
	rescacarreo:                                                           ;Etiqueta rescacarreo
	pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
	mov acarreo,dl                                                         ;Copia el contenido del registro DL a la direccion de memoria representada por acarreo
	
	ressacarreo:	                                                       ;Etiqueta ressacarreo
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov decenar,dl                                                         ;Copia el contenido del registro DL a la direccion de memoria representada por decenar
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov unidadr,dl                                                         ;Copia el contenido del registro DL a la direccion de memoria representada por unidadr
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov decimar1,dl                                                        ;Copia el contenido del registro DL a la direccion de memoria representada por decimar1
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov decimar2,dl                                                        ;Copia el contenido del registro DL a la direccion de memoria representada por decimar2
    mov contador,0                                                         ;Copia 0000h a la direccion de memoria representada por contador
    ret                                                                    ;Transfiere o retorna el control del programa al punto en el que se emitio un CALL
guardaresultado endp                                                       ;Fin del procedimiento
;PROCEDIMIENTO QUE PRAPARA LOS RESGISTROS AX Y BX EN FORMATO 16 BITS PARA OPERAR CON ELLOS
prepararegistroparao proc                                                  ;Declaramos el procedimiento prepararegistroparao
    limpiarregistros                                                       ;Llama a la macro limpiarregistros
    convertirbcd decena1,unidad1,decima11,decima12                         ;Llama a la macro convertirbcd con sus respectivos argumentos
    convertirbcd decena2,unidad2,decima21,decima22                         ;Llama a la macro convertirbcd con sus respectivos argumentos
    formatea16bits decena1,unidad1,decima11,decima12                       ;Llama a la macro formatea16bits con sus respectivos argumentos
    push bx                                                                ;Guarda(Empuja) el contenido o palabra del registro BX en la pila y disminuye el SP en 2(bytes)
    formatea16bits decena2,unidad2,decima21,decima22                       ;Llama a la macro formatea16bits con sus respectivos argumentos
    pop ax                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro AX e incrementa el SP en 2(bytes)
    ret                                                                    ;Transfiere o retorna el control del programa al punto en el que se emitio un CALL
prepararegistroparao endp                                                  ;Fin del procedimiento
;PROCEDIMIENTO QUE COMPRUEBA CUAL ES EL NUMERO MAYOR PARA PODER OPERAR DE MANERA CORRECTA(SUMA Y RESTA)
compruebamayor proc                                                        ;Declaramos el procedimiento compruebamayor
    limpiarregistros                                                       ;Llamamos a la macro limpiarregistros
    call prepararegistroparao                                              ;Llama al procedimiento prepararegistroparao
    cmp auxiliar,1                                                         ;Compara el contenido o byte de la direccion de memoria representada por auxiliar con '1' o 31h
    je compronumerosuma                                                    ;Salta si el contenido o palabra de la direccion de memoria representada por auxiliar es igual a '1' o 31h a la etiqueta compronumerosuma
    cmp signo1,'-'                                                         ;Compara el contenido o byte de la direccion de memoria representada por signo1 con '-' o 2Dh
    je llamaprocesosuma                                                    ;Salta si el contenido o palabra de la direccion de memoria representada por signo1 es igual a '-' o 2Dh a la etiqueta llamaprocesosuma
    cmp ax,bx                                                              ;Compara el contenido del registro AX con el registro BX
    jb cambiarnum1                                                         ;Salta si el contenido del registro AX es menor al contenido del registro BX a la etiqueta cambiarnum1
    mov signor,'+'                                                         ;Copia '+' o 2Bh a la direccion de memoria representada por signor
    jmp fincomprueba                                                       ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta fincomprueba
    
    llamaprocesosuma:                                                      ;Etiqueta llamprocesosuma
    mov signo2,'-'                                                         ;Copia '-' o 2Dh a la direccion de memoria representada por signo2
    jmp fincomprueba                                                       ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta fincomprueba
    
    cambiarnum1:                                                           ;Etiqueta cambiarnum1
    mov signor,'-'                                                         ;Copia '-' o 2Dh a la direccion de memoria representada por signor
    jmp sigcamnum                                                          ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta sigcamnum
    
    compronumerosuma:                                                      ;Etiqueta compronumerosuma
    cmp ax,bx                                                              ;Compara el contenido del registro AX con el registro BX
    jb cambiarnum                                                          ;Salta si el contenido del registro AX es menor al contenido del registro BX a la etiqueta cambiarnum
    
    compruebanumcsigno:                                                    ;Etiqueta compruebanumcsigno
    cmp signo1,'-'                                                         ;Compara el contenido o byte de la direccion de memoria representada por signo1 con '-' o 2Dh
    je cambiasignorn1                                                      ;Salta si el contenido o palabra de la direccion de memoria representada por signo1 es igual a '-' o 2Dh a la etiqueta cambiasignorn1
    mov signor,'+'                                                         ;Copia '+' o 2Bh a la direccion de memoria representada por signor
    jmp fincomprueba                                                       ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta fincomprueba
    
    cambiasignorn1:                                                        ;Etiqueta cambiasignorn1
    mov signor,'-'                                                         ;Copia '-' o 2Dh a la direccion de memoria representada por signor
    jmp fincomprueba                                                       ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta fincomprueba
    
    cambiarnum:                                                            ;Etiqueta cambiarnum
    cmp signo2,'-'                                                         ;Compara el contenido o byte de la direccion de memoria representada por signo2 con '-' o 2Dh
    je cambiasignorn                                                       ;Salta si el contenido o byte de la direccion de memoria representada por signo1 es igual a '-' o 2Dh a la etiqueta cambiasignorn
    mov signor,'+'                                                         ;Copia '+' o 2Bh a la direccion de memoria representada por signor
    jmp sigcamnum                                                          ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta sigacamnum
     
    cambiasignorn:                                                         ;Etiqueta cambiasignorn
    mov signor,'-'                                                         ;Copia '-' o 2Dh a la direccion de memoria representada por signor
                                                                           
    sigcamnum:                                                             ;Etiqueta sigcamnum
    cambiarnumeros decena1, decena2                                        ;Llama a la macro cambiarnumeros con sus respectivos argumentos
    cambiarnumeros unidad1, unidad2                                        ;Llama a la macro cambiarnumeros con sus respectivos argumentos
    cambiarnumeros decima11, decima21                                      ;Llama a la macro cambiarnumeros con sus respectivos argumentos
    cambiarnumeros decima12, decima22                                      ;Llama a la macro cambiarnumeros con sus respectivos argumentos
    
    fincomprueba:                                                          ;Etiqueta fincomprueba
    convertirascii decena1,unidad1,decima11,decima12                       ;Llama a la macro convertirascii con sus respectivos argumentos
    convertirascii decena2,unidad2,decima21,decima22                       ;Llama a la macro convertirascii con sus respectivos argumentos
    ret                                                                    ;Transfiere o retorna el control del programa al punto en el que se emitio un CALL
compruebamayor endp                                                        ;Fin del procedimiento
;PROCEDIMIENTO QUE IMPRIME EL RESULTADO DE LA MANERA CORRECTA SIN MOSTRAR BASURA EJ.10.00
imprimirresultado proc                                                     ;Declaramos el procedimientoimprimirresultado
    limpiarregistros                                                       ;Llamamos a la macro limpiarregistros
    formatea16bits decenar,unidadr,decimar1,decimar2                       ;LLamamos a la macro formatea16bits con sus respectivos argumentos
    cmp bx,0                                                               ;Compara el contenido del registro BX con 0000h
    je ajustesignor                                                        ;Salta si el contenido del registro BX es igual a '0' o 30h a la etiqueta ajustesignorn
    jmp procesoimpresion                                                   ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta procesoimpresion
    
    ajustesignor:                                                          ;Etiqueta ajustesignor
    mov signor,'+'                                                         ;Copia '+' o 2Bh a la direccion de memoria representada por signor
    
    procesoimpresion:                                                      ;Etiqueta procesoimpresion
    convertirascii decenar,unidadr,decimar1,decimar2                       ;Llama a la macro convertirascii con sus respectivos argumentos
    add acarreo,30h                                                        ;Sumamos 30h al contenido almacenado en la localidad acarreo de la memoria del DS
    add acarreo2,30h                                                       ;Sumamos 30h al contenido almacenado en la localidad acarreo2 de la memoria del DS
    cmp signor,'-'                                                         ;Compara el contenido o byte de la direccion de memoria representada por signor con '-' o 2Dh
    je imprimircsigno                                                      ;Salta si el contenido o byte de la direccion de memoria representada por signor es igual a '-' o 2Dh a la etiqueta imprimircsigno
    jmp imprimirssigno                                                     ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta imprimirssigno
    
    imprimircsigno:                                                        ;Etiqueta imprimircsigno
    imprimecaracter signor                                                 ;Llama a la macro imprimecaracter con el argumento signor
    cmp acarreo2,30h                                                       ;Compara el contenido o byte de la direccion de memoria representada por acarreo2 con '0' o 30h
    je acarreocmp1                                                         ;Salta si el contenido o byte de la direccion de memoria representada por acarreo2 es igual a '0' o 30h a la etiqueta acarreocmp1
    imprimecaracter acarreo2                                               ;Llama a la macro imprimecaracter con el argumento acarreo2
    jmp imprimircacarreo                                                   ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta imprimircacarreo
       
    acarreocmp1:                                                           ;Etiqueta acarreocmp1
    cmp acarreo,30h                                                        ;Compara el contenido o byte de la direccion de memoria representada por acarreo con '0' o 30h
    je  imprimirnormal                                                     ;Salta si el contenido o byte de la direccion de memoria representada por acarreo es igual a '0' o 30h a la etiqueta imprimirnormal
    jmp imprimircacarreo                                                   ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta imprimircacarreo
     
    imprimirssigno:                                                        ;Etiqueta imprimirssigno
    cmp acarreo2,30h                                                       ;Compara el contenido o byte de la direccion de memoria representada por acarreo2 con '0' o 30h
    je acarreocmp11                                                        ;Salta si el contenido o byte de la direccion de memoria representada por acarreo2 es igual a '0' o 30h a la etiqueta acarreocmp11
    imprimecaracter acarreo2                                               ;Llama a la macro imprimecaracter con el argumento acarreo2 
    jmp imprimircacarreo                                                   ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta imprimircacarreo
    
    acarreocmp11:                                                          ;Etiqueta acarreocmp11
    cmp acarreo,30h                                                        ;Compara el contenido o byte de la direccion de memoria representada por acarreo con '0' o 30h
    je  imprimirnormal                                                     ;Salta si el contenido o byte de la direccion de memoria representada por acarreo es igual a '0' o 30h a la etiqueta imprimirnormal
    
    imprimircacarreo:                                                      ;Etiqueta imprimircacarreo
    imprimecaracter acarreo                                                ;Llama a la macro imprimecaracter con su argumento acarreo
    
    imprimirnormal:                                                        ;Etiqueta imprimirnormal
    cmp acarreo,30h                                                        ;Compara el contenido o byte de la direccion de memoria representada por acarreo con '0' o 30h
    je comprobardecenar                                                    ;Salta si el contenido o byte de la direccion de memoria representada por acarreo es igual a '0' o 30h a la etiqueta comprobardecenar
    jmp imprimirdecenar1                                                   ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta imprimirdecenar1
                                                                           
    comprobardecenar:                                                      ;Etiqueta comprobardecenar
    cmp decenar,30h                                                        ;Compara el contenido o byte de la direccion de memoria representada por decenar con '0' o 30h
    je imprimirdecenar                                                     ;Salta si el contenido o byte de la direccion de memoria representada por decenar es igual a '0' o 30h a la etiqueta imprimirdecenar
    
    imprimirdecenar1:                                                      ;Etiqueta imprimirdecenar
    imprimecaracter decenar                                                ;Llama a la macro imprimecaracter con su argumento decenar
    
    imprimirdecenar:                                                       ;Etiqueta imprimirdecenar1
    imprimecaracter unidadr                                                ;Llama a la macro imprimecaracter con su argumento unidadr
    
    imprimirpunto:                                                         ;Etiqueta imprimirpunto
    cmp decimar1,30h                                                       ;Compara el contenido o byte de la direccion de memoria representada por decimar1 con '0' o 30h
    je  imprimirdecimar1                                                   ;Salta si el contenido o byte de la direccion de memoria representada por decimar1 es igual a '0' o 30h a la etiqueta imprimirdecimar1 
    imprimecaracter punto                                                  ;Llama a la macro imprimecaracter con su argumento punto
    imprimecaracter decimar1                                               ;Llama a la macro imprimecaracter con su argumento decimar1
    cmp decimar2,30h                                                       ;Compara el contenido o byte de la direccion de memoria representada por decimar2 con '0' o 30h
    ja imprimirdecimar2                                                    ;Salta si el contenido o byte de la direccion de memoria representada por decimar1 es mayor a '0' o 30h a la etiqueta imprimirdecimar2 
    jmp finimp                                                             ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta finimp

    imprimirdecimar1:                                                      ;Etiqueta imprimirdecimar1
    cmp decimar2,30h                                                       ;Compara el contenido o byte de la direccion de memoria representada por decimar2 con '0' o 30h
    ja imprimirdecimart                                                    ;Salta si el contenido o byte de la direccion de memoria representada por decimar2 es mayor a '0' o 30h a la etiqueta imprimirdecimart 
    jmp finimp                                                             ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta finimp
                           
    imprimirdecimar2:                                                      ;Etiqueta imprimirdecimar2
    imprimecaracter decimar2                                               ;Llama a la macro imprimecaracter con su argumento decimar2
    jmp finimp                                                             ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta finimp
                            
    imprimirdecimart:                                                      ;Etiqueta imprimirdecimart
    imprimecaracter punto                                                  ;Llama a la macro imprimecaracter con su argumento punto
    imprimecaracter decimar1                                               ;Llama a la macro imprimecaracter con su argumento decimar1
    imprimecaracter decimar2                                               ;Llama a la macro imprimecaracter con su argumento decimar2
    
    finimp:                                                                ;Etiqueta finimp
    mov acarreo2,0                                                         ;Copia 00h a la direccion de memoria del DS representada por acarreo2 
    mov acarreo,0                                                          ;Copia 00h a la direccion de memoria del DS representada por acarreo 
    mov decenar,0                                                          ;Copia 00h a la direccion de memoria del DS representada por decimar 
    mov unidadr,0                                                          ;Copia 00h a la direccion de memoria del DS representada por unidadr 
    mov decimar1,0                                                         ;Copia 00h a la direccion de memoria del DS representada por decimar1 
    mov decimar2,0                                                         ;Copia 00h a la direccion de memoria del DS representada por decimar2
    ret                                                                    ;Transfiere o retorna el control del programa al punto en el que se emitio un CALL
imprimirresultado endp                                                     ;Fin del procedimiento
;PROCEDIMIENTO QUE VALIDA EL INGRESO DE LOS DATOS SEAN CORRECTOS PARA OPERAR DE MANERA CORRECTA
validar proc
    limpiarregistros                                                       ;Llamamos a la macro limpiarregistros                                                               ;Declaramos el procedimiento validar
    mov cx,2                                                               ;Copia 0002h al registros
    repite:                                                                ;Etiqueta repite
    cmp cx,2                                                               ;Compara el contenido o palabra del registro CX con '2' o 32h
    je msj1                                                                ;Salta si el contenido o palabra del registro CX es igual a '2' o 32h a la etiqueta msj1
    jmp msj2                                                               ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta msj2
    
    msj1:                                                                  ;Etiqueta msj1
    imprime msjnum1                                                        ;Llama a la macro imprime con el argumento msj1
    jmp procedimiento                                                      ;Salta a la etiqueta procedimiento
    
    msj2:                                                                  ;Etiqueta msj2
    imprime msjnum2                                                        ;Llama a la macro imprime con el argumento msj2
    jmp procedimiento                                                      ;Salta a la etiqueta procedimiento
    
    procedimiento:                                                         ;Etiqueta procedimiento
    recibecaracter                                                         ;Llama a la macro recibecaracter
    cmp al,'+'                                                             ;Compara el contenido o byte del registro AL con '+' o 2Bh
    je guarda1                                                             ;Salta si el contenido o byte del registro AL es igual a '+' o 2Bh a la etiqueta guarda1
    cmp al,'-'                                                             ;Compara el contenido o byte del registro AL con '-' o 2Dh
    je guarda1                                                             ;Salta si el contenido o byte del registro AL es igual a '-' o 2Dh a la etiqueta guarda1
    cmp al,'.'                                                             ;Compara el contenido o byte del registro AL con '.' o 2Eh
    je signopunto                                                          ;Salta si el contenido o byte del registro AL es igual a '.' o 2Eh a la etiqueta signopunto
    cmp al,0dh                                                             ;Compara el contenido o byte del registro AL con 'cret' o 0Dh
    je sinnada                                                             ;Salta si el contenido o byte del registro AL es igual a 'cret' o 0Dh a la etiqueta sinnada
    cmp al,30h                                                             ;Compara el contenido o byte del registro AL con '0' o 30h
    jb error                                                               ;Salta si el contenido o byte del registro AL es menor a '0' o 30h a la etiqueta error
    cmp al,39h                                                             ;Compara el contenido o byte del registro AL con '9' o 39h
    ja error                                                               ;Salta si el contenido o byte del registro AL es mayor a '9' o 39h a la etiqueta error
    jmp guardadecena                                                       ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta guardadecena
    
    guarda1:                                                               ;Etiqueta guarda1
    mov signo2,al                                                          ;Copia el contenido del registro al a la localidad de memoria representada por signo2
    recibecaracter                                                         ;Llama a la macro recibecaracter
    cmp al,'.'                                                             ;Compara el contenido o byte del registro AL con '.' o 2Eh
    je guarda2                                                             ;Salta si el contenido o byte del registro AL es igual a '.' o 2Eh a la etiqueta guarda2
    cmp al,0dh                                                             ;Compara el contenido o byte del registro AL con 'cret' o 0Dh
    je sinnada                                                             ;Salta si el contenido o byte del registro AL es igual a 'cret' o 0Dh a la etiqueta sinnada
    cmp al,30h                                                             ;Compara el contenido o byte del registro AL con '0' o 30h
    jb error                                                               ;Salta si el contenido o byte del registro AL es menor a '0' o 30h a la etiqueta error
    cmp al,39h                                                             ;Compara el contenido o byte del registro AL con '9' o 39h
    ja error                                                               ;Salta si el contenido o byte del registro AL es mayor a '9' o 39h a la etiqueta error
    jmp guardardecena1                                                     ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta guardadecena1
    
    guarda2:                                                               ;Etiqueta guarda2
    cmp signo2,'-'                                                         ;Compara el contenido o byte de la direccion de memoria representada por signo2 con '-' o 2Dh
    je procedimiento2                                                      ;Salta si el contenido o byte de la direccion de memoria representada por signo2 es igual a '-' o 2Dh a la etiqueta procedimiento2

    signopunto:                                                            ;Etiqueta signopunto
    mov signo2,'+'                                                         ;Copia '+' o 2Bh a la localidad de memoria representada por signo2
    
    procedimiento2:                                                        ;Etiqueta procedimiento2
    mov decena2,30h                                                        ;Copia 30h a la direccion de memoria del DS representada por decena2
    mov unidad2,30h                                                        ;Copia 30h a la direccion de memoria del DS representada por unidad2
    jmp guardadecim                                                        ;Salta a la etiqueta guardadecim
    
    guardadecena:                                                          ;Etiqueta guardadecena
    mov signo2,'+'                                                         ;Copia '+' o 2Bh a la localidad de memoria representada por signo2
    
    guardardecena1:                                                        ;Etiqueta guardardecena1
    mov decena2,al                                                         ;Copia el contenido del registro AL a la localidad de memoria del DS representado por decena2
    recibecaracter                                                         ;Llama macro recibecaracter
    cmp al,'.'                                                             ;Compara el contenido o byte del registro AL con '.' o 2Eh
    je unidadydecimas                                                      ;Salta si el contenido o byte del registro AL es igual a '.' o 2Eh a la etiqueta unidadydecimas
    cmp al,0dh                                                             ;Compara el contenido o byte del registro AL con 'cret' o 0Dh
    je  unidadsindecimas                                                   ;Salta si el contenido o byte del registro AL es igual a 'cret' o 0Dh a la etiqueta unidadsindecimas
    cmp al,30h                                                             ;Compara el contenido o byte del registro AL con '0' o 30h
    jb error                                                               ;Salta si el contenido o byte del registro AL es menor a '0' o 30h a la etiqueta error
    cmp al,39h                                                             ;Compara el contenido o byte del registro AL con '9' o 39h
    ja error                                                               ;Salta si el contenido o byte del registro AL es mayor a '9' o 39h a la etiqueta error

    guardaunidad:                                                          ;Etiqueta guardaunidad:
    mov unidad2,al                                                         ;Copia el contenido del registro AL a la localidad de memoria del DS representado por unidad2
    recibecaracter                                                         ;Llama a la macro recibecaracter
    cmp al,'.'                                                             ;Compara el contenido o byte del registro AL con '.' o 2Eh
    je guardadecim                                                         ;Salta si el contenido o byte del registro AL es igual a '.' o 2Eh a la etiqueta guardadecim
    cmp al,0dh                                                             ;Compara el contenido o byte del registro AL con 'cret' o 0Dh
    je sindecimas                                                          ;Salta si el contenido o byte del registro AL es igual a 'cret' o 0Dh a la etiqueta sindecimas
    cmp al,30h                                                             ;Compara el contenido o byte del registro AL con '0' o 30h
    jb error                                                               ;Salta si el contenido o byte del registro AL es menor a '0' o 30h a la etiqueta error
    cmp al,39h                                                             ;Compara el contenido o byte del registro AL con '9' o 39h
    ja error                                                               ;Salta si el contenido o byte del registro AL es mayor a '9' o 39h a la etiqueta error
    
    guardapunto1:                                                          ;Etiqueta guardapunto1
    cmp al,'.'                                                             ;Compara el contenido o byte del registro AL con '.' o 2Eh
    je guardadecim                                                         ;Salta si el contenido o byte del registro AL es igual a '.' o 2Eh a la etiqueta guardadecim
    jmp error                                                              ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta error
    
    guardadecim:                                                           ;Etiqueta guardadecim
    recibecaracter                                                         ;Llama a la macro recibecaracter
    cmp al,30h                                                             ;Compara el contenido o byte del registro AL con '0' o 30h
    jae guardadecim1                                                       ;Salta si el contenido o byte del registro AL es mayor o igual a '0' o 30h a la etiqueta guardadecim1
    cmp al,0dh                                                             ;Compara el contenido o byte del registro AL con 'cret' o 0Dh
    je sindecimas                                                          ;Salta si el contenido o byte del registro AL es igual a 'cret' o 0Dh a la etiqueta sindecimas
    cmp al,30h                                                             ;Compara el contenido o byte del registro AL con '0' o 30h
    jb error                                                               ;Salta si el contenido o byte del registro AL es menor a '0' o 30h a la etiqueta error
    cmp al,39h                                                             ;Compara el contenido o byte del registro AL con '9' o 39h
    ja error                                                               ;Salta si el contenido o byte del registro AL es mayor a '9' o 39h a la etiqueta error
    
    guardadecim1:                                                          ;Etiqueta guardadecim1
    mov decima21,al                                                        ;Copia el contenido del registro AL a la localidad de memoria del DS representado por decima21
    recibecaracter                                                         ;Llama a la macro recibecaracter
    cmp al,30h                                                             ;Compara el contenido o byte del registro AL con '0' o 30h
    ja  guardadecima2                                                      ;Salta si el contenido o byte del registro AL es mayor a '0' o 30h a la etiqueta guardadecima2
    cmp al,0dh                                                             ;Compara el contenido o byte del registro AL con 'cret' o 0Dh
    je sindecima2                                                          ;Salta si el contenido o byte del registro AL es igual a 'cret' o 0Dh a la etiqueta sindecima2
    cmp al,30h                                                             ;Compara el contenido o byte del registro AL con '0' o 30h
    jb error                                                               ;Salta si el contenido o byte del registro AL es menor a '0' o 30h a la etiqueta error
    cmp al,39h                                                             ;Compara el contenido o byte del registro AL con '9' o 39h
    ja error                                                               ;Salta si el contenido o byte del registro AL es mayor a '9' o 39h a la etiqueta error
    jmp sindecima2                                                         ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta sindecima2
    
    guardadecima2:                                                         ;Etiqueta guardadecima2
    mov decima22,al                                                        ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por decima22
    jmp final                                                              ;Salta a la etiqueta final
    
    sindecima2:                                                            ;Etiqueta sindecima2
    mov decima22,30h                                                       ;Copia 30h a la localidad de memoria del DS representado por decima22
    jmp final                                                              ;Salta a la etiqueta final
    
    sindecimas:                                                            ;Etiqueta sindecimas
    mov decima21,30h                                                       ;Copia 30h a la localidad de memoria del DS representado por decima21
    mov decima22,30h                                                       ;Copia 30h a la localidad de memoria del DS representado por decima22
    jmp final                                                              ;Salta a la etiqueta final
                                                                           
    unidadsindecimas:                                                      ;Etiqueta unidadsdecimas
    mov al, decena2                                                        ;Copia el contenido o byte de la localidad de la memoria del DS representado por decena2 al registro AL
    mov unidad2,al                                                         ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por unidad2
    mov decena2,30h                                                        ;Copia 30h a la localidad de memoria del DS representado por decena2
    jmp sindecimas                                                         ;Salta a la etiqueta sindecimas
    
    unidadydecimas:                                                        ;Etiqueta Unidadydecimas
    mov al, decena2                                                        ;Copia el contenido o byte de la localidad de la memoria del DS representado por decena2 al registro AL
    mov unidad2,al                                                         ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por unidad2
    mov decena2,30h                                                        ;Copia 30h a la localidad de memoria del DS representado por decena2
    jmp guardadecim                                                        ;Salta a la etiqueta guardadecim
    
    sinnada:                                                               ;Etiqueta sinnada
    mov decena2,30h                                                        ;Copia 30h a la localidad de memoria del DS representado por decena2
    mov unidad2,30h                                                        ;Copia 30h a la localidad de memoria del DS representado por unidad2
    mov decima21,30h                                                       ;Copia 30h a la localidad de memoria del DS representado por decima21
    mov decima22,30h                                                       ;Copia 30h a la localidad de memoria del DS representado por decima22
    
    final:                                                                 ;Etiqueta final
    cmp cx,2                                                               ;Compara el contenio del registro CX con '2' o 32h
    je copiarnum2ennum1                                                    ;Salta si el contenido del registro AL es igual a '2' o 32h a la etiqueta copiarnum2ennum1
    jmp fin                                                                ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta fin
     
    copiarnum2ennum1:                                                      ;Etiqueta copiarnum2ennum1
    cambiarnumeros signo1, signo2                                          ;Llama a la macro cambiar numeros con sus respectivos argumentos
    cambiarnumeros decena1, decena2                                        ;Llama a la macro cambiar numeros con sus respectivos argumentos
    cambiarnumeros unidad1, unidad2                                        ;Llama a la macro cambiar numeros con sus respectivos argumentos
    cambiarnumeros decima11, decima21                                      ;Llama a la macro cambiar numeros con sus respectivos argumentos
    cambiarnumeros decima12, decima22                                      ;Llama a la macro cambiar numeros con sus respectivos argumentos

    fin:                                                                   ;Etiqueta fin
    loop repite                                                            ;Repite el ciclo si CX es mayor que 0 y salta a la etiqueta repite y decrementa el registro CX(Contador)
    ret                                                                    ;Transfiere o retorna el control del programa al punto en el que se emitio un CALL
validar endp                                                               ;Fin del procedimiento
;PROCEDIMIENTO QUE SE ENCARGAR DE DIVIDIR Y GUARDAR LOS RESULTADOS EN LAS VARIABLES CORRESPONDIENTES 
divip proc                                                                 ;Declaramos el procedimiento divip
    limpiarregistros                                                       ;Llamamos a la macro limpiarregistros    
    mov al,signo1                                                          ;Copia el contenido o byte de la localidad de la memoria del DS representado por signo1 al registro AL
    cmp al,signo2                                                          ;Compara el contenido del registro AL con el contenido de la direccion de la memoria del DS representada por signo2 
    je siguesignodivis                                                     ;Salta si el contenido del registro AL es igual al contenido de la direccion de memoria del DS representada por signo2 a la etiqueta siguesignodivis
    cmp signo1,'-'                                                         ;Compara el contenido o byte de la direccion de memoria representada por signo1 con '-' o 2Dh
    je cambiasignodiv                                                      ;Salta si el contenido o byte de la direccion de memoria representada por signo1 es igual a '-' o 2Dh a la etiqueta cambiasignodiv
    mov al,signo2                                                          ;Copia el contenido o byte de la localidad de la memoria del DS representado por signo2 al registro AL
    mov signor,al                                                          ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por signor
    jmp sigueprocdivis                                                     ;Salta si no es igual a ninguna de las comparaciones anteriores a la etiqueta sigueprocdivis
    
    siguesignodivis:                                                       ;Etiqueta siguesignodivis
    mov signor,'+'                                                         ;Copia '+' o 2Bh a la localidad de memoria representada por signor
    jmp sigueprocdivis                                                     ;Salta a la etiqueta sigueprocdivis
    
    cambiasignodiv:                                                        ;Etiqueta cambiasignodiv
    mov al,signo1                                                          ;Copia el contenido o byte de la localidad de la memoria del DS representado por signo1 al registro AL
    mov signor,al                                                          ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por signor
    
    sigueprocdivis:                                                        ;Etiqueta sigueprocdivis
    call prepararegistroparao                                              ;Llama al procedimiento prepararegistroparao
    cmp bx,0                                                               ;Compara el contenido del registro BX con 0000h
    je findiverr                                                           ;Salta si el contenido del registro BX es igual a 0000h a la etiqueta findiverr
    cmp ax,0                                                               ;Compara el contenido del registro AX con 0000h
    je findiv                                                              ;Salta si el contenido del registro AX es igual a 0000h a la etiqueta findiv
    div bx                                                                 ;Divide el contenido del registro BX entre AX y el resultado se guarda en el registro AX y el residuo en DX
    cmp ax,255                                                             ;Compara el contenido del registro AX con 255 o 00FFh
    jb continua8bits                                                       ;Salta si el contenido del registro AX es menor a 255 o 00FFh a la etiqueta continua8bits
    push dx                                                                ;Guarda(Empuja) el contenido o palabra del registro DX en la pila y disminuye el SP en 2(bytes)
    mov cx,4                                                               ;Copia 0004h al registro CX
    mov dx,0                                                               ;Copia 0000h al registro DX
    imprimeresfinal1: 	                                                   ;Etiqueta imprimeresfinal1
    div multidiez                                                          ;Divide el contenido de la localidad de memoria representado por multidiez entre AX y el resultado se guarda en el registro AX y el residuo en DX
    mov dh,0                                                               ;Copia 00h al registro DH
    push dx                                                                ;Guarda(Empuja) el contenido o palabra del registro DX en la pila y disminuye el SP en 2(bytes)
    mov dx,0                                                               ;Copia 0000h al registro DX
    loop imprimeresfinal1                                                  ;Repite el ciclo si CX es mayor que 0 y salta a la etiqueta imprimeresfinal1 y decrementa el registro CX(Contador)
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov acarreo2,dl                                                        ;Copia el contenido o byte del registro DL a la localidad de memoria del DS representado por acarreo2
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov acarreo,dl	                                                       ;Copia el contenido o byte del registro DL a la localidad de memoria del DS representado por acarreo
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov decenar,dl                                                         ;Copia el contenido o byte del registro DL a la localidad de memoria del DS representado por decenar
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    mov unidadr,dl                                                         ;Copia el contenido o byte del registro DL a la localidad de memoria del DS representado por unidadr
    pop dx                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro DX e incrementa el SP en 2(bytes)
    jmp sigadiv                                                            ;Salta a la etiqueta sigadiv
    
    continua8bits:                                                         ;Etiqueta continua8bits
    aam                                                                    ;Realiza un ajuste ascii de multiplicacion al registro AL
    cmp ah,10                                                              ;Compara el contenido del registro AH con 10 o 0Ah
    jb sigdiv1                                                             ;Salta si el contenido del registro AH es menor a 10 o 0Ah
    mov unidadr,al                                                         ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por unidadr
    mov al,ah                                                              ;Copia el contenido del registro AH al registro AL
    aam                                                                    ;Realiza un ajuste ascii de multiplicacion al registro AL
    mov acarreo,ah                                                         ;Copia el contenido o byte del registro AH a la localidad de memoria del DS representado por acarreo
    mov decenar,al                                                         ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por decenar
    jmp sigadiv                                                            ;Salta a la etiqueta sigadiv
    
    sigdiv1:                                                               ;Etiqueta sigdiv1
    mov acarreo,0                                                          ;Copia 00h a la direccion de memoria del DS representada por acarreo 
    mov decenar,ah                                                         ;Copia el contenido o byte del registro AH a la localidad de memoria del DS representado por decenar
    mov unidadr,al                                                         ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por unidadr
    
    sigadiv:                                                               ;Etiqueta sigadiv
    mov ax,dx                                                              ;Copia el contenido del registro DX al registro AX
    mul multidiez                                                          ;Multiplica el contenido de la localidad de memoria representado por multidiez por AX y el resultado se guarda en el registro AX
    div bx                                                                 ;Divide el contenido del registro BX entre AX y el resultado se guarda en el registro AX y el residuo en DX
    aam                                                                    ;Realiza un ajuste ascii de multiplicacion al registro AL
    mov decimar1,al                                                        ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por decimar1
    mov ax,dx                                                              ;Copia el contenido del registro DX al registro AX
    mul multidiez                                                          ;Multiplica el contenido de la localidad de memoria representado por multidiez por AX y el resultado se guarda en el registro AX
    div bx                                                                 ;Divide el contenido del registro BX entre AX y el resultado se guarda en el registro AX y el residuo en DX
    aam                                                                    ;Realiza un ajuste ascii de multiplicacion al registro AL
    mov decimar2,al                                                        ;Copia el contenido o byte del registro AL a la localidad de memoria del DS representado por decimar2
    jmp findiv                                                             ;Salta a la etiqueta findiv
    
    findiverr:                                                             ;Etiqueta findiverr
    imprime nodivide                                                       ;Llama a la macro imprime con el argumento nodivide(Imprime mensaje de no divide entre cero)
    regresamenu                                                            ;Llama a la macro regresamenu(Que imprime y nos pregunta si queremos seguir con el programa)
    
    findiv:                                                                ;Etiqueta findiv
    ret                                                                    ;Transfiere o retorna el control del programa al punto en el que se emitio un CALL
divip endp                                                                 ;Fin del procedimiento
;INICIA EL PROCEDIMIENTO QUE SE ENCARGA DE MULTIPLICAR Y POSTERIOR A ELLO LOS GUARDA EL RESULTADO EN LAS VARIABLES CORRESPONDIENTES
multip proc                                                                ;Inicia el procedimiento multip
    limpiarregistros                                                       ;Llama a la macro limpiarregistros
    formatea16bits decena1,unidad1,decima11,decima12                       ;Llama a la macro formatea16bits con sus respectivos argumentos
    mov ax,bx                                                              ;Copia el contenido del registro BX al registro AX
    xor bx,bx                                                              ;Realiza un XOR logico de los operandos BX almacena el resultado en el operando destino
    mov bl,decima22                                                        ;Copia el contenido de la direccion de memoria del DS representada por decima22 al registro BL
    push ax                                                                ;Guarda(Empuja) el contenido o palabra del registro AX en la pila y disminuye el SP en 2(bytes)
    mul bx                                                                 ;Multiplica el contenido del registro BX por AX y el resultado se guarda en el registro AX 
    mov contador,5                                                         ;Copia 0005h a la direccion de memoria del DS representada por contador 
    guardaenvariablemul contador,var1                                      ;Llama a la macro guardaenvariablemul con sus respectivos argumentos
    pop ax                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro AX e incrementa el SP en 2(bytes)
    push ax                                                                ;Guarda(Empuja) el contenido o palabra del registro AX en la pila y disminuye el SP en 2(bytes)
    mov bl,decima21                                                        ;Copia el contenido de la direccion de memoria del DS representada por decima21 al registro BL
    mul bx                                                                 ;Multiplica el contenido del registro BX por AX y el resultado se guarda en el registro AX 
    guardaenvariablemul contador,var2                                      ;Llama a la macro guardaenvariablemul con sus respectivos argumentos
    pop ax                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro AX e incrementa el SP en 2(bytes)
    push ax                                                                ;Guarda(Empuja) el contenido o palabra del registro AX en la pila y disminuye el SP en 2(bytes)
    mov bl,unidad2                                                         ;Copia el contenido de la direccion de memoria del DS representada por unidad2 al registro BL
    mul bx                                                                 ;Multiplica el contenido del registro BX por AX y el resultado se guarda en el registro AX 
    guardaenvariablemul contador,var3                                      ;Llama a la macro guardaenvariablemul con sus respectivos argumentos
    pop ax                                                                 ;Recupera(Saca) de la pila el contenido o palabra de la pila y se lo asignamos al registro AX e incrementa el SP en 2(bytes)
    mov bl,decena2                                                         ;Copia el contenido de la direccion de memoria del DS representada por decena2 al registro BL
    mul bx                                                                 ;Multiplica el contenido del registro BX por AX y el resultado se guarda en el registro AX 
    guardaenvariablemul contador,var4                                      ;Llama a la macro guardaenvariablemul con sus respectivos argumentos
    mov contador,8                                                         ;Copia 0008h a la direccion de memoria del DS representada por contador 
    sumaresultadomulti contador                                            ;Llama a la macro sumaresultadomulti con su argumento contador(numero de datos que guardara en el vector)
    mov al,varr[0]                                                         ;Copia el contenido de la direccion de memoria dada por la suma de varr + 0 al registro AL                         
    mov acarreo2, al                                                       ;Copia el contenido del registro AL a la localidad de memoria del DS representado por acarreo2
    mov al,varr[1]                                                         ;Copia el contenido de la direccion de memoria dada por la suma de varr + 1 al registro AL                          
    mov acarreo, al                                                        ;Copia el contenido del registro AL a la localidad de memoria del DS representado por acarreo
    mov al,varr[2]                                                         ;Copia el contenido de la direccion de memoria dada por la suma de varr + 2 al registro AL
    mov decenar, al                                                        ;Copia el contenido del registro AL a la localidad de memoria del DS representado por decenar
    mov al,varr[3]                                                         ;Copia el contenido de la direccion de memoria dada por la suma de varr + 3 al registro AL
    mov unidadr, al                                                        ;Copia el contenido del registro AL a la localidad de memoria del DS representado por unidadr
    mov al,varr[4]                                                         ;Copia el contenido de la direccion de memoria dada por la suma de varr + 4 al registro AL
    mov decimar1, al                                                       ;Copia el contenido del registro AL a la localidad de memoria del DS representado por decimar1
    mov al,varr[5]                                                         ;Copia el contenido de la direccion de memoria dada por la suma de varr + 5 al registro AL
    mov decimar2, al                                                       ;Copia el contenido del registro AL a la localidad de memoria del DS representado por decimar2
    mov contador,0                                                         ;Copia 0000h a la direccion de memoria del DS representada por contador 
    ret                                                                    ;Transfiere o retorna el control del programa al punto en el que se emitio un CALL
multip endp                                                                ;Fin del procedimiento
;*************************** INICIA EL PROGRAMA ***************************
inicio:                                                                    ;Inicia el procedimiento principal  
limpantalla                                                                ;Llama a la macro limpantalla que limpiara la pantalla
imprime menu                                                               ;Llama a la macro imprime con el argumento menu(imprime la cadena menu que mostrara al usuario)
recibecaracter                                                             ;Llama a la macro recibecaracter(lee un caracter por teclado)
cmp al,'1'                                                                 ;Compara el contenido del registro AL con '1' o 31h
jz suma                                                                    ;Salta si el contenido del registro AL es igual a '1' o 31h a la etiqueta suma
cmp al,'2'                                                                 ;Compara el contenido del registro AL con '2' o 32h
jz resta                                                                   ;Salta si el contenido del registro AL es igual a '2' o 32h a la etiqueta resta
cmp al,'3'                                                                 ;Compara el contenido del registro AL con '3' o 33h
jz multipli                                                                ;Salta si el contenido del registro AL es igual a '3' o 33h a la etiqueta multiplicacion
cmp al,'4'                                                                 ;Compara el contenido del registro AL con '4' o 34h
jz division                                                                ;Salta si el contenido del registro AL es igual a '4' o 34h a la etiqueta division
cmp al,'0'                                                                 ;Compara el contenido del registro AL con '0' o 30h
jz salir                                                                   ;Salta si el contenido del registro AL es igual a '0' o 30h a la etiqueta salir
jmp error                                                                  ;Salta a la etiqueta error
;******************** INCIA EL PROCESO DE SUMA ****************************
suma:                                                                      ;Etiqueta suma
limpantalla                                                                ;Llama a la macro limpantalla que limpiara la pantalla
imprime msjsum                                                             ;Llama a la macro imprime msjsum(Imprime el mensaje de la opereacion)
call validar                                                               ;Llama al procedimiento validar(Pide los datos al usuario para las operaciones)
mov auxiliar,1                                                             ;Copia 01h al contenido de la direccion de memoria representada por auxiliar del DS
mov al,signo1                                                              ;Copia el contenido de la direccion de memoria dada por signo1 al registro AL
cmp al,signo2                                                              ;Compara el contenido de AL con el contenido de la direccion de memoria representada por signo2
je signoigual                                                              ;Salta si el contenido de AL es igual al contenido de la direccion de memoria representada por signo2
call compruebamayor                                                        ;Llama al procedimiento compruebamayor(Comprueba que numero es mayor y los ordena)
jmp siguerestanorm                                                         ;Salta a la etiqueta siguerestanorm
  
signoigual:                                                                ;Etiqueta signoigual
mov al,signo1                                                              ;Copia el contenido de la direccion de memoria representada por signo1 al registro AL
mov signor,al                                                              ;Copia el contenido del registro AL a la localidad de memoria dada por signor
call prepararegistroparao                                                  ;LLama al procedimiento prepararegistroparao(Se encarga de ingresar los valores en AX y BX que el usuario ingreso)
add ax,bx                                                                  ;Suma el contenido o palabra del registro BX a AX
mov contador,5                                                             ;Copia 0005h a la localidad de memoria representada por contador
call guardaresultado                                                       ;Llama al procedimiento guardaresultado

finsuma:                                                                   ;Etiqueta sinsuma
mov auxiliar,0                                                             ;Copia 00h a la localidad de memoria representada por auxiliar
imprime msjresul                                                           ;Llama a la macro imprime msjresul(Imprime el mensaje del resultado)
call imprimirresultado                                                     ;Llama al procedimiento imprimirresultado(imprime el resultado final de la operacion realizada)
regresamenu                                                                ;llama a la macro regresamenu(Imprime mensaje donde nos pregunta si queremos continuar con el programa)
;******************** INICIA EL PROCESO DE RESTA **************************
resta:                                                                     ;Etiqueta resta
limpantalla                                                                ;Llama a la macro limpantalla que limpiara la pantalla
imprime msjres                                                             ;Llama a la macro imprime msjres(Imprime el mensaje de la opereacion)
call validar                                                               ;Llama al procedimiento validar(Pide los datos al usuario para las operaciones)
call compruebamayor                                                        ;Llama al procedimiento compruebamayor(Comprueba que numero es mayor y los ordena)
cmp signo1,'-'                                                             ;Compara el contenido de la localidad de memoria representado por signo1 
je signoigual                                                              ;Salta si el contenido de la localidad de memoria representado por signo1 es igual a '-' o 2Dh a la etiqueta signoigual
siguerestanorm:                                                            ;Etiqueta siguerestanorm
call prepararegistroparao                                                  ;LLama al procedimiento prepararegistroparao(Se encarga de ingresar los valores en AX y BX que el usuario ingreso)
sub ax,bx                                                                  ;Resta el contenido de BX y AX y el resultado lo almacena en AX
mov contador,4                                                             ;Copia 0004h a la localidad de memoria representada por contador
call guardaresultado                                                       ;Llama al procedimiento guardaresultado
imprime msjresul                                                           ;Llama a la macro imprime msjresul(Imprime el mensaje del resultado)
call imprimirresultado                                                     ;Llama al procedimiento imprimirresultado(imprime el resultado final de la operacion realizada)
regresamenu                                                                ;llama a la macro regresamenu(Imprime mensaje donde nos pregunta si queremos continuar con el programa)
;************************* INICIA EL PROCESO DE MULTIPLICACION ************
multipli:                                                                  ;Etiqueta multipli
limpantalla                                                                ;Llama a la macro limpantalla que limpiara la pantalla
imprime msjmul                                                             ;Llama a la macro imprime msjmul(Imprime el mensaje de la opereacion)
call validar                                                               ;Llama al procedimiento validar(Pide los datos al usuario para las operaciones)
call prepararegistroparao                                                  ;LLama al procedimiento prepararegistroparao(Se encarga de ingresar los valores en AX y BX que el usuario ingreso)
cmp ax,0                                                                   ;Compara el contenido del registro BX con 0000h
je finmul                                                                  ;Salta si el contenido del registro AX es igual a '0' o 00h a la etiqueta finmul
cmp bx,0                                                                   ;Compara el contenido del registro BX con 0000h
je finmul                                                                  ;Salta si el contenido del registro AX es igual a '0' o 00h a la etiqueta finmul
mov al,signo1                                                              ;Copia el contenido de la direccion de memoria representada por signo1 al registro AL
cmp al,signo2                                                              ;Compara el contenido del registro AL con el contenido de la localidad de memoria representada por signo2
je siguesignomulti                                                         ;Salta si el contenido del registro AL es igual  al contenido de la localidad de memoria representado por signo2 a la etiqueta siguesignomulti 
cmp signo1,'-'                                                             ;Compara el contenido de la localidad de memoria representado por signo1 con '-' 2Dh 
je cambiasignomul                                                          ;Salta si el contenido de la direccion de memoria representado por signo1 es igual con '-' o 2Dh a la etiqueta cambiasignomul  
mov al,signo2                                                              ;Copia el contenido de la direccion de memoria representada por signo2 al registro AL
mov signor,al                                                              ;Copia el contenido del registro AL a la direccion de memoria representada por signor 
jmp sigueprocmulti                                                         ;Salta a la etiqueta sigueprocmulti

siguesignomulti:                                                           ;Etiqueta siguesignomulti
mov signor,'+'                                                             ;Copia '+' o 2Bh a la direccion de memoria representada por signor
jmp sigueprocmulti                                                         ;Salta a la etiqueta sigueprocmulti

cambiasignomul:                                                            ;Etiqueta cambiasignomul
mov al,signo1                                                              ;Copia el contenido de la localidad de memoria representado por signo1 al registo AL
mov signor,al                                                              ;Copia el contenido del registro AL a la localidad de memoria representada por signor

sigueprocmulti:                                                            ;Etiqueta sigueprocmulti
call multip                                                                ;Llama al procedimiento multip

finmul:                                                                    ;Etiqueta finmul
imprime msjresul                                                           ;Llama a la macro imprime msjresul(Imprime el mensaje del resultado)
call imprimirresultado                                                     ;Llama al procedimiento imprimirresultado(imprime el resultado final de la operacion realizada)
regresamenu                                                                ;llama a la macro regresamenu(Imprime mensaje donde nos pregunta si queremos continuar con el programa)
;******************** INICIA EL PROCESO DE DIVISION ***********************
division:                                                                  ;Etiqueta division
limpantalla                                                                ;Llama a la macro limpantalla que se encarga de limpiar la pantalla
imprime msjdiv                                                             ;Llama a la macro imprime msjdiv(Imprime el mensaje de la opereacion)
call validar                                                               ;Llama al procedimiento validar(Pide los datos al usuario para las operaciones)
call divip                                                                 ;Llama al procedimiento divip(Que realiza la division de los 2 numeros ingresados)
imprime msjresul                                                           ;Llama a la macro imprime msjresul(Imprime el mensaje del resultado)
call imprimirresultado                                                     ;Llama al procedimiento imprimirresultado(imprime el resultado final de la operacion realizada)
regresamenu                                                                ;llama a la macro regresamenu(Imprime mensaje donde nos pregunta si queremos continuar con el programa)
;********** IMPRIME EL MENSAJE DE ERROR SI HAY UNO EN EL PROGRAMA *********
error:                                                                     ;Etiqueta error
imprime msjerror                                                           ;llama a la macro imprime msjerror(Imprime un mensaje de error)
regresamenu                                                                ;llama a la macro regresamenu(Imprime mensaje donde nos pregunta si queremos continuar con el programa)
;*************************** SALIDA DEL PROGRAMA **************************         
salir:                                                                     ;Etiqueta salir
limpantalla                                                                ;Llama a la macro limpantalla que limpia la pantalla
imprime despedida                                                          ;Llama a la macro imprime con el argumento despedida(Imprime el mensaje despedida)
mov ah,4ch                                                                 ;Asigna la funcion 4ch a ah
int 21h                                                                    ;Y con la int 21h devuelve el control al DOS
end inicio                                                                 ;Fin del programa
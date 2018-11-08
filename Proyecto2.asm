org 100h
;----------------------------------------------------------- Macros generales -----------------------------------------------------------
;funcion 09h 
%macro Mensaje 1
	mov ah,09h
	mov dx,%1
	int 21h
%endmacro
;asignar usando al
%macro AsignarAL 2
	mov al,%1
	mov %2,al
%endmacro
;asignar usando bl 
%macro AsignarBL 2
	mov bl,%1
	mov %2,bl
%endmacro
;asignar usando cl
%macro AsignarCL 2
	mov cl,%1
	mov %2,cl
%endmacro
;---------------------------------------------------------- Macros Para Numeros-----------------------------------------------------------
;obtener datos de los numeros
%macro Datos_Numero 3
	mov ah,01h
	int 21h
	mov %1,al

	mov ah,01h
	int 21h
	mov %2,al

	mov ah,01h
	int 21h
	mov %3,al
%endmacro
;calcular el numero con los datos
%macro Calcular_Numero 3
	mov eax,%1
	mov ebx,10
	mul ebx
	add eax,%2
	mov %3,eax
%endmacro
;calcular numero sin afectar al 
%macro Calcular_Numero2 3
	mov edx,%1
	mov ebx,10
	mul ebx
	add edx,%2
	mov %3,edx
%endmacro
;multiplicar 2 numeros
%macro Multiplicar 2
	mov eax,%1
	mov ebx,%2
	mul ebx 
	mov %1,eax
%endmacro
;---------------------------------------------------------- Macros Para archivos -----------------------------------------------------------
;leer archivo seleccionado
%macro Leer_Archivo 3
    xor ax, ax
    xor cx, cx
    xor dx, dx

    mov ah, 3dh
    mov cx, 00
    mov dx, %1
    int 21h

    jc NO_Archivo

    mov bx, ax
    mov ah, 3fh
    mov cx, 255
    mov dx, [%2]
    int 21h

    mov [%3], ax
    mov ah, 3eh
    int 21h
%endmacro
;guardar archivo seleccionado
%macro Guardar_Archivo 3
    mov ah, 3ch
    mov cx, 0
    mov dx, %1
    int 21h
    jc NO_Archivo
    mov bx, ax
    mov ah, 3eh
    int 21h

    mov ah,3dh
    mov al,1h 
    mov dx, %1
    int 21h
    jc NO_Archivo
    mov bx,ax 
    mov cx,[%2]
    mov dx,%3
    mov ah,40h
    int 21h
    
    cmp cx,ax
    jne NO_Archivo
    mov ah,3eh
    int 21h
%endmacro
;---------------------------------------------------------- Macros Para concatenar-----------------------------------------------------------
;concatenar un Caracter
%macro Concatenar 3
	mov si, %1
	mov di, %2
	mov bx,%3
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
%endmacro
;---------------------------------------------------------- Macros Para ingreso-----------------------------------------------------------
%macro Ingreso_Variable 7
	Mensaje MsjSalto
	Mensaje %1
	Datos_Numero %2,[Decena],[Unidad]
	AsignarBL %3,[Contador]

	mov al,%2
	cmp al,43
	jl Numero_Invalido
	cmp al,44
	je Numero_Invalido
	cmp al,45
	jg Numero_Invalido
	AsignarBL %2,%4

	mov al,[Decena]
	cmp al,48
	jl Numero_Invalido
	cmp al,57
	jg Numero_Invalido
	AsignarBL [Decena],%5

	mov al,[Unidad]
	cmp al,48
	jl Numero_Invalido
	cmp al,57
	jg Numero_Invalido
	AsignarBL [Unidad],%6

	mov al,[Decena]
	sub al,30h
	mov [Decena],al

	mov al,[Unidad]
	sub al,30h
	mov [Unidad],al

	Calcular_Numero [Decena],[Unidad],%7
	call Ingresar_Siguiente
%endmacro
;Asignar valores para concatenar 
%macro Asignar_Seccion 5
	AsignarBL [DecenaAux],%1
	mov bl,[DecenaAux]
	sub bl,30h
	mov [DecenaAux],bl

	AsignarBL [UnidadAux],%2
	mov bl,[UnidadAux]
	sub bl,30h
	mov [UnidadAux],bl	
	AsignarBL [SignoAux],%3
	AsignarBL [SignoAux],%4
	Calcular_Numero [DecenaAux],[UnidadAux],%5
%endmacro
;----------------------------------------------------------- Macro para derivar ---------------------------------------------------------
%macro Derivar_Coeficiente 5
	mov eax,%1
	mov ebx,%2
	mul ebx
	mov %1,eax

	xor eax,eax
	xor ebx,ebx
	xor edx,edx

	mov eax,%1
	mov ebx,10
	div ebx 
	mov %1,eax
	mov [Unidad],edx

	mov al,[Unidad]
	add al,30h
	mov [Unidad],al
	AsignarAL [Unidad],%3

	mov al,%1
	aam 
	mov [Centena],ah
	mov [Decena],al 

	mov al,[Decena]
	add al,30h
	mov [Decena],al
	mov al,[Centena]
	add al,30h
	mov [Centena],al
	AsignarAL [Decena],%4
	AsignarAL [Centena],%5

	mov al,[Contador]
	add al,1
	mov [Contador],al
	call Derivar
%endmacro
;----------------------------------------------------------- Macro para integrar ---------------------------------------------------------
%macro Integrar_Coeficiente 5
	xor eax,eax
	xor ebx,ebx
	xor edx,edx

	mov eax,%1
	mov ebx,%2
	div ebx 
	mov %1,eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx

	mov eax,%1
	mov ebx,10
	div ebx 
	mov %1,eax
	mov [Unidad],edx

	mov al,[Unidad]
	add al,30h
	mov [Unidad],al
	AsignarAL [Unidad],%3

	mov al,%1
	aam 
	mov [Centena],ah
	mov [Decena],al 
	
	mov al,[Decena]
	add al,30h
	mov [Decena],al
	mov al,[Centena]
	add al,30h
	mov [Centena],al
	AsignarAL [Decena],%4
	AsignarAL [Centena],%5

	mov al,[Contador]
	add al,1
	mov [Contador],al
	call Integrar
%endmacro
;----------------------------------------------------------- Macros para memoria ---------------------------------------------------------
%macro Asignar_Posiciones 30
	AsignarBL %1,[Pos1]
	AsignarBL %2,[Pos2]
	AsignarBL %3,[Pos3]
	AsignarBL %4,[Pos4]
	AsignarBL %5,[Pos5]
	AsignarBL %6,[Pos6]
	AsignarBL %7,[Pos7]
	AsignarBL %8,[Pos8]
	AsignarBL %9,[Pos9]
	AsignarBL %10,[Pos10]
	AsignarBL %11,[Pos11]
	AsignarBL %12,[Pos12]
	AsignarBL %13,[Pos13]
	AsignarBL %14,[Pos14]
	AsignarBL %15,[Pos15]
	AsignarBL %16,[Pos16]
	AsignarBL %17,[Pos17]
	AsignarBL %18,[Pos18]
	AsignarBL %19,[Pos19]
	AsignarBL %20,[Pos20]
	AsignarBL %21,[Pos21]
	AsignarBL %22,[Pos22]
	AsignarBL %23,[Pos23]
	AsignarBL %24,[Pos24]
	AsignarBL %25,[Pos25]
	AsignarBL %26,[Pos26]
	AsignarBL %27,[Pos27]
	AsignarBL %28,[Pos28]
	AsignarBL %29,[Pos29]
	AsignarBL %30,[Pos30]
%endmacro
;Concatenar funcion
%macro Armar_Funcion 1
	Concatenar %1,Pos1,0
	Concatenar %1,Pos2,1
	Concatenar %1,Pos3,2
	Concatenar %1,Pos4,3
	Concatenar %1,Pos5,4
	Concatenar %1,Pos6,5
	Concatenar %1,Pos7,6
	Concatenar %1,Pos8,7
	Concatenar %1,Pos9,8
	Concatenar %1,Pos10,9
	Concatenar %1,Pos11,10
	Concatenar %1,Pos12,11
	Concatenar %1,Pos13,12
	Concatenar %1,Pos14,13
	Concatenar %1,Pos15,14
	Concatenar %1,Pos16,15
	Concatenar %1,Pos17,16
	Concatenar %1,Pos18,17
	Concatenar %1,Pos19,18
	Concatenar %1,Pos20,19
	Concatenar %1,Pos21,20
	Concatenar %1,Pos22,21
	Concatenar %1,Pos23,22
	Concatenar %1,Pos24,23
	Concatenar %1,Pos25,24
	Concatenar %1,Pos26,25
	Concatenar %1,Pos27,26
	Concatenar %1,Pos28,27
	Concatenar %1,Pos29,28
	Concatenar %1,Pos30,29
%endmacro
;----------------------------------------------------------- Macros para reporte ---------------------------------------------------------
%macro Concatenar_Puntos 40
	Concatenar RepFunciones,P1,%1
	Concatenar RepFunciones,Cero,%2
	Concatenar RepFunciones,Coma,%3
	Concatenar RepFunciones,CentenaConcatenar0,%4
	Concatenar RepFunciones,DecenaConcatenar0,%5
	Concatenar RepFunciones,UnidadConcatenar0,%6
	Concatenar RepFunciones,P2,%7
	Concatenar RepFunciones,PComa,%8

	Concatenar RepFunciones,P1,%9
	Concatenar RepFunciones,Uno,%10
	Concatenar RepFunciones,Coma,%11
	Concatenar RepFunciones,CentenaConcatenar1,%12
	Concatenar RepFunciones,DecenaConcatenar1,%13
	Concatenar RepFunciones,UnidadConcatenar1,%14
	Concatenar RepFunciones,P2,%15
	Concatenar RepFunciones,PComa,%16

	Concatenar RepFunciones,P1,%17
	Concatenar RepFunciones,Dos,%18
	Concatenar RepFunciones,Coma,%19
	Concatenar RepFunciones,CentenaConcatenar2,%20
	Concatenar RepFunciones,DecenaConcatenar2,%21
	Concatenar RepFunciones,UnidadConcatenar2,%22
	Concatenar RepFunciones,P2,%23
	Concatenar RepFunciones,PComa,%24

	Concatenar RepFunciones,P1,%25
	Concatenar RepFunciones,Tres,%26
	Concatenar RepFunciones,Coma,%27
	Concatenar RepFunciones,CentenaConcatenar3,%28
	Concatenar RepFunciones,DecenaConcatenar3,%29
	Concatenar RepFunciones,UnidadConcatenar3,%30
	Concatenar RepFunciones,P2,%31
	Concatenar RepFunciones,PComa,%32

	Concatenar RepFunciones,P1,%33
	Concatenar RepFunciones,Cuatro,%34
	Concatenar RepFunciones,Coma,%35
	Concatenar RepFunciones,CentenaConcatenar4,%36
	Concatenar RepFunciones,DecenaConcatenar4,%37
	Concatenar RepFunciones,UnidadConcatenar4,%38
	Concatenar RepFunciones,P2,%39
	AsignarCL %40 ,[Contador_Turno]
%endmacro 
;Mover punteros
%macro Asignar_Limites 4
	mov di, %1
	mov bx, %2
	mov eax,%3
	mov [Limite],eax
	AsignarCL %4 ,[Contador_Turno]
%endmacro
;----------------------------------------------------------- Macros para pintar ---------------------------------------------------------
%macro Pintar_Pixel 3
	mov es,word[startaddr]
	mov ax,%3

	mov di,%1
	add di,%2
	mov [es:di],ax
%endmacro

%macro Pintar_Coordenada 2
	mov eax,%1
	mov ebx,320
	mul ebx
	mov [CoorY],eax

	mov eax,[CoorY]
	sub eax,36800
	mov [CoorY],eax

	Pintar_Pixel %2,[CoorY],0Ch
%endmacro
;----------------------------------------------------------- Macros para puntos ---------------------------------------------------------
%macro DarValores 10
	AsignarAL %1,[SX4]
	AsignarAL %2,[X4]
	AsignarAL %3,[SX3]
	AsignarAL %4,[X3]
	AsignarAL %5,[SX2]
	AsignarAL %6,[X2]
	AsignarAL %7,[SX1]
	AsignarAL %8,[X1]
	AsignarAL %9,[SX0]
	AsignarAL %10,[X0]
%endmacro
;sin afectar al
%macro DarValores2 10
	AsignarBL %1,[SX4]
	AsignarBL %2,[X4]
	AsignarBL %3,[SX3]
	AsignarBL %4,[X3]
	AsignarBL %5,[SX2]
	AsignarBL %6,[X2]
	AsignarBL %7,[SX1]
	AsignarBL %8,[X1]
	AsignarBL %9,[SX0]
	AsignarBL %10,[X0]
%endmacro
;----------------------------------------------------------- Inicio del programa ---------------------------------------------------------
;Encabezado
Inicio:
	Mensaje Encabezado
	AsignarBL 0,[Caracteres_Leidos]
	call Menu_Principal
;--------------------------------------------------------- Menus de operaciones ----------------------------------------------------------
	Menu_Principal:
		mov al,[Bandera]
		cmp al,1
		je Ver_Operacion
		cmp al,2
		je Correr_Puntero

		Mensaje MsjSalto
		Mensaje MsjContinuar
		mov ah,01h ;Para poder visualizar la operacion
		int 21h

		mov ah,00h ;Para limpiar pantalla despues de cada operacion
		mov al,03h
		int 10h

		Mensaje Menu
		mov ah,01h
		int 21h
		cmp al,'1'
		AsignarBL 1,[Ope]
		je Ingreso_Manual
		cmp al,'2'
		AsignarBL 2,[Ope]
		je Ingreso_Manual
		cmp al,'3'
		AsignarBL 3,[Ope]
		je Menu_Ingreso
		cmp al,'4'
		je Memoria
		cmp al,'5'
		je Graficar
		cmp al,'6'
		AsignarBL 4,[Ope]
		je Ecuacion
		cmp al,'7'
		je Menu_Reportes
		cmp al,'8'
		je Salir
		jmp Error
	;Opcion de ingreso de funciones 
	Menu_Ingreso:
		Mensaje MsjSalto
		Mensaje MenuIng
		mov ah,01h ;Opcion Ingresada
		int 21h
		cmp al,'1'
		je Ingreso_Manual
		cmp al,'2'
		je Cargar
		cmp al,'3'
		je Menu_Principal
		jmp Error
	;Opcion de ingreso de reportes
	Menu_Reportes:
		Mensaje MsjSalto
		Mensaje MenuRep
		mov ah,01h ;Opcion Ingresada
		int 21h
		cmp al,'1'
		je Reporte_Funciones
		cmp al,'2'
		je Menu_Principal
		jmp Error
;--------------------------------------------------------- Derivada -------------------------------------------------------------------
	Derivar:
		mov al,[Contador]
		cmp al,0
		je Derivar4
		cmp al,1
		je Derivar3
		cmp al,2
		je Derivar2
		cmp al,3
		je Derivar1
		cmp al,4
		je Derivar0
		jmp Armar_Derivada
	Derivar4:
		Derivar_Coeficiente [NumeroX4],4,[UnidadConcatenar4],[DecenaConcatenar4],[CentenaConcatenar4]
	Derivar3:
		Derivar_Coeficiente [NumeroX3],3,[UnidadConcatenar3],[DecenaConcatenar3],[CentenaConcatenar3]
	Derivar2:
		Derivar_Coeficiente [NumeroX2],2,[UnidadConcatenar2],[DecenaConcatenar2],[CentenaConcatenar2]
	Derivar1:
		Derivar_Coeficiente [NumeroX1],1,[UnidadConcatenar1],[DecenaConcatenar1],[CentenaConcatenar1]
	Derivar0:
		Derivar_Coeficiente [NumeroX0],0,[UnidadConcatenar0],[DecenaConcatenar0],[CentenaConcatenar0]
	Armar_Derivada:
		AsignarAL 0,[Bandera]
		Mensaje MsjDerivada
		Asignar_Posiciones [SignoConcatenar4],[CentenaConcatenar4],[DecenaConcatenar4],[UnidadConcatenar4],[X],[Exponente],[Tres],[SignoConcatenar3],[CentenaConcatenar3],[DecenaConcatenar3],[UnidadConcatenar3],[X],[Exponente],[Dos],[SignoConcatenar2],[CentenaConcatenar2],[DecenaConcatenar2],[UnidadConcatenar2],[X],[SignoConcatenar1],[CentenaConcatenar1],[DecenaConcatenar1],[UnidadConcatenar1],[MsjSalto],[MsjSalto],[MsjSalto],[MsjSalto],[MsjSalto],[MsjSalto],[MsjSalto]
		DarValores [SignoX4],[NumeroX4],[SignoX3],[NumeroX3],[SignoX2],[NumeroX2],[SignoX1],[NumeroX1],[SignoX0],[NumeroX0]
		mov al,[Contador_Funciones]
		add al,1
		mov [Contador_Funciones],al
		call Calcular_Punto
;--------------------------------------------------------- Integral -------------------------------------------------------------------
	Integrar:
		mov al,[Contador]
		cmp al,0
		je Integrar4
		cmp al,1
		je Integrar3
		cmp al,2
		je Integrar2
		cmp al,3
		je Integrar1
		cmp al,4
		je Integrar0
		jmp Armar_Integral
	Integrar4:
		Integrar_Coeficiente [NumeroX4],5,[UnidadConcatenar4],[DecenaConcatenar4],[CentenaConcatenar4]
	Integrar3:
		Integrar_Coeficiente [NumeroX3],4,[UnidadConcatenar3],[DecenaConcatenar3],[CentenaConcatenar3]
	Integrar2:
		Integrar_Coeficiente [NumeroX2],3,[UnidadConcatenar2],[DecenaConcatenar2],[CentenaConcatenar2]
	Integrar1:
		Integrar_Coeficiente [NumeroX1],2,[UnidadConcatenar1],[DecenaConcatenar1],[CentenaConcatenar1]
	Integrar0:
		Integrar_Coeficiente [NumeroX0],1,[UnidadConcatenar0],[DecenaConcatenar0],[CentenaConcatenar0]
	Armar_Integral:
		AsignarAL 0,[Bandera]
		Mensaje MsjIntegral
		Asignar_Posiciones [SignoConcatenar4],[DecenaConcatenar4],[UnidadConcatenar4],[X],[Exponente],[Cinco],[SignoConcatenar3],[DecenaConcatenar3],[UnidadConcatenar3],[X],[Exponente],[Cuatro],[SignoConcatenar2],[DecenaConcatenar2],[UnidadConcatenar2],[X],[Exponente],[Tres],[SignoConcatenar1],[DecenaConcatenar1],[UnidadConcatenar1],[X],[Exponente],[Dos],[SignoConcatenar0],[DecenaConcatenar0],[UnidadConcatenar0],[X],[Mas],[C]
		DarValores [SignoX4],[NumeroX4],[SignoX3],[NumeroX3],[SignoX2],[NumeroX2],[SignoX1],[NumeroX1],[SignoX0],[NumeroX0]
		mov al,[Contador_Funciones]
		add al,1
		mov [Contador_Funciones],al
		call Calcular_Punto
;--------------------------------------------------------- Ingreso -------------------------------------------------------------------
	Ingreso_Manual:
		call Ingreso_Potencia4
	Ingreso_Potencia4:
		Ingreso_Variable MsjPotencia4,[SignoX4],1,[SignoConcatenar4],[DecenaConcatenar4],[UnidadConcatenar4],[NumeroX4]
	Ingreso_Potencia3:
		Ingreso_Variable MsjPotencia3,[SignoX3],2,[SignoConcatenar3],[DecenaConcatenar3],[UnidadConcatenar3],[NumeroX3]
	Ingreso_Potencia2:
		Ingreso_Variable MsjPotencia2,[SignoX2],3,[SignoConcatenar2],[DecenaConcatenar2],[UnidadConcatenar2],[NumeroX2]
	Ingreso_Potencia1:
		Ingreso_Variable MsjPotencia1,[SignoX1],4,[SignoConcatenar1],[DecenaConcatenar1],[UnidadConcatenar1],[NumeroX1]
	Ingreso_Potencia0:
		Ingreso_Variable MsjPotencia0,[SignoX0],5,[SignoConcatenar0],[DecenaConcatenar0],[UnidadConcatenar0],[NumeroX0]

	Ingresar_Siguiente:
		mov al,[Contador]
		cmp al,1
		je Ingreso_Potencia3
		cmp al,2
		je Ingreso_Potencia2
		cmp al,3
		je Ingreso_Potencia1
		cmp al,4
		je Ingreso_Potencia0
		cmp al,5
		je Asignar_Funcion
		jmp Menu_Principal

	Asignar_Funcion:
		AsignarAL 1,[Bandera]
		Mensaje MsjSalto
		Mensaje MsjIngreso
		Asignar_Posiciones [SignoConcatenar4],[DecenaConcatenar4],[UnidadConcatenar4],[X],[Exponente],[Cuatro],[SignoConcatenar3],[DecenaConcatenar3],[UnidadConcatenar3],[X],[Exponente],[Tres],[SignoConcatenar2],[DecenaConcatenar2],[UnidadConcatenar2],[X],[Exponente],[Dos],[SignoConcatenar1],[DecenaConcatenar1],[UnidadConcatenar1],[X],[SignoConcatenar0],[DecenaConcatenar0],[UnidadConcatenar0],[MsjSalto],[MsjSalto],[MsjSalto],[MsjSalto],[MsjSalto]
		DarValores [SignoX4],[NumeroX4],[SignoX3],[NumeroX3],[SignoX2],[NumeroX2],[SignoX1],[NumeroX1],[SignoX0],[NumeroX0]
		mov al,[Contador_Funciones]
		add al,1
		mov [Contador_Funciones],al
		call Calcular_Punto

	Numero_Invalido:
		Mensaje MsjError_Numero
		mov al,[Contador]
		cmp al,1
		je Ingreso_Potencia4
		cmp al,2
		je Ingreso_Potencia3
		cmp al,3
		je Ingreso_Potencia2
		cmp al,4
		je Ingreso_Potencia1
		cmp al,5
		je Ingreso_Potencia0

	Ver_Operacion:
		AsignarBL 0,[Contador]
		mov al,[Ope]
		cmp al,1
		je Derivar
		cmp al,2
		je Integrar
		cmp al,3
		je Cambiar_Bandera
		cmp al,4
		je Resolver_Ecuacion
		jmp Menu_Principal

	Cambiar_Bandera:
		AsignarBL 0,[Bandera]
		call Menu_Principal
;--------------------------------------------------------- Carga de archivo ---------------------------------------------------------
	Cargar:
		Leer_Archivo Ruta_Leer,Texto,Total_Caracteres
		mov si,[Texto]
		call Validar_Cadena

	Correr_Puntero:
		mov si,[Texto]
		mov bl,[Total_Caracteres]
		mov cl,[Caracteres_Leidos]
		cmp cl,bl 
		jge Cambiar_Bandera
		jl Igualar_Puntero

	Igualar_Puntero:
		mov bl,[Caracteres_Leidos]
		mov cl,[Tope]
		cmp cl,bl
		je Mos
		jne Mostrar

	Mos:
		lodsb
		lodsb
		lodsb
		mov bl,[Caracteres_Leidos]
		add bl,3
		mov [Caracteres_Leidos],bl
		call Validar_Cadena

	Mostrar:
		lodsb
		mov bl,[Tope]
		add bl,1
		mov [Tope],bl
		call Igualar_Puntero

	Validar_Cadena:
		lodsb
		cmp al,59
		je Ver_Final
		cmp al,48
		je Guardar_Numero
		cmp al,49
		je Guardar_Numero
		cmp al,50
		je Guardar_Numero
		cmp al,51
		je Guardar_Numero
		cmp al,52
		je Guardar_Numero
		cmp al,53
		je Guardar_Numero
		cmp al,54
		je Guardar_Numero
		cmp al,55
		je Guardar_Numero
		cmp al,56
		je Guardar_Numero
		cmp al,57
		je Guardar_Numero
		cmp al,120
		je Bloquear_Numero
		cmp al,45
		je Guardar_Signo
		cmp al,43
		je Guardar_Signo
		cmp al,'^'
		je Aumentar_Caracter
		jmp Caracter_Invalido

	Bloquear_Numero:
		mov bl,1
		mov [Bloqueo],bl
		call Aumentar_Caracter

	Aumentar_Caracter:
		mov bl,[Caracteres_Leidos]
		add bl,1
		mov [Caracteres_Leidos],bl
		call Validar_Cadena

	Guardar_Signo:
		mov bl,0
		mov [Bloqueo],bl

		mov bl,[Contador_Lugar]
		cmp bl,5
		je Asignar_Signo4
		cmp bl,4
		je Asignar_Signo3
		cmp bl,3
		je Asignar_Signo2
		cmp bl,2
		je Asignar_Signo1
		cmp bl,1
		je Asignar_Signo0

	Asignar_Signo4:
		mov [Caracter],al
		AsignarBL [Caracter],[SignoConcatenar4]
		AsignarBL 4,[Contador_Lugar]
		AsignarBL [Caracter],[SignoX4]
		call Aumentar_Caracter

	Asignar_Signo3:
		mov [Caracter],al
		AsignarBL [Caracter],[SignoConcatenar3]
		AsignarBL 3,[Contador_Lugar]
		AsignarBL [Caracter],[SignoX3]
		call Aumentar_Caracter

	Asignar_Signo2:
		mov [Caracter],al
		AsignarBL [Caracter],[SignoConcatenar2]
		AsignarBL 2,[Contador_Lugar]
		AsignarBL [Caracter],[SignoX2]
		call Aumentar_Caracter

	Asignar_Signo1:
		mov [Caracter],al
		AsignarBL [Caracter],[SignoConcatenar1]
		AsignarBL 1,[Contador_Lugar]
		AsignarBL [Caracter],[SignoX1]
		call Aumentar_Caracter

	Asignar_Signo0:
		mov [Caracter],al
		AsignarBL [Caracter],[SignoConcatenar0]
		AsignarBL 0,[Contador_Lugar]
		AsignarBL [Caracter],[SignoX0]
		call Aumentar_Caracter

	Guardar_Numero:
		mov cl,[Bloqueo]
		cmp cl,0
		je Lugar_Numero
		jne Aumentar_Caracter

	Lugar_Numero:
		mov cl,[Contador_Lugar]
		cmp cl,0
		je Asignar_Coeficiente0
		cmp cl,1
		je Asignar_Coeficiente1
		cmp cl,2
		je Asignar_Coeficiente2
		cmp cl,3
		je Asignar_Coeficiente3
		cmp cl,4
		je Asignar_Coeficiente4

	Asignar_Coeficiente0:
		mov cl,[Contador_Cantidad]
		cmp cl,2
		je Asignar_Decenas0
		jne Asignar_Unidades0

	Asignar_Decenas0:
		mov [Caracter],al
		AsignarBL [Caracter],[Decena]
		mov cl,[Decena]
		sub cl,30h
		mov [Decena],cl
		AsignarBL [Caracter],[DecenaConcatenar0]
		AsignarBL 1,[Contador_Cantidad]
		call Aumentar_Caracter 

	Asignar_Unidades0:
		mov [Caracter],al
		AsignarBL [Caracter],[Unidad]
		mov cl,[Unidad]
		sub cl,30h
		mov [Unidad],cl
		Calcular_Numero2 [Decena],[Unidad],[NumeroX0]
		AsignarBL [Caracter],[UnidadConcatenar0]
		AsignarBL 2,[Contador_Cantidad]
		call Aumentar_Caracter

	Asignar_Coeficiente1:
		mov cl,[Contador_Cantidad]
		cmp cl,2
		je Asignar_Decenas1
		jne Asignar_Unidades1

	Asignar_Decenas1:
		mov [Caracter],al
		AsignarBL [Caracter],[Decena]
		mov cl,[Decena]
		sub cl,30h
		mov [Decena],cl
		AsignarBL [Caracter],[DecenaConcatenar1]
		AsignarBL 1,[Contador_Cantidad]
		call Aumentar_Caracter 

	Asignar_Unidades1:
		mov [Caracter],al
		AsignarBL [Caracter],[Unidad]
		mov cl,[Unidad]
		sub cl,30h
		mov [Unidad],cl
		Calcular_Numero2 [Decena],[Unidad],[NumeroX1]
		AsignarBL [Caracter],[UnidadConcatenar1]
		AsignarBL 2,[Contador_Cantidad]
		call Aumentar_Caracter

	Asignar_Coeficiente2:
		mov cl,[Contador_Cantidad]
		cmp cl,2
		je Asignar_Decenas2
		jne Asignar_Unidades2

	Asignar_Decenas2:
		mov [Caracter],al
		AsignarBL [Caracter],[Decena]
		mov cl,[Decena]
		sub cl,30h
		mov [Decena],cl
		AsignarBL [Caracter],[DecenaConcatenar2]
		AsignarBL 1,[Contador_Cantidad]
		call Aumentar_Caracter 

	Asignar_Unidades2:
		mov [Caracter],al
		AsignarBL [Caracter],[Unidad]
		mov cl,[Unidad]
		sub cl,30h
		mov [Unidad],cl
		Calcular_Numero2 [Decena],[Unidad],[NumeroX2]
		AsignarBL [Caracter],[UnidadConcatenar2]
		AsignarBL 2,[Contador_Cantidad]
		call Aumentar_Caracter

	Asignar_Coeficiente3:
		mov cl,[Contador_Cantidad]
		cmp cl,2
		je Asignar_Decenas3
		jne Asignar_Unidades3

	Asignar_Decenas3:
		mov [Caracter],al
		AsignarBL [Caracter],[Decena]
		mov cl,[Decena]
		sub cl,30h
		mov [Decena],cl
		AsignarBL [Caracter],[DecenaConcatenar3]
		AsignarBL 1,[Contador_Cantidad]
		call Aumentar_Caracter 

	Asignar_Unidades3:
		mov [Caracter],al
		AsignarBL [Caracter],[Unidad]
		mov cl,[Unidad]
		sub cl,30h
		mov [Unidad],cl
		Calcular_Numero2 [Decena],[Unidad],[NumeroX3]
		AsignarBL [Caracter],[UnidadConcatenar3]
		AsignarBL 2,[Contador_Cantidad]
		call Aumentar_Caracter

	Asignar_Coeficiente4:
		mov cl,[Contador_Cantidad]
		cmp cl,2
		je Asignar_Decenas4
		jne Asignar_Unidades4

	Asignar_Decenas4:
		mov [Caracter],al
		AsignarBL [Caracter],[Decena]
		mov cl,[Decena]
		sub cl,30h
		mov [Decena],cl
		AsignarBL [Caracter],[DecenaConcatenar4]
		AsignarBL 1,[Contador_Cantidad]
		call Aumentar_Caracter 

	Asignar_Unidades4:
		mov [Caracter],al
		AsignarBL [Caracter],[Unidad]
		mov cl,[Unidad]
		sub cl,30h
		mov [Unidad],cl
		Calcular_Numero2 [Decena],[Unidad],[NumeroX4]
		AsignarBL [Caracter],[UnidadConcatenar4]
		AsignarBL 2,[Contador_Cantidad]
		call Aumentar_Caracter

	Ver_Final:
		mov bl,[Errores]
		cmp bl,0
		je Guardar_Carga
		jne Funcion_Invalida

	Guardar_Carga:
		Asignar_Posiciones [SignoConcatenar4],[DecenaConcatenar4],[UnidadConcatenar4],[X],[Exponente],[Cuatro],[SignoConcatenar3],[DecenaConcatenar3],[UnidadConcatenar3],[X],[Exponente],[Tres],[SignoConcatenar2],[DecenaConcatenar2],[UnidadConcatenar2],[X],[Exponente],[Dos],[SignoConcatenar1],[DecenaConcatenar1],[UnidadConcatenar1],[X],[SignoConcatenar0],[DecenaConcatenar4],[UnidadConcatenar0],[MsjSalto],[MsjSalto],[MsjSalto],[MsjSalto],[MsjSalto]
		DarValores2 [SignoX4],[NumeroX4],[SignoX3],[NumeroX3],[SignoX2],[NumeroX2],[SignoX1],[NumeroX1],[SignoX0],[NumeroX0]
		AsignarBL 5,[Contador_Lugar]
		AsignarBL 2,[Bandera]
		AsignarBL 0,[Tope]
		mov bl,[Contador_Funciones]
		add bl,1
		mov [Contador_Funciones],bl
		call Calcular_Punto

	Funcion_Invalida:
		AsignarBL 0,[Errores]
		Mensaje MsjFuncionInvalida
		call Cambiar_Bandera

	Caracter_Invalido:
		Mensaje MsjSalto
		Mensaje MsjCaracterInvalido
		mov [Caracter],al 
		mov ah,02h
		mov dl,[Caracter]
		int 21h
		mov bl,[Errores]
		add bl,1
		mov [Errores],bl
		call Funcion_Invalida

	NO_Archivo:
		Mensaje MsjSalto
		Mensaje MsjError_Archivo
		call Menu_Principal
;--------------------------------------------------------- Memoria del sistema ---------------------------------------------------------
	Memoria:
		mov al,[Contador_Funciones]
		cmp al,0
		je Memoria_Vacia
		jmp Mostrar_Memoria

	Memoria_Vacia:
		Mensaje MsjSalto
		Mensaje MsjMemoriaVacia
		call Menu_Principal

	Memoria_Llena:
		Mensaje MsjSalto
		Mensaje MsjMemoriaLlena
		call Menu_Principal

	Mostrar_Memoria:
		Mensaje MsjSalto
		Mensaje MsjMemoriaActual
		Mensaje Funcion1
		Mensaje Funcion2
		Mensaje Funcion3
		Mensaje Funcion4
		Mensaje Funcion5
		Mensaje Funcion6
		Mensaje Funcion7
		Mensaje Funcion8
		Mensaje Funcion9
		Mensaje Funcion10
		Mensaje Funcion11
		Mensaje Funcion12
		Mensaje Funcion13
		Mensaje Funcion14
		Mensaje Funcion15
		call Menu_Principal
;--------------------------------------------------------- Graficas del Sistema ---------------------------------------------------------
	Graficar:
		mov ah,00h ;Para limpiar pantalla despues de cada operacion
		mov al,03h
		int 10h

		mov ah,00h
		mov al,13h
		int 10h

		call Plano
	Plano:
		mov bx,3
		mov cx,9920
		call Plano_Horizontal
		call Pintar_Puntos

	Plano_Horizontal:
		Pintar_Pixel 36800,bx,0Fh
		inc bx
		cmp bx,317
		je Plano_Vertical
		jne Plano_Horizontal

	Plano_Vertical:
		Pintar_Pixel cx,160,0Fh
		add cx,320
		inc bx
		cmp bx,481
		jne Plano_Vertical
		ret

	Pintar_Puntos:
		mov al,[Contador_Actual]
		cmp al,0
		je PintarFun1
		cmp al,1
		je PintarFun2
		cmp al,2
		je PintarFun3
		cmp al,3
		je PintarFun4
		cmp al,4
		je PintarFun5
		cmp al,5
		je PintarFun6
		cmp al,6
		je PintarFun7
		cmp al,7
		je PintarFun8
		cmp al,8
		je PintarFun9
		cmp al,9
		je PintarFun10
		cmp al,10
		je PintarFun11
		cmp al,11
		je PintarFun12
		cmp al,12
		je PintarFun13
		cmp al,13
		je PintarFun14
		cmp al,14
		je PintarFun15
		jmp Resetear

	Ver_Direccion:
		mov ah,01h
		int 21h
		cmp al,'a'
		je Disminuir
		cmp al,'d'
		je Aumentar
		jmp Cambiar_Modo

	PintarFun1:
		Pintar_Coordenada [Punto11],161
		Pintar_Coordenada [Punto21],170
		Pintar_Coordenada [Punto31],143
		Pintar_Coordenada [Punto41],194
		Pintar_Coordenada [Punto51],155
		call Ver_Direccion

	PintarFun2:
		Pintar_Coordenada [Punto12],05
		Pintar_Coordenada [Punto22],18
		Pintar_Coordenada [Punto32],104
		Pintar_Coordenada [Punto42],185
		Pintar_Coordenada [Punto52],196
		call Ver_Direccion

	PintarFun3:
		Pintar_Coordenada [Punto13],14
		Pintar_Coordenada [Punto23],16
		Pintar_Coordenada [Punto33],33
		Pintar_Coordenada [Punto43],72
		Pintar_Coordenada [Punto53],188
		call Ver_Direccion

	PintarFun4:
		Pintar_Coordenada [Punto14],61
		Pintar_Coordenada [Punto24],41
		Pintar_Coordenada [Punto34],08
		Pintar_Coordenada [Punto44],99
		Pintar_Coordenada [Punto54],46
		call Ver_Direccion

	PintarFun5:
		Pintar_Coordenada [Punto15],78
		Pintar_Coordenada [Punto25],16
		Pintar_Coordenada [Punto35],87
		Pintar_Coordenada [Punto45],101
		Pintar_Coordenada [Punto55],166
		call Ver_Direccion

	PintarFun6:
		Pintar_Coordenada [Punto16],170
		Pintar_Coordenada [Punto26],94
		Pintar_Coordenada [Punto36],03
		Pintar_Coordenada [Punto46],71
		Pintar_Coordenada [Punto56],53
		call Ver_Direccion

	PintarFun7:
		Pintar_Coordenada [Punto17],55
		Pintar_Coordenada [Punto27],64
		Pintar_Coordenada [Punto37],79
		Pintar_Coordenada [Punto47],35
		Pintar_Coordenada [Punto57],77
		call Ver_Direccion

	PintarFun8:
		Pintar_Coordenada [Punto18],161
		Pintar_Coordenada [Punto28],162
		Pintar_Coordenada [Punto38],163
		Pintar_Coordenada [Punto48],164
		Pintar_Coordenada [Punto58],165
		call Ver_Direccion

	PintarFun9:
		Pintar_Coordenada [Punto19],161
		Pintar_Coordenada [Punto29],162
		Pintar_Coordenada [Punto39],163
		Pintar_Coordenada [Punto49],164
		Pintar_Coordenada [Punto59],165
		call Ver_Direccion

	PintarFun10:
		Pintar_Coordenada [Punto110],161
		Pintar_Coordenada [Punto210],162
		Pintar_Coordenada [Punto310],163
		Pintar_Coordenada [Punto410],164
		Pintar_Coordenada [Punto510],165
		call Ver_Direccion

	PintarFun11:
		Pintar_Coordenada [Punto111],161
		Pintar_Coordenada [Punto211],162
		Pintar_Coordenada [Punto311],163
		Pintar_Coordenada [Punto411],164
		Pintar_Coordenada [Punto511],165
		call Ver_Direccion

	PintarFun12:
		Pintar_Coordenada [Punto112],161
		Pintar_Coordenada [Punto212],162
		Pintar_Coordenada [Punto312],163
		Pintar_Coordenada [Punto412],164
		Pintar_Coordenada [Punto512],165
		call Ver_Direccion

	PintarFun13:
		Pintar_Coordenada [Punto113],161
		Pintar_Coordenada [Punto213],162
		Pintar_Coordenada [Punto313],163
		Pintar_Coordenada [Punto413],164
		Pintar_Coordenada [Punto513],165
		call Ver_Direccion

	PintarFun14:
		Pintar_Coordenada [Punto114],161
		Pintar_Coordenada [Punto214],162
		Pintar_Coordenada [Punto314],163
		Pintar_Coordenada [Punto414],164
		Pintar_Coordenada [Punto514],165
		call Ver_Direccion

	PintarFun15:
		Pintar_Coordenada [Punto115],161
		Pintar_Coordenada [Punto215],162
		Pintar_Coordenada [Punto315],163
		Pintar_Coordenada [Punto415],164
		Pintar_Coordenada [Punto515],165
		call Ver_Direccion

	Disminuir:
		mov al,[Contador_Actual]
		sub al,1
		mov [Contador_Actual],al 
		call Graficar
	Aumentar:
		mov al,[Contador_Actual]
		add al,1
		mov [Contador_Actual],al 
		call Graficar

	Cambiar_Modo:
		AsignarAL 0,[Contador_Actual]
		call Menu_Principal

	Resetear:
		AsignarAL 0,[Contador_Actual]
		call Pintar_Puntos
;--------------------------------------------------------- Resolucion de Ecuaciones ---------------------------------------------------------
	Ecuacion:
		AsignarAL 2,[Contador]
		call Ingreso_Potencia2

	Resolver_Ecuacion:
		AsignarAL 0,[Bandera]
		mov al,[Contador_Funciones]
		sub al,1
		mov [Contador_Funciones],al 

		mov al,[NumeroX2]
		cmp al,0
		je Resolver_Grado1
		jne Resolver_Grado2

	Resolver_Grado1:
		mov al,[NumeroX1]
		cmp al,0
		je Solucion_Imaginaria

		xor eax,eax
		xor ebx,ebx
		xor edx,edx

		mov eax,[NumeroX0]
		mov ebx,[NumeroX1]
		div ebx
		mov [SolG1],eax

		Mensaje MsjSolucionGrado1 
		
		mov al,[SignoX1]
		mov bl,[SignoX0]
		cmp al,bl
		jne Solucion_Positiva
		je Solucion_Negativa

	Solucion_Positiva:
		mov al,[SolG1]
		aam 
		mov [Decena],ah
		mov [Unidad],al 

		mov ah,02h
		mov dl,[Decena]
		add dl,30h
		int 21h

		mov ah,02h
		mov dl,[Unidad]
		add dl,30h
		int 21h
		call Menu_Principal

	Solucion_Negativa:
		mov ah,02h
		mov dl,45
		int 21h
		call Solucion_Positiva

	Resolver_Grado2:
		mov al,[NumeroX2]
		cmp al,0
		je Solucion_Imaginaria

		mov eax,[NumeroX1]
		mov ebx,[NumeroX1]
		mul ebx
		mov [P1SolG2],eax

		mov eax,[NumeroX2]
		mov ebx,[NumeroX0]
		mul ebx
		mov [P2SolG2],eax

		mov eax,[P2SolG2]
		mov ebx,4
		mul ebx
		mov [P2SolG2],eax

		mov al,[SignoX2]
		mov bl,[SignoX0]
		cmp al,bl
		je Restar_Partes
		jne Sumar_Partes

	Sumar_Partes:
		mov eax,[P1SolG2]
		add eax,[P2SolG2]
		mov [P1SolG2],eax
		call Mostrar_Solucion

	Restar_Partes:
		mov eax,[P1SolG2]
		sub eax,[P2SolG2]
		mov [P1SolG2],eax

		mov al,[P1SolG2]
		cmp al,0
		jl Solucion_Imaginaria
		jge Mostrar_Solucion

	Mostrar_Solucion:
		mov ah,02h
		mov dl,40
		int 21h

		mov ah,02h
		mov dl,45
		int 21h

		mov al,[NumeroX1]
		aam
		mov [Decena],ah
		mov [Unidad],al
		mov ah,02h
		mov dl,[Decena]
		add dl,30h
		int 21h
		mov ah,02h
		mov dl,[Unidad]
		add dl,30h
		int 21h

		mov ah,02h
		mov dl,241
		int 21h

		mov ah,02h
		mov dl,251
		int 21h

		mov al,[P1SolG2]
		aam
		mov [Decena],ah
		mov [Unidad],al
		mov ah,02h
		mov dl,[Decena]
		add dl,30h
		int 21h
		mov ah,02h
		mov dl,[Unidad]
		add dl,30h
		int 21h

		mov ah,02h
		mov dl,41
		int 21h

		mov ah,02h
		mov dl,47
		int 21h

		mov al,[NumeroX2]
		mov bl,2
		mul bl
		mov [P2SolG2],al 
		aam
		mov [Decena],ah
		mov [Unidad],al
		mov ah,02h
		mov dl,[Decena]
		add dl,30h
		int 21h
		mov ah,02h
		mov dl,[Unidad]
		add dl,30h
		int 21h

		call Menu_Principal

	Solucion_Imaginaria:
		Mensaje MsjSolucionImaginaria
		call Menu_Principal
;--------------------------------------------------------- Reporte de Funciones ---------------------------------------------------------
	Reporte_Funciones:
		mov si, RepFunciones
		mov cl,[Contador_Turno]
		cmp cl,0
		je ConEnc
		cmp cl,1
		je ConFunc1
		cmp cl,2
		je ConMem1
		cmp cl,3
		je ConPunt1
		cmp cl,4
		je ConMemPun1
		cmp cl,5
		je ConFunc2
		cmp cl,6
		je ConMem2
		cmp cl,7
		je ConPunt2
		cmp cl,8
		je ConMemPun2
		cmp cl,9
		je ConFunc3
		cmp cl,10
		je ConMem3
		cmp cl,11
		je ConPunt3
		cmp cl,12
		je ConMemPun3
		cmp cl,13
		je ConFunc4
		cmp cl,14
		je ConMem4
		cmp cl,15
		je ConPunt4
		cmp cl,16
		je ConMemPun4
		cmp cl,17
		je ConFunc5
		cmp cl,18
		je ConMem5
		cmp cl,19
		je ConPunt5
		cmp cl,20
		je ConMemPun5
		cmp cl,21
		je ConFunc6
		cmp cl,22
		je ConMem6
		cmp cl,23
		je ConPunt6
		cmp cl,24
		je ConMemPun6
		cmp cl,25
		je ConFunc7
		cmp cl,26
		je ConMem7
		cmp cl,27
		je ConPunt7
		cmp cl,28
		je ConMemPun7
		cmp cl,29
		je ConFunc8
		cmp cl,30
		je ConMem8
		cmp cl,31
		je ConPunt8
		cmp cl,32
		je ConMemPun8
		cmp cl,33
		je ConFunc9
		cmp cl,34
		je ConMem9
		cmp cl,35
		je ConPunt9
		cmp cl,36
		je ConMemPun9
		cmp cl,37
		je ConFunc10
		cmp cl,38
		je ConMem10
		cmp cl,39
		je ConPunt10
		cmp cl,40
		je ConMemPun10
		cmp cl,41
		je ConFunc11
		cmp cl,42
		je ConMem11
		cmp cl,43
		je ConPunt11
		cmp cl,44
		je ConMemPun11
		cmp cl,45
		je ConFunc12
		cmp cl,46
		je ConMem12
		cmp cl,47
		je ConPunt12
		cmp cl,48
		je ConMemPun12
		cmp cl,49
		je ConFunc13
		cmp cl,50
		je ConMem13
		cmp cl,51
		je ConPunt13
		cmp cl,52
		je ConMemPun13
		cmp cl,53
		je ConFunc14
		cmp cl,54
		je ConMem14
		cmp cl,55
		je ConPunt14
		cmp cl,56
		je ConMemPun14
		cmp cl,57
		je ConFunc15
		cmp cl,58
		je ConMem15
		cmp cl,59
		je ConPunt15
		cmp cl,60
		je ConMemPun15
		jmp Mos2

	ConEnc:
		Asignar_Limites Encabezado,0,252,1
		call RepEnc
	ConFunc1:
		Asignar_Limites MsjFuncion,252,261,2
		call RepEnc
	ConMem1:
		Asignar_Limites Funcion1,261,291,3
		call RepEnc
	ConPunt1:
		Asignar_Limites MsjPuntos,291,299,4
		call RepEnc
	ConMemPun1:
		Concatenar_Puntos 299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,5
		call Reporte_Funciones

	ConFunc2:
		Asignar_Limites MsjFuncion,338,347,6
		call RepEnc
	ConMem2:
		Asignar_Limites Funcion2,347,377,7
		call RepEnc
	ConPunt2:
		Asignar_Limites MsjPuntos,377,385,8
		call RepEnc
	ConMemPun2:
		Concatenar_Puntos 385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,9
		call Reporte_Funciones

	ConFunc3:
		Asignar_Limites MsjFuncion,424,433,10
		call RepEnc
	ConMem3:
		Asignar_Limites Funcion3,433,463,11
		call RepEnc
	ConPunt3:
		Asignar_Limites MsjPuntos,463,471,12
		call RepEnc
	ConMemPun3:
		Concatenar_Puntos 471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,13
		call Reporte_Funciones

	ConFunc4:
		Asignar_Limites MsjFuncion,510,519,14
		call RepEnc
	ConMem4:
		Asignar_Limites Funcion4,519,549,15
		call RepEnc
	ConPunt4:
		Asignar_Limites MsjPuntos,549,557,16
		call RepEnc
	ConMemPun4:
		Concatenar_Puntos 557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,17
		call Reporte_Funciones

	ConFunc5:
		Asignar_Limites MsjFuncion,596,605,18
		call RepEnc
	ConMem5:
		Asignar_Limites Funcion5,605,635,19
		call RepEnc
	ConPunt5:
		Asignar_Limites MsjPuntos,635,643,20
		call RepEnc
	ConMemPun5:
		Concatenar_Puntos 643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,21
		call Reporte_Funciones

	ConFunc6:
		Asignar_Limites MsjFuncion,682,691,22
		call RepEnc
	ConMem6:
		Asignar_Limites Funcion6,691,721,23
		call RepEnc
	ConPunt6:
		Asignar_Limites MsjPuntos,721,729,24
		call RepEnc
	ConMemPun6:
		Concatenar_Puntos 729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,25
		call Reporte_Funciones

	ConFunc7:
		Asignar_Limites MsjFuncion,768,777,26
		call RepEnc
	ConMem7:
		Asignar_Limites Funcion7,777,807,27
		call RepEnc
	ConPunt7:
		Asignar_Limites MsjPuntos,807,815,28
		call RepEnc
	ConMemPun7:
		Concatenar_Puntos 815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,29
		call Reporte_Funciones

	ConFunc8:
		Asignar_Limites MsjFuncion,854,863,30
		call RepEnc
	ConMem8:
		Asignar_Limites Funcion8,863,893,31
		call RepEnc
	ConPunt8:
		Asignar_Limites MsjPuntos,893,901,32
		call RepEnc
	ConMemPun8:
		Concatenar_Puntos 901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,33
		call Reporte_Funciones

	ConFunc9:
		Asignar_Limites MsjFuncion,940,949,34
		call RepEnc
	ConMem9:
		Asignar_Limites Funcion9,949,979,35
		call RepEnc
	ConPunt9:
		Asignar_Limites MsjPuntos,979,987,36
		call RepEnc
	ConMemPun9:
		Concatenar_Puntos 987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,37
		call Reporte_Funciones

	ConFunc10:
		Asignar_Limites MsjFuncion,1026,1035,38
		call RepEnc
	ConMem10:
		Asignar_Limites Funcion10,1035,1065,39
		call RepEnc
	ConPunt10:
		Asignar_Limites MsjPuntos,1065,1073,40
		call RepEnc
	ConMemPun10:
		Concatenar_Puntos 1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,41
		call Reporte_Funciones

	ConFunc11:
		Asignar_Limites MsjFuncion,1112,1121,42
		call RepEnc
	ConMem11:
		Asignar_Limites Funcion11,1121,1151,43
		call RepEnc
	ConPunt11:
		Asignar_Limites MsjPuntos,1151,1159,44
		call RepEnc
	ConMemPun11:
		Concatenar_Puntos 1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,1192,1193,1194,1195,1196,1197,45
		call Reporte_Funciones

	ConFunc12:
		Asignar_Limites MsjFuncion,1198,1207,46
		call RepEnc
	ConMem12:
		Asignar_Limites Funcion12,1207,1237,47
		call RepEnc
	ConPunt12:
		Asignar_Limites MsjPuntos,1237,1245,48
		call RepEnc
	ConMemPun12:
		Concatenar_Puntos 1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279,1280,1281,1282,1283,49
		call Reporte_Funciones

	ConFunc13:
		Asignar_Limites MsjFuncion,1284,1293,50
		call RepEnc
	ConMem13:
		Asignar_Limites Funcion13,1293,1323,51
		call RepEnc
	ConPunt13:
		Asignar_Limites MsjPuntos,1323,1331,52
		call RepEnc
	ConMemPun13:
		Concatenar_Puntos 1331,1332,1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343,1344,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361,1362,1363,1364,1365,1366,1367,1368,1369,53
		call Reporte_Funciones

	ConFunc14:
		Asignar_Limites MsjFuncion,1370,1379,54
		call RepEnc
	ConMem14:
		Asignar_Limites Funcion14,1379,1409,55
		call RepEnc
	ConPunt14:
		Asignar_Limites MsjPuntos,1409,1417,56
		call RepEnc
	ConMemPun14:
		Concatenar_Puntos 1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1428,1429,1430,1431,1432,1433,1434,1435,1436,1437,1438,1439,1440,1441,1442,1443,1444,1445,1446,1447,1448,1449,1450,1451,1452,1453,1454,1455,57
		call Reporte_Funciones

	ConFunc15:
		Asignar_Limites MsjFuncion,1456,1465,58
		call RepEnc
	ConMem15:
		Asignar_Limites Funcion15,1465,1495,59
		call RepEnc
	ConPunt15:
		Asignar_Limites MsjPuntos,1495,1503,60
		call RepEnc
	ConMemPun15:
		Concatenar_Puntos 1503,1504,1505,1506,1507,1508,1509,1510,1511,1512,1513,1514,1515,1516,1517,1518,1519,1520,1521,1522,1523,1524,1525,1526,1527,1528,1529,1530,1531,1532,1533,1534,1535,1536,1537,1538,1539,1540,1541,61
		call Reporte_Funciones

	RepEnc:
		mov cl,[handle]
		cmp cl,[Limite]
		jne AuEnc
		je Reporte_Funciones

	AuEnc:
		mov dl, [di]
		mov [si + bx], dl 
		inc bx
		inc di
		mov cl,[handle]
		add cl,1
		mov [handle],cl
		call RepEnc

	Mos2:
		AsignarAL 0,[Contador_Turno]
		Guardar_Archivo Ruta_Rep1,Longitud,RepFunciones
		Mensaje MsjExitoGuardado
		call Menu_Principal
;--------------------------------------------------------- Guardado de funciones ---------------------------------------------------------
	Guardar: 
		mov al,[Contador_Funciones]
		cmp al,1
		je Guardar_Funcion1
		cmp al,2
		je Guardar_Funcion2
		cmp al,3
		je Guardar_Funcion3
		cmp al,4
		je Guardar_Funcion4
		cmp al,5
		je Guardar_Funcion5
		cmp al,6
		je Guardar_Funcion6
		cmp al,7
		je Guardar_Funcion7
		cmp al,8
		je Guardar_Funcion8
		cmp al,9
		je Guardar_Funcion9
		cmp al,10
		je Guardar_Funcion10
		cmp al,11
		je Guardar_Funcion11
		cmp al,12
		je Guardar_Funcion12
		cmp al,13
		je Guardar_Funcion13
		cmp al,14
		je Guardar_Funcion14
		cmp al,15
		je Guardar_Funcion15
		jmp Memoria_Llena

	Guardar_Funcion1:
		Armar_Funcion Funcion1
		Mensaje Funcion1
		call Menu_Principal
	Guardar_Funcion2:
		Armar_Funcion Funcion2
		Mensaje Funcion2
		call Menu_Principal
	Guardar_Funcion3:
		Armar_Funcion Funcion3
		Mensaje Funcion3
		call Menu_Principal
	Guardar_Funcion4:
		Armar_Funcion Funcion4
		Mensaje Funcion4
		call Menu_Principal
	Guardar_Funcion5:
		Armar_Funcion Funcion5
		Mensaje Funcion5
		call Menu_Principal
	Guardar_Funcion6:
		Armar_Funcion Funcion6
		Mensaje Funcion6
		call Menu_Principal
	Guardar_Funcion7:
		Armar_Funcion Funcion7
		Mensaje Funcion7
		call Menu_Principal
	Guardar_Funcion8:
		Armar_Funcion Funcion8
		Mensaje Funcion8
		call Menu_Principal
	Guardar_Funcion9:
		Armar_Funcion Funcion9
		Mensaje Funcion9
		call Menu_Principal
	Guardar_Funcion10:
		Armar_Funcion Funcion10
		Mensaje Funcion10
		call Menu_Principal
	Guardar_Funcion11:
		Armar_Funcion Funcion11
		Mensaje Funcion11
		call Menu_Principal
	Guardar_Funcion12:
		Armar_Funcion Funcion12
		Mensaje Funcion12
		call Menu_Principal
	Guardar_Funcion13:
		Armar_Funcion Funcion13
		Mensaje Funcion13
		call Menu_Principal
	Guardar_Funcion14:
		Armar_Funcion Funcion14
		Mensaje Funcion14
		call Menu_Principal
	Guardar_Funcion15:
		Armar_Funcion Funcion15
		Mensaje Funcion15
		call Menu_Principal
;--------------------------------------------------------- Calculo de Puntos ----------------------------------------------------------
	Calcular_Punto:
		mov al,[Cont_Potencia]
		cmp al,0
		je ValCuarta
		cmp al,1
		je ValCubo
		cmp al,2
		je ValCuadrado
		cmp al,3
		je ValPrim
		cmp al,4
		je ValInde
		jmp Sacar_Valor

	ValCuarta:	
		AsignarAL 3,[Tope]
		AsignarAL [Numero],[NumAux]
		call SacarExp

	ValCubo:	
		AsignarAL 2,[Tope]
		AsignarAL [NumAux],[Cuarta]
		AsignarAL [Numero],[NumAux]
		call SacarExp

	ValCuadrado:	
		AsignarAL 1,[Tope]
		AsignarAL [NumAux],[Cubo]
		AsignarAL [Numero],[NumAux]
		call SacarExp

	ValPrim:		
		AsignarAL 0,[Tope]
		AsignarAL [NumAux],[Cuadrado]
		AsignarAL [Numero],[NumAux]
		call SigValor

	ValInde:	
		AsignarAL 0,[Tope]
		AsignarAL [NumAux],[Primera]
		AsignarAL 1,[NumAux]
		AsignarAL 1,[Inde]
		call SigValor

	SigValor:
		mov al,[Cont_Potencia]
		add al,1
		mov [Cont_Potencia],al
		call Calcular_Punto

	Sacar_Valor:
		Multiplicar [Cuarta],[X4]
		Multiplicar [Cubo],[X3]
		Multiplicar [Cuadrado],[X2]
		Multiplicar [Primera],[X1]
		Multiplicar [Inde],[X0]
		call Operar_Punto

	SacarExp:
		mov al,[Tope]
		mov bl,0
		cmp al,bl
		je SigValor

		Multiplicar [Numero],[NumAux]

		mov al,[Tope]
		sub al,1
		mov [Tope],al
		call SacarExp

	Operar_Punto:
		mov al,[Contador_Operacion]
		cmp al,0
		je Comparar43
		cmp al,1
		je Comparar2P
		cmp al,2
		je Comparar1P
		cmp al,3
		je Comparar0P
		jmp Mostrar_Punto

	Comparar43:
		mov al,[SX4]
		mov bl,[SX3]
		cmp al,bl
		je Aumentar_Ope4
		jne Comparar_Cantidades43

	Aumentar_Ope4:
		mov eax,[X4]
		add eax,[X3]
		mov [Punto],eax

		AsignarAL [SX4],[Signo_Punto]

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Comparar_Cantidades43:
		mov al,[X4]
		mov bl,[X3]
		cmp al,bl
		jge Resta431
		;je Valor_0
		jl Resta432

	Resta431:
		mov eax,[X4]
		sub eax,[X3]
		mov [Punto],eax

		AsignarAL [SX4],[Signo_Punto]

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Resta432:
		mov eax,[X3]
		sub eax,[X4]
		mov [Punto],eax

		AsignarAL [SX3],[Signo_Punto]
		
		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Comparar2P:
		mov al,[Signo_Punto]
		mov bl,[SX2]
		cmp al,bl
		je Aumentar_Ope2
		jne Comparar_CantidadesP2

	Aumentar_Ope2:
		mov eax,[Punto]
		add eax,[X2]
		mov [Punto],eax

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Comparar_CantidadesP2:
		mov al,[Punto]
		mov bl,[X2]
		cmp al,bl
		jge RestaP21
		;je Valor_0
		jl RestaP22

	RestaP21:
		mov eax,[Punto]
		sub eax,[X2]
		mov [Punto],eax

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	RestaP22:
		mov eax,[X2]
		sub eax,[Punto]
		mov [Punto],eax

		AsignarAL [SX2],[Signo_Punto]

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Comparar1P:
		mov al,[Signo_Punto]
		mov bl,[SX1]
		cmp al,bl
		je Aumentar_Ope1
		jne Comparar_CantidadesP1

	Aumentar_Ope1:
		mov eax,[Punto]
		add eax,[X1]
		mov [Punto],eax

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Comparar_CantidadesP1:
		mov al,[Punto]
		mov bl,[X1]
		cmp al,bl
		jge RestaP11
		;je Valor_0
		jl RestaP12

	RestaP11:
		mov eax,[Punto]
		sub eax,[X1]
		mov [Punto],eax

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	RestaP12:
		mov eax,[X1]
		sub eax,[Punto]
		mov [Punto],eax

		AsignarAL [SX1],[Signo_Punto]

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Comparar0P:
		mov al,[Signo_Punto]
		mov bl,[SX0]
		cmp al,bl
		je Aumentar_Ope0
		jne Comparar_CantidadesP0

	Aumentar_Ope0:
		mov eax,[Punto]
		add eax,[X0]
		mov [Punto],eax

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Comparar_CantidadesP0:
		mov al,[Punto]
		mov bl,[X0]
		cmp al,bl
		jge RestaP01
		;je Valor_0
		jl RestaP02

	RestaP01:
		mov eax,[Punto]
		sub eax,[X0]
		mov [Punto],eax

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	RestaP02:
		mov eax,[X0]
		sub eax,[Punto]
		mov [Punto],eax

		AsignarAL [SX0],[Signo_Punto]

		mov al,[Contador_Operacion]
		add al,1
		mov [Contador_Operacion],al
		call Operar_Punto

	Mostrar_Punto:
		AsignarAL 0,[Cont_Potencia]
		AsignarAL 0,[Contador_Operacion]
		DarValores [SignoX4],[NumeroX4],[SignoX3],[NumeroX3],[SignoX2],[NumeroX2],[SignoX1],[NumeroX1],[SignoX0],[NumeroX0]
		mov al,[Numero]
		add al,1
		mov [Numero],al
		cmp al,5
		je ResNum
		jl Guardar_Punto

	ResNum:
		AsignarAL 0,[Numero]
		call Guardar 
		
	Guardar_Punto:
		mov al,[ContGuardarPunto]
		cmp al,0
		je GP11
		cmp al,1
		je GP21
		cmp al,2
		je GP31
		cmp al,3
		je GP41
		cmp al,5
		je GP52
		cmp al,6
		je GP12
		cmp al,7
		je GP22
		cmp al,8
		je GP32
		cmp al,9
		je GP42
		cmp al,10
		je GP52
		cmp al,11
		je GP13
		cmp al,12
		je GP23
		cmp al,13
		je GP33
		cmp al,14
		je GP43
		cmp al,15
		je GP53
		cmp al,16
		je GP14
		cmp al,17
		je GP24
		cmp al,18
		je GP34
		cmp al,19
		je GP44
		cmp al,20
		je GP54
		cmp al,21
		je GP15
		cmp al,22
		je GP25
		cmp al,23
		je GP35
		cmp al,24
		je GP45
		cmp al,25
		je GP55
		cmp al,26
		je GP16
		cmp al,27
		je GP26
		cmp al,28
		je GP36
		cmp al,29
		je GP46
		cmp al,30
		je GP56
		cmp al,31
		je GP17
		cmp al,32
		je GP27
		cmp al,33
		je GP37
		cmp al,34
		je GP47
		cmp al,35
		je GP57
		cmp al,36
		je GP18
		cmp al,37
		je GP28
		cmp al,38
		je GP38
		cmp al,39
		je GP48
		cmp al,40
		je GP58
		cmp al,41
		je GP19
		cmp al,42
		je GP29
		cmp al,43
		je GP39
		cmp al,44
		je GP49
		cmp al,45
		je GP59
		cmp al,46
		je GP110
		cmp al,47
		je GP210
		cmp al,48
		je GP310
		cmp al,49
		je GP410
		cmp al,50
		je GP510
		cmp al,51
		je GP111
		cmp al,52
		je GP211
		cmp al,53
		je GP311
		cmp al,54
		je GP411
		cmp al,55
		je GP511
		cmp al,56
		je GP112
		cmp al,57
		je GP212
		cmp al,58
		je GP312
		cmp al,59
		je GP412
		cmp al,60
		je GP512
		cmp al,61
		je GP113
		cmp al,62
		je GP213
		cmp al,63
		je GP313
		cmp al,64
		je GP413
		cmp al,65
		je GP513
		cmp al,66
		je GP114
		cmp al,67
		je GP214
		cmp al,68
		je GP314
		cmp al,69
		je GP414
		cmp al,70
		je GP514
		cmp al,71
		je GP115
		cmp al,72
		je GP215
		cmp al,73
		je GP315
		cmp al,74
		je GP415
		cmp al,75
		je GP515
		jmp Guardar

	GP11:
		AsignarAL [Punto],[Punto11]
		AsignarAL [Signo_Punto],[SigPunto11]
		call AuContador
	GP21:
		AsignarAL [Punto],[Punto21]
		AsignarAL [Signo_Punto],[SigPunto21]
		call AuContador
	GP31:
		AsignarAL [Punto],[Punto31]
		AsignarAL [Signo_Punto],[SigPunto31]
		call AuContador
	GP41:
		AsignarAL [Punto],[Punto41]
		AsignarAL [Signo_Punto],[SigPunto41]
		call AuContador
	GP51:
		AsignarAL [Punto],[Punto51]
		AsignarAL [Signo_Punto],[SigPunto51]
		call AuContador

	GP12:
		AsignarAL [Punto],[Punto12]
		AsignarAL [Signo_Punto],[SigPunto12]
		call AuContador
	GP22:
		AsignarAL [Punto],[Punto22]
		AsignarAL [Signo_Punto],[SigPunto22]
		call AuContador
	GP32:
		AsignarAL [Punto],[Punto32]
		AsignarAL [Signo_Punto],[SigPunto32]
		call AuContador
	GP42:
		AsignarAL [Punto],[Punto42]
		AsignarAL [Signo_Punto],[SigPunto42]
		call AuContador
	GP52:
		AsignarAL [Punto],[Punto52]
		AsignarAL [Signo_Punto],[SigPunto52]
		call AuContador

	GP13:
		AsignarAL [Punto],[Punto13]
		AsignarAL [Signo_Punto],[SigPunto13]
		call AuContador
	GP23:
		AsignarAL [Punto],[Punto23]
		AsignarAL [Signo_Punto],[SigPunto23]
		call AuContador
	GP33:
		AsignarAL [Punto],[Punto33]
		AsignarAL [Signo_Punto],[SigPunto33]
		call AuContador
	GP43:
		AsignarAL [Punto],[Punto43]
		AsignarAL [Signo_Punto],[SigPunto43]
		call AuContador
	GP53:
		AsignarAL [Punto],[Punto53]
		AsignarAL [Signo_Punto],[SigPunto53]
		call AuContador

	GP14:
		AsignarAL [Punto],[Punto14]
		AsignarAL [Signo_Punto],[SigPunto14]
		call AuContador
	GP24:
		AsignarAL [Punto],[Punto24]
		AsignarAL [Signo_Punto],[SigPunto24]
		call AuContador
	GP34:
		AsignarAL [Punto],[Punto34]
		AsignarAL [Signo_Punto],[SigPunto34]
		call AuContador
	GP44:
		AsignarAL [Punto],[Punto44]
		AsignarAL [Signo_Punto],[SigPunto44]
		call AuContador
	GP54:
		AsignarAL [Punto],[Punto54]
		AsignarAL [Signo_Punto],[SigPunto54]
		call AuContador

	GP15:
		AsignarAL [Punto],[Punto15]
		AsignarAL [Signo_Punto],[SigPunto15]
		call AuContador
	GP25:
		AsignarAL [Punto],[Punto25]
		AsignarAL [Signo_Punto],[SigPunto25]
		call AuContador
	GP35:
		AsignarAL [Punto],[Punto35]
		AsignarAL [Signo_Punto],[SigPunto35]
		call AuContador
	GP45:
		AsignarAL [Punto],[Punto45]
		AsignarAL [Signo_Punto],[SigPunto45]
		call AuContador
	GP55:
		AsignarAL [Punto],[Punto55]
		AsignarAL [Signo_Punto],[SigPunto55]
		call AuContador

	GP16:
		AsignarAL [Punto],[Punto16]
		AsignarAL [Signo_Punto],[SigPunto16]
		call AuContador
	GP26:
		AsignarAL [Punto],[Punto26]
		AsignarAL [Signo_Punto],[SigPunto26]
		call AuContador
	GP36:
		AsignarAL [Punto],[Punto36]
		AsignarAL [Signo_Punto],[SigPunto36]
		call AuContador
	GP46:
		AsignarAL [Punto],[Punto46]
		AsignarAL [Signo_Punto],[SigPunto46]
		call AuContador
	GP56:
		AsignarAL [Punto],[Punto56]
		AsignarAL [Signo_Punto],[SigPunto56]
		call AuContador

	GP17:
		AsignarAL [Punto],[Punto17]
		AsignarAL [Signo_Punto],[SigPunto17]
		call AuContador
	GP27:
		AsignarAL [Punto],[Punto27]
		AsignarAL [Signo_Punto],[SigPunto27]
		call AuContador
	GP37:
		AsignarAL [Punto],[Punto37]
		AsignarAL [Signo_Punto],[SigPunto37]
		call AuContador
	GP47:
		AsignarAL [Punto],[Punto47]
		AsignarAL [Signo_Punto],[SigPunto47]
		call AuContador
	GP57:
		AsignarAL [Punto],[Punto57]
		AsignarAL [Signo_Punto],[SigPunto57]
		call AuContador

	GP18:
		AsignarAL [Punto],[Punto18]
		AsignarAL [Signo_Punto],[SigPunto18]
		call AuContador
	GP28:
		AsignarAL [Punto],[Punto28]
		AsignarAL [Signo_Punto],[SigPunto28]
		call AuContador
	GP38:
		AsignarAL [Punto],[Punto38]
		AsignarAL [Signo_Punto],[SigPunto38]
		call AuContador
	GP48:
		AsignarAL [Punto],[Punto48]
		AsignarAL [Signo_Punto],[SigPunto48]
		call AuContador
	GP58:
		AsignarAL [Punto],[Punto58]
		AsignarAL [Signo_Punto],[SigPunto58]
		call AuContador

	GP19:
		AsignarAL [Punto],[Punto19]
		AsignarAL [Signo_Punto],[SigPunto19]
		call AuContador
	GP29:
		AsignarAL [Punto],[Punto29]
		AsignarAL [Signo_Punto],[SigPunto29]
		call AuContador
	GP39:
		AsignarAL [Punto],[Punto39]
		AsignarAL [Signo_Punto],[SigPunto39]
		call AuContador
	GP49:
		AsignarAL [Punto],[Punto49]
		AsignarAL [Signo_Punto],[SigPunto49]
		call AuContador
	GP59:
		AsignarAL [Punto],[Punto59]
		AsignarAL [Signo_Punto],[SigPunto59]
		call AuContador

	GP110:
		AsignarAL [Punto],[Punto110]
		AsignarAL [Signo_Punto],[SigPunto110]
		call AuContador
	GP210:
		AsignarAL [Punto],[Punto210]
		AsignarAL [Signo_Punto],[SigPunto210]
		call AuContador
	GP310:
		AsignarAL [Punto],[Punto310]
		AsignarAL [Signo_Punto],[SigPunto310]
		call AuContador
	GP410:
		AsignarAL [Punto],[Punto410]
		AsignarAL [Signo_Punto],[SigPunto410]
		call AuContador
	GP510:
		AsignarAL [Punto],[Punto510]
		AsignarAL [Signo_Punto],[SigPunto510]
		call AuContador

	GP111:
		AsignarAL [Punto],[Punto111]
		AsignarAL [Signo_Punto],[SigPunto111]
		call AuContador
	GP211:
		AsignarAL [Punto],[Punto211]
		AsignarAL [Signo_Punto],[SigPunto211]
		call AuContador
	GP311:
		AsignarAL [Punto],[Punto311]
		AsignarAL [Signo_Punto],[SigPunto311]
		call AuContador
	GP411:
		AsignarAL [Punto],[Punto411]
		AsignarAL [Signo_Punto],[SigPunto411]
		call AuContador
	GP511:
		AsignarAL [Punto],[Punto511]
		AsignarAL [Signo_Punto],[SigPunto511]
		call AuContador
	
	GP112:
		AsignarAL [Punto],[Punto112]
		AsignarAL [Signo_Punto],[SigPunto112]
		call AuContador
	GP212:
		AsignarAL [Punto],[Punto212]
		AsignarAL [Signo_Punto],[SigPunto212]
		call AuContador
	GP312:
		AsignarAL [Punto],[Punto312]
		AsignarAL [Signo_Punto],[SigPunto312]
		call AuContador
	GP412:
		AsignarAL [Punto],[Punto412]
		AsignarAL [Signo_Punto],[SigPunto412]
		call AuContador
	GP512:
		AsignarAL [Punto],[Punto512]
		AsignarAL [Signo_Punto],[SigPunto512]
		call AuContador

	GP113:
		AsignarAL [Punto],[Punto113]
		AsignarAL [Signo_Punto],[SigPunto113]
		call AuContador
	GP213:
		AsignarAL [Punto],[Punto213]
		AsignarAL [Signo_Punto],[SigPunto213]
		call AuContador
	GP313:
		AsignarAL [Punto],[Punto313]
		AsignarAL [Signo_Punto],[SigPunto313]
		call AuContador
	GP413:
		AsignarAL [Punto],[Punto413]
		AsignarAL [Signo_Punto],[SigPunto413]
		call AuContador
	GP513:
		AsignarAL [Punto],[Punto513]
		AsignarAL [Signo_Punto],[SigPunto513]
		call AuContador

	GP114:
		AsignarAL [Punto],[Punto114]
		AsignarAL [Signo_Punto],[SigPunto114]
		call AuContador
	GP214:
		AsignarAL [Punto],[Punto214]
		AsignarAL [Signo_Punto],[SigPunto214]
		call AuContador
	GP314:
		AsignarAL [Punto],[Punto314]
		AsignarAL [Signo_Punto],[SigPunto314]
		call AuContador
	GP414:
		AsignarAL [Punto],[Punto414]
		AsignarAL [Signo_Punto],[SigPunto414]
		call AuContador
	GP514:
		AsignarAL [Punto],[Punto514]
		AsignarAL [Signo_Punto],[SigPunto514]
		call AuContador

	GP115:
		AsignarAL [Punto],[Punto115]
		AsignarAL [Signo_Punto],[SigPunto115]
		call AuContador
	GP215:
		AsignarAL [Punto],[Punto215]
		AsignarAL [Signo_Punto],[SigPunto215]
		call AuContador
	GP315:
		AsignarAL [Punto],[Punto315]
		AsignarAL [Signo_Punto],[SigPunto315]
		call AuContador
	GP415:
		AsignarAL [Punto],[Punto415]
		AsignarAL [Signo_Punto],[SigPunto415]
		call AuContador
	GP515:
		AsignarAL [Punto],[Punto515]
		AsignarAL [Signo_Punto],[SigPunto515]
		call AuContador

	AuContador:
		mov al,[ContGuardarPunto]
		add al,1
		mov [ContGuardarPunto],al 
		call Calcular_Punto 
;--------------------------------------------------------- Salida del programa ----------------------------------------------------------
Salir:
	Mensaje MsjSalto
	Mensaje MsjSalir
	mov ax,4c00h
	int 21h	
;--------------------------------------------------------- Error en la opcion ----------------------------------------------------------
Error:
	Mensaje MsjSalto
	Mensaje MsjError
	call Menu_Principal
;------------------------------------------------------------ Datos Utilizados ----------------------------------------------------------
section data
;Encabezado
	Encabezado db 'Universidad de San Carlos de Guatemala',13,10,
		       db 'Facultad de Ingenieria',13,10,
		       db 'Escuela de Ciencias y Sistemas',13,10
		       db 'Arquitectura de Compiladores y Ensambladores 1 Seccion A',13,10
	  	       db 'Primer Semestre 2018',13,10,
		       db 'Francisco Ernesto Carvajal Castillo',13,10,
		       db '201504325',13,10
	 	       db 'Segundo Proyecto',13,10,
		       db '14/05/2018',13,10,
	 	       db ' ',13,10,'$'
	;Menu principal
	Menu db '1.Derivar funcion.',13,10,
	     db '2.Integrar funcion.',13,10,
		 db '3.Ingresar funcion.',13,10,
		 db '4.Mostar funcion(es) en memoria.',13,10,
		 db '5.Graficar.',13,10,
		 db '6.Resolver ecuacion.',13,10,
		 db '7.Reportes.',13,10,
		 db '8.Salir.',13,10,'$'
	;Menu de ingreso
	MenuIng db '1.Ingreso Manual.',13,10,
	        db '2.Ingreso por archivo.',13,10,
		    db '3.Regresar.',13,10,'$'
	;Menu de reportes 
	MenuRep db '1.Reporte de funciones.',13,10,
    	  db '2.Regresar.',13,10,'$'
	;Mensajes varios
	MsjSalto db ' ',13,10,'$';salto de linea
	MsjContinuar db 'Presione cualquier tecla para continuar.',13,10,'$';Pausa para visualizar resultados
	MsjError db 'El valor ingresado no es valido para realizar la operacion, ingrese de nuevo los valores.',13,10,'$';Mensaje de notificacion de error
	MsjSalir db 'Gracias por usar este programa.',13,10,'$';mensaje de salida
	Contador_Funciones db 0 ;Funcion actual en memoria
	Ope db 0 ;Operacion actual
	Tipo db 0;Tipo de funcion 
;----------------------------------------------------------- Datos para derivar/integrar ----------------------------------------------------------
MsjDerivada db 'La derivada de la funcion es:',13,10,'$' ;Mensaje resultado de derivada 
MsjIntegral db 'La integral de la funcion es:',13,10,'$' ;Mensaje de resultado de integral 
NumAux dd 0 ;Numero para utilizar si no se quiere cambiar un valor 
Potencia dd 0 ;Potencia actual 
;----------------------------------------------------------- Datos para calculo ----------------------------------------------------------
Cont_Potencia db 0 ;Ve el exponente a calcular 
Contador_Operacion db 0 ;Operacion con el coeficiente 
Tope dd 0 ;veces que multiplicar 
Signo_Punto dd 0 ;Signo final 
Punto dd 0 ;Valor final 
Numero dd 0 ;Numero a valuar 
Cuarta dd 0 ;Resultado cuarta 
Cubo dd 0 ;resultado cubo 
Cuadrado dd 0 ;resultado cuadrado 
Primera dd 0 ;resultado primer 
Inde dd 0 ;resultado independiente
;signos de coeficientes
SX4 dd 0 
SX3 dd 0
SX2 dd 0
SX1 dd 0
SX0 dd 0
;Valores de coeficientes
X4 dd 0
X3 dd 0
X2 dd 0
X1 dd 0
X0 dd 0
;----------------------------------------------------------- Datos para ingreso ----------------------------------------------------------
MsjIngreso db 'La funcion ingresada es:',13,10,'$' ;Mensaje de ingreso 
;Mensajes de valores
	MsjPotencia4 db 'Ingrese el valor para x^4:',13,10,'$'
	MsjPotencia3 db 'Ingrese el valor para x^3:',13,10,'$'
	MsjPotencia2 db 'Ingrese el valor para x^2:',13,10,'$'
	MsjPotencia1 db 'Ingrese el valor para x^1:',13,10,'$'
	MsjPotencia0 db 'Ingrese el valor para x^0:',13,10,'$'
	MsjError_Numero db 'Numero no valido, ingrese de nuevo.',13,10,'$'
	;Contador de Posicion
	Contador db 0
	;Datos de numeros
	Centena dd 0
	Decena dd 0
	Unidad dd 0
	;Coeficientes
	SignoX4 db 0
	NumeroX4 dd 0
	SignoX3 db 0
	NumeroX3 dd 0
	SignoX2 db 0
	NumeroX2 dd 0
	SignoX1 db 0
	NumeroX1 dd 0
	SignoX0 db 0
	NumeroX0 dd 0
	;Concatencacion X4
	SignoConcatenar4 db '+',13,10,'$'
	CentenaConcatenar4 db '0',13,10,'$'
	DecenaConcatenar4 db '0',13,10,'$'
	UnidadConcatenar4 db '0',13,10,'$'
	;Concatencacion X3
	SignoConcatenar3 db '+',13,10,'$'
	CentenaConcatenar3 db '0',13,10,'$'
	DecenaConcatenar3 db '0',13,10,'$'
	UnidadConcatenar3 db '0',13,10,'$'
	;Concatencacion X2
	SignoConcatenar2 db '+',13,10,'$'
	CentenaConcatenar2 db '0',13,10,'$'
	DecenaConcatenar2 db '0',13,10,'$'
	UnidadConcatenar2 db '0',13,10,'$'
	;Concatencacion X1
	SignoConcatenar1 db '+',13,10,'$'
	CentenaConcatenar1 db '0',13,10,'$'
	DecenaConcatenar1 db '0',13,10,'$'
	UnidadConcatenar1 db '0',13,10,'$'
	;Concatencacion X0
	SignoConcatenar0 db '',13,10,'$'
	CentenaConcatenar0 db '0',13,10,'$'
	DecenaConcatenar0 db '0',13,10,'$'
	UnidadConcatenar0 db '0',13,10,'$'
	;Valores individuales para concatenar 
	X db 'x',13,10,'$'
	Mas db '+',13,10,'$'
	C db 'c',13,10,'$'
	Exponente db '^',13,10,'$'
	P1 db '(',13,10,'$'
	P2 db ')',13,10,'$'
	Coma db ',',13,10,'$'
	PComa db ';',13,10,'$'
	Uno db '1',13,10,'$'
	Dos db '2',13,10,'$'
	Tres db '3',13,10,'$'
	Cuatro db '4',13,10,'$'
	Cinco db '5',13,10,'$'
	Seia db '6',13,10,'$'
	Siete db '7',13,10,'$'
	Ocho db '8',13,10,'$'
	Nueve db '9',13,10,'$'
	Cero db '0',13,10,'$'
;----------------------------------------------------------- Memoria ----------------------------------------------------------
;Valores de memoria
	MsjMemoriaVacia db 'La memoria esta vacia, no se ha echo ninguna operacion.',13,10,'$'
	MsjMemoriaLlena db 'La memoria esta llena, no se podran guardar mas funciones.',13,10,'$'
	MsjMemoriaActual db 'Las funciones que se han ingresado en el sistema son:',13,10,'$'
	Bandera db 0 ;Bandera para ciertas operaciones 
	ContGuardarPunto db 0 ;VerDondeGuardar
	;Funciones disponibles en el sistema
	Funcion1 db '                              ',13,10,'$'
	Funcion2 db '                              ',13,10,'$'
	Funcion3 db '                              ',13,10,'$'
	Funcion4 db '                              ',13,10,'$'
	Funcion5 db '                              ',13,10,'$'
	Funcion6 db '                              ',13,10,'$'
	Funcion7 db '                              ',13,10,'$'
	Funcion8 db '                              ',13,10,'$'
	Funcion9 db '                              ',13,10,'$'
	Funcion10 db '                              ',13,10,'$'
	Funcion11 db '                              ',13,10,'$'
	Funcion12 db '                              ',13,10,'$'
	Funcion13 db '                              ',13,10,'$'
	Funcion14 db '                              ',13,10,'$'
	Funcion15 db '                              ',13,10,'$'
	;Posiciones de un texto 
	Pos1 db ' ',13,10,'$'
	Pos2 db ' ',13,10,'$'
	Pos3 db ' ',13,10,'$'
	Pos4 db ' ',13,10,'$'
	Pos5 db ' ',13,10,'$'
	Pos6 db ' ',13,10,'$'
	Pos7 db ' ',13,10,'$'
	Pos8 db ' ',13,10,'$'
	Pos9 db ' ',13,10,'$'
	Pos10 db ' ',13,10,'$'
	Pos11 db ' ',13,10,'$'
	Pos12 db ' ',13,10,'$'
	Pos13 db ' ',13,10,'$'
	Pos14 db ' ',13,10,'$'
	Pos15 db ' ',13,10,'$'
	Pos16 db ' ',13,10,'$'
	Pos17 db ' ',13,10,'$'
	Pos18 db ' ',13,10,'$'
	Pos19 db ' ',13,10,'$'
	Pos20 db ' ',13,10,'$'
	Pos21 db ' ',13,10,'$'
	Pos22 db ' ',13,10,'$'
	Pos23 db ' ',13,10,'$'
	Pos24 db ' ',13,10,'$'
	Pos25 db ' ',13,10,'$'
	Pos26 db ' ',13,10,'$'
	Pos27 db ' ',13,10,'$'
	Pos28 db ' ',13,10,'$'
	Pos29 db ' ',13,10,'$'
	Pos30 db ' ',13,10,'$'
	Pos31 db ' ',13,10,'$'
	;Valores de puntos
	Punto11 dd 0
	Punto21 dd 0
	Punto31 dd 0
	Punto41 dd 0
	Punto51 dd 0
	Punto12 dd 0
	Punto22 dd 0
	Punto32 dd 0
	Punto42 dd 0
	Punto52 dd 0
	Punto13 dd 0
	Punto23 dd 0
	Punto33 dd 0
	Punto43 dd 0
	Punto53 dd 0
	Punto14 dd 0
	Punto24 dd 0
	Punto34 dd 0
	Punto44 dd 0
	Punto54 dd 0
	Punto15 dd 0
	Punto25 dd 0
	Punto35 dd 0
	Punto45 dd 0
	Punto55 dd 0
	Punto16 dd 0
	Punto26 dd 0
	Punto36 dd 0
	Punto46 dd 0
	Punto56 dd 0
	Punto17 dd 0
	Punto27 dd 0
	Punto37 dd 0
	Punto47 dd 0
	Punto57 dd 0
	Punto18 dd 0
	Punto28 dd 0
	Punto38 dd 0
	Punto48 dd 0
	Punto58 dd 0
	Punto19 dd 0
	Punto29 dd 0
	Punto39 dd 0
	Punto49 dd 0
	Punto59 dd 0
	Punto110 dd 0
	Punto210 dd 0
	Punto310 dd 0
	Punto410 dd 0
	Punto510 dd 0
	Punto111 dd 0
	Punto211 dd 0
	Punto311 dd 0
	Punto411 dd 0
	Punto511 dd 0
	Punto112 dd 0
	Punto212 dd 0
	Punto312 dd 0
	Punto412 dd 0
	Punto512 dd 0
	Punto113 dd 0
	Punto213 dd 0
	Punto313 dd 0
	Punto413 dd 0
	Punto513 dd 0
	Punto114 dd 0
	Punto214 dd 0
	Punto314 dd 0
	Punto414 dd 0
	Punto514 dd 0
	Punto115 dd 0
	Punto215 dd 0
	Punto315 dd 0
	Punto415 dd 0
	Punto515 dd 0
	;signos Puntos
	SigPunto11 dd 0
	SigPunto21 dd 0
	SigPunto31 dd 0
	SigPunto41 dd 0
	SigPunto51 dd 0
	SigPunto12 dd 0
	SigPunto22 dd 0
	SigPunto32 dd 0
	SigPunto42 dd 0
	SigPunto52 dd 0
	SigPunto13 dd 0
	SigPunto23 dd 0
	SigPunto33 dd 0
	SigPunto43 dd 0
	SigPunto53 dd 0
	SigPunto14 dd 0
	SigPunto24 dd 0
	SigPunto34 dd 0
	SigPunto44 dd 0
	SigPunto54 dd 0
	SigPunto15 dd 0
	SigPunto25 dd 0
	SigPunto35 dd 0
	SigPunto45 dd 0
	SigPunto55 dd 0
	SigPunto16 dd 0
	SigPunto26 dd 0
	SigPunto36 dd 0
	SigPunto46 dd 0
	SigPunto56 dd 0
	SigPunto17 dd 0
	SigPunto27 dd 0
	SigPunto37 dd 0
	SigPunto47 dd 0
	SigPunto57 dd 0
	SigPunto18 dd 0
	SigPunto28 dd 0
	SigPunto38 dd 0
	SigPunto48 dd 0
	SigPunto58 dd 0
	SigPunto19 dd 0
	SigPunto29 dd 0
	SigPunto39 dd 0
	SigPunto49 dd 0
	SigPunto59 dd 0
	SigPunto110 dd 0
	SigPunto210 dd 0
	SigPunto310 dd 0
	SigPunto410 dd 0
	SigPunto510 dd 0
	SigPunto111 dd 0
	SigPunto211 dd 0
	SigPunto311 dd 0
	SigPunto411 dd 0
	SigPunto511 dd 0
	SigPunto112 dd 0
	SigPunto212 dd 0
	SigPunto312 dd 0
	SigPunto412 dd 0
	SigPunto512 dd 0
	SigPunto113 dd 0
	SigPunto213 dd 0
	SigPunto313 dd 0
	SigPunto413 dd 0
	SigPunto513 dd 0
	SigPunto114 dd 0
	SigPunto214 dd 0
	SigPunto314 dd 0
	SigPunto414 dd 0
	SigPunto514 dd 0
	SigPunto115 dd 0
	SigPunto215 dd 0
	SigPunto315 dd 0
	SigPunto415 dd 0
	SigPunto515 dd 0
;----------------------------------------------------------- Datos para ecuaciones ----------------------------------------------------------
MsjSolucionImaginaria db 'La ecuacion tiene una solucion imaginaria.',13,10,'$' ;Mensaje de solucion imaginaria
MsjSolucionGrado1 db 'La solucion para la ecuacion de grado 1 es:',13,10,'$' ;Mensaje solucion grado 1
MsjSolucionGrado2 db 'La solucion para la ecuacion de grado 2 es:',13,10,'$' ; Mensaje solucion grado 2
;Datos de soluciones 
SolG1 dd 0
P1SolG2 dd 0
P2SolG2 dd 0
;----------------------------------------------------------- Datos para Carga/Reportes ----------------------------------------------------------
MsjCaracterInvalido db 'Se encontro un caracter que no es valido, o no esta en la posicion correcta:',13,10,'$' ;Caracter invalido 
MsjFuncionInvalida db 'Se cargo una funcion con errores, por lo tanto no se guardara en memoria.',13,10,'$' ;Carga con errores 
MsjError_Archivo db 'Hubo falla en la lectura/escritura del archivo.',13,10,'$' ;Error en archivo
MsjExitoGuardado db 'Se guardo el archivo con exito',13,10,'$' ;Mensaje de guardado 
;Textos para el reporte 
MsjFuncion db 'Funcion: ',13,10,'$'
MsjPuntos db 'Puntos: ',13,10,'$'
RepFunciones: times 8430 db "$" ;Texto del reporte 
;Valores auxiliares 
SignoAux db 0
DecenaAux dd 0
UnidadAux dd 0
;Valores para el reporte 
Contador_Turno db 0 ;Posicion acutal del reporte 
handle dd 0 ;puntero 
Limite dd 0 ;Tope de la cocatenacion 
Longitud dd 1541 ;Caracteres a guardar 
startaddr dw 0A000h ;Valor para modo video

CoorY dd 0 ;Coordenada a pintar en el plano
CoorX dd 0 ;Coordenada a pintar en el plano
Contador_Actual db 0 ;Puntos actuales en pantalla
Bloqueo db 0 ;para que no guarde numeros inncesarios
Contador_Cantidad db 2 ;contador de cantidades 
Contador_Lugar db 5 ;Contador de exponenete 
Ruta_Leer: dw "Prueba.txt",0 ;nombre del archivo de prueba 
Ruta_Rep1: db "Funciones.rep",0 ;Nombre del reporte 
Texto: times 256 db "$" ;texto de carga 
;Datos para carga 
section .bss
Total_Caracteres: resb 10 ;longitud del archivo 
Caracteres_Leidos: resb 10 ;caracteres leidos 
Caracter: resb 1 ;caracter actual 
Errores: resb 1 ;errores en la operacion

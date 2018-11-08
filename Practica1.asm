org 100h

%macro reporte 3
    mov ah, 3ch
    mov cx, 0
    mov dx, %1
    int 21h
    jc Error
    mov bx, ax
    mov ah, 3eh
    int 21h

    mov ah,3dh
    mov al,1h 
    mov dx, %1
    int 21h
    jc Error 
    mov bx,ax 
    mov cx,[%2]
    mov dx,%3
    mov ah,40h
    int 21h
    
    cmp cx,ax
    jne Error
    mov ah,3eh
    int 21h
%endmacro
;-----------------------------------------------------------------
;----------------------Impresión del Menu-------------------------
;-----------------------------------------------------------------
inicio:
	mov ah,9
	mov dx,Encabezado
	int 21h
	call MostrarMenu
;-----------------------------------------------------------------
;----------------------Mostrar Opciones---------------------------
;-----------------------------------------------------------------
MostrarMenu:
	mov al,0
	mov [handle],al
	mov ah,9
	mov dx,MenuPrincipal
	int 21h
	call LeerOpcion
;-----------------------------------------------------------------
;----------------------Lectura de Opción--------------------------
;-----------------------------------------------------------------
LeerOpcion:
	mov ah,01h
	int 21h
	call CompararOpcion
	ret
;-----------------------------------------------------------------
;--------------------Comparación de Opción------------------------
;-----------------------------------------------------------------
CompararOpcion:
	cmp al,'1'
	je OpcionCarga
	cmp al,'2'
	je OpcionCalculadora
	cmp al,'3'
	je OpcionFactorial
	cmp al,'4'
	je OpcionReporte
	cmp al,'5'
	je OpcionSalir

	jmp OpcionError
;-----------------------------------------------------------------
;------------------------Carga de Archivo-------------------------
;-----------------------------------------------------------------
OpcionCarga:
	mov ah,09
	mov dx,MsjCarga
	int 21h
	call inicio
;-----------------------------------------------------------------
;------------------------Modo Calculadora-------------------------
;-----------------------------------------------------------------
OpcionCalculadora:
	mov ah,09
	mov dx,MsjCal
	int 21h
	call IngresoOperacion
;-----------------------------------------------------------------
;-------------------Ingreso Primer Numero-------------------------
;-----------------------------------------------------------------
IngresoOperacion:
	mov ah,09
	mov dx,MsjSigNum1
	int 21h
	call ConS1
ConS1:
	mov si, TxtOpe
	mov di, MsjSigNum1
	mov bx,0
    call CS1
CS1:
	mov cl,[handle]
	cmp cl,101
	jne AS1
	je ViaS
AS1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS1
ViaS:
	mov ah,01
	int 21h
	cmp al,'-'
	je CMenos1
	cmp al,'+'
	je CMas1
	jmp OpIn

CMenos1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Menos
	mov bx,36
    call CSMenos1
CSMenos1:
	mov cl,[handle]
	cmp cl,101
	jne ASMenos1
	je NS1
ASMenos1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMenos1

CMas1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Mas
	mov bx,36
    call CSMas1
CSMas1:
	mov cl,[handle]
	cmp cl,101
	jne ASMas1
	je IngDec1
ASMas1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMas1

NS1:
	mov ah,09
	mov dx,Salto
	int 21h

	mov al,0
	add al,1
	mov [SigNum1],al
	call IngDec1
NNS1:
	mov ah,09
	mov dx,Salto
	int 21h

	mov al,0
	mov [SigNum1],al
	call IngDec1

IngDec1:
	mov ah,09
	mov dx,MsjNum1
	int 21h
	call ConDec1
ConDec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, MsjNum1
	mov bx,38
    call CSDec1
CSDec1:
	mov cl,[handle]
	cmp cl,101
	jne ASDec1
	je VD1
ASDec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSDec1

VD1:
	mov ah,01
	int 21h
	mov bl,al
	sub bl,30h
	mov [DecNum1],bl
	cmp al,'a'
	je AsignarRes1	
	cmp al,'0'
	je Con0Dec1
	cmp al,'1'
	je Con1Dec1
	cmp al,'2'
	je Con2Dec1
	cmp al,'3'
	je Con3Dec1
	cmp al,'4'
	je Con4Dec1
	cmp al,'5'
	je Con5Dec1
	cmp al,'6'
	je Con6Dec1
	cmp al,'7'
	je Con7Dec1
	cmp al,'8'
	je Con8Dec1
	cmp al,'9'
	je Con9Dec1

	jmp OpIn
AsignarRes1:
	mov al,1
	mov [HA1],al
	mov al,[Res]
	mov [Num1],al
	call CRe1
CRe1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, A
	mov bx,64
    call CSRe1
CSRe1:
	mov cl,[handle]
	cmp cl,101
	jne ASRe1
	je Sig2
ASRe1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRe1	

IngUni1:

Con0Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cero
	mov bx, 64
    call CS0Dec1
CS0Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS0Dec1
	je NumUni1
AS0Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS0Dec1

Con1Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Uno
	mov bx, 64
    call CS1Dec1
CS1Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS1Dec1
	je NumUni1
AS1Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS1Dec1

Con2Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Dos
	mov bx, 64
    call CS2Dec1
CS2Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS2Dec1
	je NumUni1
AS2Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS2Dec1

Con3Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Tres
	mov bx, 64
    call CS3Dec1
CS3Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS3Dec1
	je NumUni1
AS3Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS3Dec1

Con4Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cuatro
	mov bx, 64
    call CS4Dec1
CS4Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS4Dec1
	je NumUni1
AS4Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS4Dec1

Con5Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cinco
	mov bx, 64
    call CS5Dec1
CS5Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS5Dec1
	je NumUni1
AS5Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS5Dec1

Con6Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Seis
	mov bx, 64
    call CS6Dec1
CS6Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS6Dec1
	je NumUni1
AS6Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS6Dec1

Con7Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Siete
	mov bx, 64
    call CS7Dec1
CS7Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS7Dec1
	je NumUni1
AS7Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS7Dec1

Con8Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Ocho
	mov bx, 64
    call CS8Dec1
CS8Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS8Dec1
	je NumUni1
AS8Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS8Dec1

Con9Dec1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Nueve
	mov bx, 64
    call CS9Dec1
CS9Dec1:
	mov cl,[handle]
	cmp cl,101
	jne AS9Dec1
	je NumUni1
AS9Dec1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS9Dec1

NumUni1:
	mov ah,01
	int 21h	
	mov bl,al
	sub bl,30h
	mov [UniNum1],bl
	cmp al,'0'
	je Con0Uni1
	cmp al,'1'
	je Con1Uni1
	cmp al,'2'
	je Con2Uni1
	cmp al,'3'
	je Con3Uni1
	cmp al,'4'
	je Con4Uni1
	cmp al,'5'
	je Con5Uni1
	cmp al,'6'
	je Con6Uni1
	cmp al,'7'
	je Con7Uni1
	cmp al,'8'
	je Con8Uni1
	cmp al,'9'
	je Con9Uni1

	jmp OpIn
Con0Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cero
	mov bx, 65
    call CS0Uni1
CS0Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS0Uni1
	je CalNum1
AS0Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS0Uni1

Con1Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Uno
	mov bx, 65
    call CS1Uni1
CS1Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS1Uni1
	je CalNum1
AS1Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS1Uni1

Con2Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Dos
	mov bx, 65
    call CS2Uni1
CS2Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS2Uni1
	je CalNum1
AS2Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS2Uni1

Con3Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Tres
	mov bx, 65
    call CS3Uni1
CS3Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS3Uni1
	je CalNum1
AS3Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS3Uni1

Con4Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cuatro
	mov bx, 65
    call CS4Uni1
CS4Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS4Uni1
	je CalNum1
AS4Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS4Uni1

Con5Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cinco
	mov bx, 65
    call CS5Uni1
CS5Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS5Uni1
	je CalNum1
AS5Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS5Uni1

Con6Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Seis
	mov bx, 65
    call CS6Uni1
CS6Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS6Uni1
	je CalNum1
AS6Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS6Uni1

Con7Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Siete
	mov bx, 65
    call CS7Uni1
CS7Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS7Uni1
	je CalNum1
AS7Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS7Uni1

Con8Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Ocho
	mov bx, 65
    call CS8Uni1
CS8Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS8Uni1
	je CalNum1
AS8Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS8Uni1

Con9Uni1:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Nueve
	mov bx, 65
    call CS9Uni1
CS9Uni1:
	mov cl,[handle]
	cmp cl,101
	jne AS9Uni1
	je CalNum1
AS9Uni1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS9Uni1

CalNum1:
	mov al,[DecNum1]
	mov bl, 10
	mul bl
	add al,[UniNum1]
	mov [Num1],al

	mov ah,09
	mov dx,Salto
	int 21h

	call Sig2
;-----------------------------------------------------------------
;-------------------Ingreso Segundo Numero------------------------
;-----------------------------------------------------------------
Sig2:
	mov ah,09
	mov dx,MsjSigNum2
	int 21h
	call ConS2
ConS2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, MsjSigNum2
	mov bx,66
    call CS2
CS2:
	mov cl,[handle]
	cmp cl,101
	jne AS2
	je ViaS2
AS2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS2
ViaS2:
	mov ah,01
	int 21h
	cmp al,'-'
	je CMenos2
	cmp al,'+'
	je CMas2
	jmp OpIn
	mov ah,01
	int 21h
CMenos2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Menos
	mov bx,103
    call CSMenos2
CSMenos2:
	mov cl,[handle]
	cmp cl,103
	jne ASMenos2
	je NS2
ASMenos2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMenos2

CMas2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Mas
	mov bx,103
    call CSMas2
CSMas2:
	mov cl,[handle]
	cmp cl,101
	jne ASMas2
	je IngDec2
ASMas2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMas2

NS2:
	mov ah,09
	mov dx,Salto
	int 21h

	mov al,0
	add al,1
	mov [SigNum2],al
	call IngDec2
NNS2:
	mov ah,09
	mov dx,Salto
	int 21h
	call IngDec2

IngDec2:
	mov ah,09
	mov dx,MsjNum2
	int 21h
	call ConDec2
ConDec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, MsjNum2
	mov bx,105
    call CSDec2
CSDec2:
	mov cl,[handle]
	cmp cl,101
	jne ASDec2
	je VD2
ASDec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSDec2

VD2:
	mov ah,01
	int 21h
	mov bl,al
	sub bl,30h
	mov [DecNum2],bl
	cmp al,'a'
	je AsignarRes2	
	cmp al,'0'
	je Con0Dec2
	cmp al,'1'
	je Con1Dec2
	cmp al,'2'
	je Con2Dec2
	cmp al,'3'
	je Con3Dec2
	cmp al,'4'
	je Con4Dec2
	cmp al,'5'
	je Con5Dec2
	cmp al,'6'
	je Con6Dec2
	cmp al,'7'
	je Con7Dec2
	cmp al,'8'
	je Con8Dec2
	cmp al,'9'
	je Con9Dec2

	jmp OpIn
AsignarRes2:
	mov al,1
	mov [HA2],al
	mov al,[Res]
	mov [Num2],al
	call CRe2
CRe2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, A
	mov bx,132
    call CSRe2
CSRe2:
	mov cl,[handle]
	cmp cl,101
	jne ASRe2
	je IngOp
ASRe2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRe2	

Con0Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cero
	mov bx, 132
    call CS0Dec2
CS0Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS0Dec2
	je NumUni2
AS0Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS0Dec2

Con1Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Uno
	mov bx, 132
    call CS1Dec2
CS1Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS1Dec2
	je NumUni2
AS1Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS1Dec2

Con2Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Dos
	mov bx, 132
    call CS2Dec2
CS2Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS2Dec2
	je NumUni2
AS2Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS2Dec2

Con3Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Tres
	mov bx, 132
    call CS3Dec2
CS3Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS3Dec2
	je NumUni2
AS3Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS3Dec2

Con4Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cuatro
	mov bx, 132
    call CS4Dec2
CS4Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS4Dec2
	je NumUni2
AS4Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS4Dec2

Con5Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cinco
	mov bx, 132
    call CS5Dec2
CS5Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS5Dec2
	je NumUni2
AS5Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS5Dec2

Con6Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Seis
	mov bx, 132
    call CS6Dec2
CS6Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS6Dec2
	je NumUni2
AS6Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS6Dec2

Con7Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Siete
	mov bx, 132
    call CS7Dec2
CS7Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS7Dec2
	je NumUni2
AS7Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS7Dec2

Con8Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Ocho
	mov bx, 132
    call CS8Dec2
CS8Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS8Dec2
	je NumUni2
AS8Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS8Dec2

Con9Dec2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Nueve
	mov bx, 132
    call CS9Dec2
CS9Dec2:
	mov cl,[handle]
	cmp cl,101
	jne AS9Dec2
	je NumUni2
AS9Dec2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS9Dec2

NumUni2:
	mov ah,01
	int 21h	
	mov bl,al
	sub bl,30h
	mov [UniNum2],bl
	cmp al,'0'
	je Con0Uni2
	cmp al,'1'
	je Con1Uni2
	cmp al,'2'
	je Con2Uni2
	cmp al,'3'
	je Con3Uni2
	cmp al,'4'
	je Con4Uni2
	cmp al,'5'
	je Con5Uni2
	cmp al,'6'
	je Con6Uni2
	cmp al,'7'
	je Con7Uni2
	cmp al,'8'
	je Con8Uni2
	cmp al,'9'
	je Con9Uni2

	jmp OpIn
Con0Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cero
	mov bx, 133
    call CS0Uni2
CS0Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS0Uni2
	je CalNum2
AS0Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS0Uni2

Con1Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Uno
	mov bx, 133
    call CS1Uni2
CS1Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS1Uni2
	je CalNum2
AS1Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS1Uni2

Con2Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Dos
	mov bx, 133
    call CS2Uni2
CS2Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS2Uni2
	je CalNum2
AS2Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS2Uni2

Con3Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Tres
	mov bx, 133
    call CS3Uni2
CS3Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS3Uni2
	je CalNum2
AS3Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS3Uni2

Con4Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cuatro
	mov bx, 133
    call CS4Uni2
CS4Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS4Uni2
	je CalNum2
AS4Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS4Uni2

Con5Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cinco
	mov bx, 133
    call CS5Uni2
CS5Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS5Uni2
	je CalNum2
AS5Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS5Uni2

Con6Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Seis
	mov bx, 133
    call CS6Uni2
CS6Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS6Uni2
	je CalNum2
AS6Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS6Uni2

Con7Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Siete
	mov bx, 133
    call CS7Uni2
CS7Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS7Uni2
	je CalNum2
AS7Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS7Uni2

Con8Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Ocho
	mov bx, 133
    call CS8Uni2
CS8Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS8Uni2
	je CalNum2
AS8Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS8Uni2

Con9Uni2:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Nueve
	mov bx, 133
    call CS9Uni2
CS9Uni2:
	mov cl,[handle]
	cmp cl,101
	jne AS9Uni2
	je CalNum2
AS9Uni2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS9Uni2

CalNum2:
	mov al,[DecNum2]
	mov bl, 10
	mul bl
	add al,[UniNum2]
	mov [Num2],al

	mov ah,09
	mov dx,Salto
	int 21h
	call IngOp
;-----------------------------------------------------------------
;------------------------Ingreso Operador-------------------------
;-----------------------------------------------------------------
IngOp:
	mov ah,09
	mov dx,MsjOp
	int 21h
	call COP
COP:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, MsjOp
	mov bx,134
    call CSOP
CSOP:
	mov cl,[handle]
	cmp cl,101
	jne ASOP
	je VOP
ASOP:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOP
VOP:
	mov ah,01h
	int 21h

	cmp al,'+'
	je Suma
	cmp al,'-'
	je Resta
	cmp al,'*'
	je Multiplicacion
	cmp al,'/'
	je Division

	jmp OpIn
;-----------------------------------------------------------------
;-------------------------Posibles Errores------------------------
;-----------------------------------------------------------------
OpIn:
	mov ah,09
	mov dx, MsjErrOp
	int 21h
	call IngresoOperacion
ErrCont:
	mov ah,09
	mov dx, MsjErrCont
	int 21h
	call Continuar
;-----------------------------------------------------------------
;-------------------------Realizar Otra Op------------------------
;-----------------------------------------------------------------
Continuar:
	mov ah,09
	mov dx,TxtOpe
	int 21h
	Call OpcCon


OpcCon:
	
	mov ah,09
	mov dx,Salto

	int 21h

	mov ah,09
	mov dx,MsjContinuar
	int 21h

	mov ah,01
	int 21h

	cmp al,'1'
	je OpcionCalculadora
	cmp al,'2'
	je inicio

;-----------------------------------------------------------------
;---------------------Posibles Operaciones------------------------
;-----------------------------------------------------------------
Suma:
	call Cu
Cu:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, SSuma
	mov bx,155
    call CSU
CSU:
	mov cl,[handle]
	cmp cl,101
	jne ASU
	je OpSuma
ASU:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSU
OpSuma:
	mov al,[SigNum1]
	mov bl,[SigNum2]
	cmp al,bl
	je VerSignos
	jne VerMayor
VerSignos:
	mov al,[SigNum1]
	add al,[SigNum2]
	cmp al,2
	je SumarNeg
	jne SumarPos
SumarNeg:
	mov al, [Num1]
	add al, [Num2]
	mov [Res], al

	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuN

SumarPos:
	mov al, [Num1]
	add al, [Num2]
	mov [Res], al

	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuP
VerMayor:
	mov al,[Num1]
	mov bl,[Num2]
	cmp al,bl
	jg VerN1
	je VerN1
	jmp VerN2
VerN1:
	mov al,[SigNum1]
	cmp al,1
	je Resta1
	jne Resta2
VerN2:
	mov al,[SigNum2]
	cmp al,1
	je Resta3
	jne Resta4

Resta1:
	mov al,[Num1]
	sub al,[Num2]
	mov [Res],al
	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuN
Resta2:
	mov al,[Num1]
	sub al,[Num2]
	mov [Res],al
	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuP
Resta3:
	mov al,[Num2]
	sub al,[Num1]
	mov [Res],al
	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuP
Resta4:
	mov al,[Num2]
	sub al,[Num1]
	mov [Res],al
	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuN

Resta:
	call Ru
Ru:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, SResta
	mov bx,155
    call CRU
CRU:
	mov cl,[handle]
	cmp cl,101
	jne ARU
	je OpResta
ARU:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CRU
OpResta:
	mov al, [SigNum1]
	mov bl, [SigNum2]
	cmp al,bl
	je VerS1
	jne VerS2
VerS1:
	mov al, [SigNum1]
	cmp al, 1
	je VerMayorResta
	jne VerMayorNormal
VerS2:
	mov al, [SigNum2]
	cmp al, 1
	je SumarPos
	jne SumarNeg
VerMayorResta:
	mov al, [Num1]
	mov bl, [Num2]
	cmp al,bl
	jg Resta1
	je Resta2
	jmp Resta3
VerMayorNormal:
	mov al, [Num1]
	mov bl, [Num2]
	cmp al,bl
	jg Resta2
	je Resta2
	jmp Resta4
Multiplicacion:
	call Mu
Mu:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, SMult
	mov bx,155
    call MSU
MSU:
	mov cl,[handle]
	cmp cl,101
	jne MASU
	je OpMult
MASU:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call MSU
OpMult:
	mov al,[SigNum1]
	cmp al,1
	jne V2P
	je V2N
V2N:
	mov al,[SigNum2]
	cmp al,1
	jne MultNeg
	je MultPos
V2P:
	mov al,[SigNum2]
	cmp al,1
	jne MultPos
	je MultNeg
MultNeg:
	mov al, [Num1]
	mov bl, [Num2]
	mul bl
	mov [Res], al

	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuN
MultPos:
	mov al, [Num1]
	mov bl, [Num2]
	mul bl
	mov [Res], al

	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuP

Division:
	call Du
Du:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, SDiv
	mov bx,155
    call DSU
DSU:
	mov cl,[handle]
	cmp cl,101
	jne DASU
	je OpDiv
DASU:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call DSU
OpDiv:
	mov al,[SigNum1]
	mov bl,[SigNum2]
	cmp al,bl
	je DivPos
	jne DivNeg
DivNeg:
	xor ax,ax
	xor bx,bx
	mov al, [Num1]
	mov bl, [Num2]
	div bl
	mov [Res], al

	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuN
DivPos:
	xor ax,ax
	xor bx,bx
	mov al, [Num1]
	mov bl, [Num2]
	div bl
	mov [Res], al

	mov ah,09
	mov dx, MsjRes
	int 21h
	call CResuP

CResuN:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, MsjRes
	mov bx,156
    call CSResuN
CSResuN:
	mov cl,[handle]
	cmp cl,101
	jne ASResuN
	je OPNEG
ASResuN:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSResuN

CResuP:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, MsjRes
	mov bx,156
    call CSResuP
CSResuP:
	mov cl,[handle]
	cmp cl,101
	jne ASResuP
	je OPPOS
ASResuP:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSResuP

OPNEG:
	mov ah,02h
	mov dl, 45
	int 21h

	call CNEG
CNEG:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, SResta
	mov bx,172
    call CSNEG
CSNEG:
	mov cl,[handle]
	cmp cl,101
	jne ASNEG
	je COM
ASNEG:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSNEG

OPPOS:
	mov ah,02h
	mov dl, 43
	int 21h

	call CPOS
CPOS:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, SSuma
	mov bx,172
    call CSPOS
CSPOS:
	mov cl,[handle]
	cmp cl,101
	jne ASPOS
	je COM
ASPOS:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSPOS

COM:
	mov al,[Res]
	aam
	mov [UniRes],al
	mov al,ah
	aam
	mov [DecRes],al
	mov [CenRes],ah
	
	mov ah,02h
	mov dl, [CenRes]
	add dl,30h ; se suma 30h a dl para imprimir el numero real.
	int 21h

	mov dl, [DecRes]
	add dl,30h
	int 21h

	mov dl, [UniRes]
	add dl,30h
	int 21h
	call IngCenRes
IngCenRes:
	mov al,[CenRes]
	cmp al,0
	je Con0CenRes
	cmp al,1
	je Con1CenRes
	cmp al,2
	je Con2CenRes
	cmp al,3
	je Con3CenRes
	cmp al,4
	je Con4CenRes
	cmp al,5
	je Con5CenRes
	cmp al,6
	je Con6CenRes
	cmp al,7
	je Con7CenRes
	cmp al,8
	je Con8CenRes
	cmp al,9
	je Con9CenRes

	jmp OpIn
Con0CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cero
	mov bx, 173
    call CS0CenRes
CS0CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS0CenRes
	je NumDecRes
AS0CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS0CenRes

Con1CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Uno
	mov bx, 173
    call CS1CenRes
CS1CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS1CenRes
	je NumDecRes
AS1CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS1CenRes

Con2CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Dos
	mov bx, 173
    call CS2CenRes
CS2CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS2CenRes
	je NumDecRes
AS2CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS2CenRes

Con3CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Tres
	mov bx, 173
    call CS3CenRes
CS3CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS3CenRes
	je NumDecRes
AS3CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS3CenRes

Con4CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cuatro
	mov bx, 173
    call CS4CenRes
CS4CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS4CenRes
	je NumDecRes
AS4CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS4CenRes

Con5CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cinco
	mov bx, 173
    call CS5CenRes
CS5CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS5CenRes
	je NumDecRes
AS5CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS5CenRes

Con6CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Seis
	mov bx, 173
    call CS6CenRes
CS6CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS6CenRes
	je NumDecRes
AS6CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS6CenRes

Con7CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Siete
	mov bx, 173
    call CS7CenRes
CS7CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS7CenRes
	je NumDecRes
AS7CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS7CenRes

Con8CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Ocho
	mov bx, 173
    call CS8CenRes
CS8CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS8CenRes
	je NumDecRes
AS8CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS8CenRes

Con9CenRes:
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Nueve
	mov bx, 173
    call CS9CenRes
CS9CenRes:
	mov cl,[handle]
	cmp cl,101
	jne AS9CenRes
	je NumDecRes
AS9CenRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS9CenRes
NumDecRes:
	mov al,[DecRes]
	cmp al,0
	je Con0DecRes
	cmp al,1
	je Con1DecRes
	cmp al,2
	je Con2DecRes
	cmp al,3
	je Con3DecRes
	cmp al,4
	je Con4DecRes
	cmp al,5
	je Con5DecRes
	cmp al,6
	je Con6DecRes
	cmp al,7
	je Con7DecRes
	cmp al,8
	je Con8DecRes
	cmp al,9
	je Con9DecRes

	jmp OpIn
Con0DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cero
	mov bx, 174
    call CS0DecRes
CS0DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS0DecRes
	je NumUniRes
AS0DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS0DecRes

Con1DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Uno
	mov bx, 174
    call CS1DecRes
CS1DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS1DecRes
	je NumUniRes
AS1DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS1DecRes

Con2DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Dos
	mov bx, 174
    call CS2DecRes
CS2DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS2DecRes
	je NumUniRes
AS2DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS2DecRes

Con3DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Tres
	mov bx, 174
    call CS3DecRes
CS3DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS3DecRes
	je NumUniRes
AS3DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS3DecRes

Con4DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cuatro
	mov bx, 174
    call CS4DecRes
CS4DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS4DecRes
	je NumUniRes
AS4DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS4DecRes

Con5DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cinco
	mov bx, 174
    call CS5DecRes
CS5DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS5DecRes
	je NumUniRes
AS5DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS5DecRes

Con6DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Seis
	mov bx, 174
    call CS6DecRes
CS6DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS6DecRes
	je NumUniRes
AS6DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS6DecRes

Con7DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Siete
	mov bx, 174
    call CS7DecRes
CS7DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS7DecRes
	je NumUniRes
AS7DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS7DecRes

Con8DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Ocho
	mov bx, 174
    call CS8DecRes
CS8DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS8DecRes
	je NumUniRes
AS8DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS8DecRes

Con9DecRes:
	sub al,30h
	mov [DecNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Nueve
	mov bx, 174
    call CS9DecRes
CS9DecRes:
	mov cl,[handle]
	cmp cl,101
	jne AS9DecRes
	je NumUniRes
AS9DecRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS9DecRes

NumUniRes:
	mov al,[UniRes]
	cmp al,0
	je Con0UniRes
	cmp al,1
	je Con1UniRes
	cmp al,2
	je Con2UniRes
	cmp al,3
	je Con3UniRes
	cmp al,4
	je Con4UniRes
	cmp al,5
	je Con5UniRes
	cmp al,6
	je Con6UniRes
	cmp al,7
	je Con7UniRes
	cmp al,8
	je Con8UniRes
	cmp al,9
	je Con9UniRes

	jmp OpIn
Con0UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cero
	mov bx, 175
    call CS0UniRes
CS0UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS0UniRes
	je Continuar
AS0UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS0UniRes

Con1UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Uno
	mov bx, 175
    call CS1UniRes
CS1UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS1UniRes
	je Continuar
AS1UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS1UniRes

Con2UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Dos
	mov bx, 175
    call CS2UniRes
CS2UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS2UniRes
	je Continuar
AS2UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS2UniRes

Con3UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Tres
	mov bx, 175
    call CS3UniRes
CS3UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS3UniRes
	je Continuar
AS3UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS3UniRes

Con4UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cuatro
	mov bx, 175
    call CS4UniRes
CS4UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS4UniRes
	je Continuar
AS4UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS4UniRes

Con5UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Cinco
	mov bx, 175
    call CS5UniRes
CS5UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS5UniRes
	je Continuar
AS5UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS5UniRes

Con6UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Seis
	mov bx, 175
    call CS6UniRes
CS6UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS6UniRes
	je Continuar
AS6UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS6UniRes

Con7UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Siete
	mov bx, 175
    call CS7UniRes
CS7UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS7UniRes
	je Continuar
AS7UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS7UniRes

Con8UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Ocho
	mov bx, 175
    call CS8UniRes
CS8UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS8UniRes
	je Continuar
AS8UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS8UniRes

Con9UniRes:
	sub al,30h
	mov [UniNum1],al
	mov al,0
	mov [handle],al
	mov si, TxtOpe
	mov di, Nueve
	mov bx, 175
    call CS9UniRes
CS9UniRes:
	mov cl,[handle]
	cmp cl,101
	jne AS9UniRes
	je Continuar
AS9UniRes:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS9UniRes
;-----------------------------------------------------------------
;------------------------Modo Factrorial--------------------------
;-----------------------------------------------------------------
OpcionFactorial:
	mov ah,09
	mov dx,MsjFac
	int 21h	

	mov al,1
	mov [hFac],al

	mov ah,09
	mov dx,MsjNumFac
	int 21h	
	call ConNF
ConNF:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjNumFac
	mov bx,0
    call CSNF
CSNF:
	mov cl,[handle]
	cmp cl,114
	jne ASNF
	je ViaFac
ASNF:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSNF
ViaFac:
	mov ah,01h
	int 21h
	cmp al,'0'
	je Fac0
	cmp al,'1'
	je Fac1
	cmp al,'2'
	je Fac2
	cmp al,'3'
	je Fac3
	cmp al,'4'
	je Fac4
	cmp al,'5'
	je Fac5
	cmp al,'6'
	je Fac6
	cmp al,'7'
	je Fac7
	jmp ErrFac
Fac0:
	mov ah,09
	mov dx,Salto
	int 21h
	call Con0
Con0:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, Cero
	mov bx,46
    call CS0
CS0:
	mov cl,[handle]
	cmp cl,114
	jne AS0
	je IFac0
AS0:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CS0
IFac0:
	mov ah,09
	mov dx,MsjIFac
	int 21h

	call ConIFac0
ConIFac0:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjIFac
	mov bx,49
    call CSIFac0
CSIFac0:
	mov cl,[handle]
	cmp cl,101
	jne ASFac0
	je MosFac0
ASFac0:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSIFac0

MosFac0:
	mov ah,09
	mov dx,FacCero
	int 21h
	call ConRFac0
ConRFac0:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, FacCero
	mov bx,80
    call CSRFac0
CSRFac0:
	mov cl,[handle]
	cmp cl,49
	jne ASRFac0
	je MosOPFac0
ASRFac0:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRFac0

MosOPFac0:
	mov ah,09
	mov dx,MsjOpFac
	int 21h
	call ConMOFac0
ConMOFac0:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac
	mov bx,86
    call CSMOFac0
CSMOFac0:
	mov cl,[handle]
	cmp cl,101
	jne ASMOFac0
	je MosProFac0
ASMOFac0:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMOFac0

MosProFac0:
	mov ah,09
	mov dx,Salto
	int 21h

	mov ah,09
	mov dx,MsjOpFac0
	int 21h

	call ConOpFac0
ConOpFac0:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac0
	mov bx,116
    call CSOPFac0
CSOPFac0:
	mov cl,[handle]
	cmp cl,101
	jne ASOPFac0
	je ConCuFac
ASOPFac0:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOPFac0

Fac1:
	mov ah,09
	mov dx,Salto
	int 21h
	call ConUno
ConUno:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, Uno
	mov bx,46
    call CSUno
CSUno:
	mov cl,[handle]
	cmp cl,114
	jne ASUno
	je IFac1
ASUno:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSUno
IFac1:
	mov ah,09
	mov dx,MsjIFac
	int 21h

	call ConIFac1
ConIFac1:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjIFac
	mov bx,49
    call CSIFac1
CSIFac1:
	mov cl,[handle]
	cmp cl,101
	jne ASFac1
	je MosFac1
ASFac1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSIFac1

MosFac1:
	mov ah,09
	mov dx,FacUno
	int 21h
	call ConRFac1
ConRFac1:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, FacUno
	mov bx,80
    call CSRFac1
CSRFac1:
	mov cl,[handle]
	cmp cl,49
	jne ASRFac1
	je MosOPFac1
ASRFac1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRFac1

MosOPFac1:
	mov ah,09
	mov dx,MsjOpFac
	int 21h
	call ConMOFac1
ConMOFac1:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac
	mov bx,86
    call CSMOFac1
CSMOFac1:
	mov cl,[handle]
	cmp cl,101
	jne ASMOFac1
	je MosProFac1
ASMOFac1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMOFac1

MosProFac1:
	mov ah,09
	mov dx,Salto
	int 21h

	mov ah,09
	mov dx,MsjOpFac1
	int 21h

	call ConOpFac1
ConOpFac1:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac1
	mov bx,116
    call CSOPFac1
CSOPFac1:
	mov cl,[handle]
	cmp cl,101
	jne ASOPFac1
	je ConCuFac
ASOPFac1:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOPFac1

Fac2:
	mov ah,09
	mov dx,Salto
	int 21h
	call ConDos
ConDos:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, Dos
	mov bx,46
    call CSDos
CSDos:
	mov cl,[handle]
	cmp cl,114
	jne ASDos
	je IFac2
ASDos:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSDos
IFac2:
	mov ah,09
	mov dx,MsjIFac
	int 21h

	call ConIFac2
ConIFac2:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjIFac
	mov bx,49
    call CSIFac2
CSIFac2:
	mov cl,[handle]
	cmp cl,101
	jne ASFac2
	je MosFac2
ASFac2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSIFac2

MosFac2:
	mov ah,09
	mov dx,FacDos
	int 21h
	call ConRFac2
ConRFac2:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, FacDos
	mov bx,80
    call CSRFac2
CSRFac2:
	mov cl,[handle]
	cmp cl,49
	jne ASRFac2
	je MosOPFac2
ASRFac2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRFac2

MosOPFac2:
	mov ah,09
	mov dx,MsjOpFac
	int 21h
	call ConMOFac2
ConMOFac2:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac
	mov bx,86
    call CSMOFac2
CSMOFac2:
	mov cl,[handle]
	cmp cl,101
	jne ASMOFac2
	je MosProFac2
ASMOFac2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMOFac2

MosProFac2:
	mov ah,09
	mov dx,Salto
	int 21h

	mov ah,09
	mov dx,MsjOpFac2
	int 21h

	call ConOpFac2
ConOpFac2:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac2
	mov bx,116
    call CSOPFac2
CSOPFac2:
	mov cl,[handle]
	cmp cl,101
	jne ASOPFac2
	je ConCuFac
ASOPFac2:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOPFac2

Fac3:
	mov ah,09
	mov dx,Salto
	int 21h
	call ConTres
ConTres:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, Tres
	mov bx,46
    call CSTres
CSTres:
	mov cl,[handle]
	cmp cl,114
	jne ASTres
	je IFac3
ASTres:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSTres
IFac3:
	mov ah,09
	mov dx,MsjIFac
	int 21h

	call ConIFac3
ConIFac3:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjIFac
	mov bx,49
    call CSIFac3
CSIFac3:
	mov cl,[handle]
	cmp cl,101
	jne ASFac3
	je MosFac3
ASFac3:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSIFac3

MosFac3:
	mov ah,09
	mov dx,FacTres
	int 21h
	call ConRFac3
ConRFac3:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, FacTres
	mov bx,80
    call CSRFac3
CSRFac3:
	mov cl,[handle]
	cmp cl,49
	jne ASRFac3
	je MosOPFac3
ASRFac3:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRFac3

MosOPFac3:
	mov ah,09
	mov dx,MsjOpFac
	int 21h
	call ConMOFac3
ConMOFac3:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac
	mov bx,86
    call CSMOFac3
CSMOFac3:
	mov cl,[handle]
	cmp cl,101
	jne ASMOFac3
	je MosProFac3
ASMOFac3:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMOFac3

MosProFac3:
	mov ah,09
	mov dx,Salto
	int 21h

	mov ah,09
	mov dx,MsjOpFac3
	int 21h

	call ConOpFac3
ConOpFac3:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac3
	mov bx,116
    call CSOPFac3
CSOPFac3:
	mov cl,[handle]
	cmp cl,101
	jne ASOPFac3
	je ConCuFac
ASOPFac3:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOPFac3

Fac4:
	mov ah,09
	mov dx,Salto
	int 21h
	call ConCuatro
ConCuatro:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, Cuatro
	mov bx,46
    call CSCuatro
CSCuatro:
	mov cl,[handle]
	cmp cl,114
	jne ASCuatro
	je IFac4
ASCuatro:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSCuatro
IFac4:
	mov ah,09
	mov dx,MsjIFac
	int 21h

	call ConIFac4
ConIFac4:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjIFac
	mov bx,49
    call CSIFac4
CSIFac4:
	mov cl,[handle]
	cmp cl,101
	jne ASFac4
	je MosFac4
ASFac4:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSIFac4

MosFac4:
	mov ah,09
	mov dx,FacCuatro
	int 21h
	call ConRFac4
ConRFac4:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, FacCuatro
	mov bx,80
    call CSRFac4
CSRFac4:
	mov cl,[handle]
	cmp cl,49
	jne ASRFac4
	je MosOPFac4
ASRFac4:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRFac4

MosOPFac4:
	mov ah,09
	mov dx,MsjOpFac
	int 21h
	call ConMOFac4
ConMOFac4:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac
	mov bx,86
    call CSMOFac4
CSMOFac4:
	mov cl,[handle]
	cmp cl,101
	jne ASMOFac4
	je MosProFac4
ASMOFac4:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMOFac4

MosProFac4:
	mov ah,09
	mov dx,Salto
	int 21h

	mov ah,09
	mov dx,MsjOpFac4
	int 21h

	call ConOpFac4
ConOpFac4:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac4
	mov bx,116
    call CSOPFac4
CSOPFac4:
	mov cl,[handle]
	cmp cl,101
	jne ASOPFac4
	je ConCuFac
ASOPFac4:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOPFac4

Fac5:
	mov ah,09
	mov dx,Salto
	int 21h
	call ConCinco
ConCinco:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, Cinco
	mov bx,46
    call CSCinco
CSCinco:
	mov cl,[handle]
	cmp cl,114
	jne ASCinco
	je IFac5
ASCinco:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSCinco
IFac5:
	mov ah,09
	mov dx,MsjIFac
	int 21h

	call ConIFac5
ConIFac5:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjIFac
	mov bx,49
    call CSIFac5
CSIFac5:
	mov cl,[handle]
	cmp cl,101
	jne ASFac5
	je MosFac5
ASFac5:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSIFac5

MosFac5:
	mov ah,09
	mov dx,FacCinco
	int 21h
	call ConRFac5
ConRFac5:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, FacCinco
	mov bx,80
    call CSRFac5
CSRFac5:
	mov cl,[handle]
	cmp cl,49
	jne ASRFac5
	je MosOPFac5
ASRFac5:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRFac5

MosOPFac5:
	mov ah,09
	mov dx,MsjOpFac
	int 21h
	call ConMOFac5
ConMOFac5:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac
	mov bx,86
    call CSMOFac5
CSMOFac5:
	mov cl,[handle]
	cmp cl,101
	jne ASMOFac5
	je MosProFac5
ASMOFac5:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMOFac5

MosProFac5:
	mov ah,09
	mov dx,Salto
	int 21h

	mov ah,09
	mov dx,MsjOpFac5
	int 21h

	call ConOpFac5
ConOpFac5:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac5
	mov bx,116
    call CSOPFac5
CSOPFac5:
	mov cl,[handle]
	cmp cl,101
	jne ASOPFac5
	je ConCuFac
ASOPFac5:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOPFac5

Fac6:
	mov ah,09
	mov dx,Salto
	int 21h
	call ConSeis
ConSeis:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, Seis
	mov bx,46
    call CSSeis
CSSeis:
	mov cl,[handle]
	cmp cl,114
	jne ASSeis
	je IFac6
ASSeis:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSSeis
IFac6:
	mov ah,09
	mov dx,MsjIFac
	int 21h

	call ConIFac6
ConIFac6:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjIFac
	mov bx,49
    call CSIFac6
CSIFac6:
	mov cl,[handle]
	cmp cl,101
	jne ASFac6
	je MosFac6
ASFac6:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSIFac6

MosFac6:
	mov ah,09
	mov dx,FacSeis
	int 21h
	call ConRFac6
ConRFac6:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, FacSeis
	mov bx,80
    call CSRFac6
CSRFac6:
	mov cl,[handle]
	cmp cl,49
	jne ASRFac6
	je MosOPFac6
ASRFac6:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRFac6

MosOPFac6:
	mov ah,09
	mov dx,MsjOpFac
	int 21h
	call ConMOFac6
ConMOFac6:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac
	mov bx,86
    call CSMOFac6
CSMOFac6:
	mov cl,[handle]
	cmp cl,101
	jne ASMOFac6
	je MosProFac6
ASMOFac6:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMOFac6

MosProFac6:
	mov ah,09
	mov dx,Salto
	int 21h

	mov ah,09
	mov dx,MsjOpFac6
	int 21h

	call ConOpFac6
ConOpFac6:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac6
	mov bx,116
    call CSOPFac6
CSOPFac6:
	mov cl,[handle]
	cmp cl,101
	jne ASOPFac6
	je ConCuFac
ASOPFac6:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOPFac6

Fac7:
	mov ah,09
	mov dx,Salto
	int 21h
	call ConSiete
ConSiete:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, Siete
	mov bx,46
    call CSSiete
CSSiete:
	mov cl,[handle]
	cmp cl,114
	jne ASSiete
	je IFac7
ASSiete:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSSiete
IFac7:
	mov ah,09
	mov dx,MsjIFac
	int 21h

	call ConIFac7
ConIFac7:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjIFac
	mov bx,49
    call CSIFac7
CSIFac7:
	mov cl,[handle]
	cmp cl,101
	jne ASFac7
	je MosFac7
ASFac7:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSIFac7

MosFac7:
	mov ah,09
	mov dx,FacSiete
	int 21h
	call ConRFac7
ConRFac7:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, FacSiete
	mov bx,80
    call CSRFac7
CSRFac7:
	mov cl,[handle]
	cmp cl,49
	jne ASRFac7
	je MosOPFac7
ASRFac7:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSRFac7

MosOPFac7:
	mov ah,09
	mov dx,MsjOpFac
	int 21h
	call ConMOFac7
ConMOFac7:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac
	mov bx,86
    call CSMOFac7
CSMOFac7:
	mov cl,[handle]
	cmp cl,101
	jne ASMOFac7
	je MosProFac7
ASMOFac7:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSMOFac7

MosProFac7:
	mov ah,09
	mov dx,Salto
	int 21h

	mov ah,09
	mov dx,MsjOpFac7
	int 21h

	call ConOpFac7
ConOpFac7:
	mov al,0
	mov [handle],al
	mov si, TxtFac
	mov di, MsjOpFac7
	mov bx,116
    call CSOPFac7
CSOPFac7:
	mov cl,[handle]
	cmp cl,101
	jne ASOPFac7
	je ConCuFac
ASOPFac7:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSOPFac7

ConCuFac:
	mov al,0
	mov [handle],al
	mov si, Encabezado
	mov di, TxtFac
	mov bx,256
    call CSCUFac
CSCUFac:
	mov cl,[handle]
	cmp cl,101
	jne CASUFac
	je MostrarFactorial
CASUFac:
	mov dl, [di]
	mov [si + bx], dl 
	inc bx
	inc di
	mov cl,[handle]
	add cl,1
	mov [handle],cl
	call CSCUFac

MostrarFactorial:
	mov ah,09
	mov dx,TxtFac
	int 21h
	Call inicio
ErrFac:
	mov ah,09
	mov dx,MsjErrFac
	int 21h

	mov al,0
	mov [hFac],al
	call inicio
;-----------------------------------------------------------------
;---------------------------Reporte-------------------------------
;-----------------------------------------------------------------
OpcionReporte:
	mov ah,09
	mov dx,MsjRep
	int 21h
	Reporte NArchivo, Carac, Encabezado
	call inicio
Error:
	mov ah,09
	mov dx,MsjErrArch
	int 21h
	call inicio

;-----------------------------------------------------------------
;---------------------Salida del Programa-------------------------
;-----------------------------------------------------------------
OpcionSalir:

	mov ah,09
	mov dx,MsjSal
	int 21h

	mov ax,4c00h
	int 21h
;-----------------------------------------------------------------
;---------------------Error de Selección--------------------------
;-----------------------------------------------------------------
OpcionError:
	mov ah,09
	mov dx,MsjErr
    int 21h

	call inicio
;-----------------------------------------------------------------
;------------------Mensajes De  Varias Lineas---------------------
;-----------------------------------------------------------------
MenuPrincipal db '			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
	   		  db '			%%%%%%%%% MENU PRINCIPAL %%%%%%%%',13,10,
	          db '			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
	          db '			%%%%% 1. Cargar Archivo   %%%%%%%',13,10,
	          db '			%%%%% 2. Modo Calculadora %%%%%%%',13,10,
	          db '			%%%%% 3. Factorial        %%%%%%%',13,10,
	          db '			%%%%% 4. Crear reporte    %%%%%%%',13,10,
	          db '			%%%%% 5. Salir            %%%%%%%',13,10,
	          db '			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,'$'
MsjCarga 	db '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
	   		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CARGA DE ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
	        db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
	        db ' ',13,10,
			db ' ',13,10,'$'
MsjFac  db ' ',13,10,
		db ' ',13,10,
		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
   		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FACTORIAL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
        db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,	    
        db ' ',13,10,
		db ' ',13,10,'$'
MsjCal  db ' ',13,10,
		db ' ',13,10,
		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
   		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MODO CALCULADORA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
        db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,	   
        db ' ',13,10,
		db ' ',13,10,'$'
MsjRep  db ' ',13,10,
		db ' ',13,10,
		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
   		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%% SE GENERO EL REPORTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
        db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,	
        db ' ',13,10,
		db ' ',13,10,'$'
MsjErr  db ' ',13,10,
		db ' ',13,10,
		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
   		db ' %%%%%%%%%%%%%%%%%%%%% OPCION NO VALIDA, INTENTE DE NUEVO %%%%%%%%%%%%%%%%%%%%%',13,10,
        db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,	   
        db ' ',13,10,
		db ' ',13,10,'$' 
MsjSal  db ' ',13,10,
		db ' ',13,10,
		db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
   		db ' %%%%%%%%%%%%%%%%%%%%%%% GRACIAS POR USAR ESTE PROGRAMA %%%%%%%%%%%%%%%%%%%%%%%',13,10,
        db ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,'$' 
MsjContinuar db 'Desea hacer otra operacion? ',13,10,
			 db '1. Si',13,10,
			 db '2. No',13,10,'$'
;-----------------------------------------------------------------
;--------------------Mensajes De Una Linea------------------------
;-----------------------------------------------------------------
A db 'a ',13,10,'$'
Salto db ' ',13,10,'$'
Mas db '+ ',13,10,'$'
FacCero db '0001',13,10,'$'
FacUno db '0001',13,10,'$'
FacDos db '0002',13,10,'$'
FacTres db '0006',13,10,'$'
FacCuatro db '0024',13,10,'$'
FacCinco db '0120',13,10,'$'
FacSeis db '0720',13,10,'$'
FacSiete db '5040',13,10,'$'
Cero db '0',13,10,'$'
Uno db '1',13,10,'$'
Dos db '2',13,10,'$'
Tres db '3',13,10,'$'
Cuatro db '4',13,10,'$'
Cinco db '5',13,10,'$'
Seis db '6',13,10,'$'
Siete db '7',13,10,'$'
Ocho db '8',13,10,'$'
Nueve db '9',13,10,'$'
SSuma db '+',13,10,'$'
SResta db '-',13,10,'$'
SMult db '*',13,10,'$'
SDiv db '/',13,10,'$'
TEnter db '\n',13,10,'$'
Menos db '- ',13,10,'$'
MsjErrArch db 'No se pudo crear el archivo',13,10,'$'
MsjSigNum1 db 'Ingrese el signo del primer numero: ',13,10,'$'
MsjNum1 db 'Ingrese el primer numero: ',13,10,'$'
MsjSigNum2 db 'Ingrese el signo del segundo numero: ',13,10,'$'
MsjNum2 db 'Ingrese el segundo numero: ',13,10,'$'
MsjRes db 'El resultado es: ',13,10,'$'
MsjOp db 'Ingrese el operador: ',13,10,'$'
MsjErrOp db 'El operador/signo no es valido, ingrese de nuevo los valores',13,10,'$'
MsjErrCont db 'Opcion invalida, ingrese de nuevo',13,10,'$'
MsjNumFac db 'Ingrese el numero para calcular el factorial: ',13,10,'$'
MsjIFac db 'El resultado del factorial es: ',13,10,'$'
MsjOpFac db 'La operacion del factorial es: ',13,10,'$'
MsjOpFac0 db '            0! = 1',13,10,'$'
MsjOpFac1 db '            1! = 1',13,10,'$'
MsjOpFac2 db '          2! = 1*2',13,10,'$'
MsjOpFac3 db '        3! = 1*2*3',13,10,'$'
MsjOpFac4 db '      4! = 1*2*3*4',13,10,'$'
MsjOpFac5 db '    5! = 1*2*3*4*5',13,10,'$' 
MsjOpFac6 db '  6! = 1*2*3*4*5*6',13,10,'$'
MsjOpFac7 db '7! = 1*2*3*4*5*6*7',13,10,'$'
MsjErrFac db 'El numero/simbolo no es valido, ingreselo de nuevo',13,10,'$'
MsjOver db 'El resultado contiene 4 o mas cifras y por lo tanto no se puede mostrar',13,10,'$'
;-----------------------------------------------------------------
;---------------------Datos de los Numeros------------------------
;-----------------------------------------------------------------
SigNum1 db 0
UniNum1 db 0
DecNum1 db 0
Num1 db 0
SigNum2 db 0
UniNum2 db 0
DecNum2 db 0
Num2 db 0
Res db 0
DecRes db 0
UniRes db 0
CenRes db 0
Encabezado: db 'Universidad de San Carlos de Guatemala',13,10,
	       db 'Facultad de Ingenieria',13,10,
	       db 'Escuela de Ciencias y Sistemas',13,10
	       db 'Arquitectura de Compiladores y Ensambladores 1 Seccion A',13,10
  	       db 'Primer Semestre 2018',13,10,
	       db 'Francisco Ernesto Carvajal Castillo',13,10,
	       db '201504325',13,10
 	       db 'Primera Practica',13,10,
	       db '02/04/2018',13,10,
 	       db ' ',13,10,'$'
;-----------------------------------------------------------------
;---------------------Variables de Archivos-----------------------
;-----------------------------------------------------------------
TxtOpe: db '',13,10,'$'
TxtRep: db '',13,10,'$'
TxtIni: db '',13,10,'$'
TxtFac db '',13,10,'$'
handle db 0
han dw 0
HA1 db 0
HA2 db 0
hFac db 0
hOp db 0

NArchivo:dw "Reporte.rep",0
Carac: db 255

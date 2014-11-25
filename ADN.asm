;****************************************************************************
;*				Tecnologico de Costa Rica						 *
;*		        Arquitectura de Computadoras Gpo 40			         *
;*			     Segundo Proyecto Programado					 *
;*				    Secuencias de ADN						 * 
;*					  Integrantes:							 *
;*			Angulo Chavarria Sleyter 	2013388958			 	 *
;*			  Palacios Leandro David    2013194183			 	 *
;*					       Profesor:							 *
;*					Esteban Arias Mendez					 *
;****************************************************************************

section .data
	msj_Bienvenida: db "Generador de Secuencias de ADN",10,0
	len_msjBienvenida: equ $-msj_Bienvenida
	
	msj_Ingrese: db "Ingrese la cantidad de secuencias a realizar: ",10,0
	len_msjIngresar: equ $-msj_Ingrese
	leerInt: db "%d",0,10
	
	msj_Nombre: db "Ingrese el nombre del archivo: ",10,0
	len_msjNombre: equ $-msj_Nombre
	leerString: db "%s",0,10

	cambiar_Linea: db " ",10,0
	
	ext_Archivo: db ".adn",10,0
section .bss
	cant_Sec: resb 1000
	nom_Archivo: resb 100
	cad_Generada: resb 1000000
	
section .text
	extern printf
	extern srand
	extern time
	extern rand
	extern scanf
	global main
	
main:
	call imprimir_Bienvenida
	call imprimir_Ingresar
	call obtener_Cantidad
	call imprimir_Nombre
	call obtener_Nombre
	xor edx,edx
	xor ecx,ecx
	mov ecx,10
	call generar_cadena
	call generar_Archivo
	call salir
	
	
imprimir_Bienvenida:
	push msj_Bienvenida
	call printf
	add esp, 4
	ret
	
	
imprimir_Ingresar:
	push msj_Ingrese
	call printf
	add esp, 4
	ret
	
	
obtener_Cantidad:
	push cant_Sec
	push leerInt
	call scanf
	add esp,8
	ret
	
	
imprimir_Nombre:
	push msj_Nombre
	call printf
	add esp,4
	ret


obtener_Nombre:
	push nom_Archivo
	push leerString
	call scanf
	add esp,8
	ret

generar_cadena:								;Funcion que genera la cadena de ADN
	xor ecx,ecx
	push 0
	call time
	add esp,4
	
	push eax
	call srand
	add esp,4
	
	.loop:									;tengo un ciclo que realiza una serie de funciones, como generar el aleatorio de la cadena de ADN
		
		cmp esi,[cant_Sec]
		je .imprimir
		
		.generar_Aleatorio:						;genera el aleatorio de las secuencias
			push ebp
			mov ebp,esp
			
			mov ecx,29
			push ecx
			call rand
			pop ecx
			shr eax,cl
			
			mov esp, ebp
			pop ebp
			
		.agregar_cadena:						;se compara los valores aleatorios y se cambia por la respectiva letra
			cmp eax,0
			je .adenina
			
			cmp eax,1
			je .citosina
			
			cmp eax,2
			je .guanina
			
			cmp eax,3
			je .timina
			
			.avanzar:
				inc esi 	
				loop .loop
			
			.adenina:								;cambia el 0 por la letra A
				mov byte [cad_Generada+esi],"A"
				jmp .avanzar
			
			.citosina:								;cambia el 1 por la letra C
				mov byte [cad_Generada+esi],"C"
				jmp .avanzar
				
			.guanina:								;cambia el 2 por la letra G
				mov byte [cad_Generada+esi],"G"
				jmp .avanzar
				
			.timina:								;cambia el 3 por la letra T
				mov byte [cad_Generada+esi],"T"
				jmp .avanzar
		
		.imprimir:									;imprime la cadena generada
		
			mov eax,4
			mov ebx,1
			mov ecx,cad_Generada
			mov edx,1000000
			int 80h
			
			push cambiar_Linea						;imprimo el cambio de linea
			call printf
			add esp,4
	ret
	
generar_Archivo: 									;funcion que genera los archivos donde vamos a guardar la secuencias de ADN
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx
	
	.ciclo:
		mov bl, byte[nom_Archivo+ecx]
		cmp bl,0
		je .poner_Extension
		jne .continuar
	
	.poner_Extension:								;cuando llega al final del nombre pone la extension del archivo
		mov edx,[ext_Archivo]
		mov [nom_Archivo+ecx],edx
		
		jmp .guardar_Archivo
		
	.continuar:
		inc ecx
		jmp .ciclo
	
	.guardar_Archivo:								;guarda finalmente el archivo generado anteriormente con el nombre
		mov eax, 8
		mov ebx, nom_Archivo
		mov ecx, 0x0777
		int 80h
		
		mov ebx, eax
		mov eax, 4
		mov ecx, cad_Generada
		mov edx, [cant_Sec]
		int 80h
		
		mov eax, 6
		int 80h
	ret

salir:
	mov eax,1
	mov ebx,0
	int 80h
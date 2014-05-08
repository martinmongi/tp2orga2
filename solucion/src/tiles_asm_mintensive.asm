global tiles_asm

%define offset_pix 3
%define offset_#cols 32
%define offset_#filas 24
%define offset_tamx 16
%define offset_tamy 24
%define offset_offsetx 32
%define offset_offsety 40

section .data

section .text

;void tiles_asm(unsigned char *src(RDI),
				;unsigned char *dst(RSI),
				;int cols(RDX),
				;int filas(RCX), 
				;int src_row_size(R8),
				;int dst_row_size(R9),
				;int tamx(PILA),
				;int tamy(PILA),
				;int offsetx(PILA), 
				;int offsety(PILA))

tiles_asm: 
	
	PUSH RBP
	MOV RBP, RSP
	PUSH RBX
	PUSH R12
	PUSH R13
	PUSH R14
	PUSH R15
	PUSH RDX
	PUSH RCX
	PUSH R9 									;R9 = lo voy a utilizar para acceder al src
	PUSH R8 									;R8 = lo voy a utilizar para acceder al dst
	SUB RSP, 8 									;Pila: R8(ptr dst),R9(ptr src), RCX(#filas), RDX(#cols)
	XOR R10d, R10d								;recorre x en destino(R10)
	XOR R11d, R11d								;recorre y en destino(R11)
	MOV R12d, [RBP + offset_offsetx]			;recorre x en src(R12)
	MOV R13d, [RBP + offset_offsety]			;recorre y en src(R13)
	MOV R14d, R12d								;r14 = offsetx
	MOV R15d, R13d								;r15 = offsety
	MOV EBX, R9d 								;EBX = dst_row_size
	MOV ECX, R8d								;ECX = src_row_size

.loop1:
	
	CMP R11d, [RSP + offset_#filas]				;me fijo si ya pase la ultima fila del dst 
	JE .fin
	ADD RSP, 8 									;voy a guardar un puntero al dst en R8 y uno al src en R9
	POP R8
	XOR R8, R8
	MOV EAX, EBX
	MUL	R11d
	MOV R8d, EAX
	ADD R8, RSI 								;R8 = puntero a la fila en dst
	MOV EAX, [RBP + offset_tamy]						
	ADD EAX, R15d
	CMP R13d, EAX	 							;me fijo si ya pase la ultima fila del src
	JB .puntero_a_fila
	MOV R13d, R15d 

.puntero_a_fila:

	POP R9
	XOR R9, R9
	MOV EAX, ECX
	MUL R13d
	MOV R9d, EAX 									
	ADD R9, RDI 								;R9 = puntero a la fila en src
	PUSH R9
	PUSH R8
	SUB RSP, 8
	
.loop2:
	
	ADD RSP, 8
	POP R8
	POP R9
	PUSH R9
	PUSH R8
	SUB RSP, 8
	MOV EAX, offset_pix
	MUL R10d
	ADD R8, RAX									;R8 = puntero a la tira de pixeles en dst
	MOV EAX, offset_pix
	MUL R12d
	ADD R9, RAX									;R9 = puntero a la tira de pixeles en src
	
	MOV EAX, [RSP + offset_#cols] 					
	MOV EAX, [RSP + offset_#cols] 					
	LEA EAX, [EAX - 6]
	CMP R10d, EAX 								;me fijo si me faltan menos de 6 pixeles a pintar en dst
	JA .terminar_fila  							;si me faltan menos de seis pixeles salto

	MOV EAX, [RBP + offset_tamx]
	MOV EAX, [RBP + offset_tamx]
	ADD EAX, R14d                         
	LEA EAX, [EAX - 6]
	CMP R12d, EAX 								;me fijo si me faltan menos de 6 pixeles a copiar en src
	JA .terminar_bloque 		 				;si me faltan menos de seis pixeles salto
    
.copiar_pixeles:

	MOVDQU XMM0, [R9]                                
	MOVDQU XMM0, [R9]                                
	MOVDQU [R8], XMM0
	MOVDQU [R8], XMM0
	ADD R10d, 5 									;copio 5 pixeles por cada iteracion
	ADD R12d, 5
	JMP .loop2

.terminar_bloque:
	
	MOV EDX, [RBP + offset_tamx]
	MOV EDX, [RBP + offset_tamx]
	ADD EDX, R14d 							;rdx es la columna hasta donde llega el bloque a copiar 
	SUB EDX, 6                              ;en rdx tengo hasta donde tengo que retroceder r12 y r10, para que falten 6 pixeles a copiar
	
.decrementar:

	CMP R12, RDX 
	JE .listo
	SUB R12, 1
	SUB R10, 1
	JMP .decrementar

.listo:
	
	ADD RSP, 8
	POP R8
	POP R9
	PUSH R9
	PUSH R8
	SUB RSP, 8
	MOV RAX, offset_pix
	MUL R10
	ADD R8, RAX 								; ahora R8 esta apuntando a donde pegaria los ultimos 6 pixeles
	MOV RAX, offset_pix
	MUL R12
	ADD R9, RAX 								; ahora R9 esta apuntando a los ultimos 6 pixeles del bloque
 	ADD R8, 2
	ADD R9, 2 									; les sumo dos para poder pegar los 5 pixeles que me faltaban y que me entre justo en 16b
	MOVDQU XMM0, [R9]
	MOVDQU XMM0, [R9]
	MOVDQU [R8], XMM0
	MOVDQU [R8], XMM0
	ADD R10, 6
	MOV R12d, [RBP + offset_offsetx]
	JMP .loop2
		
.terminar_fila:
	
	MOV EAX, [RSP + offset_#cols]
	MOV EAX, [RSP + offset_#cols]
	SUB EAX, R10d 		                    ;CANTIDAD DE PIXELES QUE FALTAN DE DST
	PUSH RAX
	MOV EAX, [RBP + offset_tamx]
	MOV EAX, [RBP + offset_tamx]
	ADD EAX, R14d
	SUB EAX, R12d                      		;CANTIDAD DE PIXELES QUE FALTAN DE SRC
	POP RDX
	CMP EAX, EDX
	JNA .terminar_bloque                	;SI LA CANITDAD DE PIXELES QUE FALTAN DE SRC ES MENOR O IGUAL AL DST, VOY A TERMINAR BLOQUE 
	PUSH R12 								;pusheo r12, apunta a la columna a partir de donde faltar pegar la imagen 
	MOV EAX, R14d
	ADD RAX, [RBP + offset_tamx]
	SUB RAX, 6 								;lo voy usar para ver hasta donde tengo retroceder r12 para que pueda agarrar 16 bits

.retroceder:

	CMP R12d, EAX                            
	JNA .continuar                         ;me fjo que me falten 6 o mas pixeles a copiar
	SUB R12, 1  						   ;si me faltan menos, resto un pixel 
	JMP .retroceder
	
.continuar:

    POP RDX                                ;el r12 viejo
	ADD RSP, 8
	POP R8
	POP R9
	PUSH R9
	PUSH R8
	SUB RSP, 8
	PUSH RDX 								;R12 VIEJO
	MOV RDX, [RSP + offset_#cols + 8]       ; le sume un 8 porque ahora tengo pusheado el r12 viejo tambien
	MOV RDX, [RSP + offset_#cols + 8]       ; le sume un 8 porque ahora tengo pusheado el r12 viejo tambien
	SUB RDX, 6                     
	MOV RAX, offset_pix                     ;rdx = puntero a la columna faltando 6 pixeles
	MUL RDX   
	ADD R8, RAX 							 ;en r8 tengo apuntando a los ultimos 6 pixeles de dst
	MOV RAX, offset_pix
	MUL R12
	ADD R9, RAX 							;en r9 tengo apuntando a los 6 pixeles siguientes a copiar (no voy a usar todos)
	ADD R8, 2								;sumo dos para poder pegar los ultimos 15 pix y que me entre justo en 16b
	MOVDQU XMM0, [R9]				
	MOVDQU XMM0, [R9]				
	MOVDQU XMM1, [R8] 						;ultimos 16 bits de destino
	MOVDQU XMM1, [R8] 						;ultimos 16 bits de destino
	POP RAX                                 ;RAX = R12 VIEJO
	PUSH RAX

.limpiar:

	CMP RAX, R12
	JE .limpiar_dst                         ;limpio los primeros pixeles si tuve que retroceder para poder agarrar 16 bits
	PSRLDQ XMM0, 3                          
	SUB RAX, 1
	JMP .limpiar

.limpiar_dst: 

	POP R12                                 ;R12 VIEJO
	MOV RAX, [RSP + offset_#cols]           ;voy a limpiar los pixeles que van a ocupar los del src
	MOV RAX, [RSP + offset_#cols]           ;voy a limpiar los pixeles que van a ocupar los del src

.limpiar_dst2:

	CMP RAX, R10
	JE .limpiar_src
	PSLLDQ XMM1, 3
	SUB RAX, 1
	JMP .limpiar_dst2

.limpiar_src:

	MOV RAX, [RSP + offset_#cols]          ;limpio los pixeles que van a ocupar los del dst
	MOV RAX, [RSP + offset_#cols]          ;limpio los pixeles que van a ocupar los del dst
	SUB RAX, R10
	MOV RDX, offset_pix
	MUL RDX

.limpiar_src2:

	CMP RAX, 16
	JE .volver_dst
	PSLLDQ XMM0, 1
	INC RAX
	JMP .limpiar_src2

.volver_dst:
	
	MOV RAX, [RSP + offset_#cols]         ;el destino vuelve a donde estaba porque estaban bien ubicado, el src tiene qe quedar
										  ;como quedo dsp de limpiar los pixeles que no correspondian.
	MOV RAX, [RSP + offset_#cols]         ;el destino vuelve a donde estaba porque estaban bien ubicado, el src tiene qe quedar
	
.volver_dst2:

	CMP RAX, R10
	JE .listo2
	PSRLDQ XMM1, 3
	SUB RAX, 1
	JMP .volver_dst2

.listo2:
	
	POR XMM0, XMM1                         ;junto los pixeles de dst y src
	MOVDQU [R8], XMM0	
	MOVDQU [R8], XMM0	
	INC R11d 									;modifico los iteradores para bajar de fila
	INC R13d
	XOR R10d, R10d
	MOV R12d, R14d
	JMP .loop1

.fin:

	ADD RSP, 8
	POP R8
	POP R9
	POP RCX
	POP RDX
	POP R15
	POP R14
	POP R13
	POP R12
	POP RBX
	POP RBP
	RET
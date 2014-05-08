global popart_asm

section .data
ALIGN 16
obtainred_mask: DB 0xFF, 0x00, 0x00, 0xFF,
				 DB 0x00, 0x00, 0xFF, 0x00,
				 DB 0x00, 0xFF, 0x00, 0x00,
                 DB 0xFF, 0x00, 0x00, 0X00
ALIGN 16              
obtainblue_mask:   DB 0x00, 0xFF, 0x00, 0x00,
				  DB 0xFF, 0x00, 0x00, 0xFF,
                  DB 0x00, 0x00, 0xFF, 0x00,
                  DB 0x00, 0xFF, 0x00, 0X00
ALIGN 16
obtaingreen_mask: DB 0x00, 0x00, 0xFF, 0x00,
                DB 0x00, 0xFF, 0x00, 0x00,
                DB 0xFF, 0x00, 0x00, 0xFF,
                DB 0x00, 0x00, 0xFF, 0X00
     
ALIGN 16
mask_getToAlign: DB 0x00, 0x00, 0x00, 0xFF,
                 DB 0x00, 0x00, 0x00, 0x00,
				 DB 0x00, 0xFF, 0x00, 0x00,
			     DB 0x00, 0x00, 0x00, 0X00
ALIGN 16
mask_delprealigned: 
				 DB 0xFF, 0x00, 0x00, 0x00,
                 DB 0x00, 0x00, 0xFF, 0x00,
				 DB 0x00, 0x00, 0x00, 0x00,
			     DB 0xFF, 0x00, 0x00, 0X00
			     
ALIGN 16
mask_getToalignres:
				 DB 0x00, 0x00, 0xFF, 0xFF,
                 DB 0x00, 0x00, 0x00, 0x00,
				 DB 0xFF, 0xFF, 0x00, 0x00,
			     DB 0x00, 0x00, 0x00, 0X00
			     
ALIGN 16
mask_alignressum:
				 DB 0xFF, 0xFF, 0x00, 0x00,
                 DB 0x00, 0x00, 0xFF, 0xFF,
				 DB 0x00, 0x00, 0xFF, 0xFF,
			     DB 0xFF, 0xFF, 0xFF, 0xFF
ALIGN 16
mask_152:	  DB 0x98, 0x00 , 0x98,0x00 ,
              DB 0x00, 0x00, 0x98,0x00 ,
              DB 0x98, 0x00,  0x00, 0x00,
              DB 0x98,0x00 , 0x00, 0X00
              
ALIGN 16
mask_305:	  DB 0x31, 0x01, 0x31, 0x01,
              DB 0x00, 0x00, 0x31, 0x01,
              DB 0x31, 0x01, 0x00, 0x00,
              DB 0x31, 0x01, 0x00, 0x00
ALIGN 16	
mask_458: 	  DB 0xca, 0x01, 0xca, 0x01,
              DB 0x00, 0x00, 0xca, 0x01,
              DB 0xca, 0x01, 0x00, 0x00,
              DB 0xca, 0x01, 0x00, 0x00 
ALIGN 16	
mask_611:     DB 0x63,0x02 , 0x63,0x02 , 
              DB 0x00, 0x00,  0x63,0x02 , 
              DB 0x63,0x02 ,  0x00, 0x00, 
              DB 0x63,0x02 ,  0x00, 0x00 
                       
ALIGN 16
res_L153:			DB 0xFF, 0x00, 0x00, 0xFF,
					DB 0x00, 0x00, 0xFF, 0x00,
					DB 0x00, 0xFF, 0x00, 0x00,
					DB 0xFF, 0x00, 0x00, 0x00

ALIGN 16
res_GE153L306:	   
					DB 0x7f, 0x00, 0x7f,0x7f, 
					DB 0x00, 0x7f, 0x7f,0x00, 
					DB 0x7f, 0x7f, 0x00,0x7f,
					DB  0x7f, 0x00, 0x7f,0x00
ALIGN 16
res_GE306L459:	  	DB 0xFF, 0x00, 0xFF,0xFF,
					DB  0x00, 0xFF, 0xFF,0x00, 
					DB 0xFF, 0xFF, 0x00, 0xFF, 
					DB 0xFF, 0x00,0xFF, 0x00
ALIGN 16
res_GE459L612:	    DB 0x00, 0x00, 0xFF, 0x00,
					DB 0x00, 0xFF, 0x00, 0x00,
					DB 0xFF, 0x00, 0x00, 0xFF,
					DB 0x00, 0x00, 0xFF, 0x00
	
ALIGN 16
res_GE612:	  DB 0x00, 0xFF, 0xFF, 0x00,
              DB 0xFF, 0xFF, 0x00, 0xFF,
              DB 0xFF, 0x00, 0xFF, 0xFF,
              DB 0x00, 0xFF, 0xFF, 0x00
              
ALIGN 16
mask_neg: 	  DB 0xFF, 0xFF, 0xFF, 0xFF,
              DB 0x00, 0x00, 0xFF, 0xFF,
              DB 0xFF, 0xFF, 0x00, 0x00,
              DB 0xFF, 0xFF, 0x00, 0X00
              
         
section .text
;void popart_c    (
;	unsigned char *src, RDI2
;	unsigned char *dst,	RSI
;	int cols,			RDX
;	int filas,			RCX
;	int src_row_size,	R8
;	int dst_row_size)	R9
popart_asm: 
					; en RDI viene puntero a primer color de primer pixel source
push rbp			; en RSI viene puntero a primer color de primer pixel destination
mov rbp, rsp 		; en RDX viene la cantidad de columnas
push R12					; en RCX vien	e la cantidad de filas
push R13					; en R8 viene el tamaño de una fila en bytes source en R9 lo mismo pero de destination
push R14

mov rax, RDX
xor R15,R15
mov R15, 3
mul R15					
mov R13, RAX			; en R13d tengo la cantidad de columnas de bytes efectivas


xor RAX, RAX
mov rax, R13			; en R13 esta la cantidad de columnas de bytes efectivas
xor R15,R15
mov R15, 15
div R15 				
	
							; EN  R13 tengo la cantidad de columnas byte
push RDI					; en RAX va a estar el resultado de la division
push RSI					; en RDX viene el resto		
push RCX					; en RCX la cantidad de filas
							; R8, R9, src_Rows_size
							;RDI, RSI, punteros src, dst


comienzo_fila:

		 
		push RDI
		push RSI
		mov R12, R13			; en r12d tengo la cantidad de columnas bytes que tengo, le voy a quitar de a 15 hasta llegar al modulo (sobrantes)

		movdqu xmm7, [RDI]
		add rdi, 15

		cicloColDeRow:
		PXOR XMM15, XMM15

		movdqu xmm0, xmm7
		mov rax, r12
		sub rax, 15
		cmp rdx, rax
		je .listo1

		movdqu xmm7, [RDI]
		jmp .listo2

.listo1:

		sub rdi, 15		

.listo2:

		movdqu xmm1, xmm0	
		movdqu xmm2, xmm0
		movdqu xmm3, xmm0
		movdqu xmm4, xmm0
		
		pslldq xmm0, 13			; PIXEL mas a la izquierda de la imagen   
										
		psrldq xmm0, 13			; 
		PUNPCKLBW XMM0, XMM15 
		movdqu xmm5,xmm0     	; 
		movdqu xmm6,xmm0
		
		psrldq xmm0, 4		; RED
		pslldq xmm5, 12		; GREEN
		psrldq xmm5, 14
		pslldq xmm6, 14		; BLUE
		psrldq xmm6, 14
		
		paddw xmm0, xmm5
		paddw xmm0, xmm6
		
		pslldq xmm1, 10			; 
		psrldq xmm1, 13			
		PUNPCKLBW XMM1, XMM15
		movdqu xmm5,xmm1		; 
		movdqu xmm6,xmm1		; 
		
		psrldq xmm1, 4		; RED
		pslldq xmm5, 12		; GREEN
		psrldq xmm5, 14
		pslldq xmm6, 14		; BLUE
		psrldq xmm6, 14
		
		paddw xmm1, xmm5
		paddw xmm1, xmm6
		
		pslldq xmm2, 7
		psrldq xmm2, 13			; 
		PUNPCKLBW XMM2, XMM15
		movdqu xmm5,xmm2		; 
		movdqu xmm6,xmm2		;
		
		psrldq xmm2, 4		; RED
		pslldq xmm5, 12		; GREEN
		psrldq xmm5, 14
		pslldq xmm6, 14		; BLUE
		psrldq xmm6, 14
		
		paddw xmm2, xmm5
		paddw xmm2, xmm6
		
		pslldq xmm3, 4
		psrldq xmm3, 13			; 
		PUNPCKLBW XMM3, XMM15
		movdqu xmm5,xmm3		; 
		movdqu xmm6,xmm3		;
		
		psrldq xmm3, 4		; RED
		pslldq xmm5, 12		; GREEN
		psrldq xmm5, 14
		pslldq xmm6, 14		; BLUE
		psrldq xmm6, 14
		
		paddw xmm3, xmm5
		paddw xmm3, xmm6
		
		pslldq xmm4, 1			; pixel mas a la derecha.
		psrldq xmm4, 13			; 
		PUNPCKLBW XMM4, XMM15
		movdqu xmm5,xmm4		; 
		movdqu xmm6,xmm4		;
		
		psrldq xmm4, 4		; RED
		pslldq xmm5, 12		; GREEN
		psrldq xmm5, 14
		pslldq xmm6, 14		; BLUE
		psrldq xmm6, 14
		
		paddw xmm4, xmm5
		paddw xmm4, xmm6

		PXOR xmm15, xmm15
		
		POR xmm15, xmm0
		pslldq xmm1, 2
		POR xmm15, xmm1
		pslldq xmm2, 6
		POR xmm15, xmm2
		pslldq xmm3, 8
		POR xmm15, xmm3
		pslldq xmm4, 12
		POR xmm15, xmm4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		movdqu xmm1, xmm15
		movdqu xmm2, xmm15
		movdqu xmm3, xmm15
		movdqu xmm4, xmm15
		movdqu xmm5, xmm15
		
		
		
		;; EN XMM0 TENGO LA SUMA DE LOS 3 COLORES.
		;; en xmm1 y xmm2 tambien
		pcmpgtw xmm1, [mask_152]
		pxor xmm1, [mask_neg]
							; MENOR QUE 153
		movdqu xmm0, xmm1
		pand xmm0, [mask_getToalignres]
		psrldq xmm0, 1
		pand xmm1, [mask_alignressum]
		por xmm1, xmm0
		
		
		movdqu xmm0, xmm1
		pslldq xmm1, 1
		por xmm1,xmm0
		

		pand xmm1, [res_L153]	; en xmm1 ya tendria los resultados de los pixeles que son menores que 153
		
		;;;;;;;;;;;;;;			; 
		movdqu xmm0, xmm2
		
		pcmpgtw xmm2, [mask_152]			; >= 153
		pcmpgtw xmm0, [mask_305]			; < 306
		pxor xmm0, [mask_neg]
		
		pand xmm2, xmm0
		
		movdqu xmm0, xmm2
		pand xmm0, [mask_getToalignres]
		pslldq xmm0, 1
		pand xmm2, [mask_alignressum]
		por xmm2, xmm0
		
		
		movdqu xmm0, xmm2
		pslldq xmm2, 1
		por xmm2, xmm0
		
	
		pand xmm2, [res_GE153L306]
		
		
		;;;;;;;;;;;;;;;;;;,
		
								; >= 306
		movdqu xmm0, xmm3
		pcmpgtw xmm3, [mask_305]
		pcmpgtw xmm0, [mask_458]		; <459
		pxor xmm0, [mask_neg]
		pand xmm3, xmm0
		
		movdqu xmm0, xmm3
		pand xmm0, [mask_getToalignres]
		pslldq xmm0, 1
		pand xmm3, [mask_alignressum]
		por xmm3, xmm0
		
		movdqu xmm0, xmm3
		pslldq xmm3, 1
		por xmm3, xmm0
		

		pand xmm3, [res_GE306L459]
		
		;;;;;;;;;;;;;;;;;;;;;
		
		

		movdqu xmm0, xmm4
		pcmpgtw xmm4, [mask_458]
		pcmpgtw xmm0, [mask_611]
		pxor xmm0, [mask_neg]
		pand xmm4, xmm0
		
		movdqu xmm0, xmm4
		pand xmm0, [mask_getToalignres]
		pslldq xmm0, 1
		pand xmm4, [mask_alignressum]
		por xmm4, xmm0
		
		movdqu xmm0, xmm4
		pslldq xmm4, 1
		por xmm4, xmm0
		
	
		pand xmm4, [res_GE459L612]
		
		;;;;;;;;;;;;;;;;;;;;;;;;
		
		pcmpgtw xmm5, [mask_611]
	
		
		movdqu xmm0, xmm5
		pand xmm0, [mask_getToalignres]
		pslldq xmm0, 1
		pand xmm5, [mask_alignressum]
		por xmm5, xmm0
		
		movdqu xmm0, xmm5
		pslldq xmm5, 1	
		por xmm5, xmm0
		
		
		pand xmm5, [res_GE612]
	
		
		
		por xmm1, xmm2
		por xmm1, xmm3
		por xmm1, xmm4
		por xmm1, xmm5
		

		
		movdqu [RSI], xmm1	; en el byte menos significativo hay 0's en xmm0

		proxIteracionEnFilaActual:
		add RDI, 15					; agrego a RDI 15, avanzo el puntero que apunta a la fila 15 posiciones para agarrar siguientes 5 pix 
		add RSI, 15					; lo mismo aca, RSI es el puntero a la imagen detino
		sub R12, 15				; resto a R12d 15, indicando que ya procesé 5(15 bytes) pixeles en una iteración
		cmp R12, RDX				; comparo R12d con RDX, que son los bytes que sobrarian al final
		JNE cicloColDeRow			; si no dan iguales es porque aun quedas pixeles dentro del rango procesable en paralelo
		;si da iguales aca voy a pasar a la siguiente fila, todavia me queda por hacer una ultima barrida de los bytes (modulo) sobrantes
		;(veo si quedan filas por recorrer)
		sub RCX, 1					; completé una fila
		cmp RCX, 0					; en RCX tengo la cantidad de FILAS, si da 0 es porque ya recorrí todas las filas
		JE completar_sobrante_de_filas
		pop RSI
		pop RDI
		add RDI, R8					; le sumo al puntero original al comienzo de la fila el src_row_size para pasar a la sig fila
		add RSI, R9					; lo mismo para RSI

		jmp comienzo_fila


completar_sobrante_de_filas:		; necesito el modulo que me indica la cantidad de bytes que sobraron ( va a ser un multiplo de 3)
	pop RSI								;ultimos pop de la salida del ciclo
	pop RDI								; necesito la cantidad de filas
	

	pop RCX			; vuelvo a tener la cantidad de filas
	pop RSI			; vuelvo a tener aca los puntero originales al comienzo de las imagenes
	pop RDI
	
	
	sub R13, 16
	;sub R13, RDX	; en r13d tengo la cantidad de bytes efectivos de una fila, le resto cant sobrante para desplazar punteros
	add RSI, R13	; sumo a punteros el desplazamiento necesario para caer en lo que me falto procesar.
	add RDI, R13
					 ; aca voy a procesar de a pixel, es decir tomando de a double words.
						 ; en ECX tengo el resto, necesito saber cuantas word entran

	cmp RDX, 0
	JE terminado
	
	nuevaFiladeResto:
	
	mov R15, 16
	sub R15, RDX
	
	cicloDeFila_en_resto:


	
	movdqu xmm0, [RDI]
	
	
	; EN R15 tengo la cantidad que no me interesa
	
	push R15
	ciclo_shifteo_der:
	psrldq xmm0, 1
	sub R15, 1
	cmp R15, 0 
	JNE ciclo_shifteo_der
	pop R15
	
	
	
	movdqu xmm1, xmm0
	movdqu xmm2, xmm0
	
		pand xmm0, [obtainblue_mask]		; tengo el blue de 5 pixeles
		pand xmm1, [obtainred_mask]		; tengo el green
		pand xmm2, [obtaingreen_mask]			; tengo el red
	
		psrldq xmm0, 1
		psrldq xmm2, 2
	
	movdqu xmm3, xmm0
	pand xmm3, [mask_getToAlign]
	psrldq xmm3, 1
	pand xmm0, [mask_delprealigned]
	por xmm0, xmm3
		
	movdqu xmm3, xmm1
	pand xmm3, [mask_getToAlign]
	psrldq xmm3, 1
	pand xmm1, [mask_delprealigned]
	por xmm1, xmm3
		
	movdqu xmm3, xmm2
	pand xmm3, [mask_getToAlign]
	psrldq xmm3, 1
	pand xmm2, [mask_delprealigned]
	por xmm2, xmm3
	
	
	
		paddw xmm0, xmm1		; sumo de a double words los 2 primeros colores 
		paddw xmm0, xmm2	
	
	
		movdqu xmm1, xmm0
		movdqu xmm2, xmm0
		movdqu xmm3, xmm0
		movdqu xmm4, xmm0
		movdqu xmm5, xmm0
	
	pcmpgtw xmm1, [mask_152]
		pxor xmm1, [mask_neg]
							; MENOR QUE 153
		movdqu xmm0, xmm1
		pand xmm0, [mask_getToalignres]
		psrldq xmm0, 1
		pand xmm1, [mask_alignressum]
		por xmm1, xmm0
		
		
		movdqu xmm0, xmm1
		pslldq xmm1, 1
		por xmm1,xmm0
		

		pand xmm1, [res_L153]	; en xmm1 ya tendria los resultados de los pixeles que son menores que 153
		
		;;;;;;;;;;;;;;			; 
		movdqu xmm0, xmm2
		
		pcmpgtw xmm2, [mask_152]			; >= 153
		pcmpgtw xmm0, [mask_305]			; < 306
		pxor xmm0, [mask_neg]
		
		pand xmm2, xmm0
		
		movdqu xmm0, xmm2
		pand xmm0, [mask_getToalignres]
		pslldq xmm0, 1
		pand xmm2, [mask_alignressum]
		por xmm2, xmm0
		
		
		movdqu xmm0, xmm2
		pslldq xmm2, 1
		por xmm2, xmm0
		
	
		pand xmm2, [res_GE153L306]
		
		
		;;;;;;;;;;;;;;;;;;,
		
								; >= 306
		movdqu xmm0, xmm3
		pcmpgtw xmm3, [mask_305]
		pcmpgtw xmm0, [mask_458]		; <459
		pxor xmm0, [mask_neg]
		pand xmm3, xmm0
		
		movdqu xmm0, xmm3
		pand xmm0, [mask_getToalignres]
		pslldq xmm0, 1
		pand xmm3, [mask_alignressum]
		por xmm3, xmm0
		
		movdqu xmm0, xmm3
		pslldq xmm3, 1
		por xmm3, xmm0
		

		pand xmm3, [res_GE306L459]
		
		;;;;;;;;;;;;;;;;;;;;;
		
		

		movdqu xmm0, xmm4
		pcmpgtw xmm4, [mask_458]
		pcmpgtw xmm0, [mask_611]
		pxor xmm0, [mask_neg]
		pand xmm4, xmm0
		
		movdqu xmm0, xmm4
		pand xmm0, [mask_getToalignres]
		pslldq xmm0, 1
		pand xmm4, [mask_alignressum]
		por xmm4, xmm0
		
		movdqu xmm0, xmm4
		pslldq xmm4, 1
		por xmm4, xmm0
		
	
		pand xmm4, [res_GE459L612]
		
		;;;;;;;;;;;;;;;;;;;;;;;;
		
		pcmpgtw xmm5, [mask_611]
	
		
		movdqu xmm0, xmm5
		pand xmm0, [mask_getToalignres]
		pslldq xmm0, 1
		pand xmm5, [mask_alignressum]
		por xmm5, xmm0
		
		movdqu xmm0, xmm5
		pslldq xmm5, 1	
		por xmm5, xmm0
		
		
		pand xmm5, [res_GE612]
	
		
		
		por xmm1, xmm2
		por xmm1, xmm3
		por xmm1, xmm4
		por xmm1, xmm5
	
		push R15
		ciclo_shifteo_izq:
		pslldq xmm1, 1
		sub R15, 1
		cmp R15, 0 
		JNE ciclo_shifteo_izq
		pop R15
	
	movdqu xmm3, [RSI]
	
	
	
	
	push RDX
	ciclo_shf_izq:
	pslldq xmm3, 1
	sub RDX,1
	cmp RDX,0 
	JNE ciclo_shf_izq
	pop RDX
	
	push RDX
	ciclo_shf_der:
	psrldq xmm3, 1
	sub RDX,1 
	cmp RDX, 0 
	JNE ciclo_shf_der
	pop RDX
	
	por xmm1, xmm3
	movdqu [RSI], xmm1
	
	;;; procesar WORD (pixel tomado), avanzo de a 3 (1 pixel)

	proxIter:
	add RDI, R8
	add RSI, R9
	sub RCX, 1			; resto una fila del resto procesada, en RCX estan las filas
	cmp RCX, 0 			; me fijo si faltan mas filas
	JNE cicloDeFila_en_resto



terminado:
pop R14
pop R13
pop R12
pop rbp
ret

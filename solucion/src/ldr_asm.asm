
global ldr_asm

section .data

ALIGN 16
mask_maximo: DB 0x4B, 0x6A, 0x4A, 0x00,
			DB 0x00, 0x00, 0x00, 0x00,
			DB 0x00, 0x00, 0x00, 0x00,
			DB 0x00, 0x00, 0x00, 0x00
ALIGN 16
mask_soloInteresaFstQw:
			DB 0xFF, 0xFF, 0xFF, 0xFF,
			DB 0xFF, 0xFF, 0xFF, 0xFF,
			DB 0x00, 0x00, 0x00, 0x00,
			DB 0x00, 0x00, 0x00, 0x00
			
ALIGN 16
obtainblue_mask: DB 0xFF, 0x00, 0x00, 0xFF,
				 DB 0x00, 0x00, 0xFF, 0x00,
				 DB 0x00, 0xFF, 0x00, 0x00,
                 DB 0xFF, 0x00, 0x00, 0X00
ALIGN 16              
obtaingreen_mask:   DB 0x00, 0xFF, 0x00, 0x00,
				  DB 0xFF, 0x00, 0x00, 0xFF,
                  DB 0x00, 0x00, 0xFF, 0x00,
                  DB 0x00, 0xFF, 0x00, 0X00
ALIGN 16
obtainred_mask: DB 0x00, 0x00, 0xFF, 0x00,
                DB 0x00, 0xFF, 0x00, 0x00,
                DB 0xFF, 0x00, 0x00, 0xFF,
                DB 0x00, 0x00, 0xFF, 0X00
     
ALIGN 16
mask_pixDelMedio:
				DB 0x00, 0x00, 0x00, 0x00,
				DB 0x00, 0x00, 0xFF, 0xFF,
				DB 0xFF, 0x00, 0x00, 0x00,
				DB 0x00, 0x00, 0x00, 0x00
ALIGN 16
limpiar_pixelDst:
				DB 0xFF, 0xFF, 0xFF, 0xFF,
				DB 0xFF, 0xFF, 0x00, 0x00,
				DB 0x00, 0xFF, 0xFF, 0xFF,
				DB 0xFF, 0xFF, 0xFF, 0xFF
ALIGN 16
mask_quedanDosUltsPix:
				DB 0x00, 0x00, 0x00, 0x00,
				DB 0x00, 0x00, 0x00, 0x00,
				DB 0x00, 0x00, 0xFF, 0xFF,
				DB 0xFF, 0xFF, 0xFF, 0xFF
ALIGN 16
mask_quedanDosPrmsPix:
				DB 0xFF, 0xFF, 0xFF, 0xFF,
				DB 0xFF, 0xFF, 0x00, 0x00,
				DB 0x00, 0x00, 0x00, 0x00,
				DB 0x00, 0x00, 0x00, 0x00
ALIGN 16
mask_limpiarPrmsPix:
				DB 0x00, 0x00, 0x00, 0x00,
				DB 0x00, 0x00, 0xFF, 0xFF,
				DB 0xFF, 0xFF, 0xFF, 0xFF,
				DB 0xFF, 0xFF, 0xFF, 0xFF
ALIGN 16
mask_limpiarUltPixs:
				DB 0xFF, 0xFF, 0xFF, 0xFF,
				DB 0xFF, 0xFF, 0xFF, 0xFF,
				DB 0xFF, 0xFF, 0x00, 0x00,
				DB 0x00, 0x00, 0x00, 0x00

section .text
;void ldr_asm    

	
	;unsigned char *src, RDI
    ;unsigned char *dst, RSI
    ;int cols,			 RDX
    ;int filas,			 RCX
    ;int src_row_size,  R8
    ;int dst_row_size, R9
	;int alfa en pila
ldr_asm:
push rbp
mov rbp, rsp
push R12
push R13
push R14


push RDI
push RSI


mov R13, RDX
sub R13, 4			; en R13 tengo la cantidad de desplazamientos de recuadros en filas.
mov R12, RCX
sub R12, 4			; en R12 tengo la cantidad de desplaza. de recuadros en col.

barrida_nueva:
	push R13 
	push RDI
	push RSI
	barrida_actual:
		movdqu XMM0, [RDI + 0]
		movdqu XMM1, [RDI + R8]
		
		movdqu XMM2, [RDI + 2*R8]		; el del medio de XMM2 es el pixel actual a mofidicar en base a los de alrededor
		push R8
		mov R14, R8
		add R8, R14
		add R8, R14
		
		movdqu XMM3, [RDI + R8]
		pop R8
		movdqu XMM4, [RDI + 4*R8]
		
		PXOR XMM15, XMM15
		
		
		MOVDQU xmm5, xmm0     ; voy a usar xmm5 para el high de xmm0
		PUNPCKLBW XMM0, XMM15 ; uso el xmm0 para el low de xmm0  
		PUNPCKHBW xmm5, xmm15
		pslldq xmm5, 2
		psrldq xmm5, 2
		
		MOVDQU XMM6, xmm1     ; voy a usar xmm6 para el high de xmm1
		PUNPCKLBW XMM1, XMM15 ; uso xmm1 para low de xmm1
		PUNPCKHBW XMM6, XMM15
		pslldq xmm6, 2
		psrldq xmm6, 2
		
		MOVDQU XMM7, xmm2     ; voy a usar xmm6 para el high de xmm1
		PUNPCKLBW XMM2, XMM15 ; uso xmm2 para low de xmm1
		PUNPCKHBW XMM7, XMM15
		pslldq xmm7, 2
		psrldq xmm7, 2
		
		MOVDQU XMM8, xmm3     ; voy a usar xmm6 para el high de xmm1
		PUNPCKLBW XMM3, XMM15 ; uso xmm3 para low de xmm1
		PUNPCKHBW XMM8, XMM15
		pslldq xmm8, 2
		psrldq xmm8, 2
		
		MOVDQU XMM9, xmm4     ; voy a usar xmm6 para el high de xmm1
		PUNPCKLBW XMM4, XMM15 ; uso xmm4 para low de xmm1
		PUNPCKHBW XMM9, XMM15
		pslldq xmm9, 2
		psrldq xmm9, 2
		
		
		paddw xmm0, xmm1
		paddw xmm0, xmm2
		paddw xmm0, xmm3
		paddw xmm0, xmm4
		
		paddw xmm5, xmm6
		paddw xmm5, xmm7
		paddw xmm5, xmm8
		paddw xmm5, xmm9
		
		
		
		paddw xmm0, xmm5
		
		
		
		movdqu xmm1, xmm0
		pslldq xmm1, 8
		psrldq xmm1, 8
		
		psrldq xmm0, 8
		
		
		paddw xmm0, xmm1
		
		
		movdqu xmm1, xmm0
		pslldq xmm1, 12
		psrldq xmm1, 12
		
		psrldq xmm0, 4
		
		paddw xmm0, xmm1
		
		movdqu xmm1, xmm0
		pslldq xmm1, 14
		psrldq xmm1, 14
		
		psrldq xmm0, 2
		
		paddw xmm0, xmm1
		
		
		
		
		movdqu xmm1, xmm0 
		movdqu xmm2, xmm0 
		; en XMM0/XMM1/XMM2 ACA YA TENGO SUMARGB
		
		movdqu XMM3, [RDI + 2*R8] ; necesito el pixel del medio
		pand XMM3, [mask_pixDelMedio]
		movdqu xmm4, xmm3
		movdqu xmm5, xmm3
		
		pand xmm3, [obtainblue_mask]
		pand xmm4, [obtaingreen_mask]
		pand xmm5, [obtainred_mask]
		
		psrldq xmm3, 6
		psrldq xmm4, 7
		psrldq xmm5, 8
		
	
		
		PMULUDQ xmm0, xmm3		;color del que se modifica por sumargb
		
		PMULUDQ xmm1, xmm4
		
		PMULUDQ xmm2, xmm5

		;movdqu xmm6, [RBP + 16]					; RECUPERO EL ALFA
		;pand xmm6, [mask_limpiarHigh]		
		movdqu xmm6, [RBP + 16]		
		
		
		PMULUDQ xmm0, xmm6	
		
		PMULUDQ xmm1, xmm6
		
		PMULUDQ xmm2, xmm6
		break_doubles:
		
		CVTDQ2PD XMM0,XMM0
		
		CVTDQ2PD XMM1,XMM1
		CVTDQ2PD XMM2,XMM2
		
		MOVDQU XMM6, [mask_maximo]
		CVTDQ2PD XMM6,XMM6
		
		DIVPD XMM0, XMM6
		PAND XMM0, [mask_soloInteresaFstQw] 
		 
		DIVPD XMM1,	XMM6	
		PAND XMM1, [mask_soloInteresaFstQw] 
		
		DIVPD XMM2,	XMM6
		PAND XMM2, [mask_soloInteresaFstQw] 
	
		CVTTPD2DQ XMM0, XMM0          ; varb             en xmm3 tengo el blue del a modificar
		CVTTPD2DQ XMM1, XMM1			 ; varg				en xmm4 tengo el green
		CVTTPD2DQ XMM2, XMM2          ;varr              en xmm5 el red
		
		PADDUSB XMM0, xmm3     ; dest b
		PADDUSB XMM1, xmm4     ; dest g
		PADDUSB XMM2, xmm5		; dest r	
		
		pslldq xmm0, 6 
		pslldq xmm1, 7
		pslldq xmm2, 8
		
		PXOR XMM4, XMM4 ; aca voy a meter el unico pixel procesado para subirlo a img dest
		
		POR XMM4, xmm0
		POR XMM4, XMM1
		POR XMM4, XMM2
		
		movdqu xmm6, [RSI + 2*R9]
		PAND xmm6, [limpiar_pixelDst]
		por xmm4, xmm6
		
		movdqu [RSI + 2*R9], XMM4
		
		
		add RDI, 3
		add RSI, 3
		sub R13, 1

		cmp R13, 0 ; termine de hacer un barrido en fila, me sobra ultimo recuadro que toma parte del padding final.
		JNE barrida_actual 
		pop RSI
		pop RDI
		pop R13
		
		add RSI, R9 
		
		add RDI, R8
		
		sub R12, 1
		cmp R12, 0 ; me fijo si termine las filas
		JE termine_centro
		jmp barrida_nueva 


termine_centro:
pop RSI
pop RDI
	;unsigned char *src, RDI
    ;unsigned char *dst, RSI
    ;int cols,			 RDX
    ;int filas,			 RCX
    ;int src_row_size,  R8
    ;int dst_row_size, R9
push RCX	
mov rax, RDX
xor R15,R15
mov R15, 3
mul R15					
mov R13, RAX			; en R13 tengo la cantidad de columnas de bytes efectivas

xor RAX, RAX
mov rax, R13			; en R13 esta la cantidad de columnas de bytes efectivas
xor R15,R15
mov R15, 15
div R15 				; en RAX viene el COCIENTE
						; en RDX viene el RESTO
						
push RDI
push RSI
					
			ciclo_resto_grande_arriba:
				push R13
				ciclo_fila_resto_grande:
				movdqu xmm0, [RDI]
				movdqu xmm1, [RDI + R8] 
				
				movdqu [RSI], xmm0
				movdqu [RSI + R9], xmm1
				
				sub R13, 15
				add RDI, 15
				add RSI, 15
				
				cmp R13, RDX
				JNE ciclo_fila_resto_grande
				pop R13	
				cmp RDX, 0 ; ver si el resto es 0
				JE termine_continuo_resto_grande_abajo
				pop RSI
				pop RDI
				
				push RDI
				push RSI
				
				push R13
				
				sub R13, 16
				movdqu xmm0, [RDI + R13]
				
				push R13
				add R13, R8
				movdqu xmm1, [RDI + R13]
				pop R13
				movdqu [RSI + R13], xmm0
				push R13
				add R13, R9
				movdqu [RSI + R13], xmm1
				pop R13
			
				pop R13
				
				
				termine_continuo_resto_grande_abajo:
				; R13 tengo cantidad de byte efectivos
pop RSI			; vuelvo a tener punteros al principio
pop RDI
pop RCX

push RCX
push RSI
push RDI

								
					
					mov rax, R8	
					xor R15,R15
					mov R15, RCX
					sub R15, 2			
					mul R15		
					mov R12, RAX
					
					mov rax, R9
					xor R15, R15
					mov R15, RCX
					sub R15, 2
					mul R15
					mov R14, RAX
					
					xor RAX, RAX
					mov rax, R13		 ; EN RDX voy a tener resto
					xor R15,R15
					mov R15, 15
					div R15 
				
				push R13
				ciclo_filas_abajo:
				movdqu xmm0, [RDI + R12]
				push R12
				add R12, R8
				movdqu xmm1, [RDI + R12]
				pop R12 	
				
				movdqu [RSI + R14], xmm0
				push R14
				add R14, R9
				movdqu [RSI + R14], xmm1
				pop R14
				
				
				add RDI, 15
				add RSI, 15	
				sub R13, 15
				cmp R13, RDX
				JNE ciclo_filas_abajo
				pop R13
				
				cmp RDX, 0 
				JE termine_ciclo_filas_abajo
				
				pop RDI
				pop RSI
				
				push RSI
				push RDI
				
				push R13
					
				sub R13, 16
				
				push R13
				add R13, R14
				movdqu xmm0, [RDI + R13]
				pop R13
				
				push R13
				add R13, R14
				add R13, R8
				movdqu xmm1, [RDI + R13]
				pop R13
				
				push R13
				add R13, R14
				movdqu [RSI + R13], xmm0
				pop R13
				
				push R13
				add R13, R14
				add R13, R9
				movdqu [RSI + R13], xmm1
				pop R13
			 
				pop R13	
				termine_ciclo_filas_abajo:

pop RDI				; PUNTERO ORIGINAL SRC
pop RSI				; PUNTERO ORIGINAL DEST
pop RCX				; R13 CANTIDAD DE BYTES EFECTIVOS
					; RCX tiene FILAS
					
					sub RCX, 2				; cantidad de filas -2
					mov R12, 2				; empiezo desde la fila 2, contador hasta que sea igual a RCX
					
					
					
					add RSI, R8				; comienzo desde la 2da FILA 
					add RSI, R8
					add RDI, R9
					add RDI, R9
					
					sub R13, 16				; en R13 tengo lo que hay que sumarle a RDI para agarrar los ultimos 16
					
					ciclo_margenes_centro:
					
				
					movdqu xmm0, [RDI]		; primeros 2 pixeles de fila actual
					movdqu xmm1, [RDI + R13]; ultimos 2 pixeles de fila actual
					
					movdqu xmm2, [RSI]
					movdqu xmm3, [RSI + R13]
					
					pand xmm0, [mask_quedanDosPrmsPix]
					pand xmm1, [mask_quedanDosUltsPix]
					
					pand xmm2, [mask_limpiarPrmsPix]
					pand xmm3, [mask_limpiarUltPixs]
					
					por xmm0, xmm2
					por xmm1, xmm3
					
					movdqu [RSI], xmm0
					movdqu [RSI + R13], xmm1
					
					
					add RSI, R9
					add RDI, R8
					
					
					INC R12
					cmp R12, RCX
					JNE ciclo_margenes_centro 
	
pop R14
pop R13
pop R12
pop RBP
ret
 

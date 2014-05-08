global temperature_asm

%define offset_pixel 3

section .data

align 16
mascara_blue: DB 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

align 16
mascara_green: DB 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00

align 16
mascara_red: DB 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00

align 16
mascara_alinear: DB 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00

align 16
tres: dd 3.0, 3.0, 3.0, 3.0 

align 16
cuatro: dd 4, 4, 4, 4 

align 16
nro_32: dd 32, 32, 32, 32

align 16
nro_96: dd 96, 96, 96, 96

align 16
nro_128: dd 128, 128, 128, 128

align 16
nro_160: dd 160, 160, 160, 160

align 16
nro_224: dd 224, 224, 224, 224

align 16
nro_255: dd 255, 255, 255, 255

align 16
mayor_31: dd 31, 31, 31, 31

align 16
mayor_95: dd 95, 95, 95, 95

align 16
mayor_159: dd 159, 159, 159, 159

align 16
mayor_223: dd 223, 223, 223, 223

align 16
mascara_unos: DQ -1, -1 

align 16
mascara_juntar1: DB 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  

align 16
mascara_juntar2: DB 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  

align 16
mascara_juntar3: DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  

align 16
mascara_juntar4: DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00,  

section .text
;void temperature_asm(unsigned char *src(RDI),
;              unsigned char *dst(RSI),
;              int cols (RDX),
;              int fila (RCX),
;              int src_row_size(R8),
;              int dst_row_size(R9));

temperature_asm:

	PUSH RBP
	MOV RBP, RSP
	PUSH RBX
	PUSH R12
	PUSH R13
	PUSH R14
	PUSH R15
	SUB RSP, 8
	XOR R12, R12 									;itera en x dst y src
	XOR R13, R13 									;itera en y dst y src
	MOV R14d, EDX	 								;R14 = #cols
	MOV R15d, ECX 									;R15 = #fila
	XOR R10, R10 									;puntero a la tira de pixeles de src
	XOR R11, R11									;puntero a la tira de pixeles de dst
	PUSH R10
	PUSH R11

.loop1:
	
	CMP R13d, R15d									;me fijo si ya pase la ultima fila
	JE .fin
	POP R11
	POP R10
	XOR R10, R10
	XOR R11, R11
	MOV EAX, R13d
	MUL R8
	MOV R10d, EAX
	ADD R10, RDI									;puntero a la fila correspondiente en src
	MOV EAX, R13d
	MUL R9
	MOV R11d, EAX
	ADD R11, RSI 									;puntero a la fila correspondiente en dst
	PUSH R10
	PUSH R11

.loop2:
	
	CMP R12d, R14d 									;me fijo si ya termine la fila
	JE .bajar
	LEA EAX, [R14d - 2]
	CMP R12d, EAX 									;me fijo si me falta un bit no mas 
	JE .ultimos_pixeles
	LEA EAX, [R14d - 6]
	CMP R12d, EAX  									;me fijo si me faltan menos de seis pixeles
	JNA .filtrar
	POP R11
	POP R10
	PUSH R10
	PUSH R11
	MOV EAX, offset_pixel
	LEA EBX, [R14-6]
	MUL EBX
	ADD R10, RAX
	ADD R11, RAX
	MOVDQU XMM0, [R10]
	MOVDQU XMM15, XMM0
	LEA R12d, [R14d -2]
	JMP .arrancar

.ultimos_pixeles:

	INC R12d
	INC R12d
	LEA EBX, [R14d - 6]
	MOV EAX, offset_pixel
	MUL EBX
	POP R11
	POP R10
	PUSH R10
	PUSH R11
	LEA R10, [R10 + RAX + 2]
	LEA R11, [R11 + RAX + 2]
	MOVDQU XMM0, [R10] 								;src
	MOVDQU XMM15, [R11]  							;dst
	PSLLDQ XMM15, 12
	PSRLDQ XMM15, 12
	PSRLDQ XMM0, 4
	JMP .arrancar

.bajar:

	INC R13d
	XOR R12, R12
	JMP .loop1

.filtrar:
	
	POP R11
	POP R10
	PUSH R10
	PUSH R11
	MOV EAX, offset_pixel
    MUL R12d
    ;..													poner ceros en la partes mas significativa por las dudas
    ADD R10, RAX 										;puntero a la tira de pixel en src
    ADD R11, RAX										;puntero a la tira de pixel en dst
    MOVDQU XMM0, [R10]	
	ADD R12d, 4
	
.arrancar:

    MOVDQU XMM1, XMM0 							
    MOVDQU XMM2, XMM0
    MOVDQU XMM3, XMM0

    PAND XMM1, [mascara_blue] 							;pongo en xmmm1 los azules (respetando la ubicacion en xmm0)
    MOVDQU XMM4, XMM1 									;los voy a alinear a double word
    MOVDQU XMM5, XMM1
    MOVDQU XMM6, XMM1
    MOVDQU XMM7, XMM1
    PAND XMM4, [mascara_alinear]
    PSLLDQ XMM5, 1
    PAND XMM5, [mascara_alinear]
    PSLLDQ XMM6, 2
	PAND XMM6, [mascara_alinear]
    PSLLDQ XMM7, 3
	PAND XMM7, [mascara_alinear]
    POR XMM4, XMM5
    POR XMM4, XMM6
    POR XMM4, XMM7
    MOVDQU XMM1, XMM4

    PAND XMM2, [mascara_green]							;pongo en xmmm2 los verdes (respetando la ubicacion en xmm0)
	MOVDQU XMM4, XMM2                               	;los voy a alinear a double word
    MOVDQU XMM5, XMM2
    MOVDQU XMM6, XMM2
    MOVDQU XMM7, XMM2
    PSRLDQ XMM4, 1
    PAND XMM4, [mascara_alinear]
    PAND XMM5, [mascara_alinear]
    PSLLDQ XMM6, 1
	PAND XMM6, [mascara_alinear]
    PSLLDQ XMM7, 2
	PAND XMM7, [mascara_alinear]
    POR XMM4, XMM5
    POR XMM4, XMM6
    POR XMM4, XMM7
    MOVDQU XMM2, XMM4
    
    PAND XMM3, [mascara_red]							;pongo en xmmm3 los rojos (respetando la ubicacion en xmm0)
    MOVDQU XMM4, XMM3 									;los voy a alinear a double word
    MOVDQU XMM5, XMM3
    MOVDQU XMM6, XMM3
    MOVDQU XMM7, XMM3
    PSRLDQ XMM4, 2
    PAND XMM4, [mascara_alinear]
    PSRLDQ XMM5, 1  
    PAND XMM5, [mascara_alinear]
	PAND XMM6, [mascara_alinear]
    PSLLDQ XMM7, 1
	PAND XMM7, [mascara_alinear]
    POR XMM4, XMM5
    POR XMM4, XMM6
    POR XMM4, XMM7
    MOVDQU XMM3, XMM4

    MOVDQU XMM0, XMM1   								;sumo los rgb
    PADDD XMM0, XMM2
    PADDD XMM0, XMM3
    CVTDQ2PS XMM1, XMM0 								;xmm1 = convierto los enteros de xmm0 en float para dividir 
    DIVPS XMM1, [tres] 									;hago el promedio 			
	CVTTPS2DQ XMM0, XMM1 								;vuelvo a convertir los floats en enteros que estan en xmm1

	MOVDQU XMM1, XMM0 									;el resultado xmm0 lo replico varias veces para los if
	MOVDQU XMM2, XMM0
	MOVDQU XMM3, XMM0
	MOVDQU XMM4, XMM0
	MOVDQU XMM5, XMM0
	MOVDQU XMM6, XMM0
	MOVDQU XMM7, XMM0
	MOVDQU XMM8, XMM0
	
	PCMPGTD XMM1, [mayor_31] 							; t > 31
	PXOR XMM1, [mascara_unos]							; (t <= 31) =  (t < 32)
	MOVDQU XMM10, XMM0
	PAND XMM10, XMM1
	PMULLD XMM10, [cuatro] 								; xmm10 = 4t
	PADDD XMM10, [nro_128]								; xmm10 = 128 + 4t 
	PAND XMM1, XMM10 									; lo ubico en los pixeles que cumple la condicion

	PCMPGTD XMM2, [mayor_31]							; (t > 31) = (t>=32)
	PCMPGTD XMM3, [mayor_95]							; (t>95)
	PXOR XMM3, [mascara_unos]							; (t<=95) = (t<96)
	PAND XMM2, XMM3                                     ; me fijo los que cumplen ambas condiciones
	MOVDQU XMM10, XMM0
	PAND XMM10, XMM2
	PSUBD XMM10, [nro_32]                               ; xmm10 = t-32
	PAND XMM10, XMM2
	PMULLD XMM10, [cuatro]                              ; xmm10 = 4(t-32)
	PSLLDQ XMM10, 1 									; lo muevo al color g
	POR XMM10, [nro_255] 								; pongo 255 en b
	PAND XMM2, XMM10 									;lo ubico en los pixeles que cumplen la condicion

	PCMPGTD XMM4, [mayor_95] 							; (t>95) = (t>=96)
	PCMPGTD XMM5, [mayor_159] 							; (t>159)
	PXOR XMM5, [mascara_unos]							; (t<=159) = (t<160)
	PAND XMM4, XMM5 									; me fijo los que cumplean ambas condiciones
	MOVDQU XMM10, XMM0
	PAND XMM10, XMM4 									; agarro los t cumplen la condicion
	PSUBD XMM10, [nro_96] 	 							; xmm10 = (t-96)
	PAND XMM10, XMM4                                    ; limpios los -96 que no van
	PMULLD XMM10, [cuatro] 	  							; xmm10 = 4(t-96)
	MOVDQU XMM11, XMM10 								; xmm11 = 4(t-96)
	MOVDQA XMM12, [nro_255] 	     					; xmm12 = 255
	MOVDQA XMM13, XMM12 								; xmm13 = 255
	PSUBD XMM13, XMM11 									; xmm13 = 255 -4(t-96)
	PAND XMM13, XMM4                                    ; limpio
	PSLLDQ XMM10, 2 									; xmm10 lo muevo al color r
	PSLLDQ XMM12, 1  									; xmm12 lo muvo al color g
	PADDB XMM10, XMM12  								; xmm10 = 4(t-96) en r y 255 en g
	PADDB XMM10, XMM13 									; xmm10 = 4(t-96) en r y 255 en g y 255 -4(t-96) en b
	PAND XMM4, XMM10
	
	PCMPGTD XMM6, [mayor_159] 							;(t>159) = (t>=160)
	PCMPGTD XMM7, [mayor_223] 							;(t>223)
	PXOR XMM7, [mascara_unos] 							; (t<=223) ) (t<224)
	PAND XMM6, XMM7 									; me fijo los que cumplen ambas condiciones
	MOVDQU XMM10, XMM0
	PAND XMM10, XMM6
	PSUBD XMM10, [nro_160] 								; xmm10 = t-160
	PAND XMM10, XMM6
	PMULLD XMM10, [cuatro]  							; xmm10 = 4(t-160)
	MOVDQA XMM11, [nro_255] 							; xmm11 = 255
	MOVDQA XMM12, XMM11 								; xmm12 = 255
	PSUBD XMM11, XMM10 									; xmm11 = 255-4(t-160) 									
	PAND XMM11, XMM6
	PSLLDQ XMM11, 1  									; xmm11 lo pongo en el color g
	PSLLDQ XMM12, 2 									; xmm12 lo pongo en el color r
	POR XMM11, XMM12 									; xmm11 = 255 en el color r, 255-4(t-160) en g
	PAND XMM6, XMM11 									; lo ubico en los pixeles que cumplen la condicion

	PCMPGTD XMM8, [mayor_223] 							;(t>223) = (t>= 224)
	MOVDQU XMM10, XMM0
	PAND XMM10, XMM8
	PSUBD XMM10, [nro_224] 								;xmm10 = t-224
	PAND XMM10, XMM8
	PMULLD XMM10, [cuatro] 								;xmm10 = 4(t-224)
	MOVDQA XMM11, [nro_255] 							;xmm11 = 255
	PSUBD XMM11, XMM10 									;xmm11 = 255-4(t-224)
	PSLLDQ XMM11, 2 									;xmm11 lo pongo en el color r
	PAND XMM8, XMM11 									;lo ubico en los pixeles que cumplen la condicion

	PADDD XMM1, XMM2
	PADDD XMM1, XMM4
	PADDD XMM1, XMM6
	PADDD XMM1, XMM8

	MOVDQU XMM2, XMM1
	MOVDQU XMM3, XMM1
	MOVDQU XMM4, XMM1

	PAND XMM1, [mascara_juntar1]
	PSRLDQ XMM2, 1
	PAND XMM2, [mascara_juntar2]
	PSRLDQ XMM3, 2
	PAND XMM3, [mascara_juntar3]
	PSRLDQ XMM4, 3
	PAND XMM4, [mascara_juntar4]

	PADDD XMM1, xmm2
	PADDD XMM1, XMM3
	PADDD XMM1, XMM4

	CMP R12d, R14d
	JE .juntar

	MOVDQU [R11], XMM1
	JMP .loop2

.juntar:

	PSLLDQ XMM1, 4
	PADDD XMM1, XMM15
	MOVDQU [R11], XMM1
	JMP .loop2

.fin:
	
	POP R11
	POP R10
	ADD RSP, 8
	POP R15
	POP R14
	POP R13
	POP R12
	POP RBX
	POP RBP
    RET

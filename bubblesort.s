; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>

; -------------------------------------------------------------------------------
; Fun��o main()
Start  
	
;preencher vetor

	LDR		R0,	=0x20000500				;definir endere�o
	MOV		R1,	#0xFF					;pos0
	STR		R1,	[R0], #1
	MOV		R1,	#0xFE						;pos1
	STR		R1,	[R0], #1
	MOV		R1,	#0xFD						;pos2
	STR		R1,	[R0], #1
	MOV		R1,	#0xFC						;pos3
	STR		R1,	[R0], #1
	MOV		R1,	#0xFB						;pos4
	STR		R1,	[R0], #1
	MOV		R1,	#0xFA						;pos5
	STR		R1,	[R0], #1
;fim do preenchimento
;setup
	LDR		R0,	=0x20000500				;definir endere�o inicial
	MOV		R3,	#0						;i=0
	MOV		R4,	#6						;tamanho do vetor
	
;fun��o
loop	
	LDRB	R1, [R0]					;carrega a posi��o i
	LDRB	R2,	[R0,#1]					;carrega a posi��o i++
	ADD		R3, #1					;i++
	CMP		R3,R4						;R3-R4
	IT	EQ
	BLEQ	reset
	CMP		R1,R2						;R1 - R2
	BLHI	swap
	ADD		R0,		 #1					;endere�o+1
	B		loop						;loop infinito



swap
	MOV		R5, R1							;R5 = R1, R5=aux
	MOV		R1,	R2							;R1 = R2
	MOV		R2,	R5							;R2 = R5
	STRB	R1,	[R0],#1
	STRB	R2,	[R0]
	BL		loop
reset
	LDR		R0, =0x20000500;			;definir endere�o
	MOV		R3, #0						;i=0
	MOV		R4,	#5						;tamanho
	B		loop
	
fim
	
	NOP
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
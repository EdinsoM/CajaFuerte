;  Last Modified :
;  Revision      :
;  Author        :
;  Description   :
;*******************************************************************

;-------------------------------------------------
; Include derivative-specific definitions
;-------------------------------------------------
            INCLUDE 'derivative.inc'

;-------------------------------------------------
; export symbols
;-------------------------------------------------
            XDEF        _Startup
            ABSENTRY    _Startup

;-------------------------------------------------
; variable/data section
;-------------------------------------------------
;           ORG   	RAMStart		; Insert your data definition here
            ORG     Z_RAMStart+10	;Pagina Zero Dir = $90

ClaveP:		DC.B    0,0,0,0			;Esta variable se encuentra guardada en la dir = $90
Contador:	DC.B	0				;contador para verificar que la clave está bie
Contador2:	DC.B	0				;contador para salir del desbloquear

H0:  		DC.B 	1				;Determina si el botón 0 fue presionado
H1:			DS.B	1				;Determina si el botón 1 fue presionado 
H2:  		DC.B 	1				;Determina si el botón 2 fue presionado
H3:  		DC.B 	1				;Determina si el botón 3 fue presionado

VT:			DS.B 	1				;Variable temporal para almacenar la información proveniente del ADC

;##############################################################################################
Do4: MACRO
			LDHX #$003B
			STHX TPM1MOD ;Do4=261.6 Hz
			ENDM
DoS4: MACRO
			LDHX #$0038
			STHX TPM1MOD ;Do#4=277.1 Hz
			ENDM
Re4: MACRO
			LDHX #$0035
			STHX TPM1MOD ;Re4=293.6 Hz
			ENDM
ReS4: MACRO
			LDHX #$0032
			STHX TPM1MOD ;Re#4=311.1 Hz
			ENDM
Mi4: MACRO
			LDHX #$002F
			STHX TPM1MOD ;Mi4=329.6 Hz
			ENDM
Fa4: MACRO
			LDHX #$002C
			STHX TPM1MOD ;Fa4=349.2 Hz
			ENDM
FaS4: MACRO
			LDHX #$002A
			STHX TPM1MOD ;Fa#4=370 Hz
			ENDM
Sol4: MACRO
			LDHX #$0027
			STHX TPM1MOD ;Sol4=392 Hz
			ENDM
SolS4: MACRO
			LDHX #$0025
			STHX TPM1MOD ;Sol#4=415.3 Hz
			ENDM
La4: MACRO
			LDHX #$0023
			STHX TPM1MOD ;La4=440 Hz
			ENDM
LaS4: MACRO
			LDHX #$0021
			STHX TPM1MOD ;La4=466.1 Hz
			ENDM
Si4: MACRO
			LDHX #$001F
			STHX TPM1MOD ;Si4=493 Hz
			ENDM
Do5: MACRO
			LDHX #$001D
			STHX TPM1MOD ;Do5=523.2 Hz
			ENDM
DoS5: MACRO
			LDHX #$001C
			STHX TPM1MOD ;Do#5=554.3 Hz
			ENDM
Re5: MACRO
			LDHX #$001A
			STHX TPM1MOD ;Re5=587.3 Hz
			ENDM
ReS5: MACRO
			LDHX #$0019
			STHX TPM1MOD ;Re#5=622.2 Hz
			ENDM
Mi5: MACRO
			LDHX #$0017
			STHX TPM1MOD ;Mi5=659.3 Hz
			ENDM
Fa5: MACRO
			LDHX #$0016
			STHX TPM1MOD ;Fa5=698.5 Hz
			ENDM
FaS5: MACRO
			LDHX #$0015
			STHX TPM1MOD ;Fa#5=740 Hz
			ENDM
Sol5: MACRO
			LDHX #$0013
			STHX TPM1MOD ;Sol5=784 Hz
			ENDM
SolS5: MACRO
			LDHX #$0012
			STHX TPM1MOD ;Sol#5=830.6 Hz
			ENDM
La5: MACRO
			LDHX #$0011
			STHX TPM1MOD ;La5=880 Hz
			ENDM
LaS5: MACRO
			LDHX #$0010
			STHX TPM1MOD ;La#5=932.5 Hz
			ENDM
Si5: MACRO
			LDHX #$000F
			STHX TPM1MOD ;Si5=988 Hz
			ENDM
Do6: MACRO
			LDHX #$000E
			STHX TPM1MOD ;Do6=1046 Hz
			ENDM
DoS6: MACRO
			LDHX #$000E
			STHX TPM1MOD ;Do#6=1108.7 Hz
			ENDM
Re6: MACRO
			LDHX #$000D
			STHX TPM1MOD ;Re6=1174.6 Hz
			ENDM
ReS6: MACRO
			LDHX #$000C
			STHX TPM1MOD ;Re#6=1244.5 Hz
			ENDM
Mi6: MACRO
			LDHX #$000B
			STHX TPM1MOD ;Mi=1318.3 Hz
			ENDM
Fa6: MACRO
			LDHX #$000B
			STHX TPM1MOD ;Fa6=1396.9 Hz
			ENDM
FaS6: MACRO
			LDHX #$000A
			STHX TPM1MOD ;Fa#6= Hz
			ENDM
Sol6: MACRO
			LDHX #$0009
			STHX TPM1MOD ;Sol6= Hz
			ENDM
SolS6: MACRO
			LDHX #$0009
			STHX TPM1MOD ;Sol#6= Hz
			ENDM
La6: MACRO
			LDHX #$0008
			STHX TPM1MOD ;La6= Hz
			ENDM
LaS6: MACRO
			LDHX #$0008
			STHX TPM1MOD ;La#6= Hz
			ENDM
Si6: MACRO
			LDHX #$0007
			STHX TPM1MOD ;Si6= Hz
			ENDM
;##############################################################################################
;Definicion de Variable utilizada:
Permiso: 	DS.B 1 ;permiso para avanzar a la siguiente nota
;Inicializacion de variable:
 			ORG 	ROMStart
			LDA #$00
 			STA Permiso
;-----------------------------------------------------------------------------
;Rutina de interrupcion de TPM2
TPM2Interrupt:
 			LDA TPM2SC
 			AND #%01111111
 			STA TPM2SC ;Limpia la bandera

 			MOV #$00,Permiso ;Activa el permiso

 			BCLR PTBD_PTBD5,PTBD ;Desactiva el buzzer

 			RTI
;-------------------------------------------------
; code section
;-------------------------------------------------
;##############################################################################################
;            ORG   ROMStart
;##############################################################################################
Redonda: MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$F424
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
Blanca: MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$7A12
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
Negra: 		MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$3D09
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
Corchea: 	MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$1E84
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
Semi_Corchea: MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$0F42
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
Fusa: MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$07A1
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
Semi_Fusa: 	MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$03D0
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
SS_Fusa: 	MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$01E8
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
SSS_Fusa: 	MACRO
			MOV #$FF, Permiso ;PERMISO DENEGADO
			LDHX #$000F
			STHX TPM2MOD ;
\@Loop:
			BRSET 1,Permiso,\@Loop ;Pregunta si se tiene permiso de avanzar
			ENDM
;---------------------------------------------------------------------------
; Silencio (apaga el Buzzer)
Silencio: MACRO
			LDHX #$3D09 ; 1 Hz
			STHX TPM1MOD
			ENDM
;----------------------------------------------------------------------------
; Activar o Desactivar TPM1
TMP1_ON: MACRO
			LDA #%01001111
			STA TPM1SC ;Activa el TPM1
			ENDM
TMP1_OFF: MACRO
			LDA #$00
			STA TPM1SC
			ENDM
;----------------------------------------------------------------------------
TETRIS:
 			Silencio
 			Negra
			La5
 			Corchea
 			FaS5
 			Semi_Corchea
 			Sol5
 			Semi_Corchea
 			SolS5
 			Corchea
 			Sol5
 			Semi_Corchea
 			FaS5 
			Semi_Corchea
			Mi5
 			Corchea
 			Mi5
 			Semi_Corchea
 			Sol5
 			Semi_Corchea
 			La5
 			Corchea; 
			SolS5
 			Semi_Corchea
 			Sol5 
 			Semi_Corchea 
 			FaS5 
 			Corchea 
 			FaS5 
 			Semi_Corchea 
 			Sol5 
 			Semi_Corchea 
 			SolS5 
 			Corchea 
 			La5 
 			Corchea 
 			Sol5 
 			Corchea 
 			Mi5 
 			Corchea 
	 		Mi5 
	 		Negra 
	 		Silencio 
	 		Blanca 
	 		JMP Libre

;##############################################################################################
_Startup:

		bset PTCDD_PTCDD0, PTCDD   ;Salidas (LED's) 
		bset PTCD_PTCD0, PTCD
		bset PTCDD_PTCDD1, PTCDD 
		bset PTCD_PTCD1, PTCD
		bset PTCDD_PTCDD2, PTCDD
		bset PTCD_PTCD2, PTCD
		bset PTCDD_PTCDD3, PTCDD
		bset PTCD_PTCD3, PTCD
		bset PTCDD_PTCDD4, PTCDD
		bset PTCD_PTCD4, PTCD
		bset PTCDD_PTCDD5, PTCDD
		bset PTCD_PTCD5, PTCD
		bset PTEDD_PTEDD6, PTEDD
		bset PTED_PTED6, PTED
		bset PTEDD_PTEDD7, PTEDD
		bset PTED_PTED7, PTED
		
		bset PTBDD_PTBDD5, PTBDD	;Salida (Buzzer)
		
		bclr PTADD_PTADD2, PTADD	;Entradas	
		bclr PTADD_PTADD3, PTADD
		bclr PTDDD_PTDDD2, PTDDD
		bclr PTDDD_PTDDD3, PTDDD

		lda #%00001100
		sta PTAPE

		lda #%00001100
		sta PTDPE

adc: 
		lda #$20
		sta ADCSC1

Desbloquear: BRCLR 7, ADCSC1, Desbloquear

		lda ADCRL
		ldhx #$1B
		div
		coma
		sta PTCD
		sta PTED
		coma

		sta VT

		bclr PTED_PTED7, PTED				;El led 7 indica que el sistema está bloqueado

		BRCLR PTAD_PTAD2, PTAD, guardar1
		BRCLR PTAD_PTAD3, PTAD, guardar2
		BRCLR PTDD_PTDD2, PTDD, guardar3
		BRCLR PTDD_PTDD3, PTDD, guardar4

; 		codigo para salir de aqui, salto a seguro

		lda #$4								;Se carga el número 4 al acumulador
		cbeq Contador2,	Siguiente			;Si Contador2 llega a 4, quiere decir que fueron presionados los 4 botones, por lo tanto, se hace un branch a la subrutina Siguiente,
											;de tal manera que se procede a comprobar si la clave introducida es la correcta

;		Si no se hace el branch, se regresa a la subrutina Desbloquear, a la espera de presionar otro botón

		feed_watchdog
		bra Desbloquear

guardar1:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H0, Desbloquear		;Se verifica el estado del botón 0, al inicio está habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H0					;Se inabilita el botón 1
		mov VT, $80					;El valor del ADC,almacenado en VT, se almacena en el registro $80
		lda $80						;Se carga el valor de $80 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2
		cbeq ClaveP, Acumulador		;Se compara el valor con ClaveP (que está en la dirección $90) si coinciden, se hace un branch a la subrutina Acumulador
		bra Desbloquear				;Si no coinciden los números, se regresa a la subrutina Desbloquear

guardar2:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H1, Desbloquear		;Se verifica el estado del botón 1, al inicio está habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H1					;Se inabilita el botón 2
		mov VT, $81					;El valor del ADC, almacenado en VT, se almacena en el registro $81
		lda $81						;Se carga el valor de $81 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2
		cbeq ClaveP + 1, Acumulador	;Se compara el valor con ClaveP (que está en la dirección $91) si coinciden, se hace un branch a la subrutina Acumulador
		bra Desbloquear				;Si no coinciden los números, se regresa a la subrutina Desbloquear

guardar3:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H2, Desbloquear		;Se verifica el estado del botón 1, al inicio está habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H2					;Se inabilita el botón 3
		mov VT, $82					;El valor del ADC,almacenado en VT, se almacena en el registro $82
		lda $82						;Se carga el valor de $82 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2		
		cbeq ClaveP + 2, Acumulador	;Se compara el valor con ClaveP (que está en la dirección $92) si coinciden, se hace un branch a la subrutina Acumulador
		bra Desbloquear				;Si no coinciden los números, se regresa a la subrutina Desbloquear

guardar4:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H3, Desbloquear		;Se verifica el estado del botón 1, al inicio está habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H3					;Se inabilita el botón 4
		mov VT, $83					;El valor del ADC,almacenado en VT, se almacena en el registro $83
		lda $83						;Se carga el valor de $83 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2		
		cbeq ClaveP + 3, Acumulador	;Se compara el valor con ClaveP (que está en la dirección $93) si coinciden, se hace un branch a la subrutina Acumulador
		bra Desbloquear				;Si no coinciden los números, se regresa a la subrutina Desbloquear

Acumulador: 

		inc Contador
		bra Desbloquear

Siguiente:
		mov #$1, H0					;Se habilitan todos los botones
		mov #$1, H1
		mov #$1, H2
		mov #$1, H3
		
		mov #$0, Contador			;Se reestablecen los contadores
		mov #$0, Contador2

Probar:	

		bset PTCD_PTCD0, PTCD		;Se apagan todos los leds de la tarjeta
		bset PTCD_PTCD1, PTCD
		bset PTCD_PTCD2, PTCD
		bset PTCD_PTCD3, PTCD
		bset PTCD_PTCD4, PTCD
		bset PTCD_PTCD5, PTCD 
		bset PTED_PTED6, PTED
		bset PTED_PTED7, PTED

		lda #$4	
		cbeq Contador, Musiquita		;Si coincide el valor de Contador con el número 4, quiere decir que los 4 valores introducidos fueron acertados
									;por lo tanto, se desbloqueó el sistema y se hace branch a la función Libre
		
		JMP Desbloquear				;Si no se pudo desbloquear el sistema, se regresa a la subrutina Desbloquear

Musiquita:
		JMP TETRIS

Libre: 

		
		bclr PTCD_PTCD0, PTCD				;Se encienden todos los leds de la tarjeta
		bclr PTCD_PTCD1, PTCD
		bclr PTCD_PTCD2, PTCD
		bclr PTCD_PTCD3, PTCD
		bclr PTCD_PTCD4, PTCD
		bclr PTCD_PTCD5, PTCD 
		bclr PTED_PTED6, PTED
		bclr PTED_PTED7, PTED
		
		BRCLR PTAD_PTAD2, PTAD, adc2		;Se selecciona una nueva clave si se presiona el botón AD2, pero primero se activa el ADC, nuevamente
		
		BRSET PTAD_PTAD3, PTAD, NDesbloquear
		JMP Desbloquear						;Se repite todo el proceso de nuevo haciendo JMP a desbloquear, sin cambiar de clave

NDesbloquear:
		bra Libre							;No se puede hacer branch para una subrutina con una lejanía mayor a 255 espacios en memoria, por tal
											;motivo se utiliza JMP Desbloquear
											
adc2: 
		lda #$20
		sta ADCSC1
		
NuevaClave: BRCLR 7, ADCSC1, NuevaClave
		
		lda ADCRL
		ldhx #$1B
		div
		coma
		sta PTCD
		sta PTED
		coma

		sta VT

		bclr PTED_PTED6, PTED			;El led 6 indica que estamos en la opción de establecer una nueva clave

		BRCLR PTAD_PTAD2, PTAD, Nueva1
		BRCLR PTAD_PTAD3, PTAD, Nueva2
		BRCLR PTDD_PTDD2, PTDD, Nueva3
		BRCLR PTDD_PTDD3, PTDD, Nueva4
		
; 		codigo para salir de aqui, salto a Comprobar

		lda #$4							;Se carga el número 4 al acumulador
		cbeq Contador2,	Comprobar		;Si Contador2 llega a 4, quiere decir que fueron presionados los 4 botones, por lo tanto, se hace un branch a la subrutina Comprobar,
										;de tal manera que se procede a comprobar si la clave introducida es la deseada

;		Si no se hace el branch, se regresa a la subrutina NuevaClave, a la espera de presionar otro botón

		feed_watchdog
		bra NuevaClave

Nueva1:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H0, NuevaClave			;Se verifica el estado del botón 0, al inicio está habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H0					;Se inabilita el botón 1
		mov VT, ClaveP				;El valor del ADC,almacenado en VT, se almacena en el registro $90
;		lda ClaveP					;Se carga el valor de $90 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2
;		cbeq ClaveP, Acumulador		;Se compara el valor con ClaveP (que está en la dirección $90) si coinciden, se hace un branch a la subrutina Acumulador
		bra NuevaClave				;Si no coinciden los números, se regresa a la subrutina NuevaClave

Nueva2:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H1, NuevaClave			;Se verifica el estado del botón 1, al inicio está habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H1					;Se inabilita el botón 2
		mov VT, ClaveP+1			;El valor del ADC, almacenado en VT, se almacena en el registro $91
;		lda ClaveP + 1				;Se carga el valor de $91 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2
;		cbeq ClaveP + 1, Acumulador	;Se compara el valor con ClaveP (que está en la dirección $91) si coinciden, se hace un branch a la subrutina Acumulador
		bra NuevaClave				;Si no coinciden los números, se regresa a la subrutina NuevaClave

Nueva3:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H2, NuevaClave			;Se verifica el estado del botón 1, al inicio está habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H2					;Se inabilita el botón 3
		mov VT, ClaveP+2			;El valor del ADC,almacenado en VT, se almacena en el registro $92
;		lda ClaveP + 2				;Se carga el valor de $92 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2		
;		cbeq ClaveP + 2, Acumulador	;Se compara el valor con ClaveP (que está en la dirección $92) si coinciden, se hace un branch a la subrutina Acumulador
		bra NuevaClave				;Si no coinciden los números, se regresa a la subrutina NuevaClave

Nueva4:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H3, NuevaClave			;Se verifica el estado del botón 1, al inicio está habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H3					;Se inabilita el botón 4
		mov VT, ClaveP+3			;El valor del ADC,almacenado en VT, se almacena en el registro $93
;		lda ClaveP + 3				;Se carga el valor de $93 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2		
;		cbeq ClaveP + 3, Acumulador	;Se compara el valor con ClaveP (que está en la dirección $93) si coinciden, se hace un branch a la subrutina Acumulador
		bra NuevaClave				;Si no coinciden los números, se regresa a la subrutina NuevaClave

Comprobar:

		bset PTCD_PTCD0, PTCD		;Se apagan todos los leds de la tarjeta, menos el 5
		bset PTCD_PTCD1, PTCD
		bset PTCD_PTCD2, PTCD
		bset PTCD_PTCD3, PTCD
		bset PTCD_PTCD4, PTCD
		bclr PTCD_PTCD5, PTCD 
		bset PTED_PTED6, PTED
		bset PTED_PTED7, PTED
		
		BRCLR PTAD_PTAD3, PTAD, DeNuevo		;Se reestablece a la clave de fábrica y se coloca nuevamente la clave
		
		BRSET PTAD_PTAD2, PTAD, Aceptar
		JMP Desbloquear						;Clave nueva establecida, se procede a hacer todo el proceso de desbloqueo, otra vez

Aceptar:
		bra Comprobar						;No se puede hacer branch para una subrutina con una lejanía mayor a 255 espacios en memoria, por tal
											;motivo se utiliza JMP Desbloquear		
		
DeNuevo:
		mov #$0,ClaveP						;Se reestablece a la clave de fábrica
		mov #$0,ClaveP+1
		mov #$0,ClaveP+2
		mov #$0,ClaveP+3
		
		mov #$0,Contador2					;Se reestablece el contador2
		
		mov #$1, H0							;Se habilitan todos los botones
		mov #$1, H1
		mov #$1, H2
		mov #$1, H3

		JMP NuevaClave						;Se reinicia el proceso para colocar una nueva clave
		
;**************************************************************
; spurious - Spurious Interrupt Service Routine.
;             (unwanted interrupt)
;**************************************************************

spurious:                           ; placed here so that security value
            NOP                     ; does not change all the time.
            RTI

;**************************************************************
; Interrupt Vectors
;**************************************************************
            ORG $FFC0
            DC.W  spurious          ; TPM3 overflow
            DC.W  spurious          ; TPM3 CH5
            DC.W  spurious          ; TPM3 CH4
            DC.W  spurious          ; TPM3 CH3
            DC.W  spurious          ; TPM3 CH2
            DC.W  spurious          ; TPM3 CH1
            DC.W  spurious          ; TPM3 CH0
            DC.W  spurious          ; RTI
            DC.W  spurious          ; SCI2 Tx
            DC.W  spurious          ; SCI2 Rx
            DC.W  spurious          ; SCI2 Error
            DC.W  spurious          ; Analog comparator X
            DC.W  spurious          ; ADC
            DC.W  spurious          ; Keyboard
            DC.W  spurious          ; IICx Control
            DC.W  spurious          ; SCI1 Tx
            DC.W  spurious          ; SCI1 Rx
            DC.W  spurious          ; SCI1 Error
            DC.W  spurious          ; SPI1
            DC.W  spurious          ; SPI2
            DC.W  spurious          ; TPM2 overflow
            DC.W  spurious          ; TPM2 CH2
            DC.W  spurious          ; TPM2 CH1
            DC.W  spurious          ; TPM2 CH0
            DC.W  spurious          ; TPM1 overflow
            DC.W  spurious          ; TPM1 CH2
            DC.W  spurious          ; TPM1 CH1
            DC.W  spurious          ; TPM1 CH0
            DC.W  spurious          ; Low Voltage
            DC.W  spurious          ; IRQ
            DC.W  spurious          ; SWI
            DC.W  _Startup          ; Rese

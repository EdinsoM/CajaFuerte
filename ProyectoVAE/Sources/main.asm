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
;ExampleVar: DS.B  1
            ORG     Z_RAMStart+10	;Pagina Zero Dir = $90

ClaveP:		DC.B    0,0,0,0			;Esta variable se encuentra guardada en la dir = $90
Contador:	DC.B	0				;contador para verificar que la clave est� bie
Contador2:	DC.B	0				;contador para salir del desbloquear

H0:  		DC.B 	1				;Determina si el bot�n 0 fue presionado
H1:			DS.B	1				;Determina si el bot�n 1 fue presionado 
H2:  		DC.B 	1				;Determina si el bot�n 2 fue presionado
H3:  		DC.B 	1				;Determina si el bot�n 3 fue presionado
VT:			DS.B 	1				;Variable temporal para almacenar la informaci�n proveniente del ADC

;VARIABLEtemp:  DS.B    1			;Esta variable se encuentra guardada en la dir = $82
;CUENTA:        DS.B    1			;Esta variable se encuentra guardada en la dir = $83
;HXtemp:		DS.B	2			;Esta variable se encuentra guardada en las dir = $84 - $85

;-------------------------------------------------
; code section
;-------------------------------------------------
            ORG   ROMStart
_Startup:

		bset PTCDD_PTCDD0, PTCDD   ;Salidas 
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

		bclr PTED_PTED7, PTED

		BRCLR PTAD_PTAD2, PTAD, guardar1
		BRCLR PTAD_PTAD3, PTAD, guardar2
		BRCLR PTDD_PTDD2, PTDD, guardar3
		BRCLR PTDD_PTDD3, PTDD, guardar4

; 		codigo para salir de aqui, salto a seguro

		lda #$4						;Se carga el n�mero 4 al acumulador
		cbeq Contador2,	Siguiente	;Si Contador2 llega a 4, quiere decir que fueron presionados los 4 botones, por lo tanto, se hace un branch a la subrutina Siguiente,
									;de tal manera que se procede a comprobar si la clave introducida es la correcta

;		Si no se hace el branch, se regresa a la subrutina Desbloquear, a la espera de presionar otro bot�n

		feed_watchdog
		bra Desbloquear

guardar1:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H0, Desbloquear		;Se verifica el estado del bot�n 0, al inicio est� habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H0					;Se inabilita el bot�n si est� habilitado
		mov VT, $80					;El valor del ADC,almacenado en VT, se almacena en el registro $80
		lda $80						;Se carga el valor de $80 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2
		cbeq ClaveP, Acumulador		;Se compara el valor con ClaveP (que est� en la direcci�n $90) si coinciden, se hace un branch a la subrutina Acumulador
		bra Desbloquear				;Si no coinciden los n�meros, se regresa a la subrutina Desbloquear

guardar2:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H1, Desbloquear		;Se verifica el estado del bot�n 1, al inicio est� habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H1					;Se inabilita el bot�n si est� habilitado
		mov VT, $81					;El valor del ADC, almacenado en VT, se almacena en el registro $81
		lda $81						;Se carga el valor de $81 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2
		cbeq ClaveP + 1, Acumulador	;Se compara el valor con ClaveP (que est� en la direcci�n $91) si coinciden, se hace un branch a la subrutina Acumulador
		bra Desbloquear				;Si no coinciden los n�meros, se regresa a la subrutina Desbloquear

guardar3:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H2, Desbloquear		;Se verifica el estado del bot�n 1, al inicio est� habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H2					;Se inabilita el bot�n si est� habilitado
		mov VT, $82					;El valor del ADC,almacenado en VT, se almacena en el registro $82
		lda $82						;Se carga el valor de $82 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2		
		cbeq ClaveP + 2, Acumulador	;Se compara el valor con ClaveP (que est� en la direcci�n $92) si coinciden, se hace un branch a la subrutina Acumulador
		bra Desbloquear				;Si no coinciden los n�meros, se regresa a la subrutina Desbloquear

guardar4:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H3, Desbloquear		;Se verifica el estado del bot�n 1, al inicio est� habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H3					;Se inabilita el bot�n si est� habilitado
		mov VT, $83					;El valor del ADC,almacenado en VT, se almacena en el registro $83
		lda $83						;Se carga el valor de $83 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2		
		cbeq ClaveP + 3, Acumulador	;Se compara el valor con ClaveP (que est� en la direcci�n $93) si coinciden, se hace un branch a la subrutina Acumulador
		bra Desbloquear				;Si no coinciden los n�meros, se regresa a la subrutina Desbloquear

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

		bset PTCD_PTCD0, PTCD		;Se apagan todos los leds del microcontrolador
		bset PTCD_PTCD1, PTCD
		bset PTCD_PTCD2, PTCD
		bset PTCD_PTCD3, PTCD
		bset PTCD_PTCD4, PTCD
		bset PTCD_PTCD5, PTCD 
		bset PTED_PTED6, PTED
		bset PTED_PTED7, PTED

		lda #$4	
		cbeq Contador, Libre		;Si coincide el valor de Contador con el n�mero 4, quiere decir que los 4 valores introducidos fueron acertados
									;por lo tanto, se desbloque� el sistema y se hace branch a la funci�n Libre
		
		JMP Desbloquear				;Si no se pudo desbloquear el sistema, se regresa a la subrutina Desbloquear

Libre: 

		bclr PTCD_PTCD0, PTCD				;Se encienden todos los leds del microcontrolador
		bclr PTCD_PTCD1, PTCD
		bclr PTCD_PTCD2, PTCD
		bclr PTCD_PTCD3, PTCD
		bclr PTCD_PTCD4, PTCD
		bclr PTCD_PTCD5, PTCD 
		bclr PTED_PTED6, PTED
		bclr PTED_PTED7, PTED
		
		BRCLR PTAD_PTAD2, PTAD, adc2		;Se selecciona una nueva clave si se presiona el bot�n AD2, pero primero se activa el ADC, nuevamente
		
		BRSET PTAD_PTAD3, PTAD, NDesbloquear
		JMP Desbloquear						;Se repite todo el proceso de nuevo haciendo JMP a desbloquear, sin cambiar de clave

NDesbloquear:
		bra Libre							;No se puede hacer branch para una subrutina con una lejan�a mayor a 255 espacios en memoria, por tal
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

		bclr PTED_PTED6, PTED

		BRCLR PTAD_PTAD2, PTAD, Nueva1
		BRCLR PTAD_PTAD3, PTAD, Nueva2
		BRCLR PTDD_PTDD2, PTDD, Nueva3
		BRCLR PTDD_PTDD3, PTDD, Nueva4
		
; 		codigo para salir de aqui, salto a seguro

		lda #$4						;Se carga el n�mero 4 al acumulador
		cbeq Contador2,	Comprobar	;Si Contador2 llega a 4, quiere decir que fueron presionados los 4 botones, por lo tanto, se hace un branch a la subrutina Comprobar,
									;de tal manera que se procede a comprobar si la clave introducida es la deseada

;		Si no se hace el branch, se regresa a la subrutina NuevaClave, a la espera de presionar otro bot�n

		feed_watchdog
		bra NuevaClave

Nueva1:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H0, NuevaClave			;Se verifica el estado del bot�n 0, al inicio est� habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H0					;Se inabilita el bot�n si est� habilitado
		mov VT, ClaveP				;El valor del ADC,almacenado en VT, se almacena en el registro $90
;		lda ClaveP					;Se carga el valor de $90 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2
;		cbeq ClaveP, Acumulador		;Se compara el valor con ClaveP (que est� en la direcci�n $90) si coinciden, se hace un branch a la subrutina Acumulador
		bra NuevaClave				;Si no coinciden los n�meros, se regresa a la subrutina Desbloquear

Nueva2:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H1, NuevaClave			;Se verifica el estado del bot�n 1, al inicio est� habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H1					;Se inabilita el bot�n si est� habilitado
		mov VT, ClaveP+1			;El valor del ADC, almacenado en VT, se almacena en el registro $91
;		lda ClaveP + 1				;Se carga el valor de $91 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2
;		cbeq ClaveP + 1, Acumulador	;Se compara el valor con ClaveP (que est� en la direcci�n $91) si coinciden, se hace un branch a la subrutina Acumulador
		bra NuevaClave				;Si no coinciden los n�meros, se regresa a la subrutina Desbloquear

Nueva3:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H2, NuevaClave			;Se verifica el estado del bot�n 1, al inicio est� habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H2					;Se inabilita el bot�n si est� habilitado
		mov VT, ClaveP+2			;El valor del ADC,almacenado en VT, se almacena en el registro $92
;		lda ClaveP + 2				;Se carga el valor de $92 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2		
;		cbeq ClaveP + 2, Acumulador	;Se compara el valor con ClaveP (que est� en la direcci�n $92) si coinciden, se hace un branch a la subrutina Acumulador
		bra NuevaClave				;Si no coinciden los n�meros, se regresa a la subrutina Desbloquear

Nueva4:

		lda #$0						;Se carga 0 en el acumulador
		cbeq H3, NuevaClave			;Se verifica el estado del bot�n 1, al inicio est� habilitado (1), cuando se presiona se inhabilita (0)
		mov #$0, H3					;Se inabilita el bot�n si est� habilitado
		mov VT, ClaveP+3			;El valor del ADC,almacenado en VT, se almacena en el registro $93
;		lda ClaveP + 3				;Se carga el valor de $93 en el acumulador
		inc Contador2				;Se aumenta en 1 el valor de Acumulador2		
;		cbeq ClaveP + 3, Acumulador	;Se compara el valor con ClaveP (que est� en la direcci�n $93) si coinciden, se hace un branch a la subrutina Acumulador
		bra NuevaClave				;Si no coinciden los n�meros, se regresa a la subrutina Desbloquear

Comprobar:

		bset PTCD_PTCD0, PTCD		;Se apagan todos los leds del microcontrolador, menos el 5
		bset PTCD_PTCD1, PTCD
		bset PTCD_PTCD2, PTCD
		bset PTCD_PTCD3, PTCD
		bset PTCD_PTCD4, PTCD
		bclr PTCD_PTCD5, PTCD 
		bset PTED_PTED6, PTED
		bset PTED_PTED7, PTED
		
		BRCLR PTAD_PTAD3, PTAD, DeNuevo		;Se reestablece a la clave de f�brica y se coloca nuevamente la clave
		
		BRSET PTAD_PTAD2, PTAD, ClaveNueva
		JMP Desbloquear						;Clave nueva establecida, se procede a hacer todo el proceso de desbloqueo, otra vez

ClaveNueva:
		bra Comprobar						;No se puede hacer branch para una subrutina con una lejan�a mayor a 255 espacios en memoria, por tal
											;motivo se utiliza JMP Desbloquear		
		
DeNuevo:
		mov #$0,ClaveP						;Se reestablece a la clave de f�brica
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

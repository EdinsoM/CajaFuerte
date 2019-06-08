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
;            ORG   RAMStart          ; Insert your data definition here
;ExampleVar: DS.B  1
                ORG     Z_RAMStart+10	;Pagina Zero Dir = $90

ClaveP:		DC.B    0,0,0,0	;Esta variable se encuentra guardada en la dir = $90
Contador:	DC.B	0		;contador para verificar que la clave est� bie
Contador2:	DC.B	0		;contador para salir del desbloquear

H0:  		DC.B 	1		;Determina si el bot�n 0 fue presionado
H1:			DS.B	1		;Determina si el bot�n 1 fue presionado 
H2:  		DC.B 	1		;Determina si el bot�n 2 fue presionado
H3:  		DC.B 	1		;Determina si el bot�n 3 fue presionado
VT:			DS.B 	1		;Variable temporal para almacenar la informaci�n proveniente del ADC

;VARIABLEtemp:  DS.B    1	;Esta variable se encuentra guardada en la dir = $82
;CUENTA:        DS.B    1	;Esta variable se encuentra guardada en la dir = $83
;HXtemp:	DS.B	2	; Esta variable se encuentra guardada en las dir = $84 - $85

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

; codigo para salir de aqui, salto a seguro

		lda #$4					;Se carga el n�mero 4 al acumulador
		cbeq Contador2,	Seguro	;Si Contador2 llega a 4, quiere decir que fueron presionados los 4 botones, por lo tanto, se hace un branch a la subrutina Seguro,
								;de tal manera que se procede a comprobar si la clave introducida es la correcta

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
		mov VT, $81					;El valor del ADC,almacenado en VT, se almacena en el registro $81
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

Seguro:	

		bset PTCD_PTCD0, PTCD
		bset PTCD_PTCD1, PTCD
		bset PTCD_PTCD2, PTCD
		bset PTCD_PTCD3, PTCD

		bclr PTCD_PTCD6, PTCD
		bset PTED_PTED7, PTED

		BRCLR PTAD_PTAD2, PTAD, Probar
		BRSET PTAD_PTAD3, PTAD, NDesbloquear
		JMP Desbloquear

NDesbloquear:

		feed_watchdog
		bra Seguro

Probar:



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

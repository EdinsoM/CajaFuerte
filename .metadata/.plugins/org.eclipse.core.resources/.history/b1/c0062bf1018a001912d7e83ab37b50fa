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
                ORG     Z_RAMStart+10	; Pagina Zero Dir = $90

ClaveP:		DC.B    0,0,0,0	; Esta variable se encuentra guardada en la dir = $90
Contador:	DC.B	0
; contador para salir del desbloquear
H0:  		DC.B 	1
H1:			DS.B	1 
H2:  		DC.B 	1
H3:  		DC.B 	1
VT:			DS.B 	1
;VARIABLEtemp:  DS.B    1	; Esta variable se encuentra guardada en la dir = $82
;CUENTA:        DS.B    1	; Esta variable se encuentra guardada en la dir = $83
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

		bclr PTADD_PTADD2, PTADD	;Entrada	
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

		feed_watchdog
		bra Desbloquear

guardar1:

		lda #$0
		cbeq H0, Desbloquear
		mov #$0, H0
		mov VT, $80
		lda $80
		cbeq ClaveP, Acumulador
		bra Desbloquear

guardar2:

		lda #$0
		cbeq H1, Desbloquear
		mov #$0, H1
		mov VT, $81
		lda $81
		cbeq ClaveP + 1, Acumulador
		bra Desbloquear

guardar3:

		lda #$0
		cbeq H2, Desbloquear
		mov #$0, H2
		mov VT, $82
		lda $82
		cbeq ClaveP + 2, Acumulador
		bra Desbloquear

guardar4:

		lda #$0
		cbeq H3, Desbloquear
		mov #$0, H3
		mov VT, $83
		lda $83
		cbeq ClaveP + 3, Acumulador
		bra Desbloquear

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

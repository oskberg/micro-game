#include <xc.inc>
    
; ====== COMMENTS ====== 
;   This file contains subroutines for the Keyboard input

;   PIN CONFUGURATION ON Keyboard:
;    rows		PortE 0:3
;    columns		PortE 4:7
;    

; ====== IMPORTS/EXPORTS ======
extrn	delay_x4us
;extrn	readRow, readCol
    
global	button_press, keyboard_setup
    
; ====== VARIABLE DECLARATIONS ======
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
rowVal:	    ds 1    ; reserve one byte for the row value
colVal:	    ds 1    ; reserve one byte for the column value
padVal:	    ds 1    ; reserve one byte for the pad output value
keyCounter:  ds 1    ; reserve one byte for array looping
asciiVal:   ds 1    ; 1 byte for ascii value
    

psect	data    
padVals:
	db	'F','E','D','C','3','6','9','B','2','5','8','0','1','4','7','A'
;	db	'1','2','3','F','4','5','6','E','7','8','9','D','A','0','B','C',0x0a
					; values, plus carriage return
	padValsLen	EQU	17	; length of data
	align	2
	
padKeys:
	db	11100111B,11010111B,10110111B,01110111B,11101011B,11011011B,10111011B,01111011B,11101101B,11011101B,10111101B,01111101B,11101110B,11011110B,10111110B,01111110B,0x0a
					; keys, plus carriage return
	padKeysLen	EQU	17	; length of data
	align	2
    
psect	keyboard_code,class=CODE

keyboard_setup:
	;setup keypad
	banksel PADCFG1
	bsf	REPU	    ; set pull-ups
	movlb	0
	clrf	LATE, A	    ; write 0s to lat register
	return
	
button_press:
	call	readRow		    ; move row reading into w
	movwf	rowVal, A	    ; move row reading int rowVal
	
	call	readCol		    ; move col reading into w
	movwf	colVal, A	    ; move col reading int rowVal
	
	iorwf	rowVal, W, A	    ; combine to single reading
	movwf	padVal, A	    ; move reading into padVal
	
	call	keyToAscii	    ; check key press
	movwf	asciiVal, A	    ; return ascii value of key press or 'R' if 
				    ; no key pressed
	return
	
	
readRow:	; read row output
	movlw	0x0f	    ; set 0-3 as input and 4-7 as output on PORT E
	movwf	TRISE, A
	movlw	0x10	    ; 40 us delay to let pin volatges settle (in hex...)
	call	delay_x4us ; delay
	
	movf	PORTE, W, A ; move result into w
	return
	
readCol:
	movlw	0xf0	    ; set 0-3 as OUTPUT and 4-7 as INPUT on PORT E
	movwf	TRISE, A    
	movlw	0x10	    ; 40 us delay to let pin volatges settle
	call	delay_x4us ; delay
	
	movf	PORTE, W, A ; move result into w
	return
	
keyToAscii:	; returns corresponding ascii code in w register
    ; load value from key
    ; compare to current value
    ; if equal, return ascii at same index
	movlw	-1
	movwf	keyCounter, A	; set current index to 0
	
	movlw	low highword(padKeys)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(padKeys)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(padKeys)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	
keyLoop: 	
	incf	keyCounter, A	; increment counter (starts at -1)
	movlw	padKeysLen
	cpfslt	keyCounter, A
	bra	exitLoop
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf	TABLAT, W, A
	movf	padVal, W, A		; put pad value in w
	cpfseq	TABLAT, A	; exit iteration if tablat == w
	bra	keyLoop
		
	movlw	low highword(padVals)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	low(padVals)		; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL

	movlw	high(padVals)		; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movf	keyCounter, W, A
	addwf	TBLPTR, A
	tblrd
	movf	TABLAT, W, A

	return
exitLoop:
	retlw	'R'	


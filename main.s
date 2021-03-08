#include <xc.inc>

; ====== COMMENTS ======
;    This is where general comments go
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
extrn	GLCD_setup, GLCD_fill_0, GLCD_fill_1
extrn	delay_ms, delay_x4us, delay, long_delay
    
; ====== SETUP ======  
;    Code which prepares the micro processor to run the game
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable

psect	code, abs	
rst: 	org 0x0
 	goto	setup    

setup:	
;   DONT THINK THESE ARE NEEDED:
;	bcf	CFGS	; point to Flash program memory  
;	bsf	EEPGD 	; access Flash program memory
	call	GLCD_setup
	goto	main
; ====== END OF SETUP ======
	
; ====== MAIN PART ======
; Runs the game in a loop?
main:
	call    GLCD_fill_0
	call	long_delay
	call    GLCD_fill_1	
	call	long_delay	
	bra	main
	
; ====== END OF MAIN PART ======
	end	rst

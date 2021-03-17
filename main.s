#include <xc.inc>

; ====== COMMENTS ======
;    This is where general comments go 
;    Test I can save correctly
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
extrn	GLCD_setup, GLCD_fill_0
extrn	long_delay
extrn	init_player, check_collision_break, reset_score, play_levels
extrn	first_object
extrn	keyboard_setup
extrn	menu_plus_options, draw_end_screen, draw_victory_screen

    
; TODO: i dont like that the end game thing has to be exported...
global	time, collision, end_game
; ====== SETUP ======  
;    Code which prepares the micro processor to run the game
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
key:	    ds 1
time:	    ds 1
collision:  ds 1



psect	code, abs	
rst: 	org 0x0
 	goto	setup    

setup:	
;   DONT THINK THESE ARE NEEDED:
;	bcf	CFGS	; point to Flash program memory  
;	bsf	EEPGD 	; access Flash program memory
	movlw	0x00
	movwf	time, A

;	call	load_level
	call	reset_score
	call	GLCD_setup
	call	init_player
	call	keyboard_setup
	call	menu_plus_options   ; displays options then waits for input
	goto	main
; ====== END OF SETUP ======
	
; ====== MAIN PART ======
; Runs the game in a loop?
main:
	call	play_levels
	bra	won_game
	
end_game:
	movlw	0x1
	call	long_delay
	call	GLCD_fill_0
	call	draw_end_screen
	movlw	0x1
	call	long_delay
	call	reset_stack
	goto	setup
	
reset_stack: 
	movlw	0x01
	cpfseq	STKPTR, A
	bra	pop_value
	bra	setup
pop_value:
	pop
	bra	reset_stack
	
won_game:
	movlw	0x1
	call	long_delay
	call	GLCD_fill_0
	call	draw_victory_screen
	movlw	0x1
	call	long_delay
	goto	setup
    
; ====== END OF MAIN PART ======

	
	end	rst

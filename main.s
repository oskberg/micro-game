#include <xc.inc>

; ====== COMMENTS ======
;    This is where general comments go 
;    Test I can save correctly
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
extrn	GLCD_setup, GLCD_fill_0, GLCD_fill_1
extrn	delay_ms, delay_x4us, delay, long_delay, delay_key_press, delay_menu
extrn	init_player, draw_player, inc_player_y
extrn	keyboard_setup
extrn	draw_menu, menu_plus_options, draw_end_screen, draw_victory_screen
extrn	load_level, draw_level, check_collision
extrn	check_collision_break
extrn	reset_score, load_level_1, load_level_2, load_level_3
extrn	first_object, level_1_len, level_2_len, level_3_len, play_frame, play_levels
extrn	draw_level_1_screen, draw_level_2_screen, draw_level_3_screen
    
; TODO: i dont like that the end game thing has to be exported...
global	time, collision, end_game
; ====== SETUP ======  
;    Code which prepares the micro processor to run the game
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
key:	    ds 1
time:	    ds 1
collision:  ds 1
	play_key	equ	'A'
	options_key	equ	'B'
	leader_key	equ	'C'


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
	goto	setup
	
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

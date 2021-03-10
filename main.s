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
extrn	draw_menu
    
; ====== SETUP ======  
;    Code which prepares the micro processor to run the game
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
key:	    ds 1
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
    
	call	GLCD_setup
	call	init_player
	call	keyboard_setup
	goto	main
; ====== END OF SETUP ======
	
; ====== MAIN PART ======
; Runs the game in a loop?
main:
	call	menu_plus_options   ; displays options then waits for input
	
;	call	GLCD_fill_0
;	call	draw_player
;	movlw	10
;	call	delay_key_press
	
	bra main
	
; ====== END OF MAIN PART ======
menu_plus_options:
	call	draw_menu	; displays menu
	call	delay_menu	; waits for valid player input
	movwf	key, A		; move input to key
	movlw	play_key
	cpfseq	key, A		; checks if player selected play
	bra	options		; if not check next option
	call	run_game	; run game
	return			; restart
options:
	movlw	options_key
	cpfseq	key, A		; checks if player selected options
	bra	leader		; if not go to leaderboard
	call	open_options	; open options menu
	return			; restart
leader:
	call	open_leader	; open leaderboard
	return			; restart
	
run_game:
	call	GLCD_fill_0
	call	draw_player
game_loop:
	movlw	10
	call	delay_key_press
	bra	game_loop
	return

open_options:
	call	GLCD_fill_0
	movlw	10
	call	long_delay
	return
	
open_leader:
	call	GLCD_fill_0
	call	draw_player
	movlw	10
	call	long_delay
	return
	
	end	rst

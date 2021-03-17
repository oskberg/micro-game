#include <xc.inc>

; ====== COMMENTS ======
;    Main file where the program starts
    
;    General structure is, 
;	initialisations
;	Run Levels
;	If lose
;	    go to end game
;	if win
;	    go to victory screen
;	repeat
 
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
; From file glcd.s
extrn	GLCD_setup, GLCD_fill_0
	
; From file delay.s
extrn	long_delay
    
; From file game.s
extrn	init_player, check_collision_break, reset_score, play_levels
extrn	first_object
    
; From file keyboard.s
extrn	keyboard_setup
    
; From file menu.s
extrn	menu_plus_options, draw_end_screen, draw_victory_screen
    
; Exports
global	time, collision, end_game
    
; ====== SETUP ======  
;    Code which prepares the micro processor to run the game
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    
key:	    ds 1
time:	    ds 1
collision:  ds 1



psect	code, abs		    ; program starts here
rst: 	org 0x0
 	goto	setup		    ; setup devices

setup:	; set up for the initialisation of the game
	movlw	0x00
	movwf	time, A		    ; time = 0

	call	reset_score	    ; score = 0
	call	GLCD_setup	    ; Setup PortB & D for GLCD
	call	init_player	    ; Intialise player
	call	keyboard_setup	    ; Setup PortE for keyboard
	call	menu_plus_options   ; displays options then waits for input
	goto	main		    ; start game
; ====== END OF SETUP ======
	
; ====== MAIN PART ======
; Runs the game in a loop?
main:
	call	play_levels	    ; plays levels till user wins or loses
	bra	won_game	    ; player won so go to won_game
	
end_game:			    ; routine for when the player dies
	movlw	0x1
	call	long_delay	    ; show screen of how they died
	call	GLCD_fill_0	    ; clear screen
	call	draw_end_screen	    ; draw end screen with player score
	movlw	0x1
	call	long_delay	    ; pause on this screen
	call	reset_stack	    ; clear the stack
	goto	setup		    ; restart from the begining
	
reset_stack: 
	movlw	0x01
	cpfseq	STKPTR, A	    ; checks if 1 item left on stack
	bra	pop_value	    ; if not pop another entry
	bra	setup		    ; if only 1 then restart
pop_value:
	pop			    ; remove item from stack
	bra	reset_stack	    ; loop
	
won_game:
	movlw	0x1
	call	long_delay	    ; wait on final screen
	call	GLCD_fill_0	    ; clear screen
	call	draw_victory_screen ; show victory screen with score
	movlw	0x1
	call	long_delay	    ; pause on victory screen
	goto	setup		    ; reset
    
; ====== END OF MAIN PART ======

	
	end	rst		    ; end of main file

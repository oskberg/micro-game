#include <xc.inc>

; ====== COMMENTS ======
;    This file contains subroutines relating specifically to the game
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
global	init_player, draw_player, inc_player_y, move_player_up, move_player_down
    
extrn	GLCD_fill_section, GLCD_left, GLCD_right, GLCD_remove_section
extrn	x_pos, y_pos
; ====== VARIABLE DECLARATIONS ======
    
psect	udata_acs   ; named variables in access ram
player_x:   ds 1
player_y:   ds 1

player_width	equ 0x0A
	
; =========================
; ====== SUBROUTINES ======
; =========================
psect	game_code, class=CODE
init_player:
	movlw	0x04
	movwf	player_x, A
	movlw	0x08
	movwf	player_y, A
    
	
draw_player:
	call	GLCD_left

;	movlw	0x04
	movf	player_x, W, A
	movwf	x_pos, A
	movf	player_y, W, A
	movwf	y_pos, A
	movlw	player_width
	
	call	GLCD_fill_section
	return	0

inc_player_y:    ; move player 1 step in y with wrapping edge
	incf	player_y, F, A
	incf	player_y, F, A
	movlw	54
	cpfsgt	player_y, A
	bra	incPy
	movlw	0x00
	movwf	player_y, A
incPy:	return	0
	
move_player_up:	    ; move player 1 square up 
	call	GLCD_left	    ; player always on left side

	movf	player_x, W, A
	movwf	x_pos, A	    ; set players current x position
	movf	player_y, W, A
	movwf	y_pos, A	    ; set players current y position
	movlw	player_width
	
	call	GLCD_remove_section ; clear player
	
	incf	player_x, F, A	    ; incrament x position
	movf	player_x, W, A
	movwf	x_pos, A	    ; set x position
	movlw	player_width
	
	call	GLCD_fill_section   ; draw new position
	
	return	0
	
	
move_player_down:	  ; move player 1 square down 
	call	GLCD_left

	movf	player_x, W, A
	movwf	x_pos, A	    ; set players current x position
	movf	player_y, W, A
	movwf	y_pos, A	    ; set players current y position
	movlw	player_width
	
	call	GLCD_remove_section ; clear player
	
	decf	player_x, F, A	    ; decrament x position
	movf	player_x, W, A
	movwf	x_pos, A	    ; set x position
	movlw	player_width
	
	call	GLCD_fill_section   ; draw new player
	
	return	0

#include <xc.inc>

; ====== COMMENTS ======
;    This file contains subroutines relating specifically to the game
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
global	init_player, draw_player, inc_player_y, move_player_up, move_player_down
global	draw_object, load_level, draw_level
    
extrn	GLCD_fill_section, GLCD_left, GLCD_right, GLCD_fill_page_whole, GLCD_remove_section, GLCD_set_x, GLCD_set_y
extrn	x_pos, y_pos, y_pos_t, time
; ====== VARIABLE DECLARATIONS ======
    
psect	udata_acs   ; named variables in access ram
player_x:	ds 1
player_y:	ds 1
temp_count:	ds 1
score:		ds 1

    player_width	equ 0x0A

psect	udata_acs
first_object:	ds  1
draw_count:	ds  1
object_T:	ds  1
object_width:	ds  1
current_obj_y:	ds  1
x_count:	ds  1
current_gap:	ds  1
    
psect	udata_bank1
current_gaps:	ds  20	    ; reserve some space for the current level
			    ; holds the gaps for the objects in current level
	
    ; Store the gaps of the obstacles in program memory as a level
psect	data
gap_pages: 
	db  4,2,6,3,1,6,4,7,1,4,3,6,5,1,4,3,2,5,3,2,3,4,3,0xa    ; level with terminator
	
	gaps_len    equ	24
	align	2
	
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
	
; load a level from program memory into 'current_gaps' in bank1
; Currently only loading the starting level.
; TODO: specify which level is loaded.
load_level:	; much of this is taken from the lab exercises!!!
	lfsr	0, current_gaps	; Load FSR0 with address in RAM	
	movlw	low highword(gap_pages)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(gap_pages)		; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(gap_pages)		; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	gaps_len		; bytes to read
	movwf 	temp_count, A		; our counter register
ll_loop:
        tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	temp_count, A		; count down to zero
	bra	ll_loop			; keep going until finished
	
	; set up level variables. CURRENTLY HARD CODED
	; TODO: make specific to level
;	movlb	0x01	; level variables in bank 1
	movlw	0x00
;	movwf	time_step, A	; set time to 0
	movwf	first_object, A
	movwf	score, A
	movlw	0x08		
	movwf	object_width, A	; set object with to 8 pixels
	movlw	24
	movwf	object_T, A	; set object separation to 24 pixels
;	movlb	0x00		; reset bank

	return	0
	
draw_level:
    	; reset time if equal to 1 period
	movf	object_T, W, A
;	addwf	object_T, W, A
	cpfseq	time, A
	bra	dlsp
	
	; this bit if time is equal to period
;	movff	object_T, time
	movlw	0x00
	movwf	time, A
	incf	first_object, F, A
	incf	score, A
	; loop over all objects to draw 
;	movlb	0x01
;	movf	current_gaps, W, B
;	movlb	0x00
dlsp:	movlw	0x00
	movwf	draw_count, A
	lfsr	0, current_gaps	    ; load lsfr 0 which holds the gaps
	movf	first_object, W, A
	addwf	FSR0, F, A
dlloop:	
	movf	POSTINC0, W, A  ; move gap at lsfr0 into current_gap
	movwf	current_gap, A
	
	movf	object_T, W, A	; skip here if not equal to period
	mulwf	draw_count, A
	movf	PRODL, W, A
	addwf	object_T, W, A
	subwf	time, W, A
	sublw	0x00
	movwf	current_obj_y, A
	
	movlw	0x00
	movwf	x_pos, A
	movlw	0x08
	movwf	x_count, A
	
	movlw	120	; 64+64 - object_width
	cpfsgt	current_obj_y, A    ; if y position outside of screen, don't draw it
	call	draw_object
	
	incf	draw_count, F, A
	movlw	0x05		; max number of objects on the screen at once
	cpfsgt	draw_count, A
	bra	dlloop
	
	return	0

	
draw_object:	; draws a line at current_obj_y with a gap at first_object pages

draw_ob_loop:	
	movf	current_gap, W, A
	cpfseq	x_pos, A
	bra	dolb2
dolb1:	incf	x_pos, F, A
	decfsz	x_count, A
	bra	draw_ob_loop
	return	0
	
dolb2:	movf	current_obj_y, W, A
	movwf	y_pos, A
	movf	object_width, W, A
	call	GLCD_fill_page_whole
	bra	dolb1

	
	
move_player_up:	    ; move player 1 square up 
	call	GLCD_left	    ; player always on left side

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
	
	incf	player_x, F, A	    ; incrament x position
	movf	player_x, W, A
	movwf	x_pos, A	    ; set x position
	movlw	player_width
	
	call	GLCD_fill_section   ; draw new player
	
	return	0

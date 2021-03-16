#include <xc.inc>

; ====== COMMENTS ======
;    This file contains subroutines relating specifically to the game
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
global	init_player, draw_player, inc_player_y, move_player_up, move_player_down
global	draw_object, load_level, draw_level, check_collision, check_collision_break
global	score, reset_score, load_level_1, load_level_2, load_level_3
global	first_object, level_1_len, level_2_len, level_3_len, play_frame, play_levels
    
extrn	GLCD_fill_section, GLCD_left, GLCD_right, GLCD_fill_page_whole, GLCD_remove_section, GLCD_set_x, GLCD_set_y
extrn	end_game
extrn	x_pos, y_pos, y_pos_t, time, collision
extrn	GLCD_fill_0
extrn	delay_key_press, long_delay
extrn	draw_level_1_screen, draw_level_2_screen, draw_level_3_screen

; ====== VARIABLE DECLARATIONS ======
    
psect	udata_acs   ; named variables in access ram
player_x:	ds 1
player_y:	ds 1
temp_count:	ds 1
score:		ds 1

    player_width	equ 0x08
    width_object	equ 0x04
    object_separation	equ 0x18
    width_object_1	equ 0x04
    object_separation_1	equ 0x18
    time_inc_1		equ 2
    width_object_2	equ 0x04
    object_separation_2	equ 0x14
    time_inc_2		equ 4
    width_object_3	equ 0x04
    object_separation_3	equ 0x14
    time_inc_3		equ 5
    	
psect	udata_acs
first_object:	ds  1
draw_count:	ds  1
object_T:	ds  1
object_width:	ds  1
current_obj_y:	ds  1
x_count:	ds  1
current_gap:	ds  1
time_inc:	ds  1
speed_key_press:ds  1
    
psect	udata_bank1
current_gaps:	ds  20	    ; reserve some space for the current level
			    ; holds the gaps for the objects in current level
	
    ; Store the gaps of the obstacles in program memory as a level
psect	data
gap_pages: 
	db  4,2,6,3,1,6,4,7,1,4,3,6,5,1,4,3,2,5,3,2,3,4,3,0xa    ; level with terminator
	
	gaps_len    equ	24
	align	2
	
level_1:
	db  1,2,3,4,2,6,3,1,7,6,7,3,2,5,4,3,7,1,5,1,5,2,7,0xa    ; level with terminator
;	db  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0xa    ; level with terminator	
	level_1_len	    equ 24
	    
level_2:
	db  2,3,2,6,1,2,7,5,4,5,3,1,5,1,2,3,1,5,1,3,6,4,7,0xa    ; level with terminator
;	db  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0xa    ; level with terminator
	level_2_len	    equ 24
	    
level_3:
	db  3,7,3,6,3,5,3,4,3,2,3,1,3,7,4,2,5,3,1,5,3,7,1,0xa    ; level with terminator
;	db  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0xa    ; level with terminator
	level_3_len	    equ 24
	
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
	movf	x_pos, W, A
	movwf	player_x, A
;	movff	x_pos, player_x
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
;	movwf	score, A	
;	movlw	0x04
	movlw	width_object
	movwf	object_width, A	; set object with to 8 pixels
;	movlw	24
	movlw	object_separation
	movwf	object_T, A	; set object separation to 24 pixels
;	movlb	0x00		; reset bank

	return	0
	
reset_score:
	movlw	0x00
	movwf	score, A
	return	0
	
load_level_1:	; much of this is taken from the lab exercises!!!
	lfsr	0, current_gaps	; Load FSR0 with address in RAM	
	movlw	low highword(level_1)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(level_1)		; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(level_1)		; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	level_1_len		; bytes to read
	movwf 	temp_count, A		; our counter register
ll_1_loop:
        tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	temp_count, A		; count down to zero
	bra	ll_1_loop			; keep going until finished
	
	; set up level variables. CURRENTLY HARD CODED
	; TODO: make specific to level
;	movlb	0x01	; level variables in bank 1
	movlw	0x00
;	movwf	time_step, A	; set time to 0
	movwf	first_object, A
;	movwf	score, A	
;	movlw	0x04
	movlw	width_object_1
	movwf	object_width, A	; set object with to 8 pixels
;	movlw	24
	movlw	object_separation_1
	movwf	object_T, A	; set object separation to 24 pixels
;	movlb	0x00		; reset bank
	movlw	time_inc_1
	sublw	0x00
	movwf	time, A

	return	0	
	
load_level_2:	; much of this is taken from the lab exercises!!!
	lfsr	0, current_gaps	; Load FSR0 with address in RAM	
	movlw	low highword(level_2)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(level_2)		; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(level_2)		; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	level_2_len		; bytes to read
	movwf 	temp_count, A		; our counter register
ll_2_loop:
        tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	temp_count, A		; count down to zero
	bra	ll_2_loop			; keep going until finished
	
	; set up level variables. CURRENTLY HARD CODED
	; TODO: make specific to level
;	movlb	0x01	; level variables in bank 1
	movlw	0x00
;	movwf	time_step, A	; set time to 0
	movwf	first_object, A
;	movwf	score, A	
;	movlw	0x04
	movlw	width_object_2
	movwf	object_width, A	; set object with to 8 pixels
;	movlw	24
	movlw	object_separation_2
	movwf	object_T, A	; set object separation to 24 pixels
;	movlb	0x00		; reset bank
	movlw	time_inc_2
	sublw	0x00
	movwf	time, A
	return	0
	
load_level_3:	; much of this is taken from the lab exercises!!!
	lfsr	0, current_gaps	; Load FSR0 with address in RAM	
	movlw	low highword(level_3)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(level_3)		; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(level_3)		; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	level_3_len		; bytes to read
	movwf 	temp_count, A		; our counter register
ll_3_loop:
        tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	temp_count, A		; count down to zero
	bra	ll_3_loop			; keep going until finished
	
	; set up level variables. CURRENTLY HARD CODED
	; TODO: make specific to level
;	movlb	0x01	; level variables in bank 1
	movlw	0x00
;	movwf	time_step, A	; set time to 0
	movwf	first_object, A
;	movwf	score, A	
;	movlw	0x04
	movlw	width_object_3
	movwf	object_width, A	; set object with to 8 pixels
;	movlw	24
	movlw	object_separation_3
	movwf	object_T, A	; set object separation to 24 pixels
;	movlb	0x00		; reset bank
	movlw	time_inc_3
	sublw	0x00
	movwf	time, A
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
	return	0

	
clear_player:
	call	GLCD_left	    ; player always on left side

	movf	player_x, W, A
	movwf	x_pos, A	    ; set players current x position
	movf	player_y, W, A
	movwf	y_pos, A	    ; set players current y position
	movlw	player_width
	
	call	GLCD_remove_section ; clear player
	return
    
move_player_up:	    ; move player 1 square up 
	call	clear_player
	decf	player_x, F, A	    ; decrament x position
	call	draw_player
	call	check_collision_break
	return	0
	
	
move_player_down:   ; move player 1 square down 
	call	clear_player
	incf	player_x, F, A	    ; incrament x position
	call	draw_player
	call	check_collision_break
	return	0

check_collision: 
	movf	time, W, A
	subwf	object_T, W, A
	movwf	current_obj_y, A
	movf	player_y, W, A
	addlw	player_width
	cpfslt	current_obj_y, A
	retlw	0
	
	movf	current_obj_y, W, A
	addwf	object_width, W, A
	movwf	current_obj_y, A
	movf	player_y, W, A
	addlw	0x01
	cpfslt	current_obj_y, A
	bra	check_gap
	retlw	0
check_gap:
	lfsr	0, current_gaps	    ; load lsfr 0 which holds the gaps
	movf	first_object, W, A
	addwf	FSR0, F, A
	movf	POSTINC0, W, A  ; move gap at lsfr0 into current_gap
	movwf	current_gap, A
	movf	player_x, W, A
	cpfseq	current_gap, A
	retlw	1
	retlw	0

check_collision_break:
	call	check_collision
	movwf	collision, A
	movlw	0
	cpfseq	collision, A
	goto	end_game
	return	0

play_frame:
	call	GLCD_fill_0
	call	draw_player
	call	draw_level

	call	check_collision_break
	
	movf	speed_key_press, W, A
	call	delay_key_press
	
	movf	time_inc, W, A
	addwf	time, F, A
	return

play_levels:
    	call	GLCD_fill_0
	call	draw_level_1_screen
	movlw	0x01
	call	long_delay
	call	load_level_1
	movlw	time_inc_1
	movwf	time_inc, A
	movlw	0x05
	movwf	speed_key_press, A
	
level_1_play:
	call	play_frame
	movlw	0x01
	sublw	level_1_len
	cpfseq	first_object, A
	bra	level_1_play
	
level_2_draw:
	call	GLCD_fill_0
	call	draw_level_2_screen
	movlw	0x01
	call	long_delay	
	call	load_level_2
	movlw	time_inc_2
	movwf	time_inc, A
	movlw	0x04
	movwf	speed_key_press, A
	
level_2_play:
	call	play_frame
	movlw	0x01
	sublw	level_2_len
	cpfseq	first_object, A
	bra	level_2_play
	
level_3_draw:
	call	GLCD_fill_0	
	call	draw_level_3_screen
	movlw	0x01
	call	long_delay	
	call	load_level_3
	movlw	time_inc_3
	movwf	time_inc, A
	movlw	0x03
	movwf	speed_key_press, A	
	
level_3_play:
	call	play_frame
	movlw	0x01
	sublw	level_3_len
	cpfseq	first_object, A
	bra	level_3_play
	return

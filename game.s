#include <xc.inc>

; ====== COMMENTS ======
;    This file contains subroutines relating specifically to the game
;    This file also has the main run sequence to play the game
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
; From file glcd.s
extrn	GLCD_fill_section, GLCD_left, GLCD_right, GLCD_fill_page_whole 
extrn	GLCD_remove_section, GLCD_set_x, GLCD_set_y, GLCD_fill_0
    
; From file main.s
extrn	end_game
extrn	x_pos, y_pos, y_pos_t, time, collision
    
; From file delay.s
extrn	delay_key_press, long_delay
    
; From file menu.s
extrn	draw_level_1_screen, draw_level_2_screen, draw_level_3_screen
extrn	display_score, draw_level_4_screen
    
; Exports 
global	init_player, draw_player, move_player_up, move_player_down
global	check_collision_break, play_levels, reset_score
global	score, first_object
global	level_1_len, level_2_len, level_3_len, level_4_len

; ====== VARIABLE DECLARATIONS ======
    
psect	udata_acs   ; named variables in access ram
player_x:	ds 1
player_y:	ds 1
temp_count:	ds 1
score:		ds 1
first_object:	ds  1
draw_count:	ds  1
object_T:	ds  1
object_width:	ds  1
current_obj_y:	ds  1
x_count:	ds  1
current_gap:	ds  1
time_inc:	ds  1
speed_key_press:ds  1

;    Constants which define how each level will run
    player_width	equ 0x08
    width_object	equ 0x04
    object_separation	equ 0x18
    width_object_1	equ 0x04	; 1, 2, 3, 4 represent each level
    object_separation_1	equ 0x1C	; object separation must be divisible by
    time_inc_1		equ 4		; time inc for each level
    width_object_2	equ 0x04	; width of the object
    object_separation_2	equ 0x14	; distance between each object
    time_inc_2		equ 4		; number of pixels moved each time step
    width_object_3	equ 0x04
    object_separation_3	equ 0x10
    time_inc_3		equ 4
    width_object_4	equ 0x04
    object_separation_4	equ 0x20
    time_inc_4		equ 8
    
psect	udata_bank1	    ; space for the levels to be stored
current_gaps:	ds  30	    ; reserve some space for the current level
			    ; holds the gaps for the objects in current level
	
; Store the levels, as a list of the locations of gaps in obstacles 
psect	data
gap_pages:  ; test level
	db  4,2,6,3,1,6,4,7,1,4,3,6,5,1,4,3,2,5,3,2,3,4,3,0xa    ; level with terminator
	
	gaps_len    equ	24
	align	2
	
level_1:
	db  1,2,3,4,2,6,3,1,7,6,7,3,2,5,4,3,7,1,5,1,5,2,7,0xa    ; level with terminator
	level_1_len	    equ 11
	    
level_2:
	db  2,3,2,6,1,2,7,5,4,5,3,1,5,1,2,3,1,5,1,3,6,4,7,0xa    ; level with terminator
	level_2_len	    equ 24
	    
level_3:
	db  4,6,5,3,1,7,5,6,7,0,1,2,1,3,2,4,3,5,4,6,5,7,0,0xa	 ; level with terminator
	level_3_len	    equ 24
	    
level_4:
	db  3,7,3,6,3,5,3,4,1,5,2,6,7,3,0,5,1,3,7,2,4,7,1,0xa    ; level with terminator
	level_4_len	    equ 24
	
; =========================
; ====== SUBROUTINES ======
; =========================
psect	game_code, class=CODE
init_player:			; initalises player to position x=4, y=8
	movlw	0x04
	movwf	player_x, A	; player_x stores player x position
	movlw	0x08
	movwf	player_y, A	; player_y stores player y position
    
	
draw_player:			; draws player at player_x, player_y
	call	GLCD_left	; will always be on left side of the screen
	movf	player_x, W, A
	movwf	x_pos, A	; puts player_x into x_pos
	
	movf	player_y, W, A
	movwf	y_pos, A	; puts player y into y_pos
	
	movlw	player_width	; puts player width on w
	
	call	GLCD_fill_section   ; fills player section with on pixels
	movf	x_pos, W, A
	movwf	player_x, A	; for case of wrapping, x_pos will be wrapped
	return	0
	
; load a level from program memory into 'current_gaps' in bank1
; this loads test level 
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

	movlw	0x00
	movwf	first_object, A
	movlw	width_object
	movwf	object_width, A	; set object with to 8 pixels
	movlw	object_separation
	movwf	object_T, A	; set object separation to 24 pixels

	return	0
	
reset_score:	; resets the score to 0
	movlw	0x00
	movwf	score, A
	return	0
	
load_level_1:	; loads level 1 from PM --> 'current gaps' in Bank 1
	lfsr	0, current_gaps		; Load FSR0 with address in RAM	
	movlw	low highword(level_1)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(level_1)		; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(level_1)		; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	level_1_len		; bytes to read
	movwf 	temp_count, A		; our counter register
ll_1_loop:
        tblrd*+			    ; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0    ; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	temp_count, A		; count down to zero
	bra	ll_1_loop		; keep going until finished
	
;	setup parameters for level 1
	movlw	0x00
	movwf	first_object, A	    ; set first object to 0
	movlw	width_object_1	    
	movwf	object_width, A	    ; set object width to level 1 object width
	movlw	object_separation_1 ; set object separation to level 1 object
	movwf	object_T, A	    ; separation

	movlw	time_inc_1
	addlw	time_inc_1
	sublw	0x00		    ; start at least 2 time steps before first
	movwf	time, A		    ; obsticle

	return	0	
	
load_level_2:	; loads level 2 from PM --> 'current gaps' in Bank 1
	lfsr	0, current_gaps		; Load FSR0 with address in RAM	
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
	bra	ll_2_loop		; keep going until finished

; setup parameters for level 2
	movlw	0x00
	movwf	first_object, A		; set first object to 0
	movlw	width_object_2
	movwf	object_width, A	    ; set object width to level 2 object width
	movlw	object_separation_2 ; set object separation to level 2 object 
	movwf	object_T, A	    ; separation

	movlw	time_inc_2
	addlw	time_inc_2
	sublw	0x00		    ; start at least 2 time steps before first
	movwf	time, A		    ; obsticle
	return	0
	
load_level_3:	; loads level 3 from PM --> 'current gaps' in Bank 1
	lfsr	0, current_gaps		; Load FSR0 with address in RAM	
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
	bra	ll_3_loop		; keep going until finished
	
	; setup parameters for level 3
	movlw	0x00
	movwf	first_object, A	    ; set first object to 0
	movlw	width_object_3
	movwf	object_width, A	    ; set object width to level 3 object width
	movlw	object_separation_3 ; set object separation to level 3 object 
	movwf	object_T, A	    ; separation

	movlw	time_inc_3	    ; start at least 2 time steps before first
	addlw	time_inc_3	    ; before the first obstacle
	sublw	0x00
	movwf	time, A
	return	0
	
load_level_4:	; loads level 4 from PM --> 'current gaps' in Bank 1
	lfsr	0, current_gaps		; Load FSR0 with address in RAM	
	movlw	low highword(level_4)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(level_4)		; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(level_4)		; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	level_4_len		; bytes to read
	movwf 	temp_count, A		; our counter register
ll_4_loop:
        tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	temp_count, A		; count down to zero
	bra	ll_4_loop		; keep going until finished
	
	; setup parameters for level 4
	movlw	0x00
	movwf	first_object, A	    ; set first object to 0
	movlw	width_object_4
	movwf	object_width, A	    ; set object width to level 4 object width
	movlw	object_separation_4 ; set object separation to level 4 object 
	movwf	object_T, A	    ; separation
	
	movlw	time_inc_4	    ; start at least 2 time steps before first
	addlw	time_inc_4	    ; obstacle
	sublw	0x00
	movwf	time, A
	return	0
	
draw_level: ; draws the current level
    	; reset time if equal to 1 period
	movf	object_T, W, A
	cpfseq	time, A
	bra	dlsp		    ; draw level start point
	
	; this bit if time is equal to period
	movlw	0x00
	movwf	time, A		    ; reset time period
	incf	first_object, F, A  ; incrament new closest object
	incf	score, A	    ; incrament score
	
	; loop over all objects to draw 
dlsp:	movlw	0x00
	movwf	draw_count, A	    ; reset draw_count
	lfsr	0, current_gaps	    ; load lsfr 0 which holds the gaps
	movf	first_object, W, A  ; checks which obsticle to start at
	addwf	FSR0, F, A	    ; finds corresponding location in RAM
dlloop:	
	movf	POSTINC0, W, A	    ; move gap at lsfr0 into current_gap
	movwf	current_gap, A
	
	movf	object_T, W, A	    ; calculates current y position of obstacle
	mulwf	draw_count, A	    ; by doing object_T * object_number +
	movf	PRODL, W, A	    ; (time - object_T)
	addwf	object_T, W, A
	subwf	time, W, A
	sublw	0x00
	movwf	current_obj_y, A    ; put vaue into current_obj_y
	
	movlw	0x00
	movwf	x_pos, A	    ; start drawing at x = 0
	movlw	0x08
	movwf	x_count, A	    ; total of 8 pages to draw in
	
	movlw	120	; 64+64 - object_width
	cpfsgt	current_obj_y, A    ; if y position outside of screen, don't draw it
	call	draw_object	    ; draw object
	
	incf	draw_count, F, A    ; select next object
	movlw	0x05		    ; max number of objects on the screen at once
	cpfsgt	draw_count, A	    ; check if all obsticles drawn
	bra	dlloop		    ; repeat
	
	return	0

	
draw_object:	; draws a line at current_obj_y with a gap at current_gap page

draw_ob_loop:	
	movf	current_gap, W, A
	cpfseq	x_pos, A	    ; check if current x = gap
	bra	dolb2		    ; if not fill page
dolb1:	incf	x_pos, F, A	    ; incrament to next page
	decfsz	x_count, A
	bra	draw_ob_loop	    ; repeat till x_count = 0
	return	0
	
dolb2:	movf	current_obj_y, W, A 
	movwf	y_pos, A
	movf	object_width, W, A  ; put object width on w
	call	GLCD_fill_page_whole; draws object
	bra	dolb1		    ; incrament values and check if finished
	return	0

	
clear_player:	; clears the squares where the player was
	call	GLCD_left	    ; player always on left side

	movf	player_x, W, A
	movwf	x_pos, A	    ; set players current x position
	movf	player_y, W, A
	movwf	y_pos, A	    ; set players current y position
	movlw	player_width
	
	call	GLCD_remove_section ; clear player
	return
    
move_player_up:	    ; move player 1 square up 
	call	clear_player	    ; removes player
	decf	player_x, F, A	    ; decrament x position
	call	draw_player	    ; draws player in new position
	call	check_collision_break	; check if now colliding with obstacle
	return	0
	
	
move_player_down:   ; move player 1 square down 
	call	clear_player	    ; removes player
	incf	player_x, F, A	    ; incrament x position
	call	draw_player	    ; draws player in new position
	call	check_collision_break	; chek if now colliding with obstacle
	return	0

check_collision:    ; check if a collision is happening, 1 = collision, 0 = none
	movf	time, W, A	    ; find current location of closest obstacle
	subwf	object_T, W, A	    ; left side by doing object_T - time
	movwf	current_obj_y, A    ; puts in current_obj_y
	movf	player_y, W, A
	addlw	player_width	    ; finds location of players right side
	cpfslt	current_obj_y, A    ; checks if obstacle before the player
	retlw	0		    ; no collision
	
	movf	current_obj_y, W, A ; find current location of closest obstacle
	addwf	object_width, W, A  ; right side
	movwf	current_obj_y, A 
	movf	player_y, W, A	    ; finds location of players left side
	addlw	0x01
	cpfslt	current_obj_y, A    ; check if obstacle is passed player
	bra	check_gap	    ; if not check if collision
	retlw	0		    ; else no collision
check_gap:
	lfsr	0, current_gaps	    ; load lsfr 0 which holds the gaps
	movf	first_object, W, A
	addwf	FSR0, F, A
	movf	POSTINC0, W, A	    ; move gap at lsfr0 into current_gap
	movwf	current_gap, A
	movf	player_x, W, A
	cpfseq	current_gap, A	    ; check if player_x = obstacle_x
	retlw	1		    ; if they don't collision
	retlw	0		    ; if they do no collision

check_collision_break:	; check if a collision happened and exit if collision
	call	check_collision	    ; check if collision happened
	movwf	collision, A	    ; 1 if collision, 0 if no collision
	movlw	0
	cpfseq	collision, A
	goto	end_game	    ; if collision go to end_game
	return	0		    ; else continue with program

play_frame: ; runs a frame of the game
	call	GLCD_fill_0	    ; clears the screen
	call	draw_player	    ; draws the player
	call	draw_level	    ; draws the level with obstacles
	call	display_score	    ; displays the score in the top right
	
	call	check_collision_break	; check if collision from obstacles moving
	
	movf	speed_key_press, W, A	; how long to wait for key press
	call	delay_key_press		; check for user input to move
	
	movf	time_inc, W, A	    ; add time step specified
	addwf	time, F, A	    ; to current time
	return

play_levels:	; runs through all levels till a win or player dies
    	call	GLCD_fill_0		; clear screen
	call	draw_level_1_screen	; draw level 1 info screen
	movlw	0x01
	call	long_delay		; pause
	call	init_player		; re-initalise player
	call	load_level_1		; load level 1 to gap_pages
	movlw	time_inc_1
	movwf	time_inc, A		; move time_inc_1 to time_inc
	movlw	0x05
	movwf	speed_key_press, A	; move key press delay of 5
	
level_1_play:	; runs level 1
	call	play_frame		; run a framce
	movlw	0x01
	sublw	level_1_len		; check if level complete
	cpfseq	first_object, A
	bra	level_1_play		; repeat
	
level_2_draw:				; prepare level 2
	call	GLCD_fill_0		; clear screen
	call	draw_level_2_screen	; draw level 2 info screen
	movlw	0x01
	call	long_delay		; pause
	call	init_player		; re-initalise player
	call	load_level_2		; load level 2 to gap_pages
	movlw	time_inc_2
	movwf	time_inc, A		; set time_inc to time_inc_2
	movlw	0x04
	movwf	speed_key_press, A	; set key time to 4
	
level_2_play:				; play level 2
	call	play_frame		; play frame
	movlw	0x01
	sublw	level_2_len		; check if level 2 complete
	cpfseq	first_object, A
	bra	level_2_play		; repeat
	
level_3_draw:				; prepare level 3
	call	GLCD_fill_0		; clear screen
	call	draw_level_3_screen	; draw level 3 info screen
	movlw	0x01
	call	long_delay		; pause
	call	init_player		; re-initalise player
	call	load_level_3		; load level 3 to gap_pages
	movlw	time_inc_3		
	movwf	time_inc, A		; set time_inc to time_inc_3
	movlw	0x04
	movwf	speed_key_press, A	; set key time to 4
	
level_3_play:				; play level 3
	call	play_frame		; play frame
	movlw	0x01
	sublw	level_3_len		; check if level 2 complete
	cpfseq	first_object, A
	bra	level_3_play		; repeat
	
level_4_draw:				; prepare level 4
	call	GLCD_fill_0		; clear screen
	call	draw_level_4_screen	; draw level 4 info screen
	movlw	0x01
	call	long_delay		; pause
	call	init_player		; re-initalise player
	call	load_level_4		; load level 4 to gap_pages
	movlw	time_inc_4
	movwf	time_inc, A		; set tim_inc to time_inc_4 
	movlw	0x04
	movwf	speed_key_press, A	; set key tme to 4
	
level_4_play:				; play level 4
	call	play_frame		; play frame
	movlw	0x01
	sublw	level_4_len		; check if level 4 complete
	cpfseq	first_object, A
	bra	level_4_play		; repeat
	return				; return as finised game
	
; end of game.s

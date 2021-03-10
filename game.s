#include <xc.inc>

; ====== COMMENTS ======
;    This file contains subroutines relating specifically to the game
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
global	init_player, draw_player, inc_player_y, load_level, draw_object 
    
extrn	GLCD_fill_section, GLCD_left, GLCD_right, GLCD_fill_page_whole
extrn	x_pos, y_pos
; ====== VARIABLE DECLARATIONS ======
    
psect	udata_acs   ; named variables in access ram
player_x:	ds 1
player_y:	ds 1
temp_count:	ds 1

    player_width	equ 0x0A

psect	udata_acs
first_object:	ds  1
draw_count:	ds  1
time_step:	ds  1
object_T:	ds  1
object_width:	ds  1
current_obj_y:	ds  1
x_count:	ds  1
    
psect	udata_bank1
current_gaps:	ds  20	    ; reserve some space for the current level
			    ; holds the gaps for the objects in current level
	
    ; Store the gaps of the obstacles in program memory as a level
psect	data
gap_pages: 
	db  4,2,6,3,0xa    ; level with terminator
	
	gaps_len    equ	4
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
	movwf	time_step, A	; set time to 0
	movwf	first_object, A
	movlw	0x08		
	movwf	object_width, A	; set object with to 8 pixels
	movlw	24
	movwf	object_T, A	; set object separation to 24 pixels
;	movlb	0x00		; reset bank

	return	0
	
;draw_level:
;	; loop over all objects to draw 
;	movlb	0x01	; level variables in bank 1
;	movlw	0x01
;	movwf	draw_count, B
;		
;	movlb	0x00		; reset bank
;	return	0
;
	
draw_object:	; draws a line at current_obj_y with a gap at first_object pages
	movlw	0x00
	movwf	x_pos, A
	movlw	0x08
	movwf	x_count, A
draw_ob_loop:	
	movlw	60
	movwf	y_pos, A
	movf	object_width, W, A
	call	GLCD_fill_page_whole
	incf	x_pos, F, A
	decfsz	x_count, A
	bra	draw_ob_loop
	return	0

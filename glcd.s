#include <xc.inc>
    
; ====== COMMENTS ====== 
;   This file contains subroutines for driving the GLCD

;   PIN CONFUGURATION ON GLCD:
;    control lines	PortB
;    data lines		PortD
;    
;    RS: (possibly D/I in datasheet)		->  RB2
;	high	-   Data
;	low	-   Instruction
;    
;    R/W:					->  RB3
;	high	-   Read from module
;	low	-   Write to module
;
;    E		-   Enable line			->  RB4
;    D0-D7	-   Data lines			->  RD0-7
;    RST	-   Display reset		->  RB5
;    CS1	-   Select xx half		->  RB0
;    CS2	-   Select xx half		->  RB1

; ====== IMPORTS/EXPORTS ======
extrn	delay_ms, delay_x4us, delay

global	GLCD_setup, GLCD_fill_0, GLCD_fill_1, GLCD_fill_section, GLCD_left, GLCD_right
global	GLCD_fill_page_whole
global	GLCD_setup, GLCD_fill_0, GLCD_fill_1, GLCD_fill_section, GLCD_remove_section, GLCD_left, GLCD_right
global	y_pos, x_pos
    
; ====== VARIABLE DECLARATIONS ======
; DEFINE PINS
        CS1	EQU 0
	CS2	EQU 1
	RS	EQU 2
	RW_DI	EQU 3
	E	EQU 4
	RST	EQU 5
	
	y_len	EQU 64
	x_len	EQU 8
    
psect	udata_acs   ; named variables in access ram
fill_val:   ds 1
y_counter:  ds 1
x_counter:  ds 1
cs_counter: ds 1
y_pos:	    ds 1
x_pos:	    ds 1

; =========================
; ====== SUBROUTINES ======
; =========================
psect	glcd_code,class=CODE

GLCD_fill_0:	; writes 0 to all pixels
	movlw	0x00
	movwf	fill_val, A ; fill with empty
	call    GLCD_fill
	return	0

	
GLCD_fill_1:	; writes 1 to all pixels
	movlw	0xFF
	movwf	fill_val, A ; fill with empty
	call    GLCD_fill
	return	0
	
GLCD_left:  ; select left screen and set coordinates
	bcf	LATB, CS1, A
	bsf	LATB, CS2, A
	call	GLCD_set_x  ; set coordinates to what they were on the other side?
	call	GLCD_set_y
	return	0
	
GLCD_right:  ; select right screen and set coordinates
	bsf	LATB, CS1, A
	bcf	LATB, CS2, A
	call	GLCD_set_x  ; set coordinates to what they were on the other side?
	call	GLCD_set_y	
	return	0
	
GLCD_right_dec:  ; select right screen and set coordinates using new coordinate function.
	bsf	LATB, CS1, A
	bcf	LATB, CS2, A
	call	GLCD_set_x  ; set coordinates to what they were on the other side?
	call	GLCD_set_y_dec	
	return	0
	
GLCD_fill_section: ; fills a page at x_pos from pos_y to pos_y + w
	movwf	y_counter, A
	
	call	GLCD_set_x
	call	GLCD_set_y

yLoopAdress:	; loop over y coordinates, writing the clear value
    	; put  empty data to write to screen on data pins
	movlw	0xff
	movwf	LATD, A	
	call	GLCD_write_d
	decfsz	y_counter, F, A
	bra	yLoopAdress	; loop over w addresses 
	
	return	0
	
GLCD_fill_page_whole: ; fills a page at x_pos from pos_y to pos_y + w
	movwf	y_counter, A
	call	GLCD_left
	call	GLCD_set_x
	call	GLCD_set_y

yLoopAdressW:	; loop over y coordinates
	movlw	0xff
	movwf	LATD, A	
	movlw	64
	cpfslt	y_pos, A
	call	GLCD_right
	call	GLCD_write_d
	incf	y_pos, F, A 
	decfsz	y_counter, F, A
	bra	yLoopAdressW	; loop over w addresses 
	
	return	0

	
GLCD_remove_section: ; clears a page at x_pos from pos_y to pos_y + w
	movwf	y_counter, A
	
	call	GLCD_set_x
	call	GLCD_set_y

yLoopAdress_r:	; loop over y coordinates, writing the clear value
    	; put  empty data to write to screen on data pins
	movlw	0x00
	movwf	LATD, A	
	call	GLCD_write_d
	decfsz	y_counter, F, A
	bra	yLoopAdress_r	; loop over w addresses 
	
	return	0	
	
GLCD_fill:  ; fills screen with the value in fill_val
	; wipe first half
    	bcf	LATB, CS1, A
	bsf	LATB, CS2, A
	movlw	0x2
	movwf	cs_counter, A
cs_loop:	
	; reset coordinates to (0,0)
	movlw	0x00
	movwf	x_pos, A
	movwf	y_pos, A
	; define coutners for looping over screen
	movlw	x_len
	movwf	x_counter, A
w_x_loop:	; loop over all pages
	movlw	y_len
	movwf	y_counter, A
	; start at (0,0)
	call	GLCD_set_x
	call	GLCD_set_y
	incf	x_pos, F, A
w_y_loop:	; loop over y coordinates, writing the clear value
    	; put  empty data to write to screen on data pins
	movf	fill_val, W, A
	movwf	LATD, A	
;	movff	fill_val, LATD
	call	GLCD_write_d
	decfsz	y_counter, F, A
	bra	w_y_loop	; loop over 64 addresses 
	
	decfsz	x_counter, F, A	; loop over 8 pages
	bra	w_x_loop

	; repeat for second half of display
	bcf	LATB, CS2, A
	bsf	LATB, CS1, A
	decfsz	cs_counter, F, A
	bra	cs_loop
	
	return
	
GLCD_off:   ; turns the screen off. Not useful i think. Also lacking specifiers cs1 and cs2
	bcf	LATB, RS, A
	bcf	LATB, RW_DI, A
	movlw	00111110B
	movwf	LATD, A
	call	GLCD_write_i
	
	bsf	LATB, RS, A
	bsf	LATB, RW_DI, A
	return
	
GLCD_on:    ; turns the screen on (needed to show output)
	bcf	LATB, RS, A
	bcf	LATB, RW_DI, A
	movlw	00111111B
	movwf	LATD, A
	bsf	LATB, CS2, A	    ; turn on first half
	bcf	LATB, CS1, A
	call	GLCD_write_i
	bsf	LATB, CS1, A	    ; turn on second half
	bcf	LATB, CS2, A
	call	GLCD_write_i
	
	bsf	LATB, RS, A
	bsf	LATB, RW_DI, A
	return

GLCD_set_y:	; set y address to y_pos
	bcf	LATB, RS, A
	bcf	LATB, RW_DI, A
	movlw	00111111B
	andwf	y_pos, F, A	; enables wrapping edges
	movlw	01000000B	; last 6 are the coordinate
	addwf	y_pos, W, A	; add current y position to instruction for address 0
	movwf	LATD, A
	call	GLCD_write_i
	bsf	LATB, RS, A
	bsf	LATB, RW_DI, A
	return
	
;GLCD_set_y_dec:	; set y address to y_pos - 64 if too large
;	bcf	LATB, RS, A
;	bcf	LATB, RW_DI, A
;	movlw	01000000B	; last 6 are the coordinate
;	addwf	y_pos, W, A	; add current y position to instruction for address 0
;	movwf	LATD, A
;	call	GLCD_write_i
;	bsf	LATB, RS, A
;	bsf	LATB, RW_DI, A
;	return
;	
	
GLCD_set_x:	; set page to x_pos
	bcf	LATB, RS, A
	bcf	LATB, RW_DI, A
	movlw	00000111B
	andwf	x_pos, F, A	; enables wrapping edges
	movlw	10111000B	; last three digits sets the coordinate
	addwf	x_pos, W, A	; add current x position to instruction for page 0
	movwf	LATD, A
	call	GLCD_write_i
	bsf	LATB, RS, A
	bsf	LATB, RW_DI, A
	return
	
GLCD_setup:
    	clrf    TRISB, A
	setf	LATB, A
	clrf	TRISD, A
	call	GLCD_on
	call	GLCD_fill_0
	return
	
; TODO: combine write d and i so there is no duplicate code
GLCD_write_d:	; writes data to the GLCD screen 
	; E low 
	bcf	LATB, E, A
	
	; delay
	movlw	1
	call	delay_x4us
	
	bcf	LATB, RW_DI, A
	bsf	LATB, RS, A	; change for instruction/data
	
	; delay
	movlw	1
	call	delay_x4us
	
	; E high
	bsf	LATB, E, A
	
	; delay
	movlw	1
	call	delay_x4us
	
	; E low
	bcf	LATB, E, A
		
	; delay
	movlw	1
	call	delay_x4us
	
	; E high
	bsf	LATB, RW_DI, A
	bcf	LATB, RS, A	; change for instruction/data
	bsf	LATB, E, A
	
	return

	
GLCD_write_i:	; writes instructions
	; E low 
	bcf	LATB, E, A
	
	; delay
	movlw	1
	call	delay_x4us
	
	bcf	LATB, RW_DI, A
;	bcf	LATB, CS1,A	; This line shouldnt be here?
	bcf	LATB, RS, A	; change for instruction/data
	
	; delay
	movlw	1
	call	delay_x4us
	
	; E high
	bsf	LATB, E, A
	
	; delay
	movlw	1
	call	delay_x4us
	
	; E low
	bcf	LATB, E, A
	
	; delay
	movlw	1
	call	delay_x4us
	
	; E high
	bsf	LATB, E, A
	bsf	LATB, RW_DI, A
	bcf	LATB, RS, A	; change for instruction/data
	
	return

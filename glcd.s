#include <xc.inc>
    
; ====== COMMENTS ====== 
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

global	GLCD_setup, GLCD_fill_0, GLCD_fill_1
    
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
y_counter:  ds 1
x_counter:  ds 1
cs_counter: ds 1
y_pos:	    ds 1
x_pos:	    ds 1
fill_val:   ds 1


    
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
	movff	fill_val, LATD
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
	movlw	01000000B	; last 6 are the coordinate
	addwf	y_pos, W, A	; add current y position to instruction for address 0
	movwf	LATD, A
	call	GLCD_write_i
	bsf	LATB, RS, A
	bsf	LATB, RW_DI, A
	return
	
GLCD_set_x:	; set page to x_pos
	bcf	LATB, RS, A
	bcf	LATB, RW_DI, A
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
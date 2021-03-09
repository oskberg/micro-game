#include <xc.inc>

; ====== DELAY ROUTINES ======
;    This file contains delay routines
;    Taken from Simple1 
;    Need to reference properly... TODO
   
global	delay_ms, delay_x4us, delay, long_delay, delay_key_press

extrn	button_press
extrn	inc_player_y
    
psect	udata_acs   ; named variables in access ram
cnt_l:		ds 1   ; reserve 1 byte for variable LCD_cnt_l
cnt_h:		ds 1   ; reserve 1 byte for variable LCD_cnt_h
cnt_ms:		ds 1   ; reserve 1 byte for ms counter
cnt_x10ms:	ds 1
tmp:		ds 1   ; reserve 1 byte for temporary use
counter:	ds 1   ; reserve 1 byte for counting through nessage
counter_pm:	ds 1   ; reserve 1 byte for counting through nessage
shift_counter:	ds 1	;reserve 1 byte for shifting cursor
input:		ds 1
	up	equ	'2'
	down	equ	'8'

	
psect	delay_code,class=CODE
; ** a few delay routines below here as LCD timing can be quite critical ****
long_delay:
	movlw	0xFF
	call	delay_ms
	movlw	0xFF
	call	delay_ms
	movlw	0xFF
	call	delay_ms
	return
    
delay_ms:		    ; delay given in ms in W
	movwf	cnt_ms, A
lcdlp2:	movlw	250	    ; 1 ms delay
	call	delay_x4us	
	decfsz	cnt_ms, A
	bra	lcdlp2
	return
    
delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	cnt_l, A	; now need to multiply by 16
	swapf   cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	cnt_l, W, A ; move low nibble to W
	movwf	cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	delay
	return

delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1:	decf 	cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return


delay_key_press:	; delay routine that checks for a key press every 10ms
			; and is in the loop for a total of w * 10ms
	movwf	cnt_x10ms, A	; times to go round 10ms loop
delay_x10ms:
	call	button_press	; check for button press
	movwf	input, A	; store return in input
	movlw	up
	cpfseq	input, A	; check if key press was up
	bra	check_if_down	; if not check for down
;	call	move_player_up	; move player up
	call	inc_player_y
	bra	delay_x10ms_2	; continue loop
check_if_down:
	movlw	down
	cpfseq	input, A	; check if key press was down
	bra	delay_x10ms_2	; if not continue loop
;	call	move_player_down    ; move player down
	call	inc_player_y
delay_x10ms_2:			; continue loop
	movlw	0x0A
	call	delay_ms	; 10ms delay
	decfsz	cnt_x10ms, A	; check if # loops = w
	bra	delay_x10ms	; loop

	return
	
	
    end
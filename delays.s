#include <xc.inc>

    ; ====== COMMENTS ======
;    This file contains delay routines
;    Taken from Simple1 
;    Need to reference properly... TODO
;    Also delay routines which wait for a specific key press to continue
 
; ====== END OF COMMENTS ======


; ====== IMPORTS/EXPORTS ======
    
; From file keyboard.s
extrn	button_press
    
; From file game.s
extrn	move_player_up, move_player_down
    
; From file menu.s
extrn	write_instructions_menu, draw_menu
    
; From file glcd.s
extrn	GLCD_fill_0
    
; Exports
global	delay_ms, delay_x4us, delay, long_delay, delay_key_press, delay_menu
    
; ====== SETUP ======  
psect	udata_acs	; variables delcaration in access ram
cnt_l:		ds 1	
cnt_h:		ds 1
cnt_ms:		ds 1
cnt_x10ms:	ds 1
tmp:		ds 1
counter:	ds 1
counter_pm:	ds 1
shift_counter:	ds 1
input:		ds 1
    
	; constant declarations 
	up	equ	'2'	; key press to go up 
	down	equ	'8'	; key press to go down
	play	equ	'A'	; key press for menu --> play
	instructions	equ	'B'	; key press for menu --> instructions

	
; ====== DELAY ROUTINES ======	
psect	delay_code,class=CODE

long_delay:			; large delay to pause on a screen
	movlw	0xFF
	call	delay_ms
	movlw	0xFF
	call	delay_ms
	movlw	0xFF
	call	delay_ms
	return
    
delay_ms:			; delay given in ms in W
	movwf	cnt_ms, A
lcdlp2:	movlw	250		; 1 ms delay
	call	delay_x4us	
	decfsz	cnt_ms, A
	bra	lcdlp2
	return
    
delay_x4us:			; delay given in chunks of 4 microsecond in W
	movwf	cnt_l, A	; now need to multiply by 16
	swapf   cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	cnt_l, W, A	; move low nibble to W
	movwf	cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	cnt_l, F, A	; keep high nibble in LCD_cnt_l
	call	delay
	return

delay:				; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1:	decf 	cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return


delay_key_press:	; delay routine that checks for a key press every 20ms
			; and is in the loop for a total of w * 20ms
	movwf	cnt_x10ms, A	; times to go round 10ms loop
delay_x10ms:
	call	button_press	; check for button press
	movwf	input, A	; store return in input
	movlw	up
	cpfseq	input, A	; check if key press was up
	bra	check_if_down	; if not check for down
	call	move_player_up	; move player up
	bra	delay_x10ms_2	; continue loop
check_if_down:
	movlw	down
	cpfseq	input, A	; check if key press was down
	bra	delay_x10ms_2	; if not continue loop
	call	move_player_down    ; move player down
delay_x10ms_2:			; continue loop
	movlw	0x14
	call	delay_ms	; 20ms delay
	decfsz	cnt_x10ms, A	; check if # loops = w
	bra	delay_x10ms	; loop

	return
	
delay_menu:	; delay routine which waits for valid input to move from menu
	call	button_press	; takes input press
	movwf	input, A	; stores in input
	movlw	play
	cpfseq	input, A	; checks if play button pressed
	bra	instructions_select	; if not check instruction key
	retlw	play		; return play
instructions_select:
	movlw	instructions
	cpfseq	input, A	; check if options button pressed
	bra	delay_menu	; if not loop until valid input
	call	write_instructions_menu	; display instructios menu
	movlw	0x01
	call	long_delay	; pause on menu
	call	GLCD_fill_0	; clear screen
	call	draw_menu	; draw start menu
	bra	delay_menu	; wait for new key press
    
end	; end of file
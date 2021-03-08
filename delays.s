#include <xc.inc>

; ====== DELAY ROUTINES ======
;    Taken from Simple1 
;    Need to reference properly... TODO
   
global	delay_ms, delay_x4us, delay, long_delay
    
psect	udata_acs   ; named variables in access ram
cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
cnt_ms:	ds 1   ; reserve 1 byte for ms counter
tmp:	ds 1   ; reserve 1 byte for temporary use
counter:	ds 1   ; reserve 1 byte for counting through nessage
counter_pm:	ds 1   ; reserve 1 byte for counting through nessage
shift_counter:	ds 1	;reserve 1 byte for shifting cursor


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


    end
#include <xc.inc>

; ====== COMMENTS ======
;    This file contains subroutines relating to displaying the score
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
; From file maths.s    
extrn	dec_1, dec_2, dec_3, dec_4
extrn	binary_to_digits
    
; From file menu.s    
extrn	_0, _1, _2, _3, _4, _5, _6, _7, _8, _9
    
; From file game.s      
extrn	score
    
; Exports    
global	setup_score, write_digit_1, write_digit_2, write_digit_3, write_digit_4
       
; ====== VARIABLE DECLARATIONS ======
psect	udata_acs   ; reserve data space in access ram
temp_num:    ds 1    
    
; =========================
; ====== SUBROUTINES ======
; =========================     
psect	leaderboard_code,class=CODE    
setup_score:	    ; puts the value of score in decimal digits
    movf    score, W, A		; score -> w
    call    binary_to_digits	; w -> dec_1/2/3/4
    return
    
write_digit_1: ; check what digit it is then write that digit
    movf    dec_1, W, A
    call    check_0
    movf    dec_1, W, A
    call    check_1
    movf    dec_1, W, A
    call    check_2
    movf    dec_1, W, A
    call    check_3
    movf    dec_1, W, A
    call    check_4
    movf    dec_1, W, A
    call    check_5
    movf    dec_1, W, A
    call    check_6
    movf    dec_1, W, A
    call    check_7
    movf    dec_1, W, A
    call    check_8
    movf    dec_1, W, A
    call    check_9
    return
    
write_digit_2:		    ; check what digit it is then write that digit
    movf    dec_2, W, A
    call    check_0
    movf    dec_2, W, A
    call    check_1
    movf    dec_2, W, A
    call    check_2
    movf    dec_2, W, A
    call    check_3
    movf    dec_2, W, A
    call    check_4
    movf    dec_2, W, A
    call    check_5
    movf    dec_2, W, A
    call    check_6
    movf    dec_2, W, A
    call    check_7
    movf    dec_2, W, A
    call    check_8
    movf    dec_2, W, A
    call    check_9
    return    
    
write_digit_3:		    ; check what digit it is then write that digit
    movf    dec_3, W, A
    call    check_0
    movf    dec_3, W, A
    call    check_1
    movf    dec_3, W, A
    call    check_2
    movf    dec_3, W, A
    call    check_3
    movf    dec_3, W, A
    call    check_4
    movf    dec_3, W, A
    call    check_5
    movf    dec_3, W, A
    call    check_6
    movf    dec_3, W, A
    call    check_7
    movf    dec_3, W, A
    call    check_8
    movf    dec_3, W, A
    call    check_9
    return
    
write_digit_4:			; check what digit it is then write that digit
    movf    dec_4, W, A
    call    check_0
    movf    dec_4, W, A
    call    check_1
    movf    dec_4, W, A
    call    check_2
    movf    dec_4, W, A
    call    check_3
    movf    dec_4, W, A
    call    check_4
    movf    dec_4, W, A
    call    check_5
    movf    dec_4, W, A
    call    check_6
    movf    dec_4, W, A
    call    check_7
    movf    dec_4, W, A
    call    check_8
    movf    dec_4, W, A
    call    check_9
    return

check_0:    ; check if 0
    movwf   temp_num, A
    movlw   0x00
    cpfseq  temp_num, A	   
    return		    
    call    _0		    ; write 0
    return
    
check_1:    ; check if = 1
    movwf   temp_num, A
    movlw   0x01
    cpfseq  temp_num, A
    return
    call    _1		    ; write 1
    return
    
check_2:    ; check if = 2
    movwf   temp_num, A
    movlw   0x02
    cpfseq  temp_num, A
    return
    call    _2		    ; write 2
    return
    
    
check_3:    ; check if = 3
    movwf   temp_num, A
    movlw   0x03
    cpfseq  temp_num, A
    return
    call    _3		    ; write 3
    return
    
check_4:    ; check if = 4
    movwf   temp_num, A
    movlw   0x04
    cpfseq  temp_num, A
    return
    call    _4		    ; write 4
    return
        
check_5:    ; check if = 5
    movwf   temp_num, A
    movlw   0x05
    cpfseq  temp_num, A
    return
    call    _5		    ; write 5
    return
    
check_6:    ; check if = 6
    movwf   temp_num, A
    movlw   0x06
    cpfseq  temp_num, A
    return
    call    _6		    ; write 6
    return
    
check_7:    ; check if = 7
    movwf   temp_num, A
    movlw   0x07
    cpfseq  temp_num, A
    return
    call    _7		    ; write 7
    return
    
check_8:    ; check if = 8
    movwf   temp_num, A
    movlw   0x08
    cpfseq  temp_num, A
    return
    call    _8		    ; write 8
    return
    
check_9:    ; check if = 9
    movwf   temp_num, A
    movlw   0x09
    cpfseq  temp_num, A
    return
    call    _9		    ; write 9
    return
    
; end of file
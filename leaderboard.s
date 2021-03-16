#include <xc.inc>

; ====== COMMENTS ======
;    This file contains subroutines relating specifically to the game
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
global	setup_score, write_digit_1, write_digit_2, write_digit_3, write_digit_4
    
extrn	GLCD_set_x, GLCD_set_y, GLCD_write_d, GLCD_left, GLCD_remove_section, GLCD_right
extrn	x_pos, y_pos, score
extrn	dec_1, dec_2, dec_3, dec_4, hex_to_dec
extrn	mul_16_l_2, mul_16_h_2, score_to_digits
extrn	_0, _1, _2, _3, _4, _5, _6, _7, _8, _9

    
; ====== VARIABLE DECLARATIONS ======
psect	udata_acs   ; reserve data space in access ram
temp_num:    ds 1    ; reserve one byte for a counter variable
    
psect	leaderboard_code,class=CODE    
setup_score:
;    movlw   0x00
;    movwf   mul_16_h_2, A
;    movf    score, W, A
;    movwf   mul_16_l_2, A
    call    score_to_digits
    return
    
write_digit_1: 
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
    
write_digit_2: 
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
    
write_digit_3: 
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
    
write_digit_4: 
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

check_0:
    movwf   temp_num, A
    movlw   0x00
    cpfseq  temp_num, A
    return
    call    _0
    return
    
check_1:
    movwf   temp_num, A
    movlw   0x01
    cpfseq  temp_num, A
    return
    call    _1
    return
    
check_2:
    movwf   temp_num, A
    movlw   0x02
    cpfseq  temp_num, A
    return
    call    _2
    return
    
    
check_3:
    movwf   temp_num, A
    movlw   0x03
    cpfseq  temp_num, A
    return
    call    _3
    return
    
check_4:
    movwf   temp_num, A
    movlw   0x04
    cpfseq  temp_num, A
    return
    call    _4
    return
        
check_5:
    movwf   temp_num, A
    movlw   0x05
    cpfseq  temp_num, A
    return
    call    _5
    return
    
check_6:
    movwf   temp_num, A
    movlw   0x06
    cpfseq  temp_num, A
    return
    call    _6
    return
    
check_7:
    movwf   temp_num, A
    movlw   0x07
    cpfseq  temp_num, A
    return
    call    _7
    return
    
check_8:
    movwf   temp_num, A
    movlw   0x08
    cpfseq  temp_num, A
    return
    call    _8
    return
    
check_9:
    movwf   temp_num, A
    movlw   0x09
    cpfseq  temp_num, A
    return
    call    _9
    return
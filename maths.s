#include <xc.inc>
    
global  prod_1, prod_2, prod_3, prod_4, dec_1, dec_2, dec_3, dec_4
global	score_to_digits
    
extrn	score
    
psect udata_acs
mul_8:	    ds 1
mul_16_h:   ds 1
mul_16_l:   ds 1
mul_16_h_2: ds 1
mul_16_l_2: ds 1
mul_24_l:   ds 1
mul_24_m:   ds 1
mul_24_h:   ds 1
    
prod_4:	    ds 1
prod_3:	    ds 1
prod_2:	    ds 1
prod_1:	    ds 1	    ; reserve space for multiplication numbers

temp_1:	    ds 1
temp_2:	    ds 1
temp_3:	    ds 1
temp_0:	    ds 1
temp_00:    ds 1
    
dec_1:	    ds 1
dec_2:	    ds 1
dec_3:	    ds 1
dec_4:	    ds 1

k:	    ds 1
    k_val equ	0x418A

psect	maths_code,class=CODE

;test_mul:
;	movlw   32
;	mullw	69
;	movff	PRODL, mul_1, A
;	movff	PRODH, mul_2, A
;	return
score_to_digits:
    movf    score, W, A
    movwf   temp_1, A
    movlw   0x00
    movwf   dec_1, A
    movlw   0x00
    movwf   dec_2, A
    movlw   0x00
    movwf   dec_3, A
    movlw   0x00
    movwf   dec_4, A
;calc_digit_1:
;    movlw   1000
;    cpfsgt  temp_1, A
;    bra	    check_1000
;    incf    dec_1, F, A
;    movlw   1000
;    subwf   temp_1, F, A
;    bra	    calc_digit_1
;check_1000:
;    movlw   1000
;    cpfseq  temp_1, A
;    bra	    calc_digit_2
;    incf    dec_1, F, A
;    movlw   0x00
;    movwf   dec_2, A
;    movlw   0x00
;    movwf   dec_3, A
;    movlw   0x00
;    movwf   dec_4, A
;    return
calc_digit_2: 
    movlw   100
    cpfsgt  temp_1, A
    bra	    check_100
    incf    dec_2, F, A
    movlw   100
    subwf   temp_1, F, A
    bra	    calc_digit_2
check_100:
    movlw   100
    cpfseq  temp_1, A
    bra	    calc_digit_3
    incf    dec_2, F, A
    movlw   0x00
    movwf   dec_3, A
    movlw   0x00
    movwf   dec_4, A
    return
calc_digit_3:
    movlw   10
    cpfsgt  temp_1, A
    bra	    check_10
    incf    dec_3, F, A
    movlw   10
    subwf   temp_1, F, A
    bra	    calc_digit_3
check_10:
    movlw   10
    cpfseq  temp_1, A
    bra	    calc_digit_4
    incf    dec_3, F, A
    movlw   0x00
    movwf   dec_4, A
    return
calc_digit_4:
    movlw   1
    cpfsgt  temp_1, A
    bra	    check_1
    incf    dec_4, F, A
    movlw   1
    subwf   temp_1, F, A
    bra	    calc_digit_4
check_1:
    movlw   1
    cpfseq  temp_1, A
    return
    incf    dec_4, F, A
    return
    
hex_to_dec: ; converts hex number stored in hex variables
	; 1 - multiply x by k, take most signigicant bit
	; 2-4 multiply x by 10 (0x0a) and take most significant bit
	movlw	high(k_val)
	movwf	mul_16_h, A
	movlw	low(k_val)
	movwf	mul_16_l, A
	
	; step 1
	call	mul_16_16	    ; multiply x by k
	
	movff	prod_4, dec_1	    ; take highest byte
	
	movff	prod_1, mul_24_l ; prepare lower 3 bytes for multiplication by 10
	movff	prod_2, mul_24_m
	movff	prod_3, mul_24_h
	
	movlw	0x0A
	movwf	mul_8, A	; prepare multiplication by 10
	
	; step 2
	call	mul_8_24	; multiply by 10 
	
	movff	prod_4, dec_2
	
	movff	prod_1, mul_24_l	; prepare lower 3 bytes for multiplication by 10
	movff	prod_2, mul_24_m
	movff	prod_3, mul_24_h
	
	movlw	0x0A
	movwf	mul_8, A
	
	; step 3
	call	mul_8_24

	movff	prod_4, dec_3	    ; take highest byte
	
	movff	prod_1, mul_24_l	; prepare lower 3 bytes for multiplication by 10
	movff	prod_2, mul_24_m
	movff	prod_3, mul_24_h
	
	movlw	0x0A
	movwf	mul_8, A
	
	;step 4
	call	mul_8_24
	
	movff	prod_4, dec_4	    ; take highest byte
	
	return 0
	
mul_8_16:
	movf	mul_16_l, W, A   ; low 16 bit
	mulwf	mul_8, A	    ; multiply by the 8 bit
	
	movff	PRODL, prod_1	    ; low return is known
	movff	PRODH, temp_0	    ; store mid bit in temp
	
	movf	mul_16_h, W, A  ; multiply high bits
	mulwf	mul_8, A
	
	movf	PRODL, W, A	    ; get temp value
	addwf	temp_0, W, A	    ; add mid bits
	movwf	prod_2, A
	
	movlw	0x00		    ; add with carry 
	addwfc	PRODH, W, A
	
	movwf	prod_3, A	
	return
	
mul_16_16:
	movff	mul_16_h_2, mul_8   ; multiply high first
	call	mul_8_16
	
	movff	prod_1, temp_1	; store entire product in temps
	movff	prod_2, temp_2
	movff	prod_3, temp_3
	
	movff	mul_16_l_2, mul_8   ; multiply low second to keep prod 1
	call	mul_8_16
	
	movf	temp_1, W, A
	addwf	prod_2, F, A
	
	movwf	temp_2, W, A
	addwfc	prod_3, F, A
	
	movlw	0x00
	addwfc	temp_3, W, A
	movwf	prod_4, A
	
	return

mul_8_24:
    	movf	mul_24_l, W, A   ; low 24 bit
	mulwf	mul_8, A	    ; multiply by the 8 bit
	
	movff	PRODL, prod_1	    ; low return is known
	movff	PRODH, temp_0	    ; store low mid bit in temp
	
	movf	mul_24_m, W, A  ; multiply mid bits
	mulwf	mul_8, A
	
	movf	PRODL, W, A	    ; get temp value
	addwf	temp_0, W, A	    ; add mid bits
	movwf	prod_2, A
	movff	PRODH, temp_0	    ; store low mid bit in temp

	movf	mul_24_h, W, A  ; multiply mid bits
	mulwf	mul_8, A
	
	movf	PRODL, W, A	    ; get temp value
	addwf	temp_0, W, A	    ; add mid bits
	movwf	prod_3, A
	
	movlw	0x00		    ; add with carry 
	addwfc	PRODH, W, A
	
	movwf	prod_4, A	
	return

	
testing_loop:
;;	call	test_mul
; 	movlw	0x0
;	movwf	mul_8, A
;	movlw	high(0x0000)
;	movwf	mul_16_h, A
;	movlw	low(0x0000)
;	movwf	mul_16_l, A
;	call	mul_8_16
;	movlw	0x00
;	movf	prod_1, W,A
;	movf	prod_2, W,A
;	movf	prod_3, W,A	

;	movlw	high(0xabfe)
;	movwf	mul_16_h_2, A
;	movlw	low(0xabfe)
;	movwf	mul_16_l_2, A
;	movlw	high(0x27ad)
;	movwf	mul_16_h, A
;	movlw	low(0x27ad)
;	movwf	mul_16_l, A	
    
    	movlw	0xab
	movwf	mul_24_h, A
	movlw	0xfe
	movwf	mul_24_m, A
	movlw	0xdc
	movwf	mul_24_l, A
	movlw	0xef
	movwf	mul_8, A	
	
	call	mul_8_24
	return



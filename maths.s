#include <xc.inc>
    
; ====== COMMENTS ======
;    this file subroutines to convert a binary value to a decimal value and put
;    the digits into dec_1/2/3/4. 
    
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
; Exports 
global  dec_1, dec_2, dec_3, dec_4
global	binary_to_digits
       
; ====== SETUP ======      
psect udata_acs	    ; varaibles declared in Access RAM
temp_1:	    ds 1    
dec_1:	    ds 1
dec_2:	    ds 1
dec_3:	    ds 1
dec_4:	    ds 1
    
; =========================
; ====== SUBROUTINES ======
; =========================      

psect	maths_code,class=CODE

binary_to_digits:	; converts binary value in w to decimal digits
    movwf   temp_1, A
    movlw   0x00
    movwf   dec_1, A
    movlw   0x00
    movwf   dec_2, A
    movlw   0x00
    movwf   dec_3, A
    movlw   0x00
    movwf   dec_4, A		    ; initalise digits to 0
;calc_digit_1:			    ; digit 1 can't be reached as currenty 
;    movlw   1000		    ; 1 byte number
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
calc_digit_2:			    ; calculated second digit
    movlw   100
    cpfsgt  temp_1, A		    ; check if > 100
    bra	    check_100		    ; if not, check if = 100
    incf    dec_2, F, A		    ; subtract 100 and inc digit 2
    movlw   100
    subwf   temp_1, F, A
    bra	    calc_digit_2	    ; repeat
check_100:
    movlw   100
    cpfseq  temp_1, A		    ; check if = 100
    bra	    calc_digit_3	    ; if < start on next digit
    incf    dec_2, F, A		    ; incrament digit 2
    movlw   0x00
    movwf   dec_3, A
    movlw   0x00
    movwf   dec_4, A		    ; set digit 3 & 4 to 0
    return			    ; return
calc_digit_3:
    movlw   10
    cpfsgt  temp_1, A		    ; check if < 10
    bra	    check_10		    ; if <, check if = 10
    incf    dec_3, F, A		    ; incrament digit 3
    movlw   10
    subwf   temp_1, F, A	    ; subtract 10 from temp_1
    bra	    calc_digit_3	    ; repeat
check_10:
    movlw   10
    cpfseq  temp_1, A		    ; check if = 10
    bra	    calc_digit_4	    ; if not calculate last digit
    incf    dec_3, F, A		    ; incrament digit 3
    movlw   0x00
    movwf   dec_4, A		    ; set digit 4 to 0
    return			    ; return
calc_digit_4:
    movlw   1
    cpfsgt  temp_1, A		    ; check if < 1
    bra	    check_1		    ; check if = 1
    incf    dec_4, F, A		    ; incrament digit 4
    movlw   1
    subwf   temp_1, F, A	    ; subtract 1
    bra	    calc_digit_4	    ; repeat
check_1:
    movlw   1	
    cpfseq  temp_1, A		    ; check if = 1
    return			    ; return
    incf    dec_4, F, A		    ; incrament 1
    return			    ; return
    
; end of file 
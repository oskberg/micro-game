#include <xc.inc>

; ====== COMMENTS ======
;    this file subroutines to write letters to the GLCD
;    it also contains routines to draw the menus
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
extrn	GLCD_set_x, GLCD_set_y, GLCD_write_d, GLCD_left, GLCD_remove_section, GLCD_right
extrn	x_pos, y_pos
extrn	delay_ms, delay_x4us, delay, long_delay, delay_key_press, delay_menu
extrn	GLCD_setup, GLCD_fill_0, GLCD_fill_1
extrn	init_player, draw_player, inc_player_y


global	draw_menu, menu_plus_options, draw_end_screen
    
; =========================
; ====== SUBROUTINES ======
; =========================
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
key:	    ds 1
	play_key	equ	'A'
	options_key	equ	'B'
	leader_key	equ	'C'
psect	menu_code, class=CODE	 

draw_menu:  ; draws the main menu
   ; writes "main menu" to top line
   call	    GLCD_left
   movlw    0x00
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    M
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    M
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GLCD_set_x
   call	    U
   
   ; Writes "press A to start" to line 2
   call	    GLCD_left
   movlw    0x02
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    P
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GLCD_set_x
   call	    T
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x38
   movwf    y_pos, A
   call	    T
   
   ; Writes "press B to view options" to lines 4 & 5
   call	    GLCD_left
   movlw    0x04
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    P
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    B_
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GLCD_set_x
   call	    T
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    V
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    W_
   movlw    0x38
   movwf    y_pos, A
   call	    GAP

   ; moves to line 5
   call	    GLCD_left
   movlw    0x05
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    P
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   
   ; Writes "press C to view leaderboard" to lines 6 & 7
   call	    GLCD_left
   movlw    0x06
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    P
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    C_
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GLCD_set_x
   call	    T
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    V
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    W_
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP

   ; moves to line 7
   call	    GLCD_left
   movlw    0x07
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    L
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    D
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    B_
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GLCD_set_x
   call	    A_
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    D
   return

draw_end_screen:
    ; writes "main menu" to top line
   call	    GLCD_left
   movlw    0x00
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    Y
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    U
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    L
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E

   ; display 'score: x'
   movlw    0x03
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    C_
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    COLON
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    _7
   
;   call	    GLCD_right
;   movlw    0x00
;   movwf    y_pos, A
;   call	    GLCD_set_y
;   call	    GLCD_set_x
;   call	    GAP
;   movlw    0x08
;   movwf    y_pos, A
;   call	    GLCD_set_y
;   call	    _7
   return
   
M:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111110B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00001000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000010B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111110B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return

E:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
N:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00001000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return

U:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
 
A_:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01110000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00101000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00101000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01110000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
I:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
P:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00001000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
R:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00110100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01001000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
 
S:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01011100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01110100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
T:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return

O:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00111000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00111000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
 
B_:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00101000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
V:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00011100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00011100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
W_:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
L:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return

D:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00111000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
  
F_:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
 
C_:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00111000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
   
Y:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00001000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01110000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01110000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00001000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
COLON:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   0100100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return

_7:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00001100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
GAP:
    movlw   0x01
    call    GLCD_remove_section
    return
    
menu_plus_options:
	call	draw_menu	; displays menu
	call	delay_menu	; waits for valid player input
	movwf	key, A		; move input to key
	movlw	play_key
	cpfseq	key, A		; checks if player selected play
	bra	options		; if not check next option
;	call	run_game	; run game
	return			; restart
options:
	movlw	options_key
	cpfseq	key, A		; checks if player selected options
	bra	leader		; if not go to leaderboard
	call	open_options	; open options menu
	return			; restart
leader:
	call	open_leader	; open leaderboard
	return			; restart

open_options:
	call	GLCD_fill_0
	movlw	10
	call	long_delay
	return
	
open_leader:
	call	GLCD_fill_0
	call	draw_player
	movlw	10
	call	long_delay
	return
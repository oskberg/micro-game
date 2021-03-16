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
extrn	setup_score, write_digit_1, write_digit_2, write_digit_3, write_digit_4
    

global	draw_menu, menu_plus_options, draw_end_screen, draw_victory_screen
global	_0, _1, _2, _3, _4, _5, _6, _7, _8, _9
global	draw_level_1_screen, draw_level_2_screen, draw_level_3_screen
global	write_instructions_menu
    
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
   
   ; Writes "press B to see how to play" to lines 4 & 5
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
   call	    I
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    U
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    C_
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   return

draw_end_screen:
   call	    setup_score
    ; writes "game over" to top line
   call	    GLCD_left
   movlw    0x00
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    G
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    M
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    V
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R

   ; display 'score: x'
   call	    GLCD_left
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
   call	    write_digit_1
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    write_digit_2
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    write_digit_3
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    write_digit_4
   return
   
draw_victory_screen:  ; draws the main menu
   call	    setup_score
   ; writes "main menu" to top line
   call	    GLCD_left
   movlw    0x00
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    C_
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    G
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    U
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GLCD_set_x
   call	    L
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
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
   
   ; Writes "YOU WIN!" to line 2
   call	    GLCD_left
   movlw    0x02
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
   call	    W_
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    EXC
   
   ; Writes "YOUR SCORE WAS: XXXX" to lines 4 & 5
   call	    GLCD_left
   movlw    0x04
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
   call	    R
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    C_
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   call	    GLCD_right
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    W_
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    COLON
   
   call	    GLCD_left
   movlw    0x06
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    write_digit_1
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    write_digit_2
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    write_digit_3
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    write_digit_4
   
   return
   
draw_level:
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
   call	    V
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    L
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   return
 
draw_level_1_screen:  ; draws the main menu
   ; writes "main menu" to top line
   call	    GLCD_left
   movlw    0x03
   movwf    x_pos, A
   call	    GLCD_set_x
   call	    draw_level
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    _1
   return
   
draw_level_2_screen:  ; draws the main menu
   ; writes "main menu" to top line
   call	    GLCD_left
   movlw    0x03
   movwf    x_pos, A
   call	    GLCD_set_x
   call	    draw_level
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    _2
   return   
   
draw_level_3_screen:  ; draws the main menu
   ; writes "main menu" to top line
   call	    GLCD_left
   movlw    0x03
   movwf    x_pos, A
   call	    GLCD_set_x
   call	    draw_level
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    _3
   return     
   
write_instructions_menu:
   call	    GLCD_fill_0
   ; writes, "Move up or down"
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
   call	    O
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    V
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    U
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    P
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    D
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    W_
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   
    ; writes, "to avoid walls"
   call	    GLCD_left
   movlw    0x01
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
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
   call	    A_
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    V
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    D
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    W_
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    L
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    L
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   
    ; writes, "2 to move up"
   call	    GLCD_left
   movlw    0x02
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    _2
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
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
   call	    O
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    V
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    U
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    P
   call	    GLCD_left
   
   ; writes, "8 to move down" 
   movlw    0x03
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    _8
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
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
   call	    O
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    V
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    D
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    W_ 
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   
    ; writes, "there's 3 levels"
   call	    GLCD_left
   movlw    0x05
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    H
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
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
   call	    APO
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    _3
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    L
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    V
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    L
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
   
    ; writes, "of increasing"
   call	    GLCD_left
   movlw    0x06
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    O
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    F_
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    GAP
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    N
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    C_
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    R
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    E
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    A_
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    S
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
   call	    G
   
    ; writes, "difficulty"
   call	    GLCD_left
   movlw    0x07
   movwf    x_pos, A
   call	    GLCD_set_x
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    D
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x10
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    F_
   movlw    0x18
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    F_
   movlw    0x20
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    I
   movlw    0x28
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    C_
   movlw    0x30
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    U
   movlw    0x38
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    L
   call	    GLCD_right
   movlw    0x00
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    T
   movlw    0x08
   movwf    y_pos, A
   call	    GLCD_set_y
   call	    Y
   return
    
M:
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
    movlw   00001000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
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
    
G:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
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
    
H:    
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00010000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
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
    
EXC:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01011100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01011100B
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
    
APO:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00001100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00001100B
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

_1:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return  
    
_2:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01110100B
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
    movlw   01011100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
_3:
    movlw   00000000B
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
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
_4:
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00110000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00101000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00100000B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
_5:
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
    movlw   00100100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
_6:
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
    movlw   01110100B
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
    movlw   00000100B
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
    return  
    
_8:
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
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
_9:
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
    movlw   01111100B
    movwf   LATD, A
    call    GLCD_write_d
    movlw   00000000B
    movwf   LATD, A
    call    GLCD_write_d
    return
    
_0:
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
    movlw   01111100B
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
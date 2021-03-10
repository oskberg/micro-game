#include <xc.inc>

; ====== COMMENTS ======
;    this file subroutines to write letters to the GLCD
;    it also contains routines to draw the menus
; ====== END OF COMMENTS ======

; ====== IMPORTS/EXPORTS ======
extrn	GLCD_set_x, GLCD_set_y, GLCD_write_d, GLCD_left, GLCD_remove_section, GLCD_right
extrn	x_pos, y_pos

global	draw_menu
    
; =========================
; ====== SUBROUTINES ======
; =========================
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable

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

GAP:
    movlw   0x01
    call    GLCD_remove_section
    return
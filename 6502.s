; % defines a binary value
; $ defines a Hexadecimal value

; # declares a constant

;6502 notable registers: A (accumulator), X, Y 
; PC program counter, register the next operation/instruction
; PC uses 16 bit address
; some operations dont need addressing ( implicit)
; some needs only 1 byte of adress (zero pages)
; some needs the full address

;P Process status - has 8 bits



inc $00 ; increments the value on $00 adress
inx ; increments x
iny ; increments y
dec $00 ; decrements the value on $00 address
dex ; decrements x
dey ;decrements y

ldx #10 ; loads the value of 10 on X
ldy %01001100 ; loads the binary value 01001100 on y

lda $00 ; loads the value stored on the position $0000 on the acumulator
clc     ; Clear carry flag - clear the accumulator carry (9th bit)
adc $01 ; Add with Carry - adds the accumulator with the value on adress $01

;if the carry is flaged, its possible to runthe code
lda #0
adc #0
sta $03 ; adds the carry to the position 03

stx $00 ; stores the value of x on $00 address
sty $01 ; stores the value of y on $01 address
sta $02 ; stores the value of the accumulator on $02 address



inc $00 ;
inc $0300 ; 

cmp $00 ; compares one value with the value in the accumulator
; returns carry_flag = 1 when the acumulator is greater or equal, carry_flag = 0 else
bcc sub_rotine; Changes the PC value for the sub_routine address
jsr ;



;immediate addressing - # follow by the value (#$E8) - only works with single bytes
;ZeroPage Addressing - adding a 8bit operand to the instruction (stx $00) , operates faster
;Absolute Adressing - adding a 16 bit operando to the instruction (stx $0300), acess all 64k or data
;Implicit Addressing - doesn't use address (inx)


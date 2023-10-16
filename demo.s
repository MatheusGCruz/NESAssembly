.segment "HEADER"
  ; .byte "NES", $1A      ; iNES header identifier
  .byte $4E, $45, $53, $1A
  .byte 2               ; 2x 16KB PRG code
  .byte 1               ; 1x  8KB CHR data
  .byte $01, $00        ; mapper 0, vertical mirroring

.segment "VECTORS"
  ;; When an NMI happens (once per frame if enabled) the label nmi:
  .addr nmi
  ;; When the processor first turns on or is reset, it will jump to the label reset:
  .addr reset
  ;; External interrupt IRQ (unused)
  .addr 0

; "nes" linker config requires a STARTUP section, even if it's empty
.segment "STARTUP"

; Main code segment for the program
.segment "CODE"

reset:
  sei		; disable IRQs
  cld		; disable decimal mode
  ldx #$40
  stx $4017	; disable APU frame IRQ
  ldx #$ff 	; Set up stack
  txs		;  .
  inx		; now X = 0
  stx $2000	; disable NMI
  stx $2001 	; disable rendering
  stx $4010 	; disable DMC IRQs

;; first wait for vblank to make sure PPU is ready
vblankwait1:
  bit $2002
  bpl vblankwait1

clear_memory:
  lda #$00
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne clear_memory

;; second wait for vblank, PPU is ready after this
vblankwait2:
  bit $2002
  bpl vblankwait2

main:
load_palettes:
  lda $2002
  lda #$3f
  sta $2006
  lda #$00
  sta $2006
  ldx #$00
@loop:
  lda palettes, x
  sta $2007
  inx
  cpx #$20
  bne @loop

enable_rendering:
  lda #%10000000	; Enable NMI
  sta $2000
  lda #%00010000	; Enable Sprites
  sta $2001

forever:
  jmp forever

nmi:
  ldx #$00 	; Set SPR-RAM address to 0
  stx $2003
@loop:	lda hello, x 	; Load the hello message into SPR-RAM
  sta $2004
  inx
  cpx #$32
  bne @loop
  rti

hello:
; Y position, byte location, pallete?, X position
  .byte $10, $00, $12, $10 	; Why do I need these here?
  .byte $6c, $00, $12, $6c
  .byte $6c, $01, $12, $76
  .byte $6c, $02, $12, $80
  .byte $6c, $03, $12, $8A
  .byte $6c, $04, $12, $94
  .byte $6c, $03, $12, $A0
  .byte $6c, $03, $12, $A8

palettes:
  ; Background Palette
  .byte $01, $02, $03, $04
  .byte $05, $06, $07, $08
  .byte $09, $0A, $0B, $0C
  .byte $0D, $0E, $0F, $00


  ; Sprite Palette
  .byte $0D, $0E, $0F, $00    
  .byte $09, $0A, $0B, $0C
  .byte $05, $06, $07, $08
  .byte $01, $02, $03, $04

; Character memory
.segment "CHARS"
;  .byte %00000000	; 0 (00)

  .byte %00111100	; 0 (00)
  .byte %01100110
  .byte %01001110
  .byte %01011010
  .byte %01011010
  .byte %01110010
  .byte %01100010
  .byte %00111100
  .byte $00, $00, $00, $00, $00, $00, $00, $00 ;added to upper(LSB)

  .byte %00001100	; 1 (00)
  .byte %00011100
  .byte %00111100
  .byte %01101100
  .byte %00001100
  .byte %00001100
  .byte %00001100
  .byte %01111110
  .byte $00, $00, $00, $00, $00, $00, $00, $00 ;added to upper(LSB)

  .byte %00111100 ; 2
  .byte %01100110
  .byte %00000110
  .byte %00001100
  .byte %00011000
  .byte %00110000
  .byte %01100000
  .byte %01111110
  .byte $00, $00, $00, $00, $00, $00, $00, $00 

  .byte %00011000 ;|
  .byte %00011000
  .byte %00011000
  .byte %00011000
  .byte %00011000
  .byte %00011000
  .byte %00011000
  .byte %00011000
  .byte %00011000
  .byte $00, $00, $00, $00, $00, $00, $00, $00 

  .byte %10111101 ; | || |
  .byte %10111101
  .byte %10111101
  .byte %10111101
  .byte %10111101
  .byte %10111101
  .byte %10111101
  .byte %10111101
  .byte %10111101
  .byte $00, $00, $00, $00, $00, $00, $00, $00 

  .byte %11000011	; H (0A)
  .byte %11000011
  .byte %11000011
  .byte %11000011
  .byte %11111111
  .byte %11000011
  .byte %11000011
  .byte %11000011
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %11111111	; E (0B)
  .byte %11111111
  .byte %11000000
  .byte %11111100
  .byte %11111100
  .byte %11000000
  .byte %11111111
  .byte %11111111
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %11000000	; L (0C)
  .byte %11000000
  .byte %11000000
  .byte %11000000
  .byte %11000000
  .byte %11000000
  .byte %11111111
  .byte %11111111
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %01111110	; O (0D)
  .byte %11100111
  .byte %11000011
  .byte %11000011
  .byte %11000011
  .byte %11000011
  .byte %11100111
  .byte %01111110
  .byte $00, $00, $00, $00, $00, $00, $00, $00

  .byte %11000011	; N (0E)
  .byte %11100011
  .byte %11110011
  .byte %11011011
  .byte %11011011
  .byte %11001111
  .byte %11000111
  .byte %11000011
  .byte $00, $00, $00, $00, $00, $00, $00, $00


; thanks to espozo/koitsu/neviksti for the init snes routine!
; this is the only one i've found that really seems to work.

.include "global.i"

.segment "CODE"

.proc InitializeSNES
  ; Register initialisation values, per official Nintendo documentation
  
  sei          ; Disable interrupts
  clc          ; Clear carry, used by XCE
  xce          ; Set 65816 native mode
  jmp :+       ; Needed to set K (bank of PC) properly if MODE 21 is ever used;
               ; see official SNES developers docs, "Programming Cautions"

: cld          ; Disable decimal mode
  phk          ; Push K (PC bank)
  plb          ; Pull B (data bank, i.e. data bank now equals PC bank)

  rep #$30     ; A=16, X/Y=16


  ; Note: this should correlate with the top of BSS in snes.cfg
  ldx #$1fff
  txs          ; Set X = $1fff (stack pointer)
  
  lda #$2100
  tad              ; temporarily move direct page to PPU I/O area
  
  sep #$20     ; A=8
  
  ; this fixes things somehow
  lda #$30
  sta $30
  stz $31
  stz $32
  stz $33
  
  lda #$80
  sta $00
  stz $01
  stz $02
  stz $03
  stz $04
  stz $05
  stz $06
  stz $07
  stz $08
  stz $09
  stz $0a
  stz $0b
  stz $0c
  stz $0d
  stz $0d
  stz $0e
  stz $0e
  stz $0f
  stz $0f
  stz $10
  stz $10
  stz $11
  stz $11
  stz $12
  stz $12
  stz $13               
  stz $13               
  stz $14
  stz $14
  lda #$80
  sta $15
  stz $16
  stz $17
  stz $1a
  stz $1b
  lda #$01
  sta $1b
  stz $1c
  stz $1c
  stz $1d
  stz $1d
  stz $1e       
  lda #$01
  sta $1e
  stz $1f
  stz $1f
  stz $20
  stz $20
  stz $21
  stz $23
  stz $24
  stz $25
  stz $26
  stz $27
  stz $28
  stz $29
  stz $2a
  stz $2b
  stz $2c
  stz $2d
  stz $2e
  stz $2f
  
  seta16
  lda #$4200
  tcd
  seta8
  
  stz $00
  lda #$ff
  sta $01
  stz $02
  stz $03
  stz $04
  stz $05
  stz $06
  stz $07
  stz $08
  stz $09
  stz $0a
  stz $0b
  stz $0c
  stz $0d
  
  ; Note: this should correlate with ZEROPAGE in snes.cfg
  seta16
  lda #$0000
  tcd          ; Set D = $0000 (direct page)
  seta8
  
;ClearVram
  LDA #$80
  STA $2115         ;Set VRAM port to word access
  LDX #$1809
  STX $4300         ;Set DMA mode to fixed source, WORD to $2118/9
  LDX #$0000
  STX $2116         ;Set VRAM port address to $0000
  LDX #.LOWORD(zero_fill_byte)
  STX $4302         ;Set source address to $xx:0000
  LDA #.BANKBYTE(zero_fill_byte)
  STA $4304         ;Set source bank
  LDX #$0000
  STX $4305         ;Set transfer size to 65536 bytes
  LDA #$01
  STA $420B         ;Initiate transfer

;ClearPalette
  STZ $2121
  LDX #$0100
ClearPaletteLoop:
  STZ $2122
  STZ $2122
  DEX
  BNE ClearPaletteLoop

  ;**** clear Sprite tables ********

  STZ $2102	;sprites initialized to be off the screen, palette 0, character 0
  STZ $2103
  LDX #$0080
  LDA #$F0

_Loop08:
  STA $2104	;set X = 240
  STA $2104	;set Y = 240
  STZ $2104	;set character = $00
  STZ $2104	;set priority=0, no flips
  DEX
  BNE _Loop08

  LDX #$0020

_Loop09:
  STZ $2104		;set size bit=0, x MSB = 0
  DEX
  BNE _Loop09

  ;**** clear SNES RAM ********

  STZ $2181		;set WRAM address to $000000
  STZ $2182
  STZ $2183

  LDX #$8008
  STX $4300         ;Set DMA mode to fixed source, BYTE to $2180
  LDX #.LOWORD(zero_fill_byte)
  STX $4302         ;Set source offset
  LDA #.BANKBYTE(zero_fill_byte)
  STA $4304         ;Set source bank
  LDX #$0000
  STX $4305         ;Set transfer size to 64KBytes (65536 bytes)
  LDA #$01
  STA $420B         ;Initiate transfer

  LDA #$01          ;now zero the next 64KB (i.e. 128KB total)
  STA $420B         ;Initiate transfer
  jmp reset

 zero_fill_byte:
  .byte $00
.endproc
.include "inc/snes.i"

; macros

; palette macro
.macro bgr cb,g,r
  .dw ((cb<<10)|(g<<5)|r)
.endm


; the code
.org $808000

reset:
  
  ; forced blank
  seta8
  lda #$8f
  sta PPUBRIGHT
  
  lda #$03
  sta BGMODE     ; mode 0 (four 2-bit BGs) with 8x8 tiles
  stz BGCHRADDR  ; bg planes 0-1 CHR at $0000

  lda #$4000 >> 13
  sta OBSEL      ; sprite CHR at $4000, sprites are 8x8 and 16x16

  lda #>$6000
  sta NTADDR+0   ; plane 0 nametable at $6000
  sta NTADDR+1   ; plane 1 nametable also at $6000
  
  lda #$FF
  sta BGSCROLLY+0  ; The PPU displays lines 1-224, so set scroll to
  sta BGSCROLLY+0  ; $FF so that the first displayed line is line 0
  
  
  
  ; copy palette
  seta8
  stz CGADDR  ; Seek to the start of CGRAM
  setaxy16
  lda #DMAMODE_CGDATA
  ldx #palette & $ffff
  ldy #palette_size-palette
  jsl ppu_copy
  
  ; copy font
  setaxy16
  lda #font & $ffff
  sta rle_cp_src
  jsl rle_copy_ram
  
  setaxy16
  stz PPUADDR
  
  lda #DMAMODE_PPUDATA
  ldx #rle_cp_dat & $ffff
  ldy #8192
  
  php
  setaxy16
  sta DMAMODE
  stx DMAADDR
  sty DMALEN
  seta8
  lda #rle_cp_dat >> 16
  sta DMAADDRBANK
  lda #%00000001
  sta COPYSTART
  plp
  
  setaxy16
  
 ;lda #$6000|NTXY(0,8)
  lda #$6000|((0)|((8)<<5))
  sta PPUADDR


  lda #fontnam & $ffff
  ldx #$100
  sta msg_ram
  jsr scrn_copy
  
  ;seta16
  ;lda #$6000|NTXY(0,15)
  ;sta PPUADDR
  
  ;lda #ground & $ffff
  ;sta msg_ram
  ;jsr scrn_copy
  
done:
  seta8
  
  lda #%00000001  ; enable sprites and plane 0
  sta BLENDMAIN
  
  lda #$00
  sta PPUBRIGHT
  
  
  ; we want nmi
  lda #VBLANK_NMI|AUTOREAD
  sta PPUNMI

  cli ; enable interrupts
  
  ; now to fade in!
  
  lda #$01
  
fade_in:
  wai ; wait a frame
  wai ; another!
  sta PPUBRIGHT
  ina
  cpa #$10
  bne fade_in
  
forever:
  wai
  jml forever


message:
        ;12345678901234567890123456789012
  .byte "Screw you, it's a platformer.", $ff

ground:
  .rept 32
   .byte '_'
  .endr
  .byte $ff

;useless handlers for snes header
cop_handler:
brk_handler:
abort_handler:
ecop_handler:
eabort_handler:
enmi_handler:
eirq_handler:
irq_handler:
  rti

.include "src/gfx.s"
.include "src/ppu.s"
.include "src/ram.s"
.include "src/initialize_snes.s"

.include "src/snesheader.s"

.org $828000-1
db 0

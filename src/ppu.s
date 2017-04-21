ppu_copy:
  php
  setaxy16
  sta DMAMODE
  stx DMAADDR
  sty DMALEN
  seta8
  phb
  pla
  sta DMAADDRBANK
  lda #%00000001
  sta COPYSTART
  plp
  rtl


scrn_copy:
  setxy16
  ldy #$00

scrnloop: seta8
  lda (msg_ram), y
  seta16
  and #$ff ; clear higher bit
  sta PPUDATA
  dex
  iny
  iny
  cpx #$0000
  bne scrnloop
  
  rtl


vblank:
  phb
  phk         ; set data bank to bank 0 (because banks $40-$7D
  plb         ; and $C0-$FF can't reach low memory)
  bit NMISTATUS ; absolute somehow?
  plb
  rti

;;
; Decompresses data to rle_cp_dat using a simple RLE scheme.
; @param DBR:rle_cp_src pointer to compressed data
; @return rle_cp_index = 4
rle_copy_ram:
  setxy16
  seta8
  ldy #$00
  sty rle_cp_index
  tya  ; clear low and high bytes of accumulator

 rle_loop:
  lda (rle_cp_src),y
  cpa #$ff  ; RLE data is terminated by a run length of $FF
  beq rle_done  ; But what does a run length of 0 do?
  cpa #$fe
  beq copy_fe
  tax
  iny
  lda (rle_cp_src),y
  iny
  phy

  ; At this point, Y (source index) is saved on the stack,
  ; A is the byte to write, and X is the length of the run.
  txy
  
  ; no higher byte!
  pha
  seta16
  tya
  and #$ff
  tay
  seta8
  pla
  
  ldx rle_cp_index
  ; And here, Y is the length of the run, A is the byte to write,
  ; and X is the index into the decompression buffer.
rle_inter:
  sta rle_cp_dat,x
  inx
  dey
  bne rle_inter

  stx rle_cp_index
  ply  ; Restore source index
  bra rle_loop

copy_fe:
  
  ; this code gets a little crazy, so bear with me.
  
  iny ; get number of bytes to copy
  lda (rle_cp_src),y
  iny ; don't copy number of bytes to copy!
  sty rle_cp_count
  
  ldx #$00 ; 0 higher bit
  tax ; x has bytes remaining
  stx rle_cp_remain
  
  ldx rle_cp_index

fe_loop:
  lda (rle_cp_src),y
  iny ; for next byte
  
  sta rle_cp_dat,x
  
  ; this is a weird way of saying "one less remaining"
  phx
  ldx rle_cp_remain
  dex
  stx rle_cp_remain
  plx
  
  ; increase the index
  inx
  
  ; now check how much remaining
  lda rle_cp_remain
  cpa #$00
  bne fe_loop
  
  ; put the index back
  stx rle_cp_index
  
  bra rle_loop
  
rle_done:
  rtl

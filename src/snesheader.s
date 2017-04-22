; as usual, thanks tepples for the basis

.org $80ffc0
 romname:
 .byte "STINKOMAN" ; rom name
 .dsb 21 - ($ - romname),$20
 
 ; make sure the rom name length is covered (thanks tepples)
  ;.if $ - romname < 21
  ;  .dsb romname + 21 - $, $20  ; space padding
  ;.endif
  
 .byte $30 ; lorom fastrom
 .byte $00 ; no battery ram
 .byte $08 ; 256K rom
 
 .dsb 12
 
 .word cop_handler&$ffff, brk_handler&$ffff, abort_handler&$ffff
 .word vblank&$ffff, $FFFF, irq_handler&$ffff
 
 .dsb 4  ; more unused vectors
 
 ; 6502 mode vectors
 ; brk unused because 6502 mode uses irq handler and pushes the
 ; X flag clear for /IRQ or set for BRK
 .word ecop_handler&$ffff, $FFFF, eabort_handler&$ffff
 .word enmi_handler&$ffff, InitializeSNES&$ffff, eirq_handler&$ffff
  

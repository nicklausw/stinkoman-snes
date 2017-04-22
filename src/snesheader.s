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
 
 .fdw cop_handler, brk_handler, abort_handler
 .fdw vblank, $FFFF, irq_handler
 
 .dsb 4  ; more unused vectors
 
 ; 6502 mode vectors
 ; brk unused because 6502 mode uses irq handler and pushes the
 ; X flag clear for /IRQ or set for BRK
 .fdw ecop_handler, $FFFF, eabort_handler
 .fdw enmi_handler, InitializeSNES, eirq_handler
  

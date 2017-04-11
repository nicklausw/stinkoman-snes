; as usual, thanks tepples for the basis

.include "global.i"

.segment "SNESHEADER"
 romname:
 .byte "STINKOMAN" ; rom name
 
 ; make sure the rom name length is covered (thanks tepples)
 .assert * - romname <= 21, error, "ROM name too long"
  .if * - romname < 21
    .res romname + 21 - *, $20  ; space padding
  .endif
  
 .byte $30 ; lorom fastrom
 .byte $00 ; no battery ram
 .byte $08 ; 256K rom
 
 .res 12
 
 .addr cop_handler, brk_handler, abort_handler
 .addr vblank, $FFFF, irq_handler
 
 .res 4  ; more unused vectors
 
 ; 6502 mode vectors
 ; brk unused because 6502 mode uses irq handler and pushes the
 ; X flag clear for /IRQ or set for BRK
 .addr ecop_handler, $FFFF, eabort_handler
 .addr enmi_handler, InitializeSNES, eirq_handler
  
.segment "CODE"

; Unused exception handlers
cop_handler:
brk_handler:
abort_handler:
ecop_handler:
eabort_handler:
enmi_handler:
eirq_handler:
irq_handler:
  rti

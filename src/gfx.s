; the gfx

.include "global.i"

.segment "RODATA"

palette:
  .incbin "videlectrix.pal"
palette_size:

font:
  .incbin "videlectrix.rle"

fontnam: .incbin "videlectrix.nam"

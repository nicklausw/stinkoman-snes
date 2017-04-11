; the global file

.include "snes.i"
.p816
.smart
.localchar '?'

; main.s
.global reset, vblank

; gfx.s
.global palette, palette_size
.global font, fontnam

; ram.s
.globalzp msg_ram, rle_cp_src, rle_cp_index, rle_cp_count, rle_cp_remain
.global rle_cp_dat: far

; initialize_snes.s
.global InitializeSNES

; ppu.s
.global ppu_copy, scrn_copy
.global vblank, rle_copy_ram

; macros

; palette macro
.define bgr(cb, g, r) ((cb<<10)|(g<<5)|r)

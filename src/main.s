.include "inc/snes.i"
.include "inc/macros.i"

; the code
.org $808000
.include "src/reset.s"
.include "src/gfx.s"
.include "src/ppu.s"
.include "src/ram.s"
.include "src/initialize_snes.s"

.include "src/snesheader.s"

.pad $848000 ;256k
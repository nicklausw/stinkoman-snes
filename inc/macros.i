; macros

; palette macro
.macro bgr cb,g,r
  .dw ((cb<<10)|(g<<5)|r)
.endm
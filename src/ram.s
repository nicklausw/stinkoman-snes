.enum $00
  msg_ram: .dsb 2
  rle_cp_src: .dsb 2    ; Renamed: serves as pointer (within current bank) to compressed data
  rle_cp_index: .dsb 2  ; Renamed: serves as index into rle_cp_dat
  rle_cp_count: .dsb 2
  rle_cp_remain: .dsb 2
.ende
  
.enum $7e2000
  rle_cp_dat: .dsb 8192 ; 8 KB?
.ende

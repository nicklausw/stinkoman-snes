ASM16 = asm16
FIX = tools/snes-check.py
RLE = tools/rle.py
GFXCONV = tools/snes-tile-tool.py
WAVCONV = tools/wav2brr.py

TITLE = stinkoman

EMU = bsnes

IFILES = $(wildcard inc/*.i)
SFILES = $(wildcard src/*.s)

GFX = $(wildcard gfx/*.bmp)
CHR_G = $(subst .bmp,.chr,$(GFX))
RLE_G = $(subst .chr,.rle,$(CHR_G))

WAV = $(wildcard audio/*.wav)
BRR = $(subst .wav,.brr,$(WAV))

all: $(TITLE).sfc
	@echo opening in $(EMU)...
	@$(EMU) $(TITLE).sfc >/dev/null 2>&1

$(TITLE).sfc: $(SFILES)
	@echo assembling...
	@$(ASM16) -q src/main.s $(TITLE).sfc
	@$(FIX) $(TITLE).sfc

$(SFILES): $(IFILES)
$(SFILES): $(RLE_G)
$(SFILES): $(GFX)
$(SFILES): $(WAV)
$(SFILES): $(BRR)

audio/%.brr: audio/%.wav
	$(WAVCONV) $< $@

gfx/%.chr: gfx/%.bmp
	@echo converting $< to chr format...
	@$(GFXCONV) -Od -b8 -i $< -o $(subst .bmp,,$<)

gfx/%.rle: gfx/%.chr
	@echo converting $< to rle format...
	@$(RLE) $< $@

clean:
	rm -f $(RLE_G) gfx/*.nam gfx/*.pal $(TITLE).sfc

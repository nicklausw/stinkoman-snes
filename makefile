CC = ca65
LD = ld65
FIX = tools/snes-check.py
RLE = tools/rle.py
GFXCONV = tools/snes-tile-tool.py

CFG = snes.cfg

TITLE = stinkoman

EMU = bsnes

IFILES = $(wildcard inc/*.i)
SFILES = $(wildcard src/*.s)
OFILES = $(subst .s,.o,$(subst src/,obj/,$(SFILES)))

GFX = $(wildcard gfx/*.bmp)
CHR_G = $(subst .bmp,.chr,$(GFX))
RLE_G = $(subst .chr,.rle,$(CHR_G))

all: $(TITLE).sfc
	$(EMU) $(TITLE).sfc >/dev/null 2>&1

$(TITLE).sfc: $(OFILES)
	@echo linking to $(TITLE).sfc...
	@$(LD) -o $(TITLE).sfc -C $(CFG) $(OFILES)
	$(FIX) $(TITLE).sfc

$(SFILES): $(IFILES)
$(SFILES): $(CFG)
$(SFILES): $(RLE_G)
$(SFILES): $(GFX)

obj/%.o: src/%.s
	@echo assembling file $<...
	@$(CC) -I inc --bin-include-dir gfx -o $@ $<

gfx/%.chr: gfx/%.bmp
	@echo converting $< to chr format...
	@$(GFXCONV) -Od -b8 -i $< -o $(subst .bmp,,$<)

gfx/%.rle: gfx/%.chr
	@echo converting $< to rle format...
	@$(RLE) $< $@

clean:
	rm -f $(OFILES) $(RLE_G) gfx/*.nam gfx/*.pal $(TITLE).sfc

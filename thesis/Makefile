TARGET=main
EXTRACLEAN=$(TARGET).tex~ $(TARGET).tex.backup
include Makefile.include
#inkscape *.svg --export-area-drawing -A *.pdf

svg: $(wildcard pictures/*.svg)
	@$(foreach file,$(wildcard pictures/*.svg), echo inkscape -somestuff $(file) $(file:.svg=.pdf);)
	inkscape pictures/regular_surface.svg --export-area-drawing -A /tmp/test.pdf


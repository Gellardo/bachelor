TARGET=main
EXTRACLEAN=$(TARGET).tex~ $(TARGET).tex.backup
include Makefile.include
#inkscape *.svg --export-area-drawing -A *.pdf

svg: $(wildcard pictures/*.svg)
	@$(foreach file,$(wildcard pictures/*.svg), echo converting $(file); inkscape $(file) --export-area-drawing -A $(file:.svg=.pdf);)


export OCAMLMAKEFILE=OCamlMakefile

define PROJ_fract
  SOURCES = mygfx.ml fract.ml
  RESULT = fract
  LIBS = unix graphics
endef 
export PROJ_fract

ifdef sub
  export SUBPROJS = $(sub)
endif

ifndef SUBPROJS
  export SUBPROJS = fract
endif

all:	nc

%:
	@make -f $(OCAMLMAKEFILE) subprojs SUBTARGET=$@

.PHONY: all clean web

BOARDS = cfxsx cfxsx-2280
GITREPO = https://github.com/neg2led/cfxsx
JLCFAB_IGNORE = J1,J2

BOARDSFILES = $(addprefix build/, $(BOARDS:=.kicad_pcb))
SCHFILES = $(addprefix build/, $(BOARDS:=.sch))
GERBERS = $(addprefix build/, $(BOARDS:=-gerber.zip))
JLCGERBERS = $(addprefix build/, $(BOARDS:=-jlcpcb.zip))

RADIUS=1

all: $(GERBERS) $(JLCGERBERS) build/web/index.html

build/cfxsx.kicad_pcb: cfxsx/cfxsx.kicad_pcb build
	kikit panelize extractboard -s 135 50 30 62 $< $@

build/cfxsx-2280.kicad_pcb: cfxsx/cfxsx-2280.kicad_pcb build
	kikit panelize extractboard -s 135 50 30 100 $< $@

build/cfxsx.sch: cfxsx/cfxsx.kicad_pcb build
	cp cfxsx/cfxsx.sch $@

build/cfxsx-2280.sch: cfxsx/cfxsx-2280.kicad_pcb build
	cp cfxsx/cfxsx.sch $@

%-gerber: %.kicad_pcb
	kikit export gerber $< $@

%-gerber.zip: %-gerber
	zip -j $@ `find $<`

%-jlcpcb: %.sch %.kicad_pcb
	kikit fab jlcpcb --assembly --ignore $(JLCFAB_IGNORE) --schematic $^ $@

%-jlcpcb.zip: %-jlcpcb
	zip -j $@ `find $<`

web: build/web/index.html

build:
	mkdir -p build

build/web: build
	mkdir -p build/web

build/web/index.html: build/web $(BOARDSFILES)
	kikit present boardpage \
		-d README.md \
		--name "CFexpress to M.2 adapter" \
		-b "CFexpress to M.2 2230/42" "Board" build/cfxsx.kicad_pcb  \
		-b "CFexpress to M.2 2230/42/60/80" "Board" build/cfxsx-2280.kicad_pcb  \
		-r "assets/cfxsx.png" \
		-r "assets/cfxsx-bottom.png" \
		-r "assets/cfxsx-top.png" \
		--repository "$(GITREPO)"\
		build/web

clean:
	rm -r build

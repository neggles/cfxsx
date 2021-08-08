.PHONY: all clean web

BOARDS = cfxsx
GITREPO = https://github.com/neg2led/cfxsx.git
JLCFAB_IGNORE = J1,J2

BOARDSFILES = $(addprefix build/, $(BOARDS:=.kicad_pcb))
SCHFILES = $(addprefix build/, $(BOARDS:=.sch))
GERBERS = $(addprefix build/, $(BOARDS:=-gerber.zip))
JLCGERBERS = $(addprefix build/, $(BOARDS:=-jlcpcb.zip))

RADIUS=1

all: $(GERBERS) $(JLCGERBERS) build/web/index.html

build/cfxsx.kicad_pcb: cfxsx/cfxsx.kicad_pcb build
	kikit panelize extractboard -s 135 50 30 62 $< $@

build/cfxsx.sch: cfxsx/cfxsx.kicad_pcb build
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
		--name "MXM 3.1 to PCIe x8 Adapter" \
		-b "MXM 3.1 to PCIe x8 Adapter" "Board" build/cfxsx.kicad_pcb  \
		-r "assets/cfxsx.png" \
		-r "assets/cfxsx-bottom.png" \
		-r "assets/cfxsx-top.png" \
		--repository "$(GITREPO)"\
		build/web

clean:
	rm -r build

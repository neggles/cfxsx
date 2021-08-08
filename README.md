# cfxsx

Xbox Series X/S storage expansion card to M.2 NGFF NVMe SSD adapter. Well, maybe.

The connector the X/S use is CFexpress-adjacent - I have _no idea_ if this will even begin to work, but, YOLO?

![KiCad raytraced board render](assets/cfxsx-top.png)

# But, for real, don't make this. It probably doesn't work at all.

## Repository Structure
- `cfxsx` contains the main schematics and board drawing
- `cfxsx/PCIexpress.pretty` contains the board-specific footprints
- `cfxsx/PCIexpress.3dshapes` contains the 3D models for parts on the board (and a bunch of extras from my various experiments)

## Building
Simply call `make` in the top-top level directory. The `build` directory will then contain:

- the main board
- zipped gerbers for the boards you can directly use for manufacturing
- zipped gerbers and SMT assembly BOM/position files for JLCPCB's SMT assembly service for the single-board version.

Makefile uses [Jan Mrázek](https://github.com/yaqwsx)'s [KiKit](https://github.com/yaqwsx/KiKit), which I cannot recommend enough, and therefore has to be available on your system.

Jan's [jlcparts](https://yaqwsx.github.io/jlcparts/) app was also extremely useful in narrowing down part choices based on what JLCPCB have available.

-----
### **IMPORTANT NOTE:** If you give JLCPCB these files as-is, *please* verify the orientation of every part before submitting.

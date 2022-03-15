#!/bin/sh
ca65 src/main.asm
ca65 src/reset.asm
ld65 src/reset.o src/main.o --dbgfile main.dbg -C nes.cfg -o main.nes
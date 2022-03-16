.include "constants.inc"
.include "header.inc"


.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA  ; initiate DMA transfer from $0200 to OAM
  LDA #$00
  STA $2005   ; Disable scrolling for now
  STA $2005
  RTI
.endproc


.import reset_handler

.export main
.proc main

  ; prepare Background
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR

load_palletes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palletes
  
; write background
  LDA PPUSTATUS ; reset PPUADDR latch
  LDA #$20
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  LDA #<background
  STA COPYPOINTER
  LDA #>background
  STA COPYPOINTER+1

  LDA #$00
  STA COPYCOUNTER
  LDA #$04
  STA COPYCOUNTER+1

  LDY #$00
copy_background_loop:
  LDA (COPYPOINTER),Y 

  STA PPUDATA
  
  LDA COPYPOINTER
  CLC
  ADC #$01
  STA COPYPOINTER
  LDA COPYPOINTER+1
  ADC #$00
  STA COPYPOINTER+1

  LDA COPYCOUNTER
  SEC
  SBC #$01
  STA COPYCOUNTER
  LDA COPYCOUNTER+1
  SBC #$00
  STA COPYCOUNTER+1

  LDA COPYCOUNTER
  CMP #$00
  BNE copy_background_loop
  LDA COPYCOUNTER+1
  CMP #$00
  BNE copy_background_loop


  ; Write Sprite Data
  LDX #$00
load_sprites:
  LDA sprites,X
  STA $0200,X
  INX
  CPX #$04
  BNE load_sprites

  ; Enable drawing
  LDA #%10001000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK


forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "../Lightbox/tileset.chr"

.segment "RODATA"

palettes:
; 4x Background
.incbin "../Lightbox/palettes.pal"

; 4x Sprites
.incbin "../Lightbox/palettes.pal"

sprites:
.byte $70 ; Y-Koordinate
.byte $08 ; Tile Index
.byte $00 ; Attribute
.byte $80  ; X-Koordinate

background:
.incbin "../Lightbox/nametable.nam"


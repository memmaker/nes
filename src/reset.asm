.include "constants.inc"


.segment "CODE"
.import main
.export reset_handler
.proc reset_handler
  SEI
  CLD
  LDX #$00
  STX PPUCTRL
  STX PPUMASK

; Clear OAM Buffer
  LDX #$00
  LDA #$ff
clear_oam_buffer:
  STA $0200,X  ; Y Koordinate ausserhalb des Bildschirms schieben
  INX
  INX
  INX
  INX
  BNE clear_oam_buffer

vblankwait:
  BIT PPUSTATUS
  BPL vblankwait
  JMP main
.endproc
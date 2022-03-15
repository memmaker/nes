
.segment "HEADER"
.byte $4e, $45, $53, $1a ; Magischer Identifier
.byte $02				 ; Anzahl 16KB PRG-ROM Bänke
.byte $01				 ; Anzahl 8KB CHR-ROM Bänke
.byte %00000001          ; Vertical mirroring, kein save RAM, kein mapper
.byte %00000000          ; Keine special-case flags, kein mapper
.byte $00				 ; Kein PRG-RAM
.byte $00 				 ; NTSC Format

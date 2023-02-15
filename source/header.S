.segment "HEADER"

INES_MAPPER = 0
INES_MIRROR = 1
INES_SRAM = 1
INES_CODE_BANKS = 2
INES_CHR_BANKS = 1

.byte 'N', 'E', 'S', $1A
.byte INES_CODE_BANKS
.byte INES_CHR_BANKS
.byte INES_MIRROR | (INES_SRAM << 1) | ((INES_MAPPER & $f) << 4)
.byte (INES_MAPPER & %11110000)

.byte $0, $0, $0, $0
.byte $0, $0, $0, $0

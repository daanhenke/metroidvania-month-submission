.include "ppu.S"

.segment "CODE"
.import main

.global reset_handler
reset_handler:
    sei         ; mask interrupts
    
    lda #0
    sta $2000   ; disable NMI's
    sta $2001   ; disable rendering
    sta $4015   ; disable APU output
    sta $4010   ; disable DMC IRQ
    
    lda #$40
    sta $4017   ; disable APU IRQ

    cld         ; disable decimal mode

    ldx #$FF
    txs         ; set stack pointer

    bit $2002   ; first read can return garbage?
    wait_for_vblank

    ; initialize RAM to 0's
    lda #0
    ldx #0
@zero_ram:
    sta $0000, X
    sta $0100, X
    sta $0200, X
    sta $0300, X
    sta $0400, X
    sta $0500, X
    sta $0600, X
    sta $0700, X
    inx
    bne @zero_ram

    wait_for_vblank

    jmp main

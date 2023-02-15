.segment "ZEROPAGE"
.import nmi_lock
.import nmi_state

.segment "OAM"
.import oam

.segment "CODE"
.global nmi_handler
nmi_handler:
    ; store registers
    pha
    txa
    pha
    tya
    pha

    ; make sure the lock byte is clear, if not we're done
    lda nmi_lock
    bne @done

    ; set the lock byte
    lda #1
    sta nmi_lock

    lda nmi_state

    ; state 0: not ready to handle graphics
    beq @unlock

    ; state 1: push graphics data to ppu
    cmp #1
    beq @update_ppu_state
    
    ; state 2: disable rendering
    cmp #2
    beq @disable_rendering

    ; state corrupt: good lock
    jmp @unlock

@update_ppu_state:
    lda #0
    sta $2003
    ; pass pointer to oam buffer
    lda #>oam
    sta $4014

    jmp @unlock

@disable_rendering:
    ; disable ppu rendering & nmi_state = 0
    lda #0
    sta $2001
    sta nmi_state

    jmp @unlock

@unlock:
    ; clears the lock byte
    lda #0
    sta nmi_lock
@done:
    ; restore registers and return from interrupt
    pla
    tay
    pla
    tax
    pla
    rti

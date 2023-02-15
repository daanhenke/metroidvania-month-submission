.segment "ZEROPAGE"

; Used to determine what tasks to do during nmi
.global nmi_state
nmi_state: .res 1

; Detects nmi re-entry
.global nmi_lock
nmi_lock: .res 1

.segment "BSS"

.global nametable_buffer
nametable_buffer:  .res 256

.global palette_buffer
palette_buffer:    .res 32

.segment "OAM"
.global oam
oam: .res 256

.segment "CODE"
.import nmi_handler
.import reset_handler
.import irq_handler

; The NES will jump into this during interrupts & reset
.segment "VECTORS" 
.word nmi_handler
.word reset_handler
.word irq_handler

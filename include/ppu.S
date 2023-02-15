.macro wait_for_vblank
:
    bit $2002
    bpl :-
.endmacro

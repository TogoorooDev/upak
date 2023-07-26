        .global exec
        .global exec_size
        .section .rodata

exec:
        .incbin "obj/executable.tmp"
i:
exec_size:
        .int i - exec

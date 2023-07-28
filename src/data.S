        .global execz
        .global execz_size

        .section .rodata


execz:
        .incbin "obj/executable.tmp"
i:
execz_size:
        .int i - execz

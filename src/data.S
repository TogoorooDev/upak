        .global exec
        .global exec_size
        .section .rodata

cksum:
        .incbin "obj/executable.tmp.cksum"
j:
cksum_size:
        .int j - cksum

exec:
        .incbin "obj/executable.tmp"
i:
exec_size:
        .int i - exec


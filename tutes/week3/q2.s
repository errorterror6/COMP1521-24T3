0x10010020

    .data
a:  .word   42          0x10010020
0
0
0
42
b:  .space  4           0x10010024
??
??
??
??
c:  .asciiz "abcde"     0x1001028
    .align  2             #align 2 makes the next label (d) (2^2) byte aligned -> next address divisible by 4!!
    'a'
    'b'
    'c'
    'd'
    'e'
    '\0'
    space
    space
d:  .byte   1, 2, 3, 4    0x1001030
	.byte 1
	.byte 2
	.byte 3
	.byte 4
e:  .word   1, 2, 3, 4    0x1001034
	.word 1
	.word 2
	.word 3
	.word 4
f:  .space  1             0x1001044
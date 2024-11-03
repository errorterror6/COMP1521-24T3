
    0x0013
    0000 0000 0001 0011 16 + 2+ 1 = 19
    1*16 + 3 = 19


    0x0444
    0000
    4*16^2 + 4*16 + 4 = 1092

    0x1234
    1*16^3 + 2*16^2 + 3*16 + 4 = 4660

    0xffff
    1111 1111 1111 1111
    because negative, we take 2's compliment
    1. take the not operation
    0000 0000 0000 0000
    2. add 1
    0000 0000 0000 0001
    -1

    0x8000 
    1000 0000 0000 0000  -> signed
    1. take the not operation
    0111 1111 1111 1111
    2. add1
    1000 0000 0000 0000  -> unsigned
    -32768

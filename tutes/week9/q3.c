d    -> is a directory

r  -> owner can read
w                      -> owner (USR)
x

r
w                    -> group (GRP)
x    -> group can execute

-        -> others cannot read
w                     -> other (OTH)
x



  110 101 111  -> mode_t
d rw- r-x rwx       S_IWGRP = 0b000 010 000

S_IWGRP | S_IRGRP = 
000 010 000
000 100 000
000 110 000
--- rw- ---



001 001 001
--x --x --x

111 111 111
rwx rwx rwx
la   $t0, aa
$t0 = 0x10010000    

lw   $t0, bb
$t0 = 666

#la/li -> gets the address
#lw/lb -> gets the value

lb   $t0, bb
# don't do this!!

lw   $t0, aa+4
$t0 = 666

la   $t1, cc
lw   $t0, ($t1)
$t0 = 1

la   $t1, cc
lw   $t0, 8($t1)
$t0 = 5

li   $t1, 8
lw   $t0, cc($t1)
$t0 = 5

la   $t1, cc
lw   $t0, 2($t1)
# won't work!! lw require 4-byte alignment.


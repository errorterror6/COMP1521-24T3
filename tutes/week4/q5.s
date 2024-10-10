	.text

main:
	begin
# 	int main(void) {
	#     int result = sum4(11, 13, 17, 19);
	#     printf("%d\n", result);
	#     return 0;
	# }
	push	$ra
	#load args
	li	$a0, 11
	li	$a1, 13
	li	$a2, 17
	li	$a3, 19
	#call fn
	jal sum4
	move	$a0, $v0	#output result is in $v0!!
	li	$v0, 1
	syscall

	li	$a0, '\n'
	li	$v0, 11
	syscall

	li	$v0, 0

	pop	$ra
	end
	jr	$ra

sum4:
sum4_prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
	push	$s2

	#save c and d in s registers -> so they persist1!
	#c = $a2
	move	$s0, $a2  #$s0 = c
	move	$s1, $a3  #s1 = d
sum4_body:
	jal	sum2
	# can change t, a, and v registers
	# cannot change s register
	move	$s2, $v0
# int sum4(int a, int b, int c, int d) {
#     int res1 = sum2(a, b);
#     int res2 = sum2(c, d);
#     return sum2 (res1, res2);
# }
	move	$a0, $s0   #a2 = c, $s0 = c
	move	$a1, $s1
	jal	sum2
	#t0 is gone!!
	move	$a0, $s2	#t0 was res1
	move	$a1, $v0	#v0 was res2
	jal	sum2
	#output of sum2(res1, res2) is already in $v0

sum4_epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra

sum2:
	push	$ra

	add	$v0, $a0, $a1

	pop	$ra
	jr	$ra


	.data
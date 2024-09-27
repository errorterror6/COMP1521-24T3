	.text
main:

	#$t0 = s  (char *s)
	#t1 = length

	la	$t0, string
	li	$t1, 0        #length = 0

	#counter = $t3
	li	$t3, 0
main__while:	
	lb	$t2, ($t0)	#$t2 = *s (value)
	beq	$t2, '\0', main__while_end

	addi	$t1, $t1, 1	#increment length
	addi	$t0, $t0, 1     #s++
	addi	$t3, $t3, 1     #counter ++

	b	main__while
main__while_end:
	move	$a0, $t3
	li	$v0, 1
	syscall

	li	$a0, '\n'
	li	$v0, 11
	syscall

	jr	$ra

	.data
string:
	.asciiz  "......"
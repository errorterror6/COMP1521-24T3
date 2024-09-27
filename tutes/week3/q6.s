	.text
N_SIZE = 10

main:
	#$t0 = i
	li	$t0, 0  # i = 0

main__while:
	bge	$t0, N_SIZE, main__while_end
	# printf("%d\n", numbers[i]);
	#figure out numbers[i]
	mul	$t2, $t0, 4
	lw	$t1, numbers($t2)
	#print it
	move	$a0, $t1
	li	$v0, 1
	syscall
	#print '\n'
	li	$a0, '\n'
	li	$v0, 11
	syscall

	addi	$t0, $t0, 1	#i++
	
	b	main__while


main__while_end:
	jr	$ra


	.data
numbers:
	.word	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
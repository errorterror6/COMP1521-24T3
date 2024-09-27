	.text
N_SIZE = 10

main:
	#$t0 = i
	li	$t0, 0   #i = 0

main__while:
	bge	$t0, N_SIZE, main__while_end
main__while_if:
	#calculate numbers[i]
	mul	$t2, $t0, 4
	lw	$t1, numbers($t2)   #numbers + 4*i
	bge	$t1, 0, main__while_if_end
	addi	$t1, $t1, 42
	sw	$t1, numbers($t2)

main__while_if_end:
	addi	$t0, $t0, 1
	b	main__while
main__while_end:
	jr	$ra


	.data
numbers:
	.word	0, 1, 2, -3, 4, -5, 6, -7, 8, 9
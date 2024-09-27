	.text
N_SIZE = 10

main:
	#$t0 = i

	li	$t0, 0    #i = 0

main__while_cond:
	bge	$t0, N_SIZE, main__while_end
#  scanf("%d", &numbers[i]);
	#scan the value
	li	$v0, 5
	syscall
	#save the value
	mul	$t1, $t0, 4
	sw	$v0, numbers($t1)    #numbers[i] -> numbers + i*4
	addi	$t0, $t0, 1
	b	main__while_cond



main__while_end:

	jr	$ra


	.data
numbers:
	.word  0:10
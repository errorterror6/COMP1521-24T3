	.text
FLAG_ROWS = 6
FLAG_COLS = 12

main:
	li	$t0, 0		#int row = 0
main__outer_for_cond:
	bge	$t0, FLAG_ROWS, main__outer_for_end
	li	$t1, 0		#int col = 0
main__inner_for_cond:
	bge	$t1, FLAG_COLS, main__inner_for_end
	# printf("%c", flag[row][col]);
	#figure out flag[row][col]
		#figure out the 1d-offset equivalent
	mul	$t2, $t0, FLAG_COLS 	#rows * total_cols
	add	$t2, $t2, $t1		#rows * total_cols + cols
	mul	$t2, $t2, 1		#multiply by elem size
		#load from memory
	lb	$t3, flag($t2)
	#print it out
	move	$a0, $t3
	li	$v0, 11
	syscall

	addi	$t1, $t1, 1
	b	main__inner_for_cond
main__inner_for_end:
	li	$a0, '\n'
	li	$v0, 11
	syscall

	addi	$t0, $t0, 1
	b	main__outer_for_cond
main__outer_for_end:

	jr	$ra





	.data
flag:
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
	.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'





	flag[1][0] == flag[12]
	flag[12]
	lb	$t0, flag(12)
	flag[1][0]
	row * total_cols + cols
	1 * 12 + 0 = 12
	lb	$t0, flag(12)

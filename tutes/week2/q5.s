	.text
SQUARE_MAX = 46340


main:
	#$t0 = x
	#$t1 = y

	# printf("Enter a number: ");
	li	$v0, 4
	la	$a0, str1
	syscall

#     scanf("%d", &x);
	li	$v0, 5
	syscall
	move	$t0, $v0
main__if:
	# if (x <= SQUARE_MAX) goto main__else;
	ble	$t0, SQUARE_MAX, main__else

	# printf("square too big for 32 bits\n");
	li	$v0, 4
	la	$a0, str2
	syscall

	b	main__end

main__else:
	#  y = x * x;
	mul	$t1, $t0, $t0
	

	# printf("%d\n", y);
	li	$v0, 1
	move	$a0, $t1
	syscall

	li	$v0, 11
	li	$a0, '\n'
	syscall


main__end:
	li	$v0, 0
	jr	$ra

	.data
str1:
	.asciiz "Enter a number: "
str2:
	.asciiz "square too big for 32 bits\n"

data:
	.word 4

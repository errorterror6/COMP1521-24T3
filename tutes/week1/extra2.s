	.text
main:
	# typically we put local variables in registers
	# int x, y;
	# $t0 = x
	# $t1 = y
	
	# printf("Enter a number: ");
	li	$v0, 4		#puts 4 into $v0
	la	$a0, str	#la takes the address of str
				# and puts it into $a0
	syscall
			#syscall looks into $v0, for a command.

	# scanf("%d", &x);
	li	$v0, 5
	syscall
	#read in value is now in $v0!!
	
	#but we want it in x
	move 	$t0, $v0

	# y = x * x;
	mul	$t1, $t0, $t0

	# printf("%d\n", y);
	# printf("%d", y);
	li 	$v0, 1
	move	$a0, $t1 
	syscall
	# printf("\n");
	li	$v0, 11
	li	$a0, '\n'
	syscall


	li	$v0, 0
	jr	$ra		#return 0



	.data
str:
	.asciiz "Enter a number: "



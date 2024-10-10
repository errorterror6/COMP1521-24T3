	.text
main:	
	push	$ra
	#call max
		#load the arguments
	la	$a0, array
	li	$a1, 6
		#call the function
	jal	max
	#$ra gets changed to heree!!!
		#unload the return value.
	move	$t0, $v0
	#print it out
	move	$a0, $t0
	li	$v0, 1
	syscall

	li	$a0, '\n'
	li	$v0, 11
	syscall
	#return
	pop	$ra
	jr	$ra

max:	
	#$a0 = array
	#$a1 = length
max__prologue:	
	#pushing
	begin
	push	$ra
	push	$s0
max__body:
	#coding
	lw	$s0, 0($a0)		#t0 = first_Element
max__if:
	bne	$a1, 1, max__else
	move	$v0, $s0		
	#in a function, return by just branching to the epilogue.
	b	max__epilogue
max__else:
	#  int max_so_far = max(&array[1], length - 1);
	#load the arguments
	addi	$a0, $a0, 4
	addi	$a1, $a1, -1
	#call max
	#$t0 exists!!
	jal	max
	#$t0 does not exist!!
	# unload return v
	move	$t1, $v0	#t1 = max_so_far

max__else_if:
	ble	$s0, $t1, max__else_if_end
	move	$t1, $s0

max__else_if_end:
	move	$v0, $t1

max__epilogue:
	#popping
	pop	$s0
	pop	$ra
	#return
	end
	jr	$ra




	.data
array:
	.word	1, 2, 3, 44, 5, 6
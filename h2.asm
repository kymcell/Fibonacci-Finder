# Kyle McElligott

.data
prompt: .asciiz "Which Fibonacci number do you want? "
result: .asciiz "The Fibonacci number is "
warning: .asciiz "You must enter an integer greater than or equal to 0. Try again. "

.text
readInt:
	la $a0 prompt   		# print prompt
	li $v0 4
	syscall

	negjump:
	li $v0 5
	syscall
	move $t0 $v0
	move $a0 $t0
	move $v0 $t0
	jal Fibonacci
	move $t0 $v0

printInt:
	la $a0 result
	li $v0 4
	syscall
	move $a0 $t0    		# print fib output
	li $v0 1
	syscall
	li $v0 10			# halt program
	syscall

Fibonacci:
	slt $t0 $a0 $zero
	bne $t0 $zero readNonNegInt
	beqz $a0 zero   		# num = 0 return 0
	beq $a0 1 one   		# num = 1 return 1
	sub $sp $sp 4   		# store address
	sw $ra 0($sp)
	sub $a0 $a0 1
	jal Fibonacci   		# fib(n-1)
	add $a0 $a0 1
	lw $ra 0($sp)   		# restore address
	add $sp $sp 4
	sub $sp $sp 4   		# push to stack
	sw $v0 0($sp)
	sub $sp $sp 4   		# store to stack
	sw $ra 0($sp)
	sub $a0 $a0 2
	jal Fibonacci   		# fib(n-2)
	add $a0 $a0 2
	lw $ra 0($sp)   		# restore address
	add $sp $sp 4
	lw $s0 0($sp)   		# pop from stack
	add $sp $sp 4
	add $v0 $v0 $s0		        # fib(n-2) + fib(n-1)
	jr $ra

	zero:
	li $v0 0
	jr $ra

	one:
	li $v0 1
	jr $ra

readNonNegInt:
	la $a0 warning   		# input less than 0
	li $v0 4
	syscall
	jal negjump

		# 20126507 hnyzx3 ZiChen Xu

		.data
inBfr:	.space 	100
loadin: .asciiz	"Please input an integer: "
Wall:	.asciiz	"Note: the result of Fibonacci(47) will be overflow as an integer, in which case\n      Other input other than None Negative Integer or greater than 46 could lead to Error.\n"
outAns:	.asciiz	"The Fibonacci number is: "
error:	.asciiz "Invalid! Input should be None Negative Integer and less than 47."

		.text
		.globl main

main:
		li 		$v0, 4
		la 		$a0, Wall
		syscall								# print("Note: Other input other than None Negative Integer but greater than 46 could lead to Error.\n")

		li 		$v0, 4
		la 		$a0, loadin
		syscall								# print("Please input a number: ")

		li 		$v0, 8
		la 		$a0, inBfr
		li 		$a1, 100
		syscall

		la 		$s1, inBfr

#	The following function will convert input string to integer
#	With the capacity of verifying whether is valid integer input or not
#	If not, goto "err"

		li		$t1, 0						# t1 stores the converted integer
	strToIntLoop:
		lb	 	$t0, 0($s1)       			# load char from inBfr into t0
		beq 	$t0, 10, fibStart  	    	# '\n' terminator found
		blt 	$t0, 48, err   				# check current char isdigit() (ASCII < '0')
		bgt 	$t0, 57, err  				# check current char isdigit() (ASCII > '9')

		addi 	$t0, $t0, -48   			# converts t0 from ASCII to decimal
		mul 	$t1, $t1, 10    			# sum = sum * 10
		add 	$t1, $t1, $t0   			# sum += (array[s1] - '0')
		bgt 	$t1, 46, err   				# the result of fib(47) will overflow as integer
											# as a result, any input larger than 47 will be seen as error
		addi 	$s1, $s1, 1
		j 		strToIntLoop

fibStart:
		move	$a0, $t1					# print the value stored in $s1

		jal 	fib							# recursive procedure

		move	$a1, $v0					# move return value in $v0 to $a1
		j 		output

err:
		la 		$a0, error
		li 		$v0, 4
		syscall								# print out ("Invalid! Input should be None Negative Integer but less than 47.")
		j 		end

output:
		li		$v0, 4
		la		$a0, outAns
		syscall								# print out ("The Fibonacci number is: ")
		move 	$a0, $a1
		li 		$v0, 1
		syscall								# then print out the fibonacci number

end:
		li 		$v0, 10
		syscall								# exit


fib:
		addi 	$sp, $sp, -12				# space for 3 words
		sw 		$ra, 8($sp)  				# save return address 							- push
		sw 		$a0, 4($sp)					# temporary variable to hold n 					- push

		li		$v0, 0
		beq 	$a0, $zero, fibReturn		# if n == 0, return 0

		li 		$v0, 1
		beq 	$a0, $v0, fibReturn			# if n == 1, return 1


		lw 		$a0, 4($sp)
		addi	$a0, $a0, -1
		jal 	fib							# recursively calculate fib(n-1)
		sw 		$v0, 0($sp) 				# return value									- push

		lw 		$a0, 4($sp)					# restore $a0 value								- pop
		addi 	$a0, $a0, -2
		jal 	fib							# recursively calculate fib(n-2)

		lw 		$v1, 0($sp)					# restore return value of fib(n-1) in $v1		- pop
		add 	$v0, $v0, $v1				# return fib(n-2) + fib(n-1)

fibReturn:
		lw 		$ra, 8($sp)					# restore return address in $ra					- pop
		addi 	$sp, $sp, 12   				# restore stack pointer $sp						- pop
		jr 		$ra							# back to caller

# End of program, leave a blank line afterwards to make MARS happy :)
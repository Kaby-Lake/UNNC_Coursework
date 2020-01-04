		# 20126507 hnyzx3 ZiChen Xu

## printf.asm
##
## Register Usage:
## $a0,$s0 - pointer to format string
## $a1,$s1 - format argument 1 (optional)
## $a2,$s2 - format argument 2 (optional)
## $a3,$s3 - format argument 3 (optional)
## $s4 - count of formats processed.
## $s5 - char at $s4.
## $s6 - pointer to printf buffer
## $t7 - argument counter
##
## Source Courtesy D. J. E.

		.text
		.globl main
main:

# ---------------------------------------------------------------------------- #
#       This printf function works in an interactive way, with 4 prompts       #
#                    Users need to enter :_format string_                      #
#                        _format argument 1 (optional)_                        #
#                        _format argument 2 (optional)_                        #
#                        _format argument 3 (optional)_                        #
#     if any format argument is not needed, simply press Enter to skip one     #
# ---------------------------------------------------------------------------- #


#* printf(_format string_, _format argument 1 (optional)_, _format argument 2 (optional)_, _format argument 3 (optional))

#* -------------------------------------------------------------------------- *#
#*                         QB: Possible Normal Case                    		  *#
#* -------------------------------------------------------------------------- *#

# ------------------------------- Normal Case 1 ------------------------------ #
# printf("");

# ------------------------------- Normal Case 2 ------------------------------ #
# printf("%s", "Python is the best programming language");

# ------------------------------- Normal Case 3 ------------------------------ #
# printf("%d", 996251);

# ------------------------------- Normal Case 4 ------------------------------ #
# printf("%c", "s");

# ------------------------------- Normal Case 5 ------------------------------ #
# printf("%%");

# ------------------------------- Normal Case 6 ------------------------------ #
# printf("Python is the best programming language");

# ------------------------------- Normal Case 7 ------------------------------ #
# printf("Python is %s programming language", "the best");

# ------------------------------- Normal Case 8 ------------------------------ #
# printf("Python %d is %s programming language", 3, "the best");

# ------------------------------- Normal Case 9 ------------------------------ #
# printf("Python %d is %s programming language %S", 3, "the best" "in the world");

# ------------------------------ Normal Case 10 ------------------------------ #
# printf("%% Python is %s programming language %S%c", "the best" "in the world!", '!');

# - Below are '\' features which are not listed in the coursework description  #
# --------------- But is in the std-c99 printf function library -------------- #
# --------------------- So I did it, as an Easter egg... --------------------- #

# ------------------------------ Normal Case 11 ------------------------------ #
# printf("%s.lang\nStackOverflowError", "java");

# ------------------------------ Normal Case 12 ------------------------------ #
# printf("%s.lang\nStack\tOverflowError", "java");

# ------------------------------ Normal Case 13 ------------------------------ #
# printf("%s.lang\nStackOverflowError\0 at com.service. AdminService.<init>(AdminService.java:9)", "java");

# ------------------------------ Normal Case 14 ------------------------------ #
# printf("Make\t%S\tGreat\tAgain\t!", "America");

# ------------------------------ Normal Case 15 ------------------------------ #
# printf("A %S \\ pointing to a pointer\twhich is pointing to a pointer", "pointer");





#* -------------------------------------------------------------------------- *#
#*                         QB: Possible Abnormal Case                    	  *#
#* -------------------------------------------------------------------------- *#

# ----------------------------- Abnormal Case 1 ------------------------------ #
# printf("See what happens when more data argument than needed are inputted", "Boom!", "Crash");
# OUTPUT: See what happens when more data argument than needed are inputted
#		  ** Warning: Data argument not used by format string. **

# ----------------------------- Abnormal Case 2 ------------------------------ #
# printf("See what %s when less data argument than needed %S are inputted", "happens");
# OUTPUT: See what happens when less data argument than needed are inputted
#		  ** Warning: More '%' conversions than data arguments. **
#		  ** Exit with Error. **

# ----------------------------- Abnormal Case 3 ------------------------------ #
# printf("See what happens when characters are inputted to %d", 404NotFound);
# OUTPUT: See what happens when characters are inputted to
#		  ** Interrupt: format argument is not valid integer. **
#		  ** Exit with Error. **

# ----------------------------- Abnormal Case 4 ------------------------------ #
# printf("See what happens when floating point inputs are inputted to %d", 996.251);
# OUTPUT: See what happens when floating point inputs are inputted to
#		  ** Interrupt: format argument is not valid integer. **
#		  ** Exit with Error. **

# ----------------------------- Abnormal Case 5 ------------------------------ #
# printf("See what happens when overflow inputs are inputted to %d", 2147483649);
# OUTPUT: See what happens when overflow inputs are inputted to
#		  ** Interrupt: format argument is not valid integer. **
#		  ** Exit with Error. **

# ----------------------------- Abnormal Case 6 ------------------------------ #
# printf("See what happens when string input are inputted to %c", "char");
# OUTPUT: See what happens when string input are inputted to c

# ----------------------------- Abnormal Case 7 ------------------------------ #
# printf("See what %s when %r, %i, %p etc.. are inputted", "happens");
# OUTPUT: See what happens when
#		  ** Interrupt: invalid conversion specifier. **
#		  ** Exit with Error. **

# ----------------------------- Abnormal Case 8 ------------------------------ #
# printf("See what happens when input more than 99 chars in the format string part, It seem that I reach the limit...");
# ** The string in the buffer has 108 bytes, which is more than the space I set for format string
# OUTPUT: See what happens when input more than 99 chars in the format string part, It seem that I reach the

# ----------------------------- Abnormal Case 9 ------------------------------ #
# printf("%d", 996 + 251);  ** This type of calculation in formated argument can be done in C, unfortunately, can't be handled here
# OUTPUT:
# 		  ** Interrupt: format argument is not valid integer. **
# 		  ** Exit with Error. **

# ----------------------------- Abnormal Case 10 ------------------------------ #
# printf("See what happens when there exists \0 in front of %s", "format argument");
# OUTPUT: See what happens when there exists
#		  ** Warning: Data argument not used by format string. **




		li 		$v0, 4
		la 		$a0, funcDeclare
		syscall								# print(funcDeclare)

		li		$v0, 4
		la 		$a0, promptFmtStr
		syscall								# print(promptFmtStr)

		li 		$v0, 8
		la 		$a0, fmtStr
		li 		$a1, 100
		syscall								# readin fmtStr

		li 		$v0, 4
		la 		$a0, promptFmtArg1
		syscall								# print(promptFmtArg1)

		li 		$v0, 8
		la 		$a0, fmtArg1
		li 		$a1, 100
		syscall								# readin fmtArg1

		li 		$v0, 4
		la 		$a0, promptFmtArg2
		syscall								# print(promptFmtArg2)

		li 		$v0, 8
		la 		$a0, fmtArg2
		li 		$a1, 100
		syscall								# readin fmtArg2

		li 		$v0, 4
		la 		$a0, promptFmtArg3
		syscall								# print(promptFmtArg3)

		li 		$v0, 8
		la 		$a0, fmtArg3
		li 		$a1, 100
		syscall								# readin fmtArg3

		la 		$a0, fmtStr
		la 		$a1, fmtArg1
		la 		$a2, fmtArg2
		la 		$a3, fmtArg3

		jal 	printf

		j 		exit

printf:
		subu	$sp, $sp, 36				# set up the stack frame
		sw		$ra, 32($sp)				# save local variables
		sw		$fp, 28($sp)
		sw		$s0, 24($sp)
		sw		$s1, 20($sp)
		sw		$s2, 16($sp)
		sw		$s3, 12($sp)
		sw		$s4, 8($sp)
		sw		$s5, 4($sp)
		sw		$s6, 0($sp)
		addu	$fp, $sp, 36
		li		$t7, 0						# set the argument counter, +1 when there exits a valid argument, -1 when there exits a %

	# There exists '\n' inside the string input, so that we simply treat '\n' as '\0' to avoid further modifying
	# So I change all $0 to '\n', including the given skeleton part
	# In ASCII table, '\n' has the value of 10

											# grab the arguments
		move	$s0, $a0
							# fmt string
isEmptyArg1:
		move	$s1, $a1
		lb	 	$t0, 0($s1)
		beq 	$t0, 10, isEmptyArg2    	# '\n' terminator found
		addi	$t7, $t7, 1					# argument counter ++ when there exits a valid argument


isEmptyArg2:
		move	$s2, $a2					# arg2, optional
		lb	 	$t0, 0($s2)
		beq 	$t0, 10, isEmptyArg3     	# '\n' terminator found
		addi	$t7, $t7, 1

isEmptyArg3:
		move	$s3, $a3					# arg3, optional
		lb	 	$t0, 0($s3)
		beq 	$t0, 10, continue    		# '\n' terminator found
		addi	$t7, $t7, 1
continue:
		li		$s4, 0						# set # of fmt = 0
		la		$s6, printf_buf				# set s6 = base of buffer

printf_loop:								# process each character at fmt
		lb		$s5, 0($s0)					# get the next character
		addu	$s0, $s0, 1					# $s0 pointer increases
		beq		$s5, '%', printf_fmt
		beq		$s5, 92, printf_fmtSps
		beq		$s5, 10, printf_end			# if '\n', finish

printf_putc:
		sb		$s5, 0($s6) 				# otherwise, put this char
		sb		$0, 1($s6)					# into the print buffer
		move	$a0, $s6					# and print it using syscall
		li		$v0, 4
		syscall
		j		printf_loop

printf_fmt:
		lb		$s5, 0($s0) 				# get the char after '%'
		addu	$s0, $s0, 1
	# check if already processed 3 args.
		beq		$s4, 3, printf_loop


	# if 'd', then print as a decimal integer
		beq		$s5, 'd', printf_int
	# if 's', then print as a string
		beq		$s5, 's', printf_str
	# if 'c', then print as an ASCII char
		beq		$s5, 'c', printf_char
	# if '%', then print as a '%'
		beq		$s5, '%', printf_perc
	# if '%', then print as a '%'
		beq		$s5, 'S', printf_CAPS
		j		unknownArgError				# if appears invalid conversion specifier


printf_fmtSps:
		lb		$s5, 0($s0) 				# get the char after '\'
		addu	$s0, $s0, 1


	# if 'n', then print as a new line
		beq		$s5, 'n', printf_newLine
	# if 't', then print as TAB
		beq		$s5, 't', printf_TAB
	# if '\', then print as '\'
		beq		$s5, 92, printf_backslash
	# if '0', then print end
		beq		$s5, '0', printf_end
		j		unknownArgError				# if appears invalid conversion specifier


printf_shift_args:
		move	$s1, $s2
		move	$s2, $s3
		addi	$s4, $s4, 1 				# increment no. of args processed
		j		printf_loop


printf_int:									# printf('%d', 100)
#	** IMPORTANT:
#	* The following <printf_int> function has been modified by me to convert string to integer and then print it
#	* With the capability of verifying whether valid integer input (isdigit, overflow, etc) or not
#	* If not, Interrupt with error message and exit
#	*/
		addi	$t7, $t7, -1				# argument counter -- when there exits a %
		li		$t1, 0						# t1 stores the converted integer
		lb	 	$t0, 0($s1)       			# load char from fmtArg into t0
		beq 	$t0, 10, intError		    # '\n' terminator found
		beq		$t0, 45, strToNegIntLoopTemp# if the first character is '-', goto strToNegIntLoop
		j 		strToIntLoop				# the first char, if is not '-', should be converted and stored as well

	strToNegIntLoopTemp:
		addi 	$s1, $s1, 1
	strToNegIntLoop:
		lb	 	$t0, 0($s1)       			# load char from fmtArg into t0
		beq 	$t0, 10, printAsNegInt  	# '\n' terminator found
		blt 	$t0, 48, intError   		# check current char isdigit (ASCII < '0')
		bgt 	$t0, 57, intError  			# check current char isdigit (ASCII > '9')
		bgt 	$t1, 214748363, intError    # detect possibility of overflow as int
		addi 	$t0, $t0, -48   			# converts t0 from ASCII to decimal
		mul 	$t1, $t1, 10    			# sum = sum * 10
		add 	$t1, $t1, $t0   			# sum += (array[s1] - '0')
		addi 	$s1, $s1, 1

		j strToNegIntLoop


	strToIntLoop:
		lb	 	$t0, 0($s1)       			# load char from fmtArg into t0
		beq 	$t0, 10, printAsInt  	    # '\n' terminator found
		blt 	$t0, 48, intError   		# check current char isdigit (ASCII < '0')
		bgt 	$t0, 57, intError  			# check current char isdigit (ASCII > '9')
		bgt 	$t1, 214748363, intError    # detect possibility of overflow as int
		addi 	$t0, $t0, -48   			# converts t0 from ASCII to decimal
		mul 	$t1, $t1, 10    			# sum = sum * 10
		add 	$t1, $t1, $t0   			# sum += (array[s1] - '0')
		addi 	$s1, $s1, 1

		j strToIntLoop

	printAsInt:
		move	$a0, $t1					# print the value stored in $s1
		li		$v0, 1
		syscall
		j		printf_shift_args

	printAsNegInt:
		sub		$a0, $zero, $t1				# print the negative of value stored in $s1
		li		$v0, 1
		syscall
		j		printf_shift_args

	intError:
		li 		$v0, 4
		la 		$a0, intErrorMsg
		syscall								# print(intErrorMsg)
		j 		exit


printf_str:									# printf('%s', str)
		addi	$t7, $t7, -1
		la		$t1, 0($s1)
	printf_strLoop:							# print every byte of string as char until reaches '\n'
		lb		$a0, 0($t1)
		beq		$a0, 10, printf_strEnd		# '\n' terminator found
		li		$v0, 11
		syscall
		addi	$t1, $t1, 1
		j		printf_strLoop
	printf_strEnd:
		j		printf_shift_args


printf_CAPS:								# printf('%S', str), which is QC
		addi	$t7, $t7, -1
	toCAPSLoop:
		lb	 	$t0, 0($s1)      			# load char from fmtArg into t0
		beq 	$t0, 10, printf_shift_args  # '\n' terminator found
		blt 	$t0, 97, printByChar   		# check current char islower (ASCII < 'a')
		bgt 	$t0, 122, printByChar   	# check current char islower (ASCII > 'z')
		addi 	$t0, $t0, -32  				# converts t0 from ASCII to decimal
	printByChar:
		move	$a0, $t0
		beq		$a0, 10, toCAPSLoop			# '\n' terminator found
		li		$v0, 11
		syscall
		addi	$s1, $s1, 1
		j		toCAPSLoop


printf_char:								# printf('%c', char)
		addi	$t7, $t7, -1
		lb		$a0, 0($s1)					# print the ASCII char stored in $s1
		li		$v0, 11
		syscall
		j		printf_shift_args


printf_perc:								# printf('%%')
		lb		$a0, perc					# print %
		li		$v0, 11
		syscall
		j		printf_loop					# %% does not require any arguments, so that no need to shift arguments


printf_newLine:
		la		$a0, newLine				# printf('\n')
		li		$v0, 4
		syscall
		j		printf_loop


printf_TAB:
		la		$a0, newTAB					# printf('    ')(TAB)
		li		$v0, 4
		syscall
		j		printf_loop


printf_backslash:
		li		$a0, 92						# printf('\')
		li		$v0, 11
		syscall
		j		printf_loop

printf_end:
		bgt		$t7, 0, moreArgError		# if argument counter > 0, then valid argument is more than valid conversion specifier
		blt		$t7, 0, lessArgError		# if argument counter < 0, then valid argument is less than valid conversion specifier


printf_return:
		lw		$ra, 32($sp)
		lw		$fp, 28($sp)
		lw		$s0, 24($sp)
		lw		$s1, 20($sp)
		lw		$s2, 16($sp)
		lw		$s3, 12($sp)
		lw		$s4, 8($sp)
		lw		$s5, 4($sp)
		lw		$s6, 0($sp)
		addu	$sp, $sp, 36
		jr		$ra


moreArgError:
		li 		$v0, 4
		la 		$a0, moreArgErrorMsg
		syscall								# print(moreArgErrorMsg)
		j 		printf_return


lessArgError:
		li 		$v0, 4
		la 		$a0, lessArgErrorMsg
		syscall								# print(lessArgErrorMsg)
		j 		exit


unknownArgError:
		li 		$v0, 4
		la 		$a0, unknownArgErrorMsg
		syscall								# print(unknownArgErrorMsg)
		j 		exit


exit:
		li		$v0, 10
		syscall



				.data
printf_buf:		.space 2
fmtStr:			.space 	100
fmtArg1:		.space 	100
fmtArg2:		.space 	100
fmtArg3:		.space 	100
perc:			.byte '%'
newLine:		.asciiz "\n"
newTAB:			.asciiz "		"
# prompts:
funcDeclare:	.asciiz "Function Declaration: printf(_format string_, _format argument 1 (optional)_, _format argument 2 (optional)_, _format argument 3 (optional)_\n"
promptFmtStr:	.asciiz "Enter the format string: "
promptFmtArg1:	.asciiz "Enter the format argument 1 (optional, Press ENTER to skip): "
promptFmtArg2:	.asciiz "Enter the format argument 2 (optional, Press ENTER to skip): "
promptFmtArg3:	.asciiz "Enter the format argument 3 (optional, Press ENTER to skip): "
# errors and warnings:
intErrorMsg:	.asciiz "\n** Interrupt: format argument is not valid integer. **\n** Exit with Error. **"
moreArgErrorMsg:.asciiz "\n** Warning: Data argument not used by format string. **"
lessArgErrorMsg:.asciiz "\n** Warning: More '%' conversions than data arguments. **\n** Exit with Error. **"
unknownArgErrorMsg:	.asciiz "\n**Interrupt: invalid conversion specifier. **\n** Exit with Error. **"

# End of program, leave a blank line afterwards to make MARS happy :)
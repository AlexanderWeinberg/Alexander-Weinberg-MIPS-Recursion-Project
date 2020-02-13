#My ID: 02876360 %11 = 3 +26 = Base 29

.data
user_input: .space 1001	   #makes 1000 spaces for the user input
endl: .asciiz "\n"	   #makes asciiz character for a new line
NaN_msg: .asciiz "NaN" 	   #makes asciiz NaN message
comma_msg: .asciiz ","      #makes asciiz comma character

.text

main:
li $v0,8 	      # takes in and reads input
la $a0, user_input    #puts the users input into the $a0 register
li $a1, 1001          #takes in 1000 spaces from the user input even though it says 1001 (NULL)
syscall
jal Subprogram_A      #unconditional jump to subprogram_A

continue_1:
	j print 	#jumps to print loop

#########################Subprograms##################################################
Subprogram_A:
	sub $sp, $sp,4 	#creates space in the stack by subtracting
	sw $a0, 0($sp) 	#stores user_input into the stack
	lw $t0, 0($sp) 	#stores the user_input into $t0 register
	addi $sp,$sp,4 	#moves the stack pointer four spaces up
	move $t6, $t0 	#stores the begining of the input into $t6 register
start:
	li $t2,0 	#register used to check for space or tabs within the input
	li $t7, -1 	#register used for invaild input
	lb $s0, ($t0) 	# loads the bit that $t0 is pointing to
	#beq $s0, 0, finish 	#if value is equal to zero jumps to finish loop
	beq $s0, 9, skip 	#checks if the bit is a tabs character 
	beq $s0, 32, skip 	#checks if the bit is a space character
	move $t6, $t0 		#store the valid character that is not space or tab
	j loop 			#jumps back to the beginning of the loop function

skip:			#skips the bit if its a space or tab
	addi $t0,$t0,1 	#move the $t0 to the next charracter in the string array
	j start 	#jumps to start loop
loop:
	lb $s0, ($t0) 		#loads the bit that the position of $t0 is pointing to
	beq $s0, 0, substring	#checks if bit is Null, if so goes to substring
	beq $s0, 10, substring 	#checks if bit is a new line, if so goes to substring 	
	addi $t0,$t0,1 		#move the $t0 to the next element of the string array	
	beq $s0, 44, substring 	#check if bit is comma character
check:
	bgt $t2,0,invalid_loop 		#checks if there were any spaces or tabs in between valid characters
	beq $s0, 9,  gap 		#checks if there is a tab characters
	beq $s0, 32, gap 		#checks if there is a space character
	ble $s0, 47, invalid_loop 	#checks if the ascii less than 48
	ble $s0, 57, vaild 		#checks if the ascii less than 57 for integers
	ble $s0, 64, invalid_loop 	#checks if the ascii less than 64
	ble $s0, 83, vaild		#checks if the ascii less than 83 for Capital letters
	ble $s0, 96, invalid_loop 	#checks if the ascii less than 96
	ble $s0, 115, vaild 		#checks if the ascii less than 115 for lowercase letters
	bge $s0, 116, invalid_loop 	#checks if the ascii greater than 115

gap:
	addi $t2,$t2,-1 	#adds -1 to register to keeps track of spaces and tabs 
	j loop			#jumps to loop function

vaild:
	addi $t3, $t3,1 	#adds 1 to register to keep track of how many valid characters are in the substring
	mul $t2,$t2,$t7 	#if there was a space before a this valid character it will change $t2 to a positive number
	j loop 			#jumps to the beginning of loop	

invalid_loop:
	lb $s0, ($t0) 			# loads the bit that the position $t0 is pointing to
	beq $s0, 0, insubstring		# check if the bit is Null
	beq $s0, 10, insubstring	#checks if the bit is a New line character 	
	addi $t0,$t0,1 			#move the position if $t0 to the next element of the string array	
	beq $s0, 44, insubstring 	#check if bit is a comma character
	#addi $t3, $t3,1 		#adds 1 to register to keep track of how many valid characters are in the substring
	j invalid_loop 			#jumps to the beginning of loop


insubstring:
	addi $t1,$t1,1 		#adds 1 to register to keeps track of the amount substring 	
	sub $sp, $sp,4		#subtracts room to create space in the stack
	sw $t7, 0($sp) 		#stores what was in $t6 register into the stack
	move $t6,$t0  		#store the pointer to the bit after the comma character
	lb $s0, ($t0) 		#loads the bit that $t0 position is pointing to
	beq $s0, 0, continue_1	#check if the bit is Null character
	beq $s0, 10, continue_1 #checks if the bit is a new line character
	beq $s0,44, invalid_loop#checks if the next bit is a comma character
	li $t3,0 		#resets the amount of valid characters back to 0
	li $t2,0 		#resets the space and tabs checker back to 0
	j loop			#jumps to loop function

substring:
	bgt $t2,0,insubstring 	#checks to see if there were any spaces or tabs in between valid characters
	bge $t3,5,insubstring 	#checks to see if there are more than 4 for characters
	addi $t1,$t1,1 		#adds 1 to register to track of the amount substring 	
	sub $sp, $sp,4 		# subtracts to creates space in the stack
	sw $t6, 0($sp) 		#stores what was in $t6 into the stack
	move $t6,$t0  		# store the pointer to the bit after the comma character
	lw $t4,0($sp) 		#loads the value in the stack at that posistion into $t4 register
	li $s1,0 		#sets $s1 register to 0 
	jal Subprogram_B	#jumps to Subprogram_B
	lb $s0, ($t0) 		# loads the bit that $t0 position is pointing to
	beq $s0, 0, continue_1 	# check if the bit is Null character
	beq $s0, 10, continue_1 #checks if the bit is a new line character
	beq $s0,44, invalid_loop#checks if the next bit is comma character
	li $t2,0 		#resets my space and tabs register to 0
	j loop			#jumps back up to loop
Subprogram_B:
	beq $t3,0,finish 	#check how many charcter are left to convert 
	addi $t3,$t3,-1 	#adds -1 to decreases the amount of charaters left to convert
	lb $s0, ($t4) 		#loads the bit in that position
	addi $t4,$t4,1		# moves to the next element in the string array
	j Subprogram_C 		#jumps to Subprogram_C
continue_2:
	sw $s1,0($sp)		#stores the converted number
	j Subprogram_B		#jumps to Subprogram_B
Subprogram_C:
	move $t8, $t3	   	#stores the amount of characters left to use as an exponent in register $t3
	li $t9, 1	    	#set register $t9 (which is currently 29 ) equal to 1
	ble $s0, 57, number 	#sorts the bit to the number function
	ble $s0, 84, valid_CAP	#sorts the bit to the valid_CAP function
	ble $s0, 116, valid_low	#sorts the bit to the valid_low function
number:
	sub $s0, $s0, 48	#subtracts from ascii value to convert bit to decimal
	beq $t3, 0, combine	# if there are no charaters left, the exponent is 0
	li $t9, 29		#29 for my Base-29
	j exponent		#jumps to exponent loop
valid_CAP:
	sub $s0, $s0, 55 	#converts uppercase bits
	beq $t3, 0, combine 	# if there are no charaters left, the exponent is 0
	li $t9, 29		#29 for my Base-29
	j exponent		#jumps to exponent loop
valid_low:
	sub $s0, $s0, 87 	#converts lowercase bits
	beq $t3, 0, combine 	# if there are no charaters left, the exponent is 0 
	li $t9, 29		#29 for my Base-29
	j exponent		#jumps to exponent loop
exponent:
				#raises my base to a specific exponent by muliplying itself repeatly
	ble $t8, 1, combine	#if the exponet is 1, no need to multiply the base by itself anymore
	mul $t9, $t9, 29 	# multpling base by itself to simulate raising the number to a power
	addi $t8, $t8, -1	# adding -1 to decrease the exponent
	j exponent		#jumps to exponent loop
combine:
	mul $s2, $t9, $s0	#multiplied the converted bit and base raised to a power
	add $s1,$s1,$s2		# adding the coverted numbers together to get actual output 
	j continue_2		#jumps too continue_2 loop
finish : jr $ra			#jumps back to substring

print:
	mul $t1,$t1,4 		#multiply $t1 register to get the amount of space needed to move sp to the beginning of stack
	add $sp, $sp $t1 	#adding register to sp to move the stack pointer to the beginning of the stack	
done:	
	sub $t1, $t1,4		#keeping track of amount of elements left
	sub $sp,$sp,4 		#moving the sp to the next element	
	lw $s7, 0($sp)		#storing that value into register $s7
	beq $s7,-1,invalidprint #checks to see if element is invalid	
	li $v0, 1
	lw $a0, 0($sp)		 #prints element from stack
	syscall
comma:
	beq $t1, 0,Exit 	#if there are no elements left it exits the program
	li $v0, 4
	la $a0, comma_msg 	#prints the comma_msg
	syscall
	j done
invalidprint:
	li $v0, 4
	la $a0, NaN_msg 	#prints naN_msg
	syscall	
	j comma 		#jumps to print a comma
Exit:
	li $v0, 10		# exits program
	syscall
#############################################################################


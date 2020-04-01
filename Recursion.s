#My ID: 02876360 %11 = 3 +26 = Base 29

.data
user_input: .space 101	   #makes 1000 spaces for the user input
endl: .asciiz "\n"	   #makes asciiz character for a new line
invalid_msg: .asciiz "Invalid input" 	   #makes asciiz invalid input message


.text
.globl main 
main:
li $v0,8 	      # takes in and reads input
la $a0, user_input    #puts the users input into the $a0 register
syscall
li $t0, 32					#allocating space into $t3
li $t1, 0					#setting counter i = 0					
li $s0, 0					#counter to keep track of previous character. initialized at 0
la $t3, user_input				#loading userInput address into register
li $t4, 0					#number of characters = 0
li $t5, 10					#loaded new line into $t5
li $t6, 0					#second counter to track number of spaces before actual input

LoopingFunction:
lb $t7, 0($t3)				#gets string input
beq $t7, $t5, breakFunction			#breaks if character is a newline character

#branch instructions for different conditions

beq $t7, $t0, skip_Spaces        #if mycharacter is not a space and...
bne $s0, $t0, skip_Spaces        #if the previous checked character is a space and..
beq $t4, $0, skip_Spaces         #if the number of previously checked characters are not zero and..
beq $t7, $0, skip_Spaces         #character is not null and..
beq $t7, $t5, skip_Spaces        #the character is not a new line then proceed else skip to the skip_Spaces label
	
#if input is invalid_msg && invalid_msg, choose invalid_msg 
		
sub $t3, $t1, $t6								
addi $t3, $t3, 1		 #increments register by 1
li $t7, 4										
ble $t3, $t7, inValidFunction     		
li $v0, 4
la $a0,invalid_msg		
syscall									
jr $ra	

inValidFunction:
li $v0, 4
la $a0, invalid_msg
syscall			
li $v0, 10
syscall
		
skip_Spaces:
beq $t7, $t0, spaceFunc		#branch if the current character is a space otherwise continue
addi $t4, $t4, 1		#number of characters + 1

spaceFunction:
bne $t7, $t0, spaceCounterFunction	#checks if current character is a space
bne $t4, $0, spaceCounterFunction			
addi $t6, $t6, 1
		
spaceCounterFunction:
move $s0, $t7				#sets previous character to the current one
addi $t3, $t3, 1			#increments the address
addi $t1, $t1, 1			#increments i
j LoopingFunction

breakFunction:
li $t7, 4
ble $t4, $t7, longInputFunction			#checks if userInput is greaterthan 4
li $v0, 4
la $a0, invalid_msg
syscall						#print invalid_msg_error if character is greater than4
li $v0, 10
syscall
		
longInputFunction: 
bne $t4, $zero, emptyStringFunction   		#checks if user input is empty
beq $t7, $t5, emptyStringFunction     		#checks if the user input is a newline
li $v0, 4
la $a0, invalid_msg
syscall
li $v0, 10
syscall


emptyStringFunction:
la $s0, user_input
add $s0, $s0, $t6			#gets the address of the start of the number
addi $sp, $sp, -4			#allocate 4 points space
sw $ra, 0($sp)						
addi $sp, $sp, -8		
sw $s0, 0($sp)				#sets address of start of the number
sw $t4, 4($sp)				#sets length of the number
jal conversionFunction




###########################################################################

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


#############################################################################


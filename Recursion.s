#My ID: 02876360 % 11 = 3 +26 = Base 29

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
beq $t7, $t0, spaceFunction		#branch if the current character is a space otherwise continue
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
lw $t3, 0($sp)
addi $sp, $sp, 4		
li $v0, 1									
move $a0, $t3
syscall					#displays result		
lw $ra, 0($sp)				#restores return address
addi $sp, $sp, 4						
jr $ra

conversionFunction:
lw $a0, 0($sp)
lw $a1, 4($sp)
addi $sp, $sp, 8	
addi $sp, $sp, -20							
sw $ra, 0($sp)								
sw $s0, 4($sp)				#s0 is used for the address of array			
sw $s1, 8($sp)							
sw $s2, 12($sp)
sw $s3, 16($sp)								
move $s0, $a0							
move $s1, $a1		
li $t3, 1
bne $s1, $t3, PassFunction		#checks if length is equal 1
lb $t7, 0($s0)				#loads the first element of the array
move $a0, $t7				#sets the character to the argument for character to Decimal function
jal char_to_Decimal
move $t7, $v0				#gets result	
move $t3, $t7				#sets the first element into $t3, before it's returned
j conversion_Exit


PassFunction:
addi $s1, $s1, -1								
move $a0, $s1			#sets arguments for exponentFunction
jal exponentFunction
move $s3, $v0								
lb $t3, 0($s0)			#loads the first element of the array for use
move $a0, $t3
jal char_to_Decimal
move $t3, $v0
mul $s2, $t3, $s3
addi $s0, $s0, 1              #increments pointer to the start of the array
addi $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)
jal conversionFunction
lw $t3, 0($sp)
addi $sp, $sp, 4		
add $t3, $s2, $t3		#conversion results plus the first number and returns the value into $t3

conversion_Exit:
lw $ra, 0($sp)								
lw $s0, 4($sp)						
lw $s1, 8($sp)								
lw $s2, 12($sp)							
lw $s3, 16($sp)
addi $sp, $sp, 20							
addi $sp, $sp, -4
sw $t3, 0($sp)
jr $ra


exponentFunction:
addi $sp, $sp, -4			#allocates 4 points of space
sw $ra, 0($sp)				#stores returning address		
li $t3, 0
bne $a0, $t3, Ignore_zero_expo
li $v0, 1
j leave_num_power
 
Ignore_zero_expo:
addi $a0, $a0, -1			#setting up argument for recursion 
jal exponentFunction
move $t7, $v0
li $t1,29									
mul $v0, $t1, $t7			#puts a multiplied result into $v0

leave_num_power:
lw $ra, 0($sp)			#restores address
addi $sp, $sp, 4						
jr $ra
		
char_to_Decimal:		
li $t1, 65
li $t0, 90
blt $a0, $t1, skip_converting_CAP_to_digital	 # checks if ascii of char >= 65 
bgt $a0, $t0, skip_converting_CAP_to_digital	#checks if char <= 85
addi $a0, $a0, -55				#subtract 55 to get the decimal equivalent of A-S
move $v0, $a0									
jr $ra

skip_converting_CAP_to_digital:
li $t1, 97												
li $t0, 121					#checks least and largest ascii value for lowercase a - y
blt $a0, $t1, skip_converting_lower_to_digital	#checks if value >= 85 
bgt $a0, $t0, skip_converting_lower_to_digital	#checks if value <= 117
addi $a0, $a0, -87										
move $v0, $a0
jr $ra


skip_converting_lower_to_digital:
li $t1, 48													
li $t0, 57					#checks least and largest ascii value for integers 0-9
blt $a0, $t1, skip_converting_digital_to_integer#converts if asczii >= 48 
bgt $a0, $t0, skip_converting_digital_to_integer#checks if asccii <= 57
addi $a0, $a0, -48				#gets the decimal value of the ascii number
move $v0, $a0
jr $ra	

skip_converting_digital_to_integer:	
li $v0, 4
la $a0, invalid_msg
syscall
li $v0, 10
syscall




.data
InputString: .space 21
GetUserInput: .asciz "Please enter a string: "
Output: .asciz "Hash value for the string is: "
NL: .asciz "\n"
.text

main:
	la a0, GetUserInput   # prompts user to input a string
	addi a7, zero, 4
	ecall
	
	
	la a0, InputString    # load address of the place in memory of where to keep the string
	addi a1, zero, 21     # define how long the string can be
	addi a7, zero, 8      # 8 means read string from console
	ecall                 # waiting for user input
	
	
	addi s2, x0, 0        # going to use this as i in the loop
	add s0, zero, zero    # where we are storing the summation
	addi t0, zero, 10     # ascii value of newline
	add s3, a0, zero      # put the string address into s3
	add s4, zero, zero    # variable for output number
	add s5, zero, zero    # length of string
	add s6, zero, zero
	
	
L1:                                                                     #this just checks the length of the string
	lb a0, (s3)           # load current character into a0
	addi s4, s4, 1        # add one to length of string
	
	beq a0, t0, Fin    # break if the string is empty
	
	addi s3, s3, 1        # move to next character in the string
	lb a0, (s3)               
	bne a0, t0, L1        # if there is newline, break
	
la s3, InputString     # reset variables
add s6, s3, zero
add s2, zero, zero

L2:
	add s5, zero, zero    # variable for (n-i-1)
	lb a0, (s3)           # load current character into a0 
	
	sub s5, s4, s2        # stuff for summation  n-i
	addi s5, s5, -1       # (n-i)-1
	add s5, s5, s6        # address of s[n-i-1] NOT
	lb s5, (s5)
	mul s5, s5, a0
	
	add s0, s0, s5
	
	addi s3, s3, 1        # move to next character in the string
	addi s2, s2, 1        # increment i
	lb a0, (s3)
	bne a0, t0, L2        # if there is newline, break

		
la a0, Output
addi a7, zero, 4      # print the hash code:
ecall


add a0, zero, s0
addi a7, zero, 1     # print actual value
ecall

la a0, NL            # print newline
addi a7, zero, 4
ecall


jal zero, main

Fin:
la a0, Output
addi a7, zero, 4    #same stuff as above but for when the input is nothing
ecall


add a0, zero, s0
addi a7, zero, 1
ecall

main:

.data
	baseInput: .space 40     # ten words, probably dont need that much but whatever
	numberInput: .space 40   # ten words
	translated: .space 40     # translated ascii values for calulation
	basePrompt: .asciz "Please enter the base of the number you are using (0 to exit): "
	numberPrompt: .asciz "Please enter the value: "
	givenValue: .asciz "The given value in base 10 is: "
	newLine: .asciz "\n"
	badInputPrompt: .asciz "The value entered is not valid for the base entered \n"
.text


# a0 is the userBase
addi s6, zero, 0
addi s4, zero, 0          # to keep track of negatives
addi s3, zero, 0
addi s2, zero, 0
addi s1, zero, 0
addi a1, zero, 0	  # something isnt working so I am just resetting everything, just in case
addi a2, zero, 0
addi a3, zero, 0
addi a4, zero, 0
addi t0, zero, 0
addi t1, zero, 0
addi t2, zero, 0
addi t3, zero, 0

la a0, translated
sw t3, 0(a0)     # this is  to clear out the label, because that doesnt happen if i re-declare it?

addi a0, zero, 100        # make it large at first so we can loop
addi t0, zero, 36         # base must be less than this
addi t1, zero, 2	  # to make sure that it is 2 or greater


keepGettingBase:
	jal ra, getBase      # returns the base in a0
	
	beq a0, x0, exit     # if the input was zero, then leave the program
	blt a0, t1, keepGettingBase  # make sure that it is in the bounds
	bgt a0, t0, keepGettingBase
	
# by this point, we should have a suitable base
add s1, a0, zero   # move the base into s1 just in case
la t0, baseInput
sw a0, 0(t0)       # also save it at the label, just in case

jal ra, getValue    # just get the value. we aren't gonna do any error checking right here
add s2, a0, zero    # move the value to s2 just in case

jal ra, strlen      # get the length of the input. useful because we have to parse through it backwards
addi s3, a0, 0    # set the length of the string to s3

jal ra, translateFromASCII # just run everything, pretty self explanitory

blt a0, x0, main

jal ra, translateValue

jal ra, printResult

beq x0, x0, main # repeat




getBase: # get input from the user.

	la a0, basePrompt    # load the prompt
	li a7, 4            # syscall to print
	ecall
	
	li a7, 5  # read integer
	ecall
	
	jalr zero, ra, 0

getValue:

	la a0, numberPrompt    # load the prompt
	li a7, 4            # syscall to print
	ecall
	
	la a0, numberInput
	li a7, 8     # read string i think is what i need to do
	li a1, 10    # dont read more than 10 characters
	ecall
	
	jalr zero, ra, 0

printResult:

	la a0, givenValue # print prompt
	li a7, 4
	ecall
	
	li s6, 1
	bne s4, s6, isPositive # if its positive, dont make negative lol
	li s6, -1
	mul a3, a3, s6
	
	isPositive:
	add a0, zero, a3    # load the prompt
	li a7, 1            # syscall to print
	ecall
	
	la a0, newLine      # space it out a little
	li a7, 4
	ecall
	ecall               # print a second time


translateValue:

	add a3, zero, zero     # where I am going to store the output
	la t0, translated
	addi a1, zero, 0   # going to use to count, also the power!!!!
	loop3:
		lb a0, 0(t0)   # load current element in the string
		#li a7, 1     # read string i think is what i need to do
		#ecall
		#a1 = power, a0 = number, a2 = output
		beq x0, x0, pow   # go get the power. didnt want to use the stack here and it worked.
		comeBack:
		
		mul a2, a2, a0 # n = n*base^(place)
		
		add a3, a3, a2 # add to sum
		
		addi t0, t0, 1   # increment to next element
		addi a1, a1, 1
		bne t3, a1, loop3 # repeat until all each digit is done
	add a0, a1, zero
	jalr zero, ra, 0


strlen:
	la t0, numberInput
	addi a1, zero, 0   # going to use to count
	addi t3, zero, 10
	loop1:
		lb a0, 0(t0)   # load current element in the string
		#li a7, 1     # read string i think is what i need to do
		#ecall
		addi t0, t0, 1   # increment to next element
		addi a1, a1, 1
		lb a0, 0(t0)      # make sure we arent equal to 10, because that happens when it is over
		bne a0, t3, loop1
	add a0, a1, zero   # return in a0
	jalr zero, ra, 0


pow:

	addi t4, zero, 0    # t4 is how I keep track of the loop
	addi a2, zero, 1
	beq a1, zero, comeBack   # since I cant really do math with a zero, we are just gonna return 1
	
	powLoop:
	
	mul a2, a2, s1    # just keep multiplying until the counter hits the power requested
	addi t4, t4, 1
	blt t4, a1, powLoop
	
	beq x0, x0, comeBack # go back to the other func
	

translateFromASCII:

	la t0, numberInput   # where they currently are
	la t1, translated    # where I am storing my numbers in actual integer form
	add t0, t0, s3        # going to the end of the array
	addi t0, t0, -1       # to account for negatives
	addi a1, zero, 0   # going to use to count
	addi t3, s3, 0     # just so I dont accidentally overwrite it
	
	addi t4, t3, -1 # for looking for negatives
	loop2:
		lb a0, 0(t0)   # load current element in the string
		
		# convert from ascii to int
		# if curNum is betweenn 48 and 57: subtract 48
		
		# if curNum is between 97 and 122, subtract 87
		# else, return something wrong.
		
		addi t2, zero, 48   # make sure in bounds
		blt a0, t2, badInput
		
		addi t2, zero, 57 # make sure in bounds
		bgt a0, t2, notInt
		
		#now, the current thing is actually an int, so lets convert
		
		addi a0, a0, -48     # convert to real value
		beq x0, x0, doneAdding
		
		
		notInt: #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		
		addi t2, zero, 65   # make sure in bounds
		blt a0, t2, badInput
		
		addi t2, zero, 90    # make sure in bounds
		bgt a0, t2, notCap
		
		#now, the current thing is actually a capitol, so lets convert
		
		addi a0, a0, -55     # convert to real value
		beq x0, x0, doneAdding
		
		
		
		notCap: #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		
		addi t2, zero, 97     # make sure in bounds
		blt a0, t2, badInput
		
		addi t2, zero, 122     # make sure in bounds
		bgt a0, t2, badInput
		
		
		
		# now we should have a letter:
		addi a0, a0, -87     # convert to real value
		beq x0, x0, doneAdding
		
		badInput: # something is wrong. it is either a negative number or has a symbol in it
		
		addi t5, zero, 45 # negative sign is 45 in ascii
		
		
		bne a0, t5, throwCode   # if its not a negative, throw hands
		#li a7, 1     # print int for testing
		#ecall
		bne a1, t4, throwCode  # if it is a negative, make sure its in the right place in the number. otherwise throw hands 
		
		
		addi s4, zero, 1  
		addi t1, t1, 1
		beq x0, x0, skipAdd  # we are done with the number, so make sure we dont write back to the translation
		
		
		doneAdding:
		bge a0, s1, badInput     # if the translation is greater than the base, error out
		sb a0, 0(t1)      # put into new array
		addi t1, t1, 1    # increment backwards in the ogirinal array
		
		#li a7, 1     # print int for testing
		#ecall
		addi t0, t0, -1   # increment to next element
		addi a1, a1, 1    # increment counter
		lb a0, 0(t0)      # load new - dont need anymore prob
		blt a1, t3, loop2  # meaning the thing is done
	skipAdd:
	add a0, a1, zero
	jalr zero, ra, 0

throwCode:
	la a0, badInputPrompt
	li a7, 4
	ecall
	addi a0, zero, -1   # to signify that we need to restart
	jalr zero, ra, 0
	


exit:
li a7, 10 # close cleanly
ecall

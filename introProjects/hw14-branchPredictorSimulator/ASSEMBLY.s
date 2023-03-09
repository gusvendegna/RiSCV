.globl branchPredictionSim

branchPredictionSim: 
	# a2 is address of list
	# a3 is number of elements in the list
	
	# return a0
	# return a1 as number of elements
	
	addi t0, zero, 0 # set t0 = to 0 for the counter
	addi t1, zero, 0 # t1 = the current state
	addi s1, zero, 1
	addi s2, zero, 2 # assign these values for easy use later
	addi s3, zero 3
	la a0, predictions # load first element of predictions list
	
	loop:
	beq t1, x0, appendOne # if curState == 0 or curState == 1
	beq t1, s1, appendOne # if state = 0 or 1, append a 1, 
	beq x0, x0, appendTwo # else just append a 2
	

	changeState:
	addi a0, a0, 4 # move to the next location in predictions
	
	lw t2, 0(a2)  # load current index value of the actual branches
	bne t2, s1, dontSub # if i == 1 and curState != 0, backwards
	beq t1, x0, dontSub
	
	addi t1, t1, -1 # curState -= 1
	beq x0, x0, dontAdd # what makes it an else statement
	dontSub:
	
	bne t2, s2, dontAdd # elif i == 2 and curState != 3, backwards
	beq t1, s3, dontAdd
	
	addi t1, t1, 1 # curState += 1
	
	dontAdd:
	
	addi a2, a2, 4 # increment the actual branch list
	addi t0, t0, 1 # increment location in the list
	
	bne t0, a3, loop # if we are not at the end of the list, do it again
	
	la a0, predictions # set a0 back to the start of the list
	add a1, zero, a3   # make the counts the same
	
	
	jalr zero, ra, 0 # go back to main
	
	
	appendOne:
		sw s1, 0(a0) # save a 1 in the prediction array
		beq x0, x0, changeState # return to the loop
	appendTwo:
		sw s2, 0(a0) # save a 2 in the prediction array
		beq x0, x0, changeState # return to the loop
		
	

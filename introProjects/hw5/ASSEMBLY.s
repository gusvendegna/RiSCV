.text

.globl sum
sum:
	add a0, zero, zero # initialize a0 equal to 0
	LoopSum:
	lw t1, 0(a2)     # load number from array into t1
	addi a2, a2, 4   # point to next element in array
	addi a3, a3, -1  # one less element remaining in array

	add a0, a0, t1   # add em up

	bne a3, zero, LoopSum  # if num of elements remaining != 0, loop, else jump back
	jalr zero, ra, 0

.globl prod
prod:
	addi a0, zero, 1 # initialize a0 equal to 1, not zero!!!
	LoopProd:
	lw t1, 0(a2)     # load number from array into t1
	addi a2, a2, 4   # point to next element in array
	addi a3, a3, -1  # one less element remaining in array

	mul a0, a0, t1     # multiply

	bne a3, zero, LoopProd  # if num of elements remaining != 0, loop, else jump back
	jalr zero, ra, 0        # return


.globl max
max:
	addi a0, zero, 2047      # For some reason, I cant make it larger than this. (what I am comparing)
	addi t1, zero, -1        # so we can make a0 negative
	mul a0, a0, a0           # must be something with the immediates. I can just square the number to cover way more
	mul a0, a0, t1
	add t1, a0, zero         # so it doesnt trigger first time
	
	newGreatest:        # this will run if the current index is greater than a0
	add a0, t1, zero
	LoopMax:
	bgt t1, a0, newGreatest      # if current item in array is greater than the current greatest, jump
	
	lw t1, 0(a2)     # load number from array into t1
	addi a2, a2, 4   # point to next element in array
	addi a3, a3, -1  # one less element remaining in array

	bne a3, zero, LoopMax  # if num of elements remaining != 0, loop, else jump back
	jalr zero, ra, 0	# return
	
	
	
	
	

.globl mult
mult:

#mul a0, a1, a2
#jalr zero, ra, 0

#test product @ 0 if its equal to 1

# t0 = counter
# t1 = 32

addi t0, zero, 0 # using t0 as counter
addi t1, zero, 32 # up to 32 digits. Code technically only runs when less than 32
add a0, zero ,zero # a2 seemed to have 2 in it already, but I want that to be equal to zero

thirtyTwoLoop:
andi t2, a2, 1              # t2 = LSB of porduct combination (so actuall the multiplicand
beq t2, x0, ProdZeroIsZero # if product0 = 0, skip the next part

add a0, a0, a1 # left half of multiplicand = LHoM + multiplicand


ProdZeroIsZero:
# shift the product register right 1 bit
andi t2, a0, 1    # save LSB of a0
srli a0, a0, 1    # shift a0, upper 32 of product register
slli t2, t2, 31   # put LSB of a0 in MSB
srli a2, a2, 1    # shift s2 right


add a2, a2, t2    # combine for new a2, since we are treating like 1 register

addi t0, t0, 1    # increment t0
bne t0, t1, thirtyTwoLoop #see if we are done yet

add a0, zero, a2 # put the lower half into the return register

jalr zero, ra, 0  # return back to grader script




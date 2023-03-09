.data         # declare and initialize variables
hello:  .asciz  "Hello World"

.text        # code starts here
main:           # label marking the entry point of the program
  addi a0, zero,   # load the address of hello into $a0 (1st argument)
  addi a7, zero, 1     # code to print the string at the address a0
  ecall         # make the system call
 
  addi a7, zero, 10    # code to exit
  ecall     

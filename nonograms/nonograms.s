########################################################################
# COMP1521 24T3 -- Assignment 1 -- Nonograms!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/24T3/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Qiucheng Mi (z5528810)
# on 06/10/2024
#
# Version 1.0 (2024-09-25): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# ##########################################################
# ####################### Constants ########################
# ##########################################################

# C constants

TRUE = 1
FALSE = 0

MAX_WIDTH = 12
MAX_HEIGHT = 10

UNMARKED = 1
MARKED = 2
CROSSED_OUT = 3

# Other useful constants (feel free to add more if you want)

SIZEOF_CHAR = 1
SIZEOF_INT = 4

CLUE_SET_VERTICAL_CLUES_OFFSET = 0
CLUE_SET_HORIZONTAL_CLUES_OFFSET = CLUE_SET_VERTICAL_CLUES_OFFSET + SIZEOF_INT * MAX_WIDTH * MAX_HEIGHT
SIZEOF_CLUE_SET = CLUE_SET_HORIZONTAL_CLUES_OFFSET + SIZEOF_INT * MAX_HEIGHT * MAX_WIDTH

	.data
# ##########################################################
# #################### Global variables ####################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE         !!!
# !!! DEFINITIONS OR ANY OTHER PART OF THE DATA SEGMENT  !!!

width:					# int width;
	.word	0

height:					# int height;
	.word	0

selected:				# char selected[MAX_HEIGHT][MAX_WIDTH];
	.byte	0:MAX_HEIGHT*MAX_WIDTH

solution:				# char solution[MAX_HEIGHT][MAX_WIDTH];
	.byte	0:MAX_HEIGHT*MAX_WIDTH

	.align	2
selection_clues:			# struct clue_set selection_clues;
	.byte	0:SIZEOF_CLUE_SET

solution_clues:				# struct clue_set solution_clues;
	.byte	0:SIZEOF_CLUE_SET

displayed_clues:			# struct clue_set *displayed_clues;
	.word	0

# ##########################################################
# ######################### Strings ########################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THE      !!!
# !!! STRINGS OR ANY OTHER PART OF THE DATA SEGMENT !!!

str__main__height:
	.asciiz	"height"
str__main__width:
	.asciiz	"width"
str__main__congrats:
	.asciiz	"Congrats, you won!\n"

str__prompt_for_dimension__enter_the:
	.asciiz	"Enter the "
str__prompt_for_dimension__colon:
	.asciiz	": "
str__prompt_for_dimension__too_small:
	.asciiz	"error: too small, the minimum "
str__prompt_for_dimension__is:
	.asciiz	" is "
str__prompt_for_dimension__too_big:
	.asciiz	"error: too big, the maximum "

str__read_solution__enter_solution:
	.asciiz	"Enter solution: "

str__read_solution__loaded:
	.asciiz	"Loaded "
str__read_solution__solution_coordinates:
	.asciiz	" solution coordinates\n"

str__make_move__enter_first_coord:
	.asciiz	"Enter first coord: "
str__make_move__enter_second_coord:
	.asciiz	"Enter second coord: "
str__make_move__bad_input:
	.asciiz	"Bad input, try again!\n"
str__make_move__enter_choice:
	.asciiz	"Enter choice (# to select, x to cross out, . to deselect): "

str__print_game__printing_selection:
	.asciiz	"[printing counts for current selection rather than solution clues]\n"

str__dump_game_state__width:
	.asciiz	"width = "
str__dump_game_state__height:
	.asciiz	", height = "
str__dump_game_state__selected:
	.asciiz	"selected:\n"
str__dump_game_state__solution:
	.asciiz	"solution:\n"
str__dump_game_state__clues_vertical:
	.asciiz	"displayed_clues vertical:\n"
str__dump_game_state__clues_horizontal:
	.asciiz	"displayed_clues horizontal:\n"

str__get_command__prompt:
	.asciiz	" >> "
str__get_command__bad_command:
	.asciiz	"Bad command\n"

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!
# !!! If you add more strings you will likely break the     !!!
# !!! autotests and automarking.                            !!!


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions, and check these boxes as you finish
# implementing each function.
#
#  SUBSET 1
#  - [ ] main
#  - [ ] prompt_for_dimension
#  - [ ] initialise_game
#  - [ ] game_loop
#  SUBSET 2
#  - [ ] decode_coordinate
#  - [ ] read_solution
#  - [ ] lookup_clue
#  - [ ] compute_all_clues
#  SUBSET 3
#  - [ ] make_move
#  - [ ] print_game
#  - [ ] compute_clue
#  - [ ] is_game_over
#  PROVIDED
#  - [X] get_command
#  - [X] dump_game_state


################################################################################
# .TEXT <main>
        .text
main:
	# Subset:   1
	#
	# Frame:    Main function sets up the game, prompts for the board dimensions,
	#           initializes the game, reads the solution, and starts the game loop.
	# Uses:     $a0, $a1, $a2, $a3 for passing arguments to functions, $v0 for system calls
	# Clobbers: $ra (return address register)
	#
	# Locals:   Uses $a0, $a1, $a2, $a3 for passing arguments. Temporarily holds user inputs for height and width.
	#   - height, width (global variables)
	#
	# Structure: 
	#   main
	#   -> [prologue]       (save return address)
	#     -> body           (calls prompt_for_dimension, initialise_game, read_solution, game_loop)
	#   -> [epilogue]       (restore return address and return)

main__prologue:
	begin
	push	$ra	# Save return address onto the stack
main__body:
	la	$a0, str__main__height   # Load address of the "height" prompt string
	li	$a1, 3                   # Min height is 3
	li	$a2, MAX_HEIGHT          # Max height is MAX_HEIGHT (constant)
	la	$a3, height              # Load address of global variable 'height'
	jal	prompt_for_dimension     # Call prompt_for_dimension function

	la	$a0, str__main__width    # Load address of the "width" prompt string
	li	$a1, 3                   # Min width is 3
	li	$a2, MAX_WIDTH           # Max width is MAX_WIDTH (constant)
	la	$a3, width               # Load address of global variable 'width'
	jal	prompt_for_dimension     # Call prompt_for_dimension function

	jal	initialise_game          # Initialize the game grid (selected and solution arrays)

	jal	read_solution            # Load the solution grid from user input

	li	$a0, '\n'                # Print a new line
	li	$v0, 11                  # Syscall to print a character
	syscall

	jal	game_loop                # Start the game loop

	li	$v0, 4                   # Syscall to print string
	li	$a0, str__main__congrats  # Load address of "Congrats" message
	syscall


main__epilogue:
	pop	$ra
	end
	jr      $ra	# Return to the caller


################################################################################
# .TEXT <prompt_for_dimension>
        .text
prompt_for_dimension:
	# Subset:   1
	# Frame:    Prompts the user for a dimension, validates the input, and stores it in the provided memory location.
	# Uses:     $a0, $a1, $a2, $a3
	# Clobbers: $t0, $t1, $t2, $t3, $t4
	#
	# Locals:   $t0 = user input, $t1 = string name, $t2 = min, $t3 = max, $t4 = pointer to store result
	#   - Reads input from the user and ensures it falls between the min and max values.
	#
	# Structure:
	#   prompt_for_dimension
	#   -> [prologue]    (set up local registers and arguments)
	#     -> body        (loop to prompt user, validate input, and repeat if necessary)
	#   -> [epilogue]    (store result and return)

prompt_for_dimension__prologue:
	move	$t1, $a0        # $t1 = name (height/width)
	move	$t2, $a1        # $t2 = min value
	move	$t3, $a2        # $t3 = max value
	move	$t4, $a3        # $t4 = pointer to store result

prompt_for_dimension__body_whileloop_true_condition:
	# Print "Enter the <dimension>:"
	li	$v0, 4          
	li	$a0, str__prompt_for_dimension__enter_the  
	syscall

	li	$v0, 4          
	move 	$a0, $t1        
	syscall
	
	li	$v0, 4           # Syscall to print colon ":"
	li	$a0, str__prompt_for_dimension__colon
	syscall

	# Get user input
	li	$v0, 5           
	syscall
	move	$t0, $v0        # $t0 = user input

prompt_for_dimension__body_whileloop_true_condition__if_cond:
	# Check if input is greater than or equal to min value
	bge	$t0, $t2, prompt_for_dimension__body_whileloop_true_condition__elseif_cond  # If input >= min, check the next condition

prompt_for_dimension__body_whileloop_true_condition__if_body:
	# Input is less than the minimum value
	li	$v0, 4           
	li	$a0, str__prompt_for_dimension__too_small
	syscall

	li	$v0, 4           # Print the dimension name (height/width)
	move	$a0, $t1
	syscall

	li	$v0, 4           # Print " is "
	la	$a0, str__prompt_for_dimension__is
	syscall

	li	$v0, 1           # Print the minimum value
	move	$a0, $t2        # $t2 = minimum value
	syscall

	li	$a0, '\n'        # Print newline
	li	$v0, 11
	syscall

	# Go back to start of the loop for another input
	b	prompt_for_dimension__body_whileloop_true_condition 

prompt_for_dimension__body_whileloop_true_condition__elseif_cond:
	# Check if input is less than or equal to max value
	ble	$t0, $t3, prompt_for_dimension__body_whileloop_true_condition__if_else  # If input <= max, accept the input

prompt_for_dimension__body_whileloop_true_condition__elseif_body:
	# Input is greater than the maximum value
	li	$v0, 4           # Syscall to print "error: too big"
	li	$a0, str__prompt_for_dimension__too_big
	syscall

	li	$v0, 4           # Print the dimension name (height/width)
	move    $a0, $t1
	syscall

	li	$v0, 4           # Print " is "
	la	$a0, str__prompt_for_dimension__is
	syscall

	li	$v0, 1           # Print the maximum value
	move	$a0, $t3        # $t3 = maximum value
	syscall

	li	$a0, '\n'        # Print newline
	li	$v0, 11
	syscall

	# Go back to start of the loop for another input
	b	prompt_for_dimension__body_whileloop_true_condition 

prompt_for_dimension__body_whileloop_true_condition__if_else:
	# Input is valid, store the result
	b	prompt_for_dimension__body_whileloop_true_end  

prompt_for_dimension__body_whileloop_true_end:
	# Store the valid input in the provided memory location
	sw	$t0, ($t4)       # Store the valid input at the address $t4 points to
	b	prompt_for_dimension__epilogue  # Go to epilogue

prompt_for_dimension__epilogue:
	jr      $ra           


################################################################################
# .TEXT <initialise_game>
        .text
initialise_game:
	# Subset:   1
	# Frame:    This function initializes the game grid by marking all positions as UNMARKED.
	# Uses:     $t0, $t1, $t2, $t3, $t4, $t5
	# Clobbers: $t0-$t5 (temporaries used for loops and calculations)
	#
	# Locals:   $t0 = row index, $t1 = height, $t2 = column index, $t3 = width, $t4 = 1D index for array access, $t5 = UNMARKED
	#   - Loops over each row and column of the grid, marking all cells as UNMARKED.
	#
	# Structure:
	#   initialise_game
	#   -> [prologue]    (initialize loop variables)
	#     -> body        (nested loops for row and column to initialize grid)
	#   -> [epilogue]    (return)

initialise_game__prologue:

initialise_game__body:

initialise_game__body_forloop_row_less_height_init:
	li	$t0, 0              # Initialize row index
initialise_game__body_forloop_row_less_height_cond:
	lw	$t1, height         # Load height 
	bge	$t0, $t1, initialise_game__body_forloop_row_less_height_end  # If row >= height, end outer loop

initialise_game__body_forloop_row_less_height_body:


initialise_game__body_forloop_row_less_height_body__for_col_less_width_init:
	li	$t2, 0              # Initialize column index
initialise_game__body_forloop_row_less_height_body__for_col_less_width_cond:
	lw	$t3, width          # Load width
	bge	$t2, $t3, initialise_game__body_forloop_row_less_height_body__for_col_less_width_end  # If col >= width, end inner loop

initialise_game__body_forloop_row_less_height_body__for_col_less_width_body:
	# Calculate the 1D index for the selected and solution arrays
	mul	$t4, $t0, MAX_WIDTH # $t4 = row * MAX_WIDTH
	add	$t4, $t4, $t2       # $t4 = row * MAX_WIDTH + col 
	# Set selected[row][col] and solution[row][col] to UNMARKED
	li	$t5, UNMARKED       # Load UNMARKED constant
	sb	$t5, selected($t4)  # selected[row][col] = UNMARKED
	sb	$t5, solution($t4)  # solution[row][col] = UNMARKED

initialise_game__body_forloop_row_less_height_body__for_col_less_width_step:
	addi	$t2, $t2, 1        # Increment column index
	b	initialise_game__body_forloop_row_less_height_body__for_col_less_width_cond  # Repeat inner loop for the next column

initialise_game__body_forloop_row_less_height_body__for_col_less_width_end:

initialise_game__body_forloop_row_less_height_step:
	addi	$t0, $t0, 1       
	b	initialise_game__body_forloop_row_less_height_cond  # Repeat outer loop for the next row

initialise_game__body_forloop_row_less_height_end:

initialise_game__epilogue:
	jr      $ra             

################################################################################
# .TEXT <game_loop>
        .text
game_loop:
	# Subset:   1
	#
	# Frame:    The main loop of the game, where the game status is repeatedly checked,
	#           the current state of the game is displayed, and user input is handled.
	# Uses:     $a0, $a1, $v0
	# Clobbers: $ra, $v0, $a0,$a1
	#
	# Locals:   None 
	#   - Continuously checks if the game is over, processes commands, and updates the game state.
	#
	# Structure:
	#   game_loop
	#   -> [prologue]    (save return address)
	#     -> body        (loop to check game status, print game, handle input, compute clues)
	#   -> [epilogue]    (restore return address and return)

game_loop__prologue:
	push	$ra               # Save return address onto the stack

game_loop__body:


game_loop__body_forloop_isnotover_cond:
	jal	is_game_over      
	bnez 	$v0, game_loop__epilogue  # If the game is over ($v0 != 0), jump to epilogue

game_loop__body_forloop_isnotover_body:
	# Print the current game state
	la	$a0, selected      # Load address of the selected grid
	jal	print_game        
	
	jal	get_command       

	# Compute the clues based on the current selection
	la	$a0, selected      # Load address of the selected grid
	la	$a1, selection_clues  # Load address of the selection clues
	jal	compute_all_clues 

game_loop__body_forloop_isnotover_end:
	b	game_loop__body_forloop_isnotover_cond  # Loop back to check game status again

game_loop__epilogue:
	# Final display of the game state
	la	$a0, selected      # Load address of the selected grid
	jal	print_game  

	pop	$ra              
	jr      $ra                


################################################################################
# .TEXT <decode_coordinate>
        .text
decode_coordinate:
	# Subset:   2
	#
	# Frame:    This function decodes a coordinate by checking if the input is within a valid range.
	#           If the input is valid, it calculates and returns the decoded coordinate.
	# Uses:     $a0, $a1, $a2,$a3
	# Clobbers: $t0, $v0, $ra
	#
	# Locals:   $t0 = sum of base and maximum, $v0 = decoded value or original value if out of range
	#   - Checks if the input is within the range [base, base + maximum). If valid, it returns the decoded coordinate.
	#
	# Structure:
	#   decode_coordinate
	#   -> [prologue]    (save return address and previous value)
	#     -> body        (perform range check and return decoded value)
	#   -> [epilogue]    (restore return address and return decoded value)
        
decode_coordinate__prologue:
 	addi    $sp, $sp, -8        # Allocate space on the stack for return address and $a3
   	sw      $ra, 4($sp)         # Save return address onto the stack
   	sw      $a3, 0($sp)         # Save $a3 onto the stack

decode_coordinate__body:
	# Calculate base + maximum to check the upper bound
	addu	$t0, $a1, $a2        

decode_coordinate__body_if_input_gte_base_and_input_ls_baseaddmaximum_cond:
	# Check if input is in the range [base, base + maximum)
	blt	$a0, $a1, decode_coordinate__body_if_input_gte_base_and_input_ls_baseaddmaximum_cond_else  # If input < base, go to else
	bge	$a0, $t0, decode_coordinate__body_if_input_gte_base_and_input_ls_baseaddmaximum_cond_else  # If input >= base + maximum, go to else

decode_coordinate__body_if_input_gte_base_and_input_ls_baseaddmaximum_body:
	subu    $v0, $a0, $a1        # $v0 = input - base (decoded value)
    	j       decode_coordinate__epilogue  # Jump to epilogue

decode_coordinate__body_if_input_gte_base_and_input_ls_baseaddmaximum_cond_else:
	lw      $v0, 0($sp)          # Load the previous value from the stack

decode_coordinate__epilogue:
	lw      $ra, 4($sp)          # Restore return address from the stack
    	addi    $sp, $sp, 8         # Deallocate stack space
	jr      $ra               


################################################################################
# .TEXT <read_solution>
        .text
read_solution:
	# Subset:   2
	#
	# Frame:    Reads the solution coordinates from the user input and updates the solution grid.
	#           Then it calculates the clues based on the solution and stores the displayed clues.
	# Uses:     $s0, $s1, $s2, $s3
	#           $s4, $s5, $s6, $v0 
	# Clobbers: $a0, $a1, $ra
	#
	# Locals:   $s0 = total solutions marked, $s1 = row input, $s2 = column input, 
	#           $s3 = height, $s4 = width, $s5 = calculated index in solution array, $s6 = MARKED
	# 
	# Structure:
	#   read_solution
	#   -> [prologue]    (save registers and set up the stack frame)
	#     -> body        (loop to read solution coordinates, update the grid, and compute clues)
	#   -> [epilogue]    (restore registers and return)

read_solution__prologue:
	addi    $sp, $sp, -32         # Allocate space on the stack for saved registers
	sw      $ra, 28($sp)          # Save return address
	sw      $s0, 24($sp)          # Save register $s0
	sw      $s1, 20($sp)          
	sw      $s2, 16($sp)         
	sw      $s3, 12($sp)          
	sw      $s4, 8($sp)         
	sw      $s5, 4($sp)           
	sw      $s6, 0($sp)          

read_solution__body:
	# Prompt the user to enter the solution
	li      $v0, 4                
	la      $a0, str__read_solution__enter_solution  
	syscall

	# Initialize the total number of solutions marked
	li      $s0, 0               

read_solution__while_cond:
	li      $v0, 5               
	syscall
	move    $s1, $v0             

	li      $v0, 5               
	syscall
	move    $s2, $v0             

read_solution__while_if_cond:
	blt     $s1, $zero, read_solution__while_end  # If row input < 0, exit loop
	blt     $s2, $zero, read_solution__while_end  # If column input < 0, exit loop

	# Get the valid row index (row % height)
	lw      $s3, height           # Load the height
	rem     $s3, $s1, $s3         # $s3 = row % height (to handle out-of-bound rows)

	# Get the valid column index (column % width)
	lw      $s4, width            # Load the width
	rem     $s4, $s2, $s4         # $s4 = column % width (to handle out-of-bound columns)

	# Calculate the index in the solution array
	mul     $s5, $s3, MAX_WIDTH   # $s5 = row * MAX_WIDTH
	add     $s5, $s5, $s4         # $s5 = row * MAX_WIDTH + column (index in solution array)

	# Mark the solution as MARKED
	li      $s6, MARKED           # Load MARKED constant
	sb      $s6, solution($s5)    # solution[row][column] = MARKED

	# Increment the total number of solutions marked
	addi    $s0, $s0, 1         

	# Repeat the loop for the next input
	b       read_solution__while_cond  

read_solution__while_end:
	# Compute clues based on the solution array
	la      $a0, solution         # Load address of the solution array
	la      $a1, solution_clues   # Load address of the solution_clues
	jal     compute_all_clues     # Call compute_all_clues function

	# Set displayed_clues to solution_clues
	la      $a1, solution_clues   # Load address of solution_clues
	sw      $a1, displayed_clues  # displayed_clues = solution_clues

	li      $v0, 4              
	la      $a0, str__read_solution__loaded  
	syscall

	li      $v0, 1              
	move    $a0, $s0              # Print total number of marked solutions
	syscall

	li      $v0, 4                
	la      $a0, str__read_solution__solution_coordinates  
	syscall

read_solution__epilogue:
	# Restore saved registers and return
	lw      $s6, 0($sp)          
	lw      $s5, 4($sp)         
	lw      $s4, 8($sp)          
	lw      $s3, 12($sp)         
	lw      $s2, 16($sp)         
	lw      $s1, 20($sp)        
	lw      $s0, 24($sp)         
	lw      $ra, 28($sp)          
	addi    $sp, $sp, 32          # Adjust stack pointer
	jr      $ra                           



################################################################################
# .TEXT <lookup_clue>
        .text
lookup_clue:
	# Subset:   2
	#
	# Frame:    This function looks up a clue based on a given offset and conditions.
	#           It checks whether the value is odd or even, and returns a specific character based on the lookup result.
	# Uses:     $s0, $s1, $t0, $t1-$t6
	# Clobbers: $v0, $t0-$t6, $ra
	#
	# Locals:   $s0 = base address for clue lookup, $s1 = calculated offset, $t0 = provided offset
	# 
	# Structure:
	#   lookup_clue
	#   -> [prologue]    (save registers and set up the stack frame)
	#     -> body        (perform calculations and lookup clue based on conditions)
	#   -> [epilogue]    (restore registers and return the result)

lookup_clue__prologue:
	addi    $sp, $sp, -12         # Allocate stack space for saving $ra, $s0, and $s1
	sw      $ra, 8($sp)         
	sw      $s0, 4($sp)          
	sw      $s1, 0($sp)           

	move    $s0, $a0              # $s0 = base address of clue set
	move    $s1, $a1              # $s1 = offset
	move    $t0, $a2              # $t0 = modification offset

lookup_clue__body:
	# Adjust offset and perform division
	addi    $t1, $t0, 1           # $t1 = modification offset + 1
	div     $s1, $t1              # $s1 / ($t0 + 1)
	mflo    $t2                   # $t2 = result of the division

	# Check if the modification offset is non-zero
	bnez    $t0, lookup_clue__check_offset_mod  # If $t0 != 0, check mod condition
	j       lookup_clue__check_clue_zero        # jump to check clue

lookup_clue__check_offset_mod:
	# Check if $s1 % 2 == 1 (odd)
	rem     $t3, $s1, 2           # $t3 = $s1 % 2
	bne     $t3, 1, lookup_clue__check_clue_zero  # If $s1 % 2 != 1, jump to check clue zero

	# If the condition is true, return a space character
	li      $v0, 32           
	j       lookup_clue__epilogue  # Jump to epilogue

lookup_clue__check_clue_zero:
	# Calculate the clue based on the base address and offset
	sll     $t4, $t2, 2           # $t4 = $t2 * 4 (multiply by 4 to get the byte offset)
	add     $t4, $s0, $t4         
	lw      $t5, 0($t4)           # Load the value at that address into $t5
	bnez    $t5, lookup_clue__return_char  # If the clue is non-zero, return the corresponding character

	# If the clue is zero, return a space character
	li      $v0, 32               # $v0 = ' ' (ASCII space)
	j       lookup_clue__epilogue  # Jump to epilogue to return the result

lookup_clue__return_char:
	li      $t6, 48              
	add     $v0, $t6, $t5         # $v0 = '0' + clue (convert the clue to its ASCII representation)

lookup_clue__epilogue:
	# Restore saved registers and return
	lw      $ra, 8($sp)       
	lw      $s0, 4($sp)          
	lw      $s1, 0($sp)          
	addi    $sp, $sp, 12          
	jr      $ra                   



################################################################################
# .TEXT <compute_all_clues>
        .text
compute_all_clues:
	# Subset:   2
	#
	# Frame:    Computes all vertical and horizontal clues for the current game state.
	#           This function loops through each column and row in the grid and calls `compute_clue`
	#           for each one to calculate clues for the solution grid.
	# Uses:     $s0, $s1, $s2, $s3, $s4,
	#           $s5, $s6, $a0, $a1, $a2, $a3
	# Clobbers: $v0, $t0-$t4, $ra
	#
	# Locals:   $s0 = solution grid, $s1 = clue set, $s2 = column index, $s5 = row index
	#           $s4 = offset used to store clues in the clue set, $s3 = width, $s6 = height
	# 
	# Structure:
	#   compute_all_clues
	#   -> [prologue]    (save registers and set up the stack frame)
	#     -> body        (loops over each row and column to compute clues)
	#   -> [epilogue]    (restore registers and return)

compute_all_clues__prologue:
        addi    $sp, $sp, -32      
	sw      $ra, 28($sp)         
	sw      $s0, 24($sp)         
	sw      $s1, 20($sp)         
	sw      $s2, 16($sp)         
	sw      $s3, 12($sp)         
	sw      $s4, 8($sp)          
	sw      $s5, 4($sp)          
	sw      $s6, 0($sp)          
	
	move    $s0, $a0            
	move    $s1, $a1            
compute_all_clues__body:

compute_all_clues__body_forloop_col_less_width_init:
	li      $s2, 0              

compute_all_clues__body_forloop_col_less_width_cond:
	lw      $s3, width          # Load the width (number of columns)
	bge     $s2, $s3, compute_all_clues__body_forloop_row_less_height_init  # If column index >= width, go to row loop

compute_all_clues__body_forloop_col_less_width_body:
	# Call compute_clue for each column (vertical clues)
	move    $a0, $s2            
	li      $a1, TRUE           
	move    $a2, $s0            

	# Calculate the offset for storing the clue in the vertical clues section
	mul     $s4, $s2, MAX_HEIGHT  # $s4 = column index * MAX_HEIGHT
	mul     $s4, $s4, 4          
	add     $s4, $s4, $s1        
	add     $s4, $s4, CLUE_SET_VERTICAL_CLUES_OFFSET  
	move    $a3, $s4             
	jal     compute_clue         
compute_all_clues__body_forloop_col_less_width_step:
	addi    $s2, $s2, 1         # Increment column index
	b       compute_all_clues__body_forloop_col_less_width_cond  

compute_all_clues__body_forloop_row_less_height_init:
	li      $s5, 0              

compute_all_clues__body_forloop_row_less_height_cond:
	lw      $s6, height         # Load the height (number of rows)
	bge     $s5, $s6, compute_all_clues__epilogue  # If row index >= height, go to epilogue

compute_all_clues__body_forloop_row_less_height_body:
	# Call compute_clue for each row (horizontal clues)
	move    $a0, $s5            
	li      $a1, FALSE          
	move    $a2, $s0            

	# Calculate the offset for storing the clue in the horizontal clues section
	mul     $s4, $s5, MAX_WIDTH  # $s4 = row index * MAX_WIDTH
	mul     $s4, $s4, 4          
	add     $s4, $s4, $s1        
	add     $s4, $s4, CLUE_SET_HORIZONTAL_CLUES_OFFSET  
	move    $a3, $s4             # $a3 = final offset address
	jal     compute_clue        

compute_all_clues__body_forloop_row_less_height_step:
	addi    $s5, $s5, 1         # Increment row index
	b       compute_all_clues__body_forloop_row_less_height_cond 

compute_all_clues__epilogue:
	# Restore saved registers and return
	lw      $ra, 28($sp)        
	lw      $s0, 24($sp)        
	lw      $s1, 20($sp)      
	lw      $s2, 16($sp)        
	lw      $s3, 12($sp)        
	lw      $s4, 8($sp)         
	lw      $s5, 4($sp)        
	lw      $s6, 0($sp)        
	
	addi    $sp, $sp, 32       
	jr      $ra                
 


################################################################################
# .TEXT <make_move>
        .text
make_move:
	# Subset:   3
	# 
	# Frame:    Implements the functionality for making a move in the game.
	#           Prompts the user for coordinates and then allows them to mark, cross out, or unmark a cell.
	# Uses:     $a0, $a1, $v0, $s0, $s1, $s2, $t0, $t1, $t2, $t3
	# Clobbers: $t0-$t4, $v0, $a0, $a1
	#
	# Locals:   $s0 = row, $s1 = col, $s2 = new cell value
	#
	# Structure:
	#   make_move
	#   -> [prologue]    (save registers and set up)
	#     -> body        (get coordinates and update the selected grid)
	#   -> [epilogue]    (restore registers and return)

make_move__prologue:
        addi    $sp, $sp, -16       # Allocate stack for registers
        sw      $ra, 12($sp)     
        sw      $s0, 8($sp)        
        sw      $s1, 4($sp)       
        sw      $s2, 0($sp)       


make_move__input_first_coord:
        li      $v0, 4              
        la      $a0, str__make_move__enter_first_coord
        syscall

        li      $v0, 12            
        syscall
        move    $t0, $v0          

make_move__input_second_coord:
        # Prompt for the second coordinate
        li      $v0, 4             
        la      $a0, str__make_move__enter_second_coord  
        syscall

        # Read second coordinate (char)
        li      $v0, 12             
        syscall
        move    $t1, $v0            

make_move__init_invalid_coords:
        # Initialize row and col to -1 (invalid values)
        li      $s0, -1         
        li      $s1, -1             

make_move__decode_col_first_letter:
        # Decode coordinates for columns (upper-case letters 'A'-'Z')
        move    $a0, $t0           
        li      $a1, 'A'           
        lw      $a2, width         
        move    $a3, $s1            
        jal     decode_coordinate  
        move    $s1, $v0            

make_move__decode_col_second_letter:
        move    $a0, $t1          
        li      $a1, 'A'          
        lw      $a2, width          
        move    $a3, $s1            
        jal     decode_coordinate  
        move    $s1, $v0           

make_move__decode_row_first_letter:
        # Decode coordinates for rows (lower-case letters 'a'-'z')
        move    $a0, $t0          
        li      $a1, 'a'          
        lw      $a2, height       
        move    $a3, $s0            
        jal     decode_coordinate   
        move    $s0, $v0           

make_move__decode_row_second_letter:
        move    $a0, $t1         
        li      $a1, 'a'          
        lw      $a2, height         
        move    $a3, $s0            
        jal     decode_coordinate   
        move    $s0, $v0           

make_move__check_invalid_coords:
        # If row or col is still -1, it's an invalid input
        li      $t2, -1
        beq     $s0, $t2, make_move__retry  # If row == -1, retry
        beq     $s1, $t2, make_move__retry  # If col == -1, retry

make_move__ask_for_action:
        # Ask user for action to take on the cell
        li      $s2, 0             
make_move__ask_for_choice:
        li      $v0, 4              
        la      $a0, str__make_move__enter_choice  
        syscall

        # Read user choice (char)
        li      $v0, 12             
        syscall
        move    $t3, $v0            

make_move__check_choice_marked:
        # Check if the user's choice is '#'
        li      $t4, '#'           
        beq     $t3, $t4, make_move__mark_cell

make_move__check_choice_crossed_out:
        # Check if the user's choice is 'x'
        li      $t4, 'x'            
        beq     $t3, $t4, make_move__cross_out

make_move__check_choice_unmarked:
        # Check if the user's choice is '.'
        li      $t4, '.'            
        beq     $t3, $t4, make_move__deselect

make_move__invalid_choice:
        # Invalid input, print error and ask again
        li      $v0, 4           
        la      $a0, str__make_move__bad_input  
        syscall
        b       make_move__ask_for_choice


make_move__mark_cell:
        li      $s2, MARKED         
        b       make_move__update_cell

make_move__cross_out:
        li      $s2, CROSSED_OUT    
        b       make_move__update_cell

make_move__deselect:
        li      $s2, UNMARKED      

make_move__update_cell:
        # Update the selected grid with the new value
        mul     $t4, $s0, MAX_WIDTH 
        add     $t4, $t4, $s1      
        sb      $s2, selected($t4)  
        b       make_move__epilogue  

make_move__retry:
        # Invalid input, retry the move
        li      $v0, 4              
        la      $a0, str__make_move__bad_input  
        syscall
        jal     make_move  

make_move__epilogue:
        lw      $ra, 12($sp)        
        lw      $s0, 8($sp)         
        lw      $s1, 4($sp)         
        lw      $s2, 0($sp)         
        addi    $sp, $sp, 16       
        jr      $ra                



################################################################################
# .TEXT <print_game>
        .text
print_game:
        # Subset:   3
        # 

print_game__prologue:
        addi    $sp, $sp, -16       
        sw      $ra, 12($sp)        
        sw      $s0, 8($sp)        
        sw      $s1, 4($sp)       
        sw      $s2, 0($sp)        

        lw      $t0, displayed_clues  
        la      $t1, selection_clues  
        bne     $t0, $t1, print_game__skip_message  

        li      $v0, 4             
        la      $a0, str__print_game__printing_selection  
        syscall

print_game__skip_message:
        lw      $t0, height      
        addi    $t0, $t0, 1         
        srl     $s0, $t0, 1          

        lw      $s1, width         
        addi    $s1, $s1, 1

        li      $s2, 0               

print_game__body_forloop_vertical_gutter_cond:
        bge     $s2, $s0, print_game__print_top_coordinates 

        li      $t2, 0               
print_game__body_forloop_gutter_col_cond:
        bgt     $t2, $s1, print_game__body_forloop_print_clues  
        li      $v0, 11              
        li      $a0, ' '
        syscall

        addi    $t2, $t2, 1        
        b       print_game__body_forloop_gutter_col_cond

print_game__body_forloop_print_clues:
        li      $t3, 0              
print_game__body_forloop_col_cond:
        lw      $t4, width           
        bge     $t3, $t4, print_game__end_vertical_gutter  

        move    $a0, $t3           
        move    $a1, $s2            
        li      $a2, 0              
        lw      $a3, displayed_clues 
        jal     lookup_clue          

        move    $a0, $v0            
        li      $v0, 11              
        syscall

        addi    $t3, $t3, 1         
        b       print_game__body_forloop_col_cond

print_game__end_vertical_gutter:
        li      $v0, 11              
        li      $a0, '\n'
        syscall

        addi    $s2, $s2, 1          
        b       print_game__body_forloop_vertical_gutter_cond

print_game__print_top_coordinates:
        li      $t3, 0  

print_game__body_forloop_top_coord_cond:
        add     $t4, $s1, $s0        
        bge     $t3, $t4, print_game__print_grid_rows  

        ble     $t3, $s1, print_game__print_space_or_letter  
        addi    $t5, $t3, -1
        sub     $t5, $t5, $s1        
        addi    $t5, $t5, 'A'        
        move    $a0, $t5
        li      $v0, 11              
        syscall
        b       print_game__next_top_coord

print_game__print_space_or_letter:
        li      $v0, 11              
        li      $a0, ' '
        syscall

print_game__next_top_coord:
        addi    $t3, $t3, 1          
        b       print_game__body_forloop_top_coord_cond

print_game__print_grid_rows:
        li      $s2, 0             
print_game__body_forloop_rows_cond:
        lw      $t3, height          
        bge     $s2, $t3, print_game__epilogue 

        li      $t2, 0              
print_game__body_forloop_row_gutter_cond:
        bge     $t2, $s1, print_game__print_row_coord  
        move    $a0, $s2             
        move    $a1, $t2             
        li      $a2, 1               
        lw      $a3, displayed_clues 
        jal     lookup_clue          

        move    $a0, $v0            
        li      $v0, 11             
        syscall

        addi    $t2, $t2, 1          
        b       print_game__body_forloop_row_gutter_cond

print_game__print_row_coord:
        addi    $t5, $s2, 'a'       
        move    $a0, $t5
        li      $v0, 11             
        syscall

        
        li      $t3, 0             
print_game__body_forloop_grid_cond:
        lw      $t4, width           
        bge     $t3, $t4, print_game__next_row 

        
        mul     $t5, $s2, MAX_WIDTH  
        add     $t5, $t5, $t3        
        lb      $t6, selected($t5)   

        
        li      $t7, UNMARKED        
        beq     $t6, $t7, print_game__unmarked
        li      $t7, CROSSED_OUT     
        beq     $t6, $t7, print_game__crossed_out
        li      $t7, MARKED        
        beq     $t6, $t7, print_game__marked

        li      $a0, '?'             
        li      $v0, 11
        syscall
        b       print_game__grid_next_col

print_game__unmarked:
        li      $a0, '.'            
        li      $v0, 11
        syscall
        b       print_game__grid_next_col

print_game__crossed_out:
        li      $a0, 'x'            
        li      $v0, 11
        syscall
        b       print_game__grid_next_col

print_game__marked:
        li      $a0, '#'             
        li      $v0, 11
        syscall

print_game__grid_next_col:
        addi    $t3, $t3, 1          
        b       print_game__body_forloop_grid_cond

print_game__next_row:
        li      $v0, 11            
        li      $a0, '\n'
        syscall

        addi    $s2, $s2, 1         
        b       print_game__body_forloop_rows_cond

print_game__epilogue:
        lw      $ra, 12($sp)    
        lw      $s0, 8($sp)        
        lw      $s1, 4($sp)       
        lw      $s2, 0($sp)      
        addi    $sp, $sp, 16         
        jr      $ra                 



################################################################################
# .TEXT <compute_clue>
        .text
compute_clue:
        # Subset:   3
        #
        # Frame:    [...]   <-- FILL THESE OUT!
        # Uses:     [...]
        # Clobbers: [...]
        #
        # Locals:           <-- FILL THIS OUT!
        #   - ...
        #
        # Structure:        <-- FILL THIS OUT!
        #   compute_clue
        #   -> [prologue]
        #     -> body
        #   -> [epilogue]

    addi    $sp, $sp, -40          
    sw      $ra, 36($sp)          
    sw      $fp, 32($sp)           
    move    $fp, $sp               
    sw      $a0, 24($sp)           
    sw      $a1, 28($sp)           

    li      $t0, 0                 
    li      $t1, 0                
    li      $t2, 0                
    li      $t3, 0                 
    li      $s0, 0                
    li      $s1, 0                 #

    lw      $t4, 28($sp)           
    beqz    $t4, horizontal_case   

    lw      $t1, 24($sp)           
    li      $t3, 1                
    lw      $t5, MAX_HEIGHT      
    move    $s0, $t5
    lw      $t5, height            
    sra     $s1, $t5, 1            
    j       clue_index_init       

horizontal_case:
    lw      $t0, 24($sp)     
    li      $t2, 1                
    lw      $t5, MAX_WIDTH       
    move    $s0, $t5
    lw      $t5, width             
    addi    $t5, $t5, 1
    sra     $s1, $t5, 1           

clue_index_init:
    li      $s2, 0               

loop_start:
    lw      $t5, height            
    bge     $t0, $t5, end_loop
    lw      $t5, width            
    bge     $t1, $t5, end_loop

   
    mul     $t6, $t0, MAX_WIDTH   
    add     $t6, $t6, $t1     
    add     $t6, $a2, $t6   
    lb      $t7, ($t6)         
    li      $t8, MARKED           
    bne     $t7, $t8, not_marked   

    addi    $s3, $s3, 1        

    j       update_position        

not_marked:
    beqz    $s3, update_position   
    mul     $t9, $s2, 4           
    add     $t9, $a3, $t9        
    sw      $s3, 0($t9)          
    addi    $s2, $s2, 1          
    li      $s3, 0               

update_position:
    add     $t0, $t0, $t3        
    add     $t1, $t1, $t2      
    j       loop_start             

end_loop:
    beqz    $s3, fill_clues       
    
    mul     $t9, $s2, 4         
    add     $t9, $a3, $t9        
    sw      $s3, 0($t9)           

fill_clues:
    li      $t9, 0
    fill_zero_loop:
    bge     $s2, $s0, finalize
    mul     $t6, $s2, 4
    add     $t6, $a3, $t6
    sw      $t9, 0($t6)
    addi    $s2, $s2, 1
    j       fill_zero_loop

finalize:

    move    $sp, $fp            
    lw      $ra, 36($sp)          
    lw      $fp, 32($sp)          
    addi    $sp, $sp, 40       
    jr      $ra                    


################################################################################
# .TEXT <is_game_over>
        .text
is_game_over:
	# Subset:   3
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   is_game_over
	#   -> [prologue]
	#     -> body
	#   -> [epilogue]

is_game_over__prologue:
	addi    $sp, $sp, -16     
	sw      $ra, 12($sp)         
	sw      $s0, 8($sp)         
	sw      $s1, 4($sp)         
	sw      $s2, 0($sp)         

is_game_over__body:
	li      $v0, 1           
	li      $s0, 0            
	li      $s1, 0             

# Vertical clues loop (for row)
is_game_over__vertical_loop_initial:
	li      $s1, 0             

is_game_over__vertical_loop_condition:
	lw      $t0, width           
	bge     $s1, $t0, is_game_over__horizontal_loop_initial  
is_game_over__vertical_loop_body:
	# Calculate index for vertical clues (row * MAX_WIDTH + col)
	mul     $t1, $s0, MAX_WIDTH  
	add     $t2, $t1, $s1       

	lb      $s2, selection_clues($t2) 
	lb      $t3, solution_clues($t2)  

is_game_over__vertical_if_condition:
	bne     $s2, $t3, is_game_over__return_false  

is_game_over__vertical_if_end:


is_game_over__vertical_loop_step:
	addi    $s1, $s1, 1         

	b       is_game_over__vertical_loop_condition  

is_game_over__vertical_loop_end:

is_game_over__horizontal_loop_initial:
	addi    $s0, $s0, 1      
	li      $s1, 0            

	lw      $t0, height      
	bge     $s0, $t0, is_game_over__return_true  

is_game_over__horizontal_loop_condition:
	lw      $t0, width         
	bge     $s1, $t0, is_game_over__horizontal_loop_step 

# Horizontal clues body
is_game_over__horizontal_loop_body:
	# Calculate index for horizontal clues (row * MAX_WIDTH + col)
	mul     $t1, $s0, MAX_WIDTH  
	add     $t2, $t1, $s1       

	lb      $s2, selection_clues($t2)  
	lb      $t3, solution_clues($t2) 

is_game_over__horizontal_if_condition:
	bne     $s2, $t3, is_game_over__return_false  # If mismatch, return FALSE

is_game_over__horizontal_if_end:

is_game_over__horizontal_loop_step:
	addi    $s1, $s1, 1        
	b       is_game_over__horizontal_loop_condition  
is_game_over__horizontal_loop_end:

is_game_over__return_false:
	li      $v0, 0             
	b       is_game_over__epilogue  # Jump to epilogue

is_game_over__return_true:
	li      $v0, 1              # Set return value to TRUE

is_game_over__epilogue:
	lw      $ra, 12($sp)         
	lw      $s0, 8($sp)         
	lw      $s1, 4($sp)          
	lw      $s2, 0($sp)        
	addi    $sp, $sp, 16         
	jr      $ra               

################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <get_command>
        .text
get_command:
	# Provided
	#
	# Frame:    [$ra]
	# Uses:     [$a0, $v0, $t0, $t1]
	# Clobbers: [$a0, $v0, $t0, $t1]
	#
	# Locals:
	#   - $t0: command
	#   - $t1: &selection_clues or &solution_clues
	#
	# Structure:
	# Structure:
	#   dump_game_state
	#   -> [prologue]
	#   -> body
	#     -> command_m
	#     -> command_q
	#     -> command_d
	#     -> command_s
	#     -> command_S
	#     -> command_query
	#     -> bad_command
	#   -> [epilogue]

get_command__prologue:
	begin
	push	$ra

get_command__body:
	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__get_command__prompt
	syscall						# printf(" >> ");

	li	$v0, 12					# syscall 12: read_char
	syscall
	move	$t0, $v0				# scanf(" %c", &command);

	beq	$t0, 'm', get_command__command_m	# if (command == 'm') { ...
	beq	$t0, 'q', get_command__command_q	# } else if (command == 'q') { ...
	beq	$t0, 'd', get_command__command_d	# } else if (command == 'd') { ...
	beq	$t0, 's', get_command__command_s	# } else if (command == 's') { ...
	beq	$t0, 'S', get_command__command_S	# } else if (command == 'S') { ...
	beq	$t0, '?', get_command__command_query	# } else if (command == '?') { ...
	b	get_command__bad_command		# } else { ... }

get_command__command_m:					# if (command == 'm') {
	jal	make_move				#   make_move();
	b	get_command__epilgoue			# }

get_command__command_q:					# else if (command == 'q') {
	li	$v0, 10					#   syscall 10: exit
	syscall						#   exit(0);
	b	get_command__epilgoue			# }

get_command__command_d:					# if (command == 'd') {
	jal	dump_game_state				#   dump_game_state();
	b	get_command__epilgoue			# }

get_command__command_s:					# else if (command == 's') {
	la	$t1, selection_clues			#   &selection_clues
	sw	$t1, displayed_clues			#   displayed_clues = &selection_clues;
	b	get_command__epilgoue			# }

get_command__command_S:					# else if (command == 'S') {
	la	$t1, solution_clues			#   &solution_clues
	sw	$t1, displayed_clues			#   displayed_clues = &solution_clues;
	b	get_command__epilgoue			# }

get_command__command_query:				# else if (command == '?') {
	la	$a0, solution				#   solution
	jal	print_game				#   print_game(solution);
	b	get_command__epilgoue			# }

get_command__bad_command:				# else {
	li	$v0, 4					#   syscall 4: print_string
	la	$a0, str__get_command__bad_command	#   printf("Bad command");
	syscall

get_command__epilgoue:					# }
	pop	$ra
	end
	jr	$ra					# return;


################################################################################
# .TEXT <dump_game_state>
        .text
dump_game_state:
	# Provided
	#
	# Frame:    []
	# Uses:     [$a0, $v0, $t0, $t1, $t2, $t3]
	# Clobbers: [$a0, $v0, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0: row
	#   - $t1: col
	#   - $t2: copy of width/height/displayed_clues
	#   - $t3: temporary address calculations
	#
	# Structure:
	#   dump_game_state
	#   -> [prologue]
	#   -> body
	#     -> loop_selected_row__init
	#     -> loop_selected_row__cond
	#     -> loop_selected_row__body
	#       -> loop_selected_col__init
	#       -> loop_selected_col__cond
	#       -> loop_selected_col__body
	#       -> loop_selected_col__step
	#       -> loop_selected_col__end
	#     -> loop_selected_row__step
	#     -> loop_selected_row__end
	#     -> loop_solution_row__init
	#     -> loop_solution_row__cond
	#     -> loop_solution_row__body
	#       -> loop_solution_col__init
	#       -> loop_solution_col__cond
	#       -> loop_solution_col__body
	#       -> loop_solution_col__step
	#       -> loop_solution_col__end
	#     -> loop_solution_row__step
	#     -> loop_solution_row__end
	#     -> loop_clues_vert_row__init
	#     -> loop_clues_vert_row__cond
	#     -> loop_clues_vert_row__body
	#       -> loop_clues_vert_col__init
	#       -> loop_clues_vert_col__cond
	#       -> loop_clues_vert_col__body
	#       -> loop_clues_vert_col__step
	#       -> loop_clues_vert_col__end
	#     -> loop_clues_vert_row__step
	#     -> loop_clues_vert_row__end
	#     -> loop_clues_horiz_row__init
	#     -> loop_clues_horiz_row__cond
	#     -> loop_clues_horiz_row__body
	#       -> loop_clues_horiz_col__init
	#       -> loop_clues_horiz_col__cond
	#       -> loop_clues_horiz_col__body
	#       -> loop_clues_horiz_col__step
	#       -> loop_clues_horiz_col__end
	#     -> loop_clues_horiz_row__step
	#     -> loop_clues_horiz_row__end
	#   -> [epilogue]


dump_game_state__prologue:
	begin

dump_game_state__body:
	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__width
	syscall						# printf("width = ");

	li	$v0, 1					# syscall 1: print_int
	lw	$a0, width				# width
	syscall						# printf("%d", width);

	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__height
	syscall						# printf("height = ");

	li	$v0, 1					# syscall 1: print_int
	lw	$a0, height				# height
	syscall						# printf("%d", height);

	li	$v0, 11					# syscall 11: print_char
	li	$a0, '\n'
	syscall						# printf("%c", '\n');

	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__selected
	syscall						# printf("selected:\n");

dump_game_state__loop_selected_row__init:
	li	$t0, 0					# int row = 0;

dump_game_state__loop_selected_row__cond:		# while (row < height) {
	lw	$t2, height
	bge	$t0, $t2, dump_game_state__loop_selected_row__end

dump_game_state__loop_selected_row__body:
dump_game_state__loop_selected_col__init:
	li	$t1, 0					#   int col = 0;

dump_game_state__loop_selected_col__cond:		#   while (col < width) {
	lw	$t2, width
	bge	$t1, $t2, dump_game_state__loop_selected_col__end

dump_game_state__loop_selected_col__body:
	mul	$t3, $t0, MAX_WIDTH			#     row * MAX_WIDTH
	add	$t3, $t3, $t1				#     row * MAX_WIDTH + col
	add	$t3, $t3, selected			#     selected + row * MAX_WIDTH + col
							#      == &selected[row][col]

	li	$v0, 1					#     syscall 1: print_int
	lb	$a0, ($t3)				#     selected[row][col]
	syscall						#     printf("%d", selected[row][col]);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, ' '
	syscall						#     printf("%c", ' ');

dump_game_state__loop_selected_col__step:
	addi	$t1, $t1, 1				#     col++;
	b	dump_game_state__loop_selected_col__cond

dump_game_state__loop_selected_col__end:		#   }

	li	$v0, 11					#   syscall 11: print_char
	li	$a0, '\n'
	syscall						#   printf("%c", '\n');

dump_game_state__loop_selected_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	dump_game_state__loop_selected_row__cond

dump_game_state__loop_selected_row__end:		# }


	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__solution
	syscall						# printf("solution:\n");

dump_game_state__loop_solution_row__init:
	li	$t0, 0					# int row = 0;

dump_game_state__loop_solution_row__cond:		# while (row < height) {
	lw	$t2, height
	bge	$t0, $t2, dump_game_state__loop_solution_row__end

dump_game_state__loop_solution_row__body:
dump_game_state__loop_solution_col__init:
	li	$t1, 0					#   int col = 0;

dump_game_state__loop_solution_col__cond:		#   while (col < width) {
	lw	$t2, width
	bge	$t1, $t2, dump_game_state__loop_solution_col__end

dump_game_state__loop_solution_col__body:
	mul	$t3, $t0, MAX_WIDTH			#     row * MAX_WIDTH
	add	$t3, $t3, $t1				#     row * MAX_WIDTH + col
	add	$t3, $t3, solution			#     solution + row * MAX_WIDTH + col
							#      == &solution[row][col]

	li	$v0, 1					#     syscall 1: print_int
	lb	$a0, ($t3)				#     solution[row][col]
	syscall						#     printf("%d", solution[row][col]);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, ' '
	syscall						#     printf("%c", ' ');

dump_game_state__loop_solution_col__step:
	addi	$t1, $t1, 1				#     col++;
	b	dump_game_state__loop_solution_col__cond

dump_game_state__loop_solution_col__end:		#   }

	li	$v0, 11					#   syscall 11: print_char
	li	$a0, '\n'
	syscall						#   printf("%c", '\n');

dump_game_state__loop_solution_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	dump_game_state__loop_solution_row__cond

dump_game_state__loop_solution_row__end:		# }

	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__clues_vertical
	syscall						# printf("displayed_clues vertical:\n");

dump_game_state__loop_clues_vert_row__init:
	li	$t0, 0					# int row = 0;

dump_game_state__loop_clues_vert_row__cond:		# while (row < MAX_HEIGHT) {
	bge	$t0, MAX_HEIGHT, dump_game_state__loop_clues_vert_row__end

dump_game_state__loop_clues_vert_row__body:
dump_game_state__loop_clues_vert_col__init:
	li	$t1, 0					#   int col = 0;

dump_game_state__loop_clues_vert_col__cond:		#   while (col < MAX_WIDTH) {
	bge	$t1, MAX_WIDTH, dump_game_state__loop_clues_vert_col__end

dump_game_state__loop_clues_vert_col__body:
	mul	$t3, $t1, MAX_HEIGHT			#     col * MAX_HEIGHT
	add	$t3, $t3, $t0				#     col * MAX_HEIGHT + row
	mul	$t3, $t3, SIZEOF_INT			#     4 * (col * MAX_HEIGHT + row)
	lw	$t2, displayed_clues			#     displayed_clues
	add	$t3, $t3, $t2				#     displayed_clues + 4 * (col * MAX_HEIGHT + row)

	addi	$t3, CLUE_SET_VERTICAL_CLUES_OFFSET	#     &displayed_clues->vertical_clues[col][row]

	lw	$a0, ($t3)				#     displayed_clues->vertical_clues[col][row]
	li	$v0, 1					#     syscall 1: print_int
	syscall						#     printf("%d", displayed_clues->vertical_clues[col][row]);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, ' '
	syscall						#     printf("%c", ' ');

dump_game_state__loop_clues_vert_col__step:
	addi	$t1, $t1, 1				#     col++;
	b	dump_game_state__loop_clues_vert_col__cond

dump_game_state__loop_clues_vert_col__end:		#   }

	li	$v0, 11					#   syscall 11: print_char
	li	$a0, '\n'
	syscall						#   printf("%c", '\n');

dump_game_state__loop_clues_vert_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	dump_game_state__loop_clues_vert_row__cond

dump_game_state__loop_clues_vert_row__end:		# }

	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__clues_horizontal
	syscall						# printf("displayed_clues horizontal:\n");

dump_game_state__loop_clues_horiz_row__init:
	li	$t0, 0					# int row = 0;

dump_game_state__loop_clues_horiz_row__cond:		# while (row < MAX_HEIGHT) {
	bge	$t0, MAX_HEIGHT, dump_game_state__loop_clues_horiz_row__end

dump_game_state__loop_clues_horiz_row__body:
dump_game_state__loop_clues_horiz_col__init:
	li	$t1, 0					#   int col = 0;

dump_game_state__loop_clues_horiz_col__cond:		#   while (col < MAX_WIDTH) {
	bge	$t1, MAX_WIDTH, dump_game_state__loop_clues_horiz_col__end

dump_game_state__loop_clues_horiz_col__body:
	mul	$t3, $t0, MAX_WIDTH			#     row * MAX_WIDTH
	add	$t3, $t3, $t1				#     row * MAX_WIDTH + col
	mul	$t3, $t3, SIZEOF_INT			#     4 * (row * MAX_WIDTH + col)
	lw	$t2, displayed_clues			#     displayed_clues
	add	$t3, $t3, $t2				#     displayed_clues + 4 * (row * MAX_WIDTH + col)
	addi	$t3, CLUE_SET_HORIZONTAL_CLUES_OFFSET	#     &displayed_clues->horizontal_clues[row][col]

	lw	$a0, ($t3)				#     displayed_clues->horizontal_clues[row][col]
	li	$v0, 1					#     syscall 1: print_int
	syscall						#     printf("%d", displayed_clues->horizontal_clues[row][col]);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, ' '
	syscall						#     printf("%c", ' ');

dump_game_state__loop_clues_horiz_col__step:
	addi	$t1, $t1, 1				#     col++;
	b	dump_game_state__loop_clues_horiz_col__cond

dump_game_state__loop_clues_horiz_col__end:		#   }

	li	$v0, 11					#   syscall 11: print_char
	li	$a0, '\n'
	syscall						#   printf("%c", '\n');

dump_game_state__loop_clues_horiz_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	dump_game_state__loop_clues_horiz_row__cond

dump_game_state__loop_clues_horiz_row__end:		# }

dump_game_state__epilogue:
	end
	jr	$ra					# return;

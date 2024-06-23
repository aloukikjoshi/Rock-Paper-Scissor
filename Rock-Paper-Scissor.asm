.data
    rounds: .word 0           # Number of rounds
    newLine: .asciiz "\n"
    userChoice: .asciiz "Enter your choice (1: Rock, 2: Paper, 3: Scissors): "
    computerChoice: .asciiz "Computer chose: "
    winMessage: .asciiz "You win this round!\n\n"
    loseMessage: .asciiz "You lose this round!\n\n"
    drawMessage: .asciiz "This round is a draw!\n\n"
    inputPrompt: .asciiz "Enter the number of rounds: "
    resultMessage: .asciiz "Final Result - You: "
    computerMessage: .asciiz " Computer: "
    drawFinalMessage: .asciiz " Draws: "

    userWins: .word 0
    computerWins: .word 0
    draws: .word 0
    
    one: .word 1
    two: .word 2
    three: .word 3

.text
main:
    # Prompt for the number of rounds
    li $v0, 4
    la $a0, inputPrompt
    syscall

    # Read number of rounds
    li $v0, 5
    syscall
    sw $v0, rounds
    
    li $v0, 4
    la $a0, newLine
    syscall

    # Seed the random number generator
    li $v0, 30        # get time in milliseconds (as a 64-bit value)
    syscall
    move $t0, $a0

    li $a0, 1        # random generator id (will be used later)
    move $a1, $t0    # seed from time
    li $v0, 40       # seed random number generator syscall
    syscall
    
    lw $s0, one
    lw $s1, two
    lw $s2, three

game_loop:
    lw $t0, rounds         # Load number of rounds
    beqz $t0, game_end     # If rounds == 0, end game

    # Decrement round count
    sub $t0, $t0, 1
    sw $t0, rounds

    # Get user choice
    li $v0, 4
    la $a0, userChoice
    syscall

    li $v0, 5
    syscall
    move $t1, $v0          # Store user choice

    # Generate computer choice (1 to 3)
    li $a0, 1              # random generator id
    li $a1, 3              # upper bound of the range
    li $v0, 42             # random int range syscall
    syscall
    addi $t2, $a0, 1       # Random number between 1 and 3

    # Display computer choice
    li $v0, 4
    la $a0, computerChoice
    syscall

    li $v0, 1
    move $a0, $t2          # Print computer choice
    syscall
    li $v0, 11
    li $a0, 10             # Print new line
    syscall

    # Determine winner
    beq $t1, $t2, draw
    beq $t1, $s0, conditionRock
    beq $t1, $s1, conditionPaper
    beq $t1, $s2, conditionScissor
    
conditionRock:
    beq $t2, $s1, computer_wins
    beq $t2, $s2, user_wins
    j game_loop

conditionPaper:
    beq $t2, $s2, computer_wins
    beq $t2, $s0, user_wins
    j game_loop
    
conditionScissor:
    beq $t2, $s0, computer_wins
    beq $t2, $s1, user_wins
    j game_loop

user_wins:
    # Increment user wins
    lw $t5, userWins
    add $t5, $t5, 1
    sw $t5, userWins

    # Display win message
    li $v0, 4
    la $a0, winMessage
    syscall
    j game_loop

computer_wins:
    # Increment computer wins
    lw $t5, computerWins
    add $t5, $t5, 1
    sw $t5, computerWins

    # Display lose message
    li $v0, 4
    la $a0, loseMessage
    syscall
    j game_loop

draw:
    # Increment draws
    lw $t5, draws
    add $t5, $t5, 1
    sw $t5, draws

    # Display draw message
    li $v0, 4
    la $a0, drawMessage
    syscall
    j game_loop

game_end:
    # Display final results
    li $v0, 4
    la $a0, resultMessage
    syscall

    lw $a0, userWins
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, computerMessage
    syscall

    lw $a0, computerWins
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, drawFinalMessage
    syscall

    lw $a0, draws
    li $v0, 1
    syscall

    li $v0, 10          # Exit
    syscall

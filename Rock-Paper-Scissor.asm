.data
    rounds: .word 0
    userChoice: .asciiz "Enter your choice (1: Rock, 2: Paper, 3: Scissors): "
    computerChoice: .asciiz "Computer chose: "
    winMessage: .asciiz "You win this round!\n"
    loseMessage: .asciiz "You lose this round!\n"
    drawMessage: .asciiz "This round is a draw!\n"
    inputPrompt: .asciiz "Enter the number of rounds: "
    resultMessage: .asciiz "Final Result - You: "
    computerMessage: .asciiz " Computer: "
    drawFinalMessage: .asciiz " Draws: "

    userWins: .word 0
    computerWins: .word 0
    draws: .word 0

.text
main:
    li $v0, 4
    la $a0, inputPrompt
    syscall

    li $v0, 5
    syscall
    sw $v0, rounds

game_loop:
    lw $t0, rounds
    beqz $t0, game_end

    sub $t0, $t0, 1
    sw $t0, rounds

    li $v0, 4
    la $a0, userChoice
    syscall

    li $v0, 5
    syscall
    move $t1, $v0

    li $v0, 42
    li $a1, 3
    syscall
    add $t2, $v0, 1

    li $v0, 4
    la $a0, computerChoice
    syscall

    move $a0, $t2
    li $v0, 1
    syscall
    li $v0, 11
    li $a0, 10
    syscall

    beq $t1, $t2, draw

    li $t3, 1
    li $t4, 3
    beq $t1, $t3
    beq $t2, $t4
    user_wins

    li $t3, 2
    li $t4, 1
    beq $t1, $t3
    beq $t2, $t4
    user_wins

    li $t3, 3
    li $t4, 2
    beq $t1, $t3
    beq $t2, $t4
    user_wins

computer_wins:
    lw $t5, computerWins
    add $t5, $t5, 1
    sw $t5, computerWins

    li $v0, 4
    la $a0, loseMessage
    syscall
    j game_loop

user_wins:
    lw $t5, userWins
    add $t5, $t5, 1
    sw $t5, userWins

    li $v0, 4
    la $a0, winMessage
    syscall
    j game_loop

draw:
    lw $t5, draws
    add $t5, $t5, 1
    sw $t5, draws

    li $v0, 4
    la $a0, drawMessage
    syscall
    j game_loop

game_end:
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

    li $v0, 10
    syscall

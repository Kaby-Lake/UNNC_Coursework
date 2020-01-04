    // Implement arithmetics z = x / y
    // where x,y,z are integers
    // Input x, y, z stored in RAM[0] RAM[1] and RAM[2]
    // z round off

    // @sign is intentionally used to store output sign
    // xBackup and yBackup is used to restore original x and y at the end

    // Apply the idea of repetitive addition, y + y + y + .. + y <= x


    @R2
    M=0         // reset RAM[2] to blank space
    @R3
    M=1         // reset RAM[3] to default 1

    @R1
    D=M
    @yBackup
    M=D         // stores the original y value
    @R0
    D=M
    @xBackup
    M=D         // stores the original x value

    @R1
    D=M
    @Zeroy
    D;JEQ       // if y == 0, then goto "Zeroy"

    @R0
    D=M
    @ySign
    D;JGT       // if x > 0, then goto "ySign" to determine the sign of y
    @R0
    M=-D        // if x < 0, x = absolute value of x

    @R1
    D=M
    @DiffSign
    D;JGT       // When x < 0 and y > 0, apply the absolute value of x, then goto (DiffSign)

    @R1
    M=-D        // if y < 0, y = absolute value of y
    @SameSign
    D;JMP       // When x and y are all negative, apply their absolute value, then goto (SameSign)

(ySign)
    @R1
    D=M
    @SameSign
    D;JGT       // When x > 0 and y > 0, goto (SameSign)

    @R1
    M=-D        // if y < 0, y = absolute value of y
    @DiffSign
    D;JMP       // When x > 0 and y < 0, apply the absolute value of y, then goto (DiffSign)


(SameSign)
    @sign
    M=0         // when x and y are the same sign, set @sign = 0, this is used later to determine the sign of output
    @R0
    D=M
    @R1
    D=D-M       // D = x - y
    @RoundOff4SameSign
    D;JLT       // When x - y < 0, break the loop and goto (RoundOff4SameSign)
    @R0
    M=D         // else, x = x - y
    @R2
    M=M+1       // add counting number by 1
    @SameSign
    0;JMP

// the method to solve SameSign round off is that: 
// judge whether x > y/2, this equals to judge whether 2x > y
(RoundOff4SameSign)
    @R0
    D=M
    @R0
    M=M+D       // x = 2 * x
    @R0
    D=M
    @R1
    D=D-M       // D = 2x - y
    @RoundDown
    D;JLT       // When x < y/2, goto (RoundDown)
    @RoundUp
    0;JMP       // else goto (RoundUp)


(DiffSign)
    @sign
    M=1         // when x and y are the different sign, set @sign = 1
    @R0
    D=M
    @R1
    D=D-M       // D = x - y
    @RoundOff4DiffSign
    D;JLT       // When x - y < 0, break the loop and goto (RoundOff4DiffSign)
    @R0
    M=D         // else, x = x - y
    @R2
    M=M+1       // add counting number by 1
    @DiffSign
    0;JMP

// the method to solve DiffSign round off is that:
// judge whether y-x < y/2, this equals to judge whether 2(y - x) < y
(RoundOff4DiffSign)
    @R1
    D=M
    @R0
    M=D-M       // x = y - x
    @R0
    D=M
    @R0
    M=M+D       // x = 2(y - x)
    @R0
    D=M
    @R1
    D=D-M       // D = 2(y - x) - y
    @RoundUp
    D;JLT       // When y < 2(y - x), goto (RoundUp)
    @RoundDown
    0;JMP       // else goto (RoundDown)

(RoundUp)
    @R2
    M=M+1       // when roundup, count = count + 1
    @sign
    D=M
    @End
    D;JEQ       // if (@sign == 0), which means x and y are the same sign, goto End straight-forward
    @R2
    M=-M        // else count = - count
    @End
    0;JMP

(RoundDown)
    @sign
    D=M
    @End
    D;JEQ       // if (@sign == 0), which means x and y are the same sign, goto End straight-forward
    @R2
    M=-M        // else count = - count
    @End
    0;JMP

(Zeroy)
    @R3
    M=-1         // set RAM[3] to -1 when x == 0
    @R2
    M=-1

(End)
    @yBackup
    D=M
    @R1
    M=D         // restores the original y value to R1

    @xBackup
    D=M
    @R0
    M=D         // stores the original x value to R0

(Endloop)
    @Endloop
    0;JMP
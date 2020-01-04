    // Implement arithmetics z = log x, base 2, z round down
    // where x,z are non-negative integers
    // Input x stored in RAM[0]
    // The calculation output z will be stored in RAM[2]

    // RAM[3] and RAM[4] are intentionally used to store temp

    // Apply the idea of repetitive multiplication, z = x * x * ... * x
    // and y is the number of multiplications


    @R2         // RAM[2] is used for count
    M=0
    @cmp        // initialize compare variable
    M=1

(Loop)          // initialize Loop sign
    @cmp
    D=M
    @R0
    D=D-M       // when cmp > RAM[0], exit loop
    @Pre
    D;JGT

    @R2
    M=M+1       // RAM[2] continually added by 1 when cmp = cmp * 2(base number)
    @cmp
    D=M
    @cmp
    M=M+D       // cmp = cmp * 2(base number)
    @Loop
    0;JMP       // back to the beginning of Loop

(Pre)
    @R2
    M=M-1       // the actual z value should be (count-1)

(End)
    @End
    0;JMP
    // Implement arithmetics z = x ^ y
    // where x,y,z are non-negative integers
    // Input x, y stored in RAM[0] and RAM[1]
    // The calculation output will be stored in RAM[2]

    // multmp and countsv are intentionally used to store temp

    // Apply the idea of repetitive multiplication, z = x * x * ... * x
    // and y is the number of multiplications


    @R2
    M=0         // reset RAM[2] to blank space
    @R3
    M=1         // reset RAM[3] to 1

    @R0
    D=M
    @dupx
    M=D         // dupx is to store the duplication of x

    @R1
    D=M
    @dupy
    M=D         // dupy is to store the duplication of y

    @R0
    D=M
    @Zerox
    D;JEQ       // if x == 0, then goto "Zerox"

    @R1
    D=M
    @OnlyZeroy
    D;JEQ       // if y == 0, then goto "OnlyZeroy"

    @R0
    D=M-1
    @Onex
    D;JEQ       // if x == 1, then goto "Onex"

    @R1
    D=M-1
    @Oney
    D;JEQ       // if y == 1, then goto "Oney"

    @R1
    M=M-1       // arithmetically, the times to do mult is (power-1)
                // because don't need to mult with itself when y == 1
    @R0
    D=M
    @multmp
    M=D         // multmp is to store the last mult result
    @R2
    M=D
    @countsv
    M=D-1       // countsv is the counter saver, which equals to (RAM[0] - 1)
                // reason will be explained in the process

(LoopPow)
    @countsv
    D=M
    @R0
    M=D         // To reset RAM[0] with the value of countsv

(LoopMul)
    @multmp
    D=M
    @R2
    M=M+D       // each time add with the last mult result to realize simple mult
    @R0
    M=M-1       // RAM[0] is the mult counter, that's why the (countsv - 1) stuff
    @R0
    D=M
    @LoopMul    // Stop recursive only if mult counter progressively decrease to 0
    D;JGT       // At the end Loop for Mult, R0 is 0, R2 is result

    @R2
    D=M
    @multmp
    M=D         // multmp stores the last mult result
    @R1
    M=M-1       // and power counter progressively decrease by 1
    @R1
    D=M
    @LoopPow
    D;JGT       // Stop recursive only if pow counter progressively decrease to 0

    @dupx
    D=M
    @R0
    M=D         // restore x from dupx to RAM[0]

    @dupy
    D=M
    @R1
    M=D         // restore y from dupy to RAM[1]

    @End
    0;JMP

(Zerox)
    @R1
    D=M
    @Zeroxy
    D;JEQ       // if x == 0 and y == 0, then goto "Zeroxy"

    @R2
    M=0         // set RAM[2] to 0 when x == 0, in which case result = 0 regardless of y
    @End
    0;JMP

(Zeroxy)
    @R3
    M=-1        // set RAM[3] to -1 and RAM[2] to -1 when x == 0 and y == 0
    @R2
    M=-1
    @End
    0;JMP

(OnlyZeroy)
    @R2
    M=1         // set RAM[2] to 1 when x == 0, in which case result = 1 regardless of y
    @End
    0;JMP

(Onex)
    @R2
    M=1         // set RAM[2] to 1 when x == 1, in which case result = 1 regardless of y
    @End
    0;JMP

(Oney)
    @dupx
    D=M
    @R2
    M=D         // set RAM[2] to x when y == 1, in which case result = x
    @End
    0;JMP

(End)
    @End
    0;JMP
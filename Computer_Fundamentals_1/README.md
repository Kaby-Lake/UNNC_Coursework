# CSF Coursework 2019 Part I
	
This **`README.md`** is the introduction file of CSF 2019 Coursework Part Ⅰ
by *20126507 hnyzx3 Zichen Xu*.
	
The main chip is named **`CWALU.hdl`**, the same directory contains several sub-chips and standard build-in chips to support the ALU function.

Due to the fact that I have no idea for so many standard chips which one has been used in the `CWALU` chip, so I just simply copied all of them into the directory...
	
## Introduction to Customized Sub-Chips
	
**`Sub16.hdl`** is a customized chip that supports the **S** function, whose job is to _Subtract two 16-bit 2's compliment values_, with detection of both positive and _negative overflow_, the negative overflow is not asked in the coursework description, but I did it ^_^.
	
**`Add16OF.hdl`** is a customized chip that supports the **S** function, which is a sub function in `Sub16.hdl`, whose job is to _Add two 2's compliment 16-bit values_, with detection of both positive and _negative overflow_.
	
**`Mult16.hdl`** is a customized chip that can perform _2's compliment integer multiplication_ with multipliers between -100 and +100, which is the component of **M** function.
	
**`Mult1with16.hdl`** is a customized chip that can _Multiply 1-bit with 16-bit_, which is a sub function in `Mult16.hdl` and is the component of **M** function. To mention that, a is 16-bit and b is 1-bit.
	
**`Shamtl16.hdl`** is a customized chip that can _Shift 16-bit left by 1 bit_, which is a sub function in `Mult16.hdl` and is the component of **M** function as well.
	
**`Div16.hdl`** is a customized chip that supports the **D** function, whose job is to _Divide x by 2 with result rounded down_, with detection of both positive and _negative overflow_.
	
**`Exp16.hdl`** is a customized chip which helps the **F** function, whose job is to _Calculate Exponent x^y (x and y should be positive, x <= 9 && y <= 5)_, with detection of negative overflow.
	
**`ExpMult16.hdl`** is a customized chip that does the Mult job as well, however, specially desiged for the **F** function, whose job is to perform _Unsigned int Multiplication, a should between 0 and 8191, b should between 0 and 15_, with detection of positive overflow. To mention that, a is 16-bit and b is 4-bit.
	
**`xGtry.hdl`** is a customized chip that is to determine _whether the value of x is greater than that of y, if so, output 1, otherwise -1_, which is the objective of  **GL** function.
	
	
## Matters Need Attention
* Multitasking Not Support
	
Although that `CWALU.hdl` is a multifunction chip with several control pins, however, can only perform one function at a time. That's to say, if you turn on more than one control pins at the same time, the chip probably may return invalid values.
	
* Overflow
`CWALU.hdl` has **OF** sign to display whether output overflow or not, if so, the output value might be incorrect.
	
	
	
## Functions Might Different from Text Scrips
* The Div16 Gate can actually do the signed division, however, not rounded down in that case.
	
* The Subtract function (Sub16.hdl) can detect negative overflow, which is not asked in the coursework description, but I actually did it ^_^
	
* The Greater Than function GT do can detect internal overflow and can even auto correct that (example: 30000-(-30000)), so it won't turn on the Overflow pin because hopefully the output is correct, anyway.
	


## Comments
Every file in this folder has a universal comment style
	
The following is a standard comments to declare *Chip functions* and *Sub-Chips inside*.
	
```
// This file is part of CSF 2019 Coursework Part Ⅰ
// by 20126507 hnyzx3 Zichen Xu.
	
/**CUSTOMIZED CHIP INSIDE
* >> @@@@
*/
	
/**
* @@@@@@
* @@@@@
* @@@@
*/
	
```
	
## Copyright
Copyright (C) 2019 
`ZiChen XU``20126507``hnyzx3@nottingham.edu.cn`  
	All rights reserved

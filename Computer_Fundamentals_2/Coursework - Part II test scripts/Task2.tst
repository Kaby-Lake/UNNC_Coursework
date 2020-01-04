//load Task2.hack,
load Task2.asm,
output-file Task2.out,
compare-to Task2.cmp,
output-list RAM[0]%D2.6.2 RAM[1]%D2.6.2 RAM[2]%D2.6.2 RAM[3]%D2.6.2;

set PC 0,
set RAM[0] 2,   // Set test arguments
set RAM[1] 3,
set RAM[2] -1;  // 8
set RAM[3] -1;  // 1
repeat 200 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 3,   // Set test arguments
set RAM[1] 3,
set RAM[2] -1; // 27
set RAM[3] -1; // 1
repeat 300 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 4,   // Set test arguments
set RAM[1] 4,
set RAM[2] -1;  // 256
set RAM[3] -1;  // 1
repeat 400 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 0,   // Set test arguments
set RAM[1] 0,
set RAM[2] -1;  // -1
set RAM[3] -1;  // -1
repeat 400 {
  ticktock;
}
output;

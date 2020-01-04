//load Task1.hack,
load Task1.asm,
output-file Task1.out,
compare-to Task1.cmp,
output-list RAM[0]%D2.6.2 RAM[1]%D2.6.2 RAM[2]%D2.6.2 RAM[3]%D2.6.2;

set PC 0,
set RAM[0] 10,   // Set test arguments
set RAM[1] 3,
set RAM[2] -1;  // 3
set RAM[3] -1;  // 1
repeat 200 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 10,   // Set test arguments
set RAM[1] -3,
set RAM[2] -1;  // -3
set RAM[3] -1;  // 1
repeat 200 {
  ticktock;
}
output;

set PC 0,
set RAM[0] -13,   // Set test arguments
set RAM[1] -5,
set RAM[2] -1;  // 3
set RAM[3] -1;  // 1
repeat 200 {
  ticktock;
}
output;

set PC 0,
set RAM[0] -25,   // Set test arguments
set RAM[1] 10,
set RAM[2] -1;  // -2
set RAM[3] -1;  // 1
repeat 200 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 10,   // Set test arguments
set RAM[1] 0,
set RAM[2] -1;  // -1
set RAM[3] -1;  // -1
repeat 200 {
  ticktock;
}
output;
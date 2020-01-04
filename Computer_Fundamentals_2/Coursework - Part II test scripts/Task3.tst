//load Task3.hack,
load Task3.asm,
output-file Task3.out,
compare-to Task3.cmp,
output-list RAM[0]%D2.6.2 RAM[2]%D2.6.2;

set PC 0,
set RAM[0] 2, // Set test arguments
set RAM[2] -1;  // 1
repeat 300 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 3, // Set test arguments
set RAM[2] -1;  // 1
repeat 300 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 16, // Set test arguments
set RAM[2] -1;  // 4
repeat 500 {
  ticktock;
}
output;

set PC 0,
set RAM[0] 255, // Set test arguments
set RAM[2] -1;  // 7
repeat 3000 {
  ticktock;
}
output;

/*
Check the design intent: "y must equal the sum of a and b". Insert your assert check inside the RTL code on the Instruction tab
*/

module and2
 
(
 
input [3:0] a,b,
 
output [3:0] y
 
);
 
assign y = a && b;
 
 
 
///////////Add your code here

  always @(*)
  begin
    A1: assert final (y == a + b) $info("Assertion Passed. a = %0d, b = %0d, y = %0d", a,b,y); else $error("[Error]: Assertion Failed at time: %0d. a = %0d, b = %0d, y = %0d", $time, a,b,y);
  end

/////////End your code here
 
endmodule
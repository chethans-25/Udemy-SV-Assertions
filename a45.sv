/*
Evaluate the property on positive edge of the clock. Only Implication Operators and Boolean Operators are allowed.

Questions for this assignment
Write assertion to verify following behavior

"read and write request must not occur at same time"
*/

property p1;
  @(posedge clk) (read & write) == 0;
endproperty

label_p1: assert property(p1) $info("Assertion Passed at time: %0d", $time);
else   $error("Assertion Failed at time: %0d", $time);

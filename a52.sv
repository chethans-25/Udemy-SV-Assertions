/*
If rst assert then ce must deassert immediately. 
Verify the behavior for each new request from rst and ce. 
Evaluate the property on positive edge of the clock.

image reference is there in the instructions

*/

property p1;
  @(posedge clk) $rose(rst) |-> !(ce);
endproperty

always begin
  label_p1: assert property(p1) $info("Assertion Passed at time: %0d", $time);
  else   $error("Assertion Failed at time: %0d", $time);
end

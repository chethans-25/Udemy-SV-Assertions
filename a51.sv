/*
if signal a assert then signal b must also assert in the same clock tick.
*/


module tb;
  
  reg a = 0, clk = 0,b = 0;
  always #5 clk = ~clk;
  
  
    
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end
  
initial begin
  #20;
a = 0;
  #10;
a = 1;
b = 1;
#10;
  b = 0;
  a = 0;
 
  
end

property p1;
  @(posedge clk) $rose(a) |-> $rose(b);
endproperty

label_p1: assert property(p1) $info("Assertion Passed at time: %0d", $time);
else   $error("Assertion Failed at time: %0d", $time);
endmodule
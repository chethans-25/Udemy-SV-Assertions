/*
if signal a asserts, then signal c should assert within 1 to 5 clock cycles, followed by signal b becoming high. signal ce should remain high for entire duration of this sequence.
*/


module tb;
  reg a = 0, b = 0, c = 0,ce = 0;
  reg clk = 0;
  
  always #5 clk = ~clk;
  
  //always #2 en = ~en;
  
  initial begin
    #20;
    a = 1; 
    #10;
    a = 0;
   end
  
  initial begin
    #49;
    b = 1;
    #10;
    b = 0;
  end
  
    initial begin 
    #40;
    c = 1;
    #10;
    c = 0;
  end
  
  initial begin
    #15;
    ce = 1;
    #60;
    ce = 0;
    
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end
 
  ///add your code here
  sequence s1;
    ##[1:5] $rose(c) ##1 $rose(b);
  endsequence

  property p1;
    @(posedge clk) $rose(a) |-> s1;
  endproperty

  property p2;
    @(posedge clk) $rose(a) |-> ce throughout s1;
  endproperty


  label_p1: assert property(p1) $info("Assertion P1 Passed at time: %0d", $time);
  else   $error("Assertion P1 Failed at time: %0d", $time);

  label_p2: assert property(p2) $info("Assertion P2 Passed at time: %0d", $time);
  else   $error("Assertion P2 Failed at time: %0d", $time);

endmodule
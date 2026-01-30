/*
When b becomes high, b should remain stable for two consecutive ticks and then deassert. a should remain low throughout the sequence.
*/

module tb;
  reg a = 0, b = 0;
  reg clk = 0;
  
  always #5 clk = ~clk;
  
  //always #2 en = ~en;
  
  initial begin
    a = 0;
    #40;
    #6
    a = 1;
  end
  
  initial begin
    b = 0;
    #14;
    b = 1;
    #20;
    // #3
    b = 0;
  end
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #120;
    $finish();
  end

  sequence s1;
    b[*2] ##1 $fell(b);
  endsequence

  property p1;
    @(posedge clk) b |-> !(a) throughout s1;
  endproperty
 
  label_p1: assert final property(p1) $info("Assertion P1 Passed at time: %0d", $time);
  else   $info("Assertion P1 Failed at time: %0d", $time);
 
endmodule
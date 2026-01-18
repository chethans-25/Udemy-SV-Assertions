// if signal a assert then it should deassert in next clock tick.

module tb;
  reg a = 0;
  reg clk = 0;
  
  always #5 clk = ~clk;
 
  //always #10 a = ~a;
  //always #10 b = ~b;
 
initial begin
  #10;
  a = 1;
  #20;
  a = 0;
  #30;
  a = 1;
  #10;
  a = 0;
end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end
 
  ///add your code here

property p1;
	@(posedge clk) $rose(a) |=> $fell(a);
endproperty



label_p1: assert property(p1) $info("Assertion Passed at time: %0d", $time);
else   $error("Assertion Failed at time: %0d", $time);

                              
endmodule
/*
a and b must be equal for both clock edges (posedge as well as negedge). Only boolean operators are allowed.
*/
module tb;
  reg a = 0, b = 1;
  reg clk = 0;
  
  always #5 clk = ~clk;
  
  //always #2 en = ~en;
  
  initial begin
    a = 1;
    #7;
    a = 0;
    #30;
    a = 1; 
    #30;
    a = 1;
  end
  
    initial begin
    b = 1;
    #7;
    b = 0;
    #10;
    b = 1; 
    #30;
    b = 1;
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end
 
///Add your code here
always edge_check: assert property (@(edge clk) a==b) $info("Assertion Passed at time %0d", $time); else $error("Assertion Failed at time %0d", $time);
                              
endmodule
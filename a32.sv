/*
a and b must be equal to Zero on all the positive edge of clock. Only Boolean Operators are allowed.
*/
module tb;
  reg a = 0, b = 1;
  reg clk = 0;
  
  always #5 clk = ~clk;
  
  //always #2 en = ~en;
  
  initial begin
    a = 1;
    #10;
    a = 0;
    #10;
    a = 1; 
    #10;
    a = 0;
    #10;
    a = 1;
  end
  
  initial begin
    b = 0;
    #30;
    b = 1;
    #10;
    b = 0;
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end
 
    
///Add your code here
always posedge_check: assert property (@(posedge clk) a==0 & b==0) $info("Assertion Passed at time %0d", $time); else $error("Assertion Failed at time %0d", $time);
 
 
endmodule

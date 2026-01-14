/*
Assume we are generating random data for a block shop (RAM) and the read latency of BRAM is two clock cycles. 
Verify that the rd remains high for two clock ticks after user deassert rst.
*/

module tb;
  reg rd = 0;
  reg rst = 1;
  reg clk = 0;
  
  always #5 clk = ~clk;
  
  initial begin
    #40;
    rst = 0;
    #10;
    rd = 1;
    #20;
    rd = 0;
  end
 
 
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end
 
  

property p1;
  // rd should rise at the same instant when rst falls, and rd should remain high for next clk
	@(posedge clk) $fell(rst) && $rose(rd) |=> $stable(rd);
  // if antecedent fails, there is a chance of vacuous pass, so need to use $assertvacuousoff(0);
endproperty

                


label_p1: assert property(p1) $info("Assertion Passed at time: %0d", $time);
else   $error("Assertion Failed at time: %0d", $time);


endmodule

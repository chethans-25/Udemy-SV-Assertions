module tb;

 reg a = 0;
 reg clk = 0;
  
  initial begin
    a = 1;
    #20;
    a = 0;
  end
  
  always #5 clk =~clk;
  
 
  A1 : assert property (@(posedge clk) a) $info("---------Successfully Executed SVA code ----------");
  
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0); // Disable pass action for all vacuous successes in this hierarchy
    // 0 means "current and all sub modules"
    #120;
    $finish;
  end
  
  
endmodule
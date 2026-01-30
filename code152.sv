module tb;
  
    
  reg clk = 0, rst = 1,  ce = 0;
  always #5 clk = ~clk;
  
  
  
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end 
 
 
  
  //initial A3: assert property (@(posedge clk) eventually [2:3] !rst) $info("Suc at %0t",$time);
    
  
  initial A4: assert property (@(posedge clk) eventually [2:20] !rst) $info("Suc with eventually at %0t",$time);
  
  initial A5: assert property (@(posedge clk) s_eventually [2:20] !rst) $info("Suc with s_eventually at %0t",$time);
    
    
endmodule
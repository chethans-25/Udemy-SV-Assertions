module tb;
  
    
  reg clk = 0, rst = 1,  ce = 0;
  always #5 clk = ~clk;
  
  
  initial begin
    #20;
    rst = 1;
  #40;
    rst = 1;
    ce = 1;
    #50;
    rst = 1;
    #10;
    ce = 0;
    
    
  end
  
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #120;
    $finish();
  end 
 
 // initial A1: assert property (@(posedge clk) s_eventually always !rst ) $info("Suc at %0t",$time);
 // initial A2: assert property(@(posedge clk) s_eventually always !rst) $info("Suc at %0t",$time);
  
  //initial A3: assert property (@(posedge clk) s_eventually always ce)  $info("Suc at %0t",$time);
  
  initial A4: assert property (@(posedge clk) eventually [2:3] !rst) $info("Suc at %0t",$time);
endmodule
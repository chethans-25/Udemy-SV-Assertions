module tb;
  
  reg ce = 0;
  reg wr = 0;
  reg rd = 0;
  reg clk = 0;
  reg rst = 0;
  
    
  always #5 clk = ~clk;
  
  initial begin
    rst = 1;
    #30;
    rst = 0;
  end
 
  initial begin 
    ce = 0;
    #30;
    ce = 1;
  end
  
  initial begin
   #30;
    wr = 1;
   #10;
    rd = 1;
   #20;
    wr = 0;
    rd = 0;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0);
    #50;
    $finish;
  end
  
  
  sequence cewr (logic a, logic b);
    a && b;
  endsequence
  
  property p1;
    (@(posedge clk) $fell(rst) |-> cewr(ce,wr));
  endproperty
 
  
  
  ///////////////////////////////////////////////
  
  
  
  property p2(logic a,logic b);
    (@(posedge clk) $fell(rst) |=> (a && b));      
  endproperty
  
  ////////////////////////////////////////////////
  
  CHECK_CE_WR:assert property ( p1) $info("p1 CHECK_WR @ %0t", $time);
    
  CHECK_CE_rd:assert property (  p2(ce,rd))  $info("p2 CHECK_RD @ %0t", $time);
    
    
endmodule
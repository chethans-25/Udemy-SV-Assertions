// Code your testbench here
// or browse Examples
module tb;
  reg clk = 0,start = 0,wr = 0,rd = 0,stop = 0;
  
  always #5 clk = ~clk;
  
  initial begin
    #3;
    start = 1;
    #10;
    start = 0;
    
    
  end
  
  initial begin
    #180;
    stop = 1;
    #10;
    stop = 0;
  end
 
  
  initial begin
   #30;
    rd = 0;
   #20;
    rd = 0;
    #30;
  end
  
    initial begin
    #15;
   wr = 1;
    #10;
   wr = 0;
  end
  
  A1 : assert property (@(posedge clk) $rose(start) |-> (wr[->1] and (rd[->1] ##1 rd)) within stop[->1]) $info("Suc at %0t",$time);
    
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
    $assertvacuousoff(0);
    #200;
    $finish;
  end
 
  
    
endmodule
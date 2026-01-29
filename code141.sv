module tb;
  reg clk = 0,start,sclk = 0,en = 0;
  
  always #5 clk = ~clk;
  always #5 sclk = ~sclk;
  
  reg [3:0] dout = 0;
  
  
  initial begin
  #10;
    en = 1;
    #10;
    en = 0;
    
  end
  
    initial begin
   start = 0;
    #20;
   start = 1;
   #50;
   start = 0;
  end
  
 
  A1 : assert property (@(edge clk) ##1 start |-> start throughout ($changed(sclk))) $info("Suc at %0t",$time);  
  
  
  
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
    $assertvacuousoff(0);
    #100;
    $finish;
  end
 
  
    
endmodule
module tb;
  
  reg clk = 0, rst = 0, ce = 0;
  always #5 clk = ~clk;
  
  
  initial begin
    rst = 1;
    #30;
    rst = 1;
    #10;
    ce = 0;
    rst = 1;
    #10;
    rst = 1;
    #50;
    ce = 0;
  end
  
  
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish();
  end
  
  initial A1: assert property (@(posedge clk) rst s_until ce) $info("A1 Suc at %0t",$time);//Even though rst is 1, if ce is not found to be 1 by the end of simulation, Assertion fails due to strong nature
    initial A2: assert property (@(posedge clk) rst until ce) $info("A2 Suc at %0t",$time);//if ce is not found to be 1 by the end of simulation, assertion passes due to weak nature
   
endmodule
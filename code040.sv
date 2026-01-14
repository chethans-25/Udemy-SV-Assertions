// Asserion for only one time or for all the time?

module tb;
  
  reg clk = 0;
  
  reg temp = 0;
  reg a = 0;
  
  initial begin
    temp = 1;
    @(posedge clk);
    temp = 0;
  end
  
  always #10 clk = ~clk;
  always #40 a = ~a;
  
  
  
 A1: assert property (@(posedge clk) (a == 1'b1) ) $info("A1 Suc @ %0t", $time); else  $error("A1 fail @ %0t",$time);//all the time
  
    
 initial A2 : assert property (@(posedge clk) (a == 1'b1) ) $info("A2 Suc @ %0t", $time); else  $error("A2 Fail @ %0t",$time);// only one time
  
   
 A3: assert property (@(posedge clk) $rose(temp) |-> (a == 1'b1) ) $info("A3 Suc @ %0t", $time); else  $error("A3 Fail @ %0t",$time);  // only one time
  
     
  initial 
  begin
       repeat(10) @(posedge clk);
       $finish;
  end
  
        
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0);
    #100;
    $finish;
  end
  
  
endmodule
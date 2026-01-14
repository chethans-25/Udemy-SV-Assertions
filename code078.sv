module tb;
  reg [3:0] a = 4'b0000;
  
  reg clk = 0;
  reg en = 0;
  
 
  reg req = 0;
  reg ack = 0;
  
  initial begin  
   #10;
   req = 1;
   #30;
   req = 0;
 end
  
  
 initial begin
   ack = 0;
   #24;
   ack = 1;
   #40;
   ack = 0;
 end
  
 
  
  
  always #5 clk = ~clk;
 
  
  integer i = 0;
  
 initial begin
   #10;
    for(i = 0; i< 15; i++)
      begin
        a = 5;
        @(posedge clk);
      end
  end
  
  initial begin
    #10;
    en = 1;
    #60;
    en = 0;
 
  end
 
 
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0);
    #150;
    $finish();
  end
 
  //A1 : assert property (@(posedge clk) $rose(req) |=> $rose(ack) )$info("Suc at %0t",$time);
  
  
  //A2: assert property (@(posedge clk) $rose(en) |=> a == $past(a + 1))$info("Suc at %0t",$time);
    
    
  A3: assert property (@(posedge clk) disable iff(!en)  en |=> (a == $past(a + 1)))$info("Suc at %0t",$time);  
    
endmodule
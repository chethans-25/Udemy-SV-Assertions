module tb;
 
 reg a = 1;
 reg clk = 0;
 
 
 always #5 clk = ~clk;
 
 
 initial begin
 a = 1;
 #10;
 a = 0;
 #20;
 a = 1;
 #20;
 a = 0;
 end
 
 always@(posedge clk)
 begin
 $info("Value of a :%0b and $rose(a) : %0b", $sampled(a), $rose(a));
 end 
 
 
 initial begin
 $dumpfile("dump.vcd"); 
 $dumpvars;
 #120;
 $finish();
 end
 
 
endmodule
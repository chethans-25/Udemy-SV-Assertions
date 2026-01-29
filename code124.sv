module tb;
 reg clk = 0,a,b,start,done;
 
 always #5 clk = ~clk;
 
 initial begin
 start = 0;
 #20;
 start = 1;
 #10;
 start = 0;
 end
 
 initial begin
 done = 0;
 #60;
 done = 1;
 #10;
 done = 0;
 end
 
 
 
 
 initial begin
 a = 0;
 #30;
 a = 1;
 #20;
 a = 0;
 end
 
 initial begin
 b = 0;
 #40;
 b = 1;
 #20;
 b = 0;
 end
 
sequence sa;
 a[*2];
endsequence
 
 
sequence sb;
 b[*2];
endsequence
 
assert property (@(posedge clk) $rose(start) |=> sa and sb)$info("Suc at %0t",$time);
 
 initial begin
 #100;
 $finish;
 end
 
 
endmodule
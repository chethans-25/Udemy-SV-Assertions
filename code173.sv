module tb;
 reg clk = 0;
 reg start = 0;
 
 
 always #5 clk =~clk;
 
 default clocking 
 @(posedge clk);
 endclocking
 
 //always #20 start = ~start;
 
 initial begin
 #20;
 start = 1;
 #60;
 start = 0;
 end
 
 property p1;
 integer count = 0;
 
 // $rose(start) |-> start[*1:$] ##1 !start;
 
 $rose(start) |-> (start, count++)[*1:$] ##1 (!start, $display("Count : %0d",count)); // repetition operator should be outside the paranthesis
 
 // $rose(start) |-> (start[*1:$], count++) ##1 (!start, $display("Count : %0d",count)); //will not word
 
 endproperty
 
 
 assert property(p1)$info("Suc at %0t",$time);
 
 
 //assert property ($rose(start) |-> start[*1:14] ##1 !start) $info("Suc at %0t",$time);
 
 
 
 
 
 initial begin
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0); 
 #120;
 $finish;
 end
 
 
endmodule
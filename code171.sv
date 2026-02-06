module tb;
 reg clk = 0;
 reg start = 0;
 
 
 always #5 clk =~clk;
 
 default clocking 
 @(posedge clk);
 endclocking
 
 always #20 start = ~start;
 
 
 property p1;
 logic [1:0] count = 0 ;
 
 // $rose(start) |-> ## [1:$] $rose(start) ## [1:$] $rose(start);
 
($rose(start), count = 1) |-> ## [1:$] ($rose(start), count = count + 1) ##[1:$] ($rose(start), count++, $display("Count : %0d", count) ) ; 
 
 endproperty
 
 assert property (@(posedge clk) p1 ) $info("Suc @ %0t", $time);
 
 
 initial begin
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0); 
 #130;
 $finish;
 end
 
 
endmodule
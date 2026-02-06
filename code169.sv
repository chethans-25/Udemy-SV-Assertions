

module tb;
 reg clk = 0;
 reg start = 0;
 
 
 always #5 clk =~clk;
 
 default clocking 
 @(posedge clk);
 endclocking
 
 always #20 start = ~start;
 
 property p1;
 int count = 0;
 
 ($rose(start), count = count++, $display("Value of count: %0d",count));
 endproperty
 
 assert property (p1) $info("Suc at %0t",$time); else $info("");
 
 ////assert property ($rose(start));
 
 
 initial begin
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0); 
 #120;
 $finish;
 end
 
 
endmodule
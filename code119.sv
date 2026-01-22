module tb;
 
 reg clk = 0;
 
 reg a = 0;
 reg b = 0;
 
 
 always #5 clk = ~clk;
 
 initial begin
 #15;
 a = 1;
 #10;
 a = 0;
 
 end
 
 initial begin
 #20;
 b = 1;
 repeat(3) @(posedge clk); 
 b = 0; 
 
 #50;
 b = 1;
 #10;
 b = 0;
 end
 
 
 A1: assert property (@(posedge clk) $rose(a) |-> b[=3] ##1 b ) $info("Non-con Suc @ %0t",$time);
 else $info("Non-Con Fail @ %0t",$time);
 A2: assert property (@(posedge clk) $rose(a) |-> b[->3] ##1 b ) $info("GOTO Suc @ %0t",$time);
 else $info("GOTO Fail @ %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
 #150;
 $finish();
 end
 
endmodule
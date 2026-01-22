module tb;
 
 reg clk = 0;
 
 reg a = 0;
 reg b = 0;
 reg c = 0;
 
 
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
 repeat(2) @(posedge clk); 
 b = 0; 
 end
 
 initial begin
 #94;
 c = 1;
 #10;
 c = 0;
 
 end
 
 A1: assert property (@(posedge clk) $rose(a) |-> strong( b[=3:5] ) ) $info("Non-con Suc @ %0t",$time);
 A2: assert property (@(posedge clk) $rose(a) |-> strong( b[->3:5]) ) $info("GOTO Suc @ %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0);
 #200;
 $finish();
 end
 
endmodule
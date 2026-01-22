/// if a asserts, b should become high for 3 clock ticks somewhere during simulation
 
module tb;
 
 reg clk = 0;
 
 reg a = 0;
 reg b = 0;
 reg c = 0;
 
 reg temp = 0;
 
 
 always #5 clk = ~clk;
 
 initial begin
 #15;
 a = 1;
 #10;
 a = 0;
 
 end
 
 initial begin
 temp = 1;
 #185;
 temp = 0;
 end
 
 initial begin
 #20;
 b = 1;
 repeat(3) @(posedge clk); 
 b = 0; 
 end
 
 initial begin
 #94;
 c = 1;
 #10;
 c = 0;
 
 end
 
 // A1: assert property (@(posedge clk) $rose(a) |-> b[=3] ) $info("Non-con Suc @ %0t",$time);
 // A2: assert property (@(posedge clk) $rose(a) |-> b[->3] ) $info("GOTO Suc @ %0t",$time);
 
 
 A3: assert property (@(posedge clk) $rose(a) |-> temp throughout b[=3] ) $info("Non-con Suc @ %0t",$time);
 A4: assert property (@(posedge clk) $rose(a) |-> temp throughout b[->3] ) $info("GOTO Suc @ %0t",$time);
 
 
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0);
 #200;
 $finish();
 end
 
endmodule
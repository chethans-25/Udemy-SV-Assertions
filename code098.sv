// Constant delay example

module tb;
 
 reg clk = 0;
 
 reg req = 0;
 reg ack = 0;
 
 always #5 clk = ~clk;
 
 initial begin
 repeat(3) 
 begin
 #1;
 req = 1;
 #5;
 req = 0;
 repeat(3) @(negedge clk);
 end
 end
 
 initial begin
 for(int i = 0; i < 2; i++) begin
 repeat(3) @(posedge clk);
 ack = $urandom_range(0,1);
 @(posedge clk);
 ack = 0;
 end
 end
 
 
 A1: assert property (@(posedge clk) $rose(req) |=> ##2 $rose(ack)) $info("Suc @ %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0);
 #100;
 $finish();
 end
 
endmodule
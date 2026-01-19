// Unbounded delay and strong keyword

module tb;
 
 reg clk = 0;
 
 reg req = 0;
 reg ack = 0;
 
 always #5 clk = ~clk;
 
 initial begin
 #2;
 req = 1;
 #5;
 req = 0;
 end
 
 initial begin
 #120;
 ack = 0;
 #10;
 ack = 0;
 
 end
 
 
 A1: assert property (@(posedge clk) $rose(req) |-> strong(##[1:$] $rose(ack)) ) $info("Suc @ %0t",$time);
 
 initial begin 
 $dumpfile("dump.vcd");
 $dumpvars;
 $assertvacuousoff(0);
 #140;
 $finish();
 end
 
endmodule
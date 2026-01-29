module tb;
 reg a = 0, b = 0, c = 0; //Data Signal
 reg clk = 0; // Clock
 
 
 always #5 clk = ~clk; ///Generation of 10 ns Clock
 
 
 initial begin
 #28;
 b = 1;
 #30;
 b= 0; 
 end
 
 
 initial begin
 #63;
 c = 1;
 #10;
 c= 0; 
 end
 
 
 initial begin
 #28;
 a = 1;
 #40;
 a = 0; 
 end
 
 /////////reference sequence
 
 sequence seq_bc;
 b[*3] ##1 c;
 endsequence
 
 
 sequence seq_a;
 a[*4];
 endsequence
 
 A1: assert property (@(posedge clk) $rose(b) |-> seq_a within seq_bc) $info("Suc @ %0t", $time);
 
 
 
 
 
 initial begin
 $assertvacuousoff(0);
 $dumpfile("dump.vcd");
 $dumpvars;
 #150;
 $finish;
 end
 
 
endmodule
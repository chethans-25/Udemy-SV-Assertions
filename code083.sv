module tb;
 reg [3:0] a = 4'b0000;
 reg clk = 0;
 
 always #5 clk = ~clk;
 
 
 /////////////onehot and onehot0
 initial begin
 for(int i = 0; i< 20 ; i++) begin
 a = $urandom_range(0,4);
 $display("a:%0b $onehot:%0d and $onehot0:%0d @ %0t",a,$onehot(a),$onehot0(a),$time);
 $display("-----------------------------");
 @(negedge clk);
 end
 end
 
 
 
 
 initial begin
 $dumpfile("dump.vcd"); 
 $dumpvars;
 #120;
 $finish();
 end
 
 
endmodule